import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'meal_template_dao.g.dart';

@DriftAccessor(tables: [MealTemplates])
class MealTemplateDao extends DatabaseAccessor<PhoenixDatabase>
    with _$MealTemplateDaoMixin {
  MealTemplateDao(super.db);

  /// Get all 3 meals for a given day type, ordered by meal number.
  Future<List<MealTemplate>> getByDayType(String dayType) {
    return (select(mealTemplates)
          ..where((m) => m.dayType.equals(dayType))
          ..orderBy([(m) => OrderingTerm.asc(m.mealNumber)]))
        .get();
  }

  /// Get all templates.
  Future<List<MealTemplate>> getAll() {
    return (select(mealTemplates)
          ..orderBy([
            (m) => OrderingTerm.asc(m.dayType),
            (m) => OrderingTerm.asc(m.mealNumber),
          ]))
        .get();
  }
}
