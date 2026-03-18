import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/models/phenoage_calculator.dart';
import 'package:phoenix_app/core/models/duration_score.dart';
import 'package:phoenix_app/core/models/biomarker_alerts.dart';
import 'package:phoenix_app/core/models/sleep_score.dart';
import 'package:phoenix_app/core/models/breathing_controller.dart';
import 'package:phoenix_app/core/models/assessment_scoring.dart';

void main() {
  // ══════════════════════════════════════════════════════════════
  // P1: PhenoAgeCalculator.calculate
  // ══════════════════════════════════════════════════════════════
  group('PhenoAgeCalculator.calculate', () {
    // Typical healthy 40-year-old values (mid-range reference)
    const validArgs = {
      'age': 40,
      'albumin': 4.5,
      'creatinine': 1.0,
      'glucose': 90.0,
      'hscrp': 1.0,
      'lymphocytePct': 30.0,
      'mcv': 90.0,
      'rdw': 13.0,
      'alkPhos': 60.0,
      'wbc': 6.0,
    };

    double? calc({
      int? age,
      double? albumin,
      double? creatinine,
      double? glucose,
      double? hscrp,
      double? lymphocytePct,
      double? mcv,
      double? rdw,
      double? alkPhos,
      double? wbc,
    }) {
      return PhenoAgeCalculator.calculate(
        chronologicalAge: age ?? validArgs['age'] as int,
        albumin: albumin ?? validArgs['albumin'] as double,
        creatinine: creatinine ?? validArgs['creatinine'] as double,
        glucose: glucose ?? validArgs['glucose'] as double,
        hscrp: hscrp ?? validArgs['hscrp'] as double,
        lymphocytePct: lymphocytePct ?? validArgs['lymphocytePct'] as double,
        mcv: mcv ?? validArgs['mcv'] as double,
        rdw: rdw ?? validArgs['rdw'] as double,
        alkalinePhosphatase: alkPhos ?? validArgs['alkPhos'] as double,
        wbc: wbc ?? validArgs['wbc'] as double,
      );
    }

    test('should return a plausible PhenoAge for typical healthy values', () {
      final result = calc();
      expect(result, isNotNull);
      expect(result!, greaterThan(20));
      expect(result, lessThan(80));
    });

    test('should return null when any marker is null', () {
      // Test each marker being null by calling calculate directly
      expect(PhenoAgeCalculator.calculate(
        chronologicalAge: 40, albumin: null, creatinine: 1.0, glucose: 90.0,
        hscrp: 1.0, lymphocytePct: 30.0, mcv: 90.0, rdw: 13.0,
        alkalinePhosphatase: 60.0, wbc: 6.0,
      ), isNull);
      expect(PhenoAgeCalculator.calculate(
        chronologicalAge: 40, albumin: 4.5, creatinine: null, glucose: 90.0,
        hscrp: 1.0, lymphocytePct: 30.0, mcv: 90.0, rdw: 13.0,
        alkalinePhosphatase: 60.0, wbc: 6.0,
      ), isNull);
      expect(PhenoAgeCalculator.calculate(
        chronologicalAge: 40, albumin: 4.5, creatinine: 1.0, glucose: null,
        hscrp: 1.0, lymphocytePct: 30.0, mcv: 90.0, rdw: 13.0,
        alkalinePhosphatase: 60.0, wbc: 6.0,
      ), isNull);
    });

    test('should return null for age < 18', () {
      expect(calc(age: 17), isNull);
      expect(calc(age: 0), isNull);
    });

    test('should return null for age > 120', () {
      expect(calc(age: 121), isNull);
    });

    test('should accept age boundaries 18 and 120', () {
      expect(calc(age: 18), isNotNull);
      expect(calc(age: 120), isNotNull);
    });

    test('should return null for zero/negative albumin', () {
      expect(calc(albumin: 0), isNull);
      expect(calc(albumin: -1.0), isNull);
    });

    test('should return null for lymphocytePct out of 0-100', () {
      expect(calc(lymphocytePct: -1), isNull);
      expect(calc(lymphocytePct: 101), isNull);
    });

    test('should return null for mcv out of 50-150', () {
      expect(calc(mcv: 49), isNull);
      expect(calc(mcv: 151), isNull);
    });

    test('should return null for rdw out of 5-30', () {
      expect(calc(rdw: 4.9), isNull);
      expect(calc(rdw: 30.1), isNull);
    });

    test('should produce higher PhenoAge for worse biomarkers', () {
      final healthy = calc(hscrp: 0.5, rdw: 12.0, glucose: 85.0);
      final unhealthy = calc(hscrp: 5.0, rdw: 18.0, glucose: 130.0);
      expect(healthy, isNotNull);
      expect(unhealthy, isNotNull);
      expect(unhealthy!, greaterThan(healthy!));
    });

    test('should produce lower PhenoAge for younger chronological age', () {
      final young = calc(age: 25);
      final old = calc(age: 70);
      expect(young, isNotNull);
      expect(old, isNotNull);
      expect(young!, lessThan(old!));
    });
  });

  group('PhenoAgeCalculator.missingMarkers', () {
    test('should return empty for complete panel', () {
      final panel = {
        'albumin': 4.5,
        'creatinine': 1.0,
        'glucose': 90.0,
        'hscrp': 1.0,
        'lymphocytes_pct': 30.0,
        'mcv': 90.0,
        'rdw': 13.0,
        'alkaline_phosphatase': 60.0,
        'wbc': 6.0,
      };
      expect(PhenoAgeCalculator.missingMarkers(panel), isEmpty);
    });

    test('should return all markers for empty panel', () {
      expect(PhenoAgeCalculator.missingMarkers({}), hasLength(9));
    });

    test('should return only missing markers', () {
      final panel = {'albumin': 4.5, 'creatinine': 1.0};
      final missing = PhenoAgeCalculator.missingMarkers(panel);
      expect(missing, hasLength(7));
      expect(missing, isNot(contains('albumin')));
      expect(missing, isNot(contains('creatinine')));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P1: DurationScoreCalculator.calculate
  // ══════════════════════════════════════════════════════════════
  group('DurationScoreCalculator.calculate', () {
    test('should return null when < 8 previous sessions', () {
      expect(
        DurationScoreCalculator.calculate(
          currentDurationMinutes: 60,
          workoutType: 'strength',
          previousDurations: [60, 60, 60],
        ),
        isNull,
      );
    });

    test('should return green for consistent duration in range', () {
      final prev = List.filled(10, 60.0);
      final result = DurationScoreCalculator.calculate(
        currentDurationMinutes: 60,
        workoutType: 'strength',
        previousDurations: prev,
      );
      expect(result, isNotNull);
      expect(result!.score, 'green');
    });

    test('should return red for far outlier', () {
      final prev = List.filled(10, 60.0);
      final result = DurationScoreCalculator.calculate(
        currentDurationMinutes: 180,
        workoutType: 'strength',
        previousDurations: prev,
      );
      expect(result, isNotNull);
      expect(result!.score, 'red');
    });

    test('should use default range for unknown workout type', () {
      final prev = List.filled(10, 50.0);
      final result = DurationScoreCalculator.calculate(
        currentDurationMinutes: 50,
        workoutType: 'unknown_type',
        previousDurations: prev,
      );
      expect(result, isNotNull);
      // default range is 30-90, and 50 is within range
      expect(result!.rangeMin, 30.0);
      expect(result.rangeMax, 90.0);
    });

    test('should handle all identical durations (SD=0)', () {
      final prev = List.filled(10, 60.0);
      final result = DurationScoreCalculator.calculate(
        currentDurationMinutes: 60,
        workoutType: 'strength',
        previousDurations: prev,
      );
      expect(result, isNotNull);
      expect(result!.standardDeviation, 0.0);
      expect(result.score, 'green');
    });

    test('should return yellow for moderate deviation or near-range', () {
      final prev = List.filled(10, 60.0);
      // Out of range (strength max=75) but near-range (75*1.15=86.25)
      final result = DurationScoreCalculator.calculate(
        currentDurationMinutes: 80,
        workoutType: 'strength',
        previousDurations: prev,
      );
      expect(result, isNotNull);
      expect(result!.score, 'yellow');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P1: BiomarkerAlerts.check
  // ══════════════════════════════════════════════════════════════
  group('BiomarkerAlerts.check', () {
    test('should return empty for normal values', () {
      final current = {
        'testosterone': 500,
        'ferritin': 80,
        'hscrp': 0.5,
        'lymphocytes_pct': 35,
        'cortisol': 15,
        'glucose': 85,
      };
      final alerts = BiomarkerAlerts.check(current, null, 'male');
      expect(alerts, isEmpty);
    });

    test('should detect testosterone drop >20%', () {
      final current = {'testosterone': 350};
      final previous = {'testosterone': 500};
      final alerts = BiomarkerAlerts.check(current, previous, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.severity, AlertSeverity.high);
      expect(alerts.first.title, contains('Testosterone'));
    });

    test('should not alert on small testosterone drop', () {
      final current = {'testosterone': 450};
      final previous = {'testosterone': 500};
      final alerts = BiomarkerAlerts.check(current, previous, 'male');
      expect(alerts.where((a) => a.title.contains('Testosterone')), isEmpty);
    });

    test('should detect low ferritin (male threshold=30)', () {
      final alerts = BiomarkerAlerts.check({'ferritin': 25}, null, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.title, contains('Ferritina'));
    });

    test('should detect low ferritin (female threshold=20)', () {
      final alerts = BiomarkerAlerts.check({'ferritin': 15}, null, 'female');
      expect(alerts, hasLength(1));
      expect(alerts.first.title, contains('Ferritina'));
    });

    test('should not alert ferritin above threshold', () {
      final alerts = BiomarkerAlerts.check({'ferritin': 35}, null, 'male');
      expect(alerts.where((a) => a.title.contains('Ferritina')), isEmpty);
    });

    test('should detect elevated hsCRP > 3.0', () {
      final alerts = BiomarkerAlerts.check({'hscrp': 5.0}, null, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.severity, AlertSeverity.medium);
    });

    test('should detect low lymphocytes < 20%', () {
      final alerts = BiomarkerAlerts.check({'lymphocytes_pct': 15}, null, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.severity, AlertSeverity.high);
    });

    test('should detect elevated cortisol > 23', () {
      final alerts = BiomarkerAlerts.check({'cortisol': 28}, null, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.severity, AlertSeverity.medium);
    });

    test('should detect elevated glucose with graded severity', () {
      // Prediabetic (100-126) = medium
      var alerts = BiomarkerAlerts.check({'glucose': 110}, null, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.severity, AlertSeverity.medium);

      // Diabetic (>126) = high
      alerts = BiomarkerAlerts.check({'glucose': 130}, null, 'male');
      expect(alerts, hasLength(1));
      expect(alerts.first.severity, AlertSeverity.high);
    });

    test('should return empty for empty current panel', () {
      final alerts = BiomarkerAlerts.check({}, null, 'male');
      expect(alerts, isEmpty);
    });

    test('should handle multiple alerts simultaneously', () {
      final current = {
        'ferritin': 10,
        'hscrp': 5.0,
        'lymphocytes_pct': 15,
        'cortisol': 30,
        'glucose': 140,
      };
      final alerts = BiomarkerAlerts.check(current, null, 'male');
      expect(alerts.length, greaterThanOrEqualTo(5));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P1: SleepScore
  // ══════════════════════════════════════════════════════════════
  group('SleepScore.sleepDuration', () {
    test('should calculate same-day duration', () {
      final bed = DateTime(2026, 1, 1, 22, 0);
      final wake = DateTime(2026, 1, 2, 6, 0);
      expect(SleepScore.sleepDuration(bed, wake), const Duration(hours: 8));
    });

    test('should handle overnight sleep (negative diff)', () {
      // bedtime 23:00, wake 07:00 same day values → negative diff
      final bed = DateTime(2026, 1, 1, 23, 0);
      final wake = DateTime(2026, 1, 1, 7, 0); // same day = negative
      final dur = SleepScore.sleepDuration(bed, wake);
      expect(dur, const Duration(hours: 8)); // should add 24h
    });

    test('should handle same time (zero duration)', () {
      final t = DateTime(2026, 1, 1, 22, 0);
      expect(SleepScore.sleepDuration(t, t), Duration.zero);
    });
  });

  group('SleepScore.regularity', () {
    SleepEntry makeEntry(int hour, int minute) {
      return SleepEntry(
        date: DateTime(2026, 1, 1),
        bedtime: DateTime(2026, 1, 1, hour, minute),
        wakeTime: DateTime(2026, 1, 2, 7, 0),
      );
    }

    test('should return unknown for < 3 entries', () {
      final result = SleepScore.regularity([makeEntry(22, 0), makeEntry(22, 30)]);
      expect(result.level, RegularityLevel.unknown);
    });

    test('should return high for consistent bedtimes (SD <= 30)', () {
      final entries = [
        makeEntry(22, 0),
        makeEntry(22, 15),
        makeEntry(22, 30),
        makeEntry(22, 10),
      ];
      final result = SleepScore.regularity(entries);
      expect(result.level, RegularityLevel.high);
    });

    test('should return low for highly variable bedtimes (SD > 60)', () {
      final entries = [
        makeEntry(20, 0),
        makeEntry(23, 0),
        SleepEntry(
          date: DateTime(2026, 1, 1),
          bedtime: DateTime(2026, 1, 2, 2, 0), // 2 AM
          wakeTime: DateTime(2026, 1, 2, 10, 0),
        ),
        makeEntry(21, 0),
      ];
      final result = SleepScore.regularity(entries);
      expect(result.level, RegularityLevel.low);
    });
  });

  group('SleepScore.averageDuration', () {
    test('should return zero for empty list', () {
      expect(SleepScore.averageDuration([]), Duration.zero);
    });

    test('should calculate correct average', () {
      final entries = [
        SleepEntry(
          date: DateTime(2026, 1, 1),
          bedtime: DateTime(2026, 1, 1, 22, 0),
          wakeTime: DateTime(2026, 1, 2, 6, 0), // 8h
        ),
        SleepEntry(
          date: DateTime(2026, 1, 2),
          bedtime: DateTime(2026, 1, 2, 23, 0),
          wakeTime: DateTime(2026, 1, 3, 7, 0), // 8h
        ),
      ];
      final avg = SleepScore.averageDuration(entries);
      expect(avg.inHours, 8);
    });
  });

  group('SleepScore.daysOnTarget', () {
    test('should return 0 for empty list', () {
      expect(SleepScore.daysOnTarget([]), 0);
    });

    test('should count days with >= 7h sleep', () {
      final entries = [
        SleepEntry(
          date: DateTime(2026, 1, 1),
          bedtime: DateTime(2026, 1, 1, 22, 0),
          wakeTime: DateTime(2026, 1, 2, 6, 0), // 8h - on target
        ),
        SleepEntry(
          date: DateTime(2026, 1, 2),
          bedtime: DateTime(2026, 1, 2, 23, 0),
          wakeTime: DateTime(2026, 1, 3, 4, 0), // 5h - off target
        ),
      ];
      expect(SleepScore.daysOnTarget(entries), 1);
    });
  });

  group('SleepScore.fromNotesJson', () {
    test('should parse valid JSON', () {
      const json = '{"bedtime":"22:30","wakeTime":"06:45","quality":4,"notes":"good"}';
      final entry = SleepScore.fromNotesJson(json, DateTime(2026, 1, 15));
      expect(entry, isNotNull);
      expect(entry!.bedtime.hour, 22);
      expect(entry.bedtime.minute, 30);
      expect(entry.wakeTime.hour, 6);
      expect(entry.wakeTime.minute, 45);
      expect(entry.quality, 4);
      expect(entry.notes, 'good');
    });

    test('should return null for empty string', () {
      expect(SleepScore.fromNotesJson('', DateTime(2026, 1, 1)), isNull);
    });

    test('should return null for invalid JSON', () {
      expect(SleepScore.fromNotesJson('not json', DateTime(2026, 1, 1)), isNull);
    });

    test('should return null for missing fields', () {
      expect(SleepScore.fromNotesJson('{"bedtime":"22:00"}', DateTime(2026, 1, 1)), isNull);
    });

    test('should return null for invalid time format', () {
      expect(SleepScore.fromNotesJson('{"bedtime":"25:00","wakeTime":"06:00"}', DateTime(2026, 1, 1)), isNull);
    });

    test('should default quality to 3 and notes to empty', () {
      const json = '{"bedtime":"22:00","wakeTime":"06:00"}';
      final entry = SleepScore.fromNotesJson(json, DateTime(2026, 1, 1));
      expect(entry, isNotNull);
      expect(entry!.quality, 3);
      expect(entry.notes, '');
    });
  });

  group('SleepScore.toNotesJson roundtrip', () {
    test('should roundtrip through toNotesJson and fromNotesJson', () {
      final original = SleepEntry(
        date: DateTime(2026, 3, 10),
        bedtime: DateTime(2026, 3, 10, 23, 15),
        wakeTime: DateTime(2026, 3, 11, 7, 0),
        quality: 5,
        notes: 'slept great',
      );
      final json = SleepScore.toNotesJson(original);
      final parsed = SleepScore.fromNotesJson(json, DateTime(2026, 3, 10));
      expect(parsed, isNotNull);
      expect(parsed!.bedtime.hour, 23);
      expect(parsed.bedtime.minute, 15);
      expect(parsed.wakeTime.hour, 7);
      expect(parsed.wakeTime.minute, 0);
      expect(parsed.quality, 5);
      expect(parsed.notes, 'slept great');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P1: BreathingState.tick + progress
  // ══════════════════════════════════════════════════════════════
  group('BreathingState.tick', () {
    test('should increment secondsInPhase', () {
      const state = BreathingState();
      final next = state.tick(BreathingConfig.box);
      expect(next.secondsInPhase, 1);
      expect(next.phase, BreathingPhase.inhale);
      expect(next.totalSecondsElapsed, 1);
    });

    test('should transition to next phase when duration reached', () {
      // Box breathing: 4s per phase. At second 3, tick to 4 → next phase
      const state = BreathingState(
        phase: BreathingPhase.inhale,
        secondsInPhase: 3,
      );
      final next = state.tick(BreathingConfig.box);
      expect(next.phase, BreathingPhase.holdIn);
      expect(next.secondsInPhase, 0);
    });

    test('should wrap from last phase to inhale and increment cycle', () {
      const state = BreathingState(
        phase: BreathingPhase.holdOut,
        secondsInPhase: 3,
        cyclesCompleted: 0,
      );
      final next = state.tick(BreathingConfig.box);
      expect(next.phase, BreathingPhase.inhale);
      expect(next.cyclesCompleted, 1);
    });

    test('should skip 0-duration phases (relaxation preset)', () {
      // Relaxation: 4-0-6-0 → active phases: [inhale, exhale]
      const state = BreathingState(
        phase: BreathingPhase.inhale,
        secondsInPhase: 3, // at 3, tick → next
      );
      final next = state.tick(BreathingConfig.relaxation);
      // Should skip holdIn (0s) and go to exhale
      expect(next.phase, BreathingPhase.exhale);
      expect(next.secondsInPhase, 0);
    });

    test('should complete full cycle with box breathing', () {
      var state = const BreathingState();
      // Run through 16 ticks (4 phases x 4 seconds)
      for (int i = 0; i < 16; i++) {
        state = state.tick(BreathingConfig.box);
      }
      expect(state.phase, BreathingPhase.inhale);
      expect(state.cyclesCompleted, 1);
      expect(state.totalSecondsElapsed, 16);
    });
  });

  group('BreathingState.progress', () {
    test('should return 0 at start of phase', () {
      const state = BreathingState(secondsInPhase: 0);
      expect(state.progress(BreathingConfig.box), 0.0);
    });

    test('should return 0.5 at midpoint', () {
      const state = BreathingState(secondsInPhase: 2);
      expect(state.progress(BreathingConfig.box), 0.5);
    });

    test('should return 1.0 for 0-duration phase', () {
      // holdIn has 0 duration in relaxation
      const state = BreathingState(phase: BreathingPhase.holdIn, secondsInPhase: 0);
      expect(state.progress(BreathingConfig.relaxation), 1.0);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // P1: AssessmentScoring
  // ══════════════════════════════════════════════════════════════
  group('AssessmentScoring.scorePushups', () {
    test('should rate excellent for high reps (young male)', () {
      final score = AssessmentScoring.scorePushups(55, sex: 'male', age: 25);
      expect(score.rating, TestRating.excellent);
    });

    test('should rate poor for low reps (young male)', () {
      final score = AssessmentScoring.scorePushups(10, sex: 'male', age: 25);
      expect(score.rating, TestRating.poor);
    });

    test('should use age-adjusted thresholds', () {
      // Male < 30: poor=15, belowAverage=20 → 12 reps = poor
      // Male >= 40: poor=10, belowAverage=15 → 12 reps = poor (>= 10 but < 15)
      // At 16 reps: Male>=40 gets belowAverage, Male<30 stays poor
      final young = AssessmentScoring.scorePushups(16, sex: 'male', age: 25);
      final old = AssessmentScoring.scorePushups(16, sex: 'male', age: 45);
      expect(young.rating, TestRating.poor); // 16 >= 15 → poor (highest matched)
      expect(old.rating, TestRating.belowAverage); // 16 >= 15 → belowAverage
    });

    test('should use sex-adjusted thresholds', () {
      final male = AssessmentScoring.scorePushups(22, sex: 'male', age: 25);
      final female = AssessmentScoring.scorePushups(22, sex: 'female', age: 25);
      expect(male.rating, TestRating.belowAverage);
      expect(female.rating, TestRating.average);
    });

    test('should handle 0 reps', () {
      final score = AssessmentScoring.scorePushups(0, sex: 'male', age: 25);
      expect(score.rating, TestRating.poor);
    });
  });

  group('AssessmentScoring.scoreWallSit', () {
    test('should rate based on Eurofit thresholds', () {
      expect(AssessmentScoring.scoreWallSit(20).rating, TestRating.poor);
      expect(AssessmentScoring.scoreWallSit(50).rating, TestRating.belowAverage);
      expect(AssessmentScoring.scoreWallSit(70).rating, TestRating.average);
      expect(AssessmentScoring.scoreWallSit(100).rating, TestRating.good);
      expect(AssessmentScoring.scoreWallSit(150).rating, TestRating.excellent);
    });
  });

  group('AssessmentScoring.scorePlank', () {
    test('should rate based on McGill 2015 thresholds', () {
      expect(AssessmentScoring.scorePlank(20).rating, TestRating.poor);
      expect(AssessmentScoring.scorePlank(60).rating, TestRating.belowAverage);
      expect(AssessmentScoring.scorePlank(90).rating, TestRating.average);
      expect(AssessmentScoring.scorePlank(120).rating, TestRating.good);
      expect(AssessmentScoring.scorePlank(200).rating, TestRating.excellent);
    });
  });

  group('AssessmentScoring.scoreSitAndReach', () {
    test('should handle negative values (valid in sit-and-reach)', () {
      final score = AssessmentScoring.scoreSitAndReach(-10.0, sex: 'male');
      expect(score.rating, TestRating.poor);
    });

    test('should use sex-adjusted thresholds', () {
      // Male: average threshold = 10cm, Female: average threshold = 15cm
      final male = AssessmentScoring.scoreSitAndReach(12.0, sex: 'male');
      final female = AssessmentScoring.scoreSitAndReach(12.0, sex: 'female');
      expect(male.rating, TestRating.average);
      expect(female.rating, TestRating.belowAverage);
    });
  });

  group('AssessmentScoring.scoreCooper', () {
    test('should calculate VO2max correctly', () {
      // VO2max = (2400 - 504.9) / 44.73 = 42.35
      final result = AssessmentScoring.scoreCooper(2400, sex: 'male', age: 25);
      expect(result.vo2max, closeTo(42.35, 0.1));
      expect(result.score.rating, TestRating.average);
    });

    test('should handle very short distance (low VO2max)', () {
      final result = AssessmentScoring.scoreCooper(800, sex: 'male', age: 25);
      expect(result.vo2max, lessThan(10));
      expect(result.score.rating, TestRating.poor);
    });
  });

  group('AssessmentScoring.compare', () {
    test('should compute deltas for matching fields', () {
      final current = {'pushupMaxReps': 30, 'plankHoldSeconds': 120};
      final previous = {'pushupMaxReps': 25, 'plankHoldSeconds': 90};
      final deltas = AssessmentScoring.compare(current, previous);
      expect(deltas, hasLength(2));
      expect(deltas[0].delta, 5.0);
      expect(deltas[0].improved, true);
      expect(deltas[1].delta, 30.0);
    });

    test('should skip fields missing in either map', () {
      final current = {'pushupMaxReps': 30};
      final previous = {'plankHoldSeconds': 90};
      final deltas = AssessmentScoring.compare(current, previous);
      expect(deltas, isEmpty);
    });

    test('should handle empty maps', () {
      expect(AssessmentScoring.compare({}, {}), isEmpty);
    });

    test('should detect regression (decreased values)', () {
      final current = {'pushupMaxReps': 20};
      final previous = {'pushupMaxReps': 30};
      final deltas = AssessmentScoring.compare(current, previous);
      expect(deltas.first.delta, -10.0);
      expect(deltas.first.improved, false);
    });
  });

  group('AssessmentScoring.generateScoresJson', () {
    test('should generate valid JSON with all scores', () {
      final json = AssessmentScoring.generateScoresJson(
        pushupReps: 30,
        wallSitSeconds: 90,
        plankSeconds: 120,
        sitAndReachCm: 15.0,
        cooperDistanceM: 2400,
        sex: 'male',
        age: 30,
      );
      expect(json, contains('"pushup"'));
      expect(json, contains('"wall_sit"'));
      expect(json, contains('"plank"'));
      expect(json, contains('"sit_and_reach"'));
      expect(json, contains('"cooper"'));
    });

    test('should handle all nulls', () {
      final json = AssessmentScoring.generateScoresJson(sex: 'male', age: 30);
      expect(json, '{}');
    });
  });
}
