/// Week 0 Familiarization Protocol
///
/// 6 sessioni introduttive per apprendere i pattern motori fondamentali
/// prima di iniziare il programma Phoenix completo.
/// Basato sul principio di Bernstein: pochi cue per volta.

// ---------------------------------------------------------------------------
// Week0Exercise
// ---------------------------------------------------------------------------

/// Singolo esercizio di familiarizzazione.
class Week0Exercise {
  final String name;

  /// Pattern motorio: squat, hinge, push, pull, core, carry.
  final String pattern;

  /// Cue di esecuzione in italiano (max 1-2 per principio di Bernstein).
  final String instructions;

  /// Asset immagine opzionale.
  final String? imageAsset;

  const Week0Exercise({
    required this.name,
    required this.pattern,
    required this.instructions,
    this.imageAsset,
  });
}

// ---------------------------------------------------------------------------
// Week0Session
// ---------------------------------------------------------------------------

/// Una delle 6 sessioni di familiarizzazione.
class Week0Session {
  final int sessionNumber;

  /// Chiave interna: lower_basics, upper_basics, core_carry,
  /// lower_integration, upper_integration, full_body_assessment.
  final String focus;

  /// Etichetta per UI in italiano.
  final String focusLabel;

  final List<Week0Exercise> exercises;

  /// Sempre 2 serie.
  final int sets;

  /// Ripetizioni target (10-12).
  final int reps;

  /// Riposo tra le serie in secondi (90-120).
  final int restSeconds;

  /// Tempo prescritto: 3-1-2-0 (ecc-pause-con-pause).
  final String tempo;

  /// RPE target minimo.
  final double targetRpeMin;

  /// RPE target massimo.
  final double targetRpeMax;

  /// Compilato dopo il completamento.
  DateTime? completedAt;

  /// RPE medio della sessione.
  double? avgRpe;

  /// true se la sessione è superata (avgRpe ≤ 6, nessun set con RPE > 7).
  bool? passed;

  Week0Session({
    required this.sessionNumber,
    required this.focus,
    required this.focusLabel,
    required this.exercises,
    this.sets = 2,
    this.reps = 12,
    this.restSeconds = 90,
    this.tempo = '3-1-2-0',
    this.targetRpeMin = 4.0,
    this.targetRpeMax = 6.0,
    this.completedAt,
    this.avgRpe,
    this.passed,
  });

  /// La sessione deve essere ripetuta se RPE > 7 in qualsiasi set.
  bool get mustRepeat => passed == false;
}

// ---------------------------------------------------------------------------
// Week0State
// ---------------------------------------------------------------------------

/// Stato complessivo della familiarizzazione.
class Week0State {
  /// true quando il protocollo Week 0 è in corso.
  final bool isActive;

  /// Numero di sessioni completate con successo (0-6).
  final int sessionsCompleted;

  /// Le 6 sessioni del piano.
  final List<Week0Session> sessions;

  /// Quando l'utente ha iniziato Week 0.
  final DateTime? startedAt;

  /// Quando l'utente ha completato tutte e 6 le sessioni.
  final DateTime? completedAt;

  const Week0State({
    this.isActive = false,
    this.sessionsCompleted = 0,
    this.sessions = const [],
    this.startedAt,
    this.completedAt,
  });

  /// Week 0 è completato quando tutte le 6 sessioni sono superate.
  bool get isCompleted => sessionsCompleted >= 6;

  /// Prossima sessione da eseguire (1-based).
  int get nextSessionNumber => sessionsCompleted + 1;

  /// Crea una copia con campi aggiornati.
  Week0State copyWith({
    bool? isActive,
    int? sessionsCompleted,
    List<Week0Session>? sessions,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Week0State(
      isActive: isActive ?? this.isActive,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      sessions: sessions ?? this.sessions,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// ---------------------------------------------------------------------------
// Week0Generator
// ---------------------------------------------------------------------------

/// Genera il piano di 6 sessioni per Week 0.
class Week0Generator {
  Week0Generator._();

  /// Genera il piano completo di familiarizzazione.
  static List<Week0Session> generatePlan() {
    return [
      // Sessione 1 — Lower Body Basics
      Week0Session(
        sessionNumber: 1,
        focus: 'lower_basics',
        focusLabel: 'Fondamentali Parte Inferiore',
        restSeconds: 90,
        reps: 12,
        exercises: const [
          Week0Exercise(
            name: 'BW Squat',
            pattern: 'squat',
            instructions: 'Talloni a terra, petto alto',
          ),
          Week0Exercise(
            name: 'Good Morning',
            pattern: 'hinge',
            instructions: 'Schiena neutra, piegarsi dall\'anca',
          ),
          Week0Exercise(
            name: 'Glute Bridge',
            pattern: 'hinge',
            instructions: 'Stringi i glutei al top',
          ),
        ],
      ),

      // Sessione 2 — Upper Body Basics
      Week0Session(
        sessionNumber: 2,
        focus: 'upper_basics',
        focusLabel: 'Fondamentali Parte Superiore',
        restSeconds: 90,
        reps: 12,
        exercises: const [
          Week0Exercise(
            name: 'Wall Push-up',
            pattern: 'push',
            instructions: 'Scapole retratte, gomiti a 45°',
          ),
          Week0Exercise(
            name: 'Band Row',
            pattern: 'pull',
            instructions: 'Inizia dalle scapole',
          ),
          Week0Exercise(
            name: 'Shoulder Press leggero',
            pattern: 'push',
            instructions: 'Core attivo, non inarcare',
          ),
        ],
      ),

      // Sessione 3 — Core + Carry
      Week0Session(
        sessionNumber: 3,
        focus: 'core_carry',
        focusLabel: 'Core e Trasporto',
        restSeconds: 90,
        reps: 10,
        exercises: const [
          Week0Exercise(
            name: 'Dead Bug',
            pattern: 'core',
            instructions: 'Schiena a terra, opposti',
          ),
          Week0Exercise(
            name: 'Plank',
            pattern: 'core',
            instructions: 'Linea retta testa-talloni',
          ),
          Week0Exercise(
            name: 'Farmer Walk leggero',
            pattern: 'carry',
            instructions: 'Spalle basse, passi corti',
          ),
        ],
      ),

      // Sessione 4 — Lower Integration
      Week0Session(
        sessionNumber: 4,
        focus: 'lower_integration',
        focusLabel: 'Integrazione Parte Inferiore',
        restSeconds: 120,
        reps: 10,
        exercises: const [
          Week0Exercise(
            name: 'Goblet Squat',
            pattern: 'squat',
            instructions: 'Peso al petto, talloni a terra',
          ),
          Week0Exercise(
            name: 'RDL leggero',
            pattern: 'hinge',
            instructions: 'Schiena neutra, anca indietro',
          ),
          Week0Exercise(
            name: 'Walking Lunge',
            pattern: 'squat',
            instructions: 'Ginocchio non oltre la punta',
          ),
        ],
      ),

      // Sessione 5 — Upper Integration
      Week0Session(
        sessionNumber: 5,
        focus: 'upper_integration',
        focusLabel: 'Integrazione Parte Superiore',
        restSeconds: 120,
        reps: 10,
        exercises: const [
          Week0Exercise(
            name: 'Push-up',
            pattern: 'push',
            instructions: 'Corpo rigido, scapole retratte',
          ),
          Week0Exercise(
            name: 'Inverted Row',
            pattern: 'pull',
            instructions: 'Tira il petto alla sbarra',
          ),
          Week0Exercise(
            name: 'OHP leggero',
            pattern: 'push',
            instructions: 'Pressa sopra la testa, core stabile',
          ),
        ],
      ),

      // Sessione 6 — Full Body Assessment
      Week0Session(
        sessionNumber: 6,
        focus: 'full_body_assessment',
        focusLabel: 'Valutazione Corpo Completo',
        restSeconds: 120,
        reps: 10,
        exercises: const [
          Week0Exercise(
            name: 'Squat',
            pattern: 'squat',
            instructions: 'Talloni a terra, petto alto',
          ),
          Week0Exercise(
            name: 'RDL',
            pattern: 'hinge',
            instructions: 'Schiena neutra, anca indietro',
          ),
          Week0Exercise(
            name: 'Push-up',
            pattern: 'push',
            instructions: 'Corpo rigido, scapole retratte',
          ),
          Week0Exercise(
            name: 'Row',
            pattern: 'pull',
            instructions: 'Inizia dalle scapole',
          ),
          Week0Exercise(
            name: 'Plank',
            pattern: 'core',
            instructions: 'Linea retta testa-talloni',
          ),
          Week0Exercise(
            name: 'Farmer Walk',
            pattern: 'carry',
            instructions: 'Spalle basse, passi corti',
          ),
        ],
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// Week0Trigger
// ---------------------------------------------------------------------------

/// Determina se Week 0 deve attivarsi.
class Week0Trigger {
  Week0Trigger._();

  /// Soglia di inattività in giorni.
  static const inactivityThresholdDays = 14;

  /// Restituisce true se l'utente deve eseguire Week 0.
  ///
  /// Si attiva quando:
  /// - [isNewUser]: utente al primo avvio, nessun workout precedente.
  /// - Inattività: [lastWorkoutDate] > 14 giorni fa.
  /// - Cambio tier: [previousTier] != [currentTier] (cambio livello).
  static bool shouldActivate({
    required bool isNewUser,
    DateTime? lastWorkoutDate,
    int? previousTier,
    int? currentTier,
  }) {
    // Nuovo utente → sempre Week 0.
    if (isNewUser) return true;

    // Inattività prolungata.
    if (lastWorkoutDate != null) {
      final daysSinceLastWorkout =
          DateTime.now().difference(lastWorkoutDate).inDays;
      if (daysSinceLastWorkout > inactivityThresholdDays) return true;
    }

    // Cambio di tier.
    if (previousTier != null &&
        currentTier != null &&
        previousTier != currentTier) {
      return true;
    }

    return false;
  }
}

// ---------------------------------------------------------------------------
// Costanti e regole del protocollo
// ---------------------------------------------------------------------------

/// Regole di completamento per Week 0.
abstract class Week0Rules {
  /// RPE massimo per set prima di interrompere il set.
  static const double stopRpe = 6.0;

  /// RPE massimo medio per superare la sessione.
  static const double maxAvgRpeToPass = 6.0;

  /// Se un set supera questo RPE, la sessione deve essere ripetuta.
  static const double mustRepeatRpe = 7.0;

  /// Numero totale di sessioni richieste.
  static const int totalSessions = 6;

  /// Valuta se una sessione è superata.
  ///
  /// [setRpes] contiene l'RPE di ogni set della sessione.
  /// Restituisce true se la media è ≤ [maxAvgRpeToPass]
  /// e nessun set ha RPE > [mustRepeatRpe].
  static bool evaluateSession(List<double> setRpes) {
    if (setRpes.isEmpty) return false;

    final hasExcessiveRpe = setRpes.any((rpe) => rpe > mustRepeatRpe);
    if (hasExcessiveRpe) return false;

    final avgRpe = setRpes.reduce((a, b) => a + b) / setRpes.length;
    return avgRpe <= maxAvgRpeToPass;
  }

  /// Calcola l'RPE medio da una lista di RPE per set.
  static double computeAvgRpe(List<double> setRpes) {
    if (setRpes.isEmpty) return 0.0;
    return setRpes.reduce((a, b) => a + b) / setRpes.length;
  }
}
