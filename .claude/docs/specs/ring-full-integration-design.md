# Ring Full Integration — Design Spec

**Data:** 2026-03-18
**Stato:** ✅ Completato 2026-03-18
**Tipo:** Feature (multi-fase)
**Prerequisito:** Fase 0 BLE Foundation (completata 2026-03-18)

---

## 1. Cosa stiamo costruendo

Integrazione completa dei dati del Colmi R10 in ogni area di Phoenix:

- **Sync automatico** all'apertura app (sleep, HR log, passi, HRV, temperatura)
- **Bio tracking durante workout** (HR, SpO2, HRV, temperatura, stress index — tutto da raw PPG)
- **HRV mattutino** (auto al sync + fallback manuale guidato)
- **Notifica sonno** al risveglio con stats sintetiche
- **Widget home screen** del telefono (small 2×2 + large 4×4)
- **Signal processing pipeline** su dati raw PPG per qualità superiore ai dati firmware

---

## 2. Architettura — Ring come servizio distribuito

```
┌─────────────────────────────────────────────────────────┐
│                      Phoenix App                         │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │WorkoutBioTrk │  │MorningHrvChk │  │ SleepNotifier │  │
│  └──────┬───────┘  └──────┬───────┘  └───────┬───────┘  │
│         │                 │                   │          │
│  ┌──────▼─────────────────▼───────────────────▼───────┐  │
│  │              RingLockManager                       │  │
│  │  (una sola operazione real-time alla volta)        │  │
│  └──────────────────────┬─────────────────────────────┘  │
│                         │                                │
│  ┌──────────────────────▼─────────────────────────────┐  │
│  │              RingService (BLE thin wrapper)         │  │
│  └──────────────────────┬─────────────────────────────┘  │
│                         │                                │
│  ┌──────────────────────▼─────────────────────────────┐  │
│  │           RingSyncCoordinator                       │  │
│  │  (sync all'apertura: sleep+HR log+steps+HRV)       │  │
│  └──────────────────────┬─────────────────────────────┘  │
│                         │                                │
│  ┌──────────────────────▼─────────────────────────────┐  │
│  │           SignalProcessor                           │  │
│  │  (raw PPG → SQI → NLMS → AMPD → IBI → HR/HRV/SI) │  │
│  └────────────────────────────────────────────────────┘  │
│                                                          │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  ring_hr_samples  ring_sleep_stages  ring_steps     │  │
│  │  hrv_readings     workout_sets (bio cols)           │  │
│  └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Principi

- **RingService** resta thin wrapper BLE — non sa cosa fanno i consumer
- **RingLockManager** previene conflitti BLE (una sola operazione real-time alla volta): `acquire(owner)` / `release(owner)` con timeout
- Ogni feature (workout, HRV, sleep) gestisce il proprio rapporto con il ring tramite il lock manager
- **SignalProcessor** è il differenziatore: raw PPG → nostra pipeline → dati superiori al firmware Qring
- Fallback a dati firmware se raw non disponibile (firmware vecchio, errore)

---

## 3. Signal Processing Pipeline

### Principio

Raccogliere **sempre raw** quando possibile, processare con la nostra pipeline, usare i dati firmware come fallback. L'intero punto è compensare i limiti hardware con software intelligente.

### Pipeline

```
Raw PPG + Accelerometro
       │
┌──────▼──────┐
│ SQI Assessment │  → Signal Quality Index 0-1, scarta campioni rumorosi
└──────┬──────┘
       │ campioni buoni (SQI > threshold, default 0.5, configurabile)
┌──────▼──────┐
│ NLMS Filter  │  → rimuovi motion artifact (accelerometro come reference)
└──────┬──────┘
       │ segnale pulito
┌──────▼──────┐
│ Peak Detection│  → Modified AMPD, trova picchi PPG
└──────┬──────┘
       │ IBI (inter-beat intervals)
┌──────▼──────────────────────────┐
│ HR    HRV(RMSSD)    SI    SpO2  │
│ (nostro)  (nostro)  (nostro)     │
└─────────────────────────────────┘
```

### Comandi raw (da portare da CitizenOneX, MIT)

```dart
const cmdRawPpg = 0x68;    // Raw PPG sensor data (VC30F)
const cmdRawAccel = 0x67;  // Raw accelerometer data (STK8321)
const cmdRawSpo2 = 0x66;   // Raw SpO2 sensor data
```

**ATTENZIONE — Gate di verifica:** Questi comandi sono verificati sul R06 (CitizenOneX). Il R10 potrebbe non supportarli. **Fase 1 inizia con un probe**: inviare `0x68` e verificare risposta vs error bit. Se il R10 non supporta raw PPG, la pipeline SignalProcessor lavora sui dati firmware real-time (0x69) con filtering statistico. L'architettura non cambia, solo la qualità dei dati in input.

### Temperatura

Il ring espone temperatura tramite il comando di health check composito o come parte dei dati sync. Non è disponibile come real-time streaming type. Acquisizione:
- **Sync storico**: incluso nei dati sleep/health del ring
- **Spot check**: lettura singola on-demand durante workout (ogni 10 min o a inizio/fine sessione)
- Se `capabilities.supportsTemperature == false` → skip silenzioso

### SignalProcessor API

```dart
class SignalProcessor {
  // ── Raw acquisition ──
  Future<RawPpgWindow> acquireRawPpg(Duration duration);
  Future<RawAccelWindow> acquireRawAccel(Duration duration);

  // ── Pipeline ──
  double assessSignalQuality(List<int> rawPpg);                          // SQI 0-1
  List<double> removeMotionArtifact(List<int> ppg, List<double> accel);  // NLMS
  List<int> detectPeaks(List<double> cleanSignal);                       // Modified AMPD
  List<int> extractIbi(List<int> peakIndices, int sampleRate);           // IBI in ms

  // ── Derivati ──
  int computeHr(List<int> ibi);
  double computeRmssd(List<int> ibi);
  double computeStressIndex(List<int> ibi);   // Bayevsky SI

  // ── Validation (sempre attivo, anche su dati firmware) ──
  bool isValidHr(int bpm) => bpm >= 30 && bpm <= 220;
  bool isValidSpO2(int spo2) => spo2 >= 70 && spo2 <= 100;
  bool isValidTemp(double temp) => temp >= 30.0 && temp <= 42.0;
  bool isOutlier(int value, List<int> window); // > 2 SD dalla media mobile
  List<double> smooth(List<int> values, {int window = 5});
}
```

### Riferimenti scientifici

| Step | Tecnica | Paper |
|------|---------|-------|
| SQI | Variabilità + pattern detection | Kasaeyan Naeini et al., ACM 2023 (DOI: 10.1145/3616019) |
| NLMS | Adaptive filter con accel reference | IEEE 2014 (NLMS/RLS per PPG MA removal) |
| Peak detection | Modified AMPD (time-domain, leggero) | Sensors MDPI, 2020 (DOI: 10.3390/s20061783) |
| IBI → HRV | Standard Task Force ESC/NASPE 1996 | |
| SI | Bayevsky Stress Index | Bayevsky 2004 |
| HR exercise | CNN-LSTM (futuro, se serve) | Chung et al. 2020 |

### Dove si applica

| Dato | Raw pipeline | Firmware fallback |
|------|-------------|-------------------|
| HR real-time workout | Raw PPG → NLMS → HR (motion artifact removal è critico) | Real-time stream firmware (type 1) |
| HRV spot check | Raw PPG 60s → IBI → RMSSD | Real-time stream firmware (type 10) |
| HR log sync | Dati storici firmware (no raw disponibile per il passato) | Filtering statistico (outlier + smooth) |
| SpO2 | Raw se disponibile | Firmware value + validation |
| Sleep | Staging firmware + HR notturno nostro | Staging firmware solo |
| Temperatura | Lettura diretta (no processing) | — |

### Fallback strategy

```
Raw PPG disponibile?
  │ sì → pipeline nostra → dati Phoenix-quality
  │ no (firmware vecchio, errore, ring non supporta)
  │     → dati firmware pre-calcolati → filtering statistico base
  └─────→ in entrambi i casi, il sistema funziona
```

---

## 4. Database

### Nuove tabelle

**`ring_hr_samples`**

| Colonna | Tipo | Note |
|---------|------|------|
| id | INTEGER PK | Auto-increment |
| timestamp | DATETIME | Momento della lettura |
| hr | INTEGER | BPM |
| source | TEXT | `'log_sync'` / `'real_time'` / `'workout'` |
| quality | REAL? | SQI 0-1 dal SignalProcessor, nullable |

**`ring_sleep_stages`**

| Colonna | Tipo | Note |
|---------|------|------|
| id | INTEGER PK | Auto-increment |
| night_date | DATE | Notte di riferimento |
| stage | TEXT | `'deep'` / `'light'` / `'rem'` / `'awake'` |
| start_time | DATETIME | Inizio fase |
| end_time | DATETIME | Fine fase |
| hr_avg | INTEGER? | HR medio durante questa fase |
| temp_avg | REAL? | Temperatura media durante questa fase |

**`ring_steps`**

| Colonna | Tipo | Note |
|---------|------|------|
| id | INTEGER PK | Auto-increment |
| timestamp | DATETIME | Intervallo 15 min |
| steps | INTEGER | Passi nell'intervallo |
| calories | INTEGER | kcal |
| distance_m | INTEGER | Metri |

### Modifiche a tabelle esistenti

**`workout_sets`** — nuove colonne:

| Colonna | Tipo |
|---------|------|
| avg_hr | REAL? |
| max_hr | INTEGER? |
| spo2 | INTEGER? |
| rmssd | REAL? |
| stress_index | REAL? |
| hr_recovery_bpm | INTEGER? |
| skin_temp | REAL? |

**`workout_sessions`** — nuove colonne:

| Colonna | Tipo |
|---------|------|
| avg_hr | REAL? |
| max_hr | INTEGER? |
| avg_spo2 | REAL? |
| avg_rmssd | REAL? |
| bio_stats_json | TEXT? |

`bio_stats_json` contiene: zone distribution, stress progression, recovery curve, temp baseline/end/delta.

**`hrv_readings`** — nessuna modifica. Già ha `source` (useremo `'colmi_r10'`) e `context` (`'morning'` / `'workout'`).

### Migrazione

DB version bump: v10 → v11. Drift `onUpgrade`:

```sql
-- Nuove tabelle
CREATE TABLE ring_hr_samples (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp DATETIME NOT NULL, hr INTEGER NOT NULL, source TEXT NOT NULL, quality REAL);
CREATE TABLE ring_sleep_stages (id INTEGER PRIMARY KEY AUTOINCREMENT, night_date DATE NOT NULL, stage TEXT NOT NULL, start_time DATETIME NOT NULL, end_time DATETIME NOT NULL, hr_avg INTEGER, temp_avg REAL);
CREATE TABLE ring_steps (id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp DATETIME NOT NULL, steps INTEGER NOT NULL, calories INTEGER NOT NULL, distance_m INTEGER NOT NULL);

-- workout_sets: 7 nuove colonne
ALTER TABLE workout_sets ADD COLUMN avg_hr REAL;
ALTER TABLE workout_sets ADD COLUMN max_hr INTEGER;
ALTER TABLE workout_sets ADD COLUMN spo2 INTEGER;
ALTER TABLE workout_sets ADD COLUMN rmssd REAL;
ALTER TABLE workout_sets ADD COLUMN stress_index REAL;
ALTER TABLE workout_sets ADD COLUMN hr_recovery_bpm INTEGER;
ALTER TABLE workout_sets ADD COLUMN skin_temp REAL;

-- workout_sessions: 5 nuove colonne
ALTER TABLE workout_sessions ADD COLUMN avg_hr REAL;
ALTER TABLE workout_sessions ADD COLUMN max_hr INTEGER;
ALTER TABLE workout_sessions ADD COLUMN avg_spo2 REAL;
ALTER TABLE workout_sessions ADD COLUMN avg_rmssd REAL;
ALTER TABLE workout_sessions ADD COLUMN bio_stats_json TEXT;
```

Tutte le nuove colonne sono nullable → nessun dato perso, nessun default necessario. Dopo migrazione: `dart run build_runner build` per rigenerare Drift code.

---

## 5. Sync all'apertura app — RingSyncCoordinator

### Trigger

`HomeScreen.initState()` — se ring paired e connesso, lancia sync. Non blocca la UI.

### Flusso sequenziale

```
App opens → ring connected?
  │ no → skip
  │ yes ↓
  ├─ 1. Sleep sync (cmd 0x44) → parse stages → ring_sleep_stages
  │     └─ SleepNotifier → notifica locale se dati nuovi e ore 06-12
  │     └─ MorningHrvCheck.autoAttempt() (60s real-time HRV via raw PPG)
  │           └─ success → hrv_readings (source: 'colmi_r10', context: 'morning')
  │           └─ fail → flag hrvPending = true (UI mostrerà card)
  │
  ├─ 2. HR log sync (cmd 0x15) × 2 giorni → ring_hr_samples
  │     └─ SignalProcessor.filterHrLog() → scarta outlier, smooth
  │
  ├─ 3. Steps sync (cmd 0x43) × 2 giorni → ring_steps
  │
  ├─ 4. Battery refresh
  │
  └─ 5. updateLastSync(DateTime.now()) + HomeWidget.updateWidget()
```

### Dedup

Upsert su `(timestamp, source)` — il ring restituisce sempre l'intera giornata. La chiave composita evita conflitti tra dati da fonti diverse (es. log_sync e workout per lo stesso timestamp).

### Frequenza

Max 1 sync ogni 15 minuti (cooldown in memoria). Vale anche per sync manuale da RingSettingsScreen.

### Error handling

Ogni step è indipendente. Se sleep sync fallisce, procede con HR log. Errori loggati con `debugPrint`, nessun toast automatico.

---

## 6. HR e bio tracking durante workout — WorkoutBioTracker

### Lifecycle

```
WorkoutSessionScreen.initState()
  └─ WorkoutBioTracker.start(sessionId)
       └─ RingLockManager.acquire('workout_bio')
       └─ Avvia streaming (cicla tra parametri)

WorkoutSessionScreen.dispose()
  └─ WorkoutBioTracker.stop()
       └─ Stop tutti gli streaming
       └─ RingLockManager.release('workout_bio')
```

### Streaming multi-parametro

Il ring gestisce un solo tipo real-time alla volta. Cicliamo per fase:

```
Durante SET (tracking phase):
  → Raw PPG → SignalProcessor pipeline → HR (priorità: feedback immediato)
  → Lettura spot temperatura (se supportata)

Durante RIPOSO (resting phase):
  → primi 10s: HR (per recovery rate)
  → poi 30s: Raw PPG → IBI → HRV (RMSSD) + Bayevsky SI
  → ultimi secondi: SpO2
  → Lettura spot temperatura
```

### Error recovery durante cycling

Se lo switch tra tipi real-time fallisce (ring non risponde a stop/start):
- Retry una volta dopo 500ms
- Se fallisce ancora → skip quel parametro per questo riposo, torna a HR
- Log dell'errore, nessun crash o blocco del workout

### Battery check

Prima di avviare WorkoutBioTracker, check batteria ring:
- Battery < 15% → skip raw PPG, usa firmware data (risparmio energetico)
- Battery < 5% → skip bio tracking, solo workout senza dati ring

Raw PPG streaming è più energivoro dei dati firmware. Budget stimato: ~5-8% batteria per 30 min di raw PPG.

### Dati accumulati per set

```dart
class SetBioStats {
  final double avgHr;
  final int maxHr;
  final int? spo2;
  final double? rmssd;
  final double? stressIndex;
  final int hrRecoveryBpm;     // delta HR: fine set → fine riposo
  final Duration timeInZone;
  final double? skinTemp;
}
```

### Dati accumulati per sessione

```dart
class SessionBioStats {
  final double avgHr;
  final int maxHr;
  final Map<int, int> zoneDistributionSec;  // {z1: 120, z2: 300, ...}
  final double? avgRmssd;
  final double? avgSpo2;
  final double stressProgression;  // trend SI primo → ultimo riposo
  final List<int> hrRecoveryCurve;
  final double? tempBaseline;
  final double? tempEnd;
  final double? tempDelta;
}
```

### UI — bio overlay

Durante **tracking**:
```
┌──────────────────────────────┐
│  ♥ 142 BPM   Z3 ████        │
└──────────────────────────────┘
```

Durante **riposo**:
```
┌──────────────────────────────┐
│  ♥ 98 ↓44    SpO2 97%       │
│  HRV 42ms    SI 128  🌡36.4 │
└──────────────────────────────┘
```

Si nasconde se ring non connesso. Nessun placeholder vuoto.

### CardioSessionScreen

Stesso tracker, ma mostra anche target zone da `HrZones`:
```
┌─────────────────────────────┐
│  ♥ 156 BPM                 │
│  TARGET: Z4 (152-171)  ✓   │
│  SpO2 96%  🌡36.8          │
└─────────────────────────────┘
```

### Coaching basato su bio data

| Condizione | Cue |
|---|---|
| HR > 90% HRmax | "Intensità altissima. Prendi tutto il riposo che serve." |
| HR non scende sotto 65% HRmax dopo riposo | "HR ancora alto. Aggiungi 30s di riposo." |
| SpO2 < 94% | "Saturazione bassa — respira profondamente prima del prossimo set." |
| HRV in calo costante (3+ set) | "Il sistema nervoso si sta affaticando. Considera di chiudere." |
| SI > 300 durante riposo | "Stress alto — allunga il riposo o riduci il carico." |
| Recovery rate < 20 BPM/60s | "Recupero lento — considera di chiudere qui." |
| Temp delta > +1.5°C | "Temperatura in salita significativa — idratati." |
| Temp > 38°C | "Temperatura cutanea alta — rallenta e rinfrescati." |
| Tutto ok (SpO2 stabile + HR in zona + HRV ok) | "Ottimo stato fisiologico, continua così." |

Se ring non connesso → fallback ai cue RPE esistenti (nessuna regressione).

---

## 7. Sleep sync + notifica + riepilogo

### Sleep parser

Implementazione clean-room basata sulla documentazione del protocollo (colmi.puxtril.com + reverse engineering pubblico). **Non** porting diretto da Gadgetbridge (AGPL-3.0) per evitare contaminazione licenza. Riferimento al protocollo documentato per cmd `0x44`:
- Input: pacchetti multi-packet dal ring
- Output: lista di `SleepStage(stage, startTime, endTime)`
- Staging: deep / light / rem / awake

### SleepSummary

```dart
class SleepSummary {
  final Duration timeInBed;      // tempo totale a letto (include awake)
  final Duration totalSleep;     // deep + light + rem (escluso awake)
  final Duration deep, light, rem, awake;
  final double efficiency;       // totalSleep / timeInBed (standard sleep medicine)
  final int? hrMin;              // HR minimo notturno
  final int? hrAvg;              // HR medio notturno
  final double? tempDelta;       // delta temp notte
  final double? rmssd;           // HRV notturno se disponibile
  final String qualityLabel;     // "Ottimo" / "Buono" / "Scarso"
}
```

Logica qualità:

| Condizione | Label |
|---|---|
| deep ≥ 20% + efficiency ≥ 85% + rem ≥ 20% | Ottimo |
| deep ≥ 15% + efficiency ≥ 75% | Buono |
| tutto il resto | Scarso |

### Notifica locale

Generata da `SleepNotifier` dopo sync sleep. Condizioni:
- Dati sleep nuovi (non già notificati)
- È mattina (06:00–12:00)

Formato:
```
🌙 Sonno: 7h 23m — Buono
Deep 1h 32m · REM 1h 45m · HR 52
```

Tap → apre Phoenix su Today screen.

### Today screen — SleepCard arricchita

**Senza ring** (invariato):
```
┌─ SONNO ──────────────────── ✓ ─┐
│  7h 30m · Qualità: ★★★★        │
└────────────────────────────────┘
```

**Con ring** (dati automatici):
```
┌─ SONNO ──────────────────── ✓ ─┐
│  7h 23m · Buono                 │
│  Deep 1h32  Light 3h41  REM 1h45│
│  HR 52 avg · Temp 35.8°C       │
│  ▁▃▇▇▃▁▃▇▅▃▁  ← mini hypnogram │
└────────────────────────────────┘
```

Tap → `SleepTab` con hypnogram completo.

### DailyProtocol auto-complete

```dart
bool get sleepCompleted {
  if (hasRingSleepData) return true;  // auto da ring
  return hasManualSleepEntry;          // fallback manuale
}
```

### Hypnogram widget

Grafico timeline in `SleepTab` con `fl_chart`:
```
Deep  ████      ██        ███
Light    ████      ████
REM          ████      ████
Awake                        ██
      ───────────────────────────
      23:00  01:00  03:00  05:00  07:00
```

Sotto: HR notturno trend line + temperatura se disponibile.

---

## 8. HRV mattutino — MorningHrvCheck

### Auto-attempt (dentro RingSyncCoordinator)

```
Sleep sync completato
  └─ MorningHrvCheck.autoAttempt()
       └─ RingLockManager.acquire('hrv_morning')
       └─ Raw PPG 60s → SignalProcessor pipeline → IBI → RMSSD + SI
       └─ RingLockManager.release('hrv_morning')
       └─ salva in hrv_readings (source: 'colmi_r10', context: 'morning')
       └─ HrvEngine.assessRecovery() → RecoveryStatus
```

Condizioni auto-attempt:
- Ring connesso + `capabilities.supportsHrv == true`
- Nessuna lettura HRV oggi
- È mattina (06:00–12:00)
- Lock disponibile

Se fallisce → `hrvPending = true`, nessun errore.

### Fallback manuale — card in Today screen

Quando `hrvPending == true`:
```
┌─ HRV MATTUTINO ─────────────────────┐
│  Misura non completata              │
│  Indossa il ring e resta fermo      │
│                                      │
│  [  Misura ora (60s)  ]             │
└──────────────────────────────────────┘
```

Tap → countdown 60s con animazione:
```
┌─ HRV MATTUTINO ─────────────────────┐
│              38s                     │
│         ●───────○                   │
│                                      │
│   ♥ RMSSD: 44.2ms (in corso...)    │
│   Resta fermo, respira normalmente  │
└──────────────────────────────────────┘
```

Completamento:
```
┌─ HRV MATTUTINO ──────────────── ✓ ──┐
│  RMSSD 44.2ms · lnRMSSD 3.79       │
│  SI 98 · Recovery: ready            │
│  Baseline 14gg: 41.3ms (▲ 2.9)    │
└──────────────────────────────────────┘
```

### Integrazione

- `HrvEngine.computeBaseline()` — rolling 14-day con dati `colmi_r10`
- `HrvEngine.assessRecovery()` — recovery status nel widget + Today
- `PeriodizationEngine.shouldDeload()` — aggiungere parametro `RecoveryStatus? recoveryStatus`. Il caller (WorkoutGenerator o UI) chiama `HrvEngine.assessRecovery()` con gli ultimi 3 giorni e passa il risultato. Se `veryLow`/`low` per 3+ giorni → `shouldDeload = true` (oltre ai trigger esistenti RPE ≥ 9 e biomarkerAlert)
- `OneBigThing.compute()` — aggiungere parametro `RecoveryStatus? recovery`. Si inserisce come priorità massima (prima di biomarker alerts): se recovery è `veryLow` → messaggio "Recovery compromessa — considera un giorno leggero". Se `low` → "Recovery bassa — adatta l'intensità"

---

## 9. Widget home screen del telefono

### Tecnologia

`home_widget` (pub.dev, ^0.7.0, MIT). Widget nativo: XML layout Android, SwiftUI iOS. Dati via shared storage.

### Small widget (2×2)

```
┌────────────────────┐
│  PHOENIX · LV 2    │
│  ✓✓✓○○○     3/6   │
│  👟 4.832 passi    │
│  ▸ Allenamento     │
└────────────────────┘
```

### Large widget (4×4)

```
┌────────────────────────────────────────┐
│  PHOENIX · LV 2 Intermediate    3/6   │
│  ██████████████░░░░░░░░░░░            │
│                                        │
│  ✓ Sonno 7h23m    ✓ Digiuno 16h      │
│  ✓ Meditazione    ○ Allenamento       │
│  ○ Freddo         ○ Nutrizione        │
│                                        │
│  🌙 Deep 1h32 · REM 1h45 · HR 52     │
│  ♥ HRV 42ms · Recovery: ready        │
│  👟 4.832 passi · 🔥 186 kcal        │
│                                        │
│  ▸ Allenamento Upper Body             │
└────────────────────────────────────────┘
```

### Elementi protocollo nel widget

| Elemento | ✓ quando | Label mostrata |
|---|---|---|
| Sonno | Ring sync o input manuale | Durata |
| Digiuno | Sessione fasting completata | Ore |
| Allenamento | Sessione workout completata | Tipo (Upper/Lower/Full) |
| Nutrizione | Pasti loggati + protein target | "2/3 pasti" |
| Freddo | Sessione cold completata | Durata + temp |
| Meditazione | Sessione meditazione completata | Durata |

Stato: `✓` completato, `○` da fare, `◐` in corso.

### Livello Phoenix

Il livello dell'utente (Beginner/Intermediate/Advanced) con numero, da settings.

### Aggiornamento

- Dopo ogni sync (RingSyncCoordinator → `HomeWidget.updateWidget()`)
- Dopo completamento attività protocollo
- Ogni 30 min via WorkManager (contapassi se app chiusa)

### Shared storage

```dart
HomeWidget.saveWidgetData('level_name', 'Intermediate');
HomeWidget.saveWidgetData('level_number', 2);
HomeWidget.saveWidgetData('protocol_done', 3);
HomeWidget.saveWidgetData('protocol_total', 6);
HomeWidget.saveWidgetData('sleep_done', true);
HomeWidget.saveWidgetData('sleep_label', '7h23m');
HomeWidget.saveWidgetData('fasting_done', true);
HomeWidget.saveWidgetData('fasting_label', '16h');
HomeWidget.saveWidgetData('training_done', false);
HomeWidget.saveWidgetData('training_label', 'Upper Body');
HomeWidget.saveWidgetData('nutrition_done', false);
HomeWidget.saveWidgetData('nutrition_label', '2/3 pasti');
HomeWidget.saveWidgetData('cold_done', false);
HomeWidget.saveWidgetData('cold_label', '');
HomeWidget.saveWidgetData('meditation_done', true);
HomeWidget.saveWidgetData('meditation_label', '10 min');
HomeWidget.saveWidgetData('steps', 4832);
HomeWidget.saveWidgetData('calories', 186);
HomeWidget.saveWidgetData('sleep_summary', '7h23m Buono');
HomeWidget.saveWidgetData('hrv_ms', 42);
HomeWidget.saveWidgetData('recovery', 'ready');
HomeWidget.saveWidgetData('hr_rest', 52);
HomeWidget.saveWidgetData('temp', 36.2);
HomeWidget.saveWidgetData('next_step', 'Allenamento Upper Body');
```

### Limitazioni

- Android: XML layout, aggiornamento sistema max ogni 30 min, tap per refresh
- iOS: WidgetKit SwiftUI, timeline-based
- Widget non comunica col ring — mostra solo dati già sincronizzati dall'app
- **iOS background BLE**: iOS non permette scan BLE in background, solo reconnect a periferiche note. Il widget update ogni 30 min via WorkManager legge solo dati dal DB locale — **non** tenta di connettersi al ring. Il sync avviene solo quando l'app è in foreground
- Tutti i key shared storage prefissati con `phoenix_` per evitare collisioni (es. `phoenix_steps`, `phoenix_level_name`)

---

## 10. Nuovi file (~12)

| File | Tipo | Scopo |
|------|------|-------|
| `core/ring/ring_lock_manager.dart` | Core | Mutex operazioni real-time BLE |
| `core/ring/ring_sync_coordinator.dart` | Core | Sync completo all'apertura app |
| `core/ring/workout_bio_tracker.dart` | Core | Multi-parametro real-time durante workout |
| `core/ring/morning_hrv_check.dart` | Core | Auto HRV 60s + fallback manuale |
| `core/ring/signal_processor.dart` | Core | Raw PPG pipeline: SQI → NLMS → AMPD → IBI → HR/HRV/SI |
| `core/ring/sleep_notifier.dart` | Core | Notifica sleep + SleepSummary |
| `core/ring/sleep_parser.dart` | Core | Parser cmd 0x44 (porta da Gadgetbridge Java) |
| `core/database/daos/ring_data_dao.dart` | DAO | CRUD ring_hr_samples, ring_sleep_stages, ring_steps |
| `features/today/widgets/hrv_morning_card.dart` | Widget | Card HRV manuale in Today screen |
| `features/workout/widgets/bio_overlay.dart` | Widget | HR/SpO2/HRV/temp/SI live durante workout |
| `features/conditioning/widgets/sleep_hypnogram.dart` | Widget | Hypnogram timeline fl_chart |
| `features/widgets/phoenix_home_widget.dart` | Widget | Logica aggiornamento widget home screen |

## 11. File modificati (~14)

| File | Modifica |
|------|----------|
| `core/database/database.dart` | 3 nuove tabelle, colonne aggiuntive workout_sets/sessions, migrazione DB |
| `core/database/tables.dart` | Definizione tabelle ring_hr_samples, ring_sleep_stages, ring_steps |
| `core/ring/ring_protocol.dart` | Comandi raw PPG (0x68), raw accel (0x67), raw SpO2 (0x66), sleep parser |
| `core/ring/ring_constants.dart` | Costanti cmd raw |
| `core/ring/ring_service.dart` | Metodi readRawPpg(), readRawAccel(), readSleep() |
| `core/models/daily_protocol.dart` | Auto-complete sleep da ring |
| `core/models/coach_prompts.dart` | Coaching cues basati su HR/SpO2/HRV/temp/SI |
| `core/models/periodization_engine.dart` | shouldDeload integra HRV trend reale |
| `core/models/activity_rings_data.dart` | OneBigThing usa recovery status |
| `features/workout/workout_session_screen.dart` | WorkoutBioTracker start/stop, bio_overlay |
| `features/cardio/cardio_session_screen.dart` | Bio overlay con target zone |
| `features/conditioning/sleep_tab.dart` | Hypnogram se dati ring |
| `features/conditioning/cold_tab.dart` | Bio tracking durante cold |
| `features/today/today_screen.dart` | SleepCard arricchita, HRV morning card, readiness |
| `app/providers.dart` | Provider per nuovi componenti |

## 12. Dipendenze nuove

| Pacchetto | Versione | Licenza | Scopo |
|---------|---------|---------|-------|
| home_widget | ^0.7.0 | MIT | Widget nativi home screen Android/iOS |

Tutto il resto (fl_chart, drift, universal_ble, tdesign) è già presente.

## 13. Ordine implementazione

```
Fase 1: Signal foundation
  ├─ Raw PPG/accel commands in ring_protocol + ring_constants
  ├─ SignalProcessor (SQI + NLMS + AMPD + IBI → HR/HRV/SI)
  ├─ ring_data_dao + nuove tabelle + migrazione DB
  └─ RingLockManager

Fase 2: Sleep + notifica
  ├─ sleep_parser (porta da Gadgetbridge Java)
  ├─ SleepNotifier + notifica locale
  ├─ SleepCard arricchita + hypnogram
  └─ DailyProtocol auto-complete

Fase 3: Sync automatico + HRV mattutino
  ├─ RingSyncCoordinator (trigger da HomeScreen)
  ├─ MorningHrvCheck (auto + manuale)
  ├─ HRV morning card in Today
  └─ PeriodizationEngine integration

Fase 4: Bio tracking workout
  ├─ WorkoutBioTracker (HR + SpO2 + HRV + temp + SI)
  ├─ bio_overlay widget
  ├─ Coaching cues multi-parametro
  ├─ CardioSessionScreen integration
  └─ Cold tab integration

Fase 5: Widget home screen
  ├─ home_widget dependency
  ├─ Android XML layout (small + large)
  ├─ iOS SwiftUI (small + large)
  └─ phoenix_home_widget.dart (update logic)
```

Fase 1 è prerequisito di tutto. Fasi 2-4 possono procedere in parallelo dopo Fase 1. Fase 5 è indipendente (legge solo dati DB).

---

## 14. Riverpod providers

| Provider | Tipo | Scopo |
|---|---|---|
| `ringLockManagerProvider` | `Provider<RingLockManager>` | Singleton, condiviso da tutti i consumer |
| `ringSyncCoordinatorProvider` | `Provider<RingSyncCoordinator>` | Dipende da ringService, ringDataDao, signalProcessor |
| `workoutBioTrackerProvider` | `Provider<WorkoutBioTracker>` | Dipende da ringService, ringLockManager, signalProcessor |
| `morningHrvCheckProvider` | `Provider<MorningHrvCheck>` | Dipende da ringService, ringLockManager, hrvDao, signalProcessor |
| `signalProcessorProvider` | `Provider<SignalProcessor>` | Stateless, nessuna dipendenza |
| `sleepNotifierProvider` | `Provider<SleepNotifier>` | Dipende da notificationService, ringDataDao |
| `ringDataDaoProvider` | `Provider<RingDataDao>` | Dipende da databaseProvider |
| `hrvPendingProvider` | `StateProvider<bool>` | Flag per card HRV manuale in Today |

---

## 15. Fuori scope

- **CNN quality classifier** — SQI statistico sufficiente per ora, ML on-device se serve dopo
- **Supporto multi-device** — solo R10. Architettura modulare per futuro
- **Cloud sync** — Phoenix è local-first
- **SpO2 come feature primaria** — dato indicativo (LED verde), mostrato ma senza alert clinici
- **HR continuo 24h** — troppo impatto batteria, solo on-demand
