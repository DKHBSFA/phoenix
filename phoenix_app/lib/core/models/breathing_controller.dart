/// Breathing cue controller for guided meditation.
///
/// Supports presets: Box Breathing (4-4-4-4), Relaxation (4-0-6-0),
/// and custom phase durations.
enum BreathingPhase { inhale, holdIn, exhale, holdOut }

enum BreathingPreset {
  boxBreathing,
  relaxation,
  custom,
}

class BreathingConfig {
  final int inhaleSeconds;
  final int holdInSeconds;
  final int exhaleSeconds;
  final int holdOutSeconds;

  const BreathingConfig({
    required this.inhaleSeconds,
    required this.holdInSeconds,
    required this.exhaleSeconds,
    required this.holdOutSeconds,
  });

  static const box = BreathingConfig(
    inhaleSeconds: 4,
    holdInSeconds: 4,
    exhaleSeconds: 4,
    holdOutSeconds: 4,
  );

  static const relaxation = BreathingConfig(
    inhaleSeconds: 4,
    holdInSeconds: 0,
    exhaleSeconds: 6,
    holdOutSeconds: 0,
  );

  int get cycleDuration =>
      inhaleSeconds + holdInSeconds + exhaleSeconds + holdOutSeconds;

  /// Returns the list of active phases (skips phases with 0 duration).
  List<BreathingPhase> get activePhases {
    return [
      BreathingPhase.inhale,
      if (holdInSeconds > 0) BreathingPhase.holdIn,
      BreathingPhase.exhale,
      if (holdOutSeconds > 0) BreathingPhase.holdOut,
    ];
  }

  int durationOf(BreathingPhase phase) {
    return switch (phase) {
      BreathingPhase.inhale => inhaleSeconds,
      BreathingPhase.holdIn => holdInSeconds,
      BreathingPhase.exhale => exhaleSeconds,
      BreathingPhase.holdOut => holdOutSeconds,
    };
  }
}

class BreathingState {
  final BreathingPhase phase;
  final int secondsInPhase;
  final int cyclesCompleted;
  final int totalSecondsElapsed;

  const BreathingState({
    this.phase = BreathingPhase.inhale,
    this.secondsInPhase = 0,
    this.cyclesCompleted = 0,
    this.totalSecondsElapsed = 0,
  });

  /// Progress within current phase, 0.0 to 1.0.
  double progress(BreathingConfig config) {
    final duration = config.durationOf(phase);
    if (duration == 0) return 1.0;
    return secondsInPhase / duration;
  }

  /// Advance by one second.
  BreathingState tick(BreathingConfig config) {
    final phases = config.activePhases;
    final phaseDuration = config.durationOf(phase);
    final nextSecond = secondsInPhase + 1;

    if (nextSecond >= phaseDuration) {
      // Move to next phase
      final currentIndex = phases.indexOf(phase);
      final nextIndex = (currentIndex + 1) % phases.length;
      final nextPhase = phases[nextIndex];
      final completedCycle =
          nextPhase == BreathingPhase.inhale ? cyclesCompleted + 1 : cyclesCompleted;

      return BreathingState(
        phase: nextPhase,
        secondsInPhase: 0,
        cyclesCompleted: completedCycle,
        totalSecondsElapsed: totalSecondsElapsed + 1,
      );
    }

    return BreathingState(
      phase: phase,
      secondsInPhase: nextSecond,
      cyclesCompleted: cyclesCompleted,
      totalSecondsElapsed: totalSecondsElapsed + 1,
    );
  }

  String get phaseLabel {
    return switch (phase) {
      BreathingPhase.inhale => 'Inspira',
      BreathingPhase.holdIn => 'Trattieni',
      BreathingPhase.exhale => 'Espira',
      BreathingPhase.holdOut => 'Trattieni',
    };
  }
}
