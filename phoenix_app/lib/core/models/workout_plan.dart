import '../database/database.dart';
import '../database/tables.dart';
import 'cardio_plan.dart';

/// Represents a full day's workout plan.
class WorkoutPlan {
  final String dayName; // "Upper Push", "Lower Quad", etc.
  final String type; // WorkoutType.strength, cardio, power
  final List<PlannedExercise> exercises;
  final int estimatedMinutes;
  final CardioPlan? cardioPlan; // Phase F: structured cardio

  const WorkoutPlan({
    required this.dayName,
    required this.type,
    required this.exercises,
    required this.estimatedMinutes,
    this.cardioPlan,
  });

  bool get isRestDay => type == WorkoutType.cardio && cardioPlan == null;
  bool get isCardioDay => type == WorkoutType.cardio && cardioPlan != null;
}

/// A single exercise within a workout plan.
class PlannedExercise {
  final Exercise exercise;
  final int sets;
  final int repsMin;
  final int repsMax;
  final int tempoEcc;
  final int tempoCon;
  final int restSeconds;
  final int? rpeCap; // Max RPE for adapted exercises (mild limitation)

  const PlannedExercise({
    required this.exercise,
    required this.sets,
    required this.repsMin,
    required this.repsMax,
    required this.tempoEcc,
    required this.tempoCon,
    required this.restSeconds,
    this.rpeCap,
  });

  String get repsLabel => repsMin == repsMax ? '$repsMin' : '$repsMin-$repsMax';
}
