import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'workout_dao.g.dart';

@DriftAccessor(tables: [WorkoutSessions, WorkoutSets, Exercises])
class WorkoutDao extends DatabaseAccessor<PhoenixDatabase>
    with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  // -- Sessions --

  Future<int> createSession({
    required DateTime startedAt,
    required String type,
  }) {
    return into(workoutSessions).insert(WorkoutSessionsCompanion.insert(
      startedAt: startedAt,
      type: type,
    ));
  }

  Future<void> endSession(int sessionId, DateTime endedAt) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
      endedAt: Value(endedAt),
    ));
  }

  /// Update session-level biometric stats (HR) after bio tracker stops.
  Future<void> updateSessionBio(
    int sessionId, {
    required double avgHr,
    required int maxHr,
  }) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
      avgHr: Value(avgHr),
      maxHr: Value(maxHr),
    ));
  }

  Future<void> updateSessionSummary(
    int sessionId, {
    double? durationMinutes,
    String? durationScore,
    double? rpeAverage,
    String? llmSummary,
  }) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
      durationMinutes: Value.absentIfNull(durationMinutes),
      durationScore: Value.absentIfNull(durationScore),
      rpeAverage: Value.absentIfNull(rpeAverage),
      llmSummaryText: Value.absentIfNull(llmSummary),
    ));
  }

  Future<void> markWarmupCompleted(int sessionId) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
      warmupCompleted: const Value(true),
    ));
  }

  Future<void> markStabilityCompleted(int sessionId) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
      stabilityCompleted: const Value(true),
    ));
  }

  Future<void> markCooldownCompleted(int sessionId, {String? cooldownType}) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
      cooldownCompleted: const Value(true),
      cooldownType: Value.absentIfNull(cooldownType),
    ));
  }

  Stream<List<WorkoutSession>> watchRecentSessions({int limit = 20}) {
    return (select(workoutSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(limit))
        .watch();
  }

  Future<List<WorkoutSession>> getSessionsByType(
    String type, {
    int limit = 8,
  }) {
    return (select(workoutSessions)
          ..where((s) => s.type.equals(type))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(limit))
        .get();
  }

  /// Get the most recent strength workout end time (for cold exposure alert).
  Future<DateTime?> lastStrengthEndTime() async {
    final results = await (select(workoutSessions)
          ..where((s) => s.type.equals(WorkoutType.strength))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .get();
    if (results.isEmpty) return null;
    return results.first.endedAt ?? results.first.startedAt;
  }

  // -- Sets --

  Future<int> addSet(WorkoutSetsCompanion set) {
    return into(workoutSets).insert(set);
  }

  Future<void> updateSet(int setId, WorkoutSetsCompanion data) {
    return (update(workoutSets)..where((s) => s.id.equals(setId))).write(data);
  }

  Stream<List<WorkoutSet>> watchSetsForSession(int sessionId) {
    return (select(workoutSets)
          ..where((s) => s.sessionId.equals(sessionId))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .watch();
  }

  Future<List<WorkoutSet>> getSetsForSession(int sessionId) {
    return (select(workoutSets)
          ..where((s) => s.sessionId.equals(sessionId))
          ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
        .get();
  }

  Future<WorkoutSession?> getSession(int sessionId) {
    return (select(workoutSessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingleOrNull();
  }

  Future<List<WorkoutSession>> getSessionsInRange(
      DateTime start, DateTime end) {
    return (select(workoutSessions)
          ..where((s) =>
              s.startedAt.isBiggerOrEqualValue(start) &
              s.startedAt.isSmallerOrEqualValue(end))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
  }

  /// Sessions completed today (with endedAt set).
  Future<List<WorkoutSession>> getTodaySessions() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return (select(workoutSessions)
          ..where((s) =>
              s.startedAt.isBiggerOrEqualValue(todayStart) &
              s.startedAt.isSmallerThanValue(todayEnd) &
              s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
  }

  /// Consecutive days with at least one completed workout.
  Future<int> currentStreak() async {
    final sessions = await (select(workoutSessions)
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
    if (sessions.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    final sessionDates = sessions
        .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in sessionDates) {
      if (date == checkDate ||
          date == checkDate.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = date;
      } else {
        break;
      }
    }
    return streak;
  }
}
