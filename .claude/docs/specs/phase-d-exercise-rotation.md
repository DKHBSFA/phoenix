# Feature: Monthly Exercise Rotation

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Sistema di rotazione che cambia gli esercizi ogni mesociclo, evitando che il muscolo si adatti a un movimento specifico.
**Why?** Nei materiali originali (Month A/B/C), solo 1 esercizio (Plank) è condiviso tra i 3 mesi — ogni mese porta 21-28 esercizi completamente nuovi. L'app attuale propone gli stessi esercizi per sempre.
**For whom?** Tutti gli utenti — la varietà previene adattamento, aumenta motivazione e stimola pattern motori diversi.
**Success metric:** Ogni mesociclo presenta almeno il 70% di esercizi diversi dal precedente; l'utente può visualizzare il piano del mesociclo corrente.

---

## 2. Analisi del Pattern Originale

### Principio dai materiali Excel:

| Mese | Focus equipment | Esercizi unici | Overlap con mese precedente |
|------|----------------|----------------|---------------------------|
| A | Macchine + cavi | 27 | — |
| B | Bilanciere + varianti | 27 | 6 condivisi con A (22%) |
| C | Corpo libero | 30 | 2 condivisi con B (7%) |

### Pattern di rotazione:
1. **Variazione dello strumento:** Stesso pattern motorio, strumento diverso (Machine Fly → Cable Crossover → Push-Up)
2. **Variazione dell'angolo:** Stesso muscolo, angolo diverso (Bench Press → Incline Press → Decline Press)
3. **Variazione del tipo:** Compound → Isolation → Compound diverso
4. **Progressione within-month:** Reps 12→15→18→21 (non cambia esercizio, cambia volume)

---

## 3. Technical Approach

### 3.1 Concetto: Exercise Pool per Slot

Ogni "slot" nel workout (es. "Compound Push #1") ha un **pool di esercizi intercambiabili**. La rotazione sceglie dal pool in modo che:
- Ogni mesociclo usa esercizi diversi dal precedente
- L'esercizio scelto è compatibile con l'equipment dell'utente
- Il livello è appropriato per il tier

```dart
/// A rotation slot defines a position in the workout template
class RotationSlot {
  final String category;          // push/pull/squat/hinge/core
  final String exerciseType;      // compound/accessory/isolation
  final int slotIndex;            // 1st compound, 2nd compound, etc.
  final List<int> exercisePool;   // IDs of interchangeable exercises
}
```

### 3.2 Rotation Algorithm

```dart
class ExerciseRotator {
  /// Select exercises for the next mesocycle
  /// Maximizes variety while respecting constraints
  Future<Map<RotationSlot, int>> selectForMesocycle({
    required int mesocycleNumber,
    required String equipment,
    required int maxLevel,
    required Map<RotationSlot, List<int>> previousSelections,  // last 2 mesocycles
  });
}
```

**Algoritmo:**
1. Per ogni slot, ottenere il pool di esercizi compatibili (equipment + level)
2. Escludere esercizi usati nel mesociclo precedente
3. Preferire esercizi non usati negli ultimi 2 mesocicli
4. Se il pool è troppo piccolo (<2 opzioni), permettere ripetizione
5. Shuffle deterministico (seed = mesocycleNumber) per riproducibilità

### 3.3 Nuova Tabella DB

```sql
CREATE TABLE mesocycle_exercises (
  id INTEGER PRIMARY KEY,
  mesocycle_number INTEGER NOT NULL,
  slot_category TEXT NOT NULL,      -- push/pull/squat/hinge/core
  slot_type TEXT NOT NULL,          -- compound/accessory/core
  slot_index INTEGER NOT NULL,      -- 0, 1, 2...
  exercise_id INTEGER NOT NULL REFERENCES exercises(id),
  UNIQUE(mesocycle_number, slot_category, slot_type, slot_index)
);
```

### 3.4 Integrazione con WorkoutGenerator

Flusso attuale:
```
WorkoutGenerator.generateForDay() → ExerciseDao.getForWorkout() → primo esercizio disponibile
```

Nuovo flusso:
```
WorkoutGenerator.generateForDay()
  → MesocycleDao.getCurrentMesocycle()
  → MesocycleExerciseDao.getExercisesForMesocycle(mesocycleNumber)
  → Se non esistono: ExerciseRotator.selectForMesocycle() → salva in DB
  → Usa gli esercizi selezionati per il mesociclo corrente
```

### 3.5 UI — Piano del Mesociclo

**Nuova schermata/sezione: "Il Tuo Programma"**

Mostra il piano del mesociclo corrente:
- Per ogni giorno della settimana: lista esercizi assegnati
- Badge "Nuovo" per esercizi mai fatti prima
- Preview esercizio (tap → ExerciseDetailSheet)
- Countdown alla prossima rotazione

**TodayScreen:** Indicatore "Mesociclo N — Settimana M/X"

**Fine mesociclo:** Coach message che introduce i nuovi esercizi del prossimo ciclo

### 3.6 User Override

L'utente può:
- **Sostituire** un esercizio con un altro dal pool (swipe → "Cambia esercizio")
- **Bloccare** un esercizio preferito (non viene mai ruotato)
- **Escludere** un esercizio dal pool (limitazioni fisiche — già supportato)

---

## 4. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/exercise_rotator.dart` | Create | Rotation algorithm |
| `core/models/rotation_slot.dart` | Create | Data classes |
| `core/database/tables.dart` | Modify | Add mesocycle_exercises table |
| `core/database/database.dart` | Modify | Migration |
| `core/database/daos/mesocycle_exercise_dao.dart` | Create | CRUD mesocycle exercise assignments |
| `core/models/workout_generator.dart` | Modify | Use mesocycle assignments instead of ad-hoc selection |
| `features/training/training_screen.dart` | Modify | "Il Tuo Programma" section |
| `features/training/mesocycle_plan_screen.dart` | Create | Full mesocycle plan view |
| `features/today/today_screen.dart` | Modify | Mesocycle indicator |
| `core/models/coach_prompts.dart` | Modify | New-mesocycle introduction messages |

---

## 5. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Rotation maximizes variety | Pool of 10, select 3 | ≤1 overlap with previous mesocycle | High |
| UT-02 | Respects equipment constraint | equipment='bodyweight' | Only bodyweight exercises selected | High |
| UT-03 | Respects level constraint | maxLevel=3 | No exercise above level 3 | High |
| UT-04 | Small pool fallback | Pool of 2, need 2 | Allows repetition, no crash | High |
| UT-05 | Deterministic with seed | Same mesocycleNumber twice | Same selection | Medium |
| UT-06 | User lock respected | Exercise locked | Always included in selection | High |
| UT-07 | Exclusion respected | Exercise excluded | Never selected | High |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | 3 consecutive mesocycles | ExerciseRotator → DB | ≥70% different exercises each time | High |
| IT-02 | Mesocycle transition | End mesocycle → new mesocycle | New exercises auto-selected | High |
| IT-03 | WorkoutGenerator uses rotation | Generate workout | Uses mesocycle-assigned exercises | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | First mesocycle ever | No history | Select freely from full pool |
| EC-02 | Equipment change mid-mesocycle | gym → bodyweight | Re-generate mesocycle for new equipment |
| EC-03 | All exercises locked | User locks everything | Use locked exercises, warn user |
| EC-04 | Tier upgrade | beginner → intermediate | New mesocycle with expanded pool |

---

## 6. Dipendenze

- **Fase B (Exercise Enrichment):** Serve un DB con 165+ esercizi per avere pool sufficienti
- **Fase C (Periodization):** La rotazione avviene ai confini del mesociclo

---

**Attesa PROCEED.**
