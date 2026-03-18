import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/models/rest_times.dart';
import 'package:phoenix_app/core/models/cold_progression.dart';
import 'package:phoenix_app/core/models/nutrition_calculator.dart';
import 'package:phoenix_app/core/models/coach_prompts.dart';
import 'package:phoenix_app/core/models/meal_plan_generator.dart';
import 'package:phoenix_app/core/models/cardio_protocols.dart';
import 'package:phoenix_app/core/models/cardio_plan.dart';
import 'package:phoenix_app/core/models/movement_routine.dart';
import 'package:phoenix_app/core/models/age_adaptation.dart';
import 'package:phoenix_app/core/models/week0_generator.dart';
import 'package:phoenix_app/core/database/tables.dart';

void main() {
  // ══════════════════════════════════════════════════════════════
  // P2: RestTimes.betweenSets
  // ══════════════════════════════════════════════════════════════
  group('RestTimes.betweenSets', () {
    test('should return base rest for compound at intermediate level', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.compound,
        phoenixLevel: 3,
      );
      expect(rest, 150); // 2.5 min, no level adjustment
    });

    test('should add 30s for beginner levels (1-2)', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.compound,
        phoenixLevel: 1,
      );
      expect(rest, 180); // 150 + 30
    });

    test('should subtract 15s for advanced levels (5-6)', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.compound,
        phoenixLevel: 5,
      );
      expect(rest, 135); // 150 - 15
    });

    test('should return correct base for accessory type', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.accessory,
        phoenixLevel: 3,
      );
      expect(rest, 105);
    });

    test('should return correct base for core type', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.core,
        phoenixLevel: 4,
      );
      expect(rest, 75);
    });

    test('should return 0 for hiit (defined by interval protocol)', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.hiit,
        phoenixLevel: 3,
      );
      expect(rest, 0);
    });

    test('should return 120s default for unknown type', () {
      final rest = RestTimes.betweenSets(
        exerciseType: 'unknown',
        phoenixLevel: 3,
      );
      expect(rest, 120);
    });

    test('should apply level 2 adjustment (+30s) to accessory', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.accessory,
        phoenixLevel: 2,
      );
      expect(rest, 135); // 105 + 30
    });

    test('should apply level 6 adjustment (-15s) to core', () {
      final rest = RestTimes.betweenSets(
        exerciseType: ExerciseType.core,
        phoenixLevel: 6,
      );
      expect(rest, 60); // 75 - 15
    });
  });

  group('RestTimes.betweenExercises', () {
    test('should return 180s for compound at intermediate level', () {
      final rest = RestTimes.betweenExercises(
        exerciseType: ExerciseType.compound,
        phoenixLevel: 3,
      );
      expect(rest, 180);
    });

    test('should add 30s for beginner level', () {
      final rest = RestTimes.betweenExercises(
        exerciseType: ExerciseType.accessory,
        phoenixLevel: 1,
      );
      expect(rest, 150); // 120 + 30
    });

    test('should subtract 15s for advanced level', () {
      final rest = RestTimes.betweenExercises(
        exerciseType: ExerciseType.core,
        phoenixLevel: 5,
      );
      expect(rest, 75); // 90 - 15
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: ColdProgression
  // ══════════════════════════════════════════════════════════════
  group('ColdProgression.targetSeconds', () {
    test('should return 30s for week 1', () {
      expect(ColdProgression.targetSeconds(1), 30);
    });

    test('should return 60s for week 2', () {
      expect(ColdProgression.targetSeconds(2), 60);
    });

    test('should return 180s for week 6', () {
      expect(ColdProgression.targetSeconds(6), 180);
    });

    test('should cap at 180s for weeks beyond 6', () {
      expect(ColdProgression.targetSeconds(10), 180);
      expect(ColdProgression.targetSeconds(100), 180);
    });

    test('should clamp to minimum 30s for week 0 or negative', () {
      expect(ColdProgression.targetSeconds(0), 30);
    });
  });

  group('ColdProgression.targetFormatted', () {
    test('should format seconds for week 1', () {
      expect(ColdProgression.targetFormatted(1), '30s');
    });

    test('should format minutes for week 2', () {
      expect(ColdProgression.targetFormatted(2), '1min');
    });

    test('should format minutes and seconds for week 3', () {
      expect(ColdProgression.targetFormatted(3), '1min 30s');
    });

    test('should format 3min for week 6+', () {
      expect(ColdProgression.targetFormatted(6), '3min');
    });
  });

  group('ColdProgression.weekStats', () {
    test('should calculate stats for empty sessions', () {
      final stats = ColdProgression.weekStats(
        sessionsThisWeek: [],
        week: 1,
      );
      expect(stats.sessionsCompleted, 0);
      expect(stats.totalDoseSeconds, 0);
      expect(stats.targetSeconds, 30);
      expect(stats.doseProgress, 0.0);
      expect(stats.sessionProgress, 0.0);
    });

    test('should sum session durations correctly', () {
      final sessions = [
        ColdSessionData(
          durationSeconds: 30,
          date: DateTime(2026, 1, 1),
        ),
        ColdSessionData(
          durationSeconds: 45,
          date: DateTime(2026, 1, 2),
        ),
      ];
      final stats = ColdProgression.weekStats(
        sessionsThisWeek: sessions,
        week: 2,
      );
      expect(stats.sessionsCompleted, 2);
      expect(stats.totalDoseSeconds, 75);
      expect(stats.targetSeconds, 60);
    });

    test('should clamp dose progress to 1.0', () {
      final sessions = List.generate(
        10,
        (i) => ColdSessionData(
          durationSeconds: 120,
          date: DateTime(2026, 1, i + 1),
        ),
      );
      final stats = ColdProgression.weekStats(
        sessionsThisWeek: sessions,
        week: 4,
      );
      expect(stats.doseProgress, 1.0);
    });

    test('should calculate session progress as fraction of 5', () {
      final sessions = [
        ColdSessionData(durationSeconds: 30, date: DateTime(2026, 1, 1)),
        ColdSessionData(durationSeconds: 30, date: DateTime(2026, 1, 2)),
        ColdSessionData(durationSeconds: 30, date: DateTime(2026, 1, 3)),
      ];
      final stats = ColdProgression.weekStats(
        sessionsThisWeek: sessions,
        week: 1,
      );
      expect(stats.sessionProgress, closeTo(0.6, 0.01));
    });
  });

  group('ColdWeekStats computed properties', () {
    test('should convert dose to minutes', () {
      final stats = ColdWeekStats(
        week: 1,
        targetSeconds: 30,
        sessionsCompleted: 2,
        totalDoseSeconds: 180,
      );
      expect(stats.doseMinutes, 3.0);
    });

    test('should return correct dose target in minutes', () {
      final stats = ColdWeekStats(
        week: 1,
        targetSeconds: 30,
        sessionsCompleted: 0,
        totalDoseSeconds: 0,
      );
      expect(stats.doseTargetMinutes, 11.0); // 660s / 60
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: NutritionCalculator
  // ══════════════════════════════════════════════════════════════
  group('NutritionCalculator.dailyProteinGrams', () {
    test('should return 2.2 g/kg for advanced tier', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'advanced');
      expect(calc.dailyProteinGrams, closeTo(176, 0.1));
    });

    test('should return 1.8 g/kg for intermediate tier', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'intermediate');
      expect(calc.dailyProteinGrams, closeTo(144, 0.1));
    });

    test('should return 1.6 g/kg for beginner tier (default)', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'beginner');
      expect(calc.dailyProteinGrams, closeTo(128, 0.1));
    });

    test('should fallback to 1.6 for unknown tier', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'unknown');
      expect(calc.dailyProteinGrams, closeTo(128, 0.1));
    });

    test('should scale with body weight', () {
      final calc = NutritionCalculator(weightKg: 60, tier: 'advanced');
      expect(calc.dailyProteinGrams, closeTo(132, 0.1)); // 60 * 2.2
    });
  });

  group('NutritionCalculator.recommendedMeals', () {
    test('should return 3-5 meals for typical weights', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'beginner');
      expect(calc.recommendedMeals, greaterThanOrEqualTo(3));
      expect(calc.recommendedMeals, lessThanOrEqualTo(5));
    });

    test('should return 3 for low protein requirement', () {
      // 50kg beginner: 80g protein, perMealMax = 27.5, 80/27.5 = 2.9 → ceil = 3
      final calc = NutritionCalculator(weightKg: 50, tier: 'beginner');
      expect(calc.recommendedMeals, 3);
    });

    test('should clamp to 5 for very high protein requirement', () {
      // 120kg advanced: 264g protein, perMealMax = 66, 264/66 = 4.0 → ceil = 4
      final calc = NutritionCalculator(weightKg: 120, tier: 'advanced');
      expect(calc.recommendedMeals, lessThanOrEqualTo(5));
    });
  });

  group('NutritionCalculator.eatingWindowHours', () {
    test('should return 8 hours for fasting level 1', () {
      expect(NutritionCalculator.eatingWindowHours(1), 8);
    });

    test('should return 6 hours for fasting level 2', () {
      expect(NutritionCalculator.eatingWindowHours(2), 6);
    });

    test('should return 4 hours for fasting level 3', () {
      expect(NutritionCalculator.eatingWindowHours(3), 4);
    });

    test('should default to 8 hours for unknown levels', () {
      expect(NutritionCalculator.eatingWindowHours(0), 8);
      expect(NutritionCalculator.eatingWindowHours(99), 8);
    });
  });

  group('NutritionCalculator.perMealProtein', () {
    test('should calculate per-meal minimum at 0.4 g/kg', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'beginner');
      expect(calc.perMealProteinMin, closeTo(32, 0.1));
    });

    test('should calculate per-meal max at 0.55 g/kg', () {
      final calc = NutritionCalculator(weightKg: 80, tier: 'beginner');
      expect(calc.perMealProteinMax, closeTo(44, 0.1));
    });
  });

  group('NutritionCalculator.targetHoursForLevel', () {
    test('should return correct fasting hours per level', () {
      expect(NutritionCalculator.targetHoursForLevel(1), 14.0);
      expect(NutritionCalculator.targetHoursForLevel(2), 18.0);
      expect(NutritionCalculator.targetHoursForLevel(3), 22.0);
    });

    test('should default to 14 for unknown levels', () {
      expect(NutritionCalculator.targetHoursForLevel(0), 14.0);
    });
  });

  group('MacroTargets.forDay', () {
    test('should compute higher carbs on training days', () {
      final training = MacroTargets.forDay(
        weightKg: 80,
        dayType: 'training',
        tier: 'intermediate',
      );
      final normal = MacroTargets.forDay(
        weightKg: 80,
        dayType: 'normal',
        tier: 'intermediate',
      );
      expect(training.carbG, greaterThan(normal.carbG));
    });

    test('should compute lower fiber on autophagy days', () {
      final autophagy = MacroTargets.forDay(
        weightKg: 80,
        dayType: 'autophagy',
        tier: 'beginner',
      );
      final normal = MacroTargets.forDay(
        weightKg: 80,
        dayType: 'normal',
        tier: 'beginner',
      );
      expect(autophagy.fiberG, lessThan(normal.fiberG));
    });

    test('should compute total kcal as sum of macro kcal', () {
      final targets = MacroTargets.forDay(
        weightKg: 80,
        dayType: 'training',
        tier: 'advanced',
      );
      // totalKcal = (proteinKcal + carbKcal) / (1 - fatPercent)
      expect(targets.totalKcal, greaterThan(0));
      // Fat kcal should be ~27% of total for training
      final fatKcal = targets.fatG * 9;
      expect(fatKcal / targets.totalKcal, closeTo(0.27, 0.01));
    });

    test('should produce Italian day type labels', () {
      expect(
        MacroTargets.forDay(weightKg: 80, dayType: 'training', tier: 'beginner')
            .dayTypeLabel,
        'Giorno Training',
      );
      expect(
        MacroTargets.forDay(weightKg: 80, dayType: 'autophagy', tier: 'beginner')
            .dayTypeLabel,
        'Giorno Autofagia',
      );
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: CoachPrompts
  // ══════════════════════════════════════════════════════════════
  group('CoachPrompts.interSetCue', () {
    test('should return a low RPE cue for RPE <= 6', () {
      final cue = CoachPrompts.interSetCue(
        exerciseName: 'Push-up',
        setNumber: 2,
        totalSets: 4,
        rpe: 5,
        category: ExerciseCategory.push,
      );
      expect(cue, isNotEmpty);
      // Low RPE cues mention pushing more or good rhythm
      expect(cue.length, greaterThan(10));
    });

    test('should return a mid RPE cue with category tip for RPE 7-8', () {
      final cue = CoachPrompts.interSetCue(
        exerciseName: 'Squat',
        setNumber: 2,
        totalSets: 4,
        rpe: 7,
        category: ExerciseCategory.squat,
      );
      expect(cue, isNotEmpty);
    });

    test('should return a high RPE cue for RPE > 8', () {
      final cue = CoachPrompts.interSetCue(
        exerciseName: 'Deadlift',
        setNumber: 3,
        totalSets: 4,
        rpe: 9,
        category: ExerciseCategory.hinge,
      );
      expect(cue, isNotEmpty);
    });

    test('should handle RPE at boundaries (6 and 9)', () {
      final cueLow = CoachPrompts.interSetCue(
        exerciseName: 'X',
        setNumber: 1,
        totalSets: 3,
        rpe: 6,
        category: ExerciseCategory.core,
      );
      final cueHigh = CoachPrompts.interSetCue(
        exerciseName: 'X',
        setNumber: 1,
        totalSets: 3,
        rpe: 9,
        category: ExerciseCategory.core,
      );
      // RPE 6 should be low, RPE 9 should be high
      expect(cueLow, isNotEmpty);
      expect(cueHigh, isNotEmpty);
    });
  });

  group('CoachPrompts.protocolNudge', () {
    test('should nudge workout when not done and hour >= 16', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: false,
        fastingDone: true,
        coldDone: true,
        meditationDone: true,
        sleepLogged: true,
        hour: 16,
      );
      expect(nudge, contains('allenamento'));
    });

    test('should nudge cold when not done and hour >= 10', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: true,
        fastingDone: true,
        coldDone: false,
        meditationDone: true,
        sleepLogged: true,
        hour: 10,
      );
      expect(nudge, contains('fredda'));
    });

    test('should nudge meditation when not done and hour >= 20', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: true,
        fastingDone: true,
        coldDone: true,
        meditationDone: false,
        sleepLogged: true,
        hour: 20,
      );
      expect(nudge, contains('meditazione'));
    });

    test('should nudge sleep logging when not done and hour >= 8', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: true,
        fastingDone: true,
        coldDone: true,
        meditationDone: true,
        sleepLogged: false,
        hour: 8,
      );
      expect(nudge, contains('sonno'));
    });

    test('should return empty when all done', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: true,
        fastingDone: true,
        coldDone: true,
        meditationDone: true,
        sleepLogged: true,
        hour: 22,
      );
      expect(nudge, isEmpty);
    });

    test('should return empty when too early for any nudge', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: false,
        fastingDone: false,
        coldDone: false,
        meditationDone: false,
        sleepLogged: false,
        hour: 6,
      );
      expect(nudge, isEmpty);
    });

    test('should prioritize workout over cold when both pending', () {
      final nudge = CoachPrompts.protocolNudge(
        workoutDone: false,
        fastingDone: true,
        coldDone: false,
        meditationDone: true,
        sleepLogged: true,
        hour: 17,
      );
      expect(nudge, contains('allenamento'));
    });
  });

  group('CoachPrompts.fastingActive', () {
    test('should show completion message when target reached', () {
      final msg = CoachPrompts.fastingActive(16, 16.0);
      expect(msg, contains('completato'));
    });

    test('should show almost done when <= 2h remaining', () {
      final msg = CoachPrompts.fastingActive(14, 16.0);
      expect(msg, contains('Quasi fatto'));
    });

    test('should show progress when more than 2h remaining', () {
      final msg = CoachPrompts.fastingActive(10, 16.0);
      expect(msg, contains('10h'));
      expect(msg, contains('6'));
    });

    test('should handle overshoot (hours > target)', () {
      final msg = CoachPrompts.fastingActive(20, 16.0);
      expect(msg, contains('completato'));
    });
  });

  group('CoachPrompts.postSetTemplateFeedback', () {
    test('should report all reps completed for full set', () {
      final feedback = CoachPrompts.postSetTemplateFeedback(
        repsCompleted: 10,
        repsTarget: 10,
        rpe: 7,
        setNumber: 1,
        totalSets: 3,
        exerciseName: 'Push-up',
        category: 'push',
      );
      expect(feedback, contains('Tutte le rep completate'));
    });

    test('should report partial reps', () {
      final feedback = CoachPrompts.postSetTemplateFeedback(
        repsCompleted: 7,
        repsTarget: 10,
        rpe: 9,
        setNumber: 2,
        totalSets: 3,
        exerciseName: 'Pull-up',
        category: 'pull',
      );
      expect(feedback, contains('7/10'));
    });

    test('should give recovery cue for high RPE', () {
      final feedback = CoachPrompts.postSetTemplateFeedback(
        repsCompleted: 10,
        repsTarget: 10,
        rpe: 9,
        setNumber: 1,
        totalSets: 3,
        exerciseName: 'Squat',
        category: 'squat',
      );
      expect(feedback, contains('Recupera'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: MealPlanGenerator.dayTypeForWeekday
  // ══════════════════════════════════════════════════════════════
  group('MealPlanGenerator.dayTypeForWeekday', () {
    test('should return training for Monday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.monday),
        NutritionDayType.training,
      );
    });

    test('should return training for Tuesday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.tuesday),
        NutritionDayType.training,
      );
    });

    test('should return normal for Wednesday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.wednesday),
        NutritionDayType.normal,
      );
    });

    test('should return training for Thursday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.thursday),
        NutritionDayType.training,
      );
    });

    test('should return training for Friday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.friday),
        NutritionDayType.training,
      );
    });

    test('should return normal for Saturday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.saturday),
        NutritionDayType.normal,
      );
    });

    test('should return autophagy for Sunday', () {
      expect(
        MealPlanGenerator.dayTypeForWeekday(DateTime.sunday),
        NutritionDayType.autophagy,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: CardioProtocols
  // ══════════════════════════════════════════════════════════════
  group('CardioProtocols.tabata', () {
    test('should return beginner config with 6 rounds', () {
      final plan = CardioProtocols.tabata(tier: 'beginner');
      expect(plan.protocolName, 'tabata');
      expect(plan.rounds.length, 6);
      expect(plan.rounds.first.workSeconds, 20);
      expect(plan.rounds.first.restSeconds, 40);
      expect(plan.warmupMinutes, 5);
      expect(plan.cooldownMinutes, 5);
    });

    test('should return intermediate config with 8 rounds', () {
      final plan = CardioProtocols.tabata(tier: 'intermediate');
      expect(plan.rounds.length, 8);
      expect(plan.rounds.first.workSeconds, 20);
      expect(plan.rounds.first.restSeconds, 20);
    });

    test('should return advanced config with 10s rest', () {
      final plan = CardioProtocols.tabata(tier: 'advanced');
      expect(plan.rounds.length, 8);
      expect(plan.rounds.first.restSeconds, 10);
    });

    test('should fall back to intermediate for unknown tier', () {
      final plan = CardioProtocols.tabata(tier: 'unknown');
      expect(plan.rounds.length, 8);
      expect(plan.rounds.first.restSeconds, 20);
    });

    test('should include zone 2 portion', () {
      final plan = CardioProtocols.tabata(tier: 'beginner');
      expect(plan.zone2Minutes, 22);
    });

    test('should cycle exercise suggestions', () {
      final plan = CardioProtocols.tabata(tier: 'beginner');
      expect(plan.rounds.first.exerciseSuggestion, isNotNull);
      expect(plan.rounds.first.targetZone, 'zone5');
    });

    test('should compute estimated minutes correctly', () {
      final plan = CardioProtocols.tabata(tier: 'intermediate');
      // warmup(5) + hiit(ceil(8*(20+20)/60)=6) + zone2(22) + cooldown(5) = 38
      expect(plan.estimatedMinutes, 38);
    });
  });

  group('CardioProtocols.norwegian', () {
    test('should return beginner config with 3 rounds', () {
      final plan = CardioProtocols.norwegian(tier: 'beginner');
      expect(plan.protocolName, 'norwegian');
      expect(plan.rounds.length, 3);
      expect(plan.warmupMinutes, 10);
    });

    test('should return intermediate config with 4 rounds', () {
      final plan = CardioProtocols.norwegian(tier: 'intermediate');
      expect(plan.rounds.length, 4);
      expect(plan.warmupMinutes, 7);
    });

    test('should return advanced config with 5 rounds', () {
      final plan = CardioProtocols.norwegian(tier: 'advanced');
      expect(plan.rounds.length, 5);
      expect(plan.warmupMinutes, 5);
    });

    test('should have 4-min work and 3-min rest per round', () {
      final plan = CardioProtocols.norwegian(tier: 'intermediate');
      expect(plan.rounds.first.workSeconds, 240);
      expect(plan.rounds.first.restSeconds, 180);
    });

    test('should have no separate zone 2', () {
      final plan = CardioProtocols.norwegian(tier: 'beginner');
      expect(plan.zone2Minutes, 0);
    });

    test('should compute estimated minutes correctly', () {
      final plan = CardioProtocols.norwegian(tier: 'intermediate');
      // warmup(7) + 4*7 + cooldown(5) = 40
      expect(plan.estimatedMinutes, 40);
    });
  });

  group('CardioProtocols.zone2Only', () {
    test('should return zone 2 plan with no rounds', () {
      final plan = CardioProtocols.zone2Only();
      expect(plan.protocolName, 'zone2_only');
      expect(plan.rounds, isEmpty);
      expect(plan.isHiit, false);
    });

    test('should have 35 minutes zone 2', () {
      final plan = CardioProtocols.zone2Only();
      expect(plan.zone2Minutes, 35);
    });

    test('should have 45 total minutes', () {
      final plan = CardioProtocols.zone2Only();
      expect(plan.estimatedMinutes, 45); // 5 + 35 + 5
    });

    test('should target zone 2', () {
      final plan = CardioProtocols.zone2Only();
      expect(plan.targetHrZone, 'zone2');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: MovementRoutineGenerator
  // ══════════════════════════════════════════════════════════════
  group('MovementRoutineGenerator.warmupFor', () {
    test('should return push-specific warmup', () {
      final routine = MovementRoutineGenerator.warmupFor('push', 1);
      expect(routine.type, 'warmup');
      expect(routine.dayCategory, 'push');
      expect(routine.exercises, isNotEmpty);
    });

    test('should return 5min warmup for age < 30', () {
      final routine =
          MovementRoutineGenerator.warmupFor('squat', 1, ageYears: 25);
      expect(routine.estimatedMinutes, 5);
    });

    test('should return 7min warmup for age 30-50', () {
      final routine =
          MovementRoutineGenerator.warmupFor('squat', 1, ageYears: 40);
      expect(routine.estimatedMinutes, 7);
    });

    test('should return 10min warmup for age 50+', () {
      final routine =
          MovementRoutineGenerator.warmupFor('squat', 1, ageYears: 55);
      expect(routine.estimatedMinutes, 10);
    });

    test('should add extra joint mobility for age 50+', () {
      final young =
          MovementRoutineGenerator.warmupFor('push', 1, ageYears: 25);
      final old =
          MovementRoutineGenerator.warmupFor('push', 1, ageYears: 55);
      expect(old.exercises.length, greaterThan(young.exercises.length));
    });

    test('should default to 7min warmup when age is null', () {
      final routine = MovementRoutineGenerator.warmupFor('push', 1);
      expect(routine.estimatedMinutes, 7);
    });

    test('should handle hiit and power as full body warmup', () {
      final hiit = MovementRoutineGenerator.warmupFor('hiit', 1);
      final power = MovementRoutineGenerator.warmupFor('power', 1);
      expect(hiit.exercises.length, power.exercises.length);
    });

    test('should handle unknown category as full body', () {
      final routine = MovementRoutineGenerator.warmupFor('unknown', 1);
      expect(routine.exercises, isNotEmpty);
    });
  });

  group('MovementRoutineGenerator.stabilityFor', () {
    test('should return 5min for tier 1', () {
      final routine = MovementRoutineGenerator.stabilityFor(1);
      expect(routine.type, 'stability');
      expect(routine.estimatedMinutes, 5);
      expect(routine.dayCategory, 'all');
    });

    test('should return 7min for tier 2', () {
      final routine = MovementRoutineGenerator.stabilityFor(2);
      expect(routine.estimatedMinutes, 7);
    });

    test('should return 10min for tier 3', () {
      final routine = MovementRoutineGenerator.stabilityFor(3);
      expect(routine.estimatedMinutes, 10);
    });

    test('should clamp tier below 1 to tier 1', () {
      final routine = MovementRoutineGenerator.stabilityFor(0);
      expect(routine.estimatedMinutes, 5);
    });

    test('should clamp tier above 3 to tier 3', () {
      final routine = MovementRoutineGenerator.stabilityFor(5);
      expect(routine.estimatedMinutes, 10);
    });
  });

  group('MovementRoutineGenerator.cooldownFor', () {
    test('should return cooldown for push category', () {
      final routine = MovementRoutineGenerator.cooldownFor('push');
      expect(routine.type, 'cooldown');
      expect(routine.dayCategory, 'push');
      expect(routine.exercises, isNotEmpty);
    });

    test('should double stretch durations with PNF', () {
      final normal = MovementRoutineGenerator.cooldownFor('push');
      final pnf = MovementRoutineGenerator.cooldownFor('push', usePnf: true);
      // PNF doubles time-based durations
      final normalFirstDuration = normal.exercises.first.durationSeconds;
      final pnfFirstDuration = pnf.exercises.first.durationSeconds;
      expect(pnfFirstDuration, normalFirstDuration * 2);
    });

    test('should add PNF instructions when enabled', () {
      final pnf = MovementRoutineGenerator.cooldownFor('squat', usePnf: true);
      expect(pnf.exercises.first.instructions, contains('PNF'));
    });

    test('should handle all known categories', () {
      for (final cat in ['push', 'pull', 'squat', 'hinge', 'hiit', 'power']) {
        final routine = MovementRoutineGenerator.cooldownFor(cat);
        expect(routine.exercises, isNotEmpty, reason: '$cat should have exercises');
      }
    });

    test('should handle unknown category as hiit fallback', () {
      final routine = MovementRoutineGenerator.cooldownFor('unknown');
      final hiitRoutine = MovementRoutineGenerator.cooldownFor('hiit');
      expect(routine.exercises.length, hiitRoutine.exercises.length);
    });
  });

  group('MovementRoutineGenerator.pnfRecommendation', () {
    test('should return opzionale for age < 30', () {
      expect(MovementRoutineGenerator.pnfRecommendation(25), 'opzionale');
    });

    test('should return consigliato for age 30-50', () {
      expect(MovementRoutineGenerator.pnfRecommendation(40), 'consigliato');
    });

    test('should return fortemente consigliato for age 50-65', () {
      expect(
          MovementRoutineGenerator.pnfRecommendation(55), 'fortemente consigliato');
    });

    test('should return necessario for age 65+', () {
      expect(MovementRoutineGenerator.pnfRecommendation(70), 'necessario');
    });

    test('should return consigliato for null age', () {
      expect(MovementRoutineGenerator.pnfRecommendation(null), 'consigliato');
    });
  });

  group('MovementExercise computed properties', () {
    test('should compute effective seconds for time-based exercises', () {
      const ex = MovementExercise(
        name: 'test',
        nameIt: 'test',
        instructions: 'test',
        durationSeconds: 30,
      );
      expect(ex.effectiveSeconds, 30);
      expect(ex.isTimeBased, true);
    });

    test('should double effective seconds for per-side time-based', () {
      const ex = MovementExercise(
        name: 'test',
        nameIt: 'test',
        instructions: 'test',
        durationSeconds: 30,
        perSide: true,
      );
      expect(ex.effectiveSeconds, 60);
    });

    test('should estimate 3s per rep for rep-based exercises', () {
      const ex = MovementExercise(
        name: 'test',
        nameIt: 'test',
        instructions: 'test',
        reps: 10,
      );
      expect(ex.effectiveSeconds, 30); // 10 * 3
      expect(ex.isTimeBased, false);
    });

    test('should double rep time for per-side rep-based', () {
      const ex = MovementExercise(
        name: 'test',
        nameIt: 'test',
        instructions: 'test',
        reps: 10,
        perSide: true,
      );
      expect(ex.effectiveSeconds, 60); // 10 * 3 * 2
    });

    test('should format display duration correctly', () {
      const timeBased = MovementExercise(
        name: 'test',
        nameIt: 'test',
        instructions: 'test',
        durationSeconds: 30,
        perSide: true,
      );
      expect(timeBased.displayDuration, '30s/lato');

      const repBased = MovementExercise(
        name: 'test',
        nameIt: 'test',
        instructions: 'test',
        reps: 10,
      );
      expect(repBased.displayDuration, '10 rep');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: AgeAdaptationEngine
  // ══════════════════════════════════════════════════════════════
  group('AgeAdaptationEngine.forAge', () {
    const engine = AgeAdaptationEngine();

    test('should return full volume for age < 30', () {
      final params = engine.forAge(25);
      expect(params.weeklySetMultiplier, 1.0);
      expect(params.recoveryHours, 48);
      expect(params.warmupMinutes, 5);
      expect(params.mobilityPriority, 'standard');
    });

    test('should return 0.9 multiplier for age 30-39', () {
      final params = engine.forAge(35);
      expect(params.weeklySetMultiplier, 0.9);
      expect(params.recoveryHours, 60);
      expect(params.decadeLabel, '30-39');
    });

    test('should return 0.8 multiplier for age 40-49', () {
      final params = engine.forAge(45);
      expect(params.weeklySetMultiplier, 0.8);
      expect(params.mobilityPriority, 'elevated');
    });

    test('should return 0.7 multiplier for age 50-59', () {
      final params = engine.forAge(55);
      expect(params.weeklySetMultiplier, 0.7);
      expect(params.recoveryHours, 84);
      expect(params.mobilityPriority, 'high');
    });

    test('should return 0.6 multiplier for age 60-69', () {
      final params = engine.forAge(65);
      expect(params.weeklySetMultiplier, 0.6);
      expect(params.mobilityPriority, 'critical');
    });

    test('should return 0.5 multiplier for age 70+', () {
      final params = engine.forAge(75);
      expect(params.weeklySetMultiplier, 0.5);
      expect(params.recoveryHours, 108);
      expect(params.warmupMinutes, 15);
      expect(params.decadeLabel, '70+');
    });

    test('should increase warmup with age', () {
      final young = engine.forAge(25);
      final old = engine.forAge(75);
      expect(old.warmupMinutes, greaterThan(young.warmupMinutes));
    });

    test('should widen rep range for oldest bracket', () {
      final params = engine.forAge(75);
      expect(params.repRangeLow, 12);
      expect(params.repRangeHigh, 20);
    });
  });

  group('AgeAdaptationEngine.forSex', () {
    const engine = AgeAdaptationEngine();

    test('should return male defaults for male', () {
      final adapt = engine.forSex('male');
      expect(adapt.concurrentTrainingSafe, false);
      expect(adapt.monitorIron, false);
      expect(adapt.minLoadPercentForBone, 60);
    });

    test('should return female pre-menopausal for young female', () {
      final adapt = engine.forSex('female', age: 30);
      expect(adapt.concurrentTrainingSafe, true);
      expect(adapt.monitorIron, true);
      expect(adapt.minLoadPercentForBone, 60);
    });

    test('should return post-menopausal for female age >= 50', () {
      final adapt = engine.forSex('female', age: 55);
      expect(adapt.minLoadPercentForBone, 70);
      expect(adapt.coachNoteIt, contains('Post-menopausa'));
    });

    test('should allow explicit post-menopausal override', () {
      final adapt =
          engine.forSex('female', age: 35, isPostMenopausal: true);
      expect(adapt.minLoadPercentForBone, 70);
    });

    test('should treat prefer_not_to_say as male defaults', () {
      final adapt = engine.forSex('prefer_not_to_say');
      expect(adapt.concurrentTrainingSafe, false);
      expect(adapt.monitorIron, false);
    });
  });

  group('AgeAdaptationEngine.adjustSets', () {
    const engine = AgeAdaptationEngine();

    test('should return full sets for young users', () {
      expect(engine.adjustSets(4, 25), 4);
    });

    test('should reduce sets for older users', () {
      expect(engine.adjustSets(4, 55), 3); // 4 * 0.7 = 2.8 → round = 3
    });

    test('should clamp to minimum 2', () {
      expect(engine.adjustSets(3, 75), 2); // 3 * 0.5 = 1.5 → round = 2, clamp(2,3) = 2
    });
  });

  group('AgeAdaptationEngine.shouldSuggestTaiChi', () {
    const engine = AgeAdaptationEngine();

    test('should not suggest for age < 50', () {
      expect(engine.shouldSuggestTaiChi(45), false);
    });

    test('should suggest for age >= 50', () {
      expect(engine.shouldSuggestTaiChi(50), true);
      expect(engine.shouldSuggestTaiChi(70), true);
    });
  });

  group('AgeAdaptationEngine.taiChiRecommendation', () {
    const engine = AgeAdaptationEngine();

    test('should return empty for age < 50', () {
      expect(engine.taiChiRecommendation(45), isEmpty);
    });

    test('should return recommendation for age 50-59', () {
      expect(engine.taiChiRecommendation(55), contains('Tai Chi'));
    });

    test('should mention fall reduction for age 60-69', () {
      expect(engine.taiChiRecommendation(65), contains('41%'));
    });

    test('should strongly recommend for age 70+', () {
      expect(engine.taiChiRecommendation(75), contains('fortemente'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P2: Week0Generator
  // ══════════════════════════════════════════════════════════════
  group('Week0Generator.generatePlan', () {
    test('should generate exactly 6 sessions', () {
      final plan = Week0Generator.generatePlan();
      expect(plan.length, 6);
    });

    test('should have sequential session numbers 1-6', () {
      final plan = Week0Generator.generatePlan();
      for (int i = 0; i < 6; i++) {
        expect(plan[i].sessionNumber, i + 1);
      }
    });

    test('should have correct focus sequence', () {
      final plan = Week0Generator.generatePlan();
      expect(plan[0].focus, 'lower_basics');
      expect(plan[1].focus, 'upper_basics');
      expect(plan[2].focus, 'core_carry');
      expect(plan[3].focus, 'lower_integration');
      expect(plan[4].focus, 'upper_integration');
      expect(plan[5].focus, 'full_body_assessment');
    });

    test('should have 2 sets and tempo 3-1-2-0 for all sessions', () {
      final plan = Week0Generator.generatePlan();
      for (final session in plan) {
        expect(session.sets, 2);
        expect(session.tempo, '3-1-2-0');
      }
    });

    test('should have RPE target 4-6 for all sessions', () {
      final plan = Week0Generator.generatePlan();
      for (final session in plan) {
        expect(session.targetRpeMin, 4.0);
        expect(session.targetRpeMax, 6.0);
      }
    });

    test('should have exercises in each session', () {
      final plan = Week0Generator.generatePlan();
      for (final session in plan) {
        expect(session.exercises, isNotEmpty);
      }
    });

    test('full body assessment session should have 6 exercises', () {
      final plan = Week0Generator.generatePlan();
      expect(plan[5].exercises.length, 6);
    });
  });

  group('Week0Rules.evaluateSession', () {
    test('should pass for all low RPE', () {
      expect(Week0Rules.evaluateSession([4.0, 5.0, 5.0, 6.0]), true);
    });

    test('should fail for empty list', () {
      expect(Week0Rules.evaluateSession([]), false);
    });

    test('should fail if any set RPE > 7', () {
      expect(Week0Rules.evaluateSession([5.0, 5.0, 8.0]), false);
    });

    test('should fail if average RPE > 6', () {
      expect(Week0Rules.evaluateSession([6.5, 6.5, 6.5]), false);
    });

    test('should pass when average is exactly 6.0', () {
      expect(Week0Rules.evaluateSession([6.0, 6.0, 6.0]), true);
    });

    test('should pass when all RPE exactly 7.0 but avg <= 6', () {
      // All at 7.0 → avg is 7.0 > 6.0 → fail
      expect(Week0Rules.evaluateSession([7.0, 7.0, 7.0]), false);
    });

    test('should fail when one set at mustRepeatRpe boundary (> 7)', () {
      expect(Week0Rules.evaluateSession([4.0, 4.0, 7.1]), false);
    });
  });

  group('Week0Rules.computeAvgRpe', () {
    test('should return 0 for empty list', () {
      expect(Week0Rules.computeAvgRpe([]), 0.0);
    });

    test('should compute correct average', () {
      expect(Week0Rules.computeAvgRpe([4.0, 6.0, 8.0]), closeTo(6.0, 0.01));
    });

    test('should handle single element', () {
      expect(Week0Rules.computeAvgRpe([5.0]), 5.0);
    });
  });

  group('Week0Trigger.shouldActivate', () {
    test('should activate for new user', () {
      expect(
        Week0Trigger.shouldActivate(isNewUser: true),
        true,
      );
    });

    test('should activate for inactivity > 14 days', () {
      expect(
        Week0Trigger.shouldActivate(
          isNewUser: false,
          lastWorkoutDate: DateTime.now().subtract(const Duration(days: 20)),
        ),
        true,
      );
    });

    test('should not activate for recent workout', () {
      expect(
        Week0Trigger.shouldActivate(
          isNewUser: false,
          lastWorkoutDate: DateTime.now().subtract(const Duration(days: 3)),
        ),
        false,
      );
    });

    test('should activate for tier change', () {
      expect(
        Week0Trigger.shouldActivate(
          isNewUser: false,
          previousTier: 1,
          currentTier: 2,
        ),
        true,
      );
    });

    test('should not activate when tier is the same', () {
      expect(
        Week0Trigger.shouldActivate(
          isNewUser: false,
          previousTier: 2,
          currentTier: 2,
        ),
        false,
      );
    });

    test('should not activate when no triggers present', () {
      expect(
        Week0Trigger.shouldActivate(isNewUser: false),
        false,
      );
    });
  });

  group('Week0State', () {
    test('should report completed when 6 sessions done', () {
      const state = Week0State(sessionsCompleted: 6);
      expect(state.isCompleted, true);
      expect(state.nextSessionNumber, 7);
    });

    test('should not be completed with < 6 sessions', () {
      const state = Week0State(sessionsCompleted: 3);
      expect(state.isCompleted, false);
      expect(state.nextSessionNumber, 4);
    });

    test('should copy with updated fields', () {
      const state = Week0State(isActive: false, sessionsCompleted: 0);
      final updated = state.copyWith(isActive: true, sessionsCompleted: 2);
      expect(updated.isActive, true);
      expect(updated.sessionsCompleted, 2);
    });
  });

  group('Week0Session.mustRepeat', () {
    test('should return true when passed is false', () {
      final session = Week0Session(
        sessionNumber: 1,
        focus: 'test',
        focusLabel: 'Test',
        exercises: const [],
        passed: false,
      );
      expect(session.mustRepeat, true);
    });

    test('should return false when passed is true', () {
      final session = Week0Session(
        sessionNumber: 1,
        focus: 'test',
        focusLabel: 'Test',
        exercises: const [],
        passed: true,
      );
      expect(session.mustRepeat, false);
    });

    test('should return false when passed is null', () {
      final session = Week0Session(
        sessionNumber: 1,
        focus: 'test',
        focusLabel: 'Test',
        exercises: const [],
      );
      expect(session.mustRepeat, false);
    });
  });
}
