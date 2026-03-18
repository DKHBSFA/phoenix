import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import '../database/database.dart';
import '../database/daos/research_feed_dao.dart';
import '../notifications/notification_service.dart';
import '../research/research_fetcher.dart';
import '../research/research_evaluator.dart';

const kInactivityCheckTask = 'phoenix.inactivityCheck';
const kConditioningReminderTask = 'phoenix.conditioningReminder';
const kNightlyResearchTask = 'phoenix.nightlyResearch';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case kInactivityCheckTask:
          await _checkInactivity();
          break;
        case kConditioningReminderTask:
          await _checkConditioningToday();
          break;
        case kNightlyResearchTask:
          await _runNightlyResearch();
          break;
      }
      return true;
    } catch (e) {
      // Error logged silently — background tasks must not leak details
      return false;
    }
  });
}

Future<PhoenixDatabase> _openBackgroundDb() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'phoenix.sqlite'));
  return PhoenixDatabase.forTesting(NativeDatabase(file));
}

Future<NotificationService> _initNotifications() async {
  final notifications = NotificationService();
  await notifications.init();
  return notifications;
}

Future<void> _checkInactivity() async {
  final db = await _openBackgroundDb();

  try {
    final sessions = await (db.select(db.workoutSessions)
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .get();

    if (sessions.isEmpty) return;

    final lastWorkout = sessions.first.startedAt;
    final daysSince = DateTime.now().difference(lastWorkout).inDays;

    if (daysSince >= 2) {
      final notifications = await _initNotifications();
      await notifications.showNow(
        id: 5000,
        title: 'Inattivita rilevata',
        body: daysSince == 2
            ? 'Sono 2 giorni senza allenamento. Il protocollo ti aspetta.'
            : '$daysSince giorni senza allenamento. Riprendi oggi.',
      );
    }
  } finally {
    await db.close();
  }
}

Future<void> _checkConditioningToday() async {
  final now = DateTime.now();
  if (now.hour < 19) return;

  final db = await _openBackgroundDb();

  try {
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final count = await (db.select(db.conditioningSessions)
          ..where((s) =>
              s.date.isBiggerOrEqualValue(todayStart) &
              s.date.isSmallerThanValue(todayEnd)))
        .get();

    if (count.isEmpty) {
      final notifications = await _initNotifications();
      await notifications.showNow(
        id: 5001,
        title: 'Condizionamento',
        body: 'Nessuna sessione di condizionamento oggi. Ne fai una stasera?',
      );
    }
  } finally {
    await db.close();
  }
}

/// Nightly research task: fetch papers from PubMed/Europe PMC, evaluate with
/// keyword heuristics. Runs at ~03:00, only on Wi-Fi + charging.
Future<void> _runNightlyResearch() async {
  final db = await _openBackgroundDb();

  try {
    final dao = ResearchFeedDao(db);

    // Step 1: Fetch new papers
    final fetcher = ResearchFetcher(dao);
    final newPapers = await fetcher.fetchRecent(daysBack: 30);

    // Step 2: Evaluate (keyword heuristics in background — no LLM in background)
    final evaluator = ResearchEvaluator(dao);
    await evaluator.evaluateNew();

    // Step 3: Notify if high-impact papers found
    if (newPapers > 0) {
      final notifications = await _initNotifications();
      await notifications.showNow(
        id: 5002,
        title: 'Ricerca Phoenix',
        body: '$newPapers nuovi studi trovati. Apri il Coach per i dettagli.',
      );
    }
  } finally {
    await db.close();
  }
}
