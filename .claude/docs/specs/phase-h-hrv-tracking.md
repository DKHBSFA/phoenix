# Feature: HRV Tracking & Recovery Intelligence

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Integrare il tracking HRV (Heart Rate Variability) come indicatore primario di recovery e readiness, con baseline automatica, trend analysis, e decisioni automatiche sull'intensità dell'allenamento.
**Why?** Il Protocollo Phoenix §5.4 prescrive HRV tracking. LnRMSSD è il gold standard per valutare lo stato del sistema nervoso autonomo. Una riduzione >0.5 SD dalla baseline indica sovrallenamento o stress — l'app deve adattare l'intensità di conseguenza.
**For whom?** Utenti con wearable (Apple Watch, Garmin, Oura, WHOOP) o che misurano HRV manualmente.
**Success metric:** HRV baseline stabilita in 14 giorni; allenamento auto-adattato quando HRV è sotto soglia; trend visibile nella dashboard.

---

## 2. Evidenza Scientifica

### Metrica Primaria: LnRMSSD
- **RMSSD** (Root Mean Square of Successive Differences): misura la variabilità beat-to-beat, riflette il tono vagale (parasimpatico)
- **LnRMSSD** (natural log): normalizza la distribuzione, rende i dati comparabili tra individui
- **Plews et al. 2013**: LnRMSSD è superiore a SDNN per monitorare la fatica da allenamento
- **Plews et al. 2014**: SWC (Smallest Worthwhile Change) = 0.5 × SD della baseline → soglia per decisioni

### Baseline Protocol
- **14 giorni** di misurazioni mattutine (al risveglio, prima di alzarsi)
- **7-day rolling average** come valore di riferimento (riduce rumore giornaliero)
- **Individuale**: non esistono valori "normali" universali — solo il trend personale conta

### Decision Thresholds (Plews Framework)
| Condizione | LnRMSSD vs Baseline | Azione |
|-----------|---------------------|--------|
| Normale | Entro ±0.5 SD | Allenamento come da programma |
| Elevato | >0.5 SD sopra | Allenamento come da programma (recupero buono) |
| Ridotto | 0.5-1.0 SD sotto | Ridurre volume 20%, mantenere intensità |
| Molto ridotto | >1.0 SD sotto | Deload forzato o riposo attivo |
| Trend discendente | 3+ giorni consecutivi in calo | Warning: rischio sovrallenamento |

### Tradizione Russa: Bayevsky & Shlyk (fonti non occidentali)

#### Bayevsky Stress Index (SI) — la metrica che l'Occidente ignora
- **Origine**: R.M. Bayevsky (Баевский Р.М.), anni '60-'70, sviluppato per il monitoraggio cosmonauti (Salyut, Mir)
- **Formula**: `SI = (AMo × 100) / (2 × Mo × MxDMn)`
  - Mo = intervallo RR più frequente (s), AMo = % intervalli nel bin modale (50ms), MxDMn = max(RR) - min(RR)
- **Range**: Riposo normale 50-150, stress lieve 150-300, stress alto 300-500, severo >500
- **Differenza da Plews**: RMSSD misura il parasimpatico. SI misura lo **strain simpatico**. Non sono semplici inversi — si può avere RMSSD soppresso E SI normale (ritiro parasimpatico senza attivazione simpatica), con implicazioni di training diverse da SI alto (drive simpatico attivo)
- **Implementando entrambi** si ottiene un modello a 2 assi: recovery parasimpatico (RMSSD) + strain simpatico (SI)

#### Tipologia Individuale di Shlyk (N.I. Shlyk, 1992+)
Gli atleti cadono in **4 tipi regolatori distinti** con risposte ottimali diverse:

| Tipo | Regolazione | Criteri | Risposta Training |
|------|-------------|---------|-------------------|
| I | Predominanza centrale moderata | SI >100, VLF >240 ms², TP moderato | Risponde bene a periodizzazione strutturata |
| II | Predominanza centrale pronunciata | SI >100, VLF >240 ms², TP basso | Instabile, prone a fatica, serve più recovery |
| III | Predominanza autonomica moderata | SI 30-100, VLF >240 ms² | Stato regolatorio ottimale |
| IV | Predominanza autonomica pronunciata | SI <30, VLF >500 ms², TP molto alto | **ATTENZIONE**: HRV molto alto può indicare disregolazione, NON solo recupero eccellente |

**Insight critico (Tipo IV)**: Le app occidentali interpreterebbero HRV altissimo come "eccellente recovery". Shlyk dimostra che può indicare disfunzione autonomica. **HRV alto non è sempre positivo.**

#### Quattro Stati Funzionali (PARS Classification, Bayevsky)
| Stato | Significato | Azione Training |
|-------|-------------|-----------------|
| 1. Fisiologico normale | Sistemi regolatori in equilibrio | Allenamento normale |
| 2. **Prenosologico** | Tensione regolatoria aumentata, nessuna patologia | Ridurre volume, monitorare |
| 3. Premorbido | Sistemi regolatori non compensano | Riposo, valutazione |
| 4. Patologico | Disregolazione franca | Attenzione medica |

Lo stato **prenosologico** è l'early warning che il framework RMSSD occidentale non cattura: il corpo compensa di più ma ancora ci riesce. SI sale mentre RMSSD resta stabile.

#### Banda VLF come Marcatore Umorale-Metabolico
- VLF (0.003-0.04 Hz) riflette la **regolazione umorale-metabolica** (asse renina-angiotensina, termoregolazione)
- VLF depressa = esaurimento metabolico profondo che HF/LF ratio non rileva
- Atleti in overtraining mostrano VLF sotto norme fisiologiche **PRIMA** che RMSSD scenda
- Richiede registrazioni ≥5 minuti

#### Fonti Russe
- Bayevsky & Chernikova, "HRV Analysis: Physiological Foundations", Cardiometry 2017
- Bayevsky, "Analysis of HRV in Space Medicine", Human Physiology 2002
- Shlyk, "Cardio-respiratory Relationships in Athletes with Different HRR Types", Frontiers 2024
- Determining Autonomic Sympathetic Tone Using Baevsky's SI, AJP 2024

### Tradizione Cinese: HRV Biofeedback & TCM

#### HRV Biofeedback Pre-Sonno (Atleti Olimpici Cinesi)
- Ricerca con atleti cinesi di bobsled (Winter Olympics): **HRV biofeedback pre-sonno** migliora umore e qualità del sonno
- Applicazione unica non presente nella letteratura sportiva occidentale
- **Implicazione per Phoenix**: SleepTab potrebbe incorporare sessione HRV biofeedback serale usando il modulo breathing come ponte tra condizionamento e sonno

#### Tai Chi/Qigong e HRV
- Meta-analisi: Tai Chi e Qigong spostano significativamente il bilancio autonomico verso il parasimpatico
- Miglioramenti in HF power e SDNN vs controlli sedentari
- Il modulo meditazione/breathing di Phoenix (BreathingController) è già allineato con questo meccanismo

#### Monitoraggio Atleti Olimpici Cinesi (2008+)
- Post-2008, gli istituti sportivi cinesi hanno adottato monitoraggio HRV sistematico con wearable
- Approccio cinese: **feedback loop in tempo reale** — HRV alimenta prescrizioni di training nello stesso giorno, non solo check mattutino di readiness

### Interazioni con il Protocollo
- **Digiuno**: il digiuno prolungato (>24h) tipicamente AUMENTA HRV (attivazione vagale)
- **Cold exposure**: immersione in acqua fredda aumenta HRV post-sessione
- **Sleep**: HRV notturna è il miglior predittore di recovery (vs mattutina)
- **HIIT**: HRV si riduce 24-48h post-HIIT, recupero completo in 48-72h

---

## 3. Technical Approach

### 3.1 Data Sources

**Priorità 1: Wearable via Flutter `health` package**
```dart
// HealthKit (iOS) e Health Connect (Android)
// RMSSD disponibile da: Apple Watch, Garmin, Oura, WHOOP, Fitbit
final types = [HealthDataType.HEART_RATE_VARIABILITY_RMSSD];
final permissions = [HealthDataAccess.READ];
```

**Problema noto:** Apple Watch registra SDNN, non RMSSD direttamente. Necessaria conversione o uso del valore HealthKit `HKQuantityTypeIdentifierHeartRateVariabilitySDNN` con nota che la correlazione SDNN↔RMSSD è alta ma non perfetta.

**Priorità 2: Input manuale**
- L'utente può inserire il valore RMSSD da app esterna (Elite HRV, HRV4Training)
- Campo numerico con validazione (range tipico: 20-120 ms)

### 3.2 Data Model

```dart
class HrvReading {
  final int id;
  final DateTime timestamp;
  final double rmssd;          // Raw RMSSD in ms
  final double lnRmssd;        // Natural log transform
  final double? stressIndex;   // Bayevsky SI (computed from RR intervals)
  final double? vlfPower;      // VLF band power (0.003-0.04 Hz)
  final double? totalPower;    // Total spectral power
  final String source;         // 'apple_watch' / 'garmin' / 'oura' / 'manual'
  final String context;        // 'morning' / 'post_workout' / 'sleep' / 'evening_biofeedback'
}

class HrvBaseline {
  final double mean7Day;       // 7-day rolling average LnRMSSD
  final double sd7Day;         // 7-day rolling SD
  final double mean14Day;      // 14-day baseline mean
  final double sd14Day;        // 14-day baseline SD
  final int readingsCount;     // Total readings (need ≥14 for baseline)

  bool get isEstablished => readingsCount >= 14;

  /// SWC = 0.5 × SD (Smallest Worthwhile Change)
  double get swc => sd14Day * 0.5;

  /// Recovery status from today's reading (Plews + Bayevsky combined)
  RecoveryStatus statusFor(double todayLnRmssd, {double? stressIndex}) {
    final delta = todayLnRmssd - mean7Day;

    // Bayevsky 4-state check (prenosological early warning)
    if (stressIndex != null && stressIndex > 300) return RecoveryStatus.veryLow;
    if (stressIndex != null && stressIndex > 150 && delta >= -swc) {
      // SI elevated but RMSSD still normal → prenosological state
      return RecoveryStatus.prenosological;
    }

    // Shlyk Type IV warning: very high HRV may indicate dysregulation
    if (delta > sd14Day * 2) return RecoveryStatus.suspiciouslyHigh;

    if (delta < -sd14Day) return RecoveryStatus.veryLow;
    if (delta < -swc) return RecoveryStatus.low;
    if (delta > swc) return RecoveryStatus.high;
    return RecoveryStatus.normal;
  }
}

enum RecoveryStatus {
  veryLow,           // >1 SD below → deload/rest
  low,               // 0.5-1 SD below → reduce volume 20%
  prenosological,    // Bayevsky: SI elevated but RMSSD ok → early warning
  normal,            // Within ±0.5 SD → train as planned
  high,              // >0.5 SD above → good recovery
  suspiciouslyHigh,  // Shlyk Type IV: >2 SD above → possible dysregulation
}
```

### 3.3 HRV Engine

```dart
class HrvEngine {
  final HrvDao _dao;

  /// Import from wearable (daily sync)
  Future<void> syncFromHealth();

  /// Add manual reading
  Future<void> addReading(double rmssd, String source);

  /// Compute current baseline
  Future<HrvBaseline> getBaseline();

  /// Get recovery recommendation for today
  Future<RecoveryRecommendation> getTodayRecommendation();

  /// Trend analysis (last 30 days)
  Future<HrvTrend> getTrend();
}

class RecoveryRecommendation {
  final RecoveryStatus status;
  final double volumeMultiplier;     // 1.0 normal, 0.8 low, 0.5 very low
  final bool suggestDeload;
  final String coachMessage;
}
```

### 3.4 Integrazione con Training

Quando l'HRV baseline è stabilita:
1. **WorkoutGenerator** riceve `volumeMultiplier` da HrvEngine
2. Se `RecoveryStatus.low`: riduce sets del 20% (es. 4→3)
3. Se `RecoveryStatus.veryLow`: suggerisce deload o riposo attivo
4. Se 3+ giorni consecutivi in calo: trigger deload anticipato (override periodizzazione)
5. **CoachPrompts** aggiunge messaggi HRV-aware:
   - "Il tuo HRV è sotto la baseline di 1 SD. Oggi facciamo recovery attivo."
   - "HRV in trend positivo da 5 giorni — il corpo sta rispondendo bene."

### 3.5 Database

```sql
CREATE TABLE hrv_readings (
  id INTEGER PRIMARY KEY,
  timestamp INTEGER NOT NULL,
  rmssd REAL NOT NULL,
  ln_rmssd REAL NOT NULL,
  source TEXT NOT NULL,        -- 'apple_watch' / 'garmin' / 'oura' / 'manual'
  context TEXT DEFAULT 'morning'
);

-- Cached baseline (recomputed daily)
CREATE TABLE hrv_baseline (
  id INTEGER PRIMARY KEY,
  date INTEGER NOT NULL,
  mean_7day REAL,
  sd_7day REAL,
  mean_14day REAL,
  sd_14day REAL,
  readings_count INTEGER
);
```

---

## 4. UI Changes

### 4.1 HRV Card (Today Screen)
- Mostra LnRMSSD odierno vs baseline (freccia su/giù)
- Colore: verde (normale/alto), giallo (basso), rosso (molto basso)
- Se baseline non stabilita: "Giorno 7/14 — continua a misurare per stabilire la baseline"
- Tap → HRV detail screen

### 4.2 HRV Detail Screen
- Grafico 30 giorni (LineChart) con banda baseline ±SWC
- Recovery status history
- Correlazioni: HRV vs allenamento, digiuno, sonno
- Bottone sync wearable / input manuale

### 4.3 Dashboard Integration
- HRV trend card in BiomarkerDashboardTab
- Recovery status nel coach message mattutino

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/hrv_engine.dart` | Create | HrvReading, HrvBaseline, HrvEngine, RecoveryRecommendation |
| `core/database/tables.dart` | Modify | Add hrv_readings, hrv_baseline tables |
| `core/database/database.dart` | Modify | Migration |
| `core/database/daos/hrv_dao.dart` | Create | CRUD readings, baseline computation, trend queries |
| `features/hrv/hrv_detail_screen.dart` | Create | 30-day chart, recovery status, sync button |
| `features/today/widgets/hrv_card.dart` | Create | Today screen HRV summary card |
| `core/models/workout_generator.dart` | Modify | Accept volumeMultiplier from HRV |
| `core/models/coach_prompts.dart` | Modify | HRV-aware messages |
| `features/biomarkers/biomarker_dashboard_tab.dart` | Modify | HRV trend card |
| `pubspec.yaml` | Modify | Add `health: ^11.0.0` package |

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | LnRMSSD calculation | RMSSD=50ms | ln(50)=3.912 | High |
| UT-02 | Baseline not established | 10 readings | isEstablished=false | High |
| UT-03 | Baseline established | 14 readings | isEstablished=true, mean/SD computed | High |
| UT-04 | Recovery normal | LnRMSSD within ±0.5 SD | RecoveryStatus.normal | High |
| UT-05 | Recovery low | LnRMSSD 0.7 SD below | RecoveryStatus.low, volumeMultiplier=0.8 | High |
| UT-06 | Recovery very low | LnRMSSD 1.2 SD below | RecoveryStatus.veryLow, suggestDeload=true | High |
| UT-07 | Trend detection | 3 days declining | Warning flag set | Medium |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | No wearable | health package returns empty | Show manual input option |
| EC-02 | Apple Watch SDNN | SDNN instead of RMSSD | Convert with note about approximation |
| EC-03 | Gap in readings | 3 days missed | Use last available baseline, warn about accuracy |

---

## 7. Dipendenze

- **Flutter `health` package**: Per leggere da HealthKit/Health Connect
- **Fase C (Periodizzazione)**: HRV può triggerare deload anticipato
- **Indipendente** dalle altre fasi — può partire in qualsiasi momento

---

**Attesa PROCEED.**
