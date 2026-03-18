import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'hrv_dao.g.dart';

@DriftAccessor(tables: [HrvReadings])
class HrvDao extends DatabaseAccessor<PhoenixDatabase> with _$HrvDaoMixin {
  HrvDao(super.db);

  Future<int> addReading(HrvReadingsCompanion entry) {
    return into(hrvReadings).insert(entry);
  }

  Future<List<HrvReading>> getRecentReadings({int days = 30}) {
    final start = DateTime.now().subtract(Duration(days: days));
    return (select(hrvReadings)
          ..where((r) => r.timestamp.isBiggerOrEqualValue(start))
          ..orderBy([(r) => OrderingTerm.desc(r.timestamp)]))
        .get();
  }

  /// Last 14 readings for baseline calculation.
  Future<List<HrvReading>> getReadingsForBaseline() {
    return (select(hrvReadings)
          ..orderBy([(r) => OrderingTerm.desc(r.timestamp)])
          ..limit(14))
        .get();
  }

  /// Most recent reading from today.
  Future<HrvReading?> getTodayReading() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return (select(hrvReadings)
          ..where((r) =>
              r.timestamp.isBiggerOrEqualValue(todayStart) &
              r.timestamp.isSmallerThanValue(todayEnd))
          ..orderBy([(r) => OrderingTerm.desc(r.timestamp)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<HrvReading>> watchRecent({int limit = 14}) {
    return (select(hrvReadings)
          ..orderBy([(r) => OrderingTerm.desc(r.timestamp)])
          ..limit(limit))
        .watch();
  }
}
