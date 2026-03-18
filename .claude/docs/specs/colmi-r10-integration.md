# Colmi R10 Smart Ring Integration

**Data:** 2026-03-16
**Stato:** Fase 0 completata (2026-03-18)
**Tipo:** Feature (multi-fase)
**Priorità:** Alta — colma il gap più grande di Phoenix (dati fisiologici manuali → automatici)

---

## 1. Cosa stiamo costruendo

Integrazione del Colmi R10 (smart ring ~€30) come **device ufficiale opzionale** di Phoenix. L'app funziona perfettamente senza ring — il ring aggiunge dati fisiologici automatici dove oggi l'utente inserisce tutto a mano.

Phoenix è **open source** → tutte le dipendenze devono essere compatibili con licenze open source.

---

## 2. Perché

Phoenix oggi calcola tutto da input manuali:
- Sleep: l'utente inserisce ore e qualità → inaffidabile
- HRV: HrvEngine esiste ma riceve dati manuali → quasi mai usato
- HR durante workout: non esiste
- Recovery: stimato da questionario soggettivo

Il R10 a €30 risolve tutto questo. Il rapporto costo/beneficio è il migliore sul mercato wearable.

---

## 3. Hardware: Colmi R10 — specifiche verificate

| Componente | Dettaglio | Fonte |
|-----------|-----------|-------|
| Chip BLE | Realtek RTL8762 ESF (BLE 5.0) | Specifiche ufficiali |
| Sensore PPG | Vcare VC30F, LED verde | Specifiche ufficiali |
| Accelerometro | STK8321, 3 assi | Specifiche ufficiali |
| Batteria | 15-18 mAh Li-Po | Specifiche ufficiali |
| Resistenza acqua | 5ATM / IP68 | Specifiche ufficiali |
| Prezzo | €18-50 (AliExpress → Amazon EU) | Mercato 2026 |
| Temperatura | Presente su alcune revisioni HW (flag firmware `mSupportTemperature`) | Reverse engineering |
| App ufficiale | Qring | — |

### Capacità di campionamento

Il R10 ha **due modalità** — questo è cruciale per il design:

| Modalità | Quando | Frequenza PPG | Dati disponibili |
|---------|--------|---------------|------------------|
| **Sparso** | Giorno, attività normale | Ogni N minuti (configurabile via `0x16`, storage in slot da 5 min) | HR spot, step count |
| **Denso** | Sonno (automatico) oppure real-time su richiesta (`0x69`) | Quasi continuo | HR continuo, HRV calcolabile, sleep staging |

**Implicazione chiave:** Phoenix può attivare campionamento denso on-demand durante workout, cold exposure, spot check HRV — e tornare a sparso dopo. Budget batteria stimato: ~1-1.5h dense/giorno è sostenibile.

---

## 4. Protocollo BLE — verificato da codice sorgente

### Fonti di verità
- **Primaria:** [`tahnok/colmi_r02_client`](https://github.com/tahnok/colmi_r02_client) (Python, 603 stars, R10-compatibile)
- **Secondaria:** [Gadgetbridge PR #3896](https://codeberg.org/Freeyourgadget/Gadgetbridge/pulls/3896) (Java)
- **Terza:** [`Praise650/colmi-smart-ring-app`](https://github.com/Praise650/colmi-smart-ring-app) (Flutter, minimale)

### Caratteristiche BLE

| Parametro | Valore |
|-----------|--------|
| Service UUID | `6E40FFF0-B5A3-F393-E0A9-E50E24DCCA9E` |
| TX (notify/read) | `6E400003-B5A3-F393-E0A9-E50E24DCCA9E` |
| RX (write) | `6E400002-B5A3-F393-E0A9-E50E24DCCA9E` |
| Formato pacchetto | 16 byte fissi: byte[0]=comando, byte[1-14]=payload, byte[15]=checksum |
| Checksum | Somma byte[0..14] & 0xFF |

### Comandi verificati

| Funzione | Byte | Costante | Note |
|----------|------|----------|------|
| Set time | `0x01` | `CMD_SET_TIME` | Anche capability detection (risposta contiene flag sensori) |
| Battery | `0x03` | `CMD_BATTERY` | Livello + stato ricarica |
| HR log settings | `0x16` | `CMD_HEART_RATE_LOG_SETTINGS` | Intervallo campionamento (1-255 min) |
| HR log read | `0x15` | `CMD_READ_HEART_RATE` | 288 punti/giorno (slot 5 min) |
| SpO2 sync | `0x37` | `CMD_SYNC_SPO2` | Storico SpO2 |
| HRV sync | `0x39` | — | Dati HRV (firmware-dependent, a volte no response) |
| Step data | `0x43` | `CMD_GET_STEP_SOMEDAY` | Passi giornalieri |
| Sleep sync | `0x44` | `CMD_SYNC_SLEEP` | Dati sonno (staging dal ring) |
| Find device | `0x50` | `CMD_FIND_DEVICE` | Vibrazione ring |
| Real-time start | `0x69` | `CMD_START_REAL_TIME` | Streaming continuo HR/SpO2/HRV |
| Real-time stop | `0x6A` | `CMD_STOP_REAL_TIME` | Stop streaming |
| Power off | `0x08` | `CMD_POWER_OFF` | Spegnimento ring |

### Capability flags (dalla risposta a `0x01`)
- `mSupportTemperature` — sensore temperatura presente
- `mSupportHrv` — HRV supportato dal firmware
- `mSupportSpo2` — SpO2 supportato
- Utili per feature discovery a runtime

---

## 5. Cosa è scientificamente fattibile (e cosa no)

### FATTIBILE — supportato da letteratura

| Feature | Condizione | Paper di riferimento |
|---------|-----------|---------------------|
| Sleep staging (deep/light/REM/wake) | Campionamento denso notturno (il ring lo fa già) | UC Irvine End-to-End Pipeline (2023); Kasaeyan Naeini et al., ACM 2023 (DOI: 10.1145/3616019) |
| HRV notturno (RMSSD) | Finestre continue ≥30s durante sonno | Peng et al. 2014 (DOI: 10.1186/1475-925X-13-50) |
| HRV spot check mattutino | 5 min campionamento denso al risveglio | Standard Task Force ESC/NASPE 1996 |
| HR live durante workout | Real-time via `0x69` | Chung et al. 2020 (CNN-LSTM HR estimation during exercise) |
| HR recovery post-cold | Real-time attivato da Phoenix, 5-10 min | — (misurazione diretta) |
| Motion artifact removal | NLMS adaptive filter con accelerometro | IEEE 2014 (NLMS/RLS per PPG MA removal) |
| Signal quality assessment | CNN leggero per scartare campioni rumorosi | Kasaeyan Naeini et al., ACM 2023 |
| Step counting | Accelerometro 3-axis | — (standard) |
| Temperatura trend notturno | Se sensore presente (capability flag) | — (misurazione diretta) |

### NON FATTIBILE — limiti fisici

| Feature | Perché | Alternativa |
|---------|--------|-------------|
| HRV continuo diurno | Campionamento sparso, no beat-to-beat IBI | Spot check on-demand (5 min) |
| Stress index real-time diurno | Richiede HRV continuo | Stress stimato da HR trend + questionario |
| SpO2 clinico | LED verde singolo (servirebbe rosso + IR) | SpO2 indicativo, non diagnostico |
| Auto-detect tipo allenamento | Solo accelerometro, no classificazione attività | Phoenix sa già cosa l'utente sta facendo (workout guidato) |
| ECG-grade R-R intervals | PPG ≠ ECG, jitter intrinseco | PPG-derived IBI sufficiente per HRV trend, non per analisi clinica |

---

## 6. Impatto su Phoenix — mapping feature

### Componenti Phoenix che beneficiano direttamente

| Componente esistente | File | Oggi | Con R10 |
|---------------------|------|------|---------|
| HrvEngine | `core/models/hrv_engine.dart` | Input manuale (quasi mai usato) | **RMSSD reale** da ring notturno/spot check |
| SleepScore | `core/models/sleep_score.dart` | Input manuale ore/qualità | **Staging reale** + HR + temperatura |
| SleepTab | `features/conditioning/sleep_tab.dart` | Bedtime/wake manuali | **Automatico** + hypnogram |
| SleepCoach | `core/models/sleep_environment.dart` | Tips generici | Tips basati su **dati reali** (qualità, regolarità misurata) |
| DailyProtocol | `core/models/daily_protocol.dart` | Sleep da input manuale | Sleep da ring (completamento automatico) |
| WorkoutSessionScreen | `features/workout/workout_session_screen.dart` | No HR | **HR live** + zone display |
| HrZones | `core/models/hr_zones.dart` | Solo calcolo teorico | **Zone reali** visualizzate durante workout |
| CardioSessionScreen | `features/cardio/cardio_session_screen.dart` | HR manuale / non disponibile | **HR real-time** con zone target |
| ColdProgression | `core/models/cold_progression.dart` | Solo timer + constraint 6h | + **HR recovery curve** (dato scientifico chiave Søberg) |
| OneBigThing | `core/models/activity_rings_data.dart` | Basato su dati parziali | **Readiness score** data-driven |
| ActivityRings | `features/workout/widgets/activity_rings.dart` | Progresso stimato | Progresso da **dati reali** (passi, HR, sleep) |
| PeriodizationEngine | `core/models/periodization_engine.dart` | shouldDeload da RPE soggettivo | shouldDeload da **HRV trend** + RPE |
| ReportGenerator | `core/models/report_generator.dart` | Report da dati manuali | Report con **dati fisiologici reali** |
| TemplateChat | `core/llm/template_chat.dart` | Contesto limitato | Contesto arricchito con dati ring |
| BackgroundTasks | `core/background/background_tasks.dart` | Inactivity check | + **sync notturno automatico** |

### Nuovi componenti necessari

| Componente | Tipo | Scopo |
|-----------|------|-------|
| RingService | Core | BLE connection, discovery, pairing, reconnect |
| RingProtocol | Core | Packet encoding/decoding, command dispatch |
| RingSync | Core | Background sync, data merge, conflict resolution |
| RingSamplingController | Core | On-demand dense sampling (workout, cold, spot check) |
| RingDao | DAO | Raw ring data storage, processed windows |
| RingSettingsScreen | Screen | Pairing, status, battery, sync settings |
| RingStatusBadge | Widget | Connection status indicator (header/today screen) |
| SignalQualityFilter | Model | SQI-based sample acceptance/rejection |
| HrZoneOverlay | Widget | Real-time HR zone display per workout/cardio |
| SleepHypnogram | Widget | Visual sleep stage timeline |
| ReadinessScore | Model | Morning readiness from HRV + sleep + HR resting |

---

## 7. Dipendenze — compatibilità open source

### DA USARE

| Pacchetto | Versione | Licenza | Scopo |
|-----------|----------|---------|-------|
| universal_ble | ^1.2.0 | BSD-3 | BLE communication — open source, tutte le piattaforme |
| drift | ^2.23.1 | MIT | Database (già in Phoenix) |
| fl_chart | ^0.70.2 | BSD-3 | Charts (già in Phoenix) |

### DA NON USARE

| Pacchetto | Motivo |
|-----------|--------|
| flutter_blue_plus | **Licenza proprietaria** (FlutterBluePlus License) — uso commerciale a pagamento ($3K-$9K). Tecnicamente superiore (156K download/settimana, 10 issue aperte, background BLE documentato) ma **incompatibile con progetto open source**: chiunque forki Phoenix per uso commerciale dovrebbe pagare. |
| flutter_reactive_ble | **Effettivamente abbandonato**. Ultimo commit: feb 2025 (14+ mesi fa). 129 issue senza risposta. 21 PR non mergiati. Philips Hue ha smesso di mantenere il pacchetto. |
| isar | **Abbandonato** dal 2024. Nessuna release stabile da 2 anni. Core Rust rende fork difficili |
| tflite_flutter | In declino, Google migra a MediaPipe. Se serve ML: valutare `onnxruntime_flutter` o `flutter-mediapipe` |

### Perché universal_ble

| Criterio | universal_ble | flutter_blue_plus | flutter_reactive_ble |
|----------|--------------|-------------------|---------------------|
| Licenza | **BSD-3** (open source) | Proprietaria ($3K+) | BSD-3 |
| Manutenzione | Attivo (feb 2026) | Attivissimo | **Fermo da 14 mesi** |
| Piattaforme | **Tutte e 6** (Android, iOS, macOS, Win, Linux, Web) | 5 (no Windows nativo) | Solo Android, iOS |
| Pub.dev score | **150/160** (più alto) | 135/160 | 130/160 |
| Download/settimana | 15K (più piccolo) | 156K | 39K |
| Maintainer | Navideck (azienda) | 1 persona | Philips Hue (inattivo) |
| Background BLE | Android ForegroundTask | iOS restoreState + Android | Base |
| Rischio | Community piccola ma in crescita | Licenza blocca fork open source | Pacchetto morto |

**Trade-off accettato:** community più piccola in cambio di licenza aperta + manutenzione attiva. Il codice BLE di Phoenix è isolato in `RingService` — se universal_ble dovesse perdere manutenzione, il wrapper è sostituibile senza toccare il resto dell'app.

---

## 8. Architettura

### Principio: Ring come data source opzionale

```
┌─────────────────────────────────────────────┐
│                 Phoenix App                  │
│                                              │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐  │
│  │ HrvEngine│  │SleepScore│  │WorkoutSess│  │
│  │          │  │          │  │           │  │
│  └────┬─────┘  └────┬─────┘  └─────┬─────┘  │
│       │              │              │        │
│  ┌────▼──────────────▼──────────────▼─────┐  │
│  │         DataSourceResolver             │  │
│  │  if (ring connected) → ring data       │  │
│  │  else → manual input (existing)        │  │
│  └────┬───────────────────────┬───────────┘  │
│       │                       │              │
│  ┌────▼─────┐           ┌────▼──────┐       │
│  │ RingSync │           │ Manual    │       │
│  │ (BLE)    │           │ Input     │       │
│  └────┬─────┘           │ (existing)│       │
│       │                 └───────────┘       │
└───────┼─────────────────────────────────────┘
        │ BLE
   ┌────▼─────┐
   │ Colmi R10│
   └──────────┘
```

### Pattern: nessun componente esistente cambia interfaccia

I componenti esistenti (HrvEngine, SleepScore, ecc.) **non sanno** da dove vengono i dati. Un `DataSourceResolver` determina se usare dati ring o input manuale. Questo garantisce:
- Phoenix funziona identicamente senza ring
- Nessuna regressione sulle feature esistenti
- Il ring è un enhancement, non una dipendenza

---

## 9. Database — nuove tabelle

### ring_raw_samples
| Colonna | Tipo | Note |
|---------|------|------|
| id | INTEGER PK | Auto-increment |
| timestamp | DATETIME | Precisione ms |
| hr | INTEGER? | BPM, nullable |
| spo2 | INTEGER? | %, nullable |
| temperature | REAL? | °C, nullable |
| steps | INTEGER | Cumulativo giornaliero |
| signal_quality | REAL? | 0-1, se calcolabile |
| source | TEXT | 'log_sync' / 'real_time' / 'sleep_sync' |

### ring_sleep_stages
| Colonna | Tipo | Note |
|---------|------|------|
| id | INTEGER PK | Auto-increment |
| date | DATE | Notte di riferimento |
| stage | TEXT | 'deep' / 'light' / 'rem' / 'awake' |
| start_time | DATETIME | Inizio fase |
| end_time | DATETIME | Fine fase |
| source | TEXT | 'ring_native' / 'phoenix_ml' |

### ring_device
| Colonna | Tipo | Note |
|---------|------|------|
| id | INTEGER PK | Singolo device |
| mac_address | TEXT | BLE MAC |
| name | TEXT | Device name |
| firmware_version | TEXT | Rilevato a connessione |
| capabilities_json | TEXT | Flag sensori supportati |
| last_sync | DATETIME | Ultimo sync completato |
| battery_level | INTEGER | Ultimo livello batteria noto |

---

## 10. Piano di implementazione

### Grafo dipendenze

```
Fase 0: BLE Foundation
  │
  ├──→ Fase 1: Sleep Sync ──→ Fase 4: Cold Recovery
  │         │
  │         └──→ Fase 2: HRV + Readiness
  │
  └──→ Fase 3: HR Live Workout
                    │
                    └──→ Fase 4: Cold Recovery

Fase 5 (opzionale): Signal Processing — indipendente, solo se necessaria dopo Fase 4
```

- Fase 0 è prerequisito di tutto
- Fase 1 e 3 possono procedere **in parallelo** dopo Fase 0 (sleep sync e HR live non dipendono l'una dall'altra)
- Fase 2 richiede Fase 1 (HRV notturno viene dal sync sleep/HR)
- Fase 4 richiede Fase 1 + 3 (usa sia sync che real-time)

### Priorità per valore

| Fase | Valore per Phoenix | Complessità | ROI |
|------|-------------------|-------------|-----|
| **0** | Nessuno da solo (infrastruttura) | Media | Prerequisito obbligatorio |
| **1** | **Altissimo** — sleep è il gap più grande, dati più inaffidabili oggi | Alta (parser multi-packet) | **Massimo** |
| **3** | **Alto** — HR live durante workout è la feature più visibile | Bassa (real-time è semplice) | **Alto** |
| **2** | Alto — readiness score data-driven cambia il decision-making | Media | Medio-Alto |
| **4** | Medio — HR recovery post-cold è scientificamente importante ma di nicchia | Bassa | Medio |
| **5** | Basso — il ring produce già dati decenti | Alta | **Basso** (da saltare se non necessaria) |

### Ordine raccomandato

```
Settimana 1-2:  Fase 0 — BLE Foundation
                ├── Porting packet/battery/capabilities da Dart esistente + Python
                ├── RingService con universal_ble
                └── UI settings: scan, pair, status

Settimana 3-4:  Fase 1 — Sleep Sync (MASSIMA PRIORITÀ)
                ├── Porting HR log parser (Python) + sleep parser (Gadgetbridge Java)
                ├── DataSourceResolver pattern
                ├── Hypnogram widget
                └── DailyProtocol auto-complete

Settimana 4-5:  Fase 3 — HR Live Workout (in parallelo a fine Fase 1)
                ├── Porting real_time.py (semplice: start/stop/read)
                ├── HrZoneOverlay widget
                └── WorkoutSessionScreen + CardioSessionScreen integration

Settimana 5-6:  Fase 2 — HRV + Readiness
                ├── HRV sync (comando 0x39, firmware-dependent)
                ├── Morning spot check (5 min real-time)
                ├── ReadinessScore model
                └── PeriodizationEngine deload integration

Settimana 6-7:  Fase 4 — Cold Recovery + Conditioning
                ├── HR durante cold (real-time già implementato in Fase 3)
                ├── Recovery curve widget
                └── Temperatura sync (se sensore presente)

            ⏸️  PAUSA — Valutare qualità dati con uso reale

Se necessario: Fase 5 — Signal Processing Enhancement
```

### Decision gates

| Dopo | Valutare | Decisione |
|------|----------|-----------|
| Fase 0 | Ring si connette e legge battery/capabilities? | Se no: verificare firmware, debugging BLE |
| Fase 1 | Sleep staging del ring è coerente con percezione utente? | Se sì: Fase 5 non serve. Se no: valutare ML |
| Fase 2 | HRV sync funziona sul firmware specifico? | Se `0x39` non risponde: skip HRV sync, usare solo spot check real-time |
| Fase 3 | HR real-time è stabile durante movimento? | Se rumoroso: valutare SQI filter (anticipo parziale Fase 5) |
| Fase 4 | Tutti i dati ring migliorano effettivamente le decisioni Phoenix? | Retrospettiva: cosa ha funzionato, cosa no |

### Integrazione con il master plan esistente

Questa integrazione è **indipendente** dalle fasi A-N del `protocol-completion-master.md`. Può procedere in parallelo. L'unica intersezione è:

| Fase ring | Fase master | Intersezione |
|-----------|-------------|-------------|
| Fase 2 (HRV) | Fase H (HRV Tracking) | Fase H ha creato HrvEngine — Fase ring 2 lo alimenta con dati reali |
| Fase 3 (HR live) | Fase F (Structured Cardio) | CardioSessionScreen esiste — Fase ring 3 aggiunge HR real-time |
| Fase 1 (Sleep) | Fase L (Sleep Optimization) | SleepCoach/SleepEnvironment esistono — Fase ring 1 li rende data-driven |

Non ci sono conflitti: le fasi master hanno creato l'infrastruttura (modelli, engine, screen), le fasi ring la alimentano con dati reali.

---

### Fase 0 — BLE Foundation (stima: 1 sprint)

**Scope:** Connessione BLE base, discovery, pairing, read battery/firmware.

**File da creare:**
- `lib/core/ring/ring_service.dart` — BLE connection lifecycle (scan, connect, reconnect, disconnect)
- `lib/core/ring/ring_protocol.dart` — Packet encode/decode, checksum, command dispatch
- `lib/core/ring/ring_constants.dart` — UUID, command bytes, capability flags
- `lib/features/settings/ring_settings_screen.dart` — Scan + pair UI, status, battery

**File da modificare:**
- `lib/core/database/database.dart` — Aggiunta tabella `ring_device`, migrazione DB
- `lib/features/settings/` — Aggiunta sezione "Smart Ring" in settings

**Acceptance criteria:**
- [ ] Scan BLE trova il R10
- [ ] Pairing funziona (set time + capability detection)
- [ ] Battery level visibile in settings
- [ ] Firmware version visibile
- [ ] Reconnect automatico dopo disconnessione
- [ ] Capability flags letti e salvati
- [ ] Funziona su Android (iOS: verificare background BLE limits)

**Dipendenza:** `universal_ble` (BSD-3)

---

### Fase 1 — Sleep Data Sync (stima: 1 sprint)

**Scope:** Sync automatico dati sonno dal ring, visualizzazione hypnogram, alimentazione SleepScore/SleepTab.

**File da creare:**
- `lib/core/ring/ring_sync.dart` — Background sync logic (sleep + HR log + SpO2)
- `lib/core/ring/ring_dao.dart` — DAO per ring_raw_samples e ring_sleep_stages
- `lib/core/ring/data_source_resolver.dart` — If ring → ring data, else → manual
- `lib/features/conditioning/widgets/sleep_hypnogram.dart` — Hypnogram chart (fl_chart)

**File da modificare:**
- `lib/core/database/database.dart` — Tabelle `ring_raw_samples`, `ring_sleep_stages`
- `lib/core/models/sleep_score.dart` — Accetta dati ring via DataSourceResolver
- `lib/features/conditioning/sleep_tab.dart` — Mostra hypnogram se dati ring disponibili
- `lib/core/models/daily_protocol.dart` — Sleep completato automaticamente se ring synced
- `lib/core/background/background_tasks.dart` — Sync mattutino automatico

**Acceptance criteria:**
- [ ] Sync sleep data dal ring (staging, durata, efficienza)
- [ ] Hypnogram visualizzato in SleepTab
- [ ] SleepScore calcolato da dati ring (se disponibili)
- [ ] DailyProtocol marca sleep come completato automaticamente
- [ ] Background sync al mattino (WorkManager)
- [ ] Fallback a input manuale se ring non connesso

---

### Fase 2 — HRV Reale + Readiness (stima: 1 sprint)

**Scope:** HRV notturno reale, spot check mattutino, readiness score data-driven.

**File da creare:**
- `lib/core/ring/ring_sampling_controller.dart` — On-demand dense sampling (start/stop real-time)
- `lib/core/models/readiness_score.dart` — Readiness 0-100 da HRV + sleep + HR resting
- `lib/features/hrv/morning_check_screen.dart` — Guided 5-min HRV spot check

**File da modificare:**
- `lib/core/models/hrv_engine.dart` — Accetta RMSSD reale da ring (via DataSourceResolver)
- `lib/core/ring/ring_sync.dart` — Aggiunta sync HRV notturno (comando `0x39`)
- `lib/core/models/activity_rings_data.dart` — OneBigThing usa readiness score
- `lib/core/models/periodization_engine.dart` — shouldDeload integra HRV trend
- `lib/features/today/today_screen.dart` — Readiness badge mattutino (se dati disponibili)

**Acceptance criteria:**
- [ ] HRV notturno sincronizzato (se firmware lo supporta)
- [ ] Spot check HRV mattutino: attiva real-time 5 min, calcola RMSSD, stop
- [ ] Readiness score calcolato e visualizzato
- [ ] HrvEngine alimentato con dati reali
- [ ] PeriodizationEngine usa HRV trend per deload decision
- [ ] Graceful degradation se HRV non supportato dal firmware

---

### Fase 3 — HR Live Workout (stima: 1 sprint)

**Scope:** HR real-time durante workout e cardio, zone display, recovery tracking.

**File da creare:**
- `lib/features/workout/widgets/hr_zone_overlay.dart` — Real-time HR + zone bar durante workout
- `lib/features/workout/widgets/hr_recovery_chart.dart` — Post-exercise HR recovery curve

**File da modificare:**
- `lib/features/workout/workout_session_screen.dart` — Attiva real-time a inizio workout, mostra HR overlay
- `lib/features/cardio/cardio_session_screen.dart` — HR real-time con zone target (HrZones già esiste)
- `lib/core/ring/ring_sampling_controller.dart` — Gestione workout mode (start/stop con sessione)
- `lib/core/models/hr_zones.dart` — Calcolo zone da HR max reale (se disponibile da ring history)
- `lib/core/models/report_generator.dart` — Report con HR data (avg, max, zone distribution)
- `lib/core/database/daos/workout_dao.dart` — Salva HR avg/max per sessione

**Acceptance criteria:**
- [ ] HR live visualizzato durante workout guidato
- [ ] Zone HR colorate in tempo reale
- [ ] HR medio/max salvati con la sessione
- [ ] CardioSessionScreen mostra HR vs target zone
- [ ] Real-time si attiva automaticamente a inizio sessione, stop a fine
- [ ] Report post-workout include dati HR
- [ ] Funziona senza ring (nessuna regressione)

---

### Fase 4 — Cold Recovery + Conditioning (stima: 0.5 sprint)

**Scope:** HR recovery post-cold, temperatura trend, conditioning data enrichment.

**File da modificare:**
- `lib/features/conditioning/cold_tab.dart` — Attiva real-time durante cold, mostra HR recovery
- `lib/core/models/cold_progression.dart` — HR recovery come metrica aggiuntiva
- `lib/core/ring/ring_sync.dart` — Sync temperatura notturna (se supportata)
- `lib/features/conditioning/conditioning_history.dart` — Trend HR recovery nei grafici

**Acceptance criteria:**
- [ ] HR monitorato durante cold exposure
- [ ] Curva HR recovery post-cold visualizzata
- [ ] Temperatura notturna sincronizzata e mostrata (se sensore presente)
- [ ] Dati recovery integrati in conditioning history

---

### Fase 5 (opzionale) — Signal Processing Enhancement

**Scope:** Miglioramento qualità dati con processing software. **Solo se i dati nativi del ring risultano insufficienti.**

**Componenti potenziali:**
- `SignalQualityFilter` — SQI-based filtering (scarta campioni rumorosi)
- NLMS adaptive filtering per motion artifact reduction
- ML model per sleep staging proprietario (vs. usare staging del ring)

**Decision gate:** Dopo Fase 0-4, valutare se la qualità dei dati nativi del ring è sufficiente. Se sì, questa fase non serve. Il ring Qring già produce staging ragionevole (confermato dallo screenshot dell'utente).

---

## 11. Signal processing — pipeline scientifica (Fase 5)

Se necessaria, la pipeline è basata su letteratura verificata:

```
Raw PPG → [SQI Assessment] → [Motion Artifact Removal] → [Peak Detection] → [HR/HRV Extraction]
              CNN (ACM 2023)      NLMS (IEEE 2014)         AMPD (MDPI 2020)    Standard formulas
```

| Step | Tecnica | Paper | DOI |
|------|---------|-------|-----|
| Quality assessment | CNN (VGG16/MobileNetV2) | Kasaeyan Naeini et al., ACM Trans. Computing Healthcare, 2023 | 10.1145/3616019 |
| Motion artifact removal | NLMS adaptive filter + accelerometro reference | IEEE 2011-2014 (multiple) | — |
| Signal separation | cICA (constrained ICA) | Peng et al., BioMed Eng OnLine, 2014 | 10.1186/1475-925X-13-50 |
| Peak detection | Modified AMPD (time-domain, lightweight) | Sensors MDPI, 2020 | 10.3390/s20061783 |
| HR during exercise | CNN-LSTM | Chung et al., 2020 | — |
| End-to-end pipeline | Full pipeline reference | UC Irvine Future Health, 2023 | — |
| Sensor optimization | LED-PD angle (ring form factor) | Sensors MDPI, 2025 | 10.3390/s25206326 |

**Nota:** Questa pipeline richiede accesso a dati PPG raw, che il R10 **non espone**. È applicabile solo se:
1. Un firmware futuro espone raw PPG, oppure
2. Si usa il real-time streaming (`0x69`) per raccogliere HR ad alta frequenza e derivare IBI

---

## 12. Rischi e mitigazioni

| Rischio | Probabilità | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| Firmware update rompe protocollo | Media | Alto | Parser versionato, capability detection a ogni connessione |
| universal_ble community piccola | Media | Medio | Thin wrapper isolato (RingService), sostituibile. Community in crescita, score pub.dev 150/160 |
| HRV non supportato dal firmware specifico | Media | Medio | Graceful degradation: feature nascosta se flag assente |
| BLE background limitato su iOS | Alta | Medio | Sync manuale come fallback, documentazione chiara |
| Accuratezza sleep staging insufficiente | Bassa | Basso | Usare staging nativo ring (Qring già decente), Fase 5 come backup |
| Batteria ring insufficiente con dense sampling | Bassa | Medio | Dense solo on-demand (workout/cold/spot check), max ~1.5h/giorno |
| Temperatura non presente su revisione HW | Media | Basso | Capability flag check, feature nascosta se assente |
| Colmi blocca accesso BLE | Bassa | Alto | Architettura modulare `RingService` → adattabile ad altri ring |

---

## 13. Test plan

### Hardware test (richiede R10 fisico)
- [ ] BLE scan e pairing su Android
- [ ] BLE scan e pairing su iOS
- [ ] Sync sleep data dopo una notte
- [ ] Real-time HR streaming (avvio, dati, stop)
- [ ] HRV sync (verificare se firmware risponde)
- [ ] Battery read
- [ ] Reconnect dopo out-of-range e ritorno
- [ ] Background sync (WorkManager Android)
- [ ] Capability flag detection

### Software test (senza ring)
- [ ] RingProtocol: packet encode/decode con dati noti
- [ ] DataSourceResolver: fallback a manuale se ring disconnesso
- [ ] ReadinessScore: calcolo con dati simulati
- [ ] SleepHypnogram: rendering con dati mock
- [ ] HrZoneOverlay: rendering con HR stream simulato
- [ ] Database migration: tabelle ring create correttamente
- [ ] Nessuna regressione: tutte le feature esistenti funzionano senza ring

---

## 14. File toccati — riepilogo

### Nuovi file (~15)
```
lib/core/ring/ring_service.dart
lib/core/ring/ring_protocol.dart
lib/core/ring/ring_constants.dart
lib/core/ring/ring_sync.dart
lib/core/ring/ring_dao.dart
lib/core/ring/ring_sampling_controller.dart
lib/core/ring/data_source_resolver.dart
lib/core/models/readiness_score.dart
lib/features/settings/ring_settings_screen.dart
lib/features/hrv/morning_check_screen.dart
lib/features/workout/widgets/hr_zone_overlay.dart
lib/features/workout/widgets/hr_recovery_chart.dart
lib/features/conditioning/widgets/sleep_hypnogram.dart
```

### File modificati (~15)
```
lib/core/database/database.dart                          (3 nuove tabelle, migrazione)
lib/core/models/hrv_engine.dart                          (DataSourceResolver)
lib/core/models/sleep_score.dart                         (DataSourceResolver)
lib/core/models/daily_protocol.dart                      (auto-complete sleep)
lib/core/models/activity_rings_data.dart                 (readiness score)
lib/core/models/periodization_engine.dart                (HRV-based deload)
lib/core/models/cold_progression.dart                    (HR recovery)
lib/core/models/hr_zones.dart                            (HR max reale)
lib/core/models/report_generator.dart                    (HR data in reports)
lib/core/background/background_tasks.dart                (sync mattutino)
lib/features/conditioning/sleep_tab.dart                 (hypnogram)
lib/features/conditioning/cold_tab.dart                  (HR recovery)
lib/features/workout/workout_session_screen.dart         (HR overlay)
lib/features/cardio/cardio_session_screen.dart           (HR real-time)
lib/features/today/today_screen.dart                     (readiness badge)
```

---

## 15. Fuori scope (esplicito)

- **ML on-device per sleep staging** — il ring produce già staging accettabile. Rivalutare dopo Fase 4
- **Supporto multi-device** — solo R10 inizialmente. Architettura modulare per futuro
- **Supporto altri brand** (Oura, Whoop) — fuori scope. RingService è astraibile ma non ora
- **Cloud sync** — Phoenix è local-first. Nessun server
- **SpO2 come feature primaria** — dato indicativo (LED verde), non clinico. Mostrato ma senza alert
- **Continuous HR 24h** — troppo impatto su batteria. Solo on-demand

---

## Appendice A — Porting del protocollo: Python → Dart

### Stato dell'arte

Il protocollo Colmi è stato reverse-engineered dalla decompilazione dell'APK Qring (app ufficiale, Shenzhen Qingcheng Wireless Technology Co.) e implementato in più linguaggi:

| Progetto | Linguaggio | Completezza | Licenza |
|----------|-----------|-------------|---------|
| [tahnok/colmi_r02_client](https://github.com/tahnok/colmi_r02_client) | Python | ~70% (HR, steps, real-time, battery, time, settings) | MIT |
| [Gadgetbridge PR #3896 + #4223](https://codeberg.org/Freeyourgadget/Gadgetbridge/pulls/3896) | Java/Kotlin | ~80% (+ sleep, SpO2, stress, real-time HR streaming) | AGPL-3.0 |
| [CitizenOneX/colmi_r06_fbp](https://github.com/CitizenOneX/colmi_r06_fbp) | **Dart/Flutter** | ~30% (packet, battery, raw sensors, command enum) | MIT |
| [smittytone/RingCLI](https://github.com/smittytone/RingCLI) | Go | ~60% (HR, steps, SpO2, sleep, battery) | — |
| [colmi.puxtril.com](https://colmi.puxtril.com/) | Documentazione | 37+ comandi documentati | — |

### Cosa esiste già in Dart (CitizenOneX — 225 righe)

```dart
// colmi_ring.dart — già implementato:
hexStringToCmdBytes()        // Packet encoding 16-byte + checksum ✓
// UUID BLE (service, write, notify)                                ✓
// Command enum (30+ comandi definiti)                              ✓
parseBatteryData()           // Battery level + charging            ✓
parseNotifStepsCaloriesDistanceData()  // Steps base               ✓
parseRawSpO2SensorData()     // Raw SpO2                           ✓
parseRawPpgSensorData()      // Raw PPG                            ✓
// Raw accelerometer parser                                         ✓
```

### Cosa va portato da Python (colmi_r02_client — ~480 righe)

| Modulo Python | Righe | Complessità | Cosa fa | Dart target |
|---------------|-------|-------------|---------|-------------|
| `set_time.py` | ~90 | Media | BCD time encoding, **capability flags parser** (30+ flags: temperatura, HRV, SpO2, GPS, ecc.) | `ring_protocol.dart` |
| `hr.py` | ~140 | **Alta** | `HeartRateLogParser` — parser multi-pacchetto stateful. 288 slot/giorno × 5 min. BCD timestamp. Gestisce `NoData`, normalizzazione temporale | `ring_sync.dart` |
| `steps.py` | ~120 | **Alta** | `SportDetailParser` — parser multi-pacchetto stateful. Intervalli 15 min. BCD date. Flag nuovo protocollo calorie | `ring_sync.dart` |
| `real_time.py` | ~80 | Bassa | Start/stop/continue packets. `RealTimeReading` enum (HR=1, SpO2=3, HRV=10). Response parsing | `ring_sampling_controller.dart` |
| `hr_settings.py` | ~50 | Bassa | Read/write intervallo campionamento periodico (1-255 min) | `ring_protocol.dart` |
| `client.py` | ~230 | Media | BLE connect via Bleak, notification handler, command dispatch, queue-based async. **Da riscrivere** per universal_ble (non porting 1:1) | `ring_service.dart` |

### Parser multi-pacchetto: il pattern

I parser HR e Steps sono la parte più complessa. Il pattern è:

```
Phoenix invia: CMD_READ_HEART_RATE + data richiesta (BCD encoded)
Ring risponde: N pacchetti in sequenza
  Pacchetto 1: header (data, numero totale pacchetti)
  Pacchetto 2..N-1: payload (dati HR in slot 5-min)
  Pacchetto N: end marker
Phoenix: assembla, decodifica BCD timestamps, produce lista HR
```

Questo richiede uno **state machine** nel notification handler che accumula pacchetti fino al completamento. Il client Python usa una coda async (`asyncio.Queue`); in Dart useremo `Stream` + `Completer`.

### Cosa manca nel Python (ma esiste in Gadgetbridge Java)

| Feature | Comando | In Python | In Gadgetbridge | In Dart |
|---------|---------|-----------|-----------------|---------|
| Sleep sync | `0x44` | No | **Sì** (deep/light/REM/awake) | Da portare da Java |
| SpO2 log sync | `0x37` | No | **Sì** | Da portare da Java |
| Stress sync | — | No | **Sì** | Da portare da Java |
| Real-time HR streaming | `0x69` | Sì (base) | **Sì** (con polling 2s) | Da portare da Python + Java |

Per sleep sync, la fonte migliore è **Gadgetbridge** (Java, AGPL-3.0). Il parser sleep è più completo del Python.

### Piano di porting per Fase 0

1. **Copiare** packet encoding + command enum da CitizenOneX (già Dart, MIT) → `ring_constants.dart`, `ring_protocol.dart`
2. **Portare** da Python: `set_time.py` (capability flags), `battery.py` → `ring_protocol.dart`
3. **Riscrivere** BLE client per `universal_ble` (non porting di `client.py`, API diversa) → `ring_service.dart`
4. **Test** con R10 fisico: scan, connect, read battery, read capabilities

### Piano di porting per Fase 1

5. **Portare** da Python: `hr.py` (multi-packet parser) → `ring_sync.dart`
6. **Portare** da Java (Gadgetbridge): sleep sync parser → `ring_sync.dart`
7. **Portare** da Python: `steps.py` (multi-packet parser) → `ring_sync.dart`

### Piano di porting per Fase 2

8. **Portare** da Python: `real_time.py` (start/stop/continue) → `ring_sampling_controller.dart`
9. **Portare** da Python: `hr_settings.py` → `ring_protocol.dart`
10. **Portare** da Java: HRV sync (`0x39`) → `ring_sync.dart`

### Stima effort totale porting

| Fase | Righe Python/Java source | Righe Dart stimate | Note |
|------|-------------------------|-------------------|------|
| Fase 0 | ~140 (set_time + battery) + rewrite BLE | ~300 | BLE client è rewrite, non porting |
| Fase 1 | ~260 (hr + steps) + ~150 (sleep da Java) | ~400 | Parser stateful = la parte più complessa |
| Fase 2 | ~130 (real_time + hr_settings + HRV) | ~200 | Relativamente semplice |
| **Totale** | **~680 source** | **~900 Dart** | Dart è più verboso di Python |

---

## Appendice B — Qring e l'ecosistema OEM

### Chi produce cosa

```
Colmi (Shenzhen) ─── produce hardware ─── OEM/white-label a terzi
         │
         ├── Shenzhen Qingcheng Wireless Technology Co. ─── sviluppa app Qring
         │
         └── Vende sotto marchi: Colmi, R10 Smart Ring, vari rebrand AliExpress
```

### Come è stato reverse-engineered

```
Qring APK ──→ decompilazione Java ──→ nomi costanti (mSupportHrv, ecc.)
     │                                        │
     └── BLE traffic capture (Wireshark) ─────┘
                    │
                    ▼
         Documentazione pubblica:
         ├── colmi.puxtril.com (37+ comandi)
         ├── tahnok/colmi_r02_client (Python, MIT)
         ├── Gadgetbridge (Java, AGPL-3.0)
         └── CitizenOneX/colmi_r06_fbp (Dart, MIT)
```

### Compatibilità: quale ring funziona?

**Regola:** se il ring usa l'app **Qring**, è compatibile. Il protocollo è identico per:
- R02, R03, R06, R09, R10
- Qualsiasi rebrand che usa Qring
- Chip Realtek RTL8762 o BlueX RF03

**NON compatibili:** ring Colmi-branded che usano app diverse (hardware/firmware differente).

Gadgetbridge testa su firmware 3.00.06, 3.00.10, 3.00.17. Il supporto R10 è ufficiale da v0.82.0.
