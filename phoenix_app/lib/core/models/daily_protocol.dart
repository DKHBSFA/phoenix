import '../database/daos/workout_dao.dart';
import '../database/daos/fasting_dao.dart';
import '../database/daos/conditioning_dao.dart';
import '../database/daos/meal_log_dao.dart';
import '../database/tables.dart';
import 'coach_prompts.dart';
import 'workout_plan.dart';
import 'cold_progression.dart';
import 'sleep_environment.dart';
import 'meal_plan_generator.dart' show MealPlanGenerator;
import 'nutrition_calculator.dart';

/// Status of an individual protocol activity.
enum ActivityStatus { notStarted, inProgress, completed }

/// Fasting status for the day.
class FastingStatus {
  final ActivityStatus status;
  final int hoursCompleted;
  final double targetHours;
  final int waterCount;

  const FastingStatus({
    required this.status,
    required this.hoursCompleted,
    required this.targetHours,
    required this.waterCount,
  });
}

/// Nutrition progress for the day.
class NutritionProgress {
  final double proteinEaten;
  final double proteinTarget;
  final double carbEaten;
  final double fatEaten;
  final double fiberEaten;
  final String eatingWindow;
  final int mealsLogged;
  final MacroTargets? macroTargets;

  const NutritionProgress({
    required this.proteinEaten,
    required this.proteinTarget,
    this.carbEaten = 0,
    this.fatEaten = 0,
    this.fiberEaten = 0,
    required this.eatingWindow,
    required this.mealsLogged,
    this.macroTargets,
  });
}

/// Cold exposure stats for the week.
class ColdStats {
  final int targetSeconds;
  final int weeklyDoseSeconds;
  final int weeklyTargetSeconds;
  final int sessionsThisWeek;
  final double? hoursSinceStrength;

  const ColdStats({
    required this.targetSeconds,
    required this.weeklyDoseSeconds,
    required this.weeklyTargetSeconds,
    required this.sessionsThisWeek,
    this.hoursSinceStrength,
  });
}

/// Last night's sleep data.
class SleepData {
  final Duration? duration;
  final int? qualityStars;
  final String? targetBedtime;
  final String? targetWake;

  const SleepData({
    this.duration,
    this.qualityStars,
    this.targetBedtime,
    this.targetWake,
  });
}

/// The complete daily protocol state.
class DailyProtocol {
  final WorkoutPlan? todayWorkout;
  final bool workoutCompleted;
  final FastingStatus fastingStatus;
  final NutritionProgress nutritionProgress;
  final ColdStats coldStats;
  final bool coldDone;
  final bool meditationDone;
  final SleepData lastNightSleep;
  final bool sleepLogged;
  final String coachMessage;

  const DailyProtocol({
    required this.todayWorkout,
    required this.workoutCompleted,
    required this.fastingStatus,
    required this.nutritionProgress,
    required this.coldStats,
    required this.coldDone,
    required this.meditationDone,
    required this.lastNightSleep,
    required this.sleepLogged,
    required this.coachMessage,
  });

  int get completedCount {
    var count = 0;
    if (workoutCompleted) count++;
    if (fastingStatus.status == ActivityStatus.completed) count++;
    if (nutritionProgress.mealsLogged >= 3) count++;
    if (coldDone) count++;
    if (meditationDone) count++;
    if (sleepLogged) count++;
    return count;
  }

  int get totalCount => 6;
  double get progress => completedCount / totalCount;

  /// Compute the full daily protocol from DB data.
  static Future<DailyProtocol> compute({
    required WorkoutDao workoutDao,
    required FastingDao fastingDao,
    required ConditioningDao conditioningDao,
    required MealLogDao mealLogDao,
    required WorkoutPlan? todayWorkout,
    required double weightKg,
    required String tier,
    SleepEnvironment sleepEnv = const SleepEnvironment(),
    bool hasRingSleep = false,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Workout
    final todaySessions = await workoutDao.getTodaySessions();
    final workoutCompleted = todaySessions.isNotEmpty;

    // Fasting
    final activeFast = await fastingDao.getActiveFast();
    FastingStatus fastingStatus;
    if (activeFast != null) {
      final elapsed = now.difference(activeFast.startedAt).inHours;
      final target = activeFast.targetHours;
      fastingStatus = FastingStatus(
        status: elapsed >= target
            ? ActivityStatus.completed
            : ActivityStatus.inProgress,
        hoursCompleted: elapsed,
        targetHours: target,
        waterCount: activeFast.waterCount,
      );
    } else {
      // Check if completed today
      final lastCompleted = await fastingDao.getLastCompleted();
      final endedAt = lastCompleted?.endedAt;
      final doneToday = endedAt != null && endedAt.isAfter(today);
      fastingStatus = FastingStatus(
        status: doneToday ? ActivityStatus.completed : ActivityStatus.notStarted,
        hoursCompleted: doneToday
            ? endedAt.difference(lastCompleted!.startedAt).inHours
            : 0,
        targetHours: 14.0,
        waterCount: doneToday ? lastCompleted!.waterCount : 0,
      );
    }

    // Nutrition
    final meals = await mealLogDao.getMealsForDay(today);
    // proteinEstimate is a text label; estimate grams per meal
    final proteinEaten = meals.fold<double>(0, (sum, m) {
      final grams = switch (m.proteinEstimate) {
        ProteinEstimate.veryHigh => 40.0,
        ProteinEstimate.high => 30.0,
        ProteinEstimate.medium => 20.0,
        ProteinEstimate.low => 10.0,
        _ => 15.0,
      };
      return sum + grams;
    });
    final calc = NutritionCalculator(weightKg: weightKg, tier: tier);
    // Phase M: compute full macro targets
    final weekday = now.weekday;
    final dayType = MealPlanGenerator.dayTypeForWeekday(weekday);
    final macroTargets = MacroTargets.forDay(
      weightKg: weightKg,
      dayType: dayType,
      tier: tier,
    );
    // Phase M: aggregate carb/fat/fiber from meal logs
    final carbEaten = meals.fold<double>(0, (sum, m) => sum + (m.carbEstimate ?? 0));
    final fatEaten = meals.fold<double>(0, (sum, m) => sum + (m.fatEstimate ?? 0));
    final fiberEaten = meals.fold<double>(0, (sum, m) => sum + (m.fiberEstimate ?? 0));
    final nutritionProgress = NutritionProgress(
      proteinEaten: proteinEaten,
      proteinTarget: calc.dailyProteinGrams,
      carbEaten: carbEaten,
      fatEaten: fatEaten,
      fiberEaten: fiberEaten,
      eatingWindow: '10:00 – 18:00',
      mealsLogged: meals.length,
      macroTargets: macroTargets,
    );

    // Cold
    final coldSessions = await conditioningDao.getRecentByType(
      ConditioningType.cold,
      days: 30,
    );
    final coldThisWeek = coldSessions.where((s) {
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      return s.date.isAfter(weekStart.subtract(const Duration(days: 1)));
    }).toList();
    final coldDoseSeconds = coldThisWeek.fold<int>(
      0,
      (sum, s) => sum + s.durationSeconds,
    );
    final coldToday = coldThisWeek.where((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day).isNotEmpty;
    final firstCold = coldSessions.isNotEmpty ? coldSessions.last.date : null;
    final week = ColdProgression.currentWeek(firstCold);
    final lastStrength = await workoutDao.lastStrengthEndTime();
    final coldStats = ColdStats(
      targetSeconds: ColdProgression.targetSeconds(week),
      weeklyDoseSeconds: coldDoseSeconds,
      weeklyTargetSeconds: ColdProgression.weeklyDoseTargetSeconds,
      sessionsThisWeek: coldThisWeek.length,
      hoursSinceStrength: ColdProgression.hoursSinceStrength(lastStrength),
    );

    // Meditation
    final meditationSessions = await conditioningDao.getRecentByType(
      ConditioningType.meditation,
      days: 7,
    );
    final meditationDone = meditationSessions.any((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day);

    // Sleep
    final sleepSessions = await conditioningDao.getRecentByType(
      ConditioningType.sleep,
      days: 7,
    );
    SleepData sleepData;
    bool sleepLogged = false;
    if (sleepSessions.isNotEmpty) {
      final latest = sleepSessions.first;
      final loggedToday = latest.date.year == today.year &&
          latest.date.month == today.month &&
          latest.date.day == today.day;
      // Auto-complete via ring sleep data OR manual entry
      sleepLogged = loggedToday || hasRingSleep;
      sleepData = SleepData(
        duration: Duration(seconds: latest.durationSeconds),
        qualityStars: latest.temperature?.round(), // reused field for quality
        targetBedtime: sleepEnv.targetBedtimeStr,
        targetWake: sleepEnv.targetWakeTimeStr,
      );
    } else {
      // No manual entry, but ring may have data
      sleepLogged = hasRingSleep;
      sleepData = SleepData(
        targetBedtime: sleepEnv.targetBedtimeStr,
        targetWake: sleepEnv.targetWakeTimeStr,
      );
    }

    // Pre-compute completed count for coach message
    final fastingDone = fastingStatus.status == ActivityStatus.completed;
    final nutritionDone = nutritionProgress.mealsLogged >= 3;
    var preCompletedCount = 0;
    if (workoutCompleted) preCompletedCount++;
    if (fastingDone) preCompletedCount++;
    if (nutritionDone) preCompletedCount++;
    if (coldToday) preCompletedCount++;
    if (meditationDone) preCompletedCount++;
    if (sleepLogged) preCompletedCount++;

    // Coach message
    final coachMessage = _generateCoachMessage(
      todayWorkout: todayWorkout,
      workoutCompleted: workoutCompleted,
      fastingDone: fastingDone,
      coldDone: coldToday,
      meditationDone: meditationDone,
      sleepLogged: sleepLogged,
      completedCount: preCompletedCount,
      totalCount: 6,
      now: now,
      sleepEnv: sleepEnv,
    );

    return DailyProtocol(
      todayWorkout: todayWorkout,
      workoutCompleted: workoutCompleted,
      fastingStatus: fastingStatus,
      nutritionProgress: nutritionProgress,
      coldStats: coldStats,
      coldDone: coldToday,
      meditationDone: meditationDone,
      lastNightSleep: sleepData,
      sleepLogged: sleepLogged,
      coachMessage: coachMessage,
    );
  }

  static String _generateCoachMessage({
    required WorkoutPlan? todayWorkout,
    required bool workoutCompleted,
    required bool fastingDone,
    required bool coldDone,
    required bool meditationDone,
    required bool sleepLogged,
    required int completedCount,
    required int totalCount,
    required DateTime now,
    required SleepEnvironment sleepEnv,
  }) {
    // All done!
    if (completedCount >= totalCount) {
      return CoachPrompts.allComplete();
    }

    final hour = now.hour;
    final minute = now.minute;

    // ── Sleep-aware coaching ──────────────────────────────────────
    // Evening: pre-bedtime coaching when within 2h of target bedtime
    if (hour >= 19) {
      final bedtimeMinutes =
          sleepEnv.targetBedtime.hour * 60 + sleepEnv.targetBedtime.minute;
      final nowMinutes = hour * 60 + minute;
      final minutesToBedtime = bedtimeMinutes - nowMinutes;
      if (minutesToBedtime > 0 && minutesToBedtime <= 120) {
        return CoachPrompts.sleepEveningCoaching(minutesToBedtime);
      }
    }

    // Morning: caffeine cutoff reminder (if caffeine reminder enabled)
    if (hour < 12 && sleepEnv.caffeineReminder) {
      final co = sleepEnv.caffeineCutoff;
      final cutoffStr =
          '${co.hour.toString().padLeft(2, '0')}:${co.minute.toString().padLeft(2, '0')}';
      // Show caffeine message ~30% of mornings (variety with other morning prompts)
      if (now.day % 3 == 0) {
        return CoachPrompts.sleepCaffeineMorning(cutoffStr);
      }
    }

    // ── Standard coach logic ─────────────────────────────────────

    if (todayWorkout == null || todayWorkout.isRestDay) {
      return CoachPrompts.restDay();
    }

    if (workoutCompleted) {
      // Workout done but other items pending — nudge
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: true,
        fastingDone: fastingDone,
        coldDone: coldDone,
        meditationDone: meditationDone,
        sleepLogged: sleepLogged,
        hour: hour,
      );
      if (nudge.isNotEmpty) return nudge;
      return CoachPrompts.postWorkout();
    }

    if (hour < 12) {
      return CoachPrompts.morningPending(
        todayWorkout.dayName,
        todayWorkout.exercises.length,
        todayWorkout.estimatedMinutes,
      );
    }

    if (hour < 18) {
      return CoachPrompts.afternoonReminder(todayWorkout.dayName);
    }

    return CoachPrompts.eveningUrgent(todayWorkout.dayName);
  }
}
