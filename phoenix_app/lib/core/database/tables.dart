import 'package:drift/drift.dart';

// -- Exercise categories --
class ExerciseCategory {
  static const push = 'push';
  static const pull = 'pull';
  static const squat = 'squat';
  static const hinge = 'hinge';
  static const core = 'core';
}

// -- Exercise types --
class ExerciseType {
  static const compound = 'compound';
  static const accessory = 'accessory';
  static const core = 'core';
  static const hiit = 'hiit';
  static const deload = 'deload';
}

// -- Equipment --
class Equipment {
  static const gym = 'gym';
  static const home = 'home';
  static const bodyweight = 'bodyweight';
  static const all = 'all';
}

// -- Workout types --
class WorkoutType {
  static const strength = 'strength';
  static const cardio = 'cardio';
  static const power = 'power';
  static const deload = 'deload';
  static const flexibility = 'flexibility';
}

// -- Duration score --
class DurationScore {
  static const green = 'green';
  static const yellow = 'yellow';
  static const red = 'red';
}

// -- Fasting levels --
class FastingLevel {
  static const level1 = 1;
  static const level2 = 2;
  static const level3 = 3;
}

// -- Conditioning types --
class ConditioningType {
  static const cold = 'cold';
  static const heat = 'heat';
  static const meditation = 'meditation';
  static const sleep = 'sleep';
}

// -- LLM report types --
class LlmReportType {
  static const postWorkout = 'post_workout';
  static const weekly = 'weekly';
  static const monthly = 'monthly';
  static const fasting = 'fasting';
  static const motivation = 'motivation';
}

// -- Biomarker types --
class BiomarkerType {
  static const bloodPanel = 'blood_panel';
  static const weight = 'weight';
  static const hrv = 'hrv';
  static const phenoage = 'phenoage';
}

// ============================================================
// TABLE DEFINITIONS
// ============================================================

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get category => text()(); // push/pull/squat/hinge/core
  IntColumn get phoenixLevel => integer().withDefault(const Constant(1))();
  TextColumn get musclesPrimary => text().withDefault(const Constant(''))();
  TextColumn get musclesSecondary => text().withDefault(const Constant(''))();
  TextColumn get instructions => text().withDefault(const Constant(''))();
  TextColumn get imagePaths => text().withDefault(const Constant(''))();
  TextColumn get animationPath => text().withDefault(const Constant(''))();
  IntColumn get progressionNextId => integer().nullable()();
  IntColumn get progressionPrevId => integer().nullable()();
  TextColumn get advancementCriteria => text().withDefault(const Constant(''))();

  // Phase 2 columns
  TextColumn get equipment => text().withDefault(const Constant('all'))();
  // 'gym' / 'home' / 'bodyweight' / 'all'
  TextColumn get executionCues => text().withDefault(const Constant(''))();
  // Cue di esecuzione in italiano
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();
  IntColumn get defaultRepsMin => integer().withDefault(const Constant(8))();
  IntColumn get defaultRepsMax => integer().withDefault(const Constant(12))();
  IntColumn get defaultTempoEcc => integer().withDefault(const Constant(3))();
  IntColumn get defaultTempoCon => integer().withDefault(const Constant(2))();
  TextColumn get dayType => text().withDefault(const Constant(''))();
  // 'push' / 'pull' / 'squat' / 'hinge' / 'core' / 'cardio' / 'power'
  TextColumn get exerciseType => text().withDefault(const Constant('compound'))();
  // 'compound' / 'accessory' / 'core'
}

class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get type => text()(); // strength/cardio/power/deload/flexibility
  RealColumn get durationMinutes => real().nullable()();
  TextColumn get durationScore => text().nullable()(); // green/yellow/red
  RealColumn get rpeAverage => real().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get llmSummaryText => text().withDefault(const Constant(''))();

  // Phase G — Warmup/Mobility tracking
  BoolColumn get warmupCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get stabilityCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get cooldownCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get cooldownType => text().nullable()(); // 'static' / 'pnf'
  RealColumn get avgHr => real().nullable()();
  IntColumn get maxHr => integer().nullable()();
  RealColumn get avgSpo2 => real().nullable()();
  RealColumn get avgRmssd => real().nullable()();
  TextColumn get bioStatsJson => text().nullable()();
}

class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get setNumber => integer()();
  IntColumn get repsTarget => integer().withDefault(const Constant(0))();
  IntColumn get repsCompleted => integer().withDefault(const Constant(0))();
  RealColumn get rpe => real().nullable()();
  IntColumn get tempoEccentric => integer().withDefault(const Constant(3))();
  IntColumn get tempoConcentric => integer().withDefault(const Constant(2))();
  IntColumn get restSecondsAfter => integer().withDefault(const Constant(120))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  RealColumn get avgHr => real().nullable()();
  IntColumn get maxHr => integer().nullable()();
  IntColumn get spo2 => integer().nullable()();
  RealColumn get rmssd => real().nullable()();
  RealColumn get stressIndex => real().nullable()();
  IntColumn get hrRecoveryBpm => integer().nullable()();
  RealColumn get skinTemp => real().nullable()();
}

class FastingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  RealColumn get targetHours => real()();
  RealColumn get actualHours => real().nullable()();
  IntColumn get level => integer().withDefault(const Constant(1))();
  TextColumn get glucoseReadingsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get hrvReadingsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get refeedingNotes => text().withDefault(const Constant(''))();
  RealColumn get toleranceScore => real().nullable()();
  IntColumn get energyScore => integer().nullable()(); // 1-5 post-refeeding
  IntColumn get waterCount => integer().withDefault(const Constant(0))();
  TextColumn get llmSummaryText => text().withDefault(const Constant(''))();
}

// -- Protein estimate levels --
class ProteinEstimate {
  static const low = 'low'; // <15g
  static const medium = 'medium'; // 15-30g
  static const high = 'high'; // 30-45g
  static const veryHigh = 'very_high'; // >45g
}

class MealLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get mealTime => dateTime()();
  TextColumn get description => text()();
  TextColumn get proteinEstimate =>
      text()(); // 'low' / 'medium' / 'high' / 'very_high'
  TextColumn get feeling =>
      text().withDefault(const Constant(''))(); // emoji code
  TextColumn get notes => text().withDefault(const Constant(''))();

  // Phase M — Full macro tracking
  RealColumn get carbEstimate => real().nullable()();
  RealColumn get fatEstimate => real().nullable()();
  RealColumn get fiberEstimate => real().nullable()();
  RealColumn get caloriesEstimate => real().nullable()();
}

class Biomarkers extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // blood_panel/weight/hrv/phenoage
  TextColumn get valuesJson => text()();
}

class ConditioningSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // cold/heat/meditation/sleep
  IntColumn get durationSeconds => integer()();
  RealColumn get temperature => real().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class LlmReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get type => text()(); // post_workout/weekly/monthly/fasting/motivation
  TextColumn get promptTemplate => text()();
  TextColumn get contextDataJson => text()();
  TextColumn get outputText => text()();
}

class ProgressionHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get fromLevel => integer()();
  IntColumn get toLevel => integer()();
  TextColumn get criteriaMetJson =>
      text().withDefault(const Constant('{}'))();
}

class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get settingsJson =>
      text().withDefault(const Constant('{}'))();
}

// -- Day types for nutrition --
class NutritionDayType {
  static const training = 'training';
  static const normal = 'normal';
  static const autophagy = 'autophagy';
}

class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()(); // "Tier 1 — Ringiovanimento", etc.
  RealColumn get proteinPer100g => real()();
  RealColumn get carbsPer100g => real()();
  RealColumn get fatsPer100g => real()();
  RealColumn get caloriesPer100g => real()();
  RealColumn get fiberPer100g => real().nullable()();
  IntColumn get glycemicIndex => integer().nullable()();
  TextColumn get portionExample => text()();
  TextColumn get useIdeas => text()();
  TextColumn get longevityBenefit => text()();
  TextColumn get activeCompounds => text()(); // JSON
  IntColumn get longevityTier => integer()(); // 1-4
  TextColumn get idealTiming => text().nullable()();
}

class MealTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayType => text()(); // training / normal / autophagy
  IntColumn get mealNumber => integer()(); // 1, 2, 3
  TextColumn get timeSlot => text()(); // "09:00", "13:00", "16:30"
  TextColumn get description => text()();
  TextColumn get ingredients => text()(); // JSON array
  RealColumn get proteinEstimateG => real()(); // total grams protein
  RealColumn get caloriesEstimate => real()(); // total kcal
  TextColumn get cookingMethod => text()();
  TextColumn get timing => text()(); // "post-training", "principale", "leggero"

  // Phase M — Full macro estimates
  RealColumn get carbEstimateG => real().nullable()();
  RealColumn get fatEstimateG => real().nullable()();
  RealColumn get fiberEstimateG => real().nullable()();
}

// -- Research feed --
class ResearchImpact {
  static const high = 'high';
  static const medium = 'medium';
  static const low = 'low';
}

class ResearchUpdateStatus {
  static const pending = 'pending';
  static const approved = 'approved';
  static const rejected = 'rejected';
}

class ResearchFeed extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get foundDate => dateTime()();
  TextColumn get source => text()(); // "pubmed" / "cnki" / "cyberleninka"
  TextColumn get language => text()(); // "en" / "zh" / "ru"
  TextColumn get title => text()();
  TextColumn get abstractText => text()();
  TextColumn get doi => text().nullable()();
  TextColumn get url => text()();
  TextColumn get area => text()(); // "nutrition" / "exercise" / "supplements" / ...
  TextColumn get keySummary => text()(); // 1-sentence LLM summary
  TextColumn get impact => text()(); // "high" / "medium" / "low"
  BoolColumn get userRead => boolean().withDefault(const Constant(false))();
  BoolColumn get proposedUpdate =>
      boolean().withDefault(const Constant(false))();
  TextColumn get updateProposal => text().nullable()();
  TextColumn get updateStatus => text().nullable()(); // pending/approved/rejected
}

// -- Assessment test types --
class AssessmentTestType {
  static const pushupMax = 'pushup_max';
  static const wallSit = 'wall_sit';
  static const plankHold = 'plank_hold';
  static const sitAndReach = 'sit_and_reach';
  static const cooperTest = 'cooper_test';
  static const weight = 'weight';
}

// ============================================================
// PHASE F — CARDIO SESSIONS
// ============================================================

/// Cardio protocol types
class CardioProtocolType {
  static const tabata = 'tabata';
  static const norwegian = 'norwegian';
  static const zone2 = 'zone2_only';
}

class CardioSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get protocol => text()(); // 'tabata' / 'norwegian' / 'zone2_only'
  IntColumn get roundsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get roundsTotal => integer().withDefault(const Constant(0))();
  IntColumn get totalDurationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get zone2Minutes => integer().withDefault(const Constant(0))();
  IntColumn get avgHrEstimated => integer().nullable()();
  IntColumn get perceivedExertion => integer().nullable()(); // RPE 1-10
  TextColumn get modality => text().withDefault(const Constant('bodyweight'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

// ============================================================
// PHASE C — MESOCYCLE STATE (Periodization)
// ============================================================

class MesocycleStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tier => text()(); // beginner/intermediate/advanced
  IntColumn get mesocycleNumber => integer().withDefault(const Constant(1))();
  IntColumn get weekInMesocycle => integer().withDefault(const Constant(1))();
  TextColumn get currentBlock => text().nullable()(); // accumulo/trasformazione/realizzazione/deload
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

// ============================================================
// PHASE D — MESOCYCLE EXERCISE ASSIGNMENTS (Rotation)
// ============================================================

class MesocycleExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mesocycleNumber => integer()();
  TextColumn get slotCategory => text()(); // push/pull/squat/hinge/core
  TextColumn get slotType => text()(); // compound/accessory/core
  IntColumn get slotIndex => integer()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  BoolColumn get locked => boolean().withDefault(const Constant(false))();
}

// ============================================================
// PHASE H — HRV READINGS
// ============================================================

class HrvReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get rmssd => real()();
  RealColumn get lnRmssd => real()();
  RealColumn get stressIndex => real().nullable()(); // Bayevsky SI
  TextColumn get source => text()(); // 'apple_watch' / 'garmin' / 'oura' / 'manual'
  TextColumn get context => text().withDefault(const Constant('morning'))();
}

// ============================================================
// PHASE N — WEEK 0 SESSIONS
// ============================================================

class Week0Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionNumber => integer()(); // 1-6
  TextColumn get focus => text()(); // 'lower_basics', 'upper_basics', etc.
  DateTimeColumn get completedAt => dateTime().nullable()();
  RealColumn get avgRpe => real().nullable()();
  BoolColumn get passed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class Assessments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get pushupMaxReps => integer().nullable()();
  IntColumn get wallSitSeconds => integer().nullable()();
  IntColumn get plankHoldSeconds => integer().nullable()();
  RealColumn get sitAndReachCm => real().nullable()();
  RealColumn get cooperDistanceM => real().nullable()(); // meters in 12 min
  RealColumn get weightKg => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get armCm => real().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get scoresJson => text().withDefault(const Constant('{}'))();
  // JSON: {"pushup": "excellent", "plank": "good", ...}
}

// ============================================================
// COLMI R10 — RING DEVICE
// ============================================================

class RingDevices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get macAddress => text()();
  TextColumn get name => text()();
  TextColumn get firmwareVersion => text().withDefault(const Constant(''))();
  TextColumn get hardwareVersion => text().withDefault(const Constant(''))();
  TextColumn get capabilitiesJson =>
      text().withDefault(const Constant('{}'))();
  DateTimeColumn get lastSync => dateTime().nullable()();
  IntColumn get batteryLevel => integer().withDefault(const Constant(-1))();
  DateTimeColumn get pairedAt => dateTime()();
}

// ── Ring HR Samples ───────────────────────────────────────────
class RingHrSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get hr => integer()();
  TextColumn get source => text()(); // 'log_sync' / 'real_time' / 'workout'
  RealColumn get quality => real().nullable()();
}

// ── Ring Sleep Stages ─────────────────────────────────────────
class RingSleepStages extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get nightDate => dateTime()();
  TextColumn get stage => text()(); // 'deep' / 'light' / 'rem' / 'awake'
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get hrAvg => integer().nullable()();
  RealColumn get tempAvg => real().nullable()();
}

// ── Ring Steps ────────────────────────────────────────────────
class RingSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get steps => integer()();
  IntColumn get calories => integer()();
  IntColumn get distanceM => integer()();
}

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // Dati anagrafici
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get sex => text()(); // 'male' / 'female'
  IntColumn get birthYear => integer()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();

  // Livello e equipment
  TextColumn get trainingTier => text()(); // 'beginner' / 'intermediate' / 'advanced'
  TextColumn get equipment => text()(); // 'gym' / 'home' / 'bodyweight'

  // Self-test (opzionali)
  IntColumn get maxPushups => integer().nullable()();
  IntColumn get maxSquats => integer().nullable()();
  IntColumn get plankSeconds => integer().nullable()();
  IntColumn get restingHr => integer().nullable()();

  // Onboarding completato
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
}
