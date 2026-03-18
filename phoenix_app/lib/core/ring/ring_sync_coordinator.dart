/// Orchestrates full data sync on app open.
///
/// Sequence: sleep → HRV auto → HR log → steps → battery → lastSync
/// Max 1 sync per 15 minutes (cooldown).
library;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../database/daos/ring_data_dao.dart';
import '../database/daos/ring_device_dao.dart';
import '../database/daos/workout_dao.dart';
import '../database/daos/fasting_dao.dart';
import '../database/daos/conditioning_dao.dart';
import '../database/daos/meal_log_dao.dart';
import '../database/database.dart';
import '../models/daily_protocol.dart';
import '../models/sleep_environment.dart';
import '../models/workout_plan.dart';
import '../notifications/notification_service.dart';
import '../../features/widgets/phoenix_home_widget.dart';
import 'morning_hrv_check.dart';
import 'ring_service.dart';
import 'signal_processor.dart';
import 'sleep_notifier.dart';

class RingSyncCoordinator {
  final RingService _ring;
  final RingDataDao _dataDao;
  final RingDeviceDao _deviceDao;
  final SignalProcessor _processor;
  final NotificationService _notifications;
  final MorningHrvCheck _hrvCheck;
  final WorkoutDao _workoutDao;
  final FastingDao _fastingDao;
  final ConditioningDao _conditioningDao;
  final MealLogDao _mealLogDao;

  /// Provide these to enable widget updates after sync.
  WorkoutPlan? todayWorkout;
  double weightKg;
  String tier;
  SleepEnvironment sleepEnv;

  DateTime? _lastSyncTime;
  bool _syncing = false;

  final ValueNotifier<String?> syncStatus = ValueNotifier(null);

  RingSyncCoordinator({
    required RingService ring,
    required RingDataDao dataDao,
    required RingDeviceDao deviceDao,
    required SignalProcessor processor,
    required NotificationService notifications,
    required MorningHrvCheck hrvCheck,
    required WorkoutDao workoutDao,
    required FastingDao fastingDao,
    required ConditioningDao conditioningDao,
    required MealLogDao mealLogDao,
    this.todayWorkout,
    this.weightKg = 70.0,
    this.tier = 'beginner',
    this.sleepEnv = const SleepEnvironment(),
  })  : _ring = ring,
        _dataDao = dataDao,
        _deviceDao = deviceDao,
        _processor = processor,
        _notifications = notifications,
        _hrvCheck = hrvCheck,
        _workoutDao = workoutDao,
        _fastingDao = fastingDao,
        _conditioningDao = conditioningDao,
        _mealLogDao = mealLogDao;

  Future<void> syncIfNeeded() async {
    if (_syncing) return;
    if (_ring.connectionState.value != RingConnectionState.ready) return;

    if (_lastSyncTime != null &&
        DateTime.now().difference(_lastSyncTime!) < const Duration(minutes: 15)) {
      return;
    }

    _syncing = true;

    try {
      syncStatus.value = 'Sincronizzazione sonno...';
      await _syncSleep();

      syncStatus.value = 'HR log...';
      await _syncHrLog();

      syncStatus.value = 'Passi...';
      await _syncSteps();

      syncStatus.value = 'Batteria...';
      await _ring.refreshBattery();

      final device = await _deviceDao.getPairedRing();
      if (device != null) await _deviceDao.updateLastSync(device.id);
      _lastSyncTime = DateTime.now();

      // Update home screen widget with fresh data
      await _updateHomeWidget();

      syncStatus.value = null;
    } catch (e) {
      debugPrint('RingSyncCoordinator: sync error: $e');
      syncStatus.value = null;
    } finally {
      _syncing = false;
    }
  }

  Future<void> _syncSleep() async {
    try {
      final session = await _ring.readSleep();
      if (session == null || session.stages.isEmpty) return;

      final companions = session.stages
          .map((s) => RingSleepStagesCompanion(
                nightDate: Value(session.nightDate),
                stage: Value(s.stage.label),
                startTime: Value(s.start),
                endTime: Value(s.end),
              ))
          .toList();
      await _dataDao.replaceSleepStages(session.nightDate, companions);

      final hour = DateTime.now().hour;
      if (hour >= 6 && hour < 12) {
        final summary = SleepSummary.fromSession(session);
        await _notifications.showSleepSummary(
          summary.notificationTitle,
          summary.notificationBody,
        );
      }

      await _hrvCheck.autoAttempt();
    } catch (e) {
      debugPrint('RingSyncCoordinator: sleep sync failed: $e');
    }
  }

  Future<void> _syncHrLog() async {
    try {
      final now = DateTime.now();
      for (final day in [now, now.subtract(const Duration(days: 1))]) {
        final log = await _ring.readHeartRateLog(day);
        if (log == null || log.heartRates.isEmpty) continue;

        final filtered = _processor.filterHrLog(log.heartRates);
        final readings = <RingHrSamplesCompanion>[];
        final dayStart = DateTime(day.year, day.month, day.day);

        for (var i = 0; i < filtered.length; i++) {
          if (filtered[i] <= 0) continue;
          readings.add(RingHrSamplesCompanion(
            timestamp: Value(dayStart.add(Duration(minutes: i * 5))),
            hr: Value(filtered[i]),
            source: const Value('log_sync'),
          ));
        }

        if (readings.isNotEmpty) {
          await _dataDao.replaceHrSamplesForDay(day, readings);
        }
      }
    } catch (e) {
      debugPrint('RingSyncCoordinator: HR log sync failed: $e');
    }
  }

  Future<void> _syncSteps() async {
    try {
      for (final daysAgo in [0, 1]) {
        final steps = await _ring.readSteps(daysAgo);
        if (steps == null || steps.isEmpty) continue;

        final day = DateTime.now().subtract(Duration(days: daysAgo));
        final companions = steps
            .map((s) => RingStepsCompanion(
                  timestamp: Value(s.timestamp),
                  steps: Value(s.steps),
                  calories: Value(s.calories),
                  distanceM: Value(s.distanceM),
                ))
            .toList();
        await _dataDao.replaceStepsForDay(day, companions);
      }
    } catch (e) {
      debugPrint('RingSyncCoordinator: steps sync failed: $e');
    }
  }

  Future<void> _updateHomeWidget() async {
    try {
      final hasRingSleep = await _dataDao.hasLastNightSleep();
      final fallbackPlan = const WorkoutPlan(
        dayName: 'Riposo',
        type: 'rest',
        exercises: [],
        estimatedMinutes: 0,
      );
      final protocol = await DailyProtocol.compute(
        workoutDao: _workoutDao,
        fastingDao: _fastingDao,
        conditioningDao: _conditioningDao,
        mealLogDao: _mealLogDao,
        todayWorkout: todayWorkout ?? fallbackPlan,
        weightKg: weightKg,
        tier: tier,
        sleepEnv: sleepEnv,
        hasRingSleep: hasRingSleep,
      );
      final steps = await _dataDao.getTodaySteps();
      await PhoenixHomeWidget.update(
        protocol: protocol,
        steps: steps > 0 ? steps : null,
      );
    } catch (e) {
      debugPrint('RingSyncCoordinator: widget update failed: $e');
    }
  }
}
