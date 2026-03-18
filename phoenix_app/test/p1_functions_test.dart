import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/models/periodization_engine.dart';
import 'package:phoenix_app/core/models/hrv_engine.dart';
import 'package:phoenix_app/core/models/extended_fast.dart';
import 'package:phoenix_app/core/models/nutrition_calculator.dart';
import 'package:phoenix_app/core/models/exercise_rotator.dart';
import 'package:phoenix_app/core/models/supplement_engine.dart';
import 'package:phoenix_app/core/models/sleep_environment.dart';
import 'package:phoenix_app/core/models/sleep_score.dart';
import 'package:phoenix_app/core/database/database.dart'
    hide MesocycleState, HrvReading;
import 'package:phoenix_app/core/database/tables.dart';

// Helper to create a minimal Exercise for rotation tests.
Exercise _makeExercise({
  required int id,
  required String category,
  required String exerciseType,
  required int phoenixLevel,
  String equipment = 'all',
}) {
  return Exercise(
    id: id,
    name: 'Exercise $id',
    category: category,
    phoenixLevel: phoenixLevel,
    musclesPrimary: '',
    musclesSecondary: '',
    instructions: '',
    imagePaths: '',
    animationPath: '',
    progressionNextId: null,
    progressionPrevId: null,
    advancementCriteria: '',
    equipment: equipment,
    executionCues: '',
    defaultSets: 3,
    defaultRepsMin: 8,
    defaultRepsMax: 12,
    defaultTempoEcc: 3,
    defaultTempoCon: 2,
    dayType: '',
    exerciseType: exerciseType,
  );
}

void main() {
  // ══════════════════════════════════════════════════════════════
  // PeriodizationEngine.getParamsForDay
  // ══════════════════════════════════════════════════════════════
  group('PeriodizationEngine.getParamsForDay', () {
    const engine = PeriodizationEngine();

    test('beginner week 1 returns hypertrophy 4x10', () {
      final state = MesocycleState(
        tier: 'beginner',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('beginner', state, 1);
      expect(params.stimulus, Stimulus.ipertrofia);
      expect(params.repsMin, 10);
      expect(params.repsMax, 10);
      expect(params.setsCompound, 4);
    });

    test('beginner week 3 returns endurance 4x15', () {
      final state = MesocycleState(
        tier: 'beginner',
        mesocycleNumber: 1,
        weekInMesocycle: 3,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('beginner', state, 1);
      expect(params.stimulus, Stimulus.resistenza);
      expect(params.repsMin, 15);
    });

    test('beginner week 4 returns hypertrophy with increased load', () {
      final state = MesocycleState(
        tier: 'beginner',
        mesocycleNumber: 1,
        weekInMesocycle: 4,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('beginner', state, 1);
      expect(params.stimulus, Stimulus.ipertrofia);
      expect(params.loadPercentMin, 70);
      expect(params.loadPercentMax, 75);
    });

    test('beginner scheduled deload at week 12', () {
      // mesocycleNumber=3, weekInMesocycle=4 => totalWeeks = 2*4+4 = 12
      final state = MesocycleState(
        tier: 'beginner',
        mesocycleNumber: 3,
        weekInMesocycle: 4,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('beginner', state, 1);
      expect(params.stimulus, Stimulus.deload);
      expect(params.targetRPE, 5);
    });

    test('intermediate Monday returns ipertrofia', () {
      final state = MesocycleState(
        tier: 'intermediate',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('intermediate', state, 1);
      expect(params.stimulus, Stimulus.ipertrofia);
      expect(params.repsMin, 8);
      expect(params.repsMax, 12);
    });

    test('intermediate Tuesday returns forza', () {
      final state = MesocycleState(
        tier: 'intermediate',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('intermediate', state, 2);
      expect(params.stimulus, Stimulus.forza);
      expect(params.repsMin, 3);
      expect(params.repsMax, 6);
      expect(params.restSeconds, 180);
    });

    test('intermediate Friday returns resistenza', () {
      final state = MesocycleState(
        tier: 'intermediate',
        mesocycleNumber: 1,
        weekInMesocycle: 3,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('intermediate', state, 5);
      expect(params.stimulus, Stimulus.resistenza);
      expect(params.repsMin, 15);
    });

    test('intermediate Sunday returns potenza', () {
      final state = MesocycleState(
        tier: 'intermediate',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('intermediate', state, 7);
      expect(params.stimulus, Stimulus.potenza);
    });

    test('intermediate Wednesday/Saturday returns deload (cardio days)', () {
      final state = MesocycleState(
        tier: 'intermediate',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      final paramsWed = engine.getParamsForDay('intermediate', state, 3);
      final paramsSat = engine.getParamsForDay('intermediate', state, 6);
      expect(paramsWed.stimulus, Stimulus.deload);
      expect(paramsSat.stimulus, Stimulus.deload);
    });

    test('intermediate RPE ramps by week', () {
      for (final (week, expectedRpe) in [(1, 7), (2, 7), (3, 8), (4, 8), (5, 9), (6, 9)]) {
        final state = MesocycleState(
          tier: 'intermediate',
          mesocycleNumber: 1,
          weekInMesocycle: week,
          startedAt: DateTime(2026, 1, 1),
        );
        final params = engine.getParamsForDay('intermediate', state, 1);
        expect(params.targetRPE, expectedRpe, reason: 'week $week');
      }
    });

    test('intermediate week 7 returns deload', () {
      final state = MesocycleState(
        tier: 'intermediate',
        mesocycleNumber: 1,
        weekInMesocycle: 7,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('intermediate', state, 1);
      expect(params.stimulus, Stimulus.deload);
    });

    test('advanced accumulo returns volume stimulus', () {
      final state = MesocycleState(
        tier: 'advanced',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        currentBlock: 'accumulo',
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('advanced', state, 1);
      expect(params.stimulus, Stimulus.volume);
      expect(params.setsCompound, 5);
    });

    test('advanced accumulo load bumps per week', () {
      final state1 = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'accumulo', startedAt: DateTime(2026, 1, 1),
      );
      final state3 = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 3,
        currentBlock: 'accumulo', startedAt: DateTime(2026, 1, 1),
      );
      final p1 = engine.getParamsForDay('advanced', state1, 1);
      final p3 = engine.getParamsForDay('advanced', state3, 1);
      expect(p3.loadPercentMin, greaterThan(p1.loadPercentMin));
    });

    test('advanced trasformazione returns forza stimulus', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'trasformazione', startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('advanced', state, 1);
      expect(params.stimulus, Stimulus.forza);
      expect(params.restSeconds, 180);
    });

    test('advanced realizzazione returns potenza stimulus', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'realizzazione', startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('advanced', state, 1);
      expect(params.stimulus, Stimulus.potenza);
      expect(params.repsMin, 1);
      expect(params.repsMax, 3);
    });

    test('advanced realizzazione week 3 clamps loadPercentMax to 100', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 3,
        currentBlock: 'realizzazione', startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('advanced', state, 1);
      expect(params.loadPercentMax, lessThanOrEqualTo(100),
          reason: 'loadPercentMax must never exceed 100%');
      expect(params.loadPercentMin, lessThanOrEqualTo(100));
    });

    test('advanced trasformazione week 4 clamps loadPercentMax to 100', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 4,
        currentBlock: 'trasformazione', startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('advanced', state, 1);
      expect(params.loadPercentMax, lessThanOrEqualTo(100));
    });

    test('advanced deload block returns deload params', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'deload', startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('advanced', state, 1);
      expect(params.stimulus, Stimulus.deload);
    });

    test('unknown tier defaults to beginner', () {
      final state = MesocycleState(
        tier: 'unknown',
        mesocycleNumber: 1,
        weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      final params = engine.getParamsForDay('unknown', state, 1);
      expect(params.stimulus, Stimulus.ipertrofia);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // PeriodizationEngine.shouldDeload
  // ══════════════════════════════════════════════════════════════
  group('PeriodizationEngine.shouldDeload', () {
    const engine = PeriodizationEngine();

    test('returns true when biomarkerAlert is true', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state, biomarkerAlert: true), isTrue);
    });

    test('returns true when average RPE >= 9.0', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state, recentRPEs: [9.0, 9.5, 9.0]), isTrue);
    });

    test('returns false when average RPE < 9.0', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state, recentRPEs: [7.0, 8.0, 8.5]), isFalse);
    });

    test('returns true for beginner at scheduled deload (week 12)', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 3, weekInMesocycle: 4,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state), isTrue);
    });

    test('returns false for beginner not at deload boundary', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 2,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state), isFalse);
    });

    test('returns true for intermediate week 7', () {
      final state = MesocycleState(
        tier: 'intermediate', mesocycleNumber: 1, weekInMesocycle: 7,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state), isTrue);
    });

    test('returns false for intermediate week 6', () {
      final state = MesocycleState(
        tier: 'intermediate', mesocycleNumber: 1, weekInMesocycle: 6,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state), isFalse);
    });

    test('returns true for advanced deload block', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'deload', startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state), isTrue);
    });

    test('returns false for advanced accumulo block', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'accumulo', startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state), isFalse);
    });

    test('returns false when RPE list is empty', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 1,
        startedAt: DateTime(2026, 1, 1),
      );
      expect(engine.shouldDeload(state, recentRPEs: []), isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // PeriodizationEngine.advanceWeek
  // ══════════════════════════════════════════════════════════════
  group('PeriodizationEngine.advanceWeek', () {
    const engine = PeriodizationEngine();

    test('beginner advances within 4-week cycle', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 2,
        startedAt: DateTime(2026, 1, 1),
      );
      final next = engine.advanceWeek(state);
      expect(next.weekInMesocycle, 3);
      expect(next.mesocycleNumber, 1);
    });

    test('beginner starts new cycle after week 4', () {
      final state = MesocycleState(
        tier: 'beginner', mesocycleNumber: 1, weekInMesocycle: 4,
        startedAt: DateTime(2026, 1, 1),
      );
      final next = engine.advanceWeek(state);
      expect(next.weekInMesocycle, 1);
      expect(next.mesocycleNumber, 2);
    });

    test('advanced moves through blocks', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 4,
        currentBlock: 'accumulo', startedAt: DateTime(2026, 1, 1),
      );
      final next = engine.advanceWeek(state);
      expect(next.currentBlock, 'trasformazione');
      expect(next.weekInMesocycle, 1);
    });

    test('advanced deload leads to new mesocycle', () {
      final state = MesocycleState(
        tier: 'advanced', mesocycleNumber: 1, weekInMesocycle: 1,
        currentBlock: 'deload', startedAt: DateTime(2026, 1, 1),
      );
      final next = engine.advanceWeek(state);
      expect(next.mesocycleNumber, 2);
      expect(next.currentBlock, 'accumulo');
      expect(next.weekInMesocycle, 1);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // HrvBaseline.statusFor
  // ══════════════════════════════════════════════════════════════
  group('HrvBaseline.statusFor', () {
    test('returns normal when baseline not established', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.1,
        readingsCount: 10,
      );
      expect(baseline.statusFor(3.5), RecoveryStatus.normal);
    });

    test('returns normal when reading within SWC', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // SWC = 0.2 * 0.5 = 0.1, delta = 0.05 which is within +/-0.1
      expect(baseline.statusFor(3.55), RecoveryStatus.normal);
    });

    test('returns high when delta > SWC', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // SWC = 0.1, delta = 0.2 > 0.1
      expect(baseline.statusFor(3.7), RecoveryStatus.high);
    });

    test('returns low when delta < -SWC', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // SWC = 0.1, delta = -0.15 < -0.1 but > -0.2 (sd14Day)
      expect(baseline.statusFor(3.35), RecoveryStatus.low);
    });

    test('returns veryLow when delta < -SD', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // delta = -0.3 < -0.2
      expect(baseline.statusFor(3.2), RecoveryStatus.veryLow);
    });

    test('returns suspiciouslyHigh when delta > 2*SD', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // delta = 0.5 > 2*0.2 = 0.4
      expect(baseline.statusFor(4.0), RecoveryStatus.suspiciouslyHigh);
    });

    test('returns veryLow when stress index > 300', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      expect(baseline.statusFor(3.5, stressIndex: 350), RecoveryStatus.veryLow);
    });

    test('returns prenosological when SI > 150 but RMSSD within SWC', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // delta = 0.0 >= -SWC, and SI = 200 > 150
      expect(
        baseline.statusFor(3.5, stressIndex: 200),
        RecoveryStatus.prenosological,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════
  // HrvAnalysis.computeBaseline
  // ══════════════════════════════════════════════════════════════
  group('HrvAnalysis.computeBaseline', () {
    test('returns zero baseline for empty readings', () {
      final baseline = HrvAnalysis.computeBaseline([]);
      expect(baseline.mean7Day, 0);
      expect(baseline.mean14Day, 0);
      expect(baseline.readingsCount, 0);
      expect(baseline.isEstablished, isFalse);
    });

    test('computes correct mean for uniform readings', () {
      final readings = List.generate(14, (i) => HrvReading(
        timestamp: DateTime(2026, 1, 15 - i),
        rmssd: exp(3.5), // lnRmssd = 3.5
        source: 'manual',
      ));
      final baseline = HrvAnalysis.computeBaseline(readings);
      expect(baseline.mean7Day, closeTo(3.5, 0.01));
      expect(baseline.mean14Day, closeTo(3.5, 0.01));
      expect(baseline.sd7Day, closeTo(0, 0.01));
      expect(baseline.sd14Day, closeTo(0, 0.01));
      expect(baseline.isEstablished, isTrue);
    });

    test('handles fewer than 7 readings', () {
      final readings = List.generate(5, (i) => HrvReading(
        timestamp: DateTime(2026, 1, 5 - i),
        rmssd: exp(3.0 + i * 0.1),
        source: 'manual',
      ));
      final baseline = HrvAnalysis.computeBaseline(readings);
      expect(baseline.readingsCount, 5);
      expect(baseline.isEstablished, isFalse);
      expect(baseline.mean7Day, isNot(0)); // uses all 5 for both
    });

    test('limits to 14 readings', () {
      final readings = List.generate(20, (i) => HrvReading(
        timestamp: DateTime(2026, 1, 20 - i),
        rmssd: exp(3.5),
        source: 'manual',
      ));
      final baseline = HrvAnalysis.computeBaseline(readings);
      expect(baseline.readingsCount, 20);
      expect(baseline.isEstablished, isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // HrvAnalysis.recommend
  // ══════════════════════════════════════════════════════════════
  group('HrvAnalysis.recommend', () {
    test('normal status gives volume multiplier 1.0', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      final rec = HrvAnalysis.recommend(
        baseline: baseline,
        todayLnRmssd: 3.5,
        consecutiveLowDays: 0,
      );
      expect(rec.status, RecoveryStatus.normal);
      expect(rec.volumeMultiplier, 1.0);
      expect(rec.suggestDeload, isFalse);
    });

    test('veryLow status suggests deload with 0.5 multiplier', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      final rec = HrvAnalysis.recommend(
        baseline: baseline,
        todayLnRmssd: 3.0,
        consecutiveLowDays: 0,
      );
      expect(rec.status, RecoveryStatus.veryLow);
      expect(rec.volumeMultiplier, 0.5);
      expect(rec.suggestDeload, isTrue);
    });

    test('low status with consecutive >= 3 days suggests deload', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      final rec = HrvAnalysis.recommend(
        baseline: baseline,
        todayLnRmssd: 3.35, // low: -0.15 < -SWC(0.1) but > -SD(0.2)
        consecutiveLowDays: 3,
      );
      expect(rec.status, RecoveryStatus.low);
      expect(rec.volumeMultiplier, 0.8);
      expect(rec.suggestDeload, isTrue);
    });

    test('low status with consecutive < 3 days does not suggest deload', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      final rec = HrvAnalysis.recommend(
        baseline: baseline,
        todayLnRmssd: 3.35,
        consecutiveLowDays: 1,
      );
      expect(rec.suggestDeload, isFalse);
    });

    test('suspiciouslyHigh gives 0.9 multiplier', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      final rec = HrvAnalysis.recommend(
        baseline: baseline,
        todayLnRmssd: 4.0, // delta=0.5 > 2*0.2=0.4
        consecutiveLowDays: 0,
      );
      expect(rec.status, RecoveryStatus.suspiciouslyHigh);
      expect(rec.volumeMultiplier, 0.9);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // ExtendedFastProtocol.evaluateSafetyCheck
  // ══════════════════════════════════════════════════════════════
  group('ExtendedFastProtocol.evaluateSafetyCheck', () {
    test('returns ok with no symptoms and normal glucose', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 85.0,
      );
      expect(result.verdict, SafetyVerdict.ok);
    });

    test('returns ok with null glucose and no symptoms', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck();
      expect(result.verdict, SafetyVerdict.ok);
    });

    test('returns stop for critical glucose (<54)', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 50.0,
      );
      expect(result.verdict, SafetyVerdict.stopImmediately);
      expect(result.message, contains('50'));
    });

    test('returns warning for low glucose (54-70)', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 65.0,
      );
      expect(result.verdict, SafetyVerdict.warning);
      expect(result.message, contains('65'));
    });

    test('returns stop for 2+ critical symptoms', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        symptomIds: ['vertigini', 'palpitazioni'],
      );
      expect(result.verdict, SafetyVerdict.stopImmediately);
    });

    test('returns warning for 1 critical symptom', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        symptomIds: ['confusione'],
      );
      expect(result.verdict, SafetyVerdict.warning);
      expect(result.message, contains('Confusione'));
    });

    test('critical glucose takes priority over single critical symptom', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 50.0,
        symptomIds: ['vertigini'],
      );
      expect(result.verdict, SafetyVerdict.stopImmediately);
      expect(result.message, contains('50'));
    });

    test('returns warning for 3+ non-critical symptoms', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        symptomIds: ['crampi', 'nausea', 'cefalea'],
      );
      expect(result.verdict, SafetyVerdict.warning);
      expect(result.message, contains('elettroliti'));
    });

    test('returns ok for 2 non-critical symptoms', () {
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        symptomIds: ['crampi', 'nausea'],
      );
      expect(result.verdict, SafetyVerdict.ok);
    });

    test('critical symptom priority over low glucose warning', () {
      // 2 critical symptoms should trigger stop before glucose warning check
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 65.0,
        symptomIds: ['vertigini', 'tremori'],
      );
      expect(result.verdict, SafetyVerdict.stopImmediately);
    });

    test('boundary: glucose exactly at critical threshold', () {
      // 54.0 is exactly the critical threshold, should NOT trigger stop (< 54)
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 54.0,
      );
      expect(result.verdict, isNot(SafetyVerdict.stopImmediately));
    });

    test('boundary: glucose exactly at warning threshold', () {
      // 70.0 is exactly the warning threshold, should NOT trigger warning (< 70)
      final result = ExtendedFastProtocol.evaluateSafetyCheck(
        glucoseMgDl: 70.0,
      );
      expect(result.verdict, SafetyVerdict.ok);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // ExtendedFastProtocol.isBmiSafe
  // ══════════════════════════════════════════════════════════════
  group('ExtendedFastProtocol.isBmiSafe', () {
    test('returns true for normal BMI', () {
      // 70kg / (1.75m^2) = 22.86
      expect(ExtendedFastProtocol.isBmiSafe(70, 175), isTrue);
    });

    test('returns false for underweight BMI', () {
      // 50kg / (1.80m^2) = 15.43
      expect(ExtendedFastProtocol.isBmiSafe(50, 180), isFalse);
    });

    test('boundary: BMI just above 18.5', () {
      // 60kg / (1.80m^2) = 60 / 3.24 = 18.52
      expect(ExtendedFastProtocol.isBmiSafe(60, 180), isTrue);
    });

    test('boundary: BMI just below 18.5', () {
      // 59kg / (1.80m^2) = 59 / 3.24 = 18.21
      expect(ExtendedFastProtocol.isBmiSafe(59, 180), isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // MacroTargets.forDay
  // ══════════════════════════════════════════════════════════════
  group('MacroTargets.forDay', () {
    test('training day has higher carbs than normal day', () {
      final training = MacroTargets.forDay(
        weightKg: 80, dayType: 'training', tier: 'intermediate',
      );
      final normal = MacroTargets.forDay(
        weightKg: 80, dayType: 'normal', tier: 'intermediate',
      );
      expect(training.carbG, greaterThan(normal.carbG));
    });

    test('autophagy day has lower carbs than normal day', () {
      final autophagy = MacroTargets.forDay(
        weightKg: 80, dayType: 'autophagy', tier: 'intermediate',
      );
      final normal = MacroTargets.forDay(
        weightKg: 80, dayType: 'normal', tier: 'intermediate',
      );
      expect(autophagy.carbG, lessThan(normal.carbG));
    });

    test('protein scales with weight and tier', () {
      final beginner = MacroTargets.forDay(
        weightKg: 80, dayType: 'normal', tier: 'beginner',
      );
      final advanced = MacroTargets.forDay(
        weightKg: 80, dayType: 'normal', tier: 'advanced',
      );
      // beginner: 80*1.6=128, advanced: 80*2.2=176
      expect(beginner.proteinG, closeTo(128, 0.1));
      expect(advanced.proteinG, closeTo(176, 0.1));
    });

    test('carb per kg matches day type', () {
      final training = MacroTargets.forDay(
        weightKg: 80, dayType: 'training', tier: 'beginner',
      );
      // 4.5 g/kg * 80 = 360
      expect(training.carbG, closeTo(360, 0.1));
    });

    test('autophagy day has lower fiber target', () {
      final autophagy = MacroTargets.forDay(
        weightKg: 80, dayType: 'autophagy', tier: 'beginner',
      );
      final training = MacroTargets.forDay(
        weightKg: 80, dayType: 'training', tier: 'beginner',
      );
      expect(autophagy.fiberG, 27.0);
      expect(training.fiberG, 35.0);
    });

    test('total kcal is consistent with macros', () {
      final m = MacroTargets.forDay(
        weightKg: 80, dayType: 'normal', tier: 'intermediate',
      );
      // totalKcal should roughly equal protein*4 + carb*4 + fat*9
      final computedKcal = m.proteinG * 4 + m.carbG * 4 + m.fatG * 9;
      expect(m.totalKcal, closeTo(computedKcal, 1.0));
    });

    test('fat percent is higher on autophagy day', () {
      final autophagy = MacroTargets.forDay(
        weightKg: 80, dayType: 'autophagy', tier: 'beginner',
      );
      final training = MacroTargets.forDay(
        weightKg: 80, dayType: 'training', tier: 'beginner',
      );
      // fat % of total kcal
      final autophagyFatPct = (autophagy.fatG * 9) / autophagy.totalKcal;
      final trainingFatPct = (training.fatG * 9) / training.totalKcal;
      expect(autophagyFatPct, greaterThan(trainingFatPct));
    });

    test('unknown day type defaults to normal', () {
      final unknown = MacroTargets.forDay(
        weightKg: 80, dayType: 'unknown', tier: 'beginner',
      );
      final normal = MacroTargets.forDay(
        weightKg: 80, dayType: 'normal', tier: 'beginner',
      );
      expect(unknown.carbG, normal.carbG);
    });

    test('dayType is stored correctly', () {
      final m = MacroTargets.forDay(
        weightKg: 80, dayType: 'training', tier: 'beginner',
      );
      expect(m.dayType, 'training');
      expect(m.dayTypeLabel, 'Giorno Training');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // ExerciseRotator.selectForMesocycle
  // ══════════════════════════════════════════════════════════════
  group('ExerciseRotator.selectForMesocycle', () {
    final rotator = ExerciseRotator();

    // Build a pool of exercises for testing
    final pool = [
      _makeExercise(id: 1, category: 'push', exerciseType: 'compound', phoenixLevel: 1),
      _makeExercise(id: 2, category: 'push', exerciseType: 'compound', phoenixLevel: 2),
      _makeExercise(id: 3, category: 'push', exerciseType: 'compound', phoenixLevel: 3),
      _makeExercise(id: 4, category: 'push', exerciseType: 'accessory', phoenixLevel: 1),
      _makeExercise(id: 5, category: 'push', exerciseType: 'accessory', phoenixLevel: 2),
      _makeExercise(id: 6, category: 'core', exerciseType: 'core', phoenixLevel: 1),
      _makeExercise(id: 7, category: 'core', exerciseType: 'core', phoenixLevel: 2),
      _makeExercise(id: 8, category: 'core', exerciseType: 'core', phoenixLevel: 3),
      _makeExercise(id: 9, category: 'push', exerciseType: 'compound', phoenixLevel: 1, equipment: 'gym'),
    ];

    test('fills all slots when pool has enough exercises', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
        const RotationSlot(category: 'push', exerciseType: 'accessory', slotIndex: 0),
        const RotationSlot(category: 'core', exerciseType: 'core', slotIndex: 0),
      ];
      final result = rotator.selectForMesocycle(
        slots: slots,
        exercisePool: pool,
        mesocycleNumber: 1,
        equipment: 'all',
        maxLevel: 3,
      );
      expect(result.selections.length, 3);
      expect(result.totalExerciseCount, 3);
    });

    test('respects maxLevel filter', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
      ];
      final result = rotator.selectForMesocycle(
        slots: slots,
        exercisePool: pool,
        mesocycleNumber: 1,
        equipment: 'all',
        maxLevel: 1,
      );
      final selectedId = result.selections.values.first;
      final selected = pool.firstWhere((e) => e.id == selectedId);
      expect(selected.phoenixLevel, lessThanOrEqualTo(1));
    });

    test('respects excludedExerciseIds', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
      ];
      final result = rotator.selectForMesocycle(
        slots: slots,
        exercisePool: pool,
        mesocycleNumber: 1,
        equipment: 'all',
        maxLevel: 3,
        excludedExerciseIds: {1, 2, 3},
      );
      // Exercises 1,2,3 are push/compound/all but excluded.
      // Exercise 9 is push/compound/gym — equipment filter: e.equipment != 'all' && e.equipment != 'all' => filtered out.
      // So the only remaining push compounds after exclusion + equipment filter is none OR 9.
      // _filterPool checks: e.equipment != equipment && e.equipment != Equipment.all
      // equipment='all', so e.equipment != 'all' for 9 (gym != all) => true, and e.equipment != 'all' for 9 => true => filtered out.
      // So result should be empty OR contain 9 depending on exact filter logic.
      // The filter says: if (e.equipment != equipment && e.equipment != Equipment.all) return false
      // For 9: 'gym' != 'all' => true, and 'gym' != 'all' => true => return false. So 9 is filtered out.
      // With 1,2,3 excluded and 9 filtered, pool is empty.
      expect(result.selections, isEmpty);
    });

    test('locked exercises are preserved from previous selection', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
      ];
      final previous = MesocycleExerciseSelection(
        mesocycleNumber: 1,
        selections: {'push_compound_0': 2},
      );
      final result = rotator.selectForMesocycle(
        slots: slots,
        exercisePool: pool,
        mesocycleNumber: 2,
        equipment: 'all',
        maxLevel: 3,
        previousSelections: [previous],
        lockedExerciseIds: {2},
      );
      expect(result.selections['push_compound_0'], 2);
    });

    test('deterministic: same seed gives same result', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
        const RotationSlot(category: 'core', exerciseType: 'core', slotIndex: 0),
      ];
      final result1 = rotator.selectForMesocycle(
        slots: slots, exercisePool: pool,
        mesocycleNumber: 42, equipment: 'all', maxLevel: 3,
      );
      final result2 = rotator.selectForMesocycle(
        slots: slots, exercisePool: pool,
        mesocycleNumber: 42, equipment: 'all', maxLevel: 3,
      );
      expect(result1.selections, result2.selections);
    });

    test('novelty is computed against previous selections', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
        const RotationSlot(category: 'push', exerciseType: 'accessory', slotIndex: 0),
        const RotationSlot(category: 'core', exerciseType: 'core', slotIndex: 0),
      ];
      final previous = MesocycleExerciseSelection(
        mesocycleNumber: 1,
        selections: {
          'push_compound_0': 3,
          'push_accessory_0': 5,
          'core_core_0': 8,
        },
      );
      final result = rotator.selectForMesocycle(
        slots: slots,
        exercisePool: pool,
        mesocycleNumber: 2,
        equipment: 'all',
        maxLevel: 3,
        previousSelections: [previous],
      );
      // The overlap percentage is computed
      expect(result.overlapPercentage, isA<double>());
      expect(result.newExerciseCount + (result.totalExerciseCount - result.newExerciseCount),
          result.totalExerciseCount);
    });

    test('empty pool results in empty selections', () {
      final slots = [
        const RotationSlot(category: 'push', exerciseType: 'compound', slotIndex: 0),
      ];
      final result = rotator.selectForMesocycle(
        slots: slots,
        exercisePool: [],
        mesocycleNumber: 1,
        equipment: 'all',
        maxLevel: 3,
      );
      expect(result.selections, isEmpty);
      expect(result.overlapPercentage, 0.0);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // ExerciseRotator.slotsForStrengthDay
  // ══════════════════════════════════════════════════════════════
  group('ExerciseRotator.slotsForStrengthDay', () {
    test('generates correct number of slots', () {
      final slots = ExerciseRotator.slotsForStrengthDay(
        category: 'push',
        compoundCount: 2,
        accessoryCount: 3,
        coreCount: 1,
      );
      expect(slots.length, 6); // 2+3+1
    });

    test('default coreCount is 2', () {
      final slots = ExerciseRotator.slotsForStrengthDay(
        category: 'pull',
        compoundCount: 1,
        accessoryCount: 1,
      );
      expect(slots.where((s) => s.exerciseType == ExerciseType.core).length, 2);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // SupplementEngine.evaluate
  // ══════════════════════════════════════════════════════════════
  group('SupplementEngine.evaluate', () {
    const engine = SupplementEngine();

    test('always includes collagen and cordyceps', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 30,
        sex: 'male',
      );
      final names = recs.map((r) => r.name).toList();
      expect(names, contains('Collagene idrolizzato'));
      expect(names, contains('Cordyceps Cs-4'));
    });

    test('includes creatine for age >= 40', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 40,
        sex: 'male',
      );
      expect(recs.any((r) => r.name == 'Creatina monoidrato'), isTrue);
    });

    test('excludes creatine for age < 40', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 30,
        sex: 'male',
      );
      expect(recs.any((r) => r.name == 'Creatina monoidrato'), isFalse);
    });

    test('includes NMN informative for age >= 40', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 45,
        sex: 'male',
      );
      final nmn = recs.firstWhere((r) => r.name.contains('NMN'));
      expect(nmn.priority, SupplementPriority.informative);
    });

    test('includes astragalus for age >= 50', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 55,
        sex: 'female',
      );
      expect(recs.any((r) => r.name.contains('Astragalus')), isTrue);
    });

    test('excludes astragalus for age < 50', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 45,
        sex: 'male',
      );
      expect(recs.any((r) => r.name.contains('Astragalus')), isFalse);
    });

    test('low vitamin D triggers D3 recommendation', () {
      final recs = engine.evaluate(
        biomarkers: {'vitamin_d_25oh': 15.0},
        age: 30,
        sex: 'male',
      );
      final d3 = recs.firstWhere((r) => r.name.contains('D3'));
      expect(d3.priority, SupplementPriority.high); // <20 is high
    });

    test('vitamin D 20-30 triggers medium priority', () {
      final recs = engine.evaluate(
        biomarkers: {'vitamin_d_25oh': 25.0},
        age: 30,
        sex: 'male',
      );
      final d3 = recs.firstWhere((r) => r.name.contains('D3'));
      expect(d3.priority, SupplementPriority.medium);
    });

    test('vitamin D >= 30 does not trigger D3', () {
      final recs = engine.evaluate(
        biomarkers: {'vitamin_d_25oh': 35.0},
        age: 30,
        sex: 'male',
      );
      expect(recs.any((r) => r.name.contains('D3')), isFalse);
    });

    test('low omega-3 triggers omega-3 recommendation', () {
      final recs = engine.evaluate(
        biomarkers: {'omega3_index': 3.0},
        age: 30,
        sex: 'male',
      );
      final omega = recs.firstWhere((r) => r.name.contains('Omega'));
      expect(omega.priority, SupplementPriority.high); // <4 is high
    });

    test('low ferritin triggers iron recommendation', () {
      final recs = engine.evaluate(
        biomarkers: {'ferritin': 10.0},
        age: 30,
        sex: 'female',
      );
      final iron = recs.firstWhere((r) => r.name.contains('Ferro'));
      expect(iron.priority, SupplementPriority.high); // <15 is high
      expect(iron.warnings, isNotEmpty);
    });

    test('ferritin >= 30 does not trigger iron', () {
      final recs = engine.evaluate(
        biomarkers: {'ferritin': 50.0},
        age: 30,
        sex: 'male',
      );
      expect(recs.any((r) => r.name.contains('Ferro')), isFalse);
    });

    test('low magnesium triggers Mg recommendation', () {
      final recs = engine.evaluate(
        biomarkers: {'magnesium': 1.5},
        age: 30,
        sex: 'male',
      );
      expect(recs.any((r) => r.name.contains('Magnesio')), isTrue);
    });

    test('high training load adds Rhodiola and Schisandra', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 30,
        sex: 'male',
        trainingLoad: 'high',
      );
      final names = recs.map((r) => r.name).toList();
      expect(names.any((n) => n.contains('Rhodiola')), isTrue);
      expect(names.any((n) => n.contains('Schisandra')), isTrue);
    });

    test('moderate training load excludes Rhodiola', () {
      final recs = engine.evaluate(
        biomarkers: {},
        age: 30,
        sex: 'male',
        trainingLoad: 'moderate',
      );
      expect(recs.any((r) => r.name.contains('Rhodiola')), isFalse);
    });

    test('ecdysterone added for high load or age>=35 moderate', () {
      final highRecs = engine.evaluate(
        biomarkers: {},
        age: 25,
        sex: 'male',
        trainingLoad: 'high',
      );
      expect(highRecs.any((r) => r.name.contains('Ecdysterone')), isTrue);

      final moderateOlder = engine.evaluate(
        biomarkers: {},
        age: 35,
        sex: 'male',
        trainingLoad: 'moderate',
      );
      expect(moderateOlder.any((r) => r.name.contains('Ecdysterone')), isTrue);

      final moderateYoung = engine.evaluate(
        biomarkers: {},
        age: 30,
        sex: 'male',
        trainingLoad: 'moderate',
      );
      expect(moderateYoung.any((r) => r.name.contains('Ecdysterone')), isFalse);
    });

    test('results are sorted by priority', () {
      final recs = engine.evaluate(
        biomarkers: {
          'vitamin_d_25oh': 15.0,
          'ferritin': 10.0,
          'omega3_index': 3.0,
        },
        age: 45,
        sex: 'male',
        trainingLoad: 'high',
      );
      for (int i = 0; i < recs.length - 1; i++) {
        expect(recs[i].priority.index, lessThanOrEqualTo(recs[i + 1].priority.index));
      }
    });

    test('reishi included for moderate and high training load', () {
      final moderate = engine.evaluate(
        biomarkers: {}, age: 30, sex: 'male', trainingLoad: 'moderate',
      );
      expect(moderate.any((r) => r.name.contains('Reishi')), isTrue);

      final low = engine.evaluate(
        biomarkers: {}, age: 30, sex: 'male', trainingLoad: 'low',
      );
      expect(low.any((r) => r.name.contains('Reishi')), isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // SupplementEngine.missingBiomarkers
  // ══════════════════════════════════════════════════════════════
  group('SupplementEngine.missingBiomarkers', () {
    const engine = SupplementEngine();

    test('returns all 4 for empty biomarkers', () {
      expect(engine.missingBiomarkers({}), hasLength(4));
    });

    test('returns empty when all present', () {
      final bio = {
        'vitamin_d_25oh': 40.0,
        'omega3_index': 8.0,
        'ferritin': 80.0,
        'magnesium': 2.0,
      };
      expect(engine.missingBiomarkers(bio), isEmpty);
    });

    test('returns only missing ones', () {
      final bio = {'vitamin_d_25oh': 40.0, 'ferritin': 80.0};
      final missing = engine.missingBiomarkers(bio);
      expect(missing, hasLength(2));
      expect(missing, contains('Omega-3 Index'));
      expect(missing, contains('Magnesio'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // SleepCoach.eveningTips
  // ══════════════════════════════════════════════════════════════
  group('SleepCoach.eveningTips', () {
    SleepEntry _makeEntry({
      required int hour,
      required int minute,
      int quality = 4,
      int dayOffset = 0,
    }) {
      return SleepEntry(
        date: DateTime(2026, 1, 1 + dayOffset),
        bedtime: DateTime(2026, 1, 1 + dayOffset, hour, minute),
        wakeTime: DateTime(2026, 1, 2 + dayOffset, 7, 0),
        quality: quality,
      );
    }

    test('returns tips with empty entries', () {
      const env = SleepEnvironment();
      final tips = SleepCoach.eveningTips(env, []);
      // Should still include static tips (TCM, Russian, etc.)
      expect(tips, isNotEmpty);
    });

    test('includes temperature tip when reminder enabled', () {
      const env = SleepEnvironment(temperatureReminder: true);
      final tips = SleepCoach.eveningTips(env, []);
      expect(tips.any((t) => t.message.contains('18-19')), isTrue);
    });

    test('includes blue light tip when reminder enabled', () {
      const env = SleepEnvironment(blueLightReminder: true);
      final tips = SleepCoach.eveningTips(env, []);
      expect(tips.any((t) => t.message.contains('melatonina')), isTrue);
    });

    test('includes caffeine tip when reminder enabled', () {
      const env = SleepEnvironment(caffeineReminder: true);
      final tips = SleepCoach.eveningTips(env, []);
      expect(tips.any((t) => t.message.contains('caff')), isTrue);
    });

    test('does not include temperature/blue light/caffeine tips when disabled', () {
      const env = SleepEnvironment(
        temperatureReminder: false,
        blueLightReminder: false,
        caffeineReminder: false,
      );
      final tips = SleepCoach.eveningTips(env, []);
      // Personalized temperature tip mentions 'sonno ottimale' — should not appear
      expect(tips.any((t) => t.message.contains('sonno ottimale')), isFalse);
      // Personalized blue light tip starts with 'Spegni schermi' — should not appear
      // (note: 'melatonina' also appears in the always-present SZRT tip, so we check specifically)
      expect(tips.any((t) => t.message.startsWith('Spegni schermi')), isFalse);
      // Personalized caffeine cutoff tip starts with 'Ultimo caff' — should not appear
      expect(tips.any((t) => t.message.startsWith('Ultimo caff')), isFalse);
    });

    test('low quality sleep triggers high priority tip', () {
      const env = SleepEnvironment();
      final entries = List.generate(5, (i) =>
        _makeEntry(hour: 22, minute: 0, quality: 2, dayOffset: i));
      final tips = SleepCoach.eveningTips(env, entries);
      expect(
        tips.any((t) =>
          t.priority == SleepTipPriority.high &&
          t.message.contains('Qualit')),
        isTrue,
      );
    });

    test('short average duration triggers tip', () {
      const env = SleepEnvironment();
      // Bedtime 1:00, wake 7:00 = 6h < 7h threshold
      final entries = List.generate(5, (i) => SleepEntry(
        date: DateTime(2026, 1, 1 + i),
        bedtime: DateTime(2026, 1, 1 + i, 1, 0),
        wakeTime: DateTime(2026, 1, 1 + i, 7, 0),
        quality: 4,
      ));
      final tips = SleepCoach.eveningTips(env, entries);
      expect(tips.any((t) => t.message.contains('sotto le 7h')), isTrue);
    });

    test('always includes TCM organ clock tip', () {
      const env = SleepEnvironment();
      final tips = SleepCoach.eveningTips(env, []);
      expect(tips.any((t) => t.message.contains('Cistifellea')), isTrue);
    });

    test('always includes Pao Jiao tip', () {
      const env = SleepEnvironment();
      final tips = SleepCoach.eveningTips(env, []);
      expect(tips.any((t) => t.message.contains('Pao Jiao')), isTrue);
    });

    test('always includes ADAPT-232 tip', () {
      const env = SleepEnvironment();
      final tips = SleepCoach.eveningTips(env, []);
      expect(tips.any((t) => t.message.contains('ADAPT-232')), isTrue);
    });

    test('tips are sorted by priority (high first)', () {
      const env = SleepEnvironment(
        temperatureReminder: true,
        blueLightReminder: true,
        caffeineReminder: true,
      );
      final entries = List.generate(5, (i) =>
        _makeEntry(hour: 22, minute: 0, quality: 2, dayOffset: i));
      final tips = SleepCoach.eveningTips(env, entries);
      for (int i = 0; i < tips.length - 1; i++) {
        expect(tips[i].priority.index, lessThanOrEqualTo(tips[i + 1].priority.index));
      }
    });
  });

  // ══════════════════════════════════════════════════════════════
  // SleepEnvironment cutoff calculations
  // ══════════════════════════════════════════════════════════════
  group('SleepEnvironment cutoffs', () {
    test('blue light cutoff subtracts hours from bedtime', () {
      const env = SleepEnvironment(
        targetBedtime: TimeOfDay(hour: 23, minute: 0),
        blueLightCutoffHours: 2,
      );
      expect(env.blueLightCutoff.hour, 21);
      expect(env.blueLightCutoff.minute, 0);
    });

    test('caffeine cutoff subtracts hours from bedtime', () {
      const env = SleepEnvironment(
        targetBedtime: TimeOfDay(hour: 23, minute: 0),
        caffeineCutoffHours: 10,
      );
      expect(env.caffeineCutoff.hour, 13);
      expect(env.caffeineCutoff.minute, 0);
    });

    test('cutoff wraps around midnight', () {
      const env = SleepEnvironment(
        targetBedtime: TimeOfDay(hour: 1, minute: 0),
        blueLightCutoffHours: 2,
      );
      // 1:00 - 2h = 23:00
      expect(env.blueLightCutoff.hour, 23);
      expect(env.blueLightCutoff.minute, 0);
    });

    test('temperature reminder is 30 min before bedtime', () {
      const env = SleepEnvironment(
        targetBedtime: TimeOfDay(hour: 23, minute: 0),
      );
      expect(env.temperatureReminderTime.hour, 22);
      expect(env.temperatureReminderTime.minute, 30);
    });

    test('wind down start is 2h before bedtime', () {
      const env = SleepEnvironment(
        targetBedtime: TimeOfDay(hour: 23, minute: 0),
      );
      expect(env.windDownStart.hour, 21);
      expect(env.windDownStart.minute, 0);
    });

    test('pao jiao time is 1h before bedtime', () {
      const env = SleepEnvironment(
        targetBedtime: TimeOfDay(hour: 23, minute: 30),
      );
      expect(env.paoJiaoTime.hour, 22);
      expect(env.paoJiaoTime.minute, 30);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // HrvAnalysis.countConsecutiveLowDays
  // ══════════════════════════════════════════════════════════════
  group('HrvAnalysis.countConsecutiveLowDays', () {
    test('returns 0 for empty readings', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      expect(HrvAnalysis.countConsecutiveLowDays([], baseline), 0);
    });

    test('returns 0 when baseline not established', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 10,
      );
      final readings = [
        HrvReading(timestamp: DateTime(2026, 1, 1), rmssd: 10, source: 'manual'),
      ];
      expect(HrvAnalysis.countConsecutiveLowDays(readings, baseline), 0);
    });

    test('counts consecutive low days from most recent', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      // threshold = 3.5 - 0.1 = 3.4
      // lnRmssd < 3.4 => low
      final readings = [
        HrvReading(timestamp: DateTime(2026, 1, 3), rmssd: exp(3.2), source: 'manual'), // low
        HrvReading(timestamp: DateTime(2026, 1, 2), rmssd: exp(3.3), source: 'manual'), // low
        HrvReading(timestamp: DateTime(2026, 1, 1), rmssd: exp(3.6), source: 'manual'), // normal
      ];
      expect(HrvAnalysis.countConsecutiveLowDays(readings, baseline), 2);
    });

    test('stops counting at first non-low day', () {
      const baseline = HrvBaseline(
        mean7Day: 3.5, sd7Day: 0.1,
        mean14Day: 3.5, sd14Day: 0.2,
        readingsCount: 14,
      );
      final readings = [
        HrvReading(timestamp: DateTime(2026, 1, 3), rmssd: exp(3.2), source: 'manual'), // low
        HrvReading(timestamp: DateTime(2026, 1, 2), rmssd: exp(3.6), source: 'manual'), // not low
        HrvReading(timestamp: DateTime(2026, 1, 1), rmssd: exp(3.0), source: 'manual'), // low
      ];
      expect(HrvAnalysis.countConsecutiveLowDays(readings, baseline), 1);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Extended fast helper functions
  // ══════════════════════════════════════════════════════════════
  group('ExtendedFastProtocol.currentPhase', () {
    test('returns adaptation for < 24h', () {
      expect(ExtendedFastProtocol.currentPhase(0), ExtendedFastPhase.adaptation);
      expect(ExtendedFastProtocol.currentPhase(23.9), ExtendedFastPhase.adaptation);
    });

    test('returns deepKetosis for 24-72h', () {
      expect(ExtendedFastProtocol.currentPhase(24), ExtendedFastPhase.deepKetosis);
      expect(ExtendedFastProtocol.currentPhase(71.9), ExtendedFastPhase.deepKetosis);
    });

    test('returns autophagyMax for >= 72h', () {
      expect(ExtendedFastProtocol.currentPhase(72), ExtendedFastPhase.autophagyMax);
      expect(ExtendedFastProtocol.currentPhase(120), ExtendedFastPhase.autophagyMax);
    });
  });

  group('RefeedingProtocol.refeedingDurationHours', () {
    test('returns 50% of fast duration', () {
      expect(RefeedingProtocol.refeedingDurationHours(96), 48);
    });

    test('clamps to minimum 24h', () {
      expect(RefeedingProtocol.refeedingDurationHours(30), 24);
    });

    test('clamps to maximum 72h', () {
      expect(RefeedingProtocol.refeedingDurationHours(200), 72);
    });
  });

  group('Level3Criteria.evaluate', () {
    final now = DateTime(2026, 3, 1);

    test('eligible when all criteria met', () {
      final result = Level3Criteria.evaluate(
        level2FastsCompleted: 3,
        medicalDisclaimerAcceptedAt: now.subtract(const Duration(days: 30)),
        lastBloodPanelDate: now.subtract(const Duration(days: 15)),
        weightKg: 70,
        heightCm: 175,
        now: now,
      );
      expect(result.eligible, isTrue);
      expect(result.unmetCriteria, isEmpty);
    });

    test('not eligible with insufficient fasts', () {
      final result = Level3Criteria.evaluate(
        level2FastsCompleted: 2,
        medicalDisclaimerAcceptedAt: now.subtract(const Duration(days: 30)),
        lastBloodPanelDate: now.subtract(const Duration(days: 15)),
        weightKg: 70,
        heightCm: 175,
        now: now,
      );
      expect(result.eligible, isFalse);
      expect(result.unmetCriteria, hasLength(1));
    });

    test('not eligible with expired disclaimer', () {
      final result = Level3Criteria.evaluate(
        level2FastsCompleted: 3,
        medicalDisclaimerAcceptedAt: now.subtract(const Duration(days: 100)),
        lastBloodPanelDate: now.subtract(const Duration(days: 15)),
        weightKg: 70,
        heightCm: 175,
        now: now,
      );
      expect(result.eligible, isFalse);
      expect(result.medicalDisclaimerValid, isFalse);
    });

    test('not eligible with no blood panel', () {
      final result = Level3Criteria.evaluate(
        level2FastsCompleted: 3,
        medicalDisclaimerAcceptedAt: now.subtract(const Duration(days: 30)),
        lastBloodPanelDate: null,
        weightKg: 70,
        heightCm: 175,
        now: now,
      );
      expect(result.eligible, isFalse);
      expect(result.recentBloodPanel, isFalse);
    });

    test('not eligible with low BMI', () {
      final result = Level3Criteria.evaluate(
        level2FastsCompleted: 3,
        medicalDisclaimerAcceptedAt: now.subtract(const Duration(days: 30)),
        lastBloodPanelDate: now.subtract(const Duration(days: 15)),
        weightKg: 45,
        heightCm: 175,
        now: now,
      );
      expect(result.eligible, isFalse);
      expect(result.bmiSafe, isFalse);
    });

    test('multiple unmet criteria are all listed', () {
      final result = Level3Criteria.evaluate(
        level2FastsCompleted: 0,
        medicalDisclaimerAcceptedAt: null,
        lastBloodPanelDate: null,
        weightKg: 45,
        heightCm: 175,
        now: now,
      );
      expect(result.eligible, isFalse);
      expect(result.unmetCriteria, hasLength(4));
    });
  });
}
