# Spec: Phoenix App — Architettura e Stack Tecnologico

**Data:** 2026-03-12
**Tipo:** Feature (app completa)
**Stato:** Completato — app scaffoldata, Drift codegen fatto, flutter analyze 0 errori

---

## Cosa stiamo costruendo

App mobile iOS + Android che implementa il Protocollo Phoenix: allenamento guidato con visual/audio, gestione digiuno, monitoraggio biomarker, e un LLM locale che genera riepiloghi e insight personalizzati. Dati 100% in locale.

---

## Stack raccomandato

### Framework: Flutter (Dart)

**Perché Flutter e non React Native:**

| Criterio | Flutter | React Native |
|----------|---------|--------------|
| Performance animazioni | Impeller engine, 60/120 FPS costanti | JSI bridge migliore del vecchio, ma non nativo |
| Local storage | Drift (SQLite), Hive — ecosystem maturo | AsyncStorage + librerie terze |
| Pixel-perfect cross-platform | Controlla ogni pixel, UI identica su iOS/Android | Usa widget nativi, differenze tra piattaforme |
| Cactus SDK (LLM on-device) | SDK Flutter v1 disponibile e stabile | SDK React Native fermo a v0 |
| Audio/haptic engine | `just_audio` + `flutter_vibrate` — robusti | Più frammentato |
| Offline-first | Architettura naturale con Drift/Hive | Possibile ma richiede più configurazione |

**Fonti:** [TechAhead 2026](https://www.techaheadcorp.com/blog/flutter-vs-react-native-in-2026-the-ultimate-showdown-for-app-development-dominance/), [Foresight Mobile](https://foresightmobile.com/blog/why-flutter-outperforms-the-competition), [adevs benchmarks](https://adevs.com/blog/react-native-vs-flutter/)

### LLM On-Device: BitNet b1.58 2B via FFI (bitnet.cpp)

**Runtime:** [bitnet.cpp](https://github.com/microsoft/BitNet) — Microsoft, C++, integrato via Dart FFI.

| Parametro | Scelta | Motivazione |
|-----------|--------|-------------|
| **Modello** | BitNet b1.58 2B4T | 1.2 GB totale. Nativo 1.58-bit (ternario), NON post-quantizzato — qualita comparabile a Llama 3.2 1B/Gemma 3 1B con meta delle risorse |
| **Runtime** | bitnet.cpp via Dart FFI | Performance native ARM: 1.37-5x piu veloce di llama.cpp su modelli equivalenti, -55/70% consumo energia |
| **Performance attesa** | 10-20 tok/s (8GB mid-range), 30-45 tok/s (flagship) | Riepilogo 200 parole (~300 tok) in 15-30s su mid-range |
| **RAM footprint** | ~1.2GB modello + ~300MB KV cache = ~1.5GB | Su 8GB (~5-6GB disponibili) resta ampio margine |
| **Privacy** | 100% locale, zero dati in uscita | Allineato con filosofia Phoenix |

**Perche BitNet e non Cactus/GGUF:**
- BitNet e addestrato nativo a 1.58 bit — meno degradazione qualita rispetto a quantizzazione post-training (Q4_K_M)
- 55-70% meno energia su ARM — critico per un'app fitness che gira durante allenamenti
- 1.2GB vs ~700MB (Gemma 1B Q4) ma qualita di un modello 2B completo
- bitnet.cpp supporta ARM NEON SIMD (tutti i device 2017+)

**Integrazione tecnica:**
```
Flutter (Dart) → dart:ffi → bitnet.cpp (C++ shared library)
                              ├── libbitnet_android.so (ARM64)
                              └── libbitnet_ios.dylib (ARM64)
```
- Compilazione bitnet.cpp come shared library per Android (NDK) e iOS
- Wrapper Dart FFI con interfaccia asincrona (Isolate dedicato per non bloccare UI)
- Modello scaricato post-install (~1.2GB download separato)

**Layer di astrazione:** `core/llm/` espone un'interfaccia indipendente dal runtime. Se in futuro Cactus integra BitNet nativamente o esce un modello migliore, il cambio e trasparente.

**Fonti:** [BitNet GitHub](https://github.com/microsoft/BitNet), [BitNet 2B4T paper](https://arxiv.org/html/2504.12285v1), [bitnet.cpp inference paper](https://arxiv.org/html/2410.16144v1), [On-Device LLMs 2026](https://v-chandra.github.io/on-device-llms/)

### Device di riferimento

| Parametro | Requisito minimo |
|-----------|-----------------|
| **RAM** | 8 GB |
| **CPU** | ARM64 con NEON SIMD (qualsiasi smartphone 2017+) |
| **Storage libero** | ~2.5 GB (app + modello + asset esercizi) |
| **OS** | Android 7.0+ (API 24) / iOS 13+ |
| **NPU** | Non richiesto (tutto su CPU) |

**Cosa fa l'LLM in Phoenix:**

1. **Post-allenamento:** riepilogo sessione (esercizi, performance vs precedente, RPE, note)
2. **Settimanale:** analisi trend (volume, progressione, aderenza al protocollo)
3. **Mensile:** report completo (avanzamento livelli, confronto biomarker, suggerimenti)
4. **Digiuno:** tracking aderenza, preparazione al livello successivo, check criteri oggettivi
5. **Motivazionale:** interventi contestuali basati su pattern (es. "3 sessioni saltate questa settimana — vuoi adattare il piano?")

**Prompt engineering:** prompt templates pre-definiti + dati strutturati iniettati come contesto. Il modello NON ha accesso a internet, lavora solo sui dati locali dell'utente.

### Database locale: Drift (SQLite)

**Perché Drift e non Hive:**
- Query SQL complesse necessarie (aggregazioni temporali, trend, confronti)
- Type-safe con generazione codice Dart
- Migrazioni schema strutturate
- Performance superiore su dataset che crescono nel tempo

### Esercizi: free-exercise-db (public domain) + curazione Phoenix

Come definito in `references/exercise-databases-research.md`:
- ~50-80 esercizi curati per le progressioni del protocollo
- JSON locale, nessuna dipendenza API
- Immagini + GIF animate (Everkinetic CC BY-SA 3.0 + produzione propria)

---

## Architettura dell'app

```
┌─────────────────────────────────────────────────┐
│                   UI Layer                       │
│  (Flutter widgets, animazioni, audio engine)     │
├─────────────────────────────────────────────────┤
│               State Management                   │
│           (Riverpod — reactive)                  │
├──────────┬──────────┬──────────┬────────────────┤
│ Workout  │ Fasting  │ Biomark  │   LLM Engine   │
│ Engine   │ Tracker  │ Tracker  │  (bitnet.cpp)  │
├──────────┴──────────┴──────────┴────────────────┤
│              Data Layer (Drift/SQLite)           │
│         + Exercise DB (JSON assets)              │
├─────────────────────────────────────────────────┤
│           Background Service Layer               │
│  (Notifiche, timer digiuno, promemoria)          │
└─────────────────────────────────────────────────┘
```

### Background Service

L'app deve restare attiva in background per:

1. **Notifiche digiuno:** milestone raggiunte (12h, 16h, 24h, 36h, 48h, 72h), promemoria idratazione/elettroliti
2. **Promemoria allenamento:** giorno/ora programmati, con possibilita di posticipare
3. **Notifiche condizionamento:** promemoria doccia fredda, meditazione, sonno
4. **Check-in motivazionali:** se l'utente salta sessioni, notifica contestuale (NON generata dall'LLM in background — testo pre-definito, l'LLM lavora solo in foreground)

**Implementazione:**
- **Android:** `WorkManager` per task periodici + `Foreground Service` per timer digiuno attivo (notifica persistente con countdown)
- **iOS:** `Background App Refresh` + `Local Notifications` schedulate. Timer digiuno: notifiche pre-schedulate ai milestone (iOS non permette foreground service permanenti)
- **Flutter package:** `flutter_local_notifications` + `workmanager`

**Regola critica:** il LLM NON gira MAI in background. Solo notifiche pre-definite e timer. L'inference avviene esclusivamente quando l'utente e nell'app (foreground) per evitare battery drain e OOM kill.

### Moduli principali

#### 1. Workout Engine
- **Sessione guidata:** esercizio corrente → visual + audio → timer riposo → prossimo esercizio
- **Visual:** GIF/animazione dell'esercizio con indicazione dei muscoli target
- **Audio:** metronomo per velocità di esecuzione (es. 3s eccentrica, 1s pausa, 2s concentrica), beep cambio serie, voce "riposo" / "prossimo esercizio"
- **Timer adattivo tra serie:** basato su obiettivo e livello (vedi sezione Tempi di Riposo sotto)
- **Timer tra esercizi:** tempo fisso (default 2 min) o personalizzabile
- **Input utente:** numero reps completate, RPE percepito (slider 1-10), note opzionali
- **Auto-progressione:** quando i criteri della sezione 2.7 del protocollo sono soddisfatti, suggerisce avanzamento

#### 2. Workout Duration Score (il "countdown" che hai descritto)

**Logica:**
```
Fase 1 (prime 4 settimane): solo raccolta dati
  → L'utente avvia/ferma il timer, il sistema registra durata totale

Fase 2 (dalla settimana 5): scoring attivo
  → Il sistema calcola la durata ideale basandosi su:
     - Media mobile delle ultime 8 sessioni dello stesso tipo
     - Range fisiologico dal protocollo (forza: 45-75 min, cardio: 30-60 min)
     - Deviazione standard personale

  → Score:
     🟢 OTTIMALE: entro ±1 SD dalla media personale E nel range fisiologico
     🟡 SUFFICIENTE: entro ±2 SD O leggermente fuori range (±15%)
     🔴 DA RIVEDERE: >2 SD O fuori range (troppo breve = <30 min, troppo lungo = >90 min per forza)

  → Feedback contestuale (generato dall'LLM):
     - Troppo lungo: "Hai impiegato 95 minuti — controlla i tempi di riposo"
     - Troppo breve: "35 minuti per 4 esercizi — stai completando tutte le serie?"
     - Ottimale: "58 minuti — perfetto, in linea con le tue ultime sessioni"
```

**Visualizzazione:** barra circolare con zona verde/gialla/rossa, tempo attuale che scorre, tempo target al centro.

#### 3. Fasting Tracker
- **Timer digiuno:** avvio/stop con notifiche push (12h, 14h, 16h, 24h, 36h, 48h, 72h)
- **Livello corrente:** visualizzazione chiara del livello (1/2/3) e progressione
- **Criteri oggettivi:** checklist misurabile per avanzamento accelerato (glicemia, HRV, performance, sonno, benessere, peso — come da sezione 4.1 del protocollo)
- **Diario refeeding:** cosa hai mangiato alla rottura, come ti sei sentito
- **Integrazione LLM:** analisi aderenza, suggerimenti personalizzati

#### 4. Biomarker Tracker
- **Input manuale:** esami del sangue (panel base + PhenoAge markers)
- **HRV:** integrazione con Apple Health / Google Health Connect
- **Peso/composizione:** trend con media mobile
- **PhenoAge calculator:** calcolo età biologica dai 9 marker (Levine 2018)
- **Grafici temporali:** trend di ogni marker nel tempo

#### 5. LLM Engine (bitnet.cpp via FFI)
- **Trigger automatici (foreground):** post-sessione, fine settimana, fine mese, milestone digiuno
- **Trigger manuali:** "come sto andando?", "cosa devo migliorare?"
- **Context window management:** i dati vengono pre-processati in formato strutturato prima di essere inviati al modello (non raw SQL dump)
- **Template system:** prompt predefiniti per ogni tipo di riepilogo, con slot per i dati
- **Lifecycle:** modello caricato in RAM solo quando serve, scaricato dopo generazione per liberare memoria
- **Isolate dedicato:** inference su Dart Isolate separato — UI mai bloccata

#### 6. Condizionamento Tracker
- **Freddo:** timer doccia fredda con progressione (sezione 3.1 protocollo)
- **Caldo:** log sessioni sauna con temperatura e durata (sezione 3.2)
- **Meditazione:** timer con fasi guidate (sezione 3.5)
- **Sonno:** integrazione con wearable + diario soggettivo (sezione 3.4)

---

## Tempi di riposo — DA AGGIUNGERE AL PROTOCOLLO

Il protocollo attualmente NON specifica tempi di riposo tra serie ed esercizi. Dalla ricerca:

**Meta-analisi Singer et al. 2024** (Frontiers in Sports, 9 studi, Bayesian):
- **1-2 minuti:** massima ipertrofia (ma differenza con 2-3 min è minima)
- **<1 minuto:** risultati inferiori
- **>3 minuti:** risultati inferiori per ipertrofia, leggermente migliori per forza pura

**Meta-analisi 2025** (medrxiv, soggetti allenati >1 anno):
- Per **forza**: riposi più lunghi (2-3 min) modestamente superiori
- Per **ipertrofia**: differenze trascurabili sopra 1 min

**Raccomandazione per Phoenix** (dove l'obiettivo è forza funzionale, NON ipertrofia):

| Contesto | Riposo tra serie | Riposo tra esercizi | Razionale |
|----------|-----------------|---------------------|-----------|
| **Forza (esercizi compound)** | 2-3 min | 3 min | Recupero neuromuscolare per performance |
| **Forza (esercizi accessori)** | 90s-2 min | 2 min | Meno demanding, riposo ridotto |
| **Core/stabilità** | 60-90s | 90s | Esercizi meno tassanti sul SNC |
| **HIIT** | Definito dal protocollo intervalli | — | Rapporto lavoro:riposo specifico |
| **Deload** | Come forza ma RPE -2 | Come forza | Stessi tempi, intensità ridotta |

**Adattivo per livello:**
- **Principiante (Livello 1-2 delle progressioni):** +30s rispetto ai valori sopra (più recupero)
- **Intermedio (Livello 3-4):** valori standard
- **Avanzato (Livello 5-6):** -15s O +30s a scelta (recupero ridotto per densità, o aumentato per performance massima)

**Fonti:** [Singer 2024 meta-analysis](https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2024.1429789/full), [2025 meta-analysis](https://www.medrxiv.org/content/10.1101/2025.09.22.25336351v2.full)

---

## Data Model (schema concettuale)

```
users
  ├── id, created_at, settings_json

exercises (pre-populated from JSON)
  ├── id, name, category (push/pull/squat/hinge/core)
  ├── phoenix_level, muscles_primary, muscles_secondary
  ├── instructions, image_paths, animation_path
  ├── progression_next_id, progression_prev_id
  └── advancement_criteria

workout_sessions
  ├── id, user_id, started_at, ended_at
  ├── type (strength/cardio/power/deload/flexibility)
  ├── duration_minutes, duration_score (green/yellow/red)
  ├── rpe_average, notes
  └── llm_summary_text

workout_sets
  ├── id, session_id, exercise_id, set_number
  ├── reps_target, reps_completed, rpe
  ├── tempo_eccentric, tempo_concentric (seconds)
  ├── rest_seconds_after
  └── notes

fasting_sessions
  ├── id, user_id, started_at, ended_at
  ├── target_hours, actual_hours, level (1/2/3)
  ├── glucose_readings_json, hrv_readings_json
  ├── refeeding_notes, tolerance_score
  └── llm_summary_text

biomarkers
  ├── id, user_id, date, type (blood_panel/weight/hrv/phenoage)
  └── values_json

conditioning_sessions
  ├── id, user_id, date, type (cold/heat/meditation/sleep)
  ├── duration_seconds, temperature (for cold/heat)
  └── notes

llm_reports
  ├── id, user_id, generated_at
  ├── type (post_workout/weekly/monthly/fasting/motivation)
  ├── prompt_template, context_data_json
  └── output_text

progression_history
  ├── id, user_id, exercise_id, date
  ├── from_level, to_level
  └── criteria_met_json
```

---

## Schermate principali (wireframe concettuale)

1. **Home / Dashboard**
   - Prossimo allenamento programmato
   - Stato digiuno corrente (se attivo) con timer
   - Streak/aderenza settimana corrente
   - Ultimo insight LLM

2. **Sessione allenamento (la schermata core)**
   - Esercizio corrente: nome + GIF animata + muscoli target
   - Metronomo visivo/audio per tempo sotto tensione
   - Counter serie/reps con input rapido
   - Timer riposo automatico tra serie (countdown circolare)
   - Barra durata sessione (con zona colore)
   - Pulsante "prossimo esercizio" / "fine sessione"

3. **Digiuno**
   - Timer grande circolare
   - Milestone (12h, 16h, 24h, 36h, 48h, 72h) con indicatori
   - Input glicemia/sensazioni
   - Storico digiuni con trend

4. **Progressioni**
   - Mappa visiva delle progressioni per categoria (push/pull/squat/hinge/core)
   - Livello corrente evidenziato
   - Criteri per il prossimo livello
   - Storico avanzamenti

5. **Biomarker / Analytics**
   - PhenoAge (età biologica vs anagrafica)
   - Grafici trend per marker
   - HRV trend
   - Peso/composizione

6. **Coach AI**
   - Chat con l'LLM locale
   - Storico report generati
   - Riepiloghi automatici

7. **Condizionamento**
   - Timer freddo/caldo/meditazione
   - Progressioni (es. doccia fredda: 30s → 2-3 min)
   - Log sonno

---

## Cosa possiamo imparare dalle app esistenti

Dalle app più usate nel 2025-2026 (Hevy, Strong, JEFIT, Fitbod, Nike Training Club):

| Pattern UX | Cosa fanno bene | Come Phoenix lo migliora |
|------------|----------------|-------------------------|
| **Rest timer automatico** | Hevy: timer parte automaticamente dopo log serie | Phoenix: timer adattivo al livello + tipo esercizio |
| **Progressione visuale** | Strong: grafici volume/1RM nel tempo | Phoenix: mappa progressioni calisteniche a livelli |
| **Audio cues** | Nike TC: istruzioni vocali durante esercizio | Phoenix: metronomo per tempo sotto tensione (specifico per forza) |
| **AI coaching** | Fitbod: genera workout con ML | Phoenix: LLM locale che analizza pattern e genera insight in linguaggio naturale |
| **Semplicità input** | Hevy: swipe per log reps, tap per peso | Phoenix: stesso pattern, ma reps only (bodyweight) |
| **Social/gamification** | Strava: streak, badge, community | Phoenix: streak aderenza, milestone livelli (no social — privacy first) |

**Fonti:** [Fortune Best Workout Apps 2026](https://fortune.com/article/best-workout-apps/), [Garage Gym Reviews](https://www.garagegymreviews.com/best-workout-apps)

---

## File che verranno toccati / creati

**Nuovo progetto Flutter:**
```
phoenix_app/
  ├── lib/
  │   ├── main.dart
  │   ├── app/                    # Router, theme, config
  │   ├── features/
  │   │   ├── workout/            # Sessione, timer, audio, visual
  │   │   ├── fasting/            # Timer, tracking, criteri
  │   │   ├── biomarkers/         # Input, grafici, PhenoAge
  │   │   ├── conditioning/       # Freddo, caldo, meditazione, sonno
  │   │   ├── coach/              # LLM interface, report
  │   │   └── progressions/       # Mappa livelli, storico
  │   ├── core/
  │   │   ├── database/           # Drift schema, migrations
  │   │   ├── llm/                # bitnet.cpp FFI wrapper, prompt templates, abstraction layer
  │   │   ├── audio/              # Metronomo, beep, voice
  │   │   ├── notifications/      # Background service, local notifications, timer
  │   │   └── models/             # Entità condivise
  │   └── assets/
  │       ├── exercises/          # JSON + immagini + GIF
  │       ├── sounds/             # Metronomo, beep, voice cues
  │       └── fonts/
  ├── test/
  ├── pubspec.yaml
  └── README.md
```

**Protocollo da aggiornare:**
- `references/phoenix-protocol.md` — aggiungere sezione tempi di riposo tra serie/esercizi

---

## Come verifico che funziona

1. **Workout engine:** sessione completa push day con timer, audio, visual, log reps, riepilogo LLM
2. **Duration score:** dopo 8+ sessioni simulate, lo score è coerente con i range
3. **Fasting tracker:** ciclo completo Livello 1 → check criteri → suggerimento avanzamento
4. **LLM:** genera riepilogo coerente e utile post-sessione su device reale (non emulatore)
5. **Offline:** tutto funziona in airplane mode
6. **Performance:** animazioni a 60fps, LLM risponde in <30s su mid-range

---

## Rischi e mitigazioni

| Rischio | Impatto | Mitigazione |
|---------|---------|-------------|
| BitNet 2B insufficiente per insight complessi | Output generici o incoerenti | Prompt engineering aggressivo + template strutturati. Il modello fa riepiloghi e pattern matching, non ragionamento complesso |
| Integrazione bitnet.cpp via FFI complessa | Bug, crash nativi, debug difficile | Wrapper FFI minimale, test su 5+ device reali, Isolate dedicato con crash recovery |
| Dimensione download modello (1.2GB) | Utente abbandona durante download | Download progressivo post-install con resume, indicatore progresso, app funziona senza LLM (modalita degradata) |
| GIF animate pesanti per 50-80 esercizi | ~200-400MB di asset | Compressione WebP animato, lazy loading, possibile download progressivo |
| Battery drain da LLM inference | Utente si lamenta | Inference solo on-demand in foreground, mai in background. Caching aggressivo dei risultati |
| Background service killed da OS | Notifiche mancate | Android: Foreground Service con notifica persistente per digiuno. iOS: pre-scheduling notifiche locali ai milestone |
| bitnet.cpp non ancora ottimizzato per tutti i SoC ARM | Performance sotto le attese su alcuni device | Benchmark al primo avvio, se <3 tok/s fallback a template pre-compilati senza LLM |
