import '../database/daos/assessment_dao.dart';
import '../database/daos/conditioning_dao.dart';
import '../database/daos/workout_dao.dart';
import '../models/sleep_environment.dart';
import 'notification_service.dart';

class NotificationScheduler {
  final NotificationService _service;
  // ignore: unused_field — reserved for workout-specific reminders
  final WorkoutDao _workoutDao;
  final ConditioningDao _conditioningDao;
  final AssessmentDao? _assessmentDao;

  NotificationScheduler(this._service, this._workoutDao, this._conditioningDao, [this._assessmentDao]);

  /// Schedules daily workout reminder for the next occurrence of [timeHHmm].
  Future<void> scheduleWorkoutReminder(String timeHHmm) async {
    final parsed = _parseTime(timeHHmm);
    if (parsed == null) return;
    final (hour, minute) = parsed;
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _service.scheduleWorkoutReminder(
      id: 1,
      title: 'Allenamento',
      scheduledDate: scheduled,
    );
  }

  /// Cancels the workout reminder.
  Future<void> cancelWorkoutReminder() async {
    await _service.cancelNotification(2001);
  }

  /// Schedules evening conditioning reminder if no session done today.
  Future<void> scheduleConditioningReminderIfNeeded(String timeHHmm) async {
    final todayCount = await _conditioningDao.getTodaySessionCount();
    if (todayCount > 0) return;

    final parsed = _parseTime(timeHHmm);
    if (parsed == null) return;
    final (hour, minute) = parsed;
    final now = DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) return;

    await _service.scheduleConditioningReminder(
      id: 1,
      type: 'general',
      scheduledDate: scheduled,
    );
  }

  /// Schedule assessment reminder for 28 days after the last assessment.
  /// If no assessment exists, schedules for tomorrow at 09:00.
  Future<void> scheduleAssessmentReminderIfNeeded() async {
    if (_assessmentDao == null) return;

    final latest = await _assessmentDao.getLatest();
    DateTime reminderDate;

    final now = DateTime.now();
    if (latest == null) {
      // No assessments yet — remind tomorrow at 09:00
      reminderDate = DateTime(now.year, now.month, now.day + 1, 9, 0);
    } else {
      // 28 days after last assessment, at 09:00
      final due = latest.date.add(const Duration(days: 28));
      reminderDate = DateTime(due.year, due.month, due.day, 9, 0);
      if (reminderDate.isBefore(now)) {
        // Already due — remind tomorrow
        reminderDate = DateTime(now.year, now.month, now.day + 1, 9, 0);
      }
    }

    await _service.scheduleAssessmentReminder(scheduledDate: reminderDate);
  }

  /// Cancel the assessment reminder.
  Future<void> cancelAssessmentReminder() async {
    await _service.cancelAssessmentReminder();
  }

  /// Schedule physical reassessment reminder based on nextReassessmentDate from settings.
  Future<void> scheduleReassessmentReminder(String? nextReassessmentDate) async {
    if (nextReassessmentDate == null) return;
    final date = DateTime.tryParse(nextReassessmentDate);
    if (date == null) return;

    final now = DateTime.now();
    var reminderDate = DateTime(date.year, date.month, date.day, 9, 0);
    if (reminderDate.isBefore(now)) {
      // Already past due — remind tomorrow
      reminderDate = DateTime(now.year, now.month, now.day + 1, 9, 0);
    }
    await _service.scheduleReassessmentReminder(scheduledDate: reminderDate);
  }

  /// Cancel the physical reassessment reminder.
  Future<void> cancelReassessmentReminder() async {
    await _service.cancelReassessmentReminder();
  }

  /// Schedule sleep environment reminders (caffeine, blue light, temperature).
  /// Cancels existing sleep reminders first, then schedules based on config.
  Future<void> scheduleSleepEnvironmentReminders(SleepEnvironment env) async {
    await _service.cancelSleepEnvironmentReminders();

    final now = DateTime.now();

    // Caffeine cutoff — schedule for today or tomorrow
    if (env.caffeineReminder) {
      final cutoff = env.caffeineCutoff;
      final cutoffStr =
          '${cutoff.hour.toString().padLeft(2, '0')}:${cutoff.minute.toString().padLeft(2, '0')}';
      var scheduled =
          DateTime(now.year, now.month, now.day, cutoff.hour, cutoff.minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _service.scheduleSleepCaffeineReminder(
        scheduledDate: scheduled,
        cutoffTime: cutoffStr,
      );
    }

    // Blue light cutoff — evening notification
    if (env.blueLightReminder) {
      final cutoff = env.blueLightCutoff;
      var scheduled =
          DateTime(now.year, now.month, now.day, cutoff.hour, cutoff.minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _service.scheduleSleepBlueLightReminder(scheduledDate: scheduled);
    }

    // Temperature — 30min before bedtime
    if (env.temperatureReminder) {
      final tempTime = env.temperatureReminderTime;
      var scheduled =
          DateTime(now.year, now.month, now.day, tempTime.hour, tempTime.minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _service.scheduleSleepTemperatureReminder(scheduledDate: scheduled);
    }
  }

  /// Cancel all sleep environment reminders.
  Future<void> cancelSleepEnvironmentReminders() async {
    await _service.cancelSleepEnvironmentReminders();
  }

  /// Parse "HH:mm" string safely. Returns null on invalid input.
  static (int, int)? _parseTime(String timeHHmm) {
    final parts = timeHHmm.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return (hour, minute);
  }
}
