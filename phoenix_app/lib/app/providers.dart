import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/database.dart';
import '../core/database/daos/workout_dao.dart';
import '../core/database/daos/fasting_dao.dart';
import '../core/database/daos/biomarker_dao.dart';
import '../core/database/daos/conditioning_dao.dart';
import '../core/database/daos/user_profile_dao.dart';
import '../core/database/daos/exercise_dao.dart';
import '../core/database/daos/meal_log_dao.dart';
import '../core/database/daos/llm_report_dao.dart';
import '../core/database/daos/progression_dao.dart';
import '../core/database/daos/food_dao.dart';
import '../core/database/daos/meal_template_dao.dart';
import '../core/database/daos/assessment_dao.dart';
import '../core/database/daos/research_feed_dao.dart';
import '../core/database/daos/mesocycle_dao.dart';
import '../core/database/daos/hrv_dao.dart';
import '../core/database/daos/week0_dao.dart';
import '../core/database/daos/cardio_dao.dart';
import '../core/database/daos/ring_device_dao.dart';
import '../core/database/daos/ring_data_dao.dart';
import '../core/ring/ring_service.dart';
import '../core/ring/ring_lock_manager.dart';
import '../core/ring/signal_processor.dart';
import '../core/ring/sleep_notifier.dart';
import '../core/ring/sleep_parser.dart';
import '../core/models/workout_generator.dart';
import '../core/models/periodization_engine.dart' as pe;
import '../core/models/meal_plan_generator.dart';
import '../core/models/workout_plan.dart';
import '../core/models/report_generator.dart';
import '../core/models/activity_rings_data.dart';
import '../core/models/daily_protocol.dart';
import '../core/llm/llm_engine.dart';
import '../core/llm/llm_runtime.dart';
import '../core/llm/model_manager.dart';
import '../core/llm/template_chat.dart';
import '../core/audio/audio_engine.dart';
import '../core/models/app_settings.dart';
import '../core/models/settings_notifier.dart';
import '../core/models/sleep_environment.dart';
import '../core/notifications/notification_service.dart';
import '../core/tts/coach_voice.dart';
import '../core/ring/morning_hrv_check.dart';
import '../core/ring/ring_sync_coordinator.dart';
import '../core/ring/workout_bio_tracker.dart';

// -- Database --
final databaseProvider = Provider<PhoenixDatabase>((ref) {
  final db = PhoenixDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// -- DAOs --
final workoutDaoProvider = Provider<WorkoutDao>((ref) {
  return WorkoutDao(ref.watch(databaseProvider));
});

final fastingDaoProvider = Provider<FastingDao>((ref) {
  return FastingDao(ref.watch(databaseProvider));
});

final biomarkerDaoProvider = Provider<BiomarkerDao>((ref) {
  return BiomarkerDao(ref.watch(databaseProvider));
});

final conditioningDaoProvider = Provider<ConditioningDao>((ref) {
  return ConditioningDao(ref.watch(databaseProvider));
});

final exerciseDaoProvider = Provider<ExerciseDao>((ref) {
  return ExerciseDao(ref.watch(databaseProvider));
});

final mealLogDaoProvider = Provider<MealLogDao>((ref) {
  return MealLogDao(ref.watch(databaseProvider));
});

final llmReportDaoProvider = Provider<LlmReportDao>((ref) {
  return LlmReportDao(ref.watch(databaseProvider));
});

final progressionDaoProvider = Provider<ProgressionDao>((ref) {
  return ProgressionDao(ref.watch(databaseProvider));
});

final foodDaoProvider = Provider<FoodDao>((ref) {
  return FoodDao(ref.watch(databaseProvider));
});

final mealTemplateDaoProvider = Provider<MealTemplateDao>((ref) {
  return MealTemplateDao(ref.watch(databaseProvider));
});

final assessmentDaoProvider = Provider<AssessmentDao>((ref) {
  return AssessmentDao(ref.watch(databaseProvider));
});

final researchFeedDaoProvider = Provider<ResearchFeedDao>((ref) {
  return ResearchFeedDao(ref.watch(databaseProvider));
});

final mesocycleDaoProvider = Provider<MesocycleDao>((ref) {
  return MesocycleDao(ref.watch(databaseProvider));
});

final hrvDaoProvider = Provider<HrvDao>((ref) {
  return HrvDao(ref.watch(databaseProvider));
});

final week0DaoProvider = Provider<Week0Dao>((ref) {
  return Week0Dao(ref.watch(databaseProvider));
});

final cardioDaoProvider = Provider<CardioDao>((ref) {
  return CardioDao(ref.watch(databaseProvider));
});

final ringDeviceDaoProvider = Provider<RingDeviceDao>((ref) {
  return RingDeviceDao(ref.watch(databaseProvider));
});

final ringDataDaoProvider = Provider<RingDataDao>((ref) {
  return RingDataDao(ref.watch(databaseProvider));
});

// -- Smart Ring --
final ringServiceProvider = Provider<RingService>((ref) {
  final service = RingService();
  service.init();
  ref.onDispose(() => service.dispose());
  return service;
});

final ringLockManagerProvider = Provider<RingLockManager>((ref) {
  return RingLockManager();
});

final signalProcessorProvider = Provider<SignalProcessor>((ref) {
  return SignalProcessor();
});

/// Stream of the paired ring device from DB (reactive).
final pairedRingProvider = StreamProvider<RingDevice?>((ref) {
  return ref.watch(ringDeviceDaoProvider).watchPairedRing();
});

// -- Meal Plan --
final mealPlanGeneratorProvider = Provider<MealPlanGenerator>((ref) {
  return MealPlanGenerator(ref.watch(mealTemplateDaoProvider));
});

/// Today's meal plan, scaled by user weight and day type.
final mealPlanProvider = FutureProvider<MealPlan>((ref) async {
  final generator = ref.watch(mealPlanGeneratorProvider);
  final profile = await ref.watch(userProfileProvider.future);
  final weekday = DateTime.now().weekday;
  final dayType = MealPlanGenerator.dayTypeForWeekday(weekday);

  return generator.generateForDay(
    weightKg: profile?.weightKg ?? 70.0,
    dayType: dayType,
  );
});

// -- Workout Generator --
final workoutGeneratorProvider = Provider<WorkoutGenerator>((ref) {
  return WorkoutGenerator(ref.watch(exerciseDaoProvider));
});

/// Equipment override for today's session (null = use profile default).
final equipmentOverrideProvider =
    StateNotifierProvider<EquipmentOverrideNotifier, String?>((ref) {
  return EquipmentOverrideNotifier();
});

/// Today's workout plan, derived from user profile + day of week.
/// Respects equipmentOverrideProvider if set.
/// Filters out exercises excluded by physical assessment.
/// Phase C: Uses PeriodizationEngine via mesocycle state when available.
final todayWorkoutPlanProvider = FutureProvider<WorkoutPlan>((ref) async {
  final generator = ref.watch(workoutGeneratorProvider);
  final profile = await ref.watch(userProfileProvider.future);
  final equipmentOverride = ref.watch(equipmentOverrideProvider);
  final settings = ref.watch(settingsProvider);
  final weekday = DateTime.now().weekday; // 1=Mon ... 7=Sun

  // Parse level overrides from AI-generated training program
  Map<String, int> levelOverrides = {};
  if (settings.levelOverridesJson != null) {
    try {
      final parsed = Map<String, dynamic>.from(
          jsonDecode(settings.levelOverridesJson!) as Map);
      levelOverrides = parsed.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (e) { debugPrint('Provider error: $e'); }
  }

  // Phase C: Get current mesocycle state for periodization
  final mesocycleDao = ref.watch(mesocycleDaoProvider);
  final dbMesocycle = await mesocycleDao.getCurrentMesocycle();
  pe.MesocycleState? mesocycleState;
  if (dbMesocycle != null) {
    mesocycleState = pe.MesocycleState(
      tier: dbMesocycle.tier,
      mesocycleNumber: dbMesocycle.mesocycleNumber,
      weekInMesocycle: dbMesocycle.weekInMesocycle,
      currentBlock: dbMesocycle.currentBlock,
      startedAt: dbMesocycle.startedAt,
      completedAt: dbMesocycle.completedAt,
    );
  }

  // Phase D: Get rotated exercise selections for current mesocycle
  Map<String, int> mesocycleExerciseIds = {};
  if (dbMesocycle != null) {
    final assignments = await mesocycleDao.getExercisesForMesocycle(
        dbMesocycle.mesocycleNumber);
    for (final a in assignments) {
      final key = '${a.slotCategory}_${a.slotType}_${a.slotIndex}';
      mesocycleExerciseIds[key] = a.exerciseId;
    }
  }

  // Phase J: Compute age from birth year for age adaptation
  final currentYear = DateTime.now().year;
  final userAge = profile?.birthYear != null
      ? currentYear - profile!.birthYear
      : null;

  // Parse exercise modifications (graduated severity: adapt/substitute/exclude)
  Map<int, Map<String, dynamic>> exerciseModifications = {};
  if (settings.modifiedExercisesJson != null) {
    try {
      final parsed = Map<String, dynamic>.from(
          jsonDecode(settings.modifiedExercisesJson!) as Map);
      exerciseModifications = parsed.map((k, v) =>
          MapEntry(int.parse(k), Map<String, dynamic>.from(v as Map)));
    } catch (e) { debugPrint('Provider error parsing modifications: $e'); }
  }

  return generator.generateForDay(
    weekday: weekday,
    tier: profile?.trainingTier ?? 'beginner',
    equipment: equipmentOverride ?? profile?.equipment ?? 'bodyweight',
    excludeIds: settings.excludedExerciseIds,
    levelOverrides: levelOverrides,
    mesocycleState: mesocycleState,
    mesocycleExerciseIds: mesocycleExerciseIds,
    userAge: userAge,
    exerciseModifications: exerciseModifications,
  );
});

// -- Report Generator --
final reportGeneratorProvider = Provider<ReportGenerator>((ref) {
  return ReportGenerator(
    workoutDao: ref.watch(workoutDaoProvider),
    fastingDao: ref.watch(fastingDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
    biomarkerDao: ref.watch(biomarkerDaoProvider),
    exerciseDao: ref.watch(exerciseDaoProvider),
    llmReportDao: ref.watch(llmReportDaoProvider),
  );
});

// -- Dashboard Data --
final activityRingsProvider = FutureProvider<ActivityRingsData>((ref) {
  return ActivityRingsData.compute(
    workoutDao: ref.watch(workoutDaoProvider),
    fastingDao: ref.watch(fastingDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
  );
});

final oneBigThingProvider = FutureProvider<OneBigThing>((ref) async {
  final generator = ref.watch(workoutGeneratorProvider);
  final schedule = generator.scheduleFor(DateTime.now().weekday);
  return OneBigThing.compute(
    workoutDao: ref.watch(workoutDaoProvider),
    fastingDao: ref.watch(fastingDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
    biomarkerDao: ref.watch(biomarkerDaoProvider),
    todayDayName: schedule.dayName,
  );
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) {
  return DashboardStats.compute(
    workoutDao: ref.watch(workoutDaoProvider),
    biomarkerDao: ref.watch(biomarkerDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
  );
});

// -- Daily Protocol --
final dailyProtocolProvider = FutureProvider<DailyProtocol>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  final workoutPlan = await ref.watch(todayWorkoutPlanProvider.future);
  final settings = ref.watch(settingsProvider);

  // Parse SleepEnvironment from settings JSON, fallback to defaults
  SleepEnvironment sleepEnv = const SleepEnvironment();
  if (settings.sleepEnvironmentJson != null) {
    try {
      final map = Map<String, dynamic>.from(
        const JsonCodec().decode(settings.sleepEnvironmentJson!) as Map,
      );
      sleepEnv = SleepEnvironment.fromJson(map);
    } catch (e) { debugPrint('Provider error: $e'); }
  }

  // Check ring sleep data for auto-completion
  final ringDataDao = ref.watch(ringDataDaoProvider);
  final hasRingSleep = await ringDataDao.hasLastNightSleep();

  return DailyProtocol.compute(
    workoutDao: ref.watch(workoutDaoProvider),
    fastingDao: ref.watch(fastingDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
    mealLogDao: ref.watch(mealLogDaoProvider),
    todayWorkout: workoutPlan,
    weightKg: profile?.weightKg ?? 70.0,
    tier: profile?.trainingTier ?? 'beginner',
    sleepEnv: sleepEnv,
    hasRingSleep: hasRingSleep,
  );
});

// -- Ring Sleep Summary --
/// Last night's sleep summary from ring data (null if no ring data).
final ringLastNightSleepProvider = FutureProvider<SleepSummary?>((ref) async {
  final ringDataDao = ref.watch(ringDataDaoProvider);
  final hasData = await ringDataDao.hasLastNightSleep();
  if (!hasData) return null;

  final now = DateTime.now();
  final nightDate = now.hour < 12
      ? DateTime(now.year, now.month, now.day - 1)
      : DateTime(now.year, now.month, now.day);

  final stages = await ringDataDao.getSleepStages(nightDate);
  if (stages.isEmpty) return null;

  // Convert DB rows to SleepPeriod list for SleepSession
  final periods = stages.map((s) => SleepPeriod(
    stage: SleepStage.fromLabel(s.stage),
    start: s.startTime,
    end: s.endTime,
  )).toList();

  final session = SleepSession(nightDate: nightDate, stages: periods);
  return SleepSummary.fromSession(session);
});

// -- Template Chat --
final templateChatProvider = Provider<TemplateChat>((ref) {
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final chat = TemplateChat(
    workoutDao: ref.watch(workoutDaoProvider),
    fastingDao: ref.watch(fastingDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
    biomarkerDao: ref.watch(biomarkerDaoProvider),
    exerciseDao: ref.watch(exerciseDaoProvider),
    mealLogDao: ref.watch(mealLogDaoProvider),
    assessmentDao: ref.watch(assessmentDaoProvider),
    hrvDao: ref.watch(hrvDaoProvider),
    cardioDao: ref.watch(cardioDaoProvider),
    mesocycleDao: ref.watch(mesocycleDaoProvider),
    progressionDao: ref.watch(progressionDaoProvider),
  );
  // Inject user profile for personalized responses
  if (profile != null) {
    chat.setUserProfile(
      name: profile.name,
      weightKg: profile.weightKg,
      tier: profile.trainingTier,
      age: DateTime.now().year - profile.birthYear,
      sex: profile.sex,
    );
  }
  return chat;
});

// -- LLM --
final llmEngineProvider = ChangeNotifierProvider<LlmEngine>((ref) {
  final chat = ref.read(templateChatProvider);
  final fallback = TemplateFallbackRuntime(chat: chat);
  final engine = LlmEngine(runtime: fallback);
  final settings = ref.read(settingsProvider);
  if (settings.aiCoachEnabled) {
    // Attempt to initialize best runtime in background
    engine.initBestRuntime(templateChat: chat).then((_) {
      if (engine.tokPerSec > 0) {
        ref.read(settingsProvider.notifier).setLastBenchmarkTokS(engine.tokPerSec);
      }
    });
  } else {
    // Even without AI enabled, set status to ready for template-based coach
    engine.setReadyIfUnloaded();
  }
  ref.onDispose(() => engine.dispose());
  return engine;
});

// -- Model Manager --
final modelManagerProvider = ChangeNotifierProvider<ModelManager>((ref) {
  final manager = ModelManager();
  manager.checkStatus();
  ref.onDispose(() => manager.dispose());
  return manager;
});

// -- Audio --
final audioEngineProvider = Provider<AudioEngine>((ref) {
  final engine = AudioEngine();
  ref.onDispose(() => engine.dispose());
  return engine;
});

// -- Notifications --
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// -- TTS Coach --
final coachVoiceProvider = Provider<CoachVoice>((ref) {
  final settings = ref.watch(settingsProvider);
  final coach = CoachVoice();
  coach.init();
  coach.enabled = settings.coachVoiceEnabled;
  coach.volume = settings.coachVolume;
  ref.onDispose(() => coach.dispose());
  return coach;
});

// -- User Profile --
final userProfileDaoProvider = Provider<UserProfileDao>((ref) {
  return UserProfileDao(ref.watch(databaseProvider));
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(userProfileDaoProvider).watchProfile();
});

// -- Settings --
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(databaseProvider));
});

// -- Morning HRV Check --
final morningHrvCheckProvider = Provider<MorningHrvCheck>((ref) {
  return MorningHrvCheck(
    ring: ref.watch(ringServiceProvider),
    lock: ref.watch(ringLockManagerProvider),
    hrvDao: ref.watch(hrvDaoProvider),
    processor: ref.watch(signalProcessorProvider),
  );
});

final hrvPendingProvider = Provider<ValueNotifier<bool>>((ref) {
  return ref.watch(morningHrvCheckProvider).hrvPending;
});

// -- Workout Bio Tracker --
final workoutBioTrackerProvider = Provider<WorkoutBioTracker>((ref) {
  final tracker = WorkoutBioTracker(
    ring: ref.watch(ringServiceProvider),
    lock: ref.watch(ringLockManagerProvider),
    processor: ref.watch(signalProcessorProvider),
  );
  ref.onDispose(() => tracker.dispose());
  return tracker;
});

// -- Ring Sync Coordinator --
final ringSyncCoordinatorProvider = Provider<RingSyncCoordinator>((ref) {
  return RingSyncCoordinator(
    ring: ref.watch(ringServiceProvider),
    dataDao: ref.watch(ringDataDaoProvider),
    deviceDao: ref.watch(ringDeviceDaoProvider),
    processor: ref.watch(signalProcessorProvider),
    notifications: ref.watch(notificationServiceProvider),
    hrvCheck: ref.watch(morningHrvCheckProvider),
    workoutDao: ref.watch(workoutDaoProvider),
    fastingDao: ref.watch(fastingDaoProvider),
    conditioningDao: ref.watch(conditioningDaoProvider),
    mealLogDao: ref.watch(mealLogDaoProvider),
  );
});

// -- Theme (derived from settings) --
final themeModeProvider = Provider<ThemeMode>((ref) {
  final mode = ref.watch(settingsProvider).themeMode;
  return switch (mode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});
