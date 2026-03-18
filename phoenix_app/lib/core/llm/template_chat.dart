import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../database/daos/workout_dao.dart';
import '../database/daos/fasting_dao.dart';
import '../database/daos/conditioning_dao.dart';
import '../database/daos/biomarker_dao.dart';
import '../database/daos/exercise_dao.dart';
import '../database/daos/meal_log_dao.dart';
import '../database/daos/assessment_dao.dart';
import '../database/daos/hrv_dao.dart';
import '../database/daos/cardio_dao.dart';
import '../database/daos/mesocycle_dao.dart';
import '../database/daos/progression_dao.dart';
import '../database/database.dart';
import '../database/tables.dart';
import '../models/cold_progression.dart';
import '../models/nutrition_calculator.dart';
import '../models/sleep_score.dart';


// ─── Fine-grained Intent Detection ──────────────────────────────

enum ChatIntent {
  // Training intents
  trainingStatus,       // "come va l'allenamento" / general training
  trainingNext,         // "cosa devo fare oggi" / next workout
  trainingLast,         // "com'è andato l'ultimo allenamento"
  trainingProgress,     // "sto migliorando?" / progression
  trainingStreak,       // "quanti giorni di fila"
  trainingPlan,         // "che programma seguo" / periodization

  // Fasting intents
  fastingStatus,        // "come va il digiuno"
  fastingActive,        // "a che punto sono" (during fast)
  fastingLevel,         // "a che livello sono" / progression
  fastingTips,          // "consigli per il digiuno"

  // Nutrition intents
  nutritionStatus,      // "cosa ho mangiato oggi"
  nutritionTargets,     // "quante proteine devo mangiare"
  nutritionMeal,        // "cosa mangio a pranzo" / meal plan

  // Weight & body
  weightStatus,         // "quanto peso"
  weightTrend,          // "come va il peso"

  // Conditioning
  coldStatus,           // "freddo" / cold exposure
  heatStatus,           // "caldo" / heat
  meditationStatus,     // "meditazione"
  sleepStatus,          // "come dormo"
  sleepTips,            // "consigli per dormire"
  conditioningOverview, // "condizionamento" general

  // Biomarkers
  biomarkerStatus,      // "i miei biomarker"
  phenoageStatus,       // "phenoage" / biological age
  bloodPanel,           // "analisi del sangue"

  // Recovery & readiness
  recoveryStatus,       // "come sto" / "sono pronto"
  hrvStatus,            // "hrv" / recovery data

  // Assessment
  assessmentStatus,     // "assessment" / "test fisici"

  // Cardio
  cardioStatus,         // "cardio" / cardio sessions

  // Supplements
  supplementStatus,     // "integratori" / "creatina" / "vitamina d"

  // Pain / Injury
  painInjury,           // "dolore" / "infortunio" / "mi fa male"

  // Hydration
  hydrationStatus,      // "quanto devo bere" / "acqua"

  // Longevity
  longevityOverview,    // "longevità" / "ringiovanimento"

  // Protocol
  protocolOverview,     // "protocollo" / "come va" general
  protocolToday,        // "cosa devo fare oggi" (protocol-wide)

  // Emotional / motivational
  motivationLow,        // "non ce la faccio" / "sono stanco"
  motivationCelebrate,  // "grande!" / positive feedback
  greeting,             // "ciao" / "buongiorno"
  thanks,               // "grazie"
  help,                 // "cosa puoi fare" / "aiuto"

  // Catch-all
  general,
}

// ─── Template Chat Engine ─────────────────────────────────────────

/// Advanced rule-based chat engine that generates contextual,
/// coaching-toned responses using real user data from the database.
///
/// Designed to feel like a knowledgeable human coach:
/// - Uses the user's real data (not generic advice)
/// - Varies tone by time of day and context
/// - Remembers conversation within session
/// - Multiple response variants per intent
class TemplateChat {
  final WorkoutDao workoutDao;
  final FastingDao fastingDao;
  final ConditioningDao conditioningDao;
  final BiomarkerDao biomarkerDao;
  final ExerciseDao exerciseDao;
  final MealLogDao? mealLogDao;
  final AssessmentDao? assessmentDao;
  final HrvDao? hrvDao;
  final CardioDao? cardioDao;
  final MesocycleDao? mesocycleDao;
  final ProgressionDao? progressionDao;

  // User profile context (set externally)
  String? userName;
  double? userWeightKg;
  String? userTier;
  int? userAge;
  String? userSex;

  // Conversation memory (within session)
  final List<_ChatTurn> _history = [];
  static final _random = Random();

  TemplateChat({
    required this.workoutDao,
    required this.fastingDao,
    required this.conditioningDao,
    required this.biomarkerDao,
    required this.exerciseDao,
    this.mealLogDao,
    this.assessmentDao,
    this.hrvDao,
    this.cardioDao,
    this.mesocycleDao,
    this.progressionDao,
  });

  /// Set user profile for personalized responses.
  void setUserProfile({
    String? name,
    double? weightKg,
    String? tier,
    int? age,
    String? sex,
  }) {
    userName = name;
    userWeightKg = weightKg;
    userTier = tier;
    userAge = age;
    userSex = sex;
  }

  // ─── Intent Detection ───────────────────────────────────────────

  /// Detect the user's intent from their message.
  /// Priority ordering is critical — compound patterns (multi-word) checked
  /// before single-word patterns to avoid false matches.
  static ChatIntent detect(String input) {
    final lower = input.toLowerCase().trim();

    // ── Layer 0: Greeting / thanks / help (quick exits) ──
    if (_isGreeting(lower)) return ChatIntent.greeting;
    if (_containsAny(lower, ['grazie', 'thanks', 'thx'])) return ChatIntent.thanks;
    if (_containsAny(lower, ['aiuto', 'help', 'cosa puoi', 'cosa sai', 'come funzion', 'spiegami'])) return ChatIntent.help;

    // ── Layer 1: Compound patterns (multi-word, high specificity) ──
    // These MUST be checked before single-word patterns to avoid mismatches.

    // Sleep-specific before motivation (prevents "non riesco a dormire" → motivationLow)
    if (_containsAny(lower, ['non riesco.*dorm', 'non.*dormire', 'insonnia', 'consigli.*sonn', 'dormire.*megli', 'a che ora.*letto', 'andare.*letto', 'orario.*letto'])) return ChatIntent.sleepTips;

    // Pain/injury before motivation (prevents "non ce la faccio per il dolore" → motivationLow)
    if (_containsAny(lower, ['dolore', 'infortun', 'mi fa male', 'male alla', 'male al', 'male ai', 'male alle', 'infiamm.*muscol', 'tendin', 'stiramento'])) return ChatIntent.painInjury;

    // Nutrition-with-food before training (prevents "cosa mangiare prima dell'allenamento" → training)
    if (_containsAny(lower, ['mangiare.*allenam', 'mang.*prima.*allenam', 'cosa.*mang', 'quando.*mang', 'posso mangiare'])) return ChatIntent.nutritionMeal;

    // Rest between sets → training (prevents "recupero tra le serie" → recovery)
    if (_containsAny(lower, ['recupero.*serie', 'pausa.*serie', 'rest.*set'])) return ChatIntent.trainingStatus;

    // Cardio compound patterns (prevents "ho corso" → protocolToday via "oggi")
    if (_containsAny(lower, ['ho corso', 'sono.*cors', 'corsa.*oggi', 'voglio corr'])) return ChatIntent.cardioStatus;

    // ── Layer 2: Motivation / emotional ──
    if (_containsAny(lower, ['non ce la', 'mollare', 'demotiv', 'voglia', 'stressato', 'ansia', 'ansios', 'depresso'])) return ChatIntent.motivationLow;
    // "stanco/fatica" → motivation only if not near sleep/training words
    if (_containsAny(lower, ['stanc', 'fatica']) && !_containsAny(lower, ['sonn', 'dorm', 'letto', 'allenam', 'serie'])) return ChatIntent.motivationLow;
    if (_containsAny(lower, ['grande', 'fantastico', 'ottimo', 'perfetto', 'spettacol', 'wow', 'bravo', 'forte'])) return ChatIntent.motivationCelebrate;

    // ── Layer 3: HRV (very specific keyword) ──
    if (_containsAny(lower, ['hrv', 'variabil'])) return ChatIntent.hrvStatus;

    // ── Layer 4: Recovery / readiness ──
    if (_containsAny(lower, ['pronto.*allenar', 'ready', 'come sto', 'come mi sent'])) return ChatIntent.recoveryStatus;
    // "recupero" alone → recovery (compound "recupero tra le serie" already caught above)
    if (_containsAny(lower, ['recuper'])) return ChatIntent.recoveryStatus;

    // ── Layer 5: Assessment ──
    if (_containsAny(lower, ['assessment', 'test fisic', 'valutazion'])) return ChatIntent.assessmentStatus;

    // ── Layer 6: Training ──
    if (_containsAny(lower, ['prossim.*allenam', 'oggi.*allena', 'cosa.*fare.*oggi', 'workout di oggi'])) return ChatIntent.trainingNext;
    if (_containsAny(lower, ['ultimo.*allena', 'ultima.*session', 'com.*andat'])) return ChatIntent.trainingLast;
    if (_containsAny(lower, ['progress', 'miglior', 'avanz', 'aumentare.*carico', 'posso.*aument'])) return ChatIntent.trainingProgress;
    if (_containsAny(lower, ['streak', 'giorni.*fila', 'consecutiv'])) return ChatIntent.trainingStreak;
    if (_containsAny(lower, ['programma', 'periodizz', 'mesocicl', 'fase', 'blocco', 'deload'])) return ChatIntent.trainingPlan;
    if (_containsAny(lower, ['allenam', 'workout', 'eserciz', 'serie', 'rep', 'muscol', 'training'])) return ChatIntent.trainingStatus;

    // ── Layer 7: Cardio ──
    if (_containsAny(lower, ['cardio', 'tabata', 'hiit', 'norwegian', 'zone 2', 'corsa', 'corr', 'vo2', 'aerob'])) return ChatIntent.cardioStatus;

    // ── Layer 8: Fasting ──
    if (_containsAny(lower, ['livello.*digiun', 'avanzare.*digiun', 'livello.*fast'])) return ChatIntent.fastingLevel;
    if (_containsAny(lower, ['consigli.*digiun', 'tip.*fast'])) return ChatIntent.fastingTips;
    if (_containsAny(lower, ['a che punto', 'quante ore', 'manca.*digiun'])) return ChatIntent.fastingActive;
    // "come va il digiuno" → status (not tips); "fame" → fasting context
    if (_containsAny(lower, ['digiun', 'fast', 'autofag', 'fame'])) return ChatIntent.fastingStatus;

    // ── Layer 9: Nutrition ──
    if (_containsAny(lower, ['protein', 'macro', 'calori', 'quant.*mang'])) return ChatIntent.nutritionTargets;
    if (_containsAny(lower, ['pasto', 'pranzo', 'cena', 'colazion', 'meal', 'mangiare'])) return ChatIntent.nutritionMeal;
    if (_containsAny(lower, ['mangiat', 'cibo', 'nutrizion', 'dieta'])) return ChatIntent.nutritionStatus;

    // ── Layer 10: Weight ──
    if (_containsAny(lower, ['trend.*peso', 'andamento.*peso', 'peso.*scend', 'peso.*sal'])) return ChatIntent.weightTrend;
    if (_containsAny(lower, ['peso', 'kg', 'bilancia', 'massa', 'weight', 'bmi', 'ingrass', 'dimagr'])) return ChatIntent.weightStatus;

    // ── Layer 11: Supplements ──
    if (_containsAny(lower, ['integrator', 'supplement', 'creatina', 'vitamina', 'omega', 'magnesio', 'nmn', 'rhodiola', 'astragal'])) return ChatIntent.supplementStatus;

    // ── Layer 12: Conditioning ──
    if (_containsAny(lower, ['fredd', 'cold', 'doccia.*fredd', 'ghiacci'])) return ChatIntent.coldStatus;
    if (_containsAny(lower, ['cald', 'heat', 'sauna'])) return ChatIntent.heatStatus;
    if (_containsAny(lower, ['meditaz', 'respir', 'mindful', 'breathing'])) return ChatIntent.meditationStatus;
    if (_containsAny(lower, ['sonn', 'sleep', 'dormo', 'dormit', 'riposo.*nott', 'letto'])) return ChatIntent.sleepStatus;
    if (_containsAny(lower, ['condizion', 'stretching', 'mobilit'])) return ChatIntent.conditioningOverview;

    // ── Layer 13: Biomarkers ──
    if (_containsAny(lower, ['phenoage', 'età biolog'])) return ChatIntent.phenoageStatus;
    if (_containsAny(lower, ['sangu', 'analis', 'esam', 'pannello'])) return ChatIntent.bloodPanel;
    if (_containsAny(lower, ['biomark', 'testosteron', 'cortisol', 'infiammaz', 'ferritin', 'glicemia', 'albumin'])) return ChatIntent.biomarkerStatus;

    // ── Layer 14: Hydration ──
    if (_containsAny(lower, ['bere', 'acqua', 'idrataz'])) return ChatIntent.hydrationStatus;

    // ── Layer 15: Longevity ──
    if (_containsAny(lower, ['longevit', 'ringiovan', 'immortal', 'invecchi'])) return ChatIntent.longevityOverview;

    // ── Layer 16: Protocol (broad catch) ──
    if (_containsAny(lower, ['dimmi tutto', 'salute', 'panoramic', 'riepilog', 'come.*andando.*mese', 'come.*andando.*settiман'])) return ChatIntent.protocolOverview;
    if (_containsAny(lower, ['oggi', 'giornata', 'quanto manca'])) return ChatIntent.protocolToday;
    if (_containsAny(lower, ['protocoll', 'status'])) return ChatIntent.protocolOverview;

    return ChatIntent.general;
  }

  static bool _isGreeting(String text) {
    return _containsAny(text, ['ciao', 'buongiorn', 'buonaser', 'buonanott', 'salve', 'hey', 'ehi', 'hello', 'hi ']);
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((k) {
      if (k.contains('.*')) {
        return RegExp(k).hasMatch(text);
      }
      return text.contains(k);
    });
  }

  // ─── Time-of-Day Context ─────────────────────────────────────

  static String _timeGreeting() {
    final h = DateTime.now().hour;
    if (h < 6) return 'Notte fonda';
    if (h < 12) return 'Buongiorno';
    if (h < 18) return 'Buon pomeriggio';
    return 'Buonasera';
  }

  // ─── Response Variants ──────────────────────────────────────────

  static String _pick(List<String> options) =>
      options[_random.nextInt(options.length)];

  // ─── Main Respond ──────────────────────────────────────────────

  /// Generate a contextual response based on the detected intent.
  Future<String> respond(String userMessage) async {
    final intent = detect(userMessage);

    // Track conversation
    _history.add(_ChatTurn(userMessage, intent, DateTime.now()));

    try {
      final response = await _dispatch(intent, userMessage);
      return response;
    } catch (e) {
      debugPrint('TemplateChat.respond error: $e');
      return 'Mi dispiace, c\'è stato un problema nel recuperare i tuoi dati. Riprova tra un attimo.';
    }
  }

  Future<String> _dispatch(ChatIntent intent, String userMessage) async {
    return switch (intent) {
      // Training
      ChatIntent.trainingStatus => _respondTrainingStatus(),
      ChatIntent.trainingNext => _respondTrainingNext(),
      ChatIntent.trainingLast => _respondTrainingLast(),
      ChatIntent.trainingProgress => _respondTrainingProgress(),
      ChatIntent.trainingStreak => _respondTrainingStreak(),
      ChatIntent.trainingPlan => _respondTrainingPlan(),

      // Fasting
      ChatIntent.fastingStatus => _respondFastingStatus(),
      ChatIntent.fastingActive => _respondFastingActive(),
      ChatIntent.fastingLevel => _respondFastingLevel(),
      ChatIntent.fastingTips => _respondFastingTips(),

      // Nutrition
      ChatIntent.nutritionStatus => _respondNutritionStatus(),
      ChatIntent.nutritionTargets => _respondNutritionTargets(),
      ChatIntent.nutritionMeal => _respondNutritionMeal(),

      // Weight
      ChatIntent.weightStatus => _respondWeightStatus(),
      ChatIntent.weightTrend => _respondWeightTrend(),

      // Conditioning
      ChatIntent.coldStatus => _respondColdStatus(),
      ChatIntent.heatStatus => _respondHeatStatus(),
      ChatIntent.meditationStatus => _respondMeditationStatus(),
      ChatIntent.sleepStatus => _respondSleepStatus(),
      ChatIntent.sleepTips => _respondSleepTips(),
      ChatIntent.conditioningOverview => _respondConditioningOverview(),

      // Biomarkers
      ChatIntent.biomarkerStatus => _respondBiomarkerStatus(),
      ChatIntent.phenoageStatus => _respondPhenoageStatus(),
      ChatIntent.bloodPanel => _respondBloodPanel(),

      // Recovery
      ChatIntent.recoveryStatus => _respondRecoveryStatus(),
      ChatIntent.hrvStatus => _respondHrvStatus(),

      // Assessment
      ChatIntent.assessmentStatus => _respondAssessmentStatus(),

      // Cardio
      ChatIntent.cardioStatus => _respondCardioStatus(),

      // Supplements
      ChatIntent.supplementStatus => _respondSupplementStatus(),

      // Pain / Injury
      ChatIntent.painInjury => _respondPainInjury(userMessage),

      // Hydration
      ChatIntent.hydrationStatus => _respondHydrationStatus(),

      // Longevity
      ChatIntent.longevityOverview => _respondLongevityOverview(),

      // Protocol
      ChatIntent.protocolOverview => _respondProtocolOverview(),
      ChatIntent.protocolToday => _respondProtocolToday(),

      // Emotional
      ChatIntent.motivationLow => _respondMotivationLow(),
      ChatIntent.motivationCelebrate => _respondMotivationCelebrate(),
      ChatIntent.greeting => _respondGreeting(),
      ChatIntent.thanks => _respondThanks(),
      ChatIntent.help => _respondHelp(),

      ChatIntent.general => _respondGeneral(),
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // TRAINING RESPONSES
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondTrainingStatus() async {
    final streak = await workoutDao.currentStreak();
    final recentStream = workoutDao.watchRecentSessions(limit: 3);
    final recent = await recentStream.first;
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final weekSessions = await workoutDao.getSessionsInRange(weekStart, now);
    final completed = weekSessions.where((s) => s.endedAt != null).length;

    if (recent.isEmpty) {
      return _pick([
        'Non hai ancora fatto allenamenti. Il primo passo è sempre il più importante — inizia quando vuoi, il protocollo si adatta a te.',
        'Nessuna sessione registrata. Vai su Training e inizia: anche 20 minuti cambiano la traiettoria.',
      ]);
    }

    final last = recent.first;
    final rpe = last.rpeAverage?.toStringAsFixed(1) ?? '-';
    final daysSinceLast = now.difference(last.startedAt).inDays;

    final buf = StringBuffer();

    // Opening — context-aware
    if (daysSinceLast == 0) {
      buf.writeln(_pick([
        'Ti sei allenato oggi — bene.',
        'Sessione di oggi completata.',
      ]));
    } else if (daysSinceLast == 1) {
      buf.writeln('Ultima sessione ieri. RPE medio: $rpe.');
    } else if (daysSinceLast > 3) {
      buf.writeln('Sono $daysSinceLast giorni dall\'ultima sessione. Il corpo ha recuperato — è ora di muoversi.');
    } else {
      buf.writeln('$completed sessioni questa settimana. Streak: $streak giorni.');
    }

    // Exercise names from last session
    final sets = await workoutDao.getSetsForSession(last.id);
    if (sets.isNotEmpty) {
      final exerciseIds = sets.map((s) => s.exerciseId).toSet();
      final exercises = await exerciseDao.getByIds(exerciseIds);
      final names = exercises.map((e) => e.name).toList();
      if (names.isNotEmpty) {
        buf.writeln('Ultimo lavoro: ${names.join(", ")}.');
      }
    }

    // Coaching insight based on data
    final rpeVal = last.rpeAverage ?? 0;
    buf.writeln();
    if (rpeVal >= 9) {
      buf.write(_pick([
        'L\'RPE dell\'ultima sessione era alto. Ascolta il corpo — un giorno di scarico non è debolezza, è strategia.',
        'RPE $rpe: forte intensità. Se la tecnica ha tenuto, ottimo. Altrimenti, scala il carico.',
      ]));
    } else if (rpeVal >= 7) {
      buf.write(_pick([
        'RPE $rpe — zona di lavoro ideale. Stai spingendo abbastanza da stimolare adattamento senza rischiare.',
        'Intensità giusta. Continua così, il progresso viene dalla costanza in questa zona.',
      ]));
    } else if (rpeVal > 0 && rpeVal < 6) {
      buf.write(_pick([
        'RPE $rpe — puoi dare di più. Se completi tutte le rep con facilità, è tempo di progredire.',
        'L\'intensità era bassa. Prova ad aumentare carico o tempo sotto tensione.',
      ]));
    } else {
      buf.write('$completed sessioni questa settimana. La costanza è il miglior integratore.');
    }

    return buf.toString();
  }

  Future<String> _respondTrainingNext() async {
    final today = await workoutDao.getTodaySessions();
    final todayCompleted = today.where((s) => s.endedAt != null).length;

    if (todayCompleted > 0) {
      return _pick([
        'Hai già completato l\'allenamento di oggi. Recupero attivo: cammina, stretcha, idratati.',
        'Oggi hai già fatto la tua sessione. Se vuoi, puoi fare mobilità o una camminata — ma non sovraccaricare.',
      ]);
    }

    final now = DateTime.now();
    final weekday = now.weekday; // 1=Monday

    // Rest days: Sunday (7)
    if (weekday == 7) {
      return _pick([
        'Domenica è riposo. Camminata, mobilità, niente di più. Il corpo cresce a riposo.',
        'Oggi si riposa. Stretching leggero, camminata. Domani si ricomincia.',
      ]);
    }

    // Cardio days: Wednesday (3), Saturday (6)
    if (weekday == 3 || weekday == 6) {
      return _pick([
        'Oggi è giorno di cardio. Tabata o Norwegian — scegli in base a come ti senti.',
        'Giorno cardio. Il VO2max è il miglior predittore di longevità — oggi lo alleniamo.',
      ]);
    }

    final h = now.hour;
    if (h < 10) {
      return _pick([
        'La sessione di oggi ti aspetta. Meglio allenarsi al mattino: cortisolo alto, performance migliore.',
        'Buon momento per allenarsi. Riscaldamento, focus, qualità.',
      ]);
    } else if (h < 16) {
      return _pick([
        'Ancora tempo per la sessione di oggi. Il pomeriggio è ottimo per la forza — temperatura corporea al picco.',
        'Sessione di oggi: vai su Training per iniziare. Meglio adesso che stasera.',
      ]);
    } else {
      return _pick([
        'La giornata sta finendo. C\'è ancora tempo per la sessione — anche breve.',
        'Non hai ancora fatto l\'allenamento di oggi. Anche 25 minuti sono sufficienti.',
      ]);
    }
  }

  Future<String> _respondTrainingLast() async {
    final recentStream = workoutDao.watchRecentSessions(limit: 1);
    final recent = await recentStream.first;

    if (recent.isEmpty) {
      return 'Non ho sessioni registrate. Fai il primo allenamento e poi ne parliamo.';
    }

    final last = recent.first;
    final duration = last.durationMinutes?.toStringAsFixed(0) ?? '?';
    final rpe = last.rpeAverage?.toStringAsFixed(1) ?? '-';
    final score = last.durationScore;
    final daysSince = DateTime.now().difference(last.startedAt).inDays;

    final sets = await workoutDao.getSetsForSession(last.id);
    final exerciseIds = sets.map((s) => s.exerciseId).toSet();
    final exercises = await exerciseDao.getByIds(exerciseIds);
    final names = exercises.map((e) => e.name).toList();

    final totalReps = sets.fold<int>(0, (sum, s) => sum + (s.repsCompleted));
    final totalSets = sets.length;

    final buf = StringBuffer();

    // When
    final whenLabel = daysSince == 0 ? 'Oggi' : daysSince == 1 ? 'Ieri' : '$daysSince giorni fa';
    buf.writeln('$whenLabel — $duration minuti, $totalSets serie, $totalReps rep totali.');

    if (names.isNotEmpty) {
      buf.writeln('Esercizi: ${names.join(", ")}.');
    }

    buf.writeln('RPE medio: $rpe.');

    if (score != null) {
      final label = switch (score) {
        DurationScore.green => 'ottima gestione del tempo',
        DurationScore.yellow => 'nella norma',
        DurationScore.red => 'sessione lunga — valuta di ridurre le pause',
        _ => '',
      };
      if (label.isNotEmpty) buf.writeln('Durata: $label.');
    }

    // Coaching comment
    buf.writeln();
    final rpeVal = last.rpeAverage ?? 0;
    if (rpeVal >= 9) {
      buf.write('Sessione intensa. Se l\'RPE resta alto per 2+ sessioni di fila, serve un deload.');
    } else if (rpeVal >= 7) {
      buf.write('Buon lavoro. Questa è la zona dove il corpo si adatta — non troppo facile, non troppo duro.');
    } else if (rpeVal > 0) {
      buf.write('RPE basso — se riesci a completare tutto con facilità, il corpo è pronto per il prossimo livello.');
    }

    return buf.toString();
  }

  Future<String> _respondTrainingProgress() async {
    final streak = await workoutDao.currentStreak();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthSessions = await workoutDao.getSessionsInRange(monthStart, now);
    final completed = monthSessions.where((s) => s.endedAt != null).length;

    final buf = StringBuffer();
    buf.writeln('$completed sessioni questo mese. Streak attuale: $streak giorni.');

    // Check mesocycle if available
    if (mesocycleDao != null) {
      final meso = await mesocycleDao!.getCurrentMesocycle();
      if (meso != null) {
        final phase = _phaseDescription(meso);
        buf.writeln('Fase attuale: $phase.');
      }
    }

    // RPE trend from last 5 sessions
    final recentStream = workoutDao.watchRecentSessions(limit: 5);
    final recent = await recentStream.first;
    if (recent.length >= 3) {
      final rpes = recent.where((s) => s.rpeAverage != null).map((s) => s.rpeAverage!).toList();
      if (rpes.length >= 3) {
        final avgRpe = rpes.reduce((a, b) => a + b) / rpes.length;
        buf.writeln('RPE medio ultime ${rpes.length} sessioni: ${avgRpe.toStringAsFixed(1)}.');

        // Trend
        final firstHalf = rpes.sublist(0, rpes.length ~/ 2);
        final secondHalf = rpes.sublist(rpes.length ~/ 2);
        final avgFirst = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
        final avgSecond = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

        buf.writeln();
        if (avgSecond > avgFirst + 0.5) {
          buf.write('L\'RPE sta salendo — il corpo si sta caricando. Se supera 9 costantemente, considera un deload.');
        } else if (avgSecond < avgFirst - 0.5) {
          buf.write('L\'RPE sta scendendo — stai diventando più efficiente. Buon segno: il corpo si adatta.');
        } else {
          buf.write('RPE stabile — stai mantenendo un\'intensità costante. La base si costruisce così.');
        }
      }
    }

    return buf.toString();
  }

  Future<String> _respondTrainingStreak() async {
    final streak = await workoutDao.currentStreak();

    if (streak == 0) {
      return _pick([
        'Nessuna streak attiva. Oggi è il giorno giusto per iniziarne una.',
        'La streak parte da zero. Un allenamento oggi e domani — hai già una streak di 2.',
      ]);
    }

    if (streak >= 14) {
      return '$streak giorni consecutivi. Disciplina rara. Assicurati di includere i giorni di scarico — la costanza conta, ma anche il recupero.';
    }
    if (streak >= 7) {
      return '$streak giorni di fila. Una settimana intera senza saltare. Pochi ci riescono. Continua.';
    }
    if (streak >= 3) {
      return _pick([
        '$streak giorni consecutivi. Lo slancio si costruisce. Non fermarti adesso.',
        'Streak di $streak giorni. Il corpo si sta adattando alla regolarità — questo è il punto di svolta.',
      ]);
    }
    return _pick([
      '$streak giorno${streak > 1 ? "i" : ""} di fila. Ogni giorno aggiunto è un mattone.',
      'Streak: $streak. Costruisci l\'abitudine. Dopo 21 giorni diventa automatica.',
    ]);
  }

  Future<String> _respondTrainingPlan() async {
    if (mesocycleDao == null) {
      return 'Il tuo programma segue una progressione basata sul livello (${userTier ?? "beginner"}). Ogni sessione adatta automaticamente volume e intensità.';
    }

    final meso = await mesocycleDao!.getCurrentMesocycle();
    if (meso == null) {
      return 'Nessun mesociclo attivo. Il prossimo allenamento ne inizierà uno automaticamente.';
    }

    final phase = _phaseDescription(meso);
    final tier = meso.tier;

    final buf = StringBuffer();
    buf.writeln('Programma: ${_tierLabel(tier)}.');
    buf.writeln('$phase.');
    buf.writeln('Mesociclo #${meso.mesocycleNumber}, settimana ${meso.weekInMesocycle}.');

    // Periodization description
    buf.writeln();
    buf.write(switch (tier) {
      'beginner' => 'Periodizzazione lineare: 4 settimane, carico progressivo. Impari i movimenti e costruisci la base.',
      'intermediate' => 'DUP (Daily Undulating): 6+1 settimane. Stimoli diversi ogni giorno per massimizzare l\'adattamento.',
      'advanced' => 'Periodizzazione a blocchi (Verkhoshansky): accumulo → trasformazione → realizzazione → deload.',
      _ => 'Progressione adattativa basata sul tuo livello.',
    });

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // FASTING RESPONSES
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondFastingStatus() async {
    // Check for active fast first
    final active = await fastingDao.getActiveFast();
    if (active != null) return _respondFastingActive();

    final last = await fastingDao.getLastCompleted();
    if (last == null) {
      return _pick([
        'Non hai ancora completato un digiuno. Il protocollo Phoenix include il digiuno intermittente come pilastro — inizia con 14 ore.',
        'Nessun digiuno registrato. Prova il livello 1: 14 ore di digiuno, 10 ore di finestra alimentare. Il corpo si adatta in 3-5 giorni.',
      ]);
    }

    final buf = StringBuffer();
    buf.writeln('Livello digiuno: ${last.level}.');
    buf.writeln('Ultimo completato: ${last.actualHours?.toStringAsFixed(1) ?? "?"}h su ${last.targetHours.toInt()}h target.');

    if (last.toleranceScore != null) {
      buf.writeln('Tolleranza: ${last.toleranceScore!.toStringAsFixed(1)}/5.');
    }

    // Level progression
    final nextLevel = last.level + 1;
    if (nextLevel <= 3) {
      final canAdvance = await fastingDao.canAdvanceToLevel(nextLevel);
      final stats = await fastingDao.getLevelStats(last.level);
      buf.writeln();
      if (canAdvance) {
        buf.write('Hai le carte per passare al livello $nextLevel. ${stats.goodTolerance} sessioni con buona tolleranza — sei pronto.');
      } else {
        buf.write('${stats.total} sessioni al livello ${last.level} (${stats.goodTolerance} con buona tolleranza). Consolida prima di avanzare.');
      }
    }

    return buf.toString();
  }

  Future<String> _respondFastingActive() async {
    final active = await fastingDao.getActiveFast();
    if (active == null) {
      return 'Nessun digiuno attivo al momento. Avvia un nuovo digiuno dalla tab Fasting.';
    }

    final elapsed = DateTime.now().difference(active.startedAt);
    final hoursElapsed = elapsed.inMinutes / 60;
    final remaining = (active.targetHours - hoursElapsed).clamp(0.0, 999.0);
    final water = active.waterCount;

    final buf = StringBuffer();
    buf.writeln('Digiuno in corso: ${hoursElapsed.toStringAsFixed(1)}h / ${active.targetHours.toInt()}h.');

    if (remaining <= 0) {
      buf.writeln('Obiettivo raggiunto! Puoi terminare il digiuno.');
      buf.write('Refeeding: inizia con proteine e vegetali. Evita zuccheri semplici.');
    } else if (remaining <= 2) {
      buf.writeln('Quasi fatto — ${remaining.toStringAsFixed(1)}h rimaste.');
      buf.write(_pick([
        'L\'ultimo tratto è il più duro ma anche il più benefico. Tieni duro.',
        'Le ultime ore sono quelle dove l\'autofagia accelera. Resisti.',
      ]));
    } else {
      buf.writeln('${remaining.toStringAsFixed(1)}h rimaste.');
      buf.writeln('Acqua bevuta: $water bicchieri.');
      buf.write(water < 4
          ? 'Bevi di più — l\'idratazione è fondamentale durante il digiuno.'
          : 'Buona idratazione. Continua così.');
    }

    return buf.toString();
  }

  Future<String> _respondFastingLevel() async {
    final last = await fastingDao.getLastCompleted();
    if (last == null) {
      return 'Inizi dal livello 1: 14 ore di digiuno. Il corpo si adatta velocemente — i primi 3 giorni sono i più duri, poi diventa naturale.';
    }

    final level = last.level;
    final stats = await fastingDao.getLevelStats(level);
    final nextLevel = level + 1;

    final buf = StringBuffer();
    buf.writeln('Livello attuale: $level.');
    buf.writeln('Sessioni completate: ${stats.total}.');
    buf.writeln('Con buona tolleranza (≥3/5): ${stats.goodTolerance}.');

    if (nextLevel <= 3) {
      final canAdvance = await fastingDao.canAdvanceToLevel(nextLevel);
      final criteria = switch (nextLevel) {
        2 => '7 sessioni totali + 5 con tolleranza ≥3',
        3 => '14 sessioni totali + 10 con tolleranza ≥3',
        _ => '',
      };
      buf.writeln();
      buf.writeln('Per livello $nextLevel: $criteria.');

      if (canAdvance) {
        buf.write('Criteri raggiunti! Puoi provare il livello $nextLevel.');
      } else {
        buf.write('Non ancora. Continua a consolidare — non c\'è fretta.');
      }
    } else {
      buf.writeln();
      buf.write('Sei al massimo. Livello 3: digiuno avanzato. Il corpo è adattato.');
    }

    return buf.toString();
  }

  Future<String> _respondFastingTips() async {
    return _pick([
      'Consigli per il digiuno:\n'
          '• Bevi 2-3 litri di acqua al giorno\n'
          '• Caffè nero e tè sono ok (senza zucchero)\n'
          '• I primi 3 giorni sono i più duri\n'
          '• Se ti gira la testa, un pizzico di sale nell\'acqua\n'
          '• La fame arriva a onde — passa in 20 minuti',
      'Le basi del digiuno Phoenix:\n'
          '• Elettroliti: sodio, potassio, magnesio\n'
          '• Occupati — la fame è spesso noia\n'
          '• Non rompere il digiuno con zuccheri\n'
          '• Refeeding: proteine prima, poi vegetali\n'
          '• L\'autofagia accelera dopo le 16 ore',
    ]);
  }

  // ═══════════════════════════════════════════════════════════════
  // NUTRITION RESPONSES
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondNutritionStatus() async {
    if (mealLogDao == null) {
      return 'Registra i pasti dalla tab Nutrizione per avere un quadro completo.';
    }

    final today = DateTime.now();
    final meals = await mealLogDao!.getMealsForDay(today);

    if (meals.isEmpty) {
      return _pick([
        'Nessun pasto registrato oggi. Logga quello che mangi — non serve pesare tutto, basta stimare le proteine.',
        'Oggi ancora niente registrato. Inizia a loggare: è il primo passo per ottimizzare la nutrizione.',
      ]);
    }

    final buf = StringBuffer();
    buf.writeln('Oggi: ${meals.length} past${meals.length == 1 ? "o" : "i"} registrat${meals.length == 1 ? "o" : "i"}.');

    // Estimate protein if available
    final proteinMeals = meals.where((m) => m.proteinEstimate.isNotEmpty).toList();
    if (proteinMeals.isNotEmpty) {
      const proteinLabels = {
        'low': 'bassa',
        'medium': 'media',
        'high': 'alta',
        'very_high': 'molto alta',
      };
      buf.writeln('Stima proteine: ${proteinMeals.map((m) => proteinLabels[m.proteinEstimate] ?? m.proteinEstimate).join(", ")}.');
    }

    final weight = userWeightKg ?? 70.0;
    final target = NutritionCalculator(weightKg: weight, tier: userTier ?? 'beginner').dailyProteinGrams;
    buf.writeln();
    buf.write('Target giornaliero: ${target.toStringAsFixed(0)}g proteine (${(target / weight).toStringAsFixed(1)} g/kg).');

    return buf.toString();
  }

  Future<String> _respondNutritionTargets() async {
    final weight = userWeightKg ?? 70.0;
    final tier = userTier ?? 'beginner';
    final calc = NutritionCalculator(weightKg: weight, tier: tier);

    final weekday = DateTime.now().weekday;
    final dayType = _dayTypeForWeekday(weekday);
    final macros = MacroTargets.forDay(weightKg: weight, dayType: dayType, tier: tier);

    final buf = StringBuffer();
    buf.writeln('Target per oggi (${macros.dayTypeLabel}):');
    buf.writeln('• Proteine: ${macros.proteinG.toStringAsFixed(0)}g (${(macros.proteinG / weight).toStringAsFixed(1)} g/kg)');
    buf.writeln('• Carboidrati: ${macros.carbG.toStringAsFixed(0)}g');
    buf.writeln('• Grassi: ${macros.fatG.toStringAsFixed(0)}g');
    buf.writeln('• Fibre: ${macros.fiberG.toStringAsFixed(0)}g');
    buf.writeln('• Calorie: ~${macros.totalKcal.toStringAsFixed(0)} kcal');
    buf.writeln();
    buf.write('Proteine per pasto: ${calc.perMealProteinMin.toStringAsFixed(0)}-${calc.perMealProteinMax.toStringAsFixed(0)}g in ${calc.recommendedMeals} pasti.');

    return buf.toString();
  }

  Future<String> _respondNutritionMeal() async {
    final weight = userWeightKg ?? 70.0;
    final weekday = DateTime.now().weekday;
    final dayType = _dayTypeForWeekday(weekday);

    return _pick([
      'Oggi è giorno $dayType. Focus su proteine ad ogni pasto (${(weight * 0.4).toStringAsFixed(0)}-${(weight * 0.55).toStringAsFixed(0)}g/pasto). Dai priorità a cibi del tier 1-2: salmone, uova, spinaci, mirtilli.',
      'Per il tuo peso (${weight.toStringAsFixed(0)}kg), ogni pasto dovrebbe avere almeno ${(weight * 0.4).toStringAsFixed(0)}g di proteine. Fonti top: pesce, uova, legumi, pollo. Verdure a volontà.',
    ]);
  }

  // ═══════════════════════════════════════════════════════════════
  // WEIGHT RESPONSES
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondWeightStatus() async {
    final weights = await biomarkerDao.getByType(BiomarkerType.weight, limit: 1);
    if (weights.isEmpty) {
      return 'Nessun peso registrato. Vai su Biomarker → Peso per iniziare il tracking. Pesati al mattino a digiuno per dati coerenti.';
    }

    final data = _parseValuesJson(weights.first.valuesJson);
    if (data == null) return 'Dati peso non disponibili.';
    final w = (data['weight_kg'] as num?)?.toDouble();
    if (w == null) return 'Dati peso non disponibili.';

    final buf = StringBuffer();
    buf.writeln('Peso attuale: ${w.toStringAsFixed(1)} kg.');

    final height = (data['height_cm'] as num?)?.toDouble();
    if (height != null && height > 0) {
      final bmi = w / ((height / 100) * (height / 100));
      buf.writeln('BMI: ${bmi.toStringAsFixed(1)}.');
    }

    buf.writeln();
    buf.write('Il peso è solo un numero. Quello che conta è la composizione corporea e il PhenoAge. Non ossessionarti con la bilancia.');

    return buf.toString();
  }

  Future<String> _respondWeightTrend() async {
    final weights = await biomarkerDao.getByType(BiomarkerType.weight, limit: 14);
    if (weights.length < 2) {
      return 'Servono almeno 2 pesate per vedere un trend. Pesati regolarmente al mattino.';
    }

    final latest = _parseValuesJson(weights.first.valuesJson);
    final oldest = _parseValuesJson(weights.last.valuesJson);
    if (latest == null || oldest == null) return 'Dati insufficienti per il trend.';

    final w1 = (latest['weight_kg'] as num?)?.toDouble();
    final w2 = (oldest['weight_kg'] as num?)?.toDouble();
    if (w1 == null || w2 == null) return 'Dati insufficienti.';

    final delta = w1 - w2;
    final days = weights.first.date.difference(weights.last.date).inDays;
    final sign = delta >= 0 ? '+' : '';

    final buf = StringBuffer();
    buf.writeln('Trend ultime ${weights.length} pesate ($days giorni):');
    buf.writeln('$sign${delta.toStringAsFixed(1)} kg (${w2.toStringAsFixed(1)} → ${w1.toStringAsFixed(1)} kg).');
    buf.writeln();

    if (delta.abs() < 0.5) {
      buf.write('Peso stabile — coerente con un protocollo di ricomposizione corporea.');
    } else if (delta > 1.5) {
      buf.write('Aumento significativo. Se intenzionale (fase di massa), ok. Altrimenti, rivedi le calorie.');
    } else if (delta < -1.5) {
      buf.write('Calo marcato. Se rapido (>1kg/settimana), rischi di perdere massa muscolare. Rallenta.');
    } else if (delta > 0) {
      buf.write('Leggero aumento — può essere massa muscolare se ti stai allenando con costanza.');
    } else {
      buf.write('Leggero calo — coerente con il protocollo se la forza tiene.');
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // CONDITIONING RESPONSES
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondColdStatus() async {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final sessions = await conditioningDao.getByTypeInRange(ConditioningType.cold, weekStart, now);
    final streak = await conditioningDao.currentStreak(ConditioningType.cold);
    final firstDate = await conditioningDao.getFirstSessionDate(ConditioningType.cold);

    final buf = StringBuffer();

    if (sessions.isEmpty && firstDate == null) {
      return _pick([
        'Non hai ancora fatto esposizione al freddo. Inizia con 30 secondi di doccia fredda a fine doccia. Sì, fa schifo i primi 3 secondi. Poi passa.',
        'Zero sessioni freddo. Il protocollo Phoenix include 11 minuti settimanali di freddo. Inizia con poco — 30 secondi. Il corpo si adatta.',
      ]);
    }

    final week = firstDate != null ? ColdProgression.currentWeek(firstDate) : 1;
    final totalDose = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);

    buf.writeln('Freddo questa settimana: ${sessions.length} sessioni, ${_formatDuration(totalDose)} totali.');
    buf.writeln('Target per sessione: ${ColdProgression.targetFormatted(week)} (settimana $week).');
    buf.writeln('Dose settimanale: ${_formatDuration(totalDose)} / ${_formatDuration(ColdProgression.weeklyDoseTargetSeconds)}.');
    buf.writeln('Streak: $streak giorni.');

    // Safety check
    final lastStrength = await workoutDao.lastStrengthEndTime();
    if (lastStrength != null) {
      final hours = ColdProgression.hoursSinceStrength(lastStrength);
      if (hours != null && hours < 6) {
        buf.writeln();
        buf.write('⚠ Allenamento di forza ${hours.toStringAsFixed(1)}h fa. Aspetta almeno 6h prima del freddo — altrimenti inibisci l\'adattamento muscolare.');
        return buf.toString();
      }
    }

    buf.writeln();
    if (totalDose >= ColdProgression.weeklyDoseTargetSeconds) {
      buf.write('Dose settimanale raggiunta! Il sistema noradrenergico ringrazia.');
    } else {
      buf.write(_pick([
        'Il freddo è il protocollo più odiato e più efficace. Dopamina +250% senza effetti collaterali.',
        'Ogni sessione di freddo è un reset del sistema nervoso. Continua.',
      ]));
    }

    return buf.toString();
  }

  Future<String> _respondHeatStatus() async {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final sessions = await conditioningDao.getByTypeInRange(ConditioningType.heat, weekStart, now);
    final streak = await conditioningDao.currentStreak(ConditioningType.heat);

    if (sessions.isEmpty) {
      return _pick([
        'Nessuna sessione di calore questa settimana. Sauna, bagno caldo, o anche solo 15 minuti di sole — le heat shock proteins proteggono le cellule.',
        'Zero sessioni calore. L\'esposizione al caldo attiva le heat shock proteins — proteine che riparano e proteggono. Prova una sauna questa settimana.',
      ]);
    }

    final totalMin = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds) ~/ 60;
    return 'Calore questa settimana: ${sessions.length} sessioni, $totalMin minuti. Streak: $streak giorni. Le heat shock proteins si attivano sopra i 40°C per 15+ minuti.';
  }

  Future<String> _respondMeditationStatus() async {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final sessions = await conditioningDao.getByTypeInRange(ConditioningType.meditation, weekStart, now);
    final streak = await conditioningDao.currentStreak(ConditioningType.meditation);

    if (sessions.isEmpty) {
      return _pick([
        'Nessuna meditazione questa settimana. Anche 5 minuti di box breathing (4-4-4-4) fanno la differenza sul cortisolo.',
        'Zero meditazione. Il protocollo include la respirazione guidata — prova il box breathing: 4s inspira, 4s trattieni, 4s espira, 4s pausa.',
      ]);
    }

    final totalMin = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds) ~/ 60;
    return _pick([
      '${sessions.length} sessioni di meditazione questa settimana, $totalMin minuti. Streak: $streak giorni. Il cortisolo scende, l\'HRV sale. Continua.',
      'Meditazione: $totalMin minuti questa settimana. $streak giorni consecutivi. La costanza qui è tutto — anche 5 minuti al giorno cambiano la neurofisiologia.',
    ]);
  }

  Future<String> _respondSleepStatus() async {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final sessions = await conditioningDao.getByTypeInRange(ConditioningType.sleep, weekStart, now);

    if (sessions.isEmpty) {
      return 'Nessun dato sonno registrato questa settimana. Logga sonno e risveglio — la regolarità del sonno è il predittore #1 della qualità.';
    }

    // Parse sleep entries
    final entries = <SleepEntry>[];
    for (final s in sessions) {
      final entry = SleepScore.fromNotesJson(s.notes.isEmpty ? '{}' : s.notes, s.date);
      if (entry != null) entries.add(entry);
    }

    if (entries.isEmpty) {
      return '${sessions.length} notti registrate ma dati incompleti. Assicurati di inserire orario letto e sveglia.';
    }

    final avg = SleepScore.averageDuration(entries);
    final regularity = SleepScore.regularity(entries);

    final buf = StringBuffer();
    buf.writeln('Sonno ultima settimana (${entries.length} notti):');
    buf.writeln('• Durata media: ${avg.inHours}h ${avg.inMinutes % 60}min.');
    buf.writeln('• Regolarità: ${regularity.label} (±${regularity.stdDevMinutes.toStringAsFixed(0)} min).');

    buf.writeln();
    if (avg.inMinutes < 390) { // < 6.5h
      buf.write('Dormi poco. Sotto le 7 ore il testosterone cala del 10-15% e il cortisolo sale. Prioritizza il sonno.');
    } else if (avg.inMinutes < 450) { // < 7.5h
      buf.write('Buono ma c\'è margine. Punta a 7.5-8 ore. Il recupero muscolare avviene durante il sonno profondo.');
    } else {
      buf.write('Ottima durata. La chiave ora è la regolarità — stessi orari ogni giorno, weekend inclusi.');
    }

    return buf.toString();
  }

  Future<String> _respondSleepTips() async {
    return _pick([
      'I fondamentali del sonno Phoenix:\n'
          '• Camera a 18-19°C — il corpo deve raffreddarsi per addormentarsi\n'
          '• Niente schermi 1-2h prima — la luce blu blocca la melatonina\n'
          '• Caffè solo prima delle 14:00\n'
          '• Stesso orario ogni giorno, anche nel weekend\n'
          '• Oscurità totale — anche un LED può disturbare',
      'Protocollo sonno ottimale:\n'
          '• Esposizione alla luce solare mattutina (10 min)\n'
          '• Ultimo pasto 3h prima di dormire\n'
          '• Magnesio glicinate 400mg alla sera\n'
          '• Niente alcol — sopprime il sonno REM\n'
          '• Piedi caldi, testa fresca (Pao Jiao)',
    ]);
  }

  Future<String> _respondConditioningOverview() async {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));

    final cold = await conditioningDao.getByTypeInRange(ConditioningType.cold, weekStart, now);
    final heat = await conditioningDao.getByTypeInRange(ConditioningType.heat, weekStart, now);
    final med = await conditioningDao.getByTypeInRange(ConditioningType.meditation, weekStart, now);
    final sleep = await conditioningDao.getByTypeInRange(ConditioningType.sleep, weekStart, now);

    final coldStreak = await conditioningDao.currentStreak(ConditioningType.cold);
    final medStreak = await conditioningDao.currentStreak(ConditioningType.meditation);

    final buf = StringBuffer();
    buf.writeln('Condizionamento questa settimana:');
    buf.writeln('• Freddo: ${cold.length} sessioni (streak: $coldStreak gg)');
    buf.writeln('• Caldo: ${heat.length} sessioni');
    buf.writeln('• Meditazione: ${med.length} sessioni (streak: $medStreak gg)');
    buf.writeln('• Sonno: ${sleep.length} notti registrate');

    final missing = <String>[];
    if (cold.isEmpty) missing.add('freddo');
    if (heat.isEmpty) missing.add('caldo');
    if (med.isEmpty) missing.add('meditazione');
    if (sleep.isEmpty) missing.add('sonno');

    buf.writeln();
    if (missing.isEmpty) {
      buf.write(_pick([
        'Tutti i pilastri del condizionamento coperti. Eccellente disciplina.',
        'Nessun buco nel condizionamento. Questo è il livello.',
      ]));
    } else if (missing.length <= 2) {
      buf.write('Ti manca: ${missing.join(" e ")}. Aggiungi${missing.length == 1 ? "lo" : "li"} — ogni pilastro conta.');
    } else {
      buf.write('Il condizionamento è un pilastro del protocollo. Inizia con freddo e meditazione — 5 minuti ciascuno.');
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // BIOMARKER RESPONSES
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondBiomarkerStatus() async {
    final phenoage = await biomarkerDao.getLatestByType(BiomarkerType.phenoage);
    final blood = await biomarkerDao.getLatestByType(BiomarkerType.bloodPanel);
    final weight = await biomarkerDao.getLatestByType(BiomarkerType.weight);

    if (phenoage == null && blood == null && weight == null) {
      return 'Nessun biomarker registrato. Le analisi del sangue sono il GPS del protocollo — senza dati, navighi a vista. Fai un pannello base.';
    }

    final buf = StringBuffer();
    buf.writeln('I tuoi biomarker:');

    if (phenoage != null) {
      final data = _parseValuesJson(phenoage.valuesJson);
      final age = data?['pheno_age'];
      if (age != null) {
        buf.writeln('• PhenoAge: $age anni.');
        if (userAge != null) {
          final diff = (age as num).toDouble() - userAge!;
          buf.writeln('  ${diff < 0 ? "${diff.abs().toStringAsFixed(1)} anni più giovane" : "${diff.toStringAsFixed(1)} anni più vecchio"} dell\'età anagrafica.');
        }
      }
    }

    if (blood != null) {
      final days = DateTime.now().difference(blood.date).inDays;
      buf.writeln('• Ultimo pannello sangue: $days giorni fa${days > 90 ? " — tempo di aggiornare" : ""}.');
    }

    if (weight != null) {
      final data = _parseValuesJson(weight.valuesJson);
      final w = (data?['weight_kg'] as num?)?.toDouble();
      if (w != null) buf.writeln('• Peso: ${w.toStringAsFixed(1)} kg.');
    }

    buf.writeln();
    buf.write('Il PhenoAge è l\'indicatore chiave. Ogni punto in meno = anni di vita biologica guadagnati.');

    return buf.toString();
  }

  Future<String> _respondPhenoageStatus() async {
    final phenoage = await biomarkerDao.getLatestByType(BiomarkerType.phenoage);
    if (phenoage == null) {
      return 'PhenoAge non calcolato. Servono le analisi del sangue (9 marcatori + età). Vai su Biomarker → PhenoAge per i dettagli.';
    }

    final data = _parseValuesJson(phenoage.valuesJson);
    final age = (data?['pheno_age'] as num?)?.toDouble();
    if (age == null) return 'Dati PhenoAge non disponibili.';

    final buf = StringBuffer();
    buf.writeln('PhenoAge: ${age.toStringAsFixed(1)} anni.');

    if (userAge != null) {
      final diff = age - userAge!;
      if (diff < -5) {
        buf.writeln('${diff.abs().toStringAsFixed(1)} anni più giovane — risultato eccezionale.');
        buf.write('Il protocollo sta funzionando. Continua così.');
      } else if (diff < 0) {
        buf.writeln('${diff.abs().toStringAsFixed(1)} anni più giovane — buon risultato.');
        buf.write('C\'è margine di miglioramento. Focus su sonno, digiuno e infiammazione.');
      } else {
        buf.writeln('${diff.toStringAsFixed(1)} anni sopra l\'età anagrafica.');
        buf.write('Le aree di intervento principali: infiammazione (hsCRP), glucosio a digiuno, albumina. Il protocollo lavora su tutte.');
      }
    }

    return buf.toString();
  }

  Future<String> _respondBloodPanel() async {
    final blood = await biomarkerDao.getLatestByType(BiomarkerType.bloodPanel);
    if (blood == null) {
      return 'Nessun pannello sangue registrato. Le analisi sono fondamentali: il protocollo si adatta ai tuoi valori. Fai almeno un pannello base.';
    }

    final days = DateTime.now().difference(blood.date).inDays;
    final buf = StringBuffer();
    buf.writeln('Ultimo pannello: $days giorni fa.');

    if (days > 180) {
      buf.write('Sono più di 6 mesi — tempo di ripetere le analisi. Il corpo cambia, i dati devono seguire.');
    } else if (days > 90) {
      buf.write('Più di 3 mesi. Valuta un aggiornamento per monitorare i progressi del protocollo.');
    } else {
      buf.write('Analisi recenti — i dati sono attuali. Controlla la dashboard biomarker per i trend.');
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // RECOVERY / HRV
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondRecoveryStatus() async {
    final recentStream = workoutDao.watchRecentSessions(limit: 3);
    final recent = await recentStream.first;

    final buf = StringBuffer();

    // HRV if available
    if (hrvDao != null) {
      final todayHrv = await hrvDao!.getTodayReading();
      if (todayHrv != null) {
        buf.writeln('HRV oggi: ${todayHrv.rmssd.toStringAsFixed(1)} ms (lnRMSSD: ${todayHrv.lnRmssd.toStringAsFixed(2)}).');
      }
    }

    // Recent RPE trend
    if (recent.length >= 2) {
      final rpes = recent.where((s) => s.rpeAverage != null).map((s) => s.rpeAverage!).toList();
      if (rpes.isNotEmpty) {
        final avgRpe = rpes.reduce((a, b) => a + b) / rpes.length;
        buf.writeln('RPE medio ultime sessioni: ${avgRpe.toStringAsFixed(1)}.');

        if (avgRpe >= 9) {
          buf.writeln();
          buf.write('Il corpo è sotto carico. Giorno leggero o riposo attivo consigliato.');
          return buf.toString();
        }
      }
    }

    // Last workout timing
    if (recent.isNotEmpty) {
      final daysSince = DateTime.now().difference(recent.first.startedAt).inDays;
      if (daysSince >= 2) {
        buf.writeln('$daysSince giorni dall\'ultimo allenamento — recupero completato.');
      } else if (daysSince == 1) {
        buf.writeln('Ultimo allenamento ieri. Recupero in corso.');
      }
    }

    buf.writeln();
    buf.write(_pick([
      'Il recupero è allenamento. Sonno, nutrizione, idratazione — non saltarli.',
      'Ascolta il corpo. Se ti senti fresco, spingi. Se no, scala.',
    ]));

    return buf.toString();
  }

  Future<String> _respondHrvStatus() async {
    if (hrvDao == null) {
      return 'HRV non configurato. Se hai un wearable (Apple Watch, Garmin, Oura), puoi inserire le letture per monitorare il recupero.';
    }

    final today = await hrvDao!.getTodayReading();
    final baseline = await hrvDao!.getReadingsForBaseline();

    if (today == null && baseline.isEmpty) {
      return 'Nessuna lettura HRV. Registra la prima misurazione — preferibilmente al mattino appena sveglio.';
    }

    if (baseline.length < 7) {
      return 'Servono almeno 7 letture per calcolare la baseline. Hai ${baseline.length}/7. Continua a misurare ogni mattina.';
    }

    final avgRmssd = baseline.map((r) => r.lnRmssd).reduce((a, b) => a + b) / baseline.length;

    final buf = StringBuffer();
    buf.writeln('Baseline lnRMSSD: ${avgRmssd.toStringAsFixed(2)} (${baseline.length} letture).');

    if (today != null) {
      final diff = today.lnRmssd - avgRmssd;
      buf.writeln('Oggi: ${today.lnRmssd.toStringAsFixed(2)} (${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(2)} vs baseline).');
      buf.writeln();

      if (diff < -0.5) {
        buf.write('Sotto la baseline — il sistema nervoso è stressato. Volume ridotto o riposo attivo oggi.');
      } else if (diff > 0.5) {
        buf.write('Sopra la baseline — ottimo recupero. Puoi spingere oggi.');
      } else {
        buf.write('Nella norma. Allenamento come da programma.');
      }
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // ASSESSMENT & CARDIO
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondAssessmentStatus() async {
    if (assessmentDao == null) {
      return 'L\'assessment periodico (ogni 4 settimane) misura push-up, wall sit, plank, flessibilità e Cooper test. Vai su Assessment per fare il test.';
    }

    final latest = await assessmentDao!.getLatest();
    if (latest == null) {
      return 'Nessun assessment fatto. Il primo assessment stabilisce la baseline — fallo quando ti senti fresco, non dopo un allenamento.';
    }

    final isDue = await assessmentDao!.isAssessmentDue();
    final daysSince = DateTime.now().difference(latest.date).inDays;

    final buf = StringBuffer();
    buf.writeln('Ultimo assessment: $daysSince giorni fa.');

    if (latest.pushupMaxReps != null) buf.writeln('• Push-up: ${latest.pushupMaxReps} rep.');
    if (latest.plankHoldSeconds != null) buf.writeln('• Plank: ${latest.plankHoldSeconds}s.');
    if (latest.cooperDistanceM != null) buf.writeln('• Cooper: ${latest.cooperDistanceM}m.');
    if (latest.sitAndReachCm != null) buf.writeln('• Sit & Reach: ${latest.sitAndReachCm} cm.');

    if (isDue) {
      buf.writeln();
      buf.write('È tempo di un nuovo assessment! Confronta i risultati con il precedente per misurare i progressi.');
    }

    return buf.toString();
  }

  Future<String> _respondCardioStatus() async {
    if (cardioDao == null) {
      return 'Il protocollo Phoenix include cardio 2 volte a settimana: mercoledì e sabato. Tabata, Norwegian 4×4, o Zone 2.';
    }

    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final sessions = await cardioDao!.getSessionsInRange(weekStart, now);

    if (sessions.isEmpty) {
      return _pick([
        'Nessuna sessione cardio questa settimana. Il VO2max è il miglior predittore di longevità — non saltarlo.',
        'Zero cardio questa settimana. Mercoledì e sabato sono i giorni cardio del protocollo. Anche una sessione conta.',
      ]);
    }

    final buf = StringBuffer();
    buf.writeln('Cardio questa settimana: ${sessions.length} sessioni.');
    for (final s in sessions) {
      final min = s.totalDurationSeconds ~/ 60;
      buf.writeln('• ${s.protocol}: $min min, ${s.roundsCompleted} round${s.perceivedExertion != null ? ", RPE ${s.perceivedExertion}" : ""}.');
    }

    if (sessions.length < 2) {
      buf.writeln();
      buf.write('Target: 2 sessioni/settimana. Aggiungine una.');
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // SUPPLEMENTS
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondSupplementStatus() async {
    final blood = await biomarkerDao.getLatestByType(BiomarkerType.bloodPanel);

    if (blood == null) {
      return _pick([
        'Integratori senza analisi del sangue è sparare nel buio. Fai un pannello base prima — poi il protocollo ti dirà esattamente cosa serve.',
        'Il protocollo Phoenix non prescrive integratori a caso. Servono le analisi: vitamina D, ferritina, testosterone, hsCRP come minimo. Poi si decide.',
      ]);
    }

    final days = DateTime.now().difference(blood.date).inDays;
    final buf = StringBuffer();
    buf.writeln('Ultimo pannello sangue: $days giorni fa.');
    buf.writeln();
    buf.writeln('Integratori base del protocollo (se supportati dai dati):');
    buf.writeln('• Vitamina D3: 2000-4000 UI/giorno (se <30 ng/mL)');
    buf.writeln('• Omega-3 (EPA/DHA): 2-3g/giorno');
    buf.writeln('• Creatina monoidrato: 3-5g/giorno');
    buf.writeln('• Magnesio glicinate: 400mg alla sera');
    buf.writeln();
    buf.write('Controlla la sezione Integratori nei Biomarker per raccomandazioni personalizzate basate sui tuoi valori.');

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // PAIN / INJURY
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondPainInjury(String userMessage) async {
    final lower = userMessage.toLowerCase();

    // Try to identify body part
    String? bodyPart;
    if (_containsAny(lower, ['spall'])) bodyPart = 'spalla';
    if (_containsAny(lower, ['ginocch'])) bodyPart = 'ginocchio';
    if (_containsAny(lower, ['schien', 'lombar'])) bodyPart = 'schiena';
    if (_containsAny(lower, ['polso', 'mano'])) bodyPart = 'polso';
    if (_containsAny(lower, ['caviglia', 'piede'])) bodyPart = 'caviglia';
    if (_containsAny(lower, ['gomit'])) bodyPart = 'gomito';
    if (_containsAny(lower, ['anca', 'anche'])) bodyPart = 'anca';
    if (_containsAny(lower, ['collo', 'cervical'])) bodyPart = 'collo';

    final buf = StringBuffer();

    if (bodyPart != null) {
      buf.writeln('Dolore alla $bodyPart — prendiamo sul serio la cosa.');
      buf.writeln();
      buf.writeln('Regola Phoenix:');
      buf.writeln('• Dolore acuto (improvviso, forte) → STOP, consulta un medico');
      buf.writeln('• Dolore muscolare post-allenamento (DOMS) → normale, 24-72h');
      buf.writeln('• Dolore articolare persistente → modifica gli esercizi, non forzare');
      buf.writeln();
      buf.write('L\'onboarding ha un assessment fisico che esclude automaticamente gli esercizi problematici per la $bodyPart. Rifallo se la situazione è cambiata.');
    } else {
      buf.writeln(_pick([
        'Dolore o infortunio — la prima regola è non peggiorare la situazione.',
        'Il corpo parla: il dolore è un segnale, non un ostacolo da ignorare.',
      ]));
      buf.writeln();
      buf.writeln('• Se è dolore acuto → fermati, consulta un medico');
      buf.writeln('• Se è DOMS (muscoli dopo allenamento) → è normale, 24-72h');
      buf.writeln('• Se è articolare → modifica l\'esercizio o sostituiscilo');
      buf.writeln();
      buf.write('Dimmi quale zona fa male e posso dirti quali esercizi evitare.');
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // HYDRATION
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondHydrationStatus() async {
    final weight = userWeightKg ?? 70.0;
    final mlTarget = (weight * 35).round(); // 35ml/kg rule of thumb

    final buf = StringBuffer();
    buf.writeln('Idratazione per ${weight.toStringAsFixed(0)} kg:');
    buf.writeln('• Base: ${(mlTarget / 1000).toStringAsFixed(1)} litri/giorno');
    buf.writeln('• Allenamento: +500ml per ora di attività');
    buf.writeln('• Digiuno: +500ml extra (elettroliti!)');
    buf.writeln('• Caldo/sudore: +500-1000ml');
    buf.writeln();
    buf.write(_pick([
      'L\'idratazione impatta la performance cognitiva e fisica prima ancora di sentire sete. Bevi proattivamente.',
      'Un calo del 2% di idratazione riduce la performance del 10-20%. Non aspettare la sete — è già tardi.',
    ]));

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // LONGEVITY
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondLongevityOverview() async {
    final phenoage = await biomarkerDao.getLatestByType(BiomarkerType.phenoage);
    final streak = await workoutDao.currentStreak();

    final buf = StringBuffer();
    buf.writeln('Il protocollo Phoenix è progettato per una cosa: rallentare l\'invecchiamento biologico.');
    buf.writeln();
    buf.writeln('I 3 pilastri:');
    buf.writeln('1. **Allenamento** — massa muscolare, VO2max, sensibilità insulinica');
    buf.writeln('2. **Condizionamento** — freddo (noradrenalina), caldo (HSP), meditazione (cortisolo), sonno');
    buf.writeln('3. **Nutrizione** — TRE, autofagia, proteine, micronutrienti');
    buf.writeln();

    if (phenoage != null) {
      final data = _parseValuesJson(phenoage.valuesJson);
      final age = data?['pheno_age'];
      if (age != null && userAge != null) {
        final diff = (age as num).toDouble() - userAge!;
        buf.writeln('Il tuo PhenoAge: ${(age).toStringAsFixed(1)} anni (${diff < 0 ? "${diff.abs().toStringAsFixed(1)} anni più giovane" : "${diff.toStringAsFixed(1)} anni più vecchio"}).');
      }
    }

    buf.write('Ogni sessione, ogni digiuno, ogni notte di sonno di qualità è un investimento. Streak: $streak giorni.');

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // PROTOCOL OVERVIEW
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondProtocolOverview() async {
    final streak = await workoutDao.currentStreak();
    final lastFast = await fastingDao.getLastCompleted();
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));
    final weekSessions = await workoutDao.getSessionsInRange(weekStart, now);
    final completed = weekSessions.where((s) => s.endedAt != null).length;
    final todayConditioning = await conditioningDao.getTodaySessionCount();

    final coldStreak = await conditioningDao.currentStreak(ConditioningType.cold);
    final medStreak = await conditioningDao.currentStreak(ConditioningType.meditation);

    final buf = StringBuffer();
    buf.writeln('Panoramica protocollo Phoenix:');
    buf.writeln('• Allenamento: $completed sessioni/settimana (streak: $streak gg)');
    buf.writeln('• Digiuno: livello ${lastFast?.level ?? "-"}');
    buf.writeln('• Freddo: streak $coldStreak gg');
    buf.writeln('• Meditazione: streak $medStreak gg');
    buf.writeln('• Condizionamento oggi: $todayConditioning sessioni');

    // Weight & PhenoAge
    final weight = await biomarkerDao.getLatestByType(BiomarkerType.weight);
    final phenoage = await biomarkerDao.getLatestByType(BiomarkerType.phenoage);
    if (weight != null || phenoage != null) {
      buf.writeln();
      if (weight != null) {
        final w = (_parseValuesJson(weight.valuesJson)?['weight_kg'] as num?)?.toDouble();
        if (w != null) buf.writeln('• Peso: ${w.toStringAsFixed(1)} kg');
      }
      if (phenoage != null) {
        final age = _parseValuesJson(phenoage.valuesJson)?['pheno_age'];
        if (age != null) buf.writeln('• PhenoAge: $age anni');
      }
    }

    // Coaching suggestion
    buf.writeln();
    if (completed < 3) {
      buf.write('Focus: aumenta la frequenza di allenamento. 3+ sessioni/settimana è il minimo per progredire.');
    } else if (coldStreak == 0 && medStreak == 0) {
      buf.write('L\'allenamento va bene. Ora aggiungi condizionamento: freddo e meditazione completano il protocollo.');
    } else {
      buf.write('Il protocollo è attivo su tutti i fronti. Mantieni la costanza — è il segreto.');
    }

    return buf.toString();
  }

  Future<String> _respondProtocolToday() async {
    final today = await workoutDao.getTodaySessions();
    final todayCompleted = today.where((s) => s.endedAt != null).length;
    final todayConditioning = await conditioningDao.getTodaySessionCount();
    final activeFast = await fastingDao.getActiveFast();

    final now = DateTime.now();
    final weekday = now.weekday;

    final buf = StringBuffer();
    buf.writeln('${_timeGreeting()}. Ecco la tua giornata:');

    // Workout
    if (todayCompleted > 0) {
      buf.writeln('✓ Allenamento completato.');
    } else if (weekday == 7) {
      buf.writeln('• Riposo programmato.');
    } else if (weekday == 3 || weekday == 6) {
      buf.writeln('• Cardio da fare.');
    } else {
      buf.writeln('• Sessione di forza da fare.');
    }

    // Fasting
    if (activeFast != null) {
      final elapsed = now.difference(activeFast.startedAt);
      buf.writeln('• Digiuno in corso: ${(elapsed.inMinutes / 60).toStringAsFixed(1)}h / ${activeFast.targetHours.toInt()}h.');
    }

    // Conditioning
    if (todayConditioning > 0) {
      buf.writeln('✓ $todayConditioning sessioni condizionamento oggi.');
    } else {
      buf.writeln('• Condizionamento: non ancora fatto.');
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // EMOTIONAL / MOTIVATIONAL
  // ═══════════════════════════════════════════════════════════════

  Future<String> _respondMotivationLow() async {
    final streak = await workoutDao.currentStreak();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthSessions = await workoutDao.getSessionsInRange(monthStart, now);
    final completed = monthSessions.where((s) => s.endedAt != null).length;

    // Context-aware motivation
    if (completed > 10) {
      return _pick([
        '$completed sessioni questo mese. Guarda indietro: stai facendo più di quanto credi. I giorni difficili sono parte del processo.',
        'Hai fatto $completed sessioni questo mese. Non è poco. Oggi è un giorno duro — capita. Non devi essere perfetto, devi essere costante.',
        'Ascolta: $completed sessioni, streak di $streak giorni. Questi numeri dicono che sei disciplinato. Oggi è duro — va bene. Fai anche solo 15 minuti, o riposa. Domani si ricomincia.',
      ]);
    }

    if (streak >= 3) {
      return _pick([
        '$streak giorni di fila — non buttare via lo slancio. Anche una sessione leggera conta. Il corpo si adatta anche nei giorni in cui la mente resiste.',
        'Sei a $streak giorni consecutivi. La voglia va e viene, ma i risultati vengono dalla disciplina. Anche oggi conta.',
      ]);
    }

    return _pick([
      'I giorni in cui non vuoi allenarti sono quelli che contano di più. Non serve spaccare — serve presentarsi. Anche 20 minuti.',
      'La motivazione è sopravvalutata. La disciplina è sottovalutata. Oggi non devi essere il migliore — devi solo fare qualcosa.',
      'La fenice rinasce dalle ceneri. I giorni duri sono le ceneri. Quello che fai adesso definisce quello che diventerai.',
      'Non ce la fai? Va bene. Fai una camminata di 30 minuti. Respira. Domani riprendi. Il protocollo non ti giudica — ti aspetta.',
    ]);
  }

  Future<String> _respondMotivationCelebrate() async {
    final streak = await workoutDao.currentStreak();
    return _pick([
      'Questo è lo spirito. $streak giorni di disciplina. Non fermarti.',
      'Bene. Ma non celebriamo — registriamo. Il prossimo passo conta più dell\'ultimo.',
      'Il risultato è la prova. Ma il processo è il premio. Avanti.',
      'Sì. Ma ricorda: il giorno dopo un successo è il più pericoloso. Mantieni la routine.',
    ]);
  }

  Future<String> _respondGreeting() async {
    final streak = await workoutDao.currentStreak();
    final now = DateTime.now();
    final h = now.hour;
    final todaySessions = await workoutDao.getTodaySessions();
    final todayCompleted = todaySessions.where((s) => s.endedAt != null).length;

    if (todayCompleted > 0) {
      return _pick([
        '${_timeGreeting()}. Oggi hai già fatto la tua sessione — il resto è recupero.',
        '${_timeGreeting()}. Allenamento di oggi: fatto. Come posso aiutarti?',
      ]);
    }

    if (h < 10) {
      return _pick([
        '${_timeGreeting()}. Nuovo giorno, nuova opportunità. ${streak > 0 ? "Streak: $streak giorni. " : ""}Cosa vuoi sapere?',
        '${_timeGreeting()}. ${streak >= 3 ? "$streak giorni consecutivi — ottimo ritmo. " : ""}Come posso aiutarti?',
      ]);
    }

    return _pick([
      '${_timeGreeting()}. ${streak > 0 ? "Streak attiva: $streak giorni. " : ""}Di cosa parliamo?',
      '${_timeGreeting()}. Chiedimi di allenamento, digiuno, condizionamento, nutrizione o biomarker.',
    ]);
  }

  Future<String> _respondThanks() async {
    return _pick([
      'Ci sono per questo. Continua a spingere.',
      'Niente da ringraziare. I risultati li ottieni tu.',
      'Il merito è tuo. Io ti do i dati.',
    ]);
  }

  Future<String> _respondHelp() async {
    return 'Posso aiutarti con:\n'
        '• **Allenamento** — stato, progressi, prossima sessione, periodizzazione\n'
        '• **Digiuno** — stato, livello, consigli, fame\n'
        '• **Nutrizione** — target macro, cosa mangiare, idratazione\n'
        '• **Condizionamento** — freddo, caldo, meditazione, sonno, mobilità\n'
        '• **Biomarker** — PhenoAge, analisi sangue, peso, testosterone, cortisolo\n'
        '• **Recovery** — HRV, recupero, prontezza, dolore\n'
        '• **Integratori** — creatina, vitamina D, omega-3, magnesio\n'
        '• **Cardio** — HIIT, Zone 2, VO2max, corsa\n'
        '• **Longevità** — protocollo anti-aging, ringiovanimento\n\n'
        'Chiedimi qualsiasi cosa — uso i tuoi dati reali per rispondere.';
  }

  Future<String> _respondGeneral() async {
    // Check if we have a recent topic in conversation history
    if (_history.length >= 2) {
      final lastIntent = _history[_history.length - 2].intent;
      if (lastIntent != ChatIntent.general && lastIntent != ChatIntent.greeting) {
        // Continue the last topic
        return _dispatch(lastIntent, '');
      }
    }

    return _respondProtocolToday();
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  static Map<String, dynamic>? _parseValuesJson(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }

  static String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    if (sec == 0) return '${min}min';
    return '${min}min ${sec}s';
  }

  /// Phase description from DB mesocycle state (avoids PeriodizationEngine type mismatch).
  static String _phaseDescription(MesocycleState meso) {
    final block = meso.currentBlock;
    final week = meso.weekInMesocycle;
    if (block != null && block.isNotEmpty) {
      final blockLabel = switch (block) {
        'accumulo' => 'Accumulo',
        'trasformazione' => 'Trasformazione',
        'realizzazione' => 'Realizzazione',
        'deload' => 'Deload',
        _ => block,
      };
      return 'Fase $blockLabel — Settimana $week';
    }
    return 'Settimana $week del mesociclo';
  }

  static String _tierLabel(String tier) {
    return switch (tier) {
      'beginner' => 'Principiante (lineare)',
      'intermediate' => 'Intermedio (DUP)',
      'advanced' => 'Avanzato (blocchi)',
      _ => tier,
    };
  }

  static String _dayTypeForWeekday(int weekday) {
    // Mon,Tue,Thu,Fri = training; Wed = normal; Sat,Sun = autophagy
    return switch (weekday) {
      1 || 2 || 4 || 5 => 'training',
      3 => 'normal',
      _ => 'autophagy',
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // POST-SET COACHING (unchanged from original)
  // ═══════════════════════════════════════════════════════════════

  /// Generate a template-based post-set coach response.
  static String postSetFeedback({
    required int repsCompleted,
    required int repsTarget,
    required int rpe,
    required int setNumber,
    required int totalSets,
    required String exerciseName,
    required String category,
  }) {
    final buf = StringBuffer();

    if (repsCompleted >= repsTarget) {
      buf.write('Tutte le rep completate. ');
    } else {
      buf.write('$repsCompleted/$repsTarget rep. ');
    }

    if (rpe <= 6) {
      buf.write('Buon controllo! ');
      if (repsCompleted >= repsTarget) {
        buf.write('Valuta una progressione nella prossima sessione.');
      } else {
        buf.write('Mantieni questo ritmo.');
      }
    } else if (rpe <= 8) {
      buf.write('Intensità giusta — zona di lavoro ideale. ');
      final categoryTip = switch (category) {
        ExerciseCategory.push => 'Scapole retratte.',
        ExerciseCategory.pull => 'Guida con le scapole.',
        ExerciseCategory.squat => 'Ginocchia fuori, talloni a terra.',
        ExerciseCategory.hinge => 'Schiena neutra.',
        ExerciseCategory.core => 'Respira, non trattenere.',
        _ => 'Focus sulla forma.',
      };
      buf.write(categoryTip);
    } else {
      buf.write('Duro! Se la tecnica cede, riduci il carico. ');
      if (setNumber < totalSets) {
        buf.write('Recupera bene prima della prossima serie.');
      }
    }

    return buf.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // STATIC UTILITIES (unchanged from original)
  // ═══════════════════════════════════════════════════════════════

  /// Parse the [DATI: ...] line from LLM coach response.
  static Map<String, dynamic> parseCoachData(String response) {
    final match = RegExp(r'\[DATI:\s*reps=(\w+),\s*rpe=(\w+),\s*dolore=(\w+)\]')
        .firstMatch(response);
    if (match == null) return {'reps': null, 'rpe': null, 'pain': false};

    int? reps;
    int? rpe;
    bool pain = false;

    final repsStr = match.group(1) ?? 'null';
    final rpeStr = match.group(2) ?? 'null';
    final painStr = match.group(3) ?? 'no';

    if (repsStr != 'null') reps = int.tryParse(repsStr);
    if (rpeStr != 'null') rpe = int.tryParse(rpeStr);
    pain = painStr.toLowerCase() == 'si';

    return {'reps': reps, 'rpe': rpe, 'pain': pain};
  }

  /// Remove the [DATI: ...] metadata line from coach response for display.
  static String stripCoachData(String response) {
    return response.replaceAll(RegExp(r'\[DATI:.*?\]'), '').trim();
  }

  // ─── Physical Assessment Fallback ────────────────────────────────

  /// Zone-specific exclusion patterns (used for severe limitations).
  static const _zoneExclusionMap = <String, List<String>>{
    'shoulder_right': ['Press', 'Dip', 'OHP', 'Pike', 'Handstand', 'Shoulder', 'Lateral Raise'],
    'shoulder_left': ['Press', 'Dip', 'OHP', 'Pike', 'Handstand', 'Shoulder', 'Lateral Raise'],
    'elbow_right': ['Curl', 'Tricep', 'Dip', 'Press', 'Push'],
    'elbow_left': ['Curl', 'Tricep', 'Dip', 'Press', 'Push'],
    'wrist_right': ['Push-Up', 'Plank', 'Pike', 'Handstand', 'Bench Press', 'OHP'],
    'wrist_left': ['Push-Up', 'Plank', 'Pike', 'Handstand', 'Bench Press', 'OHP'],
    'upper_back': ['Row', 'Pull', 'Deadlift', 'Lat'],
    'lower_back': ['Deadlift', 'Hinge', 'Good Morning', 'Row', 'Squat', 'Hip Thrust'],
    'hip_right': ['Squat', 'Lunge', 'Hinge', 'Deadlift', 'Hip Thrust', 'Step'],
    'hip_left': ['Squat', 'Lunge', 'Hinge', 'Deadlift', 'Hip Thrust', 'Step'],
    'knee_right': ['Squat', 'Lunge', 'Leg Press', 'Step', 'Jump', 'Pistol'],
    'knee_left': ['Squat', 'Lunge', 'Leg Press', 'Step', 'Jump', 'Pistol'],
    'ankle_right': ['Squat', 'Lunge', 'Jump', 'Calf', 'Step', 'Pistol'],
    'ankle_left': ['Squat', 'Lunge', 'Jump', 'Calf', 'Step', 'Pistol'],
  };

  /// Zone-specific substitution map for moderate severity.
  /// null value = no safe substitute, treat as severe (exclude).
  static const _zoneSubstitutionMap = <String, Map<String, String?>>{
    'knee': {
      'Squat': 'Wall Sit',
      'Lunge': 'Step-Up',
      'Jump': null,
      'Pistol': 'Wall Sit',
      'Leg Press': 'Wall Sit',
    },
    'lower_back': {
      'Deadlift': 'Hip Hinge',
      'Hinge': 'Hip Hinge',
      'Good Morning': null,
      'Row': 'Seated Row',
      'Squat': 'Goblet Squat',
      'Hip Thrust': 'Glute Bridge',
    },
    'shoulder': {
      'Press': 'Landmine Press',
      'Dip': null,
      'OHP': 'Landmine Press',
      'Pike': null,
      'Handstand': null,
      'Lateral Raise': null,
    },
    'hip': {
      'Squat': 'Leg Press',
      'Lunge': null,
      'Hinge': 'Hip Hinge',
      'Deadlift': null,
      'Hip Thrust': 'Glute Bridge',
      'Step': null,
    },
    'upper_back': {
      'Row': 'Seated Row',
      'Pull': 'Lat Pulldown',
      'Deadlift': null,
    },
    'ankle': {
      'Squat': 'Leg Press',
      'Lunge': null,
      'Jump': null,
      'Calf': null,
      'Step': null,
      'Pistol': null,
    },
    'elbow': {
      'Curl': null,
      'Tricep': null,
      'Dip': null,
      'Press': 'Isometric Press',
      'Push': null,
    },
    'wrist': {
      'Push-Up': 'Plank (fists)',
      'Plank': 'Plank (fists)',
      'Pike': null,
      'Handstand': null,
      'Bench Press': null,
    },
  };

  Future<List<int>> getExcludedExerciseIds(List<String> zones) async {
    if (zones.isEmpty) return [];

    final patterns = <String>{};
    for (final zone in zones) {
      final zonePatterns = _zoneExclusionMap[zone];
      if (zonePatterns != null) patterns.addAll(zonePatterns);
    }
    if (patterns.isEmpty) return [];

    final allExercises = <Exercise>[];
    for (final cat in [ExerciseCategory.push, ExerciseCategory.pull, ExerciseCategory.squat, ExerciseCategory.hinge, ExerciseCategory.core]) {
      for (final eq in ['all', 'gym', 'home', 'bodyweight']) {
        final chain = await exerciseDao.getProgressionChain(cat, eq);
        allExercises.addAll(chain);
      }
    }

    final seen = <int>{};
    final excluded = <int>[];
    for (final ex in allExercises) {
      if (seen.contains(ex.id)) continue;
      seen.add(ex.id);
      final nameLower = ex.name.toLowerCase();
      for (final pattern in patterns) {
        if (nameLower.contains(pattern.toLowerCase())) {
          excluded.add(ex.id);
          break;
        }
      }
    }

    return excluded;
  }

  /// Build exercise modifications based on limitations with graduated severity.
  /// Returns a map: exerciseId → {action, substituteId?, paramOverrides?}
  Future<Map<int, Map<String, dynamic>>> getExerciseModifications(
      List<Map<String, dynamic>> limitations) async {
    if (limitations.isEmpty) return {};

    final allExercises = <Exercise>[];
    for (final cat in [ExerciseCategory.push, ExerciseCategory.pull, ExerciseCategory.squat, ExerciseCategory.hinge, ExerciseCategory.core]) {
      for (final eq in ['all', 'gym', 'home', 'bodyweight']) {
        final chain = await exerciseDao.getProgressionChain(cat, eq);
        allExercises.addAll(chain);
      }
    }
    // Dedup
    final exerciseById = <int, Exercise>{};
    for (final ex in allExercises) {
      exerciseById[ex.id] = ex;
    }
    // Build name→id lookup for substitutes
    final exerciseByNameLower = <String, Exercise>{};
    for (final ex in exerciseById.values) {
      exerciseByNameLower[ex.name.toLowerCase()] = ex;
    }

    final modifications = <int, Map<String, dynamic>>{};

    for (final lim in limitations) {
      final zone = lim['area'] as String;
      final severity = lim['severity'] as String? ?? 'moderate';
      // Get the base zone (strip _right/_left suffix for substitution lookup)
      final baseZone = zone.replaceAll(RegExp(r'_(right|left)$'), '');

      // Get exclusion patterns for this zone
      final exclusionPatterns = _zoneExclusionMap[zone] ?? _zoneExclusionMap[baseZone] ?? [];

      for (final ex in exerciseById.values) {
        final nameLower = ex.name.toLowerCase();
        String? matchedPattern;
        for (final pattern in exclusionPatterns) {
          if (nameLower.contains(pattern.toLowerCase())) {
            matchedPattern = pattern;
            break;
          }
        }
        if (matchedPattern == null) continue;
        // Already have a more severe modification? Skip.
        if (modifications.containsKey(ex.id)) {
          final existing = modifications[ex.id]!;
          if (_severityRank(existing['action'] as String) >=
              _severityRank(_actionForSeverity(severity))) {
            continue;
          }
        }

        switch (severity) {
          case 'mild':
            modifications[ex.id] = {
              'action': 'adapt',
              'paramOverrides': {'rpe_cap': 6, 'no_explosive': true},
            };
          case 'moderate':
            final subMap = _zoneSubstitutionMap[baseZone];
            final substituteName = subMap?[matchedPattern];
            if (substituteName == null) {
              // No substitute available → exclude
              modifications[ex.id] = {'action': 'exclude'};
            } else {
              // Find substitute in DB by name
              final sub = exerciseByNameLower.entries
                  .where((e) => e.key.contains(substituteName.toLowerCase()))
                  .map((e) => e.value)
                  .firstOrNull;
              if (sub != null) {
                modifications[ex.id] = {
                  'action': 'substitute',
                  'substituteId': sub.id,
                  'substituteName': sub.name,
                };
              } else {
                // Substitute not in DB → exclude
                modifications[ex.id] = {'action': 'exclude'};
              }
            }
          case 'severe':
          default:
            modifications[ex.id] = {'action': 'exclude'};
        }
      }
    }

    return modifications;
  }

  static int _severityRank(String action) => switch (action) {
        'adapt' => 1,
        'substitute' => 2,
        'exclude' => 3,
        _ => 0,
      };

  static String _actionForSeverity(String severity) => switch (severity) {
        'mild' => 'adapt',
        'moderate' => 'substitute',
        'severe' => 'exclude',
        _ => 'substitute',
      };

  static const zoneLabels = <String, String>{
    'shoulder_right': 'Spalla destra',
    'shoulder_left': 'Spalla sinistra',
    'elbow_right': 'Gomito destro',
    'elbow_left': 'Gomito sinistro',
    'wrist_right': 'Polso destro',
    'wrist_left': 'Polso sinistro',
    'upper_back': 'Schiena alta',
    'lower_back': 'Schiena bassa',
    'hip_right': 'Anca destra',
    'hip_left': 'Anca sinistra',
    'knee_right': 'Ginocchio destro',
    'knee_left': 'Ginocchio sinistro',
    'ankle_right': 'Caviglia destra',
    'ankle_left': 'Caviglia sinistra',
  };

  static Map<String, dynamic>? parseAssessmentData(String response) {
    final match = RegExp(r'\[ASSESSMENT:\s*(\{.*?\})\]', dotAll: true).firstMatch(response);
    if (match == null) return null;
    try {
      return jsonDecode(match.group(1)!) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String stripAssessmentData(String response) {
    return response.replaceAll(RegExp(r'\[ASSESSMENT:.*?\]', dotAll: true), '').trim();
  }
}

// ─── Conversation Memory ──────────────────────────────────────────

class _ChatTurn {
  final String message;
  final ChatIntent intent;
  final DateTime timestamp;

  _ChatTurn(this.message, this.intent, this.timestamp);
}
