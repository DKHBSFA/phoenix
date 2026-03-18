import 'dart:math';

import '../database/tables.dart';

/// Workout Duration Score calculator.
/// Phase 1 (weeks 1-4): data collection only.
/// Phase 2 (week 5+): scoring based on moving average and physiological ranges.
class DurationScoreCalculator {
  static const _minSessionsForScoring = 8;

  // Physiological ranges in minutes
  static const _ranges = {
    WorkoutType.strength: (min: 45.0, max: 75.0),
    WorkoutType.cardio: (min: 30.0, max: 60.0),
    WorkoutType.power: (min: 30.0, max: 60.0),
    WorkoutType.deload: (min: 30.0, max: 60.0),
    WorkoutType.flexibility: (min: 20.0, max: 45.0),
  };

  /// Calculate the duration score for a session.
  /// Returns null during Phase 1 (insufficient data).
  static DurationScoreResult? calculate({
    required double currentDurationMinutes,
    required String workoutType,
    required List<double> previousDurations,
  }) {
    if (previousDurations.length < _minSessionsForScoring) {
      return null; // Phase 1: collecting data
    }

    final mean = previousDurations.reduce((a, b) => a + b) /
        previousDurations.length;
    final variance = previousDurations
            .map((d) => pow(d - mean, 2))
            .reduce((a, b) => a + b) /
        previousDurations.length;
    final sd = sqrt(variance);
    final deviation = (currentDurationMinutes - mean).abs();

    final range = _ranges[workoutType] ?? (min: 30.0, max: 90.0);
    final inRange = currentDurationMinutes >= range.min &&
        currentDurationMinutes <= range.max;
    final nearRange = currentDurationMinutes >= range.min * 0.85 &&
        currentDurationMinutes <= range.max * 1.15;

    String score;
    if (deviation <= sd && inRange) {
      score = DurationScore.green;
    } else if (deviation <= 2 * sd || nearRange) {
      score = DurationScore.yellow;
    } else {
      score = DurationScore.red;
    }

    return DurationScoreResult(
      score: score,
      currentMinutes: currentDurationMinutes,
      targetMinutes: mean,
      standardDeviation: sd,
      rangeMin: range.min,
      rangeMax: range.max,
    );
  }
}

class DurationScoreResult {
  final String score; // green/yellow/red
  final double currentMinutes;
  final double targetMinutes;
  final double standardDeviation;
  final double rangeMin;
  final double rangeMax;

  const DurationScoreResult({
    required this.score,
    required this.currentMinutes,
    required this.targetMinutes,
    required this.standardDeviation,
    required this.rangeMin,
    required this.rangeMax,
  });
}
