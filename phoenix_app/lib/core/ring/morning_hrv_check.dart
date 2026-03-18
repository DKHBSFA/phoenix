/// Automatic + manual morning HRV measurement.
///
/// Auto: 60s real-time HRV after sleep sync.
/// Manual: UI-triggered 60s countdown.
library;

import 'dart:async';
import 'dart:math' as math;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/database.dart';
import '../database/daos/hrv_dao.dart';
import 'ring_lock_manager.dart';
import 'ring_service.dart';
import 'signal_processor.dart';
import 'ring_constants.dart';

class MorningHrvCheck {
  final RingService _ring;
  final RingLockManager _lock;
  final HrvDao _hrvDao;
  final SignalProcessor _processor;

  /// True if auto-attempt failed and manual measurement is available.
  final ValueNotifier<bool> hrvPending = ValueNotifier(false);

  /// Progress during measurement (0.0 to 1.0).
  final ValueNotifier<double> progress = ValueNotifier(0.0);

  /// Latest RMSSD during measurement (null = not measuring or no reading yet).
  final ValueNotifier<double?> currentRmssd = ValueNotifier(null);

  MorningHrvCheck({
    required RingService ring,
    required RingLockManager lock,
    required HrvDao hrvDao,
    required SignalProcessor processor,
  })  : _ring = ring,
        _lock = lock,
        _hrvDao = hrvDao,
        _processor = processor;

  /// Auto-attempt after sleep sync. Silent failure → sets hrvPending.
  Future<void> autoAttempt() async {
    final hour = DateTime.now().hour;
    if (hour < 6 || hour >= 12) return;

    final today = await _hrvDao.getTodayReading();
    if (today != null) return;

    if (_ring.capabilities?.supportsHrv != true) {
      hrvPending.value = true;
      return;
    }

    if (_ring.connectionState.value != RingConnectionState.ready) {
      hrvPending.value = true;
      return;
    }

    if (!_lock.acquire('hrv_morning')) {
      hrvPending.value = true;
      return;
    }

    try {
      final result = await _measure(const Duration(seconds: 60));
      if (result != null) {
        hrvPending.value = false;
      } else {
        hrvPending.value = true;
      }
    } catch (_) {
      hrvPending.value = true;
    } finally {
      _lock.release('hrv_morning');
    }
  }

  /// Manual measurement triggered by user. Returns RMSSD or null.
  Future<double?> manualMeasure() async {
    if (!_lock.acquire('hrv_morning')) return null;

    try {
      final result = await _measure(const Duration(seconds: 60));
      if (result != null) {
        hrvPending.value = false;
      }
      return result;
    } catch (_) {
      return null;
    } finally {
      _lock.release('hrv_morning');
    }
  }

  Future<double?> _measure(Duration duration) async {
    final ibiReadings = <int>[];
    StreamSubscription? sub;

    progress.value = 0.0;
    currentRmssd.value = null;

    try {
      await _ring.startRealTimeHrv();

      final startTime = DateTime.now();

      sub = _ring.realTimeReadings.listen((reading) {
        if (reading.type == RealTimeReadingType.hrv && !reading.isError) {
          ibiReadings.add(reading.value);

          final elapsed = DateTime.now().difference(startTime);
          progress.value =
              (elapsed.inSeconds / duration.inSeconds).clamp(0.0, 1.0);

          if (ibiReadings.length >= 5) {
            currentRmssd.value = _processor.computeRmssd(ibiReadings);
          }
        }
      });

      await Future.delayed(duration);
    } finally {
      sub?.cancel();
      await _ring.stopRealTimeHrv();
      progress.value = 1.0;
    }

    if (ibiReadings.length < 10) return null;

    final rmssd = _processor.computeRmssd(ibiReadings);
    final lnRmssd = rmssd > 0 ? math.log(rmssd) : 0.0;
    final si = _processor.computeStressIndex(ibiReadings);

    await _hrvDao.addReading(HrvReadingsCompanion(
      timestamp: Value(DateTime.now()),
      rmssd: Value(rmssd),
      lnRmssd: Value(lnRmssd),
      stressIndex: Value(si),
      source: const Value('colmi_r10'),
      context: const Value('morning'),
    ));

    currentRmssd.value = rmssd;
    return rmssd;
  }
}
