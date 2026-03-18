# Spec: Chiudere i gap di implementazione

**Data:** 2026-03-12
**Stato:** Completato (2026-03-12)

---

## Cosa sto costruendo

Tre funzionalità mancanti che collegano logica già esistente ma non ancora cablata:
1. **Auto-progressione esercizi** — suggerimento avanzamento quando i criteri del protocollo sono soddisfatti
2. **Notifiche collegate** — attivare le notifiche workout/conditioning già scritte ma mai chiamate
3. **WorkManager background tasks** — task periodici per notifiche di inattività e conditioning serale

---

## Gap 1 — Auto-progressione esercizi

### Contesto dal protocollo

Da `references/phoenix-protocol.md` §2.6 e §2.7:

> **Criterio universale di progressione:** quando si completano tutte le serie al range massimo di reps previsto per **2 sessioni consecutive**, avanzare alla variante successiva.

Per corpo libero, la progressione avviene tramite catene (es. Wall Push-up -> Incline Push-up -> Standard Push-up). Il criterio RPE del protocollo: tutte le serie al limite superiore del range con RPE <=8.

### Stato attuale

- La tabella `ProgressionHistory` esiste in `tables.dart` (riga 183) ma non ha un DAO
- `Exercises` ha `progressionNextId` / `progressionPrevId` per le catene
- `WorkoutSets` salva `repsCompleted`, `repsTarget`, `rpe` per ogni set
- `_endSession()` in `workout_session_screen.dart` (riga 293) calcola score e chiude la sessione ma **non verifica progressione**

### Implementazione

#### 1.1 Creare `ProgressionDao`

**File nuovo:** `phoenix_app/lib/core/database/daos/progression_dao.dart`

```dart
@DriftAccessor(tables: [ProgressionHistory, Exercises, WorkoutSets, WorkoutSessions])
class ProgressionDao extends DatabaseAccessor<PhoenixDatabase>
    with _$ProgressionDaoMixin {
  ProgressionDao(super.db);

  /// Registra un avanzamento di progressione.
  Future<int> recordAdvancement({
    required int exerciseId,
    required int fromLevel,
    required int toLevel,
    required Map<String, dynamic> criteriaMet,
  });

  /// Verifica se un esercizio soddisfa i criteri di progressione.
  /// Ritorna l'exerciseId del prossimo esercizio nella catena, o null.
  Future<int?> checkProgressionCriteria({
    required int exerciseId,
    required int sessionId,
  });
}
```

Logica di `checkProgressionCriteria`:
1. Recupera l'esercizio corrente per ottenere `progressionNextId` — se null, non c'e' progressione possibile
2. Recupera le ultime 2 sessioni completate (con `endedAt != null`) che contengono set per questo esercizio
3. Per ciascuna sessione, verifica:
   - **Tutti** i set hanno `repsCompleted >= repsTarget` (completati al max)
   - **Tutti** i set hanno `rpe <= 8.0`
4. Se entrambe le sessioni soddisfano i criteri -> ritorna `progressionNextId`

Query chiave:
```sql
-- Ultime 2 sessioni con questo esercizio
SELECT DISTINCT ws.session_id, wo.started_at
FROM workout_sets ws
JOIN workout_sessions wo ON ws.session_id = wo.id
WHERE ws.exercise_id = :exerciseId
  AND wo.ended_at IS NOT NULL
ORDER BY wo.started_at DESC
LIMIT 2;

-- Per ogni sessione, verifica criteri
SELECT COUNT(*) as total,
       SUM(CASE WHEN reps_completed >= reps_target AND rpe <= 8.0 THEN 1 ELSE 0 END) as passing
FROM workout_sets
WHERE session_id = :sessionId AND exercise_id = :exerciseId;
-- Criterio soddisfatto se total == passing
```

#### 1.2 Creare modello `ProgressionCheck`

**File nuovo:** `phoenix_app/lib/core/models/progression_check.dart`

```dart
class ProgressionCheckResult {
  final int currentExerciseId;
  final String currentExerciseName;
  final int nextExerciseId;
  final String nextExerciseName;
  final int currentLevel;
  final int nextLevel;

  const ProgressionCheckResult({
    required this.currentExerciseId,
    required this.currentExerciseName,
    required this.nextExerciseId,
    required this.nextExerciseName,
    required this.currentLevel,
    required this.nextLevel,
  });
}
```

#### 1.3 Integrare in `_endSession()`

**File:** `phoenix_app/lib/features/workout/workout_session_screen.dart`
**Dove:** nel metodo `_endSession()`, dopo `dao.updateSessionSummary()` (riga ~324), prima del summary dialog

```dart
// Dopo updateSessionSummary e prima di showSummaryDialog:
final progressionDao = ref.read(progressionDaoProvider);
final exerciseDao = ref.read(exerciseDaoProvider);
final advancements = <ProgressionCheckResult>[];

for (final planned in _plan!.exercises) {
  final nextId = await progressionDao.checkProgressionCriteria(
    exerciseId: planned.exercise.id,
    sessionId: _sessionId!,
  );
  if (nextId != null) {
    final nextExercise = await exerciseDao.getById(nextId);
    advancements.add(ProgressionCheckResult(
      currentExerciseId: planned.exercise.id,
      currentExerciseName: planned.exercise.name,
      nextExerciseId: nextExercise.id,
      nextExerciseName: nextExercise.name,
      currentLevel: planned.exercise.phoenixLevel,
      nextLevel: nextExercise.phoenixLevel,
    ));
  }
}

if (advancements.isNotEmpty && mounted) {
  await _showProgressionDialog(advancements);
}
```

#### 1.4 Dialog di progressione

**File:** `workout_session_screen.dart` (nuovo metodo privato)

```dart
Future<void> _showProgressionDialog(List<ProgressionCheckResult> advancements) async {
  for (final adv in advancements) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Progressione disponibile!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${adv.currentExerciseName} (Lv. ${adv.currentLevel})'),
            const Icon(Icons.arrow_downward),
            Text('${adv.nextExerciseName} (Lv. ${adv.nextLevel})',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Hai completato 2 sessioni consecutive al massimo '
                'delle reps con RPE <=8. Vuoi avanzare?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Non ora'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Avanza'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final progressionDao = ref.read(progressionDaoProvider);
      await progressionDao.recordAdvancement(
        exerciseId: adv.currentExerciseId,
        fromLevel: adv.currentLevel,
        toLevel: adv.nextLevel,
        criteriaMet: {
          'sessions': 2,
          'criteria': 'all_sets_max_reps_rpe_le_8',
          'date': DateTime.now().toIso8601String(),
        },
      );
    }
  }
}
```

#### 1.5 Provider

**File:** `phoenix_app/lib/app/providers.dart`

```dart
final progressionDaoProvider = Provider<ProgressionDao>((ref) {
  return ProgressionDao(ref.watch(databaseProvider));
});
```

---

## Gap 2 — Notifiche collegate

### Stato attuale

- `NotificationService.scheduleWorkoutReminder()` esiste (riga 86) ma non viene mai chiamato
- `NotificationService.scheduleConditioningReminder()` esiste (riga 101) ma non viene mai chiamato
- `AppSettings` non ha campo per orario reminder
- `SettingsScreen` non ha time picker per reminder

### Implementazione

#### 2.1 Aggiungere campi reminder a `AppSettings`

**File:** `phoenix_app/lib/core/models/app_settings.dart`

Aggiungere:
```dart
final bool workoutReminderEnabled;
final String workoutReminderTime; // 'HH:mm' formato 24h, default '07:00'
final bool conditioningReminderEnabled;
final String conditioningReminderTime; // default '20:00'
final bool inactivityReminderEnabled; // default true
```

Con defaults: `workoutReminderEnabled: false`, `conditioningReminderEnabled: false`, `inactivityReminderEnabled: true`.

Aggiornare `copyWith`, `toJson`, `fromJson` di conseguenza.

#### 2.2 Aggiungere metodi a `SettingsNotifier`

**File:** `phoenix_app/lib/core/models/settings_notifier.dart`

```dart
Future<void> setWorkoutReminderEnabled(bool v) => update((s) => s.copyWith(workoutReminderEnabled: v));
Future<void> setWorkoutReminderTime(String v) => update((s) => s.copyWith(workoutReminderTime: v));
Future<void> setConditioningReminderEnabled(bool v) => update((s) => s.copyWith(conditioningReminderEnabled: v));
Future<void> setConditioningReminderTime(String v) => update((s) => s.copyWith(conditioningReminderTime: v));
Future<void> setInactivityReminderEnabled(bool v) => update((s) => s.copyWith(inactivityReminderEnabled: v));
```

#### 2.3 UI time picker nelle Settings

**File:** `phoenix_app/lib/features/settings/settings_screen.dart`

Aggiungere sezione "Notifiche" dopo la sezione "Coach":

```dart
// ── Notifiche ──
_SectionHeader('Notifiche'),
SwitchListTile(
  title: const Text('Promemoria allenamento'),
  subtitle: Text(settings.workoutReminderEnabled
      ? 'Ogni giorno alle ${settings.workoutReminderTime}'
      : 'Disattivato'),
  value: settings.workoutReminderEnabled,
  onChanged: (v) {
    settingsNotifier.setWorkoutReminderEnabled(v);
    if (v) _scheduleWorkoutReminder(ref, settings.workoutReminderTime);
    else _cancelWorkoutReminder(ref);
  },
),
if (settings.workoutReminderEnabled)
  ListTile(
    leading: const Icon(Icons.schedule),
    title: const Text('Orario promemoria'),
    trailing: Text(settings.workoutReminderTime),
    onTap: () async {
      final parts = settings.workoutReminderTime.split(':');
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        ),
      );
      if (picked != null) {
        final time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        settingsNotifier.setWorkoutReminderTime(time);
        _scheduleWorkoutReminder(ref, time);
      }
    },
  ),
SwitchListTile(
  title: const Text('Promemoria condizionamento serale'),
  subtitle: Text(settings.conditioningReminderEnabled
      ? 'Alle ${settings.conditioningReminderTime} se non hai fatto sessioni'
      : 'Disattivato'),
  value: settings.conditioningReminderEnabled,
  onChanged: (v) => settingsNotifier.setConditioningReminderEnabled(v),
),
SwitchListTile(
  title: const Text('Avviso inattivita (2+ giorni)'),
  value: settings.inactivityReminderEnabled,
  onChanged: (v) => settingsNotifier.setInactivityReminderEnabled(v),
),
```

#### 2.4 Scheduling helper functions

**File:** `phoenix_app/lib/core/notifications/notification_scheduler.dart` (nuovo)

```dart
class NotificationScheduler {
  final NotificationService _service;
  final WorkoutDao _workoutDao;
  final ConditioningDao _conditioningDao;

  NotificationScheduler(this._service, this._workoutDao, this._conditioningDao);

  /// Schedula promemoria allenamento giornaliero per domani all'ora indicata.
  Future<void> scheduleWorkoutReminder(String timeHHmm) async {
    final parts = timeHHmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _service.scheduleWorkoutReminder(
      id: 1, title: 'Allenamento', scheduledDate: scheduled,
    );
  }

  /// Cancella promemoria workout.
  Future<void> cancelWorkoutReminder() async {
    // ID 2001 (2000 + id=1)
    await _service.cancelNotification(2001);
  }

  /// Schedula promemoria conditioning serale se nessuna sessione oggi.
  Future<void> scheduleConditioningReminderIfNeeded(String timeHHmm) async {
    final todayCount = await _conditioningDao.getTodaySessionCount();
    if (todayCount > 0) return; // Gia' fatto oggi

    final parts = timeHHmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) return; // Troppo tardi per oggi

    await _service.scheduleConditioningReminder(
      id: 1, type: 'general', scheduledDate: scheduled,
    );
  }
}
```

#### 2.5 Aggiungere `cancelNotification` a `NotificationService`

**File:** `phoenix_app/lib/core/notifications/notification_service.dart`

```dart
Future<void> cancelNotification(int id) async {
  await _plugin.cancel(id);
}
```

#### 2.6 Reschedule dopo workout completato

**File:** `phoenix_app/lib/features/workout/workout_session_screen.dart`
**Dove:** in `_endSession()`, dopo il salvataggio (riga ~324)

```dart
// Reschedule workout reminder per domani
final settings = ref.read(settingsProvider);
if (settings.workoutReminderEnabled) {
  final scheduler = NotificationScheduler(
    ref.read(notificationServiceProvider),
    ref.read(workoutDaoProvider),
    ref.read(conditioningDaoProvider),
  );
  await scheduler.scheduleWorkoutReminder(settings.workoutReminderTime);
}
```

---

## Gap 3 — WorkManager background tasks

### Stato attuale

- `workmanager: ^0.5.2` in `pubspec.yaml` (riga 31) ma nessun import o uso nel codebase
- Nessun `callbackDispatcher` definito
- `main.dart` non inizializza WorkManager

### Implementazione

#### 3.1 Creare callback dispatcher

**File nuovo:** `phoenix_app/lib/core/background/background_tasks.dart`

```dart
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../database/database.dart';
import '../notifications/notification_service.dart';

const kInactivityCheckTask = 'phoenix.inactivityCheck';
const kConditioningReminderTask = 'phoenix.conditioningReminder';

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
      }
      return true;
    } catch (e) {
      return false;
    }
  });
}

Future<void> _checkInactivity() async {
  // Apri DB direttamente (siamo in Isolate background)
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'phoenix.sqlite'));
  final db = PhoenixDatabase.forTesting(NativeDatabase(file));

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
      final notifications = NotificationService();
      await notifications.init();
      await notifications._scheduleNotification(
        id: 5000,
        title: 'Inattivita rilevata',
        body: daysSince == 2
            ? 'Sono 2 giorni senza allenamento. Il protocollo ti aspetta.'
            : '$daysSince giorni senza allenamento. Riprendi oggi.',
        scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
      );
    }
  } finally {
    await db.close();
  }
}

Future<void> _checkConditioningToday() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'phoenix.sqlite'));
  final db = PhoenixDatabase.forTesting(NativeDatabase(file));

  try {
    final now = DateTime.now();
    // Solo se e' sera (dopo le 19)
    if (now.hour < 19) return;

    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final count = await (db.select(db.conditioningSessions)
          ..where((s) =>
              s.date.isBiggerOrEqualValue(todayStart) &
              s.date.isSmallerThanValue(todayEnd)))
        .get();

    if (count.isEmpty) {
      final notifications = NotificationService();
      await notifications.init();
      await notifications.scheduleConditioningReminder(
        id: 99,
        type: 'general',
        scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
      );
    }
  } finally {
    await db.close();
  }
}
```

**Nota:** `_scheduleNotification` e' private. Occorre aggiungere un metodo public `showImmediate()` a `NotificationService`, oppure rendere le notifiche background immediate con `_plugin.show()` invece di `zonedSchedule`. Alternativa migliore:

Aggiungere a `NotificationService`:
```dart
Future<void> showNow({
  required int id,
  required String title,
  required String body,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'phoenix_channel', 'Phoenix Protocol',
    channelDescription: 'Notifiche del Protocollo Phoenix',
    importance: Importance.high, priority: Priority.high,
  );
  const details = NotificationDetails(android: androidDetails);
  await _plugin.show(id, title, body, details);
}
```

Nei task background, usare `showNow()` al posto di `_scheduleNotification`.

#### 3.2 Inizializzare WorkManager in `main.dart`

**File:** `phoenix_app/lib/main.dart`

Aggiungere dopo `await notifications.requestPermissions()`:

```dart
import 'package:workmanager/workmanager.dart';
import 'core/background/background_tasks.dart';

// In main():
await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

// Task periodico: controlla inattivita ogni 24h
await Workmanager().registerPeriodicTask(
  'phoenix-inactivity-check',
  kInactivityCheckTask,
  frequency: const Duration(hours: 24),
  constraints: Constraints(networkType: NetworkType.not_required),
  existingWorkPolicy: ExistingWorkPolicy.keep,
);

// Task periodico: controlla conditioning serale ogni 12h
await Workmanager().registerPeriodicTask(
  'phoenix-conditioning-reminder',
  kConditioningReminderTask,
  frequency: const Duration(hours: 12),
  constraints: Constraints(networkType: NetworkType.not_required),
  existingWorkPolicy: ExistingWorkPolicy.keep,
);
```

#### 3.3 Verificare AndroidManifest

**File:** `phoenix_app/android/app/src/main/AndroidManifest.xml`

WorkManager richiede che il manifest contenga il provider (solitamente aggiunto automaticamente dal plugin). Verificare che sia presente:

```xml
<!-- Di solito aggiunto automaticamente, ma verificare -->
<provider
    android:name="androidx.startup.InitializationProvider"
    android:authorities="${applicationId}.androidx-startup"
    android:exported="false"
    tools:node="merge">
    <meta-data
        android:name="androidx.work.WorkManagerInitializer"
        android:value="androidx.startup" />
</provider>
```

Se gia' presente (di solito il plugin lo auto-configura), nessuna modifica necessaria.

---

## File da modificare — Riepilogo

### File nuovi (3)

| File | Scopo |
|------|-------|
| `phoenix_app/lib/core/database/daos/progression_dao.dart` | DAO per ProgressionHistory + logica check criteri |
| `phoenix_app/lib/core/models/progression_check.dart` | Modello risultato check progressione |
| `phoenix_app/lib/core/background/background_tasks.dart` | CallbackDispatcher + task WorkManager |

### File modificati (7)

| File | Cosa cambia |
|------|-------------|
| `phoenix_app/lib/core/models/app_settings.dart` | +5 campi reminder (enabled, time, inactivity) |
| `phoenix_app/lib/core/models/settings_notifier.dart` | +5 metodi setter per reminder |
| `phoenix_app/lib/core/notifications/notification_service.dart` | +`cancelNotification()`, +`showNow()` |
| `phoenix_app/lib/features/workout/workout_session_screen.dart` | `_endSession()`: +check progressione, +reschedule reminder. +`_showProgressionDialog()` |
| `phoenix_app/lib/features/settings/settings_screen.dart` | +sezione Notifiche con switch e time picker |
| `phoenix_app/lib/app/providers.dart` | +`progressionDaoProvider` |
| `phoenix_app/lib/main.dart` | +import WorkManager, +`callbackDispatcher` init, +task periodici registrati |

### File da rigenerare (1)

| File | Motivo |
|------|--------|
| `phoenix_app/lib/core/database/daos/progression_dao.g.dart` | Generato da `build_runner` dopo creazione `progression_dao.dart` |

---

## Ordine di implementazione

1. `progression_check.dart` (modello, nessuna dipendenza)
2. `progression_dao.dart` + run `build_runner` per generare `.g.dart`
3. `providers.dart` (aggiungere `progressionDaoProvider`)
4. `app_settings.dart` + `settings_notifier.dart` (campi reminder)
5. `notification_service.dart` (metodi `cancelNotification`, `showNow`)
6. `settings_screen.dart` (sezione Notifiche)
7. `workout_session_screen.dart` (progressione + reschedule)
8. `background_tasks.dart` (task WorkManager)
9. `main.dart` (init WorkManager)

---

## Verifica

- [ ] **Progressione:** completare 2 sessioni con tutti i set a max reps e RPE <=8 -> compare dialog "Progressione disponibile"
- [ ] **Progressione:** confermare avanzamento -> nuova riga in `progression_history`
- [ ] **Progressione:** rifiutare -> nessuna modifica al DB
- [ ] **Progressione:** esercizio senza `progressionNextId` -> nessun dialog
- [ ] **Progressione:** 1 sola sessione al massimo -> nessun dialog (servono 2 consecutive)
- [ ] **Notifiche workout:** attivare in Settings -> notifica arriva all'ora impostata
- [ ] **Notifiche workout:** cambiare orario -> vecchia cancellata, nuova schedulata
- [ ] **Notifiche workout:** completare allenamento -> reminder reschedulato per domani
- [ ] **Notifiche conditioning:** sera senza sessioni -> notifica serale arriva
- [ ] **Notifiche conditioning:** sessione fatta oggi -> nessuna notifica
- [ ] **Inattivita:** 2+ giorni senza workout -> notifica WorkManager
- [ ] **WorkManager:** task registrati al boot dell'app (verificare con `adb shell dumpsys jobscheduler`)
- [ ] **Settings UI:** time picker funziona, orario salvato e persistito
- [ ] **Settings UI:** toggle attiva/disattiva correttamente
- [ ] **Build:** `flutter analyze` senza errori
- [ ] **Build:** `dart run build_runner build` genera `progression_dao.g.dart` senza errori
