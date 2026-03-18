// Warmup, stability, and cool-down/stretching routines for the Phoenix Protocol.
//
// Generates evidence-based movement sequences adapted by day category,
// training tier, and age. Based on joint CARs, dynamic prep,
// and PNF stretching principles.

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

/// A single warmup/stability/stretch movement.
class MovementExercise {
  final String name;

  /// Italian display name.
  final String nameIt;

  /// Brief execution cue.
  final String instructions;

  /// Duration in seconds. 0 if rep-based.
  final int durationSeconds;

  /// Rep count. 0 if time-based.
  final int reps;

  /// Whether the exercise is performed per side.
  final bool perSide;

  /// Optional asset path for illustration.
  final String? imageAsset;

  const MovementExercise({
    required this.name,
    required this.nameIt,
    required this.instructions,
    this.durationSeconds = 0,
    this.reps = 0,
    this.perSide = false,
    this.imageAsset,
  });

  bool get isTimeBased => durationSeconds > 0;

  /// Human-readable dose label in Italian.
  String get displayDuration => isTimeBased
      ? '${durationSeconds}s${perSide ? '/lato' : ''}'
      : '$reps rep${perSide ? '/lato' : ''}';

  /// Effective total seconds including per-side doubling.
  /// Rep-based exercises estimate ~3s per rep.
  int get effectiveSeconds {
    if (isTimeBased) {
      return perSide ? durationSeconds * 2 : durationSeconds;
    }
    final repTime = reps * 3;
    return perSide ? repTime * 2 : repTime;
  }
}

/// A sequence of movements forming a warmup, stability, or cool-down routine.
class MovementRoutine {
  /// One of: 'warmup', 'stability', 'cooldown'.
  final String type;

  /// One of: 'push', 'pull', 'squat', 'hinge', 'hiit', 'power', 'all'.
  final String dayCategory;

  final List<MovementExercise> exercises;
  final int estimatedMinutes;

  const MovementRoutine({
    required this.type,
    required this.dayCategory,
    required this.exercises,
    required this.estimatedMinutes,
  });

  /// Total seconds summed from all exercises.
  int get totalSeconds =>
      exercises.fold(0, (sum, e) => sum + e.effectiveSeconds);
}

// ---------------------------------------------------------------------------
// Generator
// ---------------------------------------------------------------------------

/// Generates movement routines based on day category, tier, and age.
class MovementRoutineGenerator {
  const MovementRoutineGenerator._();

  // ---- Warmup --------------------------------------------------------------

  /// Returns a warmup routine for the given [dayCategory].
  ///
  /// [dayCategory]: 'push' / 'pull' / 'squat' / 'hinge' / 'hiit' / 'power'.
  /// [tier]: 1 (beginner), 2 (intermediate), 3 (advanced).
  /// [ageYears]: optional age for duration adaptation and extra joint mobility.
  ///
  /// Age brackets:
  /// - <30: 5min warmup
  /// - 30-50: 7min warmup, PNF recommended
  /// - 50-65: 10min warmup, PNF strongly recommended
  /// - 65+: 10min + extra joint mobility, PNF required
  static MovementRoutine warmupFor(
    String dayCategory,
    int tier, {
    int? ageYears,
  }) {
    final ageBracket = _ageBracket(ageYears);
    final exercises = <MovementExercise>[
      ..._warmupExercisesFor(dayCategory),
    ];

    // Age adaptation: extra joint mobility for 50+.
    if (ageBracket >= 2) {
      exercises.addAll(_extraJointMobility);
    }

    return MovementRoutine(
      type: 'warmup',
      dayCategory: dayCategory,
      exercises: exercises,
      estimatedMinutes: _warmupMinutes(ageBracket),
    );
  }

  // ---- Stability ------------------------------------------------------------

  /// Returns a stability routine appropriate for the athlete's [tier].
  ///
  /// - tier 1 (beginner): ~5min
  /// - tier 2 (intermediate): ~7min
  /// - tier 3 (advanced): ~10min
  static MovementRoutine stabilityFor(int tier) {
    final clampedTier = tier.clamp(1, 3);
    final exercises = _stabilityExercisesFor(clampedTier);
    final minutes = const {1: 5, 2: 7, 3: 10}[clampedTier]!;

    return MovementRoutine(
      type: 'stability',
      dayCategory: 'all',
      exercises: exercises,
      estimatedMinutes: minutes,
    );
  }

  // ---- Cooldown -------------------------------------------------------------

  /// Returns a cooldown stretching routine for the given [dayCategory].
  ///
  /// If [usePnf] is true, stretch durations are doubled and instructions
  /// include the PNF protocol (10s passive + 6s isometric + deep stretch).
  static MovementRoutine cooldownFor(
    String dayCategory, {
    bool usePnf = false,
  }) {
    final base = _cooldownExercisesFor(dayCategory);
    final exercises = usePnf ? _applyPnf(base) : base;
    final totalSeconds =
        exercises.fold(0, (sum, e) => sum + e.effectiveSeconds);
    final minutes = ((totalSeconds + 59) / 60).floor();

    return MovementRoutine(
      type: 'cooldown',
      dayCategory: dayCategory,
      exercises: exercises,
      estimatedMinutes: minutes,
    );
  }

  // ---- PNF recommendation ---------------------------------------------------

  /// Whether PNF stretching is recommended for the given age.
  ///
  /// - <30: opzionale
  /// - 30-50: consigliato
  /// - 50-65: fortemente consigliato
  /// - 65+: necessario
  static String pnfRecommendation(int? ageYears) {
    if (ageYears == null) return 'consigliato';
    if (ageYears < 30) return 'opzionale';
    if (ageYears <= 50) return 'consigliato';
    if (ageYears <= 65) return 'fortemente consigliato';
    return 'necessario';
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// 0 = <30, 1 = 30-50, 2 = 50-65, 3 = 65+
  static int _ageBracket(int? age) {
    if (age == null) return 1; // default middle bracket
    if (age < 30) return 0;
    if (age <= 50) return 1;
    if (age <= 65) return 2;
    return 3;
  }

  static int _warmupMinutes(int ageBracket) {
    switch (ageBracket) {
      case 0:
        return 5;
      case 1:
        return 7;
      case 2:
      case 3:
        return 10;
      default:
        return 7;
    }
  }

  static const _extraJointMobility = [
    MovementExercise(
      name: 'Wrist circles',
      nameIt: 'Cerchi dei polsi',
      instructions: 'Cerchi lenti in entrambe le direzioni',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Neck CARs',
      nameIt: 'CARs del collo',
      instructions: 'Cerchio lento e controllato, massima ampiezza',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Knee circles',
      nameIt: 'Cerchi delle ginocchia',
      instructions: 'Piedi uniti, cerchi lenti con le ginocchia',
      durationSeconds: 30,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Warmup exercises by day category
  // ---------------------------------------------------------------------------

  static List<MovementExercise> _warmupExercisesFor(String dayCategory) {
    switch (dayCategory) {
      case 'push':
        return _warmupPush;
      case 'pull':
        return _warmupPull;
      case 'squat':
        return _warmupSquat;
      case 'hinge':
        return _warmupHinge;
      case 'hiit':
      case 'power':
        return _warmupFullBody;
      default:
        return _warmupFullBody;
    }
  }

  static const _warmupPush = [
    MovementExercise(
      name: 'Arm circles',
      nameIt: 'Cerchi delle braccia',
      instructions: 'Cerchi progressivi, da piccoli a grandi',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Wall slides',
      nameIt: 'Scivolamenti a muro',
      instructions: 'Schiena al muro, braccia a W-Y lentamente',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Thread the needle',
      nameIt: 'Filo nell\'ago',
      instructions: 'Rotazione toracica controllata, segui la mano',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Band pull-aparts',
      nameIt: 'Aperture con elastico',
      instructions: 'Scapole addotte, braccia tese, movimento lento',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Shoulder CARs',
      nameIt: 'CARs delle spalle',
      instructions: 'Cerchio completo della spalla, massima ampiezza',
      durationSeconds: 30,
      perSide: true,
    ),
  ];

  static const _warmupSquat = [
    MovementExercise(
      name: 'Leg swings',
      nameIt: 'Oscillazioni delle gambe',
      instructions: 'Laterali, ampiezza progressiva',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Hip CARs',
      nameIt: 'CARs delle anche',
      instructions: 'Cerchio completo dell\'anca, controllato',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Lateral lunges',
      nameIt: 'Affondi laterali',
      instructions: 'Peso sul tallone, ginocchio in linea con piede',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'High knees',
      nameIt: 'Ginocchia alte',
      instructions: 'Ritmo moderato, core attivo',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Ankle circles',
      nameIt: 'Cerchi delle caviglie',
      instructions: 'Cerchi lenti, entrambe le direzioni',
      durationSeconds: 30,
      perSide: true,
    ),
  ];

  static const _warmupPull = [
    MovementExercise(
      name: 'Shoulder CARs',
      nameIt: 'CARs delle spalle',
      instructions: 'Cerchio completo della spalla, massima ampiezza',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Cat-cow',
      nameIt: 'Gatto-mucca',
      instructions: 'Flessione ed estensione spinale ritmica',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Thoracic rotations',
      nameIt: 'Rotazioni toraciche',
      instructions: 'Da quadrupedia, mano dietro la testa, ruota',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Band pull-aparts',
      nameIt: 'Aperture con elastico',
      instructions: 'Scapole addotte, braccia tese, movimento lento',
      durationSeconds: 30,
    ),
  ];

  static const _warmupHinge = [
    MovementExercise(
      name: 'Hip CARs',
      nameIt: 'CARs delle anche',
      instructions: 'Cerchio completo dell\'anca, controllato',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Light good mornings',
      nameIt: 'Good mornings leggeri',
      instructions: 'Cerniera all\'anca, schiena neutra, lento',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Sagittal leg swings',
      nameIt: 'Oscillazioni sagittali delle gambe',
      instructions: 'Avanti-indietro, ampiezza progressiva',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Glute bridges',
      nameIt: 'Ponte glutei',
      instructions: 'Spremi i glutei in alto, pausa 2s in cima',
      durationSeconds: 45,
    ),
  ];

  static const _warmupFullBody = [
    MovementExercise(
      name: 'Light jumping jacks',
      nameIt: 'Jumping jacks leggeri',
      instructions: 'Ritmo basso, attiva la circolazione',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Leg swings',
      nameIt: 'Oscillazioni delle gambe',
      instructions: 'Frontali e laterali alternati',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Arm circles',
      nameIt: 'Cerchi delle braccia',
      instructions: 'Cerchi progressivi, da piccoli a grandi',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Torso rotations',
      nameIt: 'Rotazioni del busto',
      instructions: 'Piedi fermi, ruota il busto con le braccia',
      durationSeconds: 30,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Stability exercises by tier
  // ---------------------------------------------------------------------------

  static List<MovementExercise> _stabilityExercisesFor(int tier) {
    switch (tier) {
      case 1:
        return _stabilityBeginner;
      case 2:
        return _stabilityIntermediate;
      case 3:
        return _stabilityAdvanced;
      default:
        return _stabilityBeginner;
    }
  }

  static const _stabilityBeginner = [
    MovementExercise(
      name: 'Tandem stance',
      nameIt: 'Stazione tandem',
      instructions: 'Piedi in linea tallone-punta, mantieni',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Single-leg stance with support',
      nameIt: 'Stazione monopodalica con appoggio',
      instructions: 'Un dito al muro, ginocchio leggermente flesso',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Bird dog',
      nameIt: 'Bird dog',
      instructions: 'Braccio e gamba opposti, pausa 2s in estensione',
      reps: 10,
      perSide: true,
    ),
    MovementExercise(
      name: 'Dead bug',
      nameIt: 'Dead bug',
      instructions: 'Lombare a terra, estendi lentamente',
      reps: 10,
      perSide: true,
    ),
    MovementExercise(
      name: 'Heel lifts',
      nameIt: 'Sollevamenti sui talloni',
      instructions: 'Lento e controllato, pausa in alto',
      reps: 15,
    ),
  ];

  static const _stabilityIntermediate = [
    MovementExercise(
      name: 'Single-leg stance',
      nameIt: 'Stazione monopodalica',
      instructions: 'Occhi aperti, ginocchio morbido',
      durationSeconds: 30,
      perSide: true,
    ),
    MovementExercise(
      name: 'Single-leg RDL',
      nameIt: 'RDL monopodalico',
      instructions: 'Cerniera all\'anca, schiena neutra',
      reps: 8,
      perSide: true,
    ),
    MovementExercise(
      name: 'Plank shoulder taps',
      nameIt: 'Plank con tocco spalla',
      instructions: 'Anti-rotazione, bacino fermo',
      reps: 10,
      perSide: true,
    ),
    MovementExercise(
      name: 'Single-leg toe touch',
      nameIt: 'Tocco punta monopodalico',
      instructions: 'Scendi lento, controlla il ginocchio',
      reps: 8,
      perSide: true,
    ),
    MovementExercise(
      name: 'Tree pose',
      nameIt: 'Posizione dell\'albero',
      instructions: 'Piede su polpaccio o coscia, mai sul ginocchio',
      durationSeconds: 30,
      perSide: true,
    ),
  ];

  static const _stabilityAdvanced = [
    MovementExercise(
      name: 'Weighted single-leg RDL',
      nameIt: 'RDL monopodalico con peso',
      instructions: 'Cerniera all\'anca, peso leggero, controllo',
      reps: 8,
      perSide: true,
    ),
    MovementExercise(
      name: 'Stability ball plank',
      nameIt: 'Plank su fitball',
      instructions: 'Avambracci sulla palla, corpo rigido',
      durationSeconds: 30,
    ),
    MovementExercise(
      name: 'Eccentric pistol squat',
      nameIt: 'Pistol squat eccentrico',
      instructions: 'Scendi su una gamba in 5s, risali con due',
      reps: 5,
      perSide: true,
    ),
    MovementExercise(
      name: 'Standing elbow-to-knee',
      nameIt: 'Gomito-ginocchio in piedi',
      instructions: 'Gomito e ginocchio opposti, pausa 1s',
      reps: 10,
      perSide: true,
    ),
    MovementExercise(
      name: 'Overhead squat',
      nameIt: 'Squat con braccia in alto',
      instructions: 'Braccia tese sopra la testa, squat profondo',
      reps: 8,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Cooldown exercises by day category
  // ---------------------------------------------------------------------------

  static List<MovementExercise> _cooldownExercisesFor(String dayCategory) {
    switch (dayCategory) {
      case 'push':
        return const [
          MovementExercise(
            name: 'Pectoralis doorway stretch',
            nameIt: 'Stretching pettorale alla porta',
            instructions: 'Avambraccio sullo stipite, passo avanti',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Overhead tricep stretch',
            nameIt: 'Stretching tricipite sopra la testa',
            instructions: 'Gomito al soffitto, spingi delicatamente',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Anterior deltoid stretch',
            nameIt: 'Stretching deltoide anteriore',
            instructions: 'Mani dietro la schiena, petto aperto',
            durationSeconds: 30,
            perSide: true,
          ),
        ];

      case 'squat':
        return const [
          MovementExercise(
            name: 'Standing quad stretch',
            nameIt: 'Stretching quadricipite in piedi',
            instructions: 'Tallone al gluteo, ginocchia unite',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Hamstring forward fold',
            nameIt: 'Piegamento in avanti per femorali',
            instructions: 'Gambe tese, rilassa la schiena verso il basso',
            durationSeconds: 30,
          ),
          MovementExercise(
            name: 'Hip flexor lunge stretch',
            nameIt: 'Stretching flessori dell\'anca in affondo',
            instructions: 'Ginocchio posteriore a terra, spingi l\'anca avanti',
            durationSeconds: 30,
            perSide: true,
          ),
        ];

      case 'pull':
        return const [
          MovementExercise(
            name: 'Lat stretch at wall',
            nameIt: 'Stretching dorsali al muro',
            instructions: 'Braccio teso al muro, ruota il busto via',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Bicep wall stretch',
            nameIt: 'Stretching bicipite al muro',
            instructions: 'Palmo al muro, ruota il corpo via',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Thoracic extension',
            nameIt: 'Estensione toracica',
            instructions: 'Foam roller o sedia, estendi la parte alta',
            durationSeconds: 30,
          ),
        ];

      case 'hinge':
        return const [
          MovementExercise(
            name: 'Pigeon pose',
            nameIt: 'Posizione del piccione',
            instructions: 'Tibia anteriore parallela, rilassa il busto',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Seated hamstring stretch',
            nameIt: 'Stretching femorali da seduto',
            instructions: 'Gamba tesa, piegati dall\'anca',
            durationSeconds: 30,
          ),
          MovementExercise(
            name: 'Figure-4 glute stretch',
            nameIt: 'Stretching glutei a 4',
            instructions: 'Caviglia sul ginocchio opposto, tira verso il petto',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Calf stretch',
            nameIt: 'Stretching polpacci',
            instructions: 'Piede posteriore a terra, tallone premuto',
            durationSeconds: 30,
            perSide: true,
          ),
        ];

      case 'hiit':
      case 'power':
        // Full body: hips + shoulders + spine
        return const [
          MovementExercise(
            name: 'Hip flexor lunge stretch',
            nameIt: 'Stretching flessori dell\'anca in affondo',
            instructions: 'Ginocchio posteriore a terra, spingi l\'anca avanti',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Pigeon pose',
            nameIt: 'Posizione del piccione',
            instructions: 'Tibia anteriore parallela, rilassa il busto',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Pectoralis doorway stretch',
            nameIt: 'Stretching pettorale alla porta',
            instructions: 'Avambraccio sullo stipite, passo avanti',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Lat stretch at wall',
            nameIt: 'Stretching dorsali al muro',
            instructions: 'Braccio teso al muro, ruota il busto via',
            durationSeconds: 30,
            perSide: true,
          ),
          MovementExercise(
            name: 'Seated spinal twist',
            nameIt: 'Torsione spinale da seduto',
            instructions: 'Gambe incrociate, ruota il busto e guarda dietro',
            durationSeconds: 30,
            perSide: true,
          ),
        ];

      default:
        return _cooldownExercisesFor('hiit');
    }
  }

  /// Doubles duration for PNF protocol and adds PNF cue to instructions.
  static List<MovementExercise> _applyPnf(List<MovementExercise> exercises) {
    return exercises.map((e) {
      if (e.isTimeBased) {
        return MovementExercise(
          name: e.name,
          nameIt: e.nameIt,
          instructions:
              '${e.instructions} (PNF: 10s passivo + 6s isometrico + stretch profondo)',
          durationSeconds: e.durationSeconds * 2,
          reps: e.reps,
          perSide: e.perSide,
          imageAsset: e.imageAsset,
        );
      }
      return e;
    }).toList();
  }
}
