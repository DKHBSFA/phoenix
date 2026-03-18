
# Product Requirements Document (PRD)

## Colmi R10 AI-Enhanced Health Analytics App

**Versione**: 1.0  
**Data**: 13 Marzo 2026  
**Stato**: Draft  
**Autore**: Product Team  

---

## 1. Executive Summary

### 1.1 Visione
Sviluppare un'applicazione mobile Flutter che trasforma il Colmi R10 — smart ring economico con sensori PPG base — in un dispositivo di health analytics avanzato attraverso algoritmi di signal processing e machine learning on-device. L'app compensa le limitazioni hardware del ring (sensori entry-level, campionamento ogni 5 min) con processing intelligente dei dati raw, offrendo accuratezza comparabile a dispositivi premium a una frazione del costo.

### 1.2 Problema
- I dispositivi wearable premium (Oura, Apple Watch, Whoop) costano €300-€500
- Il Colmi R10 (€30-€50) ha sensori adeguati ma algoritmi base e chiusi
- Gli utenti vogliono insights avanzati (sleep scoring, HRV, stress) senza spendere cifre elevate
- Non esiste sul mercato un'app che sfrutti il potenziale raw del R10 con AI

### 1.3 Soluzione
App Flutter che:
1. Legge dati **raw BLE** dal Colmi R10 (non dipende dall'app ufficiale)
2. Applica **pipeline di signal processing** scientificamente validata (filtri adattivi, ICA, SQI)
3. Utilizza **modelli ML leggeri** (TFLite) per enhancement on-device
4. Offre **analytics avanzate**: sleep staging, HRV derivato, stress index, readiness score

---

## 2. Requisiti Utente (User Stories)

### 2.1 Onboarding & Setup
**US-001**: Come nuovo utente, voglio connettere il mio Colmi R10 all'app senza installare l'app ufficiale, così da avere un'esperienza unificata.

**US-002**: Come utente, voglio che l'app rilevi automaticamente il mio R10 nel raggio BLE, senza dover inserire MAC address manualmente.

**US-003**: Come utente non tecnico, voglio una spiegazione semplice dei permessi Bluetooth richiesti, così da capire perché l'app ne ha bisogno.

### 2.2 Acquisizione Dati
**US-004**: Come utente, voglio che l'app sincronizzi automaticamente i dati dal ring ogni N minuti in background, senza dover aprire l'app.

**US-005**: Come utente curioso, voglio vedere i dati **raw** (numeri grezzi dal sensore) in una sezione "Developer Mode", per capire cosa sta leggendo l'app.

**US-006**: Come utente, voglio che l'app salvi i dati localmente sul telefono, per privacy e offline access.

### 2.3 Dashboard & Visualizzazione
**US-007**: Come utente, voglio una dashboard giornaliera con: passi, calorie, HR medio, SpO2 medio, temperatura, durata sonno, readiness score.

**US-008**: Come utente, voglio grafici trend settimanali/mensili per ogni metrica, per identificare pattern.

**US-009**: Come utente, voglio vedere il mio **sleep hypnogram** (grafico fasi sonno: deep/light/REM/awake) con timestamp precisi.

**US-010**: Come utente avanzato, voglio esportare i miei dati in CSV/JSON per analisi esterna.

### 2.4 AI Enhancement & Insights
**US-011**: Come utente, voglio che l'app mi avvisi quando la qualità del segnale è bassa (es. "Movimento rilevato, HR potrebbe essere inaccurato").

**US-012**: Come utente, voglio un **Readiness Score** (0-100) ogni mattina basato su: qualità sonno, HRV, temperatura, HR resting — con spiegazione dei fattori.

**US-013**: Come utente, voglio un **Stress Index** durante la giornata, calcolato da HRV e pattern HR, con alert quando supera soglia personalizzata.

**US-014**: Come utente, voglio che l'app rilevi automaticamente le sessioni di allenamento basandosi su spike HR + accelerometro, senza doverle avviare manualmente.

**US-015**: Come utente, voglio che l'app **interpoli** i dati HR mancanti (il R10 campiona ogni 5 min max) usando algoritmi di imputazione intelligente.


### 5.3 Schema Dati Principale

**RawSample** (dati grezzi dal ring):
- timestamp: DateTime (ms precision)
- hr: int? (bpm, nullable se non disponibile)
- spo2: int? (%, nullable)
- temperature: double? (°C, nullable)
- accelX/Y/Z: double (g-force)
- steps: int (cumulativo)
- rawPpgValue: int? (se esposto da firmware, nullable)

**ProcessedWindow** (post-pipeline):
- startTime, endTime: DateTime
- hrMean, hrStd, hrMin, hrMax: double
- hrvSdnn, hrvRmssd: double?
- spo2Mean: double?
- tempMean, tempDelta: double
- signalQuality: double [0-1]
- motionArtifactDetected: bool
- sleepStage: enum [deep, light, rem, awake, unknown]

**DailySummary**:
- date: DateTime
- totalSteps, totalCalories, totalDistance
- hrResting, hrMax
- sleepDuration, sleepEfficiency, sleepStagesDistribution
- readinessScore: int [0-100]
- stressAvg, stressMax
- notes: String?

---

### 6.2 Dipendenze Esterne

| Dipendenza | Scopo | Stato |
|-----------|-------|-------|
| flutter_blue_plus | BLE communication | Stable |
| tflite_flutter | ML runtime | Stable |
| isar | Local database | Stable |
| fl_chart | Data visualization | Stable |

### 6.3 Rischi & Mitigazioni

| Rischio | Probabilità | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| Protocollo R10 cambia con firmware update | Media | Alto | Reverse engineering flessibile, parser versionato |
| Performance ML insufficiente su device entry-level | Media | Medio | Quantizzazione INT8, fallback a rule-based |
| BLE background limitations su iOS | Alta | Medio | Documentazione chiara, sync manuale fallback |
| Accuratezza sleep non soddisfacente vs concorrenza | Media | Alto | Focus su "AI-enhanced" come differentiator, non accuracy pura |
| Colmi blocca accesso raw in futuro | Bassa | Alto | Architettura modulare per supportare altri dispositivi |

## 8. Appendici

### 8.1 Glossario

| Termine | Definizione |
|---------|-------------|
| **PPG** | Photoplethysmography, tecnica ottica per misurare variazioni volume sanguigno |
| **SQI** | Signal Quality Index, metrica numerica della qualità del segnale PPG |
| **MA** | Motion Artifact, artefatto nel segnale causato da movimento |
| **HRV** | Heart Rate Variability, variabilità inter-battito, indicatore salute autonoma |
| **NLMS** | Normalized Least Mean Squares, algoritmo adaptive filtering |
| **cICA** | Constrained Independent Component Analysis, tecnica separazione segnale |
| **TFLite** | TensorFlow Lite, runtime ML ottimizzato per mobile/embedded |

### 8.2 Riferimenti Scientifici Chiave

1. **UC Irvine End-to-End Pipeline** (2023) - Pipeline PPG completa con ML [^19^]
2. **PPG Signal Quality Assessment** (ACM 2023) - CNN per quality classification [^23^]
3. **Rotation-Robust PPG Sensor** (2025) - Ottimizzazione angolare LED-PD [^15^]
4. **Adaptive Filtering PPG** (IEEE 2014) - NLMS e RLS per MA removal [^31^][^32^]
5. **Constrained ICA PPG** (Nanjing 2014) - Separazione segnale-movimento [^36^]
6. **CNN-LSTM PPG Exercise** (2020) - Deep learning per HR durante movimento [^33^][^40^]
7. **Time-Domain HR Algorithm** (2020) - Algoritmo leggero resource-constrained [^38^]

### 8.3 Documentazione Colmi R10

- **Protocollo BLE**: Nordic UART Service, pacchetti 16-byte
- **UUIDs**: Service `6e40fff0-b5a3-f393-e0a9-e50e24dcca9e`, TX `6e400003...`, RX `6e400002...`
- **Comandi**: Ora (0x01), Firmware (0x02), Batteria (0x03), Dati giornalieri (0x51), HR/SpO2 (0x52), Sonno (0x53), Temperatura (0x54), HRV (0x55), Stress (0x56), Allenamento (0x57)
- **Limitazioni**: HR max ogni 5 min (firmware), no PPG raw continuo, temperatura a volte instabile

---

**Prossimi Passi**:
1. Review tecnica architettura BLE e signal processing
2. Validazione protocollo R10 con dispositivo fisico
3. Setup repository e CI/CD
4. Inizio M1: Foundation