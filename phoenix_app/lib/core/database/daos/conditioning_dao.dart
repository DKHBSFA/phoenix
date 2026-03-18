import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'conditioning_dao.g.dart';

@DriftAccessor(tables: [ConditioningSessions])
class ConditioningDao extends DatabaseAccessor<PhoenixDatabase>
    with _$ConditioningDaoMixin {
  ConditioningDao(super.db);

  Future<int> addSession(ConditioningSessionsCompanion entry) {
    return into(conditioningSessions).insert(entry);
  }

  Stream<List<ConditioningSession>> watchByType(String type, {int limit = 20}) {
    return (select(conditioningSessions)
          ..where((s) => s.type.equals(type))
          ..orderBy([(s) => OrderingTerm.desc(s.date)])
          ..limit(limit))
        .watch();
  }

  Stream<List<ConditioningSession>> watchRecent({int limit = 20}) {
    return (select(conditioningSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.date)])
          ..limit(limit))
        .watch();
  }

  Future<List<ConditioningSession>> getByTypeInRange(
    String type,
    DateTime start,
    DateTime end,
  ) {
    return (select(conditioningSessions)
          ..where((s) =>
              s.type.equals(type) &
              s.date.isBiggerOrEqualValue(start) &
              s.date.isSmallerOrEqualValue(end))
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .get();
  }

  /// Get the first session date for a given type (for cold week calculation).
  Future<DateTime?> getFirstSessionDate(String type) async {
    final results = await (select(conditioningSessions)
          ..where((s) => s.type.equals(type))
          ..orderBy([(s) => OrderingTerm.asc(s.date)])
          ..limit(1))
        .get();
    return results.isEmpty ? null : results.first.date;
  }

  /// Get all sessions for a type (for charts, last 30 days default).
  Future<List<ConditioningSession>> getRecentByType(
    String type, {
    int days = 30,
  }) {
    final start = DateTime.now().subtract(Duration(days: days));
    return (select(conditioningSessions)
          ..where((s) =>
              s.type.equals(type) & s.date.isBiggerOrEqualValue(start))
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .get();
  }

  /// Count sessions by type.
  Future<int> countByType(String type) async {
    final count = countAll();
    final query = selectOnly(conditioningSessions)
      ..addColumns([count])
      ..where(conditioningSessions.type.equals(type));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Count conditioning sessions today (any type).
  Future<int> getTodaySessionCount() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final count = countAll();
    final query = selectOnly(conditioningSessions)
      ..addColumns([count])
      ..where(conditioningSessions.date.isBiggerOrEqualValue(todayStart) &
          conditioningSessions.date.isSmallerThanValue(todayEnd));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Calculate current streak (consecutive days with at least one session).
  Future<int> currentStreak(String type) async {
    final sessions = await (select(conditioningSessions)
          ..where((s) => s.type.equals(type))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();

    if (sessions.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();
    // Normalize to date only
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    final sessionDates = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in sessionDates) {
      if (date == checkDate || date == checkDate.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = date;
      } else {
        break;
      }
    }

    return streak;
  }
}
