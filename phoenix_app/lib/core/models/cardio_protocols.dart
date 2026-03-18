import 'cardio_plan.dart';

/// Protocolli cardio strutturati basati su evidenze scientifiche.
///
/// Tre protocolli principali:
/// - **Tabata** (Tabata et al. 1996) — HIIT breve ad alta intensita
/// - **Norwegian 4x4** (Wisloff et al. 2007) — intervalli lunghi sub-massimali
/// - **Zone 2 Only** — steady-state aerobico per deload o sessioni standalone
class CardioProtocols {
  CardioProtocols._();

  // ── Tabata (Tabata 1996) ─────────────────────────────────────
  //
  // Warmup: 5min
  // Round: lavoro/recupero ad altissima intensita
  // Zona 2: 20-25min post-HIIT
  // Cooldown: 5min
  //
  // Progressione per tier:
  //   beginner:     20s/40s, 6 round
  //   intermediate: 20s/20s, 8 round
  //   advanced:     20s/10s, 8 round

  /// Suggerimenti esercizi per tier Tabata.
  static const _tabataExercises = {
    'beginner': [
      'Jumping jacks',
      'Marcia sul posto',
      'Squat a corpo libero',
      'Toe taps',
    ],
    'intermediate': [
      'Mountain climbers',
      'Burpees (senza push-up)',
      'High knees',
      'Jump squats',
    ],
    'advanced': [
      'Burpees con push-up',
      'Box jumps',
      'Jumping lunges',
      'Squat-press',
    ],
  };

  /// Protocollo Tabata.
  ///
  /// [tier] deve essere 'beginner', 'intermediate', o 'advanced'.
  static CardioPlan tabata({required String tier}) {
    final (workSec, restSec, numRounds) = switch (tier) {
      'beginner' => (20, 40, 6),
      'intermediate' => (20, 20, 8),
      'advanced' => (20, 10, 8),
      _ => (20, 20, 8), // fallback intermedio
    };

    final exercises = _tabataExercises[tier] ?? _tabataExercises['intermediate']!;

    final rounds = List.generate(numRounds, (i) {
      return HiitRound(
        workSeconds: workSec,
        restSeconds: restSec,
        targetZone: 'zone5',
        exerciseSuggestion: exercises[i % exercises.length],
      );
    });

    // Durata HIIT in minuti (arrotondato per eccesso)
    final hiitMinutes = (numRounds * (workSec + restSec) / 60).ceil();
    const warmup = 5;
    const zone2 = 22; // 20-25min, valore medio
    const cooldown = 5;

    return CardioPlan(
      protocolName: 'tabata',
      warmupMinutes: warmup,
      rounds: rounds,
      zone2Minutes: zone2,
      cooldownMinutes: cooldown,
      targetHrZone: 'zone5',
      estimatedMinutes: warmup + hiitMinutes + zone2 + cooldown,
    );
  }

  // ── Norwegian 4x4 (Wisloff 2007) ────────────────────────────
  //
  // Warmup: 5-10min
  // Round: 4min @85-95% HR max / 3min @60-70% HR max
  // Cooldown: 5min
  //
  // Progressione per tier:
  //   beginner:     3 round, 80-85% HR max
  //   intermediate: 4 round, 85-90% HR max
  //   advanced:     4-5 round, 90-95% HR max

  /// Protocollo Norwegian 4x4.
  ///
  /// [tier] deve essere 'beginner', 'intermediate', o 'advanced'.
  static CardioPlan norwegian({required String tier}) {
    final (numRounds, targetZone, warmup) = switch (tier) {
      'beginner' => (3, 'zone4', 10),      // 80-85%, warmup piu lungo
      'intermediate' => (4, 'zone4', 7),    // 85-90%
      'advanced' => (5, 'norwegian_work', 5), // 90-95%
      _ => (4, 'zone4', 7),
    };

    final rounds = List.generate(numRounds, (_) {
      return const HiitRound(
        workSeconds: 240,  // 4 minuti
        restSeconds: 180,  // 3 minuti recupero attivo
        targetZone: 'norwegian_work',
      );
    });

    const cooldown = 5;
    // Ogni round = 7min, + warmup + cooldown
    final estimated = warmup + (numRounds * 7) + cooldown;

    return CardioPlan(
      protocolName: 'norwegian',
      warmupMinutes: warmup,
      rounds: rounds,
      zone2Minutes: 0, // no zona 2 separata, il recupero e gia in zona 2
      cooldownMinutes: cooldown,
      targetHrZone: targetZone,
      estimatedMinutes: estimated,
    );
  }

  // ── Zone 2 Only ──────────────────────────────────────────────
  //
  // 30-40min @60-70% HR max
  // Per settimane di deload o sessioni standalone

  /// Sessione solo zona 2 (steady-state aerobico).
  ///
  /// Durata: 35min (range consigliato: 30-40min).
  static CardioPlan zone2Only() {
    const warmup = 5;
    const zone2 = 35;
    const cooldown = 5;

    return const CardioPlan(
      protocolName: 'zone2_only',
      warmupMinutes: warmup,
      rounds: [],
      zone2Minutes: zone2,
      cooldownMinutes: cooldown,
      targetHrZone: 'zone2',
      estimatedMinutes: warmup + zone2 + cooldown,
    );
  }
}
