/// Sessione cardio strutturata.
///
/// Un [CardioPlan] descrive una sessione completa: warmup, round HIIT
/// (opzionali), zona 2 steady-state, cooldown.
class CardioPlan {
  /// Identificativo protocollo: 'tabata' / 'norwegian' / 'zone2_only'
  final String protocolName;

  /// Minuti di riscaldamento.
  final int warmupMinutes;

  /// Round HIIT (vuoto per sessioni solo zona 2).
  final List<HiitRound> rounds;

  /// Minuti di zona 2 steady-state dopo i round HIIT.
  final int zone2Minutes;

  /// Minuti di defaticamento.
  final int cooldownMinutes;

  /// Zona HR target principale (es. 'zone2', 'hiit_work').
  final String targetHrZone;

  /// Durata totale stimata in minuti.
  final int estimatedMinutes;

  const CardioPlan({
    required this.protocolName,
    required this.warmupMinutes,
    required this.rounds,
    required this.zone2Minutes,
    required this.cooldownMinutes,
    required this.targetHrZone,
    required this.estimatedMinutes,
  });

  /// True se la sessione include round HIIT.
  bool get isHiit => rounds.isNotEmpty;

  /// Durata totale dei round HIIT in secondi.
  int get hiitTotalSeconds =>
      rounds.fold(0, (sum, r) => sum + r.totalSeconds);
}

/// Singolo round di un protocollo HIIT.
class HiitRound {
  /// Durata fase di lavoro in secondi.
  final int workSeconds;

  /// Durata fase di recupero in secondi.
  final int restSeconds;

  /// Zona HR target durante il lavoro (es. 'zone5', 'zone4').
  final String targetZone;

  /// Suggerimento esercizio (opzionale).
  final String? exerciseSuggestion;

  const HiitRound({
    required this.workSeconds,
    required this.restSeconds,
    required this.targetZone,
    this.exerciseSuggestion,
  });

  /// Durata totale del round (lavoro + recupero) in secondi.
  int get totalSeconds => workSeconds + restSeconds;
}
