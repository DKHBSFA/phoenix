# Fase 2: Exercise DB + Training Flow

**Prerequisiti:** Fase 1 (profilo utente con tier + equipment)
**Output:** DB esercizi popolato, allenamento del giorno generato, sessione guidata completa.

---

## 2.1 Seed Exercise Database

### Fonte dati

Tutti gli esercizi vengono da `references/phoenix-protocol.md` sezione 2 (Training).

### Struttura dati seed

Creare `lib/core/database/seed/exercise_seed.dart` con una lista di `ExercisesCompanion`:

**5 categorie × ~10 esercizi ciascuno × 3 varianti equipment = ~150 record**

Ma nel DB ogni variante è un record separato con campo `equipment` (da aggiungere alla tabella).

### Modifica tabella Exercises

Aggiungere colonne:

```dart
TextColumn get equipment => text().withDefault(const Constant('all'))();
// 'gym' / 'home' / 'bodyweight' / 'all'

TextColumn get executionCues => text().withDefault(const Constant(''))();
// Cue di esecuzione in italiano (dalla sezione 2.7 del protocollo)

IntColumn get defaultSets => integer().withDefault(const Constant(3))();
IntColumn get defaultRepsMin => integer().withDefault(const Constant(8))();
IntColumn get defaultRepsMax => integer().withDefault(const Constant(12))();
IntColumn get defaultTempoEcc => integer().withDefault(const Constant(3))();
IntColumn get defaultTempoCon => integer().withDefault(const Constant(2))();
TextColumn get dayType => text().withDefault(const Constant(''))();
// 'push' / 'pull' / 'squat' / 'hinge' / 'core' / 'cardio' / 'power'
// Quale giorno della settimana usa questo esercizio
```

### Esercizi da inserire (dal protocollo)

**Push (Giorno 1 - Upper Push):**

| Livello | Gym | Home | Bodyweight |
|---------|-----|------|------------|
| 1 | Chest Press machine | Floor press manubri | Wall push-up |
| 2 | Bench Press bilanciere | DB bench press | Incline push-up |
| 3 | Incline Bench Press | DB incline press | Push-up standard |
| 4 | DB Shoulder Press | KB press | Diamond push-up |
| 5 | Weighted Dip | Ring dip | Archer push-up |
| 6 | Barbell OHP | — | Planche progression |

+ accessori: tricep extension, lateral raise, face pull

**Pull (Giorno 4 - Upper Pull):**

| Livello | Gym | Home | Bodyweight |
|---------|-----|------|------------|
| 1 | Lat pulldown | Band pull-apart | Dead hang |
| 2 | Seated row | DB row | Australian row |
| 3 | Barbell row | KB row | Pull-up negatives |
| 4 | Pull-up | Weighted row | Pull-up |
| 5 | Weighted pull-up | — | Archer pull-up |
| 6 | Muscle-up prog | — | Muscle-up |

+ accessori: bicep curl, rear delt fly, face pull

**Squat (Giorno 2 - Lower Quad):**

| Livello | Gym | Home | Bodyweight |
|---------|-----|------|------------|
| 1 | Leg press | Goblet squat | Assisted squat |
| 2 | Back squat | DB squat | Bodyweight squat |
| 3 | Front squat | Bulgarian split squat DB | Bulgarian split squat |
| 4 | Pause squat | Pistol progression | Shrimp squat |
| 5 | ATG squat | — | Pistol squat |
| 6 | Olympic squat | — | Weighted pistol |

+ accessori: leg extension, calf raise, lunges

**Hinge (Giorno 5 - Lower Hip):**

| Livello | Gym | Home | Bodyweight |
|---------|-----|------|------------|
| 1 | Leg curl | KB deadlift | Glute bridge |
| 2 | Romanian DL | DB RDL | Single leg bridge |
| 3 | Conventional DL | KB swing | Nordic curl negative |
| 4 | Sumo DL | Single leg RDL | Nordic curl |
| 5 | Deficit DL | — | Single leg nordic |
| 6 | Snatch grip DL | — | Full nordic curl |

+ accessori: hip thrust, hamstring curl, back extension

**Core (tutti i giorni, 2-3 esercizi):**

| Livello | Esercizio |
|---------|-----------|
| 1 | Dead bug, Bird dog |
| 2 | Plank, Side plank |
| 3 | Ab wheel (knees), Pallof press |
| 4 | Hanging knee raise, Ab wheel standing |
| 5 | Dragon flag negative, L-sit |
| 6 | Dragon flag, Front lever progression |

### Seed loading

In `database.dart`, al primo avvio (o se tabella vuota):

```dart
Future<void> seedExercises() async {
  final count = await (select(exercises)..limit(1)).get();
  if (count.isEmpty) {
    await batch((b) {
      b.insertAll(exercises, exerciseSeedData);
    });
  }
}
```

Chiamare `seedExercises()` dopo la creazione del DB.

### ExerciseDao

```dart
// lib/core/database/daos/exercise_dao.dart — NUOVO

class ExerciseDao extends DatabaseAccessor<PhoenixDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(PhoenixDatabase db) : super(db);

  // Esercizi per categoria, livello, equipment
  Future<List<Exercise>> getForWorkout({
    required String category,
    required int maxLevel,
    required String equipment,
  }) {
    return (select(exercises)
      ..where((e) => e.category.equals(category))
      ..where((e) => e.phoenixLevel.isSmallerOrEqualValue(maxLevel))
      ..where((e) => e.equipment.isIn([equipment, 'all']))
      ..orderBy([(e) => OrderingTerm.desc(e.phoenixLevel)])
      ..limit(1)
    ).get();
    // Ritorna l'esercizio di livello più alto disponibile per l'utente
  }

  // Tutti gli esercizi di una categoria (per progressioni)
  Future<List<Exercise>> getProgressionChain(String category, String equipment) {
    return (select(exercises)
      ..where((e) => e.category.equals(category))
      ..where((e) => e.equipment.isIn([equipment, 'all']))
      ..orderBy([(e) => OrderingTerm.asc(e.phoenixLevel)])
    ).get();
  }

  // Singolo esercizio per ID
  Future<Exercise> getById(int id) {
    return (select(exercises)..where((e) => e.id.equals(id))).getSingle();
  }
}
```

---

## 2.2 Generazione Allenamento del Giorno

### Workout Generator

`lib/core/models/workout_generator.dart` — **NUOVO**

Logica basata sul protocollo Phoenix (sezione 2.1):

```
Giorno della settimana → Tipo allenamento:
  Lunedì (1) → Upper Push (strength)
  Martedì (2) → Lower Quad (strength)
  Mercoledì (3) → Active Recovery (cardio + flexibility)
  Giovedì (4) → Upper Pull (strength)
  Venerdì (5) → Lower Hinge (strength)
  Sabato (6) → Active Recovery (cardio + flexibility)
  Domenica (7) → Full Body Power/Skill
```

```dart
class WorkoutPlan {
  final String dayName; // "Upper Push", "Lower Quad", etc.
  final String type; // WorkoutType.strength, cardio, power
  final List<PlannedExercise> exercises;
  final int estimatedMinutes;
}

class PlannedExercise {
  final Exercise exercise; // dal DB
  final int sets;
  final int repsMin;
  final int repsMax;
  final int tempoEcc;
  final int tempoCon;
  final int restSeconds;
}
```

**Parametrizzazione per Tier** (dal protocollo sezione 2.2):

| Parametro | Beginner | Intermediate | Advanced |
|-----------|----------|--------------|----------|
| Esercizi/sessione | 4-5 | 5-6 | 5-7 |
| Serie/esercizio | 3 | 3-4 | 4-5 |
| Reps | 10-15 | 6-12 (DUP) | 1-8 (block) |
| Rest compound | 150s (+30s) | 150s | 150s (-15s o +30s) |
| Rest accessorio | 90s (+30s) | 90s | 90s |

**Selezione esercizi:**
1. Query DB per categoria + tier level + equipment
2. Prendere 2-3 compound (livello più alto disponibile)
3. Prendere 2-3 accessori (livello precedente o stesso)
4. Aggiungere 2 core

---

## 2.3 Training Tab Redesign

### Struttura navigazione attuale
Premere "Training" nel bottom nav → `Navigator.push(WorkoutSessionScreen)`

### Nuovo flusso
Premere "Training" nel bottom nav → mostra `TrainingScreen` (nel body dell'IndexedStack, indice 1)

**`TrainingScreen`** contiene:

**Sezione superiore: Allenamento del giorno**
- Card grande con:
  - Nome giorno: "Upper Push" / "Active Recovery" / etc.
  - Tipo: Forza / Cardio / Power
  - Numero esercizi: "5 esercizi • ~55 min"
  - Lista preview esercizi (nome + serie × reps)
  - **Tasto "Inizia allenamento"** (grande, amber, full width) → push `WorkoutSessionScreen`

**Sezione inferiore: Storico recente**
- Ultime 5 sessioni: data, tipo, durata, duration score (pallino colorato)

**Se giorno di Active Recovery:**
- Card con suggerimenti: "Zone 2 cardio 20-30 min" + "Stretching PNF 15 min"
- Timer semplice (senza esercizi guidati)

### File

- `lib/features/training/training_screen.dart` — **NUOVO** (sostituisce la navigazione diretta a workout)
- Aggiornare `home_screen.dart`: indice 1 nel body mostra `TrainingScreen` invece di push a `WorkoutSessionScreen`

---

## 2.4 Workout Session Migliorata

### Pre-exercise flow

Quando inizia un nuovo esercizio (primo della sessione o dopo completamento del precedente):

1. **Schermata preview esercizio** (2-5 secondi, o finché utente preme "Pronto"):
   - Nome esercizio (H1)
   - Immagine placeholder: icona grande per gruppo muscolare (da sostituire con GIF in futuro)
   - Muscoli target (chips: "Pettorali", "Deltoidi anteriori", "Tricipiti")
   - Serie × Reps target: "3 × 10-12"
   - Se `settings.coachExplanation == true`:
     - Coach TTS legge `executionCues` dell'esercizio
     - Mostra cue come testo sotto l'immagine
   - Tasto "Pronto" → avvia countdown

2. **Countdown** (3 o 5 secondi):
   - Numeri grandi al centro (display font)
   - Beep audio per ogni secondo
   - Beep doppio allo 0 → inizia tracking serie

3. **Tracking serie** (come attuale ma migliorato):
   - Reps counter con ±
   - RPE slider (già esiste)
   - Se metronomo attivo: beep eccentric/concentric
   - Tasto "Serie completata"

4. **Rest timer** (già esiste, migliorare):
   - Tempo adattivo dal protocollo (non fisso)
   - Mostrare "Prossimo: Serie 2/3" o "Prossimo esercizio: Pull-up"
   - Skip button

### Storico set inline

Sotto il counter reps, mostrare set precedenti della stessa sessione:

```
Set 1: 12 reps @ RPE 7
Set 2: 10 reps @ RPE 8
Set 3: ← (corrente)
```

### Duration score reale

Collegare `DurationScoreCalculator` a dati reali dal DB:
- Query ultime 8 sessioni dello stesso tipo
- Calcolare media e SD
- Mostrare risultato nel dialog fine sessione

### Modifica WorkoutSessionScreen

Il file attuale (`workout_session_screen.dart`) va **riscritto** per:
- Ricevere `WorkoutPlan` come parametro (non più mock hardcoded)
- Implementare il flusso pre-exercise → countdown → tracking → rest
- Leggere settings per coach/metronomo
- Salvare set reali nel DB con `exerciseId` dal DB (non mock)

---

## 2.5 Progressioni reali

### Collegamento a DB

`ProgressionsScreen` attualmente usa dati mock. Collegare a:
- `ExerciseDao.getProgressionChain()` per la catena di esercizi
- `ProgressionHistory` per livello attuale
- Livello attuale dell'utente = `userProfile.trainingTier` mappato su Phoenix Level

### Auto-progressione

Dopo ogni sessione, controllare criteri di avanzamento:

```dart
// Criteri dal protocollo:
// - 3 sessioni consecutive con reps target raggiunte per tutti i set
// - RPE medio < 8 (margine di riserva)

Future<bool> shouldAdvance(int exerciseId) async {
  final lastSessions = await getLastSessions(exerciseId, count: 3);
  if (lastSessions.length < 3) return false;

  return lastSessions.every((s) =>
    s.repsCompleted >= s.repsTarget && s.rpe != null && s.rpe! < 8
  );
}
```

Se criteri raggiunti → mostrare dialog:
- "Sei pronto per avanzare! Prossimo livello: [nome esercizio successivo]"
- Tasti: "Avanza" / "Resta al livello attuale"

---

## 2.6 File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/database/tables.dart` | Aggiungere colonne a `Exercises` |
| `lib/core/database/database.dart` | Seed exercises al primo avvio |
| `lib/core/database/seed/exercise_seed.dart` | **Nuovo** — dati seed ~50-80 esercizi |
| `lib/core/database/daos/exercise_dao.dart` | **Nuovo** — query esercizi |
| `lib/core/models/workout_generator.dart` | **Nuovo** — genera piano giornaliero |
| `lib/core/models/workout_plan.dart` | **Nuovo** — data classes WorkoutPlan, PlannedExercise |
| `lib/features/training/training_screen.dart` | **Nuovo** — preview allenamento del giorno |
| `lib/features/workout/workout_session_screen.dart` | **Riscritto** — flusso completo |
| `lib/features/progressions/progressions_screen.dart` | Collegare a DB reale |
| `lib/app/router.dart` | Aggiungere route `/training` |
| `lib/app/providers.dart` | Aggiungere `exerciseDaoProvider`, `workoutPlanProvider` |
| `lib/features/workout/home_screen.dart` | Indice 1 = TrainingScreen |
| Regen DB | `dart run build_runner build` |

---

## 2.7 Verifica completamento

- [ ] DB contiene 50+ esercizi dopo primo avvio
- [ ] Ogni esercizio ha: nome, categoria, livello, istruzioni, muscoli, sets/reps default
- [ ] Training tab mostra allenamento del giorno corretto per il giorno della settimana
- [ ] Esercizi filtrati per equipment utente (da profilo)
- [ ] Esercizi filtrati per tier utente
- [ ] Tasto "Inizia" apre sessione con esercizi dal piano
- [ ] Pre-exercise mostra nome + muscoli + cue (se coach attivo)
- [ ] Countdown prima della prima serie
- [ ] Reps + RPE salvati nel DB per ogni set
- [ ] Rest timer adattivo (diverso per compound vs accessory)
- [ ] Storico set inline visibile
- [ ] Duration score calcolato su dati reali
- [ ] Progressioni leggono da DB (non mock)
- [ ] `flutter analyze` 0 errors
