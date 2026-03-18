import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'food_dao.g.dart';

@DriftAccessor(tables: [FoodItems])
class FoodDao extends DatabaseAccessor<PhoenixDatabase>
    with _$FoodDaoMixin {
  FoodDao(super.db);

  /// All foods ordered by longevity tier (best first).
  Future<List<FoodItem>> getAll() {
    return (select(foodItems)
          ..orderBy([
            (f) => OrderingTerm.asc(f.longevityTier),
            (f) => OrderingTerm.asc(f.name),
          ]))
        .get();
  }

  /// Foods filtered by tier.
  Future<List<FoodItem>> getByTier(int tier) {
    return (select(foodItems)
          ..where((f) => f.longevityTier.equals(tier))
          ..orderBy([(f) => OrderingTerm.asc(f.name)]))
        .get();
  }

  /// Search foods by name (case-insensitive).
  Future<List<FoodItem>> search(String query) {
    return (select(foodItems)
          ..where((f) => f.name.lower().like('%${query.toLowerCase()}%'))
          ..orderBy([(f) => OrderingTerm.asc(f.longevityTier)]))
        .get();
  }

  /// Single food by name (exact match).
  Future<FoodItem?> getByName(String name) {
    return (select(foodItems)..where((f) => f.name.equals(name)))
        .getSingleOrNull();
  }
}
