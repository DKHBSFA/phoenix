import 'dart:math';

import '../database/tables.dart';

/// Template-based coach messages for different contexts.
/// Replaceable by LLM when available.
class CoachPrompts {
  static final _random = Random();

  /// Pick a random element from a list.
  static String _pick(List<String> options) =>
      options[_random.nextInt(options.length)];

  // ─── Today Screen Messages ─────────────────────────────────────

  /// Morning message when workout is pending.
  static String morningPending(String dayName, int exerciseCount, int minutes) {
    return _pick([
      'Oggi è $dayName. $exerciseCount esercizi · ~$minutes min. '
          'Concentrati sulla connessione mente-muscolo.',
      'Buongiorno. $dayName ti aspetta: $exerciseCount esercizi, ~$minutes min. '
          'Ogni rep conta.',
      '$dayName oggi. $exerciseCount movimenti, ~$minutes minuti. '
          'Qualità > quantità.',
      'Oggi si spinge su $dayName. $exerciseCount esercizi in ~$minutes min. '
          'Riscaldamento, focus, esecuzione.',
    ]);
  }

  /// Afternoon message when workout not done.
  static String afternoonReminder(String dayName) {
    return _pick([
      'Non hai ancora completato $dayName. '
          'Ancora tempo — ogni sessione conta.',
      '$dayName è ancora in attesa. Il pomeriggio è un buon momento per allenarsi.',
      'C\'è tempo per $dayName. Anche 30 minuti fanno la differenza.',
      'Il protocollo di oggi include $dayName. Non rimandare a domani.',
    ]);
  }

  /// Evening message when workout not done.
  static String eveningUrgent(String dayName) {
    return _pick([
      'Ultima chance per $dayName oggi. '
          'Anche una sessione breve è meglio di niente.',
      '$dayName oggi non è ancora fatto. Anche 20 minuti contano.',
      'La giornata sta finendo. $dayName può ancora essere completato.',
    ]);
  }

  /// Post-workout congratulations.
  static String postWorkout() {
    return _pick([
      'Ottimo lavoro oggi! Concentrati sul recupero: proteine, idratazione, sonno.',
      'Sessione completata! Proteine entro 1-2 ore, 7-8h di sonno stasera.',
      'Fatto! Recupero attivo: cammina, stretcha, bevi. Il muscolo cresce a riposo.',
      'Sessione in archivio. Ora idratazione, nutrizione, riposo.',
      'Grande lavoro! Il recupero è parte del protocollo. Non saltarlo.',
    ]);
  }

  /// Rest day message.
  static String restDay() {
    return _pick([
      'Oggi è giorno di recupero attivo. Camminata, stretching, mobilità.',
      'Recupero attivo oggi. 30 min di camminata + PNF stretching.',
      'Giorno di mobilità. Il recupero è allenamento. Camminata + stretching.',
      'Niente pesi oggi. Camminata, mobilità, respiro. Il corpo si rigenera.',
    ]);
  }

  /// All protocol items completed.
  static String allComplete() {
    return _pick([
      'Protocollo completato al 100%. Sei una macchina. Riposa.',
      'Tutto fatto. Oggi hai dato il massimo. Domani si ricomincia.',
      '6/6. Protocollo Phoenix completato. Questo è il percorso.',
      'Giornata perfetta. Ogni pilastro completato. Continua così.',
    ]);
  }

  // ─── Inter-Set Workout Cues ──────────────────────────────────

  /// Cue between sets based on RPE of last set.
  static String interSetCue({
    required String exerciseName,
    required int setNumber,
    required int totalSets,
    required int rpe,
    required String category,
  }) {
    if (rpe <= 6) {
      return _pick(_lowRpeCues(setNumber, totalSets));
    } else if (rpe <= 8) {
      return _pick(_midRpeCues(setNumber, totalSets, category));
    } else {
      return _pick(_highRpeCues(setNumber, totalSets));
    }
  }

  static List<String> _lowRpeCues(int set, int total) => [
    'Buon ritmo. Serie $set/$total completata. Puoi spingere di più nella prossima.',
    'Serie fluida. Concentrati sulla tecnica, il carico verrà.',
    'Controllo perfetto. Se l\'RPE resta basso, aumenta il carico la prossima sessione.',
    'Ottima forma. Serie $set/$total. Mantieni questa qualità.',
  ];

  static List<String> _midRpeCues(int set, int total, String category) {
    final categoryTips = switch (category) {
      ExerciseCategory.push => 'Scapole retratte, gomiti a 45°.',
      ExerciseCategory.pull => 'Inizia il movimento dalle scapole.',
      ExerciseCategory.squat => 'Ginocchia fuori, spingi coi talloni.',
      ExerciseCategory.hinge => 'Schiena neutra, stringi i glutei al top.',
      ExerciseCategory.core => 'Respira. Non trattenere il fiato.',
      _ => 'Concentrazione sulla forma.',
    };
    return [
      'Bene, zona di lavoro ideale. $categoryTips',
      'RPE giusto. Serie $set/$total. $categoryTips',
      'Buona intensità. Ancora ${total - set} serie. $categoryTips',
      'Zona perfetta. Mantieni il tempo eccentrico.',
    ];
  }

  static List<String> _highRpeCues(int set, int total) => [
    'Intenso! Serie $set/$total. Prendi qualche respiro profondo.',
    'Forte. Se la tecnica cede, riduci il carico. La forma prima di tutto.',
    'RPE alto. Se non riesci a completare le rep, va bene. Ascolta il corpo.',
    'Duro ma ce la fai. Respira. Concentrati sulla prossima serie.',
  ];

  /// Cue for first set of a new exercise.
  static String exerciseIntro(String exerciseName, String executionCues) {
    if (executionCues.isEmpty) {
      return 'Prossimo: $exerciseName. Pronto quando vuoi.';
    }
    return executionCues;
  }

  // ─── Post-Set Coach Questions ──────────────────────────────────

  /// AI coach opening question after a set.
  static String postSetQuestion({
    required String exerciseName,
    required int setNumber,
    required int totalSets,
    required int repsTarget,
  }) {
    if (setNumber == 1) {
      return _pick([
        'Prima serie di $exerciseName fatta. Come è andata? Quante rep?',
        'Serie 1/$totalSets completata. Come ti sei sentito? Rep completate?',
        'Ok, prima serie. Com\'era? Riesci a dirmi quante rep e come ti sentivi?',
      ]);
    }
    if (setNumber == totalSets) {
      return _pick([
        'Ultima serie! Come è andata? Tutto ok?',
        'Serie finale di $exerciseName. Come stai? Rep completate?',
        'L\'ultima! Com\'era rispetto alle precedenti?',
      ]);
    }
    return _pick([
      'Serie $setNumber/$totalSets fatta. Come è andata?',
      'Ok, serie $setNumber. Rep e sensazioni?',
      'Come ti senti? Quante rep sei riuscito a fare?',
    ]);
  }

  /// Template coach response when LLM not available — wraps the static method.
  static String postSetTemplateFeedback({
    required int repsCompleted,
    required int repsTarget,
    required int rpe,
    required int setNumber,
    required int totalSets,
    required String exerciseName,
    required String category,
  }) {
    // Delegates to the full logic in TemplateChat
    // (imported at call site to avoid circular dep)
    final buf = StringBuffer();
    if (repsCompleted >= repsTarget) {
      buf.write('Tutte le rep completate. ');
    } else {
      buf.write('$repsCompleted/$repsTarget rep. ');
    }

    if (rpe <= 6) {
      buf.write('Buon controllo! Mantieni questo ritmo.');
    } else if (rpe <= 8) {
      buf.write('Intensità giusta — zona di lavoro ideale.');
    } else {
      buf.write('Forte! Recupera bene.');
    }

    return buf.toString();
  }

  // ─── Sleep Coaching ──────────────────────────────────────────────

  /// Morning message referencing caffeine cutoff.
  static String sleepCaffeineMorning(String cutoffTime) {
    return _pick([
      'Ultimo caffè entro le $cutoffTime — proteggi il sonno di stasera.',
      'Caffeina: deadline $cutoffTime. Dopo, il corpo impiega 8-10h per smaltirla.',
      'Il sonno inizia al mattino. Ultimo caffè entro le $cutoffTime.',
    ]);
  }

  /// Evening pre-bedtime coaching.
  static String sleepEveningCoaching(int minutesToBedtime) {
    if (minutesToBedtime <= 30) {
      return _pick([
        'Tra $minutesToBedtime minuti è bedtime. Camera a 18-19°C, schermi off.',
        'Bedtime vicino. Oscura la stanza, abbassa la temperatura.',
        'Quasi ora di dormire. Routine serale: niente schermi, temperatura bassa.',
      ]);
    }
    return _pick([
      'Stasera punta a dormire entro l\'orario target. La regolarità è il fattore #1.',
      'Preparati al sonno: riduci stimoli, abbassa le luci.',
    ]);
  }

  // ─── Fasting Cues ──────────────────────────────────────────────

  /// When fasting is active.
  static String fastingActive(int hoursCompleted, double targetHours) {
    final remaining = (targetHours - hoursCompleted).round();
    if (remaining <= 0) {
      return 'Digiuno completato! Refeeding con proteine e micronutrienti.';
    }
    if (remaining <= 2) {
      return 'Quasi fatto. $remaining ore al traguardo. Bevi acqua.';
    }
    return '${hoursCompleted}h di digiuno. $remaining ore rimanenti. Idratazione costante.';
  }

  // ─── Cardio Day Messages (Phase F) ────────────────────────

  /// Message for cardio days (Wednesday/Saturday).
  static String cardioDay(String protocol) {
    return switch (protocol) {
      'tabata' => _pick([
          'Oggi è giorno Tabata — 4 minuti che valgono più di 30 minuti di corsa.',
          'HIIT Tabata oggi. 8 round, 20 secondi ciascuno. VO2max è il miglior predittore di longevità.',
          'Tabata day. Il protocollo con +28% VO2max anaerobico in 6 settimane.',
        ]),
      'norwegian' => _pick([
          'Norwegian 4×4 oggi — +22% VO2max in 12 settimane (Wisløff 2007).',
          'Oggi Norwegian 4×4. 4 round da 4 minuti. Il protocollo cardio più efficace.',
          'Giorno Norwegian. Meglio di qualsiasi allenamento continuo per longevità.',
        ]),
      _ => _pick([
          'Zone 2 oggi. 30 minuti di base aerobica. Fondamenta della longevità.',
          'Giorno cardio a bassa intensità. Zone 2: brucia grassi, costruisci base.',
        ]),
    };
  }

  /// Post-cardio session message.
  static String postCardio(String protocol, int roundsDone, int roundsTotal) {
    if (roundsDone >= roundsTotal) {
      return switch (protocol) {
        'tabata' => 'Tutti i round Tabata completati! Il tuo VO2max ringrazia.',
        'norwegian' => 'Norwegian 4×4 completato! La base aerobica si costruisce così.',
        _ => 'Sessione Zone 2 completata. Base aerobica costruita.',
      };
    }
    return '$roundsDone/$roundsTotal round completati. Ogni round conta.';
  }

  // ─── HRV Messages (Phase H) ──────────────────────────────

  /// HRV-aware morning message.
  static String hrvStatus(String status) {
    return switch (status) {
      'veryLow' => 'HRV molto sotto la baseline. Oggi riposo attivo o deload.',
      'low' => 'HRV sotto la baseline. Volume ridotto del 20% oggi.',
      'prenosological' => 'Indice di stress elevato. Monitora i prossimi giorni.',
      'high' => 'Ottimo recupero! Il corpo risponde bene al protocollo.',
      'suspiciouslyHigh' => 'HRV insolitamente alto. Osserva i prossimi giorni.',
      _ => 'Recovery nella norma. Allenamento come da programma.',
    };
  }

  // ─── Warmup/Cooldown Messages (Phase G) ───────────────────

  /// Warmup encouragement.
  static String warmupEncouragement(int ageYears) {
    if (ageYears > 50) {
      return _pick([
        'Il warmup è fondamentale. 10 minuti che prevengono settimane di infortunio.',
        'Mobilità prima di tutto. A quest\'età, il warmup è non-negoziabile.',
      ]);
    }
    return _pick([
      'Warmup dinamico — prepara il corpo, previeni infortuni.',
      '5 minuti di warmup migliorano la performance del 10%.',
      'Mobilità prima, forza dopo. Il corpo deve essere pronto.',
    ]);
  }

  /// Cooldown encouragement.
  static String cooldownEncouragement(bool usedPnf) {
    if (usedPnf) {
      return 'PNF completato — la flessibilità migliora sessione dopo sessione.';
    }
    return _pick([
      'Stretching statico post-workout. Il corpo recupera meglio.',
      'Cool-down completato. Il recupero è parte del protocollo.',
    ]);
  }

  // ─── Week 0 Messages (Phase N) ────────────────────────────

  /// Week 0 session intro.
  static String week0SessionIntro(int sessionNumber, String focus) {
    return switch (sessionNumber) {
      1 => 'Sessione 1/6 — Basi Corpo Inferiore. Focus sulla tecnica, zero carico.',
      2 => 'Sessione 2/6 — Basi Corpo Superiore. Movimento controllato.',
      3 => 'Sessione 3/6 — Core + Trasporto. Stabilità e controllo.',
      4 => 'Sessione 4/6 — Integrazione Lower. Carichiamo un po\'.',
      5 => 'Sessione 5/6 — Integrazione Upper. Quasi pronti.',
      6 => 'Sessione 6/6 — Assessment Completo. Tutti i pattern motori.',
      _ => 'Week 0 — Familiarizzazione. Focus sulla tecnica.',
    };
  }

  /// Week 0 completion.
  static String week0Complete() {
    return _pick([
      'Week 0 completata! Tutti i pattern motori sono appresi. Inizia il programma.',
      'Familiarizzazione completata! Base motoria solida. Da domani si spinge.',
      'Ottimo! 6 sessioni di tecnica in archivio. Il programma regolare inizia ora.',
    ]);
  }

  /// Week 0 RPE too high warning.
  static String week0RpeTooHigh() {
    return 'RPE troppo alto! Questa settimana è per imparare, non per spingere. Riduci il carico.';
  }

  // ─── Periodization Messages (Phase C) ─────────────────────

  /// Mesocycle phase description.
  static String periodizationPhase(String block, int weekInMesocycle, int totalWeeks) {
    return switch (block) {
      'accumulo' => 'Fase Accumulo — Settimana $weekInMesocycle/$totalWeeks. Volume e tecnica.',
      'trasformazione' => 'Fase Trasformazione — Settimana $weekInMesocycle/$totalWeeks. Intensità in crescita.',
      'realizzazione' => 'Fase Realizzazione — Settimana $weekInMesocycle/$totalWeeks. Picco prestazionale.',
      'deload' => 'Settimana di Deload. Recupero attivo, volume ridotto.',
      _ => 'Settimana $weekInMesocycle/$totalWeeks del mesociclo.',
    };
  }

  // ─── Bio-Based Coaching Cues ───────────────────────────────────

  /// Real-time biometric coaching cue during workout or cold exposure.
  ///
  /// Returns null when no cue is warranted — callers should show nothing.
  static String? bioCue({
    int? currentHr,
    int? hrMax,
    int? spo2,
    double? rmssd,
    double? previousRmssd,
    double? stressIndex,
    int? hrRecoveryBpm,
    double? skinTemp,
    double? tempBaseline,
  }) {
    if (hrMax != null && currentHr != null && currentHr > hrMax * 0.9) {
      return 'Intensità altissima. Prendi tutto il riposo che serve.';
    }
    if (spo2 != null && spo2 < 94) {
      return 'Saturazione bassa — respira profondamente prima del prossimo set.';
    }
    if (stressIndex != null && stressIndex > 300) {
      return 'Stress alto — allunga il riposo o riduci il carico.';
    }
    if (hrRecoveryBpm != null && hrRecoveryBpm < 20) {
      return 'Recupero lento — considera di chiudere qui.';
    }
    if (rmssd != null && previousRmssd != null && rmssd < previousRmssd * 0.7) {
      return 'Il sistema nervoso si sta affaticando. Considera di chiudere.';
    }
    if (skinTemp != null && tempBaseline != null && skinTemp - tempBaseline > 1.5) {
      return 'Temperatura in salita significativa — idratati.';
    }
    if (skinTemp != null && skinTemp > 38.0) {
      return 'Temperatura cutanea alta — rallenta e rinfrescati.';
    }
    return null;
  }

  // ─── Protocol Nudges ───────────────────────────────────────────

  /// Nudge based on what's not done yet.
  static String protocolNudge({
    required bool workoutDone,
    required bool fastingDone,
    required bool coldDone,
    required bool meditationDone,
    required bool sleepLogged,
    required int hour,
  }) {
    if (!workoutDone && hour >= 16) {
      return 'L\'allenamento di oggi è ancora in attesa. Ogni sessione conta.';
    }
    if (!coldDone && hour >= 10) {
      return 'Doccia fredda non ancora fatta. Il freddo è più facile al mattino.';
    }
    if (!meditationDone && hour >= 20) {
      return '5 minuti di meditazione prima di dormire migliorano il sonno.';
    }
    if (!sleepLogged && hour >= 8) {
      return 'Registra il sonno di ieri notte. I dati guidano il protocollo.';
    }
    return '';
  }
}
