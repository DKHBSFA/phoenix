# Feature: Warmup, Mobility, Stability & Stretching

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Aggiungere warmup dinamico pre-sessione, stability work, e stretching/cool-down a tutte le sessioni di allenamento. Implementare il tracking della mobilità/flessibilità come prescritto dal Protocollo Phoenix §3.2.
**Why?** Il protocollo prescrive esplicitamente "mobilità dinamica 5-10min pre-allenamento 7×/sett" e "PNF 4-6 sessioni/sett". L'app attualmente parte direttamente con il primo esercizio — nessun warmup, nessun cool-down, nessuna guida per stability. Questo aumenta il rischio di infortunio e ignora un requisito chiave per la longevità funzionale.
**For whom?** Tutti gli utenti — warmup è fondamentale specialmente per >40 anni.
**Success metric:** Ogni sessione ha warmup guidato pre-workout e cool-down post-workout; stability work è tracciato; flessibilità migliora nel tempo.

---

## 2. Cosa Prescrive il Protocollo Phoenix (§3.2)

> **Mobilità dinamica:** 5-10 min pre-allenamento, 7×/sett
> **PNF:** 4-6 sessioni/sett, 3-5 cicli, 20-30s stretch
> **Eccentrico:** 3-4s eccentrica in tutti gli esercizi di forza (già implementato via tempoEcc)

Anche il Protocollo Phoenix §2.8 (adattamenti per età) richiede più mobilità con l'avanzare dell'età.

---

## 3. I 3 Componenti

### 3.1 Dynamic Warmup (Pre-Workout, 5-10min)

**Sempre presente prima di ogni sessione forza e cardio.**

Struttura per sessione:
1. **General warmup (3-5min):** movimento leggero per alzare temperatura corporea
2. **Dynamic stretches (3-5min):** specifici per la sessione del giorno

| Day Type | Dynamic Warmup Focus |
|----------|---------------------|
| Upper Push (Lun) | Arm circles, wall slides, thread the needle, band pull-aparts, shoulder CARs |
| Lower Squat (Mar) | Leg swings, hip CARs, lateral lunges, high knees, ankle circles |
| HIIT (Mer) | Full-body: jumping jacks leggeri, leg swings, arm circles, torso rotations |
| Upper Pull (Gio) | Shoulder CARs, cat-cow, thoracic rotations, band pull-aparts |
| Lower Hinge (Ven) | Hip CARs, good mornings leggeri, leg swings sagittali, glute bridges |
| Norwegian (Sab) | Full-body: marching, high knees, butt kicks, lateral shuffles |
| Power (Dom) | Full-body: tutti i pattern → prep esplosiva |

**Presentazione UI:**
- Lista esercizi warmup con timer per ciascuno (30s o 45s)
- Animazione/immagine per ogni movimento (usa assets Fase A)
- Auto-avanzamento: finito il timer, passa al prossimo
- Skip disponibile per utenti esperti

### 3.2 Stability Work (Intra-Workout, 5-10min)

**Inserito dopo gli esercizi di forza principali, prima del cool-down.**

Esercizi stability per tier:

| Tier | Esercizi | Durata |
|------|----------|--------|
| Beginner | Tandem stance (30s/lato), Single-leg stance con appoggio (30s/lato), Bird dog (10/lato), Dead bug (10/lato), Heel lifts (15) | 5min |
| Intermediate | Single-leg stance senza appoggio (30s), Single-leg RDL (8/lato), Plank shoulder taps (10/lato), Single-leg toe touch (8/lato), Tree pose (30s/lato) | 7min |
| Advanced | Single-leg RDL con peso (8/lato), Stability ball plank (30s), Pistol squat eccentrico (5/lato), Standing elbow-to-knee (10/lato), Overhead squat (8) | 10min |

### 3.3 Cool-Down & Stretching (Post-Workout, 5-10min)

**Sempre presente dopo ogni sessione.**

Due modalità:
1. **Static Stretching (5min)** — mantenere ogni posizione 20-30s
2. **PNF Protocol (7-10min)** — 3-5 cicli: contrazione isometrica 6s → stretch 20-30s

| Day Type | Target Stretching |
|----------|------------------|
| Upper Push | Pectoralis doorway stretch, overhead tricep, anterior deltoid |
| Lower Squat | Standing quad stretch, hamstring (forward fold), hip flexor lunge |
| Upper Pull | Lat stretch (wall), bicep stretch, thoracic extension |
| Lower Hinge | Pigeon pose, seated hamstring, glute stretch (figure-4), calf stretch |
| Power/Full Body | Full sequence: hips + shoulders + spine |

**PNF Protocol:**
1. Stretch passivo 10s
2. Contrazione isometrica contro resistenza 6s (spingere contro muro/pavimento)
3. Rilassare + stretch profondo 20-30s
4. Ripetere 3-5 cicli

---

## 4. Technical Approach

### 4.1 Data Model

```dart
/// A warmup/cooldown routine specific to a workout day
class MovementRoutine {
  final String type;              // 'warmup' / 'stability' / 'cooldown'
  final String dayCategory;       // 'push' / 'squat' / 'hiit' / etc.
  final List<MovementExercise> exercises;
  final int estimatedMinutes;
}

class MovementExercise {
  final String name;
  final String nameIt;            // Italian name
  final String instructions;      // Brief cue
  final int durationSeconds;      // 0 if rep-based
  final int reps;                 // 0 if time-based
  final bool perSide;             // true = do both sides
  final String? imageAsset;       // from Phase A media
}
```

### 4.2 Routine Generator

```dart
class MovementRoutineGenerator {
  /// Generate warmup for today's workout type
  MovementRoutine warmupFor({
    required String dayCategory,
    required String tier,
  });

  /// Generate stability work for tier
  MovementRoutine stabilityFor({
    required String tier,
  });

  /// Generate cool-down stretches for today's workout
  MovementRoutine cooldownFor({
    required String dayCategory,
    required bool usePnf,         // PNF or static
  });
}
```

### 4.3 Seed Data

~40-50 movimenti di warmup/stability/stretching predefiniti, organizzati per:
- Tipo (dynamic / stability / static stretch / PNF)
- Zona del corpo (upper / lower / full body / core)
- Tier (beginner / intermediate / advanced)

Questi NON vanno nella tabella exercises (sono diversi dagli esercizi di forza). Tabella separata o hardcoded come routine predefinite.

### 4.4 Integrazione nel Workout Flow

Flow attuale:
```
WorkoutSessionScreen: Exercise Preview → Countdown → Set Tracking → Rest → Next Exercise
```

Nuovo flow:
```
WorkoutSessionScreen:
  1. WARMUP PHASE → Dynamic warmup (5-10min, timer-guided)
  2. STRENGTH PHASE → Exercise Preview → Countdown → Set Tracking → Rest → Next Exercise
  3. STABILITY PHASE → Stability exercises (5-10min)
  4. COOLDOWN PHASE → Stretching / PNF (5-10min)
```

Ogni fase è skippabile ma il coach incoraggia a completarle tutte.

### 4.5 Tracking

```sql
-- Track completion of movement phases per session
ALTER TABLE workout_sessions ADD COLUMN warmup_completed INTEGER DEFAULT 0;
ALTER TABLE workout_sessions ADD COLUMN stability_completed INTEGER DEFAULT 0;
ALTER TABLE workout_sessions ADD COLUMN cooldown_completed INTEGER DEFAULT 0;
ALTER TABLE workout_sessions ADD COLUMN cooldown_type TEXT;  -- 'static' / 'pnf'
```

### 4.6 Age Adaptation (§2.8)

| Età | Warmup | Stability | Cool-down |
|-----|--------|-----------|-----------|
| <30 | 5min | 5min | 5min static |
| 30-50 | 7min | 7min | 7min PNF recommended |
| 50-65 | 10min | 10min | 10min PNF strongly recommended |
| 65+ | 10min + extra joint mobility | 10min balance-focused | 10min PNF required |

L'app usa l'età dal profilo per calcolare durata e intensità delle routine.

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/movement_routine.dart` | Create | Data classes + routine generator |
| `core/models/movement_exercises.dart` | Create | ~40-50 predefined movements |
| `core/database/tables.dart` | Modify | Add warmup/stability/cooldown columns to workout_sessions |
| `core/database/database.dart` | Modify | Migration |
| `features/workout/workout_session_screen.dart` | Modify | Add warmup/stability/cooldown phases |
| `features/workout/widgets/warmup_phase.dart` | Create | Timer-guided warmup UI |
| `features/workout/widgets/stability_phase.dart` | Create | Stability work UI |
| `features/workout/widgets/cooldown_phase.dart` | Create | Stretching/PNF UI with timer |
| `core/models/coach_prompts.dart` | Modify | Warmup/cooldown encouragement |
| `features/history/history_screen.dart` | Modify | Show warmup/cooldown completion |

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Warmup for push day | dayCategory='push' | Arm circles, wall slides, etc. | High |
| UT-02 | Warmup for squat day | dayCategory='squat' | Leg swings, hip CARs, etc. | High |
| UT-03 | Stability for beginner | tier='beginner' | Tandem stance, bird dog, etc. | High |
| UT-04 | Stability for advanced | tier='advanced' | Single-leg RDL weighted, etc. | High |
| UT-05 | Cooldown PNF structure | usePnf=true | 3-5 cycles, 6s iso + 20-30s stretch | High |
| UT-06 | Age adaptation 60yr | age=60 | 10min warmup, PNF recommended | Medium |
| UT-07 | Age adaptation 25yr | age=25 | 5min warmup, static OK | Medium |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Full workout with warmup | Warmup → Strength → Stability → Cooldown | All phases logged | High |
| IT-02 | Skip warmup | User skips | Strength starts, warmup_completed=0 | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | No age in profile | age=null | Default to 5min warmup |
| EC-02 | User always skips | 5 sessions skipped | Coach nudge: "Il warmup riduce il rischio infortunio del 50%" |

---

## 7. Dipendenze

- **Fase A (Media):** Le immagini dei movimenti vengono da lì
- **Fase C (Periodizzazione):** L'intensità del warmup può variare in deload (più lungo, più delicato)
- **Indipendente dalle altre fasi** — può partire in parallelo con Fase B

---

**Attesa PROCEED.**
