import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<PhoenixDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  /// Best exercise for a category/level/equipment combo.
  /// Returns the highest-level exercise the user can do.
  /// [excludeIds] filters out exercises by ID (physical limitations).
  Future<List<Exercise>> getForWorkout({
    required String category,
    required int maxLevel,
    required String equipment,
    List<int> excludeIds = const [],
  }) {
    final query = select(exercises)
      ..where((e) => e.category.equals(category))
      ..where((e) => e.phoenixLevel.isSmallerOrEqualValue(maxLevel))
      ..where((e) => e.equipment.isIn([equipment, 'all']))
      ..where((e) => e.exerciseType.equals(ExerciseType.compound))
      ..orderBy([(e) => OrderingTerm.desc(e.phoenixLevel)])
      ..limit(1);
    if (excludeIds.isNotEmpty) {
      query.where((e) => e.id.isNotIn(excludeIds));
    }
    return query.get();
  }

  /// Accessories for a category.
  Future<List<Exercise>> getAccessories({
    required String category,
    required String equipment,
    List<int> excludeIds = const [],
  }) {
    final query = select(exercises)
      ..where((e) => e.category.equals(category))
      ..where((e) => e.exerciseType.equals(ExerciseType.accessory))
      ..where((e) => e.equipment.isIn([equipment, 'all']))
      ..orderBy([(e) => OrderingTerm.asc(e.name)]);
    if (excludeIds.isNotEmpty) {
      query.where((e) => e.id.isNotIn(excludeIds));
    }
    return query.get();
  }

  /// Core exercises up to a given level.
  Future<List<Exercise>> getCoreExercises({
    required int maxLevel,
    List<int> excludeIds = const [],
  }) {
    final query = select(exercises)
      ..where((e) => e.category.equals(ExerciseCategory.core))
      ..where((e) => e.phoenixLevel.isSmallerOrEqualValue(maxLevel))
      ..orderBy([(e) => OrderingTerm.desc(e.phoenixLevel)])
      ..limit(4);
    if (excludeIds.isNotEmpty) {
      query.where((e) => e.id.isNotIn(excludeIds));
    }
    return query.get();
  }

  /// Full progression chain for a category + equipment.
  Future<List<Exercise>> getProgressionChain(
      String category, String equipment) {
    return (select(exercises)
          ..where((e) => e.category.equals(category))
          ..where((e) => e.exerciseType.equals(ExerciseType.compound))
          ..where((e) => e.equipment.isIn([equipment, 'all']))
          ..orderBy([(e) => OrderingTerm.asc(e.phoenixLevel)]))
        .get();
  }

  /// Single exercise by ID.
  Future<Exercise> getById(int id) {
    return (select(exercises)..where((e) => e.id.equals(id))).getSingle();
  }

  /// Multiple exercises by IDs in a single query.
  Future<List<Exercise>> getByIds(Set<int> ids) {
    if (ids.isEmpty) return Future.value([]);
    return (select(exercises)..where((e) => e.id.isIn(ids.toList()))).get();
  }

  /// Count exercises (used to check if seeding is needed).
  Future<int> count() async {
    final expr = exercises.id.count();
    final query = selectOnly(exercises)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }
}
