import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'meal_log_dao.g.dart';

@DriftAccessor(tables: [MealLogs])
class MealLogDao extends DatabaseAccessor<PhoenixDatabase>
    with _$MealLogDaoMixin {
  MealLogDao(super.db);

  Future<int> addMeal(MealLogsCompanion entry) {
    return into(mealLogs).insert(entry);
  }

  Future<List<MealLog>> getMealsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(mealLogs)
          ..where((m) => m.date.isBiggerOrEqualValue(start))
          ..where((m) => m.date.isSmallerThanValue(end))
          ..orderBy([(m) => OrderingTerm.asc(m.mealTime)]))
        .get();
  }

  Stream<List<MealLog>> watchMealsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(mealLogs)
          ..where((m) => m.date.isBiggerOrEqualValue(start))
          ..where((m) => m.date.isSmallerThanValue(end))
          ..orderBy([(m) => OrderingTerm.asc(m.mealTime)]))
        .watch();
  }

  Future<void> deleteMeal(int id) {
    return (delete(mealLogs)..where((m) => m.id.equals(id))).go();
  }
}
