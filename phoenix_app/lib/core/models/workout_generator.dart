import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/daos/exercise_dao.dart';
import '../database/tables.dart';
import '../models/rest_times.dart';
import 'age_adaptation.dart';
import 'cardio_protocols.dart';
import 'periodization_engine.dart' as pe;
import 'workout_plan.dart';

/// State notifier for equipment override in today's workout.
/// null = use profile default, otherwise override for this session only.
class EquipmentOverrideNotifier extends StateNotifier<String?> {
  EquipmentOverrideNotifier() : super(null);

  void setOverride(String equipment) => state = equipment;
  void clearOverride() => state = null;
  void toggle(String profileEquipment) {
    if (state == Equipment.bodyweight) {
      state = null; // back to profile default
    } else {
      state = Equipment.bodyweight;
    }
  }
}

/// Day-of-week schedule from Phoenix Protocol section 2.1.
class DaySchedule {
  final String dayName;
  final String type;
  final String category; // primary category for strength days

  const DaySchedule(this.dayName, this.type, this.category);
}

const _weekSchedule = <int, DaySchedule>{
  1: DaySchedule('Upper Push', WorkoutType.strength, ExerciseCategory.push),    // Monday
  2: DaySchedule('Lower Quad', WorkoutType.strength, ExerciseCategory.squat),   // Tuesday
  3: DaySchedule('Active Recovery', WorkoutType.cardio, ''),      // Wednesday
  4: DaySchedule('Upper Pull', WorkoutType.strength, ExerciseCategory.pull),     // Thursday
  5: DaySchedule('Lower Hinge', WorkoutType.strength, ExerciseCategory.hinge),  // Friday
  6: DaySchedule('Active Recovery', WorkoutType.cardio, ''),      // Saturday
  7: DaySchedule('Full Body Power', WorkoutType.power, ''),       // Sunday
};

/// Parameters per tier from Phoenix Protocol section 2.2.
class _TierParams {
  final int compoundCount;
  final int accessoryCount;
  final int setsCompound;
  final int setsAccessory;
  final int repsMinCompound;
  final int repsMaxCompound;

  const _TierParams({
    required this.compoundCount,
    required this.accessoryCount,
    required this.setsCompound,
    required this.setsAccessory,
    required this.repsMinCompound,
    required this.repsMaxCompound,
  });
}

const _tierParams = {
  'beginner': _TierParams(
    compoundCount: 2, accessoryCount: 2, setsCompound: 3, setsAccessory: 3,
    repsMinCompound: 10, repsMaxCompound: 15,
  ),
  'intermediate': _TierParams(
    compoundCount: 3, accessoryCount: 2, setsCompound: 4, setsAccessory: 3,
    repsMinCompound: 6, repsMaxCompound: 12,
  ),
  'advanced': _TierParams(
    compoundCount: 3, accessoryCount: 3, setsCompound: 5, setsAccessory: 4,
    repsMinCompound: 1, repsMaxCompound: 8,
  ),
};

/// Generates a daily workout plan from the exercise DB.
class WorkoutGenerator {
  final ExerciseDao _exerciseDao;

  WorkoutGenerator(this._exerciseDao);

  /// Get the schedule for a given weekday (1=Monday ... 7=Sunday).
  DaySchedule scheduleFor(int weekday) {
    return _weekSchedule[weekday] ?? _weekSchedule[3]!;
  }

  /// Generate today's workout plan.
  /// [excludeIds] filters out exercises by ID (physical limitations from assessment).
  /// [levelOverrides] maps category names to max level (from AI program generation).
  /// [mesocycleState] when provided, uses PeriodizationEngine for sets/reps/rest.
  /// [mesocycleExerciseIds] maps rotation slot keys to exercise IDs
  /// from ExerciseRotator. When provided, uses those specific exercises
  /// instead of generic DAO queries.
  /// [userAge] when provided, applies Fragala 2019 age adaptation to volume.
  Future<WorkoutPlan> generateForDay({
    required int weekday,
    required String tier,
    required String equipment,
    List<int> excludeIds = const [],
    Map<String, int> levelOverrides = const {},
    pe.MesocycleState? mesocycleState,
    Map<String, int> mesocycleExerciseIds = const {},
    int? userAge,
    Map<int, Map<String, dynamic>> exerciseModifications = const {},
  }) async {
    final schedule = scheduleFor(weekday);

    if (schedule.type == WorkoutType.cardio) {
      // Phase F: Generate structured cardio plan
      final cardioPlan = weekday == 3
          ? CardioProtocols.tabata(tier: tier)
          : weekday == 6
              ? CardioProtocols.norwegian(tier: tier)
              : CardioProtocols.zone2Only();
      return WorkoutPlan(
        dayName: cardioPlan.protocolName == 'tabata'
            ? 'HIIT Tabata + Zone 2'
            : cardioPlan.protocolName == 'norwegian'
                ? 'Norwegian 4×4'
                : 'Zone 2 Steady State',
        type: schedule.type,
        exercises: [],
        estimatedMinutes: cardioPlan.estimatedMinutes,
        cardioPlan: cardioPlan,
      );
    }

    // Phase C: Use periodization params when mesocycle state is available
    final pe.WorkoutParams? periodParams;
    if (mesocycleState != null) {
      const engine = pe.PeriodizationEngine();
      periodParams = engine.getParamsForDay(tier, mesocycleState, weekday);
    } else {
      periodParams = null;
    }

    final fallbackParams = _tierParams[tier] ?? _tierParams['beginner']!;
    final defaultMaxLevel = _tierToMaxLevel(tier);
    final planned = <PlannedExercise>[];

    // Effective params (periodization overrides static tier params)
    var setsCompound = periodParams?.setsCompound ?? fallbackParams.setsCompound;
    var setsAccessory = periodParams?.setsAccessory ?? fallbackParams.setsAccessory;
    final repsMinCompound = periodParams?.repsMin ?? fallbackParams.repsMinCompound;
    final repsMaxCompound = periodParams?.repsMax ?? fallbackParams.repsMaxCompound;
    final restOverride = periodParams?.restSeconds;

    // Phase J: Apply age-based volume adjustment (Fragala 2019)
    if (userAge != null) {
      const ageEngine = AgeAdaptationEngine();
      setsCompound = ageEngine.adjustSets(setsCompound, userAge);
      setsAccessory = ageEngine.adjustSets(setsAccessory, userAge);
    }

    // Helper: get effective max level for a category (respects AI overrides)
    int maxLevelFor(String category) =>
        levelOverrides[category] ?? defaultMaxLevel;

    // Phase D: Helper to resolve exercise by rotator slot key or fallback to DAO
    Future<Exercise?> _resolveExercise(String slotKey, Future<List<Exercise>> Function() fallback) async {
      final rotatedId = mesocycleExerciseIds[slotKey];
      if (rotatedId != null) {
        final byId = await _exerciseDao.getByIds({rotatedId});
        if (byId.isNotEmpty) return byId.first;
      }
      final list = await fallback();
      return list.isNotEmpty ? list.first : null;
    }

    if (schedule.type == WorkoutType.power) {
      // Full body power: one compound per category
      for (final cat in [ExerciseCategory.push, ExerciseCategory.pull, ExerciseCategory.squat, ExerciseCategory.hinge]) {
        final catMaxLevel = maxLevelFor(cat);
        final slotKey = '${cat}_${ExerciseType.compound}_0';
        final ex = await _resolveExercise(slotKey, () =>
          _exerciseDao.getForWorkout(
            category: cat, maxLevel: catMaxLevel, equipment: equipment,
            excludeIds: excludeIds,
          ),
        );
        if (ex != null) {
          planned.add(_toPlanned(ex, setsCompound,
              repsMinCompound, repsMaxCompound, catMaxLevel,
              restOverride: restOverride));
        }
      }
    } else {
      // Strength day — compounds
      final catMaxLevel = maxLevelFor(schedule.category);

      for (var i = 0; i < fallbackParams.compoundCount; i++) {
        final slotKey = '${schedule.category}_${ExerciseType.compound}_$i';
        final ex = await _resolveExercise(slotKey, () async {
          final allCompounds = await _exerciseDao.getProgressionChain(
              schedule.category, equipment);
          final available = allCompounds
              .where((e) =>
                  e.phoenixLevel <= catMaxLevel &&
                  e.exerciseType == ExerciseType.compound &&
                  !excludeIds.contains(e.id))
              .toList()
            ..sort((a, b) => b.phoenixLevel.compareTo(a.phoenixLevel));
          // Skip already-planned exercises
          final plannedIds = planned.map((p) => p.exercise.id).toSet();
          final fresh = available.where((e) => !plannedIds.contains(e.id)).toList();
          return fresh.isNotEmpty ? [fresh.first] : (available.isNotEmpty ? [available.first] : []);
        });
        if (ex != null) {
          planned.add(_toPlanned(ex, setsCompound,
              repsMinCompound, repsMaxCompound, catMaxLevel,
              restOverride: restOverride));
        }
      }

      // Accessories
      for (var i = 0; i < fallbackParams.accessoryCount; i++) {
        final slotKey = '${schedule.category}_${ExerciseType.accessory}_$i';
        final ex = await _resolveExercise(slotKey, () async {
          final accessories = await _exerciseDao.getAccessories(
            category: schedule.category, equipment: equipment,
            excludeIds: excludeIds,
          );
          final plannedIds = planned.map((p) => p.exercise.id).toSet();
          final fresh = accessories.where((e) => !plannedIds.contains(e.id)).toList();
          return fresh.isNotEmpty ? [fresh.first] : (accessories.isNotEmpty ? [accessories.first] : []);
        });
        if (ex != null) {
          planned.add(_toPlanned(ex, setsAccessory,
              ex.defaultRepsMin, ex.defaultRepsMax, catMaxLevel,
              restOverride: restOverride));
        }
      }
    }

    // Core (2 exercises on all days)
    final coreMaxLevel = maxLevelFor(ExerciseCategory.core);
    for (var i = 0; i < 2; i++) {
      final slotKey = '${ExerciseCategory.core}_core_$i';
      final ex = await _resolveExercise(slotKey, () async {
        final coreExercises = await _exerciseDao.getCoreExercises(
          maxLevel: coreMaxLevel, excludeIds: excludeIds,
        );
        final plannedIds = planned.map((p) => p.exercise.id).toSet();
        final fresh = coreExercises.where((e) => !plannedIds.contains(e.id)).toList();
        return fresh.isNotEmpty ? [fresh.first] : (coreExercises.isNotEmpty ? [coreExercises.first] : []);
      });
      if (ex != null) {
        planned.add(_toPlanned(ex, 3, ex.defaultRepsMin, ex.defaultRepsMax, coreMaxLevel,
            restOverride: restOverride));
      }
    }

    // Apply exercise modifications (graduated severity)
    if (exerciseModifications.isNotEmpty) {
      for (var i = planned.length - 1; i >= 0; i--) {
        final mod = exerciseModifications[planned[i].exercise.id];
        if (mod == null) continue;
        final action = mod['action'] as String?;
        switch (action) {
          case 'exclude':
            planned.removeAt(i);
          case 'substitute':
            final subId = mod['substituteId'] as int?;
            if (subId != null) {
              final subs = await _exerciseDao.getByIds({subId});
              if (subs.isNotEmpty) {
                final original = planned[i];
                planned[i] = _toPlanned(subs.first, original.sets,
                    original.repsMin, original.repsMax, defaultMaxLevel,
                    restOverride: restOverride);
              } else {
                planned.removeAt(i); // substitute not found, exclude
              }
            } else {
              planned.removeAt(i);
            }
          case 'adapt':
            final overrides = mod['paramOverrides'] as Map<String, dynamic>?;
            final rpeCap = (overrides?['rpe_cap'] as num?)?.toInt();
            final noExplosive = overrides?['no_explosive'] as bool? ?? false;
            final original = planned[i];
            // Cap RPE by reducing sets/reps range slightly
            final adaptedSets = rpeCap != null && rpeCap <= 6
                ? (original.sets > 3 ? original.sets - 1 : original.sets)
                : original.sets;
            // Remove explosive exercises entirely if flagged
            if (noExplosive && original.exercise.name.toLowerCase().contains('jump')) {
              planned.removeAt(i);
            } else {
              planned[i] = PlannedExercise(
                exercise: original.exercise,
                sets: adaptedSets,
                repsMin: original.repsMin,
                repsMax: original.repsMax,
                restSeconds: original.restSeconds,
                tempoEcc: original.tempoEcc,
                tempoCon: original.tempoCon,
                rpeCap: rpeCap,
              );
            }
        }
      }
    }

    // Estimate duration
    final totalSets = planned.fold<int>(0, (sum, p) => sum + p.sets);
    final estimatedMinutes = (totalSets * 1.5 + planned.length * 2).round();

    // Phase description from periodization
    String dayName = schedule.dayName;
    if (periodParams != null) {
      final stimulusLabel = periodParams.stimulus.name;
      dayName = '${schedule.dayName} — $stimulusLabel';
    }

    return WorkoutPlan(
      dayName: dayName,
      type: schedule.type,
      exercises: planned,
      estimatedMinutes: estimatedMinutes,
    );
  }

  PlannedExercise _toPlanned(Exercise ex, int sets, int repsMin, int repsMax, int maxLevel, {int? restOverride}) {
    final restSeconds = restOverride ?? RestTimes.betweenSets(
      exerciseType: ex.exerciseType,
      phoenixLevel: maxLevel,
    );
    return PlannedExercise(
      exercise: ex,
      sets: sets,
      repsMin: repsMin,
      repsMax: repsMax,
      tempoEcc: ex.defaultTempoEcc,
      tempoCon: ex.defaultTempoCon,
      restSeconds: restSeconds,
    );
  }

  int _tierToMaxLevel(String tier) {
    switch (tier) {
      case 'beginner':
        return 2;
      case 'intermediate':
        return 4;
      case 'advanced':
        return 6;
      default:
        return 2;
    }
  }
}
