import 'dart:async';

import 'package:just_audio/just_audio.dart';

/// Breathing phase names for callbacks.
enum TempoPhase { eccentric, pause, concentric }

class AudioEngine {
  final AudioPlayer _metronomePlayer = AudioPlayer();
  final AudioPlayer _beepPlayer = AudioPlayer();
  Timer? _metronomeTimer;
  bool _isMetronomeRunning = false;

  bool get isMetronomeRunning => _isMetronomeRunning;

  Future<void> init() async {
    // Pre-load audio assets
    await _beepPlayer.setAsset('assets/sounds/beep.wav');
  }

  /// Start metronome for tempo control during exercise execution.
  /// [eccentricSeconds] and [concentricSeconds] define the rep tempo.
  /// [onPhaseChange] fires when transitioning between eccentric/pause/concentric.
  /// [onCycleComplete] fires when one full rep cycle finishes.
  void startMetronome({
    required int eccentricSeconds,
    int pauseSeconds = 1,
    required int concentricSeconds,
    void Function(TempoPhase phase)? onPhaseChange,
    void Function()? onCycleComplete,
  }) {
    stopMetronome();
    _isMetronomeRunning = true;

    final totalCycleMs =
        (eccentricSeconds + pauseSeconds + concentricSeconds) * 1000;
    int elapsed = 0;

    // Fire initial phase immediately
    onPhaseChange?.call(TempoPhase.eccentric);

    _metronomeTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        elapsed += 100;
        final posInCycle = elapsed % totalCycleMs;
        final eccentricMs = eccentricSeconds * 1000;
        final pauseMs = eccentricMs + pauseSeconds * 1000;

        // Beep at phase transitions
        if (posInCycle == 0) {
          _playTick(); // Start eccentric
          onPhaseChange?.call(TempoPhase.eccentric);
          // A full cycle just completed (except the very first tick)
          if (elapsed >= totalCycleMs) {
            onCycleComplete?.call();
          }
        } else if (posInCycle == eccentricMs) {
          _playTick(); // Start pause
          onPhaseChange?.call(TempoPhase.pause);
        } else if (posInCycle == pauseMs) {
          _playTick(); // Start concentric
          onPhaseChange?.call(TempoPhase.concentric);
        }
      },
    );
  }

  void stopMetronome() {
    _metronomeTimer?.cancel();
    _metronomeTimer = null;
    _isMetronomeRunning = false;
  }

  Future<void> playRestStart() async {
    await _beepPlayer.seek(Duration.zero);
    await _beepPlayer.play();
  }

  Future<void> playRestEnd() async {
    // Double beep for rest end
    await _beepPlayer.seek(Duration.zero);
    await _beepPlayer.play();
    await Future.delayed(const Duration(milliseconds: 200));
    await _beepPlayer.seek(Duration.zero);
    await _beepPlayer.play();
  }

  Future<void> playSessionComplete() async {
    // Triple beep for session end
    for (int i = 0; i < 3; i++) {
      await _beepPlayer.seek(Duration.zero);
      await _beepPlayer.play();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _playTick() async {
    try {
      await _metronomePlayer.seek(Duration.zero);
      await _metronomePlayer.play();
    } catch (_) {
      // Silently ignore audio errors during metronome
    }
  }

  void dispose() {
    stopMetronome();
    _metronomePlayer.dispose();
    _beepPlayer.dispose();
  }
}
