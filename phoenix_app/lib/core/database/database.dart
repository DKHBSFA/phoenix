import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';
import 'seed/exercise_seed.dart';
import 'seed/food_seed.dart';
import 'seed/meal_template_seed.dart';
import 'daos/progression_dao.dart';
import 'daos/ring_data_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Exercises,
    WorkoutSessions,
    WorkoutSets,
    FastingSessions,
    Biomarkers,
    ConditioningSessions,
    LlmReports,
    ProgressionHistory,
    UserSettings,
    UserProfiles,
    MealLogs,
    FoodItems,
    MealTemplates,
    Assessments,
    ResearchFeed,
    // Phase F — Structured Cardio
    CardioSessions,
    // Phase C — Periodization
    MesocycleStates,
    // Phase D — Exercise Rotation
    MesocycleExercises,
    // Phase H — HRV
    HrvReadings,
    // Phase N — Week 0
    Week0Sessions,
    // Colmi R10 — Smart Ring
    RingDevices,
    // Colmi R10 — Ring data tables
    RingHrSamples,
    RingSleepStages,
    RingSteps,
  ],
  daos: [ProgressionDao, RingDataDao],
)
class PhoenixDatabase extends _$PhoenixDatabase {
  PhoenixDatabase() : super(_openConnection());

  PhoenixDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedExercises();
        await _seedFoodItems();
        await _seedMealTemplates();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProfiles);
        }
        if (from < 3) {
          // Add Phase 2 columns to exercises
          await m.addColumn(exercises, exercises.equipment);
          await m.addColumn(exercises, exercises.executionCues);
          await m.addColumn(exercises, exercises.defaultSets);
          await m.addColumn(exercises, exercises.defaultRepsMin);
          await m.addColumn(exercises, exercises.defaultRepsMax);
          await m.addColumn(exercises, exercises.defaultTempoEcc);
          await m.addColumn(exercises, exercises.defaultTempoCon);
          await m.addColumn(exercises, exercises.dayType);
          await m.addColumn(exercises, exercises.exerciseType);
          // Seed exercises for existing DBs
          await _seedExercises();
        }
        if (from < 4) {
          // Phase 3: nutrition
          await m.createTable(mealLogs);
          await m.addColumn(fastingSessions, fastingSessions.energyScore);
          await m.addColumn(fastingSessions, fastingSessions.waterCount);
        }
        if (from < 5) {
          // Phase 2 v2: Food DB + Meal Templates
          await m.createTable(foodItems);
          await m.createTable(mealTemplates);
          await _seedFoodItems();
          await _seedMealTemplates();
        }
        if (from < 6) {
          // Phase 5: Assessments
          await m.createTable(assessments);
        }
        if (from < 7) {
          // Phase 6: Research Feed
          await m.createTable(researchFeed);
        }
        if (from < 8) {
          // Phase 7: Onboarding v2 — add name to user profiles
          await m.addColumn(userProfiles, userProfiles.name);
        }
        if (from < 9) {
          // Protocol Completion — Phases C, D, F, G, H, M, N

          // Phase F: Cardio sessions
          await m.createTable(cardioSessions);

          // Phase C: Periodization — mesocycle state
          await m.createTable(mesocycleStates);

          // Phase D: Exercise rotation — mesocycle exercise assignments
          await m.createTable(mesocycleExercises);

          // Phase H: HRV readings
          await m.createTable(hrvReadings);

          // Phase N: Week 0 familiarization sessions
          await m.createTable(week0Sessions);

          // Phase G: Warmup/Mobility columns on workout_sessions
          await m.addColumn(workoutSessions, workoutSessions.warmupCompleted);
          await m.addColumn(workoutSessions, workoutSessions.stabilityCompleted);
          await m.addColumn(workoutSessions, workoutSessions.cooldownCompleted);
          await m.addColumn(workoutSessions, workoutSessions.cooldownType);

          // Phase M: Full macro columns on meal_logs
          await m.addColumn(mealLogs, mealLogs.carbEstimate);
          await m.addColumn(mealLogs, mealLogs.fatEstimate);
          await m.addColumn(mealLogs, mealLogs.fiberEstimate);
          await m.addColumn(mealLogs, mealLogs.caloriesEstimate);

          // Phase M: Full macro columns on meal_templates
          await m.addColumn(mealTemplates, mealTemplates.carbEstimateG);
          await m.addColumn(mealTemplates, mealTemplates.fatEstimateG);
          await m.addColumn(mealTemplates, mealTemplates.fiberEstimateG);
        }
        if (from < 10) {
          // Colmi R10 — Smart Ring device table
          await m.createTable(ringDevices);
        }
        if (from < 11) {
          await m.createTable(ringHrSamples);
          await m.createTable(ringSleepStages);
          await m.createTable(ringSteps);
          // workout_sets bio columns
          await m.addColumn(workoutSets, workoutSets.avgHr);
          await m.addColumn(workoutSets, workoutSets.maxHr);
          await m.addColumn(workoutSets, workoutSets.spo2);
          await m.addColumn(workoutSets, workoutSets.rmssd);
          await m.addColumn(workoutSets, workoutSets.stressIndex);
          await m.addColumn(workoutSets, workoutSets.hrRecoveryBpm);
          await m.addColumn(workoutSets, workoutSets.skinTemp);
          // workout_sessions bio columns
          await m.addColumn(workoutSessions, workoutSessions.avgHr);
          await m.addColumn(workoutSessions, workoutSessions.maxHr);
          await m.addColumn(workoutSessions, workoutSessions.avgSpo2);
          await m.addColumn(workoutSessions, workoutSessions.avgRmssd);
          await m.addColumn(workoutSessions, workoutSessions.bioStatsJson);
        }
      },
    );
  }

  Future<void> _seedExercises() async {
    final count = await (select(exercises)..limit(1)).get();
    if (count.isEmpty) {
      await batch((b) {
        b.insertAll(exercises, exerciseSeedData);
      });
    }
  }

  Future<void> _seedFoodItems() async {
    final count = await (select(foodItems)..limit(1)).get();
    if (count.isEmpty) {
      await batch((b) {
        b.insertAll(foodItems, foodSeedData);
      });
    }
  }

  Future<void> _seedMealTemplates() async {
    final count = await (select(mealTemplates)..limit(1)).get();
    if (count.isEmpty) {
      await batch((b) {
        b.insertAll(mealTemplates, mealTemplateSeedData);
      });
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'phoenix.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
