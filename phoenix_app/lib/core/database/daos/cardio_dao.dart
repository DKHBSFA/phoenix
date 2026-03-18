import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'cardio_dao.g.dart';

@DriftAccessor(tables: [CardioSessions])
class CardioDao extends DatabaseAccessor<PhoenixDatabase>
    with _$CardioDaoMixin {
  CardioDao(super.db);

  Future<int> addSession(CardioSessionsCompanion entry) {
    return into(cardioSessions).insert(entry);
  }

  Stream<List<CardioSession>> watchRecent({int limit = 20}) {
    return (select(cardioSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.date)])
          ..limit(limit))
        .watch();
  }

  Future<List<CardioSession>> getSessionsInRange(
      DateTime start, DateTime end) {
    return (select(cardioSessions)
          ..where((s) =>
              s.date.isBiggerOrEqualValue(start) &
              s.date.isSmallerOrEqualValue(end))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  Future<List<CardioSession>> getTodaySessions() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return (select(cardioSessions)
          ..where((s) =>
              s.date.isBiggerOrEqualValue(todayStart) &
              s.date.isSmallerThanValue(todayEnd))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  Future<int> countByProtocol(String protocol) async {
    final count = countAll();
    final query = selectOnly(cardioSessions)
      ..addColumns([count])
      ..where(cardioSessions.protocol.equals(protocol));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
