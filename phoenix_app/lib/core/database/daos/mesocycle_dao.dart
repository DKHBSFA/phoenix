import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'mesocycle_dao.g.dart';

@DriftAccessor(tables: [MesocycleStates, MesocycleExercises])
class MesocycleDao extends DatabaseAccessor<PhoenixDatabase>
    with _$MesocycleDaoMixin {
  MesocycleDao(super.db);

  /// Get the latest active (not completed) mesocycle.
  Future<MesocycleState?> getCurrentMesocycle() {
    return (select(mesocycleStates)
          ..where((s) => s.completedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> createMesocycle(MesocycleStatesCompanion entry) {
    return into(mesocycleStates).insert(entry);
  }

  Future<void> updateMesocycle(int id, MesocycleStatesCompanion data) {
    return (update(mesocycleStates)..where((s) => s.id.equals(id))).write(data);
  }

  Future<void> completeMesocycle(int id) {
    return (update(mesocycleStates)..where((s) => s.id.equals(id)))
        .write(MesocycleStatesCompanion(
      completedAt: Value(DateTime.now()),
    ));
  }

  Future<List<MesocycleExercise>> getExercisesForMesocycle(
      int mesocycleNumber) {
    return (select(mesocycleExercises)
          ..where((e) => e.mesocycleNumber.equals(mesocycleNumber)))
        .get();
  }

  Future<void> saveExerciseAssignments(
      int mesocycleNumber, List<MesocycleExercisesCompanion> entries) {
    return batch((b) {
      b.insertAll(mesocycleExercises, entries);
    });
  }

  /// Get exercises from previous N mesocycles (for rotation avoidance).
  Future<List<MesocycleExercise>> getPreviousSelections(
    int mesocycleNumber, {
    int lookback = 2,
  }) {
    final minMeso = mesocycleNumber - lookback;
    return (select(mesocycleExercises)
          ..where((e) =>
              e.mesocycleNumber.isBiggerOrEqualValue(minMeso) &
              e.mesocycleNumber.isSmallerThanValue(mesocycleNumber)))
        .get();
  }
}
