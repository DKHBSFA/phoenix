import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../database/tables.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );
    await _plugin.initialize(settings);
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // -- Fasting notifications --

  Future<void> scheduleFastingMilestones(DateTime fastStart) async {
    const milestoneHours = [12, 14, 16, 24, 36, 48, 72];

    for (final hours in milestoneHours) {
      final milestoneTime = fastStart.add(Duration(hours: hours));
      if (milestoneTime.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: 1000 + hours,
          title: 'Digiuno: ${hours}h raggiunte',
          body: _fastingMilestoneMessage(hours),
          scheduledDate: milestoneTime,
        );
      }
    }
  }

  Future<void> cancelFastingMilestones() async {
    const milestoneHours = [12, 14, 16, 24, 36, 48, 72];
    for (final hours in milestoneHours) {
      await _plugin.cancel(1000 + hours);
    }
  }

  String _fastingMilestoneMessage(int hours) {
    switch (hours) {
      case 12:
        return 'Autofagia in avvio. Continua cosi.';
      case 14:
        return '14 ore. Il corpo sta accelerando la pulizia cellulare.';
      case 16:
        return '16 ore complete! Livello 1 raggiunto.';
      case 24:
        return '24 ore. Autofagia profonda attiva.';
      case 36:
        return '36 ore. Rigenerazione cellulare in corso.';
      case 48:
        return '48 ore. Livello 2 completo. Grande risultato.';
      case 72:
        return '72 ore! Livello 3. Massima autofagia raggiunta.';
      default:
        return '$hours ore di digiuno completate.';
    }
  }

  // -- Workout reminders --

  Future<void> scheduleWorkoutReminder({
    required int id,
    required String title,
    required DateTime scheduledDate,
  }) async {
    await _scheduleNotification(
      id: 2000 + id,
      title: title,
      body: 'E ora di allenarsi. Il protocollo ti aspetta.',
      scheduledDate: scheduledDate,
    );
  }

  // -- Conditioning reminders --

  Future<void> scheduleConditioningReminder({
    required int id,
    required String type,
    required DateTime scheduledDate,
  }) async {
    final messages = {
      ConditioningType.cold: 'Doccia fredda programmata. Preparati.',
      ConditioningType.meditation: 'Momento meditazione. Trova uno spazio tranquillo.',
      ConditioningType.sleep: 'Promemoria sonno. Inizia la routine serale.',
    };

    await _scheduleNotification(
      id: 3000 + id,
      title: 'Condizionamento: $type',
      body: messages[type] ?? 'Sessione di condizionamento programmata.',
      scheduledDate: scheduledDate,
    );
  }

  // -- Assessment reminders --

  Future<void> scheduleAssessmentReminder({
    required DateTime scheduledDate,
  }) async {
    await _scheduleNotification(
      id: 4001,
      title: 'Assessment periodico',
      body: 'Sono passate 4 settimane. Misura i tuoi progressi con i 5 test.',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> cancelAssessmentReminder() async {
    await _plugin.cancel(4001);
  }

  // -- Physical reassessment (3-month) --

  Future<void> scheduleReassessmentReminder({
    required DateTime scheduledDate,
  }) async {
    await _scheduleNotification(
      id: 5001,
      title: 'Check-up fisico',
      body: 'Sono passati 3 mesi dall\'ultimo assessment. Come sta andando? Aggiorniamo il tuo programma.',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> cancelReassessmentReminder() async {
    await _plugin.cancel(5001);
  }

  // -- Sleep environment reminders --

  static const _sleepCaffeineId = 6001;
  static const _sleepBlueLightId = 6002;
  static const _sleepTemperatureId = 6003;

  Future<void> scheduleSleepCaffeineReminder({
    required DateTime scheduledDate,
    required String cutoffTime,
  }) async {
    await _scheduleNotification(
      id: _sleepCaffeineId,
      title: 'Ultimo caffè',
      body: 'Dopo le $cutoffTime la caffeina interferisce con il sonno (Drake 2013)',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> scheduleSleepBlueLightReminder({
    required DateTime scheduledDate,
  }) async {
    await _scheduleNotification(
      id: _sleepBlueLightId,
      title: 'Blue Light Off',
      body: 'Spegni schermi o attiva filtro luce blu — il sonno inizia ora',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> scheduleSleepTemperatureReminder({
    required DateTime scheduledDate,
  }) async {
    await _scheduleNotification(
      id: _sleepTemperatureId,
      title: 'Camera pronta',
      body: 'Imposta la camera a 18-19°C e oscura le luci',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> cancelSleepEnvironmentReminders() async {
    await _plugin.cancel(_sleepCaffeineId);
    await _plugin.cancel(_sleepBlueLightId);
    await _plugin.cancel(_sleepTemperatureId);
  }

  // -- Sleep summary --

  static const _sleepSummaryId = 7001;

  /// Show sleep summary notification.
  Future<void> showSleepSummary(String title, String body) async {
    await showNow(id: _sleepSummaryId, title: title, body: body);
  }

  // -- Cancel / Show Now --

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'phoenix_channel',
      'Phoenix Protocol',
      channelDescription: 'Notifiche del Protocollo Phoenix',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, details);
  }

  // -- Private --

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'phoenix_channel',
      'Phoenix Protocol',
      channelDescription: 'Notifiche del Protocollo Phoenix',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
