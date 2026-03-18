import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'fasting_dao.g.dart';

@DriftAccessor(tables: [FastingSessions])
class FastingDao extends DatabaseAccessor<PhoenixDatabase>
    with _$FastingDaoMixin {
  FastingDao(super.db);

  Future<int> startFast({
    required DateTime startedAt,
    required double targetHours,
    required int level,
  }) {
    return into(fastingSessions).insert(FastingSessionsCompanion.insert(
      startedAt: startedAt,
      targetHours: targetHours,
      level: Value(level),
    ));
  }

  Future<void> endFast(int sessionId, DateTime endedAt, double actualHours) {
    return (update(fastingSessions)..where((s) => s.id.equals(sessionId)))
        .write(FastingSessionsCompanion(
      endedAt: Value(endedAt),
      actualHours: Value(actualHours),
    ));
  }

  Future<void> updateGlucoseReading(int sessionId, String json) {
    return (update(fastingSessions)..where((s) => s.id.equals(sessionId)))
        .write(FastingSessionsCompanion(
      glucoseReadingsJson: Value(json),
    ));
  }

  Future<void> updateRefeedingJournal(
    int sessionId, {
    required String notes,
    required double tolerance,
    required int energy,
  }) {
    return (update(fastingSessions)..where((s) => s.id.equals(sessionId)))
        .write(FastingSessionsCompanion(
      refeedingNotes: Value(notes),
      toleranceScore: Value(tolerance),
      energyScore: Value(energy),
    ));
  }

  Future<void> incrementWater(int sessionId) async {
    final session = await (select(fastingSessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingle();
    await (update(fastingSessions)..where((s) => s.id.equals(sessionId)))
        .write(FastingSessionsCompanion(
      waterCount: Value(session.waterCount + 1),
    ));
  }

  Stream<FastingSession?> watchActiveFast() {
    return (select(fastingSessions)
          ..where((s) => s.endedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<FastingSession?> getActiveFast() {
    return (select(fastingSessions)
          ..where((s) => s.endedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<FastingSession>> watchRecentFasts({int limit = 20}) {
    return (select(fastingSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(limit))
        .watch();
  }

  Future<List<FastingSession>> getFastsByLevel(int level) {
    return (select(fastingSessions)
          ..where((s) => s.level.equals(level))
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
  }

  /// Check if the user can advance to [targetLevel].
  /// Level 2 requires: ≥7 completed fasts at level 1, ≥5 with tolerance ≥3.
  /// Level 3 requires: ≥14 completed fasts at level 2, ≥10 with tolerance ≥3.
  Future<bool> canAdvanceToLevel(int targetLevel) async {
    final currentLevel = targetLevel - 1;
    if (currentLevel < 1) return false;
    final sessions = await getFastsByLevel(currentLevel);

    final withGoodTolerance = sessions
        .where((s) => s.toleranceScore != null && s.toleranceScore! >= 3)
        .length;

    return switch (targetLevel) {
      2 => sessions.length >= 7 && withGoodTolerance >= 5,
      3 => sessions.length >= 14 && withGoodTolerance >= 10,
      _ => false,
    };
  }

  Future<List<FastingSession>> getSessionsInRange(
      DateTime start, DateTime end) {
    return (select(fastingSessions)
          ..where((s) =>
              s.startedAt.isBiggerOrEqualValue(start) &
              s.startedAt.isSmallerOrEqualValue(end))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
  }

  /// Most recent completed fasting session.
  Future<FastingSession?> getLastCompleted() {
    return (select(fastingSessions)
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get stats for a given fasting level (for levels tab).
  Future<({int total, int goodTolerance})> getLevelStats(int level) async {
    final sessions = await getFastsByLevel(level);
    final good = sessions
        .where((s) => s.toleranceScore != null && s.toleranceScore! >= 3)
        .length;
    return (total: sessions.length, goodTolerance: good);
  }
}
