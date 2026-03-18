/// Multi-parameter real-time bio tracking during workouts.
///
/// During sets: HR monitoring.
/// During rest: HRV/SpO2 cycling.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ring_constants.dart';
import 'ring_lock_manager.dart';
import 'ring_protocol.dart';
import 'ring_service.dart';
import 'signal_processor.dart';

// ═══════════════════════════════════════════════════════════════════
// DATA CLASSES
// ═══════════════════════════════════════════════════════════════════

/// Bio stats captured during a single exercise set.
class SetBioStats {
  final double avgHr;
  final int maxHr;
  final int? spo2;
  final double? rmssd;
  final double? stressIndex;

  /// Difference between peak HR during set and resting HR at set start.
  final int hrRecoveryBpm;
  final double? skinTemp;

  const SetBioStats({
    required this.avgHr,
    required this.maxHr,
    this.spo2,
    this.rmssd,
    this.stressIndex,
    required this.hrRecoveryBpm,
    this.skinTemp,
  });

  factory SetBioStats.fromReadings({
    required List<int> hrReadings,
    int? spo2,
    double? rmssd,
    double? stressIndex,
    required int restingHr,
    required int peakHr,
    double? skinTemp,
  }) {
    final avgHr = hrReadings.isEmpty
        ? 0.0
        : hrReadings.reduce((a, b) => a + b) / hrReadings.length;
    final maxHr = hrReadings.isEmpty
        ? 0
        : hrReadings.reduce((a, b) => a > b ? a : b);
    return SetBioStats(
      avgHr: avgHr,
      maxHr: maxHr,
      spo2: spo2,
      rmssd: rmssd,
      stressIndex: stressIndex,
      hrRecoveryBpm: peakHr - restingHr,
      skinTemp: skinTemp,
    );
  }
}

/// Aggregated bio stats for an entire workout session.
class SessionBioStats {
  final double avgHr;
  final int maxHr;
  final double? avgSpo2;
  final double? avgRmssd;
  final double? tempBaseline;
  final double? tempEnd;
  final double? tempDelta;

  const SessionBioStats({
    required this.avgHr,
    required this.maxHr,
    this.avgSpo2,
    this.avgRmssd,
    this.tempBaseline,
    this.tempEnd,
    this.tempDelta,
  });

  factory SessionBioStats.fromSets(List<SetBioStats> sets) {
    if (sets.isEmpty) {
      return const SessionBioStats(avgHr: 0, maxHr: 0);
    }

    final avgHr =
        sets.map((s) => s.avgHr).reduce((a, b) => a + b) / sets.length;
    final maxHr =
        sets.map((s) => s.maxHr).reduce((a, b) => a > b ? a : b);

    final spo2Values =
        sets.where((s) => s.spo2 != null).map((s) => s.spo2!).toList();
    final avgSpo2 = spo2Values.isEmpty
        ? null
        : spo2Values.reduce((a, b) => a + b) / spo2Values.length;

    final rmssdValues =
        sets.where((s) => s.rmssd != null).map((s) => s.rmssd!).toList();
    final avgRmssd = rmssdValues.isEmpty
        ? null
        : rmssdValues.reduce((a, b) => a + b) / rmssdValues.length;

    final temps = sets
        .where((s) => s.skinTemp != null)
        .map((s) => s.skinTemp!)
        .toList();
    final tempBaseline = temps.isNotEmpty ? temps.first : null;
    final tempEnd = temps.length > 1 ? temps.last : null;
    final tempDelta =
        tempBaseline != null && tempEnd != null ? tempEnd - tempBaseline : null;

    return SessionBioStats(
      avgHr: avgHr,
      maxHr: maxHr,
      avgSpo2: avgSpo2,
      avgRmssd: avgRmssd,
      tempBaseline: tempBaseline,
      tempEnd: tempEnd,
      tempDelta: tempDelta,
    );
  }

  /// Serialize for DB storage.
  Map<String, dynamic> toJson() => {
        'avgHr': avgHr,
        'maxHr': maxHr,
        if (avgSpo2 != null) 'avgSpo2': avgSpo2,
        if (avgRmssd != null) 'avgRmssd': avgRmssd,
        if (tempBaseline != null) 'tempBaseline': tempBaseline,
        if (tempEnd != null) 'tempEnd': tempEnd,
        if (tempDelta != null) 'tempDelta': tempDelta,
      };
}

// ═══════════════════════════════════════════════════════════════════
// TRACKER
// ═══════════════════════════════════════════════════════════════════

/// Coordinates real-time biometric data collection during a workout session.
///
/// Lifecycle:
/// 1. Call [start] before the first set.
/// 2. Call [onSetStart] / [onSetEnd] to bracket each set.
/// 3. Call [onRestStart] / [onRestEnd] to bracket rest periods (enables SpO2).
/// 4. Call [stop] at session end — returns [SessionBioStats].
class WorkoutBioTracker {
  final RingService _ring;
  final RingLockManager _lock;
  final SignalProcessor _processor;

  final List<int> _setHrReadings = [];
  final List<int> _restIbiReadings = [];
  final List<SetBioStats> _allSets = [];
  int? _lastSpo2;
  double? _lastRmssd;
  double? _lastStressIndex;
  double? _lastTemp;
  int _peakHr = 0;
  bool _inRest = false;
  StreamSubscription<RealTimeReading>? _sub;

  /// Current HR for UI display.
  final ValueNotifier<int?> currentHr = ValueNotifier(null);

  /// Current SpO2.
  final ValueNotifier<int?> currentSpo2 = ValueNotifier(null);

  /// Current RMSSD.
  final ValueNotifier<double?> currentRmssd = ValueNotifier(null);

  /// Current stress index.
  final ValueNotifier<double?> currentStressIndex = ValueNotifier(null);

  /// Whether bio tracking is active.
  final ValueNotifier<bool> isActive = ValueNotifier(false);

  WorkoutBioTracker({
    required RingService ring,
    required RingLockManager lock,
    required SignalProcessor processor,
  })  : _ring = ring,
        _lock = lock,
        _processor = processor;

  /// Start bio tracking for a workout session.
  ///
  /// Returns false if the ring is not ready, battery too low, or lock unavailable.
  /// Battery < 5%: skip bio tracking entirely.
  /// Battery < 15%: use firmware HR only (no raw PPG).
  Future<bool> start() async {
    if (_ring.connectionState.value != RingConnectionState.ready) return false;

    final battery = _ring.batteryLevel.value;
    if (battery != null && battery < 5) {
      debugPrint('WorkoutBioTracker: battery $battery% < 5%, skipping bio');
      return false;
    }

    if (!_lock.acquire('workout_bio')) return false;

    _sub = _ring.realTimeReadings.listen(_onReading);
    await _ring.startRealTimeHr();
    isActive.value = true;
    return true;
  }

  /// Call when a new set begins — clears HR accumulation buffer.
  void onSetStart() {
    _setHrReadings.clear();
    _peakHr = 0;
  }

  /// Call when set ends — captures and returns stats for this set.
  ///
  /// Returns null if no HR readings were collected during the set.
  SetBioStats? onSetEnd() {
    if (_setHrReadings.isEmpty) return null;
    final restingHr = currentHr.value ?? _setHrReadings.last;
    final stats = SetBioStats.fromReadings(
      hrReadings: List.from(_setHrReadings),
      spo2: _lastSpo2,
      rmssd: _lastRmssd,
      stressIndex: _lastStressIndex,
      restingHr: restingHr,
      peakHr: _peakHr,
      skinTemp: _lastTemp,
    );
    _allSets.add(stats);
    return stats;
  }

  /// Call when rest starts — enables SpO2 + HRV streaming, clears IBI buffer.
  Future<void> onRestStart() async {
    _inRest = true;
    _restIbiReadings.clear();
    try {
      await _ring.startRealTimeSpO2();
    } catch (e) {
      debugPrint('WorkoutBioTracker: SpO2 not available: $e');
    }
    try {
      await _ring.startRealTimeHrv();
    } catch (e) {
      debugPrint('WorkoutBioTracker: HRV not available: $e');
    }
  }

  /// Call when rest ends — computes RMSSD/SI from accumulated IBI, stops HRV/SpO2.
  Future<void> onRestEnd() async {
    _inRest = false;
    // Compute HRV metrics from IBI accumulated during rest
    if (_restIbiReadings.length >= 5) {
      _lastRmssd = _processor.computeRmssd(_restIbiReadings);
      _lastStressIndex = _processor.computeStressIndex(_restIbiReadings);
      currentRmssd.value = _lastRmssd;
      currentStressIndex.value = _lastStressIndex;
    }
    try {
      await _ring.stopRealTimeHrv();
    } catch (e) {
      debugPrint('WorkoutBioTracker: error stopping HRV: $e');
    }
    try {
      await _ring.stopRealTimeSpO2();
    } catch (e) {
      debugPrint('WorkoutBioTracker: error stopping SpO2: $e');
    }
  }

  /// Stop tracking and return aggregated session stats.
  Future<SessionBioStats> stop() async {
    await _sub?.cancel();
    _sub = null;
    try {
      await _ring.stopRealTimeHr();
    } catch (_) {}
    try {
      await _ring.stopRealTimeSpO2();
    } catch (_) {}
    try {
      await _ring.stopRealTimeHrv();
    } catch (_) {}
    _lock.release('workout_bio');
    isActive.value = false;

    return SessionBioStats.fromSets(_allSets);
  }

  /// Dispose ValueNotifiers. Call when the tracker is permanently discarded.
  void dispose() {
    currentHr.dispose();
    currentSpo2.dispose();
    currentRmssd.dispose();
    currentStressIndex.dispose();
    isActive.dispose();
  }

  // ── Private ────────────────────────────────────────────────────

  void _onReading(RealTimeReading reading) {
    if (reading.isError) return;

    if (reading.type == RealTimeReadingType.heartRate) {
      final hr = reading.value;
      if (_processor.isValidHr(hr)) {
        currentHr.value = hr;
        _setHrReadings.add(hr);
        if (hr > _peakHr) _peakHr = hr;
      }
    } else if (reading.type == RealTimeReadingType.spo2) {
      final spo2 = reading.value;
      if (_processor.isValidSpO2(spo2)) {
        currentSpo2.value = spo2;
        _lastSpo2 = spo2;
      }
    } else if (reading.type == RealTimeReadingType.hrv) {
      // IBI value in ms — accumulate during rest for RMSSD/SI computation.
      if (_inRest && reading.value > 300 && reading.value < 2000) {
        _restIbiReadings.add(reading.value);
        // Live update RMSSD if enough samples
        if (_restIbiReadings.length >= 5) {
          currentRmssd.value = _processor.computeRmssd(_restIbiReadings);
        }
      }
    }
  }
}
