/// Modelli per il digiuno avanzato Livello 3: digiuni estesi (72-120h),
/// Fasting Mimicking Diet (FMD), protocollo di refeeding, e criteri di avanzamento.
///
/// Pura logica di dominio — nessuna dipendenza da database o UI.
library;

// ============================================================
// FASI DEL DIGIUNO ESTESO
// ============================================================

/// Fase fisiologica durante un digiuno esteso.
enum ExtendedFastPhase {
  /// 0-24h: il corpo esaurisce il glicogeno epatico.
  adaptation,

  /// 24-72h: chetosi stabile, beta-idrossibutirrato >0.5 mmol/L.
  deepKetosis,

  /// 72h+: marcatori autofagici al picco (LC3-II, p62 nei modelli animali).
  autophagyMax,
}

/// Stadio secondo la tradizione russa РДТ (Nikolaev/Filonov).
enum RdtStage {
  /// Giorni 1-3: fame intensa, irritabilita, pensiero ossessivo sul cibo.
  foodExcitement,

  /// Giorni 3-7: lingua bianca, alito acetonico, debolezza poi miglioramento.
  growingAcidosis,

  /// Giorno 6+: crisi acidotica poi benessere improvviso, lingua si schiarisce.
  compensation,
}

// ============================================================
// SAFETY
// ============================================================

/// Verdetto di un controllo di sicurezza durante il digiuno.
enum SafetyVerdict {
  /// Tutto nella norma, continuare.
  ok,

  /// Valori borderline — monitorare piu frequentemente.
  warning,

  /// Interrompere il digiuno immediatamente.
  stopImmediately,
}

/// Risultato di un singolo controllo di sicurezza.
class SafetyCheckResult {
  final SafetyVerdict verdict;
  final String message;

  const SafetyCheckResult(this.verdict, this.message);

  const SafetyCheckResult.ok()
      : verdict = SafetyVerdict.ok,
        message = 'Valori nella norma. Puoi continuare.';

  const SafetyCheckResult.warning(String msg)
      : verdict = SafetyVerdict.warning,
        message = msg;

  const SafetyCheckResult.stop(String msg)
      : verdict = SafetyVerdict.stopImmediately,
        message = msg;
}

/// Sintomi da monitorare durante il digiuno esteso.
class FastingSymptom {
  final String id;
  final String label;
  final bool isCritical;

  const FastingSymptom({
    required this.id,
    required this.label,
    this.isCritical = false,
  });

  static const List<FastingSymptom> checklist = [
    FastingSymptom(id: 'crampi', label: 'Crampi muscolari'),
    FastingSymptom(
        id: 'vertigini', label: 'Vertigini o svenimento', isCritical: true),
    FastingSymptom(
        id: 'palpitazioni', label: 'Palpitazioni cardiache', isCritical: true),
    FastingSymptom(
        id: 'confusione', label: 'Confusione mentale', isCritical: true),
    FastingSymptom(id: 'nausea', label: 'Nausea persistente'),
    FastingSymptom(id: 'debolezza', label: 'Debolezza estrema'),
    FastingSymptom(id: 'cefalea', label: 'Mal di testa forte'),
    FastingSymptom(id: 'tremori', label: 'Tremori', isCritical: true),
    FastingSymptom(id: 'insonnia', label: 'Insonnia prolungata'),
    FastingSymptom(id: 'irritabilita', label: 'Irritabilita eccessiva'),
  ];
}

/// Promemoria per integrazione elettrolitica durante il digiuno esteso.
class ElectrolyteReminder {
  final String mineral;
  final String dose;
  final String timing;
  final String note;

  const ElectrolyteReminder({
    required this.mineral,
    required this.dose,
    required this.timing,
    required this.note,
  });

  static const List<ElectrolyteReminder> schedule = [
    ElectrolyteReminder(
      mineral: 'Sodio',
      dose: '1-2g (sale rosa Himalaya)',
      timing: 'Ogni 8h in acqua',
      note: 'Previene ipotensione e crampi',
    ),
    ElectrolyteReminder(
      mineral: 'Potassio',
      dose: '200-400mg (citrato di potassio)',
      timing: 'Ogni 12h',
      note: 'Fondamentale per ritmo cardiaco',
    ),
    ElectrolyteReminder(
      mineral: 'Magnesio',
      dose: '200-400mg (glicinato di magnesio)',
      timing: 'Sera, prima di dormire',
      note: 'Previene crampi e migliora il sonno',
    ),
  ];
}

// ============================================================
// EXTENDED FAST PROTOCOL (72-120h)
// ============================================================

/// Protocollo per digiuni estesi 72-120h.
class ExtendedFastProtocol {
  const ExtendedFastProtocol._();

  // -- Soglie di sicurezza glicemica (mg/dL) --

  /// Sotto questa soglia: INTERROMPERE IMMEDIATAMENTE.
  static const double glucoseCriticalThreshold = 54.0;

  /// Sotto questa soglia: warning, monitorare ogni 2h.
  static const double glucoseWarningThreshold = 70.0;

  /// BMI minimo per iniziare un digiuno esteso.
  static const double minBmi = 18.5;

  /// Durate target disponibili (ore).
  static const List<int> availableTargetHours = [72, 96, 120];

  /// Intervallo safety check per le prime 72h (ogni 6h).
  static const Duration safetyCheckIntervalEarly = Duration(hours: 6);

  /// Intervallo safety check dopo 72h (ogni 12h).
  static const Duration safetyCheckIntervalLate = Duration(hours: 12);

  /// Milestone fisiologici (ore dall'inizio del digiuno).
  static const List<({int hours, String label, String description})>
      milestones = [
    (
      hours: 12,
      label: 'Glicogeno epatico in esaurimento',
      description: 'Il corpo inizia a passare dai carboidrati ai grassi.',
    ),
    (
      hours: 24,
      label: 'Chetosi iniziale',
      description:
          'I chetoni nel sangue aumentano. La fame puo intensificarsi prima di attenuarsi.',
    ),
    (
      hours: 48,
      label: 'Chetosi profonda',
      description:
          'Beta-idrossibutirrato >1 mmol/L. Autofagia attiva (dati da modelli animali).',
    ),
    (
      hours: 72,
      label: 'Picco autofagico',
      description:
          'Marcatori autofagici al massimo. Rigenerazione cellule staminali immunitarie (Longo 2014).',
    ),
    (
      hours: 96,
      label: 'Autofagia sostenuta',
      description: 'Fase di mantenimento. Monitorare attentamente.',
    ),
    (
      hours: 120,
      label: 'Limite raccomandato',
      description:
          'Oltre 120h il rapporto rischio/beneficio peggiora. Iniziare refeeding.',
    ),
  ];

  /// Determina la fase fisiologica corrente in base alle ore trascorse.
  static ExtendedFastPhase currentPhase(double hoursElapsed) {
    if (hoursElapsed < 24) return ExtendedFastPhase.adaptation;
    if (hoursElapsed < 72) return ExtendedFastPhase.deepKetosis;
    return ExtendedFastPhase.autophagyMax;
  }

  /// Etichetta italiana della fase.
  static String phaseLabel(ExtendedFastPhase phase) {
    return switch (phase) {
      ExtendedFastPhase.adaptation => 'Adattamento',
      ExtendedFastPhase.deepKetosis => 'Chetosi profonda',
      ExtendedFastPhase.autophagyMax => 'Autofagia massima',
    };
  }

  /// Descrizione della fase.
  static String phaseDescription(ExtendedFastPhase phase) {
    return switch (phase) {
      ExtendedFastPhase.adaptation =>
        'Il corpo esaurisce il glicogeno e inizia la transizione a chetosi. '
            'Possibile fame intensa nelle prime 12-18h.',
      ExtendedFastPhase.deepKetosis =>
        'Chetoni elevati, segnale autofagico attivo. '
            'La fame si attenua. Attenzione a vertigini e debolezza.',
      ExtendedFastPhase.autophagyMax =>
        'Picco autofagico raggiunto. Rigenerazione cellulare attiva. '
            'Monitorare glicemia e sintomi con attenzione.',
    };
  }

  /// Stadio РДТ approssimativo in base alle ore.
  static RdtStage? rdtStage(double hoursElapsed) {
    if (hoursElapsed < 72) return RdtStage.foodExcitement;
    if (hoursElapsed < 168) return RdtStage.growingAcidosis;
    // La compensazione avviene tipicamente dopo 7+ giorni,
    // oltre il range di questo protocollo (max 120h = 5 giorni).
    return null;
  }

  /// Calcola l'intervallo per il prossimo safety check.
  ///
  /// Prime 72h: ogni 6h. Dopo 72h: ogni 12h.
  static Duration nextSafetyCheckInterval(double hoursElapsed) {
    if (hoursElapsed < 72) return safetyCheckIntervalEarly;
    return safetyCheckIntervalLate;
  }

  /// Valuta un controllo di sicurezza basato sulla glicemia e sui sintomi.
  static SafetyCheckResult evaluateSafetyCheck({
    double? glucoseMgDl,
    List<String> symptomIds = const [],
  }) {
    // Soglia critica glicemia
    if (glucoseMgDl != null && glucoseMgDl < glucoseCriticalThreshold) {
      return SafetyCheckResult.stop(
        'Glicemia critica: ${glucoseMgDl.toStringAsFixed(0)} mg/dL. '
        'Interrompi il digiuno immediatamente e assumi carboidrati semplici.',
      );
    }

    // Sintomi critici (vertigini, palpitazioni, confusione, tremori)
    final criticalSymptoms = symptomIds
        .where((id) => FastingSymptom.checklist
            .any((s) => s.id == id && s.isCritical))
        .toList();

    if (criticalSymptoms.length >= 2) {
      return const SafetyCheckResult.stop(
        'Sintomi critici multipli rilevati. '
        'Interrompi il digiuno e consulta un medico.',
      );
    }

    if (criticalSymptoms.length == 1) {
      final matches = FastingSymptom.checklist
          .where((s) => s.id == criticalSymptoms.first);
      final symptomLabel = matches.isNotEmpty
          ? matches.first.label
          : 'Sintomo critico';
      return SafetyCheckResult.warning(
        '$symptomLabel rilevato. Monitora attentamente. '
        'Se peggiora o si aggiungono altri sintomi, interrompi.',
      );
    }

    // Soglia warning glicemia
    if (glucoseMgDl != null && glucoseMgDl < glucoseWarningThreshold) {
      return SafetyCheckResult.warning(
        'Glicemia bassa: ${glucoseMgDl.toStringAsFixed(0)} mg/dL. '
        'Monitorare ogni 2h. Se scende sotto 54 mg/dL, interrompere.',
      );
    }

    // Sintomi non critici multipli
    if (symptomIds.length >= 3) {
      return const SafetyCheckResult.warning(
        'Diversi sintomi presenti. Valuta se continuare. '
        'Assicurati di assumere elettroliti.',
      );
    }

    return const SafetyCheckResult.ok();
  }

  /// Controlla se il BMI e sufficiente per iniziare.
  static bool isBmiSafe(double weightKg, double heightCm) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);
    return bmi >= minBmi;
  }
}

// ============================================================
// FMD — FASTING MIMICKING DIET (Longo)
// ============================================================

/// Un singolo pasto suggerito nel piano FMD.
class FmdMeal {
  final String name;
  final String description;
  final int kcalEstimate;
  final double proteinG;
  final double fatG;
  final double carbG;

  const FmdMeal({
    required this.name,
    required this.description,
    required this.kcalEstimate,
    required this.proteinG,
    required this.fatG,
    required this.carbG,
  });
}

/// Piano giornaliero FMD.
class FmdDayPlan {
  final int dayNumber;
  final int targetKcal;
  final double proteinPercent;
  final double fatPercent;
  final double carbPercent;
  final List<FmdMeal> meals;
  final String note;

  const FmdDayPlan({
    required this.dayNumber,
    required this.targetKcal,
    required this.proteinPercent,
    required this.fatPercent,
    required this.carbPercent,
    required this.meals,
    this.note = '',
  });

  /// Grammi target per macronutriente.
  double get proteinTargetG => (targetKcal * proteinPercent) / 4.0;
  double get fatTargetG => (targetKcal * fatPercent) / 9.0;
  double get carbTargetG => (targetKcal * carbPercent) / 4.0;
}

/// Protocollo FMD di 5 giorni (Brandhorst et al. 2015, Cell Metabolism).
class FmdProtocol {
  const FmdProtocol._();

  /// Durata del ciclo FMD in giorni.
  static const int cycleDays = 5;

  /// Frequenza massima consigliata: 1 ciclo ogni 2-3 mesi.
  static const int minDaysBetweenCycles = 60;

  /// Cicli massimi per anno.
  static const int maxCyclesPerYear = 6;

  /// BMI minimo per FMD.
  static const double minBmi = 20.0;

  /// Macro targets per giorno.
  static const _day1Kcal = 1100;
  static const _day1Protein = 0.10;
  static const _day1Fat = 0.56;
  static const _day1Carb = 0.34;

  static const _day2to5Kcal = 800;
  static const _day2to5Protein = 0.09;
  static const _day2to5Fat = 0.44;
  static const _day2to5Carb = 0.47;

  /// Genera il piano pasti per un giorno specifico (1-5).
  static FmdDayPlan dayPlan(int dayNumber) {
    assert(dayNumber >= 1 && dayNumber <= cycleDays);

    if (dayNumber == 1) {
      return const FmdDayPlan(
        dayNumber: 1,
        targetKcal: _day1Kcal,
        proteinPercent: _day1Protein,
        fatPercent: _day1Fat,
        carbPercent: _day1Carb,
        note: 'Giorno di transizione — calorie leggermente piu alte '
            'per facilitare l\'adattamento.',
        meals: [
          FmdMeal(
            name: 'Colazione',
            description: 'Te verde + 30g noci miste + 1 cracker di semi di lino',
            kcalEstimate: 280,
            proteinG: 7,
            fatG: 22,
            carbG: 14,
          ),
          FmdMeal(
            name: 'Pranzo',
            description:
                'Zuppa di verdure miste (zucchine, carote, sedano) + 1 cucchiaio olio EVO + olive',
            kcalEstimate: 450,
            proteinG: 10,
            fatG: 30,
            carbG: 35,
          ),
          FmdMeal(
            name: 'Cena',
            description:
                'Insalata di cavolo riccio con avocado + semi di zucca + limone',
            kcalEstimate: 370,
            proteinG: 10,
            fatG: 28,
            carbG: 22,
          ),
        ],
      );
    }

    // Giorni 2-5: stesse macro, stessi suggerimenti
    return FmdDayPlan(
      dayNumber: dayNumber,
      targetKcal: _day2to5Kcal,
      proteinPercent: _day2to5Protein,
      fatPercent: _day2to5Fat,
      carbPercent: _day2to5Carb,
      note: dayNumber == 3
          ? 'Giorno 3: possibile picco taurina plasmatica '
              '(studio Bigu, J Nutr 2021). Milestone metabolico.'
          : dayNumber == 5
              ? 'Ultimo giorno. Domani inizia il refeeding graduale.'
              : '',
      meals: [
        const FmdMeal(
          name: 'Colazione',
          description: 'Te verde + 20g noci + 5 olive',
          kcalEstimate: 200,
          proteinG: 5,
          fatG: 16,
          carbG: 8,
        ),
        const FmdMeal(
          name: 'Pranzo',
          description:
              'Zuppa di verdure (cavolo, cipolla, pomodoro) + 1 cucchiaio olio EVO',
          kcalEstimate: 350,
          proteinG: 8,
          fatG: 18,
          carbG: 38,
        ),
        const FmdMeal(
          name: 'Cena',
          description:
              'Kale chips al forno + crackers di semi + te alla camomilla',
          kcalEstimate: 250,
          proteinG: 5,
          fatG: 14,
          carbG: 28,
        ),
      ],
    );
  }

  /// Genera il piano completo di 5 giorni.
  static List<FmdDayPlan> fullCyclePlan() {
    return List.generate(cycleDays, (i) => dayPlan(i + 1));
  }

  /// Controlla se il BMI e sufficiente per FMD.
  static bool isBmiSafe(double weightKg, double heightCm) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);
    return bmi >= minBmi;
  }
}

// ============================================================
// REFEEDING PROTOCOL
// ============================================================

/// Fase di reintroduzione alimentare post-digiuno.
class RefeedingPhase {
  /// Ora di inizio della fase (dal termine del digiuno).
  final int hourStart;

  /// Ora di fine della fase.
  final int hourEnd;

  /// Nome della fase.
  final String name;

  /// Descrizione di cosa mangiare.
  final String description;

  /// Alimenti consentiti in questa fase.
  final List<String> allowedFoods;

  /// Restrizioni specifiche.
  final String restrictions;

  const RefeedingPhase({
    required this.hourStart,
    required this.hourEnd,
    required this.name,
    required this.description,
    required this.allowedFoods,
    required this.restrictions,
  });
}

/// Protocollo di refeeding post-digiuno esteso.
///
/// Combina le linee guida occidentali (Mehanna 2008, BMJ) con i principi
/// della tradizione russa (Nikolaev) e cinese (Bigu).
class RefeedingProtocol {
  const RefeedingProtocol._();

  /// Rapporto durata refeeding / durata digiuno.
  ///
  /// Protocollo occidentale: 24-48h fisso.
  /// Protocollo russo (Nikolaev): 1:1 (durata = durata digiuno).
  /// Protocollo cinese (Bigu): 3:1 (3x durata digiuno).
  ///
  /// Phoenix usa un compromesso: 50% della durata del digiuno,
  /// con minimo 24h e massimo 72h.
  static const double refeedingRatio = 0.5;
  static const int minRefeedingHours = 24;
  static const int maxRefeedingHours = 72;

  /// Calcola la durata del refeeding in ore.
  static int refeedingDurationHours(double fastDurationHours) {
    final calculated = (fastDurationHours * refeedingRatio).round();
    if (calculated < minRefeedingHours) return minRefeedingHours;
    if (calculated > maxRefeedingHours) return maxRefeedingHours;
    return calculated;
  }

  /// Le 3 fasi standard del refeeding.
  static const List<RefeedingPhase> phases = [
    RefeedingPhase(
      hourStart: 0,
      hourEnd: 12,
      name: 'Fase 1 — Liquidi e elettroliti',
      description:
          'Solo brodo osseo, acqua con elettroliti, te. '
          'Piccoli sorsi ogni 1-2 ore. Niente cibi solidi.',
      allowedFoods: [
        'Brodo osseo (200-300ml ogni 2h)',
        'Acqua con sale rosa',
        'Te verde o camomilla',
        'Elettroliti (sodio, potassio, magnesio)',
      ],
      restrictions:
          'Niente cibi solidi. Niente zuccheri semplici. '
          'Niente latticini.',
    ),
    RefeedingPhase(
      hourStart: 12,
      hourEnd: 24,
      name: 'Fase 2 — Verdure cotte e proteine leggere',
      description:
          'Verdure cotte morbide, porzioni piccole. '
          'Proteine leggere (uova, pesce bianco) solo in piccole quantita.',
      allowedFoods: [
        'Verdure cotte (zucchine, carote, spinaci)',
        'Zuppa di miso',
        'Uova sode (max 2)',
        'Pesce bianco al vapore (piccola porzione)',
        'Avocado (mezzo)',
      ],
      restrictions:
          'Porzioni piccole (max 200g per pasto). '
          'Niente carne rossa. Niente cereali raffinati. '
          'Niente frutta ad alto IG.',
    ),
    RefeedingPhase(
      hourStart: 24,
      hourEnd: 48,
      name: 'Fase 3 — Ritorno graduale',
      description:
          'Alimenti del protocollo Phoenix, porzioni crescenti. '
          'Evitare ancora zuccheri semplici e alcool.',
      allowedFoods: [
        'Alimenti Tier 1-2 del protocollo Phoenix',
        'Riso integrale o quinoa (piccole porzioni)',
        'Verdure crude (introdotte gradualmente)',
        'Frutta a basso IG (mirtilli, lamponi)',
        'Noci e semi',
        'Pesce, uova, legumi',
      ],
      restrictions:
          'Porzioni 50-75% del normale. '
          'Niente carne rossa per almeno 48h (tradizione russa: 7 giorni). '
          'Niente alcool. Niente zuccheri aggiunti.',
    ),
  ];

  /// Determina la fase corrente in base alle ore dal termine del digiuno.
  static RefeedingPhase currentPhase(double hoursSinceFastEnd) {
    if (hoursSinceFastEnd < 12) return phases[0];
    if (hoursSinceFastEnd < 24) return phases[1];
    return phases[2];
  }

  /// Indice della fase corrente (0-2).
  static int currentPhaseIndex(double hoursSinceFastEnd) {
    if (hoursSinceFastEnd < 12) return 0;
    if (hoursSinceFastEnd < 24) return 1;
    return 2;
  }

  /// Prossimo cambio di fase (ore dal termine del digiuno).
  static int? nextPhaseChangeHour(double hoursSinceFastEnd) {
    if (hoursSinceFastEnd < 12) return 12;
    if (hoursSinceFastEnd < 24) return 24;
    return null; // Ultima fase
  }

  /// Avvisi post-digiuno specifici.
  static const List<({int hour, String message})> refeedingAlerts = [
    (
      hour: 0,
      message: 'Digiuno completato! Inizia il refeeding con brodo e liquidi.',
    ),
    (
      hour: 6,
      message: 'Continua con liquidi. Come ti senti? '
          'Segnala eventuali disturbi gastrointestinali.',
    ),
    (
      hour: 12,
      message: 'Puoi introdurre verdure cotte morbide e piccole porzioni '
          'di proteine leggere.',
    ),
    (
      hour: 24,
      message: 'Passaggio a cibo solido del protocollo Phoenix. '
          'Porzioni al 50-75% del normale.',
    ),
    (
      hour: 48,
      message: 'Refeeding completato. Puoi tornare alle porzioni normali.',
    ),
  ];

  /// Avviso speciale: giorni 4-6 post-digiuno (tradizione russa).
  /// Spike di appetito estremo — l'utente va avvisato.
  static const String russianAppetiteSpikeWarning =
      'Attenzione: nei giorni 4-6 dopo un digiuno lungo potresti sperimentare '
      'un appetito estremo (documentato nella tradizione russa РДТ). '
      'E normale. Non cedere a abbuffate — mantieni porzioni controllate.';

  /// Ore post-digiuno in cui avvisare dell'appetite spike (96-144h).
  static bool isInAppetiteSpikeWindow(double hoursSinceFastEnd) {
    return hoursSinceFastEnd >= 96 && hoursSinceFastEnd <= 144;
  }
}

// ============================================================
// CRITERI DI AVANZAMENTO A LIVELLO 3
// ============================================================

/// Risultato della verifica dei criteri per accedere al Livello 3.
class Level3EligibilityResult {
  /// L'utente soddisfa tutti i criteri.
  final bool eligible;

  /// Numero di digiuni L2 completati (richiesti: >=3 da >=24h con tolleranza >=3).
  final int completedLevel2Fasts;

  /// Il disclaimer medico e stato accettato e non e scaduto.
  final bool medicalDisclaimerValid;

  /// L'utente ha un pannello ematico recente (entro 30 giorni).
  final bool recentBloodPanel;

  /// BMI >= 18.5 per digiuno esteso.
  final bool bmiSafe;

  /// Messaggi per criteri non soddisfatti.
  final List<String> unmetCriteria;

  const Level3EligibilityResult({
    required this.eligible,
    required this.completedLevel2Fasts,
    required this.medicalDisclaimerValid,
    required this.recentBloodPanel,
    required this.bmiSafe,
    required this.unmetCriteria,
  });
}

/// Criteri di avanzamento al Livello 3.
class Level3Criteria {
  const Level3Criteria._();

  /// Numero minimo di digiuni L2 completati (>=24h ciascuno, tolleranza >=3).
  static const int requiredLevel2Fasts = 3;

  /// Durata minima dei digiuni L2 qualificanti (ore).
  static const double minLevel2FastHours = 24.0;

  /// Tolleranza minima dei digiuni L2 qualificanti (su 5).
  static const double minToleranceScore = 3.0;

  /// Validita massima del disclaimer medico per L3 (giorni).
  static const int medicalDisclaimerValidityDays = 90;

  /// Eta massima del pannello ematico (giorni).
  static const int maxBloodPanelAgeDays = 30;

  /// Verifica l'idoneita al Livello 3.
  ///
  /// Parametri:
  /// - [level2FastsCompleted]: numero di digiuni L2 completati con >=24h e tolleranza >=3
  /// - [medicalDisclaimerAcceptedAt]: data di accettazione del disclaimer medico
  /// - [lastBloodPanelDate]: data dell'ultimo pannello ematico
  /// - [weightKg]: peso attuale in kg
  /// - [heightCm]: altezza in cm
  /// - [now]: data/ora corrente (per test)
  static Level3EligibilityResult evaluate({
    required int level2FastsCompleted,
    DateTime? medicalDisclaimerAcceptedAt,
    DateTime? lastBloodPanelDate,
    required double weightKg,
    required double heightCm,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final unmet = <String>[];

    // 1. Digiuni L2 sufficienti
    final hasEnoughFasts = level2FastsCompleted >= requiredLevel2Fasts;
    if (!hasEnoughFasts) {
      unmet.add(
        'Completa almeno $requiredLevel2Fasts digiuni di Livello 2 '
        '(>=24h con tolleranza >=3/5). '
        'Completati: $level2FastsCompleted/$requiredLevel2Fasts.',
      );
    }

    // 2. Disclaimer medico valido
    final disclaimerValid = medicalDisclaimerAcceptedAt != null &&
        currentTime.difference(medicalDisclaimerAcceptedAt).inDays <=
            medicalDisclaimerValidityDays;
    if (!disclaimerValid) {
      if (medicalDisclaimerAcceptedAt == null) {
        unmet.add(
          'Accetta il disclaimer medico specifico per il Livello 3. '
          'Il digiuno esteso comporta rischi significativi.',
        );
      } else {
        unmet.add(
          'Il disclaimer medico e scaduto (>$medicalDisclaimerValidityDays giorni). '
          'Riaccettalo per procedere.',
        );
      }
    }

    // 3. Pannello ematico recente
    final hasRecentPanel = lastBloodPanelDate != null &&
        currentTime.difference(lastBloodPanelDate).inDays <=
            maxBloodPanelAgeDays;
    if (!hasRecentPanel) {
      if (lastBloodPanelDate == null) {
        unmet.add(
          'Inserisci un pannello ematico recente (sezione Biomarker > Sangue). '
          'Necessario per valutare la sicurezza del digiuno esteso.',
        );
      } else {
        unmet.add(
          'Il pannello ematico e troppo vecchio '
          '(>$maxBloodPanelAgeDays giorni). Inseriscine uno recente.',
        );
      }
    }

    // 4. BMI sicuro
    final bmiOk = ExtendedFastProtocol.isBmiSafe(weightKg, heightCm);
    if (!bmiOk) {
      final heightM = heightCm / 100.0;
      final bmi = weightKg / (heightM * heightM);
      unmet.add(
        'BMI troppo basso (${bmi.toStringAsFixed(1)}). '
        'Minimo ${ExtendedFastProtocol.minBmi} per il digiuno esteso.',
      );
    }

    return Level3EligibilityResult(
      eligible: hasEnoughFasts && disclaimerValid && hasRecentPanel && bmiOk,
      completedLevel2Fasts: level2FastsCompleted,
      medicalDisclaimerValid: disclaimerValid,
      recentBloodPanel: hasRecentPanel,
      bmiSafe: bmiOk,
      unmetCriteria: unmet,
    );
  }

  /// Etichette italiane per la UI dei criteri (checklist).
  static List<({String label, bool met})> criteriaChecklist({
    required int level2FastsCompleted,
    required bool medicalDisclaimerValid,
    required bool recentBloodPanel,
    required bool bmiSafe,
  }) {
    return [
      (
        label: '>=$requiredLevel2Fasts digiuni L2 completati (>=24h, tolleranza >=3/5) '
            '— $level2FastsCompleted/$requiredLevel2Fasts',
        met: level2FastsCompleted >= requiredLevel2Fasts,
      ),
      (
        label: 'Disclaimer medico accettato (valido $medicalDisclaimerValidityDays giorni)',
        met: medicalDisclaimerValid,
      ),
      (
        label: 'Pannello ematico recente (ultimi $maxBloodPanelAgeDays giorni)',
        met: recentBloodPanel,
      ),
      (
        label: 'BMI >= ${ExtendedFastProtocol.minBmi}',
        met: bmiSafe,
      ),
    ];
  }
}
