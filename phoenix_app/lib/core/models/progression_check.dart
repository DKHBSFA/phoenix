class ProgressionCheckResult {
  final int currentExerciseId;
  final String currentExerciseName;
  final int nextExerciseId;
  final String nextExerciseName;
  final int currentLevel;
  final int nextLevel;

  const ProgressionCheckResult({
    required this.currentExerciseId,
    required this.currentExerciseName,
    required this.nextExerciseId,
    required this.nextExerciseName,
    required this.currentLevel,
    required this.nextLevel,
  });
}
