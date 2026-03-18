import 'dart:convert';

import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'progression_dao.g.dart';

@DriftAccessor(
    tables: [ProgressionHistory, Exercises, WorkoutSets, WorkoutSessions])
class ProgressionDao extends DatabaseAccessor<PhoenixDatabase>
    with _$ProgressionDaoMixin {
  ProgressionDao(super.db);

  /// Records a progression advancement.
  Future<int> recordAdvancement({
    required int exerciseId,
    required int fromLevel,
    required int toLevel,
    required Map<String, dynamic> criteriaMet,
  }) {
    return into(progressionHistory).insert(
      ProgressionHistoryCompanion.insert(
        exerciseId: exerciseId,
        date: DateTime.now(),
        fromLevel: fromLevel,
        toLevel: toLevel,
        criteriaMetJson: Value(jsonEncode(criteriaMet)),
      ),
    );
  }

  /// Checks if an exercise meets progression criteria.
  /// Returns the next exercise ID in the chain, or null.
  ///
  /// Criteria (from phoenix-protocol §2.6):
  /// - Last 2 completed sessions containing this exercise
  /// - All sets in each session: repsCompleted >= repsTarget AND rpe <= 8.0
  Future<int?> checkProgressionCriteria({
    required int exerciseId,
    required int sessionId,
  }) async {
    // 1. Get the exercise to check progressionNextId
    final exercise = await (select(exercises)
          ..where((e) => e.id.equals(exerciseId)))
        .getSingleOrNull();
    if (exercise == null || exercise.progressionNextId == null) return null;

    // 2. Get the last 2 completed sessions that contain sets for this exercise
    final sessionRows = await customSelect(
      'SELECT DISTINCT ws.session_id, wo.started_at '
      'FROM workout_sets ws '
      'JOIN workout_sessions wo ON ws.session_id = wo.id '
      'WHERE ws.exercise_id = ? '
      'AND wo.ended_at IS NOT NULL '
      'ORDER BY wo.started_at DESC '
      'LIMIT 2',
      variables: [Variable.withInt(exerciseId)],
      readsFrom: {workoutSets, workoutSessions},
    ).get();

    if (sessionRows.length < 2) return null;

    // 3. For each session, verify all sets meet criteria
    for (final row in sessionRows) {
      final sid = row.read<int>('session_id');
      final checkRows = await customSelect(
        'SELECT COUNT(*) as total, '
        'SUM(CASE WHEN reps_completed >= reps_target AND rpe <= 8.0 THEN 1 ELSE 0 END) as passing '
        'FROM workout_sets '
        'WHERE session_id = ? AND exercise_id = ?',
        variables: [Variable.withInt(sid), Variable.withInt(exerciseId)],
        readsFrom: {workoutSets},
      ).getSingle();

      final total = checkRows.read<int>('total');
      final passing = checkRows.read<int>('passing');
      if (total == 0 || total != passing) return null;
    }

    // 4. Both sessions pass — progression available
    return exercise.progressionNextId;
  }

  /// Get progression history for an exercise.
  Future<List<ProgressionHistoryData>> getHistoryForExercise(int exerciseId) {
    return (select(progressionHistory)
          ..where((p) => p.exerciseId.equals(exerciseId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }
}
