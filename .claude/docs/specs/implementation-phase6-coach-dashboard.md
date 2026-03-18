# Fase 6: Coach AI + Dashboard

**Prerequisiti:** Tutte le fasi precedenti (serve dati reali da ogni pilastro)
**Output:** Dashboard con activity rings e dati reali, coach che genera report strutturati, notifiche.

---

## 6.1 Dashboard Ridisegnata

### Attualmente

La home mostra card statiche con dati mock e tasto che naviga direttamente al workout.

### Nuovo layout

**Sezione 1: Activity Rings (Hero)**

3 anelli concentrici sovrapposti (stile Apple Watch ma con colori Phoenix):
- **Esterno (amber):** Training — % completamento allenamento del giorno
- **Medio (cyan):** Fasting — % progresso digiuno attivo (o completato oggi)
- **Interno (violet):** Conditioning — sessioni condizionamento oggi / target

Implementazione con `CustomPainter`:
```dart
class ActivityRingsPainter extends CustomPainter {
  final double trainingProgress; // 0.0 - 1.0
  final double fastingProgress;
  final double conditioningProgress;

  // 3 archi con strokeWidth diverso, gap tra anelli
  // Animazione: fill progressivo con curva easeOutCubic
}
```

**Sotto gli anelli:** 3 label con valore:
- "Allenamento: completato" / "da fare"
- "Digiuno: 14h/16h" / "non attivo"
- "Condizionamento: 2/3 sessioni"

**Sezione 2: One Big Thing**

Card principale con la prossima azione suggerita:
- Se non ha fatto allenamento oggi → "Allenamento del giorno: Upper Push"
- Se digiuno attivo → "Digiuno in corso: mancano 3h al target"
- Se 2+ giorni senza allenamento → "Sono 2 giorni che non ti alleni. Tutto bene?"
- Se analisi sangue > 3 mesi fa → "È ora di fare le analisi del sangue"

Logica priorità:
1. Alert biomarker attivi (rosso)
2. Allenamento non fatto oggi (amber)
3. Digiuno attivo — stato (cyan)
4. Condizionamento mancante oggi (violet)
5. Insight positivo ("Streak freddo: 7 giorni!")

**Sezione 3: Quick Actions (2 colonne)**

4 card tappabili:
- "Inizia allenamento" → Training tab
- "Inizia digiuno" → Fasting tab
- "Log condizionamento" → Conditioning tab
- "Aggiungi biomarker" → Biomarkers tab

**Sezione 4: Stats Cards (2 colonne)**

Dati reali dal DB:
- PhenoAge (se calcolato) + trend
- Peso attuale + delta
- Streak allenamento (giorni consecutivi)
- Sonno medio settimana

---

## 6.2 Coach — Report Strutturati

### Approccio senza LLM (template-based)

Dato che il modello BitNet non è ancora integrato, i report vengono generati da template con dati reali. Quando l'LLM sarà disponibile, i template vengono sostituiti dalla generazione.

### Tipi di report

**Post-workout:**
```
Generato automaticamente dopo ogni sessione.

Struttura:
- Esercizi completati (nome × set × reps)
- RPE medio della sessione
- Duration score (verde/giallo/rosso) + spiegazione
- Confronto con sessione precedente dello stesso tipo
- Suggerimento: "Volume in linea" / "Considera deload" / "Progressione possibile"
```

**Weekly:**
```
Generabile dal tab Coach, chip "Settimanale".

Struttura:
- Sessioni completate / pianificate (es. 5/7)
- Aderenza digiuno (sessioni completate, livello attuale)
- Condizionamento streak
- Peso trend (se loggato)
- Punti di forza: cosa è andato bene
- Aree di miglioramento: cosa manca
```

**Fasting:**
```
Dopo ogni digiuno completato.

Struttura:
- Durata raggiunta vs target
- Livello attuale + progresso verso criteri avanzamento
- Tolleranza riportata
- Suggerimento: "Pronto per livello 2" / "Continua a consolidare"
```

### Implementazione

`lib/core/models/report_generator.dart` — **NUOVO**

```dart
class ReportGenerator {
  final PhoenixDatabase db;

  Future<String> generatePostWorkout(int sessionId) async {
    final session = await db.workoutDao.getSession(sessionId);
    final sets = await db.workoutDao.getSetsForSession(sessionId);
    // ... costruire report da template
  }

  Future<String> generateWeekly() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));
    final sessions = await db.workoutDao.getSessionsInRange(weekStart, now);
    final fasts = await db.fastingDao.getSessionsInRange(weekStart, now);
    // ... costruire report da template
  }
}
```

### UI Coach Screen

**Stato attuale:** Chat vuota con input.

**Nuovo layout:**

**Header: Stato modello**
- Se LLM non disponibile: "Coach template-based (LLM offline)"
- Se disponibile: "Phoenix Coach AI — Pronto"

**Report chips (scrollabili orizzontalmente):**
- "Ultimo allenamento" → genera/mostra post-workout dell'ultima sessione
- "Questa settimana" → genera weekly
- "Digiuno" → report fasting
- "Progressioni" → overview avanzamenti

**Area report:**
- Report mostrato come card formattata (non chat)
- Markdown semplice renderizzato (titoli, bullet, bold)
- Data generazione
- Tasto "Rigenera" per aggiornare

**Chat (futuro):**
- Per ora: disabilitata con messaggio "Chat con AI Coach disponibile quando il modello sarà scaricato"
- Input field grigio, non interagibile

---

## 6.3 Notifiche Background

### Tipi (dal protocollo)

1. **Milestone digiuno:** 12h, 16h, 18h, 24h → già implementato in `NotificationService`, collegare
2. **Reminder allenamento:** Giornaliero a orario fisso (configurabile in settings)
3. **Reminder condizionamento:** "Non hai fatto la doccia fredda oggi"
4. **Motivazionale:** Se 2+ giorni senza attività → "Sono X giorni che non ti alleni"

### Implementazione

Il `NotificationService` esiste ma non è collegato. Collegare:

```dart
// In fase di avvio app (main.dart o HomeScreen initState)
final notifications = ref.read(notificationServiceProvider);
await notifications.initialize();

// Dopo inizio digiuno
await notifications.scheduleFastingMilestones(startTime, targetHours);

// Settings: orario reminder allenamento
await notifications.scheduleWorkoutReminder(timeOfDay);
```

### WorkManager (background)

Per Android, registrare task periodico:

```dart
Workmanager().registerPeriodicTask(
  'inactivity_check',
  'checkInactivity',
  frequency: Duration(hours: 24),
);
```

Callback: controlla ultima sessione allenamento. Se > 2 giorni → notifica.

---

## 6.4 File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/models/report_generator.dart` | **Nuovo** — generazione report template |
| `lib/core/models/activity_rings_data.dart` | **Nuovo** — calcolo progress anelli |
| `lib/features/workout/home_screen.dart` | **Riscritto** — dashboard con rings + dati reali |
| `lib/features/workout/widgets/activity_rings.dart` | **Nuovo** — CustomPainter 3 anelli |
| `lib/features/coach/coach_screen.dart` | **Riscritto** — report chips + area report |
| `lib/core/notifications/notification_service.dart` | Collegare a flussi reali |
| `lib/main.dart` | Inizializzare notifiche + WorkManager |

---

## 6.5 Verifica completamento

- [ ] Dashboard mostra 3 activity rings con dati reali
- [ ] "One Big Thing" card con suggerimento contestuale
- [ ] Quick actions navigano ai tab corretti
- [ ] Stats cards con dati dal DB
- [ ] Coach genera report post-workout (template)
- [ ] Coach genera report settimanale (template)
- [ ] Report mostrati come card formattate
- [ ] Chat disabilitata con messaggio chiaro
- [ ] Notifiche milestone digiuno funzionanti
- [ ] Reminder allenamento configurabile
- [ ] `flutter analyze` 0 errors

---

## 6.6 Post-Fase 6 (Backlog futuro)

Queste funzionalità NON sono in scope per le 6 fasi ma vanno sviluppate dopo:

- **LLM on-device:** Download modello BitNet, FFI integration, Isolate inference
- **Wearable sync:** Apple Health / Google Health Connect per HRV + sleep auto
- **PDF OCR:** Import automatico analisi sangue da foto/PDF
- **Esercizi GIF/video:** Sostituire placeholder con animazioni reali
- **Periodizzazione avanzata:** DUP (tier 2), block (tier 3)
- **Velocity-Based Training:** Integrazione accelerometro per tier 3
- **Export dati:** CSV/JSON per portabilità
- **Backup/restore:** Salvataggio DB su file
