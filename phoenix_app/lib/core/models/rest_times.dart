import '../database/tables.dart';

/// Rest time configuration based on the Phoenix Protocol.
/// See: phoenix-app-architecture.md, section "Tempi di riposo"
class RestTimes {
  /// Returns rest time in seconds between sets for a given context.
  static int betweenSets({
    required String exerciseType,
    required int phoenixLevel,
  }) {
    final base = _baseBetweenSets(exerciseType);
    return _adjustForLevel(base, phoenixLevel);
  }

  /// Returns rest time in seconds between exercises.
  static int betweenExercises({
    required String exerciseType,
    required int phoenixLevel,
  }) {
    final base = _baseBetweenExercises(exerciseType);
    return _adjustForLevel(base, phoenixLevel);
  }

  static int _baseBetweenSets(String type) {
    switch (type) {
      case ExerciseType.compound:
        return 150; // 2.5 min (midpoint of 2-3 min)
      case ExerciseType.accessory:
        return 105; // 1:45 min (midpoint of 90s-2min)
      case ExerciseType.core:
        return 75; // 1:15 min (midpoint of 60-90s)
      case ExerciseType.hiit:
        return 0; // Defined by interval protocol
      case ExerciseType.deload:
        return 150; // Same as compound, lower intensity
      default:
        return 120; // 2 min default
    }
  }

  static int _baseBetweenExercises(String type) {
    switch (type) {
      case ExerciseType.compound:
        return 180; // 3 min
      case ExerciseType.accessory:
        return 120; // 2 min
      case ExerciseType.core:
        return 90; // 1:30 min
      default:
        return 120;
    }
  }

  /// Adjust rest times based on Phoenix progression level.
  /// Levels 1-2 (beginner): +30s
  /// Levels 3-4 (intermediate): standard
  /// Levels 5-6 (advanced): -15s
  static int _adjustForLevel(int baseSeconds, int level) {
    if (level <= 2) {
      return baseSeconds + 30;
    } else if (level >= 5) {
      return baseSeconds - 15;
    }
    return baseSeconds;
  }
}
