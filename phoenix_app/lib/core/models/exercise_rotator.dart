import 'dart:math';

import '../database/database.dart';
import '../database/tables.dart';

/// Defines a position in the workout template where an exercise can be placed.
class RotationSlot {
  final String category; // 'push'/'pull'/'squat'/'hinge'/'core'
  final String exerciseType; // 'compound'/'accessory'/'core'
  final int slotIndex; // 0, 1, 2...

  const RotationSlot({
    required this.category,
    required this.exerciseType,
    required this.slotIndex,
  });

  /// Unique key for this slot: "${category}_${exerciseType}_${slotIndex}".
  String get key => '${category}_${exerciseType}_$slotIndex';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RotationSlot &&
          category == other.category &&
          exerciseType == other.exerciseType &&
          slotIndex == other.slotIndex;

  @override
  int get hashCode => Object.hash(category, exerciseType, slotIndex);

  @override
  String toString() => 'RotationSlot($key)';
}

/// Stores a mesocycle's exercise assignments.
class MesocycleExerciseSelection {
  final int mesocycleNumber;

  /// Slot key → exercise ID.
  final Map<String, int> selections;

  /// Exercises the user wants to keep across mesocycles.
  final Set<int> lockedExerciseIds;

  /// Exercises to exclude (physical limitations, injuries).
  final Set<int> excludedExerciseIds;

  const MesocycleExerciseSelection({
    required this.mesocycleNumber,
    required this.selections,
    this.lockedExerciseIds = const {},
    this.excludedExerciseIds = const {},
  });

  /// All exercise IDs selected in this mesocycle.
  Set<int> get allExerciseIds => selections.values.toSet();

  /// Serialize to JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'mesocycleNumber': mesocycleNumber,
        'selections': selections,
        'lockedExerciseIds': lockedExerciseIds.toList(),
        'excludedExerciseIds': excludedExerciseIds.toList(),
      };

  /// Deserialize from JSON-compatible map.
  factory MesocycleExerciseSelection.fromJson(Map<String, dynamic> json) {
    return MesocycleExerciseSelection(
      mesocycleNumber: json['mesocycleNumber'] as int,
      selections: Map<String, int>.from(json['selections'] as Map),
      lockedExerciseIds:
          (json['lockedExerciseIds'] as List?)?.map((e) => e as int).toSet() ??
              {},
      excludedExerciseIds: (json['excludedExerciseIds'] as List?)
              ?.map((e) => e as int)
              .toSet() ??
          {},
    );
  }
}

/// Result of a mesocyclic exercise rotation.
class RotationResult {
  /// Slot key → selected exercise ID.
  final Map<String, int> selections;

  /// How many exercises are new compared to the previous mesocycle.
  final int newExerciseCount;

  /// Total number of exercise slots filled.
  final int totalExerciseCount;

  /// Overlap percentage with previous mesocycle (target: ≤30%).
  final double overlapPercentage;

  const RotationResult({
    required this.selections,
    required this.newExerciseCount,
    required this.totalExerciseCount,
    required this.overlapPercentage,
  });

  /// True if the rotation meets the ≥70% novelty target.
  bool get meetsNoveltyTarget => overlapPercentage <= 30.0;

  @override
  String toString() =>
      'RotationResult($newExerciseCount/$totalExerciseCount new, '
      '${overlapPercentage.toStringAsFixed(1)}% overlap)';
}

/// Selects exercises for each mesocycle, ensuring variety across cycles.
///
/// Algorithm:
/// 1. For each slot, get pool of compatible exercises (equipment + level).
/// 2. Exclude exercises used in the PREVIOUS mesocycle.
/// 3. Prefer exercises not used in the last 2 mesocycles.
/// 4. If pool too small (<2 options after filtering), allow repetition.
/// 5. Deterministic shuffle: mesocycleNumber as random seed.
///
/// Target: ≥70% different exercises each mesocycle vs previous.
class ExerciseRotator {
  /// Minimum pool size before we allow repetition from previous mesocycle.
  static const _minPoolSize = 2;

  /// Select exercises for a mesocycle.
  ///
  /// [slots] defines all positions to fill.
  /// [exercisePool] is the full DB of exercises to choose from.
  /// [mesocycleNumber] is the current mesocycle (used as random seed).
  /// [equipment] filters exercises by equipment compatibility.
  /// [maxLevel] filters exercises by maximum Phoenix level.
  /// [previousSelections] is a list of past mesocycle selections (most recent
  /// first), used to maximize variety. Typically the last 2 mesocycles.
  /// [lockedExerciseIds] are exercises the user wants to keep (skip rotation).
  /// [excludedExerciseIds] are exercises to never select (physical limitations).
  RotationResult selectForMesocycle({
    required List<RotationSlot> slots,
    required List<Exercise> exercisePool,
    required int mesocycleNumber,
    required String equipment,
    required int maxLevel,
    List<MesocycleExerciseSelection> previousSelections = const [],
    Set<int> lockedExerciseIds = const {},
    Set<int> excludedExerciseIds = const {},
  }) {
    final rng = Random(mesocycleNumber);
    final selections = <String, int>{};

    // Build previous mesocycle exercise sets for exclusion/preference.
    final previousIds = previousSelections.isNotEmpty
        ? previousSelections.first.allExerciseIds
        : <int>{};
    final olderIds = previousSelections.length >= 2
        ? previousSelections[1].allExerciseIds
        : <int>{};
    final recentIds = {...previousIds, ...olderIds};

    // Track exercises already selected in this mesocycle to avoid duplicates.
    final usedInThisCycle = <int>{};

    for (final slot in slots) {
      // Check if there is a locked exercise for this slot from the previous
      // mesocycle — if so, keep it.
      final previousSlotId = previousSelections.isNotEmpty
          ? previousSelections.first.selections[slot.key]
          : null;
      if (previousSlotId != null &&
          lockedExerciseIds.contains(previousSlotId) &&
          !excludedExerciseIds.contains(previousSlotId)) {
        selections[slot.key] = previousSlotId;
        usedInThisCycle.add(previousSlotId);
        continue;
      }

      // Build compatible pool for this slot.
      final compatible = _filterPool(
        exercisePool,
        category: slot.category,
        exerciseType: slot.exerciseType,
        equipment: equipment,
        maxLevel: maxLevel,
        excludedIds: excludedExerciseIds,
      );

      if (compatible.isEmpty) continue;

      // Remove exercises already used in this cycle.
      var pool = compatible
          .where((e) => !usedInThisCycle.contains(e.id))
          .toList();
      if (pool.isEmpty) pool = compatible;

      // Try to exclude exercises from the previous mesocycle.
      var filtered = pool.where((e) => !previousIds.contains(e.id)).toList();

      if (filtered.length < _minPoolSize) {
        // Pool too small — allow repetition but still prefer non-recent.
        filtered = pool;
      } else {
        // Within the non-previous pool, prefer exercises not used in last 2.
        final fresh =
            filtered.where((e) => !recentIds.contains(e.id)).toList();
        if (fresh.isNotEmpty) {
          filtered = fresh;
        }
      }

      // Deterministic shuffle.
      _deterministicShuffle(filtered, rng);

      // Pick the first exercise (highest priority after shuffle).
      // Prefer higher Phoenix level within the filtered set for progression.
      filtered.sort((a, b) {
        // Primary: higher level first.
        final levelCmp = b.phoenixLevel.compareTo(a.phoenixLevel);
        if (levelCmp != 0) return levelCmp;
        // Secondary: deterministic tiebreak (already shuffled).
        return 0;
      });

      final selected = filtered.first;
      selections[slot.key] = selected.id;
      usedInThisCycle.add(selected.id);
    }

    // Compute novelty metrics.
    final selectedIds = selections.values.toSet();
    final repeatedFromPrevious = selectedIds.intersection(previousIds);
    final totalCount = selections.length;
    final newCount = totalCount - repeatedFromPrevious.length;
    final overlap = totalCount > 0
        ? (repeatedFromPrevious.length / totalCount) * 100.0
        : 0.0;

    return RotationResult(
      selections: selections,
      newExerciseCount: newCount,
      totalExerciseCount: totalCount,
      overlapPercentage: overlap,
    );
  }

  /// Get pool of exercises with alternatives for a single slot.
  ///
  /// Returns a map with a single key (slot key) → list of exercise IDs
  /// (selected + alternatives), useful for showing swap options in the UI.
  Map<String, List<int>> getAlternatives({
    required RotationSlot slot,
    required List<Exercise> exercisePool,
    required String equipment,
    required int maxLevel,
    Set<int> excludedExerciseIds = const {},
    int maxAlternatives = 3,
  }) {
    final compatible = _filterPool(
      exercisePool,
      category: slot.category,
      exerciseType: slot.exerciseType,
      equipment: equipment,
      maxLevel: maxLevel,
      excludedIds: excludedExerciseIds,
    );

    // Sort by level descending.
    compatible.sort((a, b) => b.phoenixLevel.compareTo(a.phoenixLevel));

    final ids = compatible
        .take(maxAlternatives + 1)
        .map((e) => e.id)
        .toList();

    return {slot.key: ids};
  }

  /// Generate the standard set of rotation slots for a strength workout day.
  ///
  /// Uses tier parameters to determine compound/accessory/core counts.
  static List<RotationSlot> slotsForStrengthDay({
    required String category,
    required int compoundCount,
    required int accessoryCount,
    int coreCount = 2,
  }) {
    final slots = <RotationSlot>[];

    for (var i = 0; i < compoundCount; i++) {
      slots.add(RotationSlot(
        category: category,
        exerciseType: ExerciseType.compound,
        slotIndex: i,
      ));
    }

    for (var i = 0; i < accessoryCount; i++) {
      slots.add(RotationSlot(
        category: category,
        exerciseType: ExerciseType.accessory,
        slotIndex: i,
      ));
    }

    for (var i = 0; i < coreCount; i++) {
      slots.add(RotationSlot(
        category: ExerciseCategory.core,
        exerciseType: ExerciseType.core,
        slotIndex: i,
      ));
    }

    return slots;
  }

  /// Generate slots for a full-body power day (one compound per category + core).
  static List<RotationSlot> slotsForPowerDay({int coreCount = 2}) {
    final categories = [
      ExerciseCategory.push,
      ExerciseCategory.pull,
      ExerciseCategory.squat,
      ExerciseCategory.hinge,
    ];

    final slots = <RotationSlot>[];
    for (final cat in categories) {
      slots.add(RotationSlot(
        category: cat,
        exerciseType: ExerciseType.compound,
        slotIndex: 0,
      ));
    }

    for (var i = 0; i < coreCount; i++) {
      slots.add(RotationSlot(
        category: ExerciseCategory.core,
        exerciseType: ExerciseType.core,
        slotIndex: i,
      ));
    }

    return slots;
  }

  /// Filter the exercise pool by category, type, equipment, and level.
  List<Exercise> _filterPool(
    List<Exercise> pool, {
    required String category,
    required String exerciseType,
    required String equipment,
    required int maxLevel,
    required Set<int> excludedIds,
  }) {
    return pool.where((e) {
      if (e.category != category) return false;
      if (e.exerciseType != exerciseType) return false;
      if (e.phoenixLevel > maxLevel) return false;
      if (excludedIds.contains(e.id)) return false;
      // Equipment compatibility: 'all' matches any equipment.
      if (e.equipment != equipment && e.equipment != Equipment.all) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Fisher-Yates shuffle with a seeded Random for reproducibility.
  void _deterministicShuffle(List<Exercise> list, Random rng) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = rng.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
}
