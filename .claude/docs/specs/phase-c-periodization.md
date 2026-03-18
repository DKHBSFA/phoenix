# Feature: Periodization System (Linear / DUP / Block)

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Implementare i 3 modelli di periodizzazione prescritti dal Protocollo Phoenix §2.2/§2.4:
- **Beginner:** Progressione Lineare
- **Intermediate:** Daily Undulating Periodization (DUP)
- **Advanced:** Block Periodization (Verkhoshansky)
**Why?** Senza periodizzazione, l'app propone gli stessi parametri ogni settimana — il che causa stallo, adattamento e assenza di deload. È il gap più critico del protocollo.
**For whom?** Tutti gli utenti — ogni tier ha il suo modello.
**Success metric:** WorkoutGenerator produce parametri diversi settimana per settimana secondo il modello del tier; deload si attiva automaticamente; mesocicli sono visibili all'utente.

---

## 2. I Tre Modelli (dal Protocollo Phoenix §2.4)

### 2.1 Beginner — Progressione Lineare

**Ciclo di 4 settimane:**
| Settimana | Reps/set | Note |
|-----------|----------|------|
| 1 | 4×10 | Carico iniziale |
| 2 | 4×12 | Stesso carico |
| 3 | 4×15 | Stesso carico |
| 4 | 4×10 | +2.5kg (upper) / +5kg (lower) — reset reps |

**Implementazione:**
- Tracciare `mesocycle_week` (1-4) per l'utente
- Settimana 4 = micro-deload implicito (reset reps, aumento carico)
- Ogni 12 settimane (3 cicli): 1 settimana deload completo (50% volume)

### 2.2 Intermediate — DUP (Daily Undulating Periodization)

**Rotazione giornaliera su 3 stimoli:**
| Giorno forza | Stimolo | Reps | Carico | Rest |
|-------------|---------|------|--------|------|
| Lun (Push) | Ipertrofia | 4×8-12 | 65-75% 1RM | 90s |
| Mar (Squat) | Forza | 4×3-6 | 75-85% 1RM | 180s |
| Gio (Pull) | Ipertrofia | 4×8-12 | 65-75% 1RM | 90s |
| Ven (Hinge) | Resistenza | 3×15-20 | 50-65% 1RM | 60s |
| Dom (Power) | Potenza | 5×3-5 | 70-80% 1RM | 120s |

**Mesociclo:** 4-6 settimane, poi deload 1 settimana
**Progressione intra-mesociclo:**
- Settimana 1-2: RPE 7
- Settimana 3-4: RPE 8
- Settimana 5-6: RPE 9
- Deload: RPE 5-6, -40% volume

### 2.3 Advanced — Block Periodization (Verkhoshansky)

**Mesociclo 10-13 settimane:**
| Blocco | Settimane | Reps | Set/muscolo | Carico | Focus |
|--------|-----------|------|-------------|--------|-------|
| Accumulo | 3-4 | 8-12 | 16-20 | 60-75% | Volume, ipertrofia |
| Trasformazione | 3-4 | 3-6 | 12-16 | 75-90% | Forza massimale |
| Realizzazione | 2-3 | 1-3 | 8-12 | 85-95% | Picco prestazionale |
| Deload | 1 | 8-10 | 8 | 50-60% | Recupero attivo |

**Progressione:**
- Intra-blocco: +2.5-5% carico per settimana
- Inter-blocco: cambio stimolo (volume → intensità → picco)

---

## 3. Technical Approach

### 3.1 Data Model

```dart
/// Represents the current position in a periodization cycle
class MesocycleState {
  final String tier;              // beginner/intermediate/advanced
  final int mesocycleNumber;      // incrementale (1, 2, 3, ...)
  final int weekInMesocycle;      // 1-based
  final String currentBlock;      // accumulo/trasformazione/realizzazione/deload (advanced)
  final String currentStimulus;   // ipertrofia/forza/resistenza/potenza/deload (DUP)
  final DateTime startedAt;
  final DateTime? completedAt;
}
```

### 3.2 Nuova Tabella DB

```sql
CREATE TABLE mesocycle_state (
  id INTEGER PRIMARY KEY,
  tier TEXT NOT NULL,
  mesocycle_number INTEGER NOT NULL DEFAULT 1,
  week_in_mesocycle INTEGER NOT NULL DEFAULT 1,
  current_block TEXT,           -- for advanced
  started_at INTEGER NOT NULL,
  completed_at INTEGER
);
```

### 3.3 PeriodizationEngine

Nuovo model che incapsula tutta la logica:

```dart
class PeriodizationEngine {
  /// Get workout parameters for today based on tier and mesocycle state
  WorkoutParams getParamsForDay({
    required String tier,
    required MesocycleState state,
    required int weekday,
  });

  /// Advance the mesocycle (called weekly, typically Monday)
  MesocycleState advanceWeek(MesocycleState current);

  /// Check if deload is needed (RPE trending, biomarker alerts, schedule)
  bool shouldDeload(MesocycleState state, {List<double>? recentRPEs, bool? biomarkerAlert});

  /// Get description of current phase for UI
  String currentPhaseDescription(MesocycleState state);
}
```

### 3.4 WorkoutParams

```dart
class WorkoutParams {
  final String stimulus;     // 'ipertrofia' / 'forza' / 'resistenza' / 'potenza' / 'deload'
  final int setsCompound;
  final int setsAccessory;
  final int repsMin;
  final int repsMax;
  final double loadPercentMin;  // % 1RM
  final double loadPercentMax;
  final int restSeconds;
  final double targetRPE;
}
```

### 3.5 Integrazione con WorkoutGenerator

`WorkoutGenerator.generateForDay()` attualmente usa `_tierParams` statico. Cambierà per:
1. Leggere `MesocycleState` dal DB
2. Chiamare `PeriodizationEngine.getParamsForDay()`
3. Usare i params dinamici invece dei `_tierParams` fissi
4. Aggiornare `MesocycleState` se è inizio settimana

### 3.6 UI — Visualizzazione Mesociclo

**TodayScreen:** Badge con fase corrente ("Settimana 3/6 — Ipertrofia")
**TrainingScreen:** Card mesociclo con:
- Barra progresso del mesociclo
- Blocco corrente evidenziato
- Countdown al deload
**CoachScreen:** Report automatico fine mesociclo

### 3.7 Deload Automatico

Trigger per deload:
1. **Schedulato:** Fine mesociclo (sempre)
2. **RPE trending:** Media RPE ultima settimana ≥ 9.0
3. **Biomarker:** Cortisolo elevato o CK persistente (da biomarker_alerts)
4. **Manuale:** Utente richiede deload

Parametri deload (tutti i tier):
- Volume: -40% (set ridotti)
- Intensità: 50-60% 1RM
- RPE target: 5-6
- Durata: 1 settimana

---

## 4. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/periodization_engine.dart` | Create | Core periodization logic |
| `core/models/mesocycle_state.dart` | Create | Data classes |
| `core/models/workout_params.dart` | Create | Dynamic workout parameters |
| `core/database/tables.dart` | Modify | Add mesocycle_state table |
| `core/database/database.dart` | Modify | Migration, DAO registration |
| `core/database/daos/mesocycle_dao.dart` | Create | CRUD mesocycle state |
| `core/models/workout_generator.dart` | Modify | Use PeriodizationEngine instead of static params |
| `features/today/today_screen.dart` | Modify | Show current phase badge |
| `features/training/training_screen.dart` | Modify | Mesocycle progress card |
| `core/models/report_generator.dart` | Modify | End-of-mesocycle report |
| `core/models/coach_prompts.dart` | Modify | Phase-aware coach messages |

---

## 5. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Beginner linear: week 1→2→3→4 reps | Week 1-4 | 10→12→15→10 reps | High |
| UT-02 | Beginner: weight increase at week 4 | Week 4 reached | +2.5kg upper, +5kg lower | High |
| UT-03 | DUP stimulus rotation | Mon/Tue/Thu/Fri/Sun | Ipertrofia/Forza/Ipertrofia/Resistenza/Potenza | High |
| UT-04 | DUP RPE progression | Week 1→6 | RPE 7→7→8→8→9→9 | High |
| UT-05 | Block sequence | Mesocycle flow | Accumulo→Trasformazione→Realizzazione→Deload | High |
| UT-06 | Block params per phase | Each block | Correct reps/sets/load ranges | High |
| UT-07 | Deload trigger: RPE | Avg RPE 9.2 | shouldDeload = true | High |
| UT-08 | Deload trigger: biomarker | Cortisolo alert | shouldDeload = true | Medium |
| UT-09 | Deload params | Any tier, deload | -40% volume, 50-60% load, RPE 5-6 | High |
| UT-10 | Week advancement | advanceWeek() at end | Correct next week/block | High |
| UT-11 | Mesocycle completion | Last week of deload | New mesocycle started | Medium |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Full beginner cycle | PeriodizationEngine → WorkoutGenerator | 4 weeks of correct params | High |
| IT-02 | DUP week | All 5 strength days | Different stimulus each day | High |
| IT-03 | Block transition | End of Accumulo | Trasformazione params active | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Tier upgrade mid-mesocycle | User promoted from beginner→intermediate | Finish current mesocycle, then switch model |
| EC-02 | Missed weeks | User skips 2 weeks | Resume from current week, don't auto-advance |
| EC-03 | First ever mesocycle | No mesocycle_state in DB | Create default Week 1 |

---

## 6. Rischi e Mitigazioni

| Rischio | Mitigazione |
|---------|-------------|
| Complessità UI per mostrare fase/blocco | Mantenere semplice: 1 badge + 1 card, no overload |
| 1RM non tracciato (serve per % carico) | Fase 1: usare RPE come proxy; Fase 2: aggiungere 1RM tracking |
| Utente confuso da cambio automatico parametri | Coach message che spiega la transizione |
| Conflitto con progression check esistente | Progressione esercizi (avanzamento catena) resta separata dalla periodizzazione (cambio parametri) |

---

**Attesa PROCEED.**
