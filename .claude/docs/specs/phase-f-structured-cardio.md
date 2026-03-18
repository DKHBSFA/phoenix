# Feature: Structured Cardio — HIIT, Zone 2, HR Zones

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Trasformare i giorni "Active Recovery" (mercoledì/sabato) da label vuoti a sessioni cardio strutturate con HIIT, Zone 2, e calcolo zone HR. Aggiungere protocolli cardio evidence-based dal Protocollo Phoenix §3.3.
**Why?** VO2max è il **miglior singolo predittore di mortalità per tutte le cause** (Mandsager 2018, n=122,007). Il protocollo prescrive HIIT e Zone 2, ma l'app non ha nessuna struttura cardio. Blueprint Johnson dimostra che 3 protocolli HIIT/settimana sono fattibili e ben strutturati.
**For whom?** Tutti gli utenti — il cardio è critico quanto la forza per longevità.
**Success metric:** L'utente ha sessioni cardio guidate con timer, HR zones target, e tracking del progresso VO2max stimato.

---

## 2. Cosa Prescrive il Protocollo Phoenix (§3.3)

> Cardiovascular Conditioning — Day 3/6:
> - Zone 2 (60-70% HR max) OR HIIT (30s on/60s off)
> - Modalities: Bike, treadmill, rowing, swimming, jump rope, running
> - Calculation: HR max = 220 - age, Zone 2 = 60-70%

Il protocollo è vago sui dettagli. Blueprint Johnson è più specifico con 3 protocolli distinti. Integriamo il meglio di entrambi.

---

## 3. I 3 Protocolli Cardio

### 3.1 Tabata HIIT (Day 3 — Mercoledì)

**Fonte:** Tabata et al. 1996 — +28% VO2max anaerobic in 6 settimane
**Struttura:**
- Warmup: 5min (cycling/walking)
- 8 round di: **20s all-out / 20s rest** (beginner: 20s on / 40s rest)
- Total HIIT: 4 minuti
- Seguito da 20-25min Zone 2

**Esercizi HIIT per tier:**
| Tier | Opzioni |
|------|---------|
| Beginner | Jumping jacks, marching in place, BW squats, standing toe taps |
| Intermediate | Mountain climbers, burpees (no push-up), high knees, jump squats |
| Advanced | Burpees con push-up, box jumps, jumping lunges, squat-press |

**Progressione:**
- Settimana 1-4: 20s/40s rest (beginner) o 20s/20s (intermediate+)
- Settimana 5-8: 20s/20s tutti
- Settimana 9+: 20s/10s (vero Tabata)

### 3.2 Norwegian 4×4 (Day 6 — Sabato)

**Fonte:** Wisløff et al. 2007 — +22% VO2max in pazienti CVD (vs +17% aerobic continuo)
**Struttura:**
- Warmup: 5-10min
- 4 round di: **4min @85-95% HR max / 3min @60-70% HR max**
- Total: 28 minuti
- Cool-down: 5min

**Modalità:** Treadmill, indoor bike, rowing, outdoor running

**Progressione per tier:**
| Tier | Round | Intensità lavoro | Recovery |
|------|-------|-----------------|----------|
| Beginner | 3 round | 80-85% HR max | 3min @60% |
| Intermediate | 4 round | 85-90% HR max | 3min @60-65% |
| Advanced | 4-5 round | 90-95% HR max | 3min @60-70% |

### 3.3 Zone 2 Steady State (componente di ogni sessione cardio)

**Fonte:** Protocollo Phoenix §3.3, Mandsager 2018
**Struttura:** 20-30min @60-70% HR max
**Modalità:** Walking, cycling, swimming, elliptical
**Quando:** Dopo ogni sessione HIIT (riempie il tempo rimanente fino a 45-60min)

---

## 4. Technical Approach

### 4.1 HR Zone Calculator

```dart
class HrZones {
  final int age;

  HrZones(this.age);

  int get hrMax => 220 - age;
  int get zone1Low => (hrMax * 0.50).round();  // Recovery
  int get zone1High => (hrMax * 0.60).round();
  int get zone2Low => (hrMax * 0.60).round();  // Aerobic base
  int get zone2High => (hrMax * 0.70).round();
  int get zone3Low => (hrMax * 0.70).round();  // Tempo
  int get zone3High => (hrMax * 0.80).round();
  int get zone4Low => (hrMax * 0.80).round();  // Threshold
  int get zone4High => (hrMax * 0.90).round();
  int get zone5Low => (hrMax * 0.90).round();  // VO2max
  int get zone5High => hrMax;

  /// Target range for a named zone
  (int low, int high) targetFor(String zone) {
    switch (zone) {
      case 'zone2': return (zone2Low, zone2High);
      case 'hiit_work': return (zone4Low, zone5High);  // 80-100%
      case 'hiit_recovery': return (zone1High, zone2High);  // 60-70%
      case 'norwegian_work': return (zone4High, zone5High);  // 85-95%
      default: return (zone2Low, zone2High);
    }
  }
}
```

### 4.2 HIIT Session Screen

Nuova schermata per sessioni cardio guidate:

**Componenti:**
- **Timer centrale** — countdown per fase work/rest con colori (rosso work, verde rest)
- **Round counter** — "Round 3/8"
- **HR target band** — fascia target HR con indicatore (richiede input manuale o futuro wearable)
- **Zone indicator** — "ZONE 5 — VO2max" con colore
- **Audio cues** — beep inizio/fine round (via AudioEngine esistente)
- **Exercise suggestion** — quale movimento fare nel round corrente

**Flow:**
1. Scelta protocollo (Tabata / Norwegian / Custom)
2. Scelta modalità (corsa / bike / bodyweight / misto)
3. Warmup countdown (5min)
4. HIIT rounds con timer automatico
5. Transizione a Zone 2 (timer 20-30min)
6. Cool-down
7. Summary: round completati, durata totale, HR media stimata

### 4.3 Cardio Day nel WorkoutGenerator

Attualmente i giorni cardio restituiscono un `WorkoutPlan` vuoto:
```dart
if (schedule.type == WorkoutType.cardio) {
  return WorkoutPlan(
    dayName: schedule.dayName,
    type: schedule.type,
    exercises: [],  // ← VUOTO
    estimatedMinutes: 30,
  );
}
```

Cambio: generare un `CardioPlan` con protocollo specifico per il giorno:

```dart
class CardioPlan {
  final String protocolName;     // 'tabata' / 'norwegian' / 'zone2_only'
  final int warmupMinutes;
  final List<HiitRound> rounds;  // work/rest intervals
  final int zone2Minutes;
  final int cooldownMinutes;
  final String targetHrZone;
}

class HiitRound {
  final int workSeconds;
  final int restSeconds;
  final String targetZone;       // 'zone5' / 'zone4'
  final String? exerciseSuggestion;
}
```

### 4.4 Integrazione con Periodizzazione (Fase C)

L'intensità HIIT varia per fase del mesociclo:
- **Accumulo:** Zone 2 prevalente, HIIT ridotto (2 round Tabata, 3 round Norwegian)
- **Trasformazione:** HIIT standard (8 round Tabata, 4 round Norwegian)
- **Realizzazione:** HIIT intenso (Tabata 20/10, Norwegian 5 round)
- **Deload:** Solo Zone 2, no HIIT

### 4.5 VO2max Estimation

Stima VO2max senza laboratorio — formula Cooper o sub-max:
- **Cooper 12-min test:** già nell'assessment screen
- **Tracking trend:** dopo ogni Norwegian 4×4, registrare round completati + HR percepita → stima miglioramento
- **Benchmark:** ogni 4-8 settimane, ripetere Cooper test

### 4.6 Tracking DB

```sql
CREATE TABLE cardio_sessions (
  id INTEGER PRIMARY KEY,
  date INTEGER NOT NULL,
  protocol TEXT NOT NULL,           -- 'tabata' / 'norwegian' / 'zone2'
  rounds_completed INTEGER,
  total_duration_seconds INTEGER,
  zone2_minutes INTEGER,
  avg_hr_estimated INTEGER,         -- input manuale o futuro wearable
  perceived_exertion INTEGER,       -- RPE 1-10
  modality TEXT,                    -- 'running' / 'cycling' / 'bodyweight' / 'mixed'
  notes TEXT
);
```

---

## 5. UI Changes

### 5.1 Today Screen

I giorni mercoledì/sabato mostrano card cardio invece di "Active Recovery":
- **Mercoledì:** "HIIT Tabata + Zone 2" con timer e HR target
- **Sabato:** "Norwegian 4×4 + Zone 2" con timer e HR target

### 5.2 Cardio Session Screen (nuova)

Simile al WorkoutSessionScreen ma ottimizzato per intervalli:
- Timer a schermo pieno durante i round
- Transizioni automatiche work→rest con audio
- Barra progresso dei round
- Zone HR evidenziate con colore

### 5.3 History / Stats

Le sessioni cardio appaiono nella History con:
- Protocollo usato
- Round completati
- Durata Zone 2
- RPE

### 5.4 Coach Messages

CoachPrompts cardio-aware:
- "Oggi è giorno Tabata — 4 minuti che valgono più di 30 minuti di corsa"
- "Norwegian 4×4 è il protocollo con la migliore evidenza per VO2max. +22% in 12 settimane."
- Post-sessione: "Hai completato 8/8 round Tabata. Il tuo VO2max ringrazia."

---

## 6. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/hr_zones.dart` | Create | HR zone calculator from age |
| `core/models/cardio_plan.dart` | Create | CardioPlan, HiitRound data classes |
| `core/models/cardio_protocols.dart` | Create | Tabata, Norwegian, Zone2 protocol definitions |
| `core/database/tables.dart` | Modify | Add cardio_sessions table |
| `core/database/database.dart` | Modify | Migration |
| `core/database/daos/cardio_dao.dart` | Create | CRUD cardio sessions |
| `core/models/workout_generator.dart` | Modify | Generate CardioPlan for cardio days |
| `features/cardio/cardio_session_screen.dart` | Create | Guided HIIT/Zone 2 session |
| `features/cardio/widgets/hiit_timer.dart` | Create | Visual timer with work/rest phases |
| `features/cardio/widgets/hr_zone_indicator.dart` | Create | Zone badge with target |
| `features/today/today_screen.dart` | Modify | Cardio card for Wed/Sat |
| `features/today/widgets/cardio_card.dart` | Create | Protocol card for cardio days |
| `features/history/history_screen.dart` | Modify | Include cardio sessions |
| `core/models/coach_prompts.dart` | Modify | Cardio-specific messages |
| `core/models/daily_protocol.dart` | Modify | Track cardio completion |
| `core/audio/audio_engine.dart` | Modify | HIIT round beeps (work start, rest start, final countdown) |

---

## 7. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | HR max calculation | Age 40 | HR max = 180 | High |
| UT-02 | Zone 2 range | Age 40 | 108-126 bpm | High |
| UT-03 | Tabata round structure | Beginner | 8 rounds, 20s/40s | High |
| UT-04 | Norwegian round structure | Intermediate | 4 rounds, 4min/3min | High |
| UT-05 | Cardio plan for Wednesday | Weekday 3 | Tabata protocol | High |
| UT-06 | Cardio plan for Saturday | Weekday 6 | Norwegian protocol | High |
| UT-07 | Deload cardio | Deload week | Zone 2 only, no HIIT | High |
| UT-08 | Timer state transitions | Work→Rest→Work | Correct durations and phase | High |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Full Tabata session | Timer → rounds → Zone 2 → summary | Complete session logged | High |
| IT-02 | Cardio in daily protocol | Wednesday check | Cardio counted in 6/6 progress | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | User stops mid-HIIT | App backgrounded during round 4 | Session saved with rounds_completed=4 |
| EC-02 | Very young user (age 18) | HR max = 202 | Zone calculations still valid |
| EC-03 | Elderly user (age 70) | HR max = 150 | Zones adjust, HIIT intensity reduced |

---

**Attesa PROCEED.**
