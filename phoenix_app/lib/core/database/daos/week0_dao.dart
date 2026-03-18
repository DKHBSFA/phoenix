import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'week0_dao.g.dart';

@DriftAccessor(tables: [Week0Sessions])
class Week0Dao extends DatabaseAccessor<PhoenixDatabase>
    with _$Week0DaoMixin {
  Week0Dao(super.db);

  Future<int> addSession(Week0SessionsCompanion entry) {
    return into(week0Sessions).insert(entry);
  }

  Future<List<Week0Session>> getAllSessions() {
    return (select(week0Sessions)
          ..orderBy([(s) => OrderingTerm.asc(s.sessionNumber)]))
        .get();
  }

  Future<int> completedCount() async {
    final count = countAll();
    final query = selectOnly(week0Sessions)
      ..addColumns([count])
      ..where(week0Sessions.completedAt.isNotNull());
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<void> completeSession(
    int id, {
    required double avgRpe,
    required bool passed,
  }) {
    return (update(week0Sessions)..where((s) => s.id.equals(id)))
        .write(Week0SessionsCompanion(
      completedAt: Value(DateTime.now()),
      avgRpe: Value(avgRpe),
      passed: Value(passed),
    ));
  }

  Stream<List<Week0Session>> watchSessions() {
    return (select(week0Sessions)
          ..orderBy([(s) => OrderingTerm.asc(s.sessionNumber)]))
        .watch();
  }
}
