import 'dart:math' show min;

/// Periodization engine for Phoenix Protocol training.
///
/// Three models by tier:
/// - **Beginner:** Linear Progression (4-week cycles)
/// - **Intermediate:** Daily Undulating Periodization (DUP, 5 stimuli)
/// - **Advanced:** Block Periodization (Verkhoshansky, 4 blocks)

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

/// Training stimulus type for DUP / block labeling.
enum Stimulus {
  ipertrofia,
  forza,
  resistenza,
  potenza,
  volume,
  deload,
}

/// Current position within the periodization cycle.
class MesocycleState {
  /// 'beginner', 'intermediate', 'advanced'
  final String tier;

  /// Sequential mesocycle count (1-based).
  final int mesocycleNumber;

  /// Week within the current mesocycle (1-based).
  final int weekInMesocycle;

  /// Current block name (advanced only): accumulo / trasformazione /
  /// realizzazione / deload.  Null for beginner/intermediate.
  final String? currentBlock;

  /// When this mesocycle started.
  final DateTime startedAt;

  /// When it was completed (null = in progress).
  final DateTime? completedAt;

  const MesocycleState({
    required this.tier,
    required this.mesocycleNumber,
    required this.weekInMesocycle,
    this.currentBlock,
    required this.startedAt,
    this.completedAt,
  });

  MesocycleState copyWith({
    String? tier,
    int? mesocycleNumber,
    int? weekInMesocycle,
    String? currentBlock,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return MesocycleState(
      tier: tier ?? this.tier,
      mesocycleNumber: mesocycleNumber ?? this.mesocycleNumber,
      weekInMesocycle: weekInMesocycle ?? this.weekInMesocycle,
      currentBlock: currentBlock ?? this.currentBlock,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'tier': tier,
        'mesocycleNumber': mesocycleNumber,
        'weekInMesocycle': weekInMesocycle,
        'currentBlock': currentBlock,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory MesocycleState.fromJson(Map<String, dynamic> json) {
    return MesocycleState(
      tier: json['tier'] as String,
      mesocycleNumber: json['mesocycleNumber'] as int,
      weekInMesocycle: json['weekInMesocycle'] as int,
      currentBlock: json['currentBlock'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
}

/// Concrete training parameters for a single workout session.
class WorkoutParams {
  final Stimulus stimulus;
  final int setsCompound;
  final int setsAccessory;
  final int repsMin;
  final int repsMax;

  /// % of estimated 1RM (0-100).
  final int loadPercentMin;
  final int loadPercentMax;

  final int restSeconds;
  final int targetRPE;

  const WorkoutParams({
    required this.stimulus,
    required this.setsCompound,
    required this.setsAccessory,
    required this.repsMin,
    required this.repsMax,
    required this.loadPercentMin,
    required this.loadPercentMax,
    required this.restSeconds,
    required this.targetRPE,
  });

  String get repsLabel => repsMin == repsMax ? '$repsMin' : '$repsMin-$repsMax';
}

// ---------------------------------------------------------------------------
// Engine
// ---------------------------------------------------------------------------

class PeriodizationEngine {
  const PeriodizationEngine();

  // ---- Public API --------------------------------------------------------

  /// Return the training parameters for a given day.
  ///
  /// [weekday] 1=Monday … 7=Sunday (ISO 8601).
  WorkoutParams getParamsForDay(
    String tier,
    MesocycleState state,
    int weekday,
  ) {
    switch (tier) {
      case 'beginner':
        return _beginnerParams(state);
      case 'intermediate':
        return _dupParams(state, weekday);
      case 'advanced':
        return _blockParams(state);
      default:
        return _beginnerParams(state);
    }
  }

  /// Advance to the next week (or next mesocycle / block).
  MesocycleState advanceWeek(MesocycleState current) {
    switch (current.tier) {
      case 'beginner':
        return _advanceBeginner(current);
      case 'intermediate':
        return _advanceIntermediate(current);
      case 'advanced':
        return _advanceAdvanced(current);
      default:
        return _advanceBeginner(current);
    }
  }

  /// Whether a deload week should be inserted now.
  ///
  /// Triggers:
  /// 1. HRV recovery low/veryLow for 3+ consecutive days
  /// 2. Scheduled end-of-mesocycle
  /// 3. Average RPE of last week >= 9.0
  /// 4. Cortisol biomarker alert
  bool shouldDeload(
    MesocycleState state, {
    List<double>? recentRPEs,
    bool biomarkerAlert = false,
    String? recoveryStatus, // 'veryLow', 'low', 'normal', etc.
    int recoveryLowDays = 0, // consecutive days of low/veryLow
  }) {
    // HRV-based deload trigger
    if (recoveryLowDays >= 3 &&
        (recoveryStatus == 'veryLow' || recoveryStatus == 'low')) {
      return true;
    }

    // Cortisol / biomarker override
    if (biomarkerAlert) return true;

    // RPE trend override
    if (recentRPEs != null && recentRPEs.isNotEmpty) {
      final avg = recentRPEs.reduce((a, b) => a + b) / recentRPEs.length;
      if (avg >= 9.0) return true;
    }

    // Scheduled deload by tier
    switch (state.tier) {
      case 'beginner':
        // Every 12 weeks (3 complete 4-week cycles)
        final totalWeeks =
            (state.mesocycleNumber - 1) * 4 + state.weekInMesocycle;
        return totalWeeks > 0 && totalWeeks % 12 == 0;
      case 'intermediate':
        // End of 6-week mesocycle
        return state.weekInMesocycle >= 7; // week 7 = deload week
      case 'advanced':
        return state.currentBlock == 'deload';
      default:
        return false;
    }
  }

  /// Human-readable description of the current phase (Italian).
  String currentPhaseDescription(MesocycleState state) {
    switch (state.tier) {
      case 'beginner':
        return _beginnerDescription(state);
      case 'intermediate':
        return _intermediateDescription(state);
      case 'advanced':
        return _advancedDescription(state);
      default:
        return 'Fase sconosciuta';
    }
  }

  // ---- Deload params (shared) --------------------------------------------

  static const _deloadParams = WorkoutParams(
    stimulus: Stimulus.deload,
    setsCompound: 2,
    setsAccessory: 2,
    repsMin: 8,
    repsMax: 10,
    loadPercentMin: 50,
    loadPercentMax: 60,
    restSeconds: 90,
    targetRPE: 5,
  );

  // ---- Beginner: Linear Progression --------------------------------------

  WorkoutParams _beginnerParams(MesocycleState state) {
    // Check for scheduled deload (every 12 weeks)
    final totalWeeks =
        (state.mesocycleNumber - 1) * 4 + state.weekInMesocycle;
    if (totalWeeks > 0 && totalWeeks % 12 == 0) {
      return _deloadParams;
    }

    final week = state.weekInMesocycle;
    switch (week) {
      case 1:
        return const WorkoutParams(
          stimulus: Stimulus.ipertrofia,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 10,
          repsMax: 10,
          loadPercentMin: 65,
          loadPercentMax: 70,
          restSeconds: 90,
          targetRPE: 7,
        );
      case 2:
        return const WorkoutParams(
          stimulus: Stimulus.ipertrofia,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 12,
          repsMax: 12,
          loadPercentMin: 60,
          loadPercentMax: 65,
          restSeconds: 90,
          targetRPE: 7,
        );
      case 3:
        return const WorkoutParams(
          stimulus: Stimulus.resistenza,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 15,
          repsMax: 15,
          loadPercentMin: 55,
          loadPercentMax: 60,
          restSeconds: 75,
          targetRPE: 7,
        );
      case 4:
        // Reset: back to 10 reps with increased weight
        return const WorkoutParams(
          stimulus: Stimulus.ipertrofia,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 10,
          repsMax: 10,
          loadPercentMin: 70,
          loadPercentMax: 75,
          restSeconds: 90,
          targetRPE: 7,
        );
      default:
        return const WorkoutParams(
          stimulus: Stimulus.ipertrofia,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 10,
          repsMax: 10,
          loadPercentMin: 65,
          loadPercentMax: 70,
          restSeconds: 90,
          targetRPE: 7,
        );
    }
  }

  MesocycleState _advanceBeginner(MesocycleState current) {
    if (current.weekInMesocycle < 4) {
      return current.copyWith(weekInMesocycle: current.weekInMesocycle + 1);
    }
    // New 4-week cycle
    return MesocycleState(
      tier: current.tier,
      mesocycleNumber: current.mesocycleNumber + 1,
      weekInMesocycle: 1,
      startedAt: DateTime.now(),
    );
  }

  String _beginnerDescription(MesocycleState state) {
    final totalWeeks =
        (state.mesocycleNumber - 1) * 4 + state.weekInMesocycle;
    if (totalWeeks > 0 && totalWeeks % 12 == 0) {
      return 'Settimana di scarico — recupero attivo';
    }
    final week = state.weekInMesocycle;
    switch (week) {
      case 1:
        return 'Ciclo ${state.mesocycleNumber}, Settimana 1 — 4×10 base';
      case 2:
        return 'Ciclo ${state.mesocycleNumber}, Settimana 2 — 4×12 volume';
      case 3:
        return 'Ciclo ${state.mesocycleNumber}, Settimana 3 — 4×15 resistenza';
      case 4:
        return 'Ciclo ${state.mesocycleNumber}, Settimana 4 — 4×10 + aumento carico';
      default:
        return 'Progressione lineare — Ciclo ${state.mesocycleNumber}';
    }
  }

  // ---- Intermediate: Daily Undulating Periodization ----------------------

  /// DUP stimulus by weekday.
  /// 1=Mon Push Ipertrofia, 2=Tue Squat Forza, 4=Thu Pull Ipertrofia,
  /// 5=Fri Hinge Resistenza, 7=Sun Power Potenza.
  /// Cardio days (3, 6) return deload-like params (active recovery).
  WorkoutParams _dupParams(MesocycleState state, int weekday) {
    // Deload week (week 7 in a 6+1 mesocycle)
    if (state.weekInMesocycle >= 7) return _deloadParams;

    // RPE progression within mesocycle
    final targetRPE = _dupRPE(state.weekInMesocycle);

    switch (weekday) {
      case 1: // Monday — Push Ipertrofia
        return WorkoutParams(
          stimulus: Stimulus.ipertrofia,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 8,
          repsMax: 12,
          loadPercentMin: 65,
          loadPercentMax: 75,
          restSeconds: 90,
          targetRPE: targetRPE,
        );
      case 2: // Tuesday — Squat Forza
        return WorkoutParams(
          stimulus: Stimulus.forza,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 3,
          repsMax: 6,
          loadPercentMin: 75,
          loadPercentMax: 85,
          restSeconds: 180,
          targetRPE: targetRPE,
        );
      case 4: // Thursday — Pull Ipertrofia
        return WorkoutParams(
          stimulus: Stimulus.ipertrofia,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 8,
          repsMax: 12,
          loadPercentMin: 65,
          loadPercentMax: 75,
          restSeconds: 90,
          targetRPE: targetRPE,
        );
      case 5: // Friday — Hinge Resistenza
        return WorkoutParams(
          stimulus: Stimulus.resistenza,
          setsCompound: 3,
          setsAccessory: 3,
          repsMin: 15,
          repsMax: 20,
          loadPercentMin: 50,
          loadPercentMax: 65,
          restSeconds: 60,
          targetRPE: targetRPE,
        );
      case 7: // Sunday — Power Potenza
        return WorkoutParams(
          stimulus: Stimulus.potenza,
          setsCompound: 5,
          setsAccessory: 2,
          repsMin: 3,
          repsMax: 5,
          loadPercentMin: 70,
          loadPercentMax: 80,
          restSeconds: 120,
          targetRPE: targetRPE,
        );
      default:
        // Wednesday / Saturday — active recovery / cardio
        return _deloadParams;
    }
  }

  /// RPE ramp: weeks 1-2 → 7, weeks 3-4 → 8, weeks 5-6 → 9.
  int _dupRPE(int weekInMesocycle) {
    if (weekInMesocycle <= 2) return 7;
    if (weekInMesocycle <= 4) return 8;
    return 9;
  }

  MesocycleState _advanceIntermediate(MesocycleState current) {
    if (current.weekInMesocycle < 7) {
      // Weeks 1-6 training + week 7 deload
      return current.copyWith(weekInMesocycle: current.weekInMesocycle + 1);
    }
    // New mesocycle after deload
    return MesocycleState(
      tier: current.tier,
      mesocycleNumber: current.mesocycleNumber + 1,
      weekInMesocycle: 1,
      startedAt: DateTime.now(),
    );
  }

  String _intermediateDescription(MesocycleState state) {
    if (state.weekInMesocycle >= 7) {
      return 'Mesociclo ${state.mesocycleNumber} — Settimana di scarico';
    }
    final rpe = _dupRPE(state.weekInMesocycle);
    return 'Mesociclo ${state.mesocycleNumber}, '
        'Settimana ${state.weekInMesocycle} — '
        'DUP (RPE $rpe)';
  }

  // ---- Advanced: Block Periodization (Verkhoshansky) ---------------------

  /// Block definitions: name → (weeks, params).
  static const _blocks = ['accumulo', 'trasformazione', 'realizzazione', 'deload'];

  /// Block durations in weeks.
  static const _blockWeeks = {
    'accumulo': 4,
    'trasformazione': 4,
    'realizzazione': 3,
    'deload': 1,
  };

  WorkoutParams _blockParams(MesocycleState state) {
    final block = state.currentBlock ?? 'accumulo';
    final weekInBlock = state.weekInMesocycle;

    switch (block) {
      case 'accumulo':
        // Intra-block load progression: +2.5% per week, clamped to 100%
        final loadBump = (weekInBlock - 1) * 3;
        return WorkoutParams(
          stimulus: Stimulus.volume,
          setsCompound: 5,
          setsAccessory: 4,
          repsMin: 8,
          repsMax: 12,
          loadPercentMin: min(100, 60 + loadBump),
          loadPercentMax: min(100, 75 + loadBump),
          restSeconds: 90,
          targetRPE: 7 + (weekInBlock > 2 ? 1 : 0),
        );
      case 'trasformazione':
        final loadBump = (weekInBlock - 1) * 3;
        return WorkoutParams(
          stimulus: Stimulus.forza,
          setsCompound: 4,
          setsAccessory: 3,
          repsMin: 3,
          repsMax: 6,
          loadPercentMin: min(100, 75 + loadBump),
          loadPercentMax: min(100, 90 + loadBump),
          restSeconds: 180,
          targetRPE: 8 + (weekInBlock > 2 ? 1 : 0),
        );
      case 'realizzazione':
        final loadBump = (weekInBlock - 1) * 3;
        return WorkoutParams(
          stimulus: Stimulus.potenza,
          setsCompound: 3,
          setsAccessory: 2,
          repsMin: 1,
          repsMax: 3,
          loadPercentMin: min(100, 85 + loadBump),
          loadPercentMax: min(100, 95 + loadBump),
          restSeconds: 240,
          targetRPE: 9,
        );
      case 'deload':
        return _deloadParams;
      default:
        return _deloadParams;
    }
  }

  MesocycleState _advanceAdvanced(MesocycleState current) {
    final block = current.currentBlock ?? 'accumulo';
    final maxWeeks = _blockWeeks[block] ?? 4;

    if (current.weekInMesocycle < maxWeeks) {
      // Still within current block
      return current.copyWith(weekInMesocycle: current.weekInMesocycle + 1);
    }

    // Move to next block
    final blockIndex = _blocks.indexOf(block);
    if (blockIndex < _blocks.length - 1) {
      // Next block in sequence
      final nextBlock = _blocks[blockIndex + 1];
      return current.copyWith(
        weekInMesocycle: 1,
        currentBlock: nextBlock,
      );
    }

    // Completed full cycle (after deload) → new mesocycle
    return MesocycleState(
      tier: current.tier,
      mesocycleNumber: current.mesocycleNumber + 1,
      weekInMesocycle: 1,
      currentBlock: 'accumulo',
      startedAt: DateTime.now(),
    );
  }

  String _advancedDescription(MesocycleState state) {
    final block = state.currentBlock ?? 'accumulo';
    final blockLabel = _blockDisplayName(block);
    if (block == 'deload') {
      return 'Mesociclo ${state.mesocycleNumber} — Scarico attivo';
    }
    return 'Mesociclo ${state.mesocycleNumber}, '
        '$blockLabel — '
        'Settimana ${state.weekInMesocycle}/${_blockWeeks[block]}';
  }

  static String _blockDisplayName(String block) {
    switch (block) {
      case 'accumulo':
        return 'Accumulo (volume)';
      case 'trasformazione':
        return 'Trasformazione (forza massimale)';
      case 'realizzazione':
        return 'Realizzazione (picco prestazione)';
      case 'deload':
        return 'Scarico';
      default:
        return block;
    }
  }

  // ---- Factory helpers ---------------------------------------------------

  /// Create an initial state for a new user.
  static MesocycleState initialState(String tier) {
    return MesocycleState(
      tier: tier,
      mesocycleNumber: 1,
      weekInMesocycle: 1,
      currentBlock: tier == 'advanced' ? 'accumulo' : null,
      startedAt: DateTime.now(),
    );
  }
}
