import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../database/daos/workout_dao.dart';
import '../database/daos/fasting_dao.dart';
import '../database/daos/conditioning_dao.dart';
import '../database/daos/biomarker_dao.dart';
import '../database/tables.dart';

/// Progress data for the 3 activity rings on the dashboard.
class ActivityRingsData {
  final double trainingProgress;
  final double fastingProgress;
  final double conditioningProgress;
  final String trainingLabel;
  final String fastingLabel;
  final String conditioningLabel;

  const ActivityRingsData({
    required this.trainingProgress,
    required this.fastingProgress,
    required this.conditioningProgress,
    required this.trainingLabel,
    required this.fastingLabel,
    required this.conditioningLabel,
  });

  static const _conditioningDailyTarget = 1;

  static Future<ActivityRingsData> compute({
    required WorkoutDao workoutDao,
    required FastingDao fastingDao,
    required ConditioningDao conditioningDao,
  }) async {
    // Training
    final todaySessions = await workoutDao.getTodaySessions();
    final trainingDone = todaySessions.isNotEmpty;
    final trainingProgress = trainingDone ? 1.0 : 0.0;
    final trainingLabel =
        trainingDone ? 'Allenamento: completato' : 'Allenamento: da fare';

    // Fasting
    final activeFast = await fastingDao.watchActiveFast().first;
    double fastingProgress;
    String fastingLabel;
    if (activeFast != null) {
      final elapsed =
          DateTime.now().difference(activeFast.startedAt).inMinutes;
      final target = (activeFast.targetHours * 60).round();
      fastingProgress = target > 0 ? (elapsed / target).clamp(0.0, 1.0) : 0.0;
      final h = elapsed ~/ 60;
      final targetH = activeFast.targetHours.toInt();
      fastingLabel = 'Digiuno: ${h}h/${targetH}h';
    } else {
      fastingProgress = 0.0;
      fastingLabel = 'Digiuno: non attivo';
    }

    // Conditioning
    final condToday = await conditioningDao.getTodaySessionCount();
    final conditioningProgress =
        (condToday / _conditioningDailyTarget).clamp(0.0, 1.0);
    final conditioningLabel =
        'Condizionamento: $condToday/$_conditioningDailyTarget sessioni';

    return ActivityRingsData(
      trainingProgress: trainingProgress,
      fastingProgress: fastingProgress,
      conditioningProgress: conditioningProgress,
      trainingLabel: trainingLabel,
      fastingLabel: fastingLabel,
      conditioningLabel: conditioningLabel,
    );
  }
}

/// Priority-based "One Big Thing" suggestion for the dashboard.
class OneBigThing {
  final String title;
  final String subtitle;
  final IconType iconType;
  final PriorityLevel priority;

  const OneBigThing({
    required this.title,
    required this.subtitle,
    required this.iconType,
    required this.priority,
  });

  static Future<OneBigThing> compute({
    required WorkoutDao workoutDao,
    required FastingDao fastingDao,
    required ConditioningDao conditioningDao,
    required BiomarkerDao biomarkerDao,
    required String todayDayName,
    String? recoveryStatus,
  }) async {
    // 0. HRV recovery status (highest priority)
    if (recoveryStatus == 'veryLow') {
      return const OneBigThing(
        title: 'Recovery compromessa',
        subtitle: 'Considera un giorno leggero',
        iconType: IconType.biomarker,
        priority: PriorityLevel.alert,
      );
    }
    if (recoveryStatus == 'low') {
      return const OneBigThing(
        title: 'Recovery bassa',
        subtitle: 'Adatta l\'intensità',
        iconType: IconType.biomarker,
        priority: PriorityLevel.warning,
      );
    }

    // 1. Biomarker alerts (blood panel > 90 days old)
    final lastBlood =
        await biomarkerDao.getLatestByType(BiomarkerType.bloodPanel);
    if (lastBlood != null) {
      final daysSince = DateTime.now().difference(lastBlood.date).inDays;
      if (daysSince > 90) {
        return OneBigThing(
          title: 'Analisi del sangue scadute',
          subtitle:
              'Sono passati $daysSince giorni. È ora di fare le analisi.',
          iconType: IconType.biomarker,
          priority: PriorityLevel.alert,
        );
      }
    }

    // 2. Training not done today
    final todaySessions = await workoutDao.getTodaySessions();
    if (todaySessions.isEmpty) {
      final recent = await workoutDao.getSessionsInRange(
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now(),
      );
      if (recent.isNotEmpty) {
        final daysAgo =
            DateTime.now().difference(recent.first.startedAt).inDays;
        if (daysAgo >= 2) {
          return OneBigThing(
            title: 'Sono $daysAgo giorni che non ti alleni',
            subtitle: 'Tutto bene? Il protocollo ti aspetta.',
            iconType: IconType.training,
            priority: PriorityLevel.warning,
          );
        }
      }
      return OneBigThing(
        title: 'Allenamento del giorno: $todayDayName',
        subtitle: 'Non ancora completato oggi.',
        iconType: IconType.training,
        priority: PriorityLevel.action,
      );
    }

    // 3. Active fasting status
    final activeFast = await fastingDao.watchActiveFast().first;
    if (activeFast != null) {
      final remaining = (activeFast.targetHours * 60).round() -
          DateTime.now().difference(activeFast.startedAt).inMinutes;
      if (remaining > 0) {
        final h = remaining ~/ 60;
        final m = remaining % 60;
        return OneBigThing(
          title: 'Digiuno in corso',
          subtitle: 'Mancano ${h}h ${m}m al target.',
          iconType: IconType.fasting,
          priority: PriorityLevel.info,
        );
      }
    }

    // 4. Conditioning missing today
    final condToday = await conditioningDao.getTodaySessionCount();
    if (condToday == 0) {
      return const OneBigThing(
        title: 'Condizionamento',
        subtitle: 'Nessuna sessione oggi. Doccia fredda? Meditazione?',
        iconType: IconType.conditioning,
        priority: PriorityLevel.suggestion,
      );
    }

    // 5. Positive insight
    final streak = await workoutDao.currentStreak();
    if (streak >= 3) {
      return OneBigThing(
        title: 'Streak allenamento: $streak giorni!',
        subtitle: 'Continua così. La costanza è tutto.',
        iconType: IconType.positive,
        priority: PriorityLevel.positive,
      );
    }

    return const OneBigThing(
      title: 'Oggi stai bene',
      subtitle: 'Hai completato le attività principali.',
      iconType: IconType.positive,
      priority: PriorityLevel.positive,
    );
  }
}

enum IconType { training, fasting, conditioning, biomarker, positive }

enum PriorityLevel { alert, warning, action, info, suggestion, positive }

/// Stats for the dashboard cards.
class DashboardStats {
  final double? phenoAge;
  final double? phenoAgeDelta;
  final double? currentWeight;
  final double? weightDelta;
  final int workoutStreak;
  final double? avgSleepHours;

  const DashboardStats({
    this.phenoAge,
    this.phenoAgeDelta,
    this.currentWeight,
    this.weightDelta,
    this.workoutStreak = 0,
    this.avgSleepHours,
  });

  static Future<DashboardStats> compute({
    required WorkoutDao workoutDao,
    required BiomarkerDao biomarkerDao,
    required ConditioningDao conditioningDao,
  }) async {
    // PhenoAge
    double? phenoAge;
    double? phenoAgeDelta;
    final phenoAgeEntry =
        await biomarkerDao.getLatestByType(BiomarkerType.phenoage);
    if (phenoAgeEntry != null) {
      try {
        final values =
            Map<String, dynamic>.from(jsonDecode(phenoAgeEntry.valuesJson) as Map);
        phenoAge = (values['phenoage'] as num?)?.toDouble();
        final chrono = (values['chronological_age'] as num?)?.toDouble();
        if (phenoAge != null && chrono != null) {
          phenoAgeDelta = phenoAge - chrono;
        }
      } catch (e) { debugPrint('Dashboard computation error: $e'); }
    }

    // Weight
    double? currentWeight;
    double? weightDelta;
    final weights =
        await biomarkerDao.getByType(BiomarkerType.weight, limit: 2);
    if (weights.isNotEmpty) {
      try {
        final v =
            Map<String, dynamic>.from(jsonDecode(weights.first.valuesJson) as Map);
        currentWeight = (v['kg'] as num?)?.toDouble();
        if (weights.length >= 2) {
          final prev =
              Map<String, dynamic>.from(jsonDecode(weights[1].valuesJson) as Map);
          final prevW = (prev['kg'] as num?)?.toDouble();
          if (currentWeight != null && prevW != null) {
            weightDelta = currentWeight - prevW;
          }
        }
      } catch (e) { debugPrint('Dashboard computation error: $e'); }
    }

    // Workout streak
    final streak = await workoutDao.currentStreak();

    // Sleep average (last 7 days)
    double? avgSleepHours;
    final sleepSessions = await conditioningDao.getRecentByType(
      ConditioningType.sleep,
      days: 7,
    );
    if (sleepSessions.isNotEmpty) {
      final totalSeconds =
          sleepSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
      avgSleepHours = totalSeconds / sleepSessions.length / 3600;
    }

    return DashboardStats(
      phenoAge: phenoAge,
      phenoAgeDelta: phenoAgeDelta,
      currentWeight: currentWeight,
      weightDelta: weightDelta,
      workoutStreak: streak,
      avgSleepHours: avgSleepHours,
    );
  }
}
