# Feature: Integrazione AI On-Device (BitNet b1.58 2B4T)

**Status:** IMPLEMENTED
**Created:** 2026-03-12 10:00 UTC
**Approved:** 2026-03-12
**Completed:** —

---

## 1. Overview

**What?** Integrare il modello LLM BitNet b1.58 2B4T (~1.2GB, ternario 1.58-bit) come runtime nativo nell'app Phoenix, sostituendo il placeholder attuale in `BitnetRuntime` con vere chiamate FFI a `bitnet.cpp`.

**Why?** Abilitare un coach AI completamente on-device: report personalizzati, chat contestuale, suggerimenti adattivi basati su dati reali dell'utente. Zero dipendenza da server, zero latenza di rete, privacy totale.

**For whom?** Tutti gli utenti Phoenix. Il modello gira su dispositivi con almeno 4GB RAM.

**Success metric:**
- Inference funzionante su Android (arm64) e iOS (arm64) con >= 3 tok/s
- Fallback automatico a template se modello non disponibile o device troppo lento
- Chat abilitata nel Coach screen quando modello pronto
- Tempo di download < 10 min su connessione media (10 Mbps)

---

## 2. Parti della Spec

### Parte A — Native FFI Layer

#### A1. Compilazione bitnet.cpp

**Android (NDK):**
- Compilare `bitnet.cpp` come shared library `libbitnet.so` per `arm64-v8a` (minimo) e `armeabi-v7a` (opzionale)
- Usare CMakeLists.txt nella directory `phoenix_app/android/app/src/main/jni/`
- La libreria NON viene inclusa nell'APK — viene caricata da disco dopo il download del modello

```cmake
# phoenix_app/android/app/src/main/jni/CMakeLists.txt
cmake_minimum_required(VERSION 3.18)
project(bitnet_phoenix)

set(BITNET_SRC_DIR "${CMAKE_SOURCE_DIR}/bitnet-cpp")

add_library(bitnet SHARED
    ${BITNET_SRC_DIR}/bitnet.cpp
    ${BITNET_SRC_DIR}/bitnet-lut.cpp
    ${BITNET_SRC_DIR}/ggml.c
    ${BITNET_SRC_DIR}/ggml-alloc.c
    ${BITNET_SRC_DIR}/ggml-backend.c
)

target_compile_options(bitnet PRIVATE
    -O3 -DNDEBUG
    -march=armv8-a+dotprod  # NEON + dot product per ternary kernels
    -ffast-math
)

target_include_directories(bitnet PRIVATE ${BITNET_SRC_DIR})
```

**iOS (Xcode):**
- Compilare come framework statico o `.dylib` via podspec
- Target: `arm64` (tutti i dispositivi iOS moderni)

```ruby
# phoenix_app/ios/bitnet_ios.podspec
Pod::Spec.new do |s|
  s.name         = 'bitnet_ios'
  s.version      = '0.1.0'
  s.summary      = 'BitNet b1.58 inference engine'
  s.homepage     = 'https://github.com/microsoft/BitNet'
  s.license      = 'MIT'
  s.author       = 'Phoenix'
  s.source       = { :path => '.' }
  s.platform     = :ios, '15.0'

  s.source_files = 'bitnet-cpp/**/*.{c,cpp,h}'
  s.compiler_flags = '-O3 -DNDEBUG -ffast-math'
  s.pod_target_xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'OTHER_CFLAGS' => '-DGGML_USE_ACCELERATE',
  }
  s.frameworks = 'Accelerate'
end
```

#### A2. Dart FFI Bindings

Riscrivere `BitnetRuntime` in `llm_runtime.dart` con vere chiamate FFI:

```dart
// Signature C da wrappare (da bitnet.h):
//   void*   bitnet_init(const char* model_path);
//   char*   bitnet_generate(void* ctx, const char* prompt, int max_tokens);
//   void    bitnet_stream_start(void* ctx, const char* prompt, int max_tokens);
//   char*   bitnet_stream_next(void* ctx);  // returns NULL when done
//   int     bitnet_stream_done(void* ctx);
//   void    bitnet_free(void* ctx);
//   void    bitnet_free_string(char* str);
```

Struttura dei bindings Dart:

```dart
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';

// Typedefs FFI
typedef BitnetInitNative = Pointer<Void> Function(Pointer<Utf8> modelPath);
typedef BitnetInit = Pointer<Void> Function(Pointer<Utf8> modelPath);

typedef BitnetGenerateNative = Pointer<Utf8> Function(
    Pointer<Void> ctx, Pointer<Utf8> prompt, Int32 maxTokens);
typedef BitnetGenerate = Pointer<Utf8> Function(
    Pointer<Void> ctx, Pointer<Utf8> prompt, int maxTokens);

typedef BitnetStreamStartNative = Void Function(
    Pointer<Void> ctx, Pointer<Utf8> prompt, Int32 maxTokens);
typedef BitnetStreamStart = void Function(
    Pointer<Void> ctx, Pointer<Utf8> prompt, int maxTokens);

typedef BitnetStreamNextNative = Pointer<Utf8> Function(Pointer<Void> ctx);
typedef BitnetStreamNext = Pointer<Utf8> Function(Pointer<Void> ctx);

typedef BitnetStreamDoneNative = Int32 Function(Pointer<Void> ctx);
typedef BitnetStreamDone = int Function(Pointer<Void> ctx);

typedef BitnetFreeNative = Void Function(Pointer<Void> ctx);
typedef BitnetFree = void Function(Pointer<Void> ctx);

typedef BitnetFreeStringNative = Void Function(Pointer<Utf8> str);
typedef BitnetFreeString = void Function(Pointer<Utf8> str);
```

#### A3. Gestione file modello

| Aspetto | Dettaglio |
|---------|-----------|
| **Nome file** | `bitnet-2b4t-q8.gguf` (~1.2 GB) |
| **Posizione** | `getApplicationDocumentsDirectory()/models/` |
| **Rilevamento** | `File('$docDir/models/bitnet-2b4t-q8.gguf').existsSync()` |
| **Libreria nativa** | `libbitnet.so` (Android) / framework (iOS) — bundled nell'APK/IPA |

#### A4. Gestione memoria

- Il modello occupa ~1.2GB in RAM una volta caricato (1.58-bit weights + kernels)
- **Caricamento:** solo su richiesta utente (non all'avvio dell'app)
- **Scaricamento:** automatico dopo 5 minuti di inattivita o quando l'app va in background
- **RAM check:** prima di caricare, verificare RAM disponibile >= 1.5GB tramite `SysInfo` (Android) / `os_proc_available_memory` (iOS)
- **Isolate:** l'inferenza gira in un `Isolate` separato (gia previsto in `LlmEngine._generateInIsolate`). L'Isolate tiene il modello in memoria; la comunicazione avviene via `SendPort/ReceivePort`

---

### Parte B — Model Download Flow

#### B1. Sorgente download

| Opzione | Pro | Contro | Scelta |
|---------|-----|--------|--------|
| GitHub Release | Gratuito, CDN globale | Rate limits, no resume nativo | Per v1 (MVP) |
| Asset server dedicato | Controllo totale, resume facile | Costa | v2 |
| Bundle nell'APK | Nessun download | APK da 1.3GB, inaccettabile | No |

**Scelta MVP:** GitHub Release con download via `dio` (supporta resume nativo con `Range` headers).

#### B2. UI Download

Nuovo widget `ModelDownloadCard` in settings e nel Coach screen:

```
+-----------------------------------------------+
|  Phoenix Coach AI                              |
|  Modello: BitNet 2B4T (1.2 GB)                |
|                                                |
|  [████████████░░░░░░░░░] 63%  780 MB / 1.2 GB |
|  Velocita: 8.2 MB/s — ~52s rimanenti          |
|                                                |
|  [Annulla]                          [Pausa]    |
+-----------------------------------------------+
```

Dopo il download:
```
+-----------------------------------------------+
|  Phoenix Coach AI                    [Attivo]  |
|  Modello: BitNet 2B4T — 1.2 GB su disco       |
|  Velocita: 12.3 tok/s                          |
|                                                |
|  [Elimina modello]                             |
+-----------------------------------------------+
```

#### B3. Requisiti tecnici download

- **Package:** `dio` (gia maturo per Flutter, supporta resume, progress callbacks)
- **Resume:** salvare `etag` + `bytes_downloaded` in `SharedPreferences`. Se download interrotto, riprendere con header `Range: bytes=N-`
- **Checksum:** SHA256 del file scaricato vs hash noto. Se mismatch, eliminare e riscaricare
- **Spazio su disco:** verificare >= 2GB liberi prima di iniziare (modello + spazio temporaneo)
- **Background download:** usare `workmanager` (gia in dipendenze) per continuare in background su Android. iOS limitato a ~30s in background — notificare l'utente di tenere l'app aperta

#### B4. Versioning modello

- File `model_manifest.json` nel server/release:
```json
{
  "version": "2b4t-v1",
  "filename": "bitnet-2b4t-q8.gguf",
  "size_bytes": 1288490188,
  "sha256": "abc123...",
  "min_ram_mb": 1500,
  "download_url": "https://github.com/.../releases/download/v1/bitnet-2b4t-q8.gguf"
}
```
- Confrontare `version` locale (salvata in `AppSettings`) con manifest remoto
- Se nuova versione disponibile, mostrare badge "Aggiornamento disponibile" in settings

---

### Parte C — Integrazione LLM nell'App

#### C1. Architettura runtime (gia predisposta)

L'architettura attuale e gia corretta:

```
LlmEngine (orchestratore)
  ├── BitnetRuntime      ← quando modello disponibile
  └── TemplateFallbackRuntime  ← fallback
```

**Modifica principale:** `LlmEngine` deve scegliere automaticamente il runtime:

```dart
class LlmEngine {
  LlmRuntime _runtime;
  double _lastTokPerSec = 0;

  LlmEngine() : _runtime = TemplateFallbackRuntime();

  /// Tenta di inizializzare BitnetRuntime. Se fallisce o troppo lento, usa template.
  Future<void> initBestRuntime() async {
    final modelFile = await _modelPath();
    if (!File(modelFile).existsSync()) {
      _runtime = TemplateFallbackRuntime();
      return;
    }

    final bitnet = BitnetRuntime(modelPath: modelFile);
    try {
      await bitnet.load();
      // Benchmark: genera 20 token e misura tok/s
      final sw = Stopwatch()..start();
      await bitnet.infer('Test', maxTokens: 20);
      sw.stop();
      _lastTokPerSec = 20 / (sw.elapsedMilliseconds / 1000);

      if (_lastTokPerSec < 3.0) {
        await bitnet.unload();
        _runtime = TemplateFallbackRuntime();
      } else {
        _runtime = bitnet;
      }
    } catch (_) {
      _runtime = TemplateFallbackRuntime();
    }
  }
}
```

#### C2. Streaming generation

Aggiungere metodo `generateStream` a `LlmEngine` per mostrare token man mano:

```dart
Stream<String> generateStream({
  required PromptTemplate template,
  required Map<String, dynamic> context,
  int maxTokens = 512,
}) async* {
  final prompt = template.render(context);
  // Usa bitnet_stream_start/next/done via FFI
  _runtime.streamStart(prompt, maxTokens: maxTokens);
  while (!_runtime.streamDone()) {
    final token = await _runtime.streamNext();
    if (token != null) yield token;
  }
}
```

Il `CoachScreen` userà questo stream per la chat e per i report (mostrando testo progressivamente).

#### C3. Chat nel Coach screen

Quando modello disponibile:
- Abilitare il `TextField` della chat (attualmente `enabled: false`)
- Ogni messaggio utente viene wrappato in un prompt con contesto (ultimi dati workout, digiuno, biomarker)
- Storico chat mantenuto in memoria (non persistito — e un coach, non un messenger)
- Limite: 10 messaggi in sessione, poi suggerire "Vuoi un report completo?"

Nuovo prompt template `ChatTemplate`:
```dart
class ChatTemplate implements PromptTemplate {
  @override
  String get name => 'chat';

  @override
  String render(Map<String, dynamic> context) {
    final userMessage = context['user_message'] ?? '';
    final history = context['chat_history'] ?? '';
    final userData = context['user_data_summary'] ?? '';

    return '''Sei un coach di longevita e performance. Rispondi in italiano, max 100 parole.

Dati utente:
$userData

Conversazione:
$history

Utente: $userMessage
Coach:''';
  }
}
```

#### C4. Funzionalita AI oltre i report

##### C4.1 Tempo adattivo per tier (da Protocollo §2.3)

Il protocollo definisce:

| Tier | Tempo eccentrica |
|------|-----------------|
| Beginner | 3 sec (fisso, apprendimento motorio) |
| Intermediate | 2-3 sec |
| Advanced | Variabile per blocco di periodizzazione |

Attualmente `WorkoutGenerator._toPlanned()` usa `ex.defaultTempoEcc` dal DB. Con l'LLM possiamo:
- **Advanced tier:** il modello riceve il blocco di periodizzazione corrente (accumulazione/intensificazione/realizzazione) e suggerisce il tempo specifico
- **Tutti i tier:** il modello analizza RPE trend delle ultime 2 settimane e suggerisce aggiustamenti tempo se RPE troppo alto/basso

**Implementazione:** nuovo `TempoAdvisorTemplate` che prende tier, blocco, RPE history e restituisce JSON strutturato:
```json
{"tempo_ecc": 3, "tempo_con": 1, "rationale": "Blocco accumulazione: TUT elevato per ipertrofia"}
```

Fallback: se LLM non disponibile, usare la tabella statica dal protocollo (comportamento attuale).

##### C4.2 Suggerimenti workout basati su fatica/RPE

- Nuovo `FatigueAdvisorTemplate`: analizza ultimi 7 giorni di RPE, durate, volume
- Output: "Riduci volume del 20% oggi" / "Pronto per progressione" / "Giorno di scarico consigliato"
- Mostrato nel `TrainingScreen` come card prima dell'inizio workout

##### C4.3 Insight personalizzati sul digiuno

- Nuovo `FastingAdvisorTemplate`: analizza pattern di tolerance_score, energy_score, durate completate
- Output: osservazioni su pattern (es. "I tuoi digiuni del martedi hanno tolerance score piu alto — prova a spostare i digiuni lunghi in quel giorno")
- Mostrato nel `FastingScreen` come card espandibile

##### C4.4 Interpretazione biomarker in linguaggio naturale

- Nuovo `BiomarkerInsightTemplate`: riceve ultimo pannello sangue + variazioni vs precedente
- Output: spiegazione in linguaggio naturale (es. "Il tuo hsCRP e sceso da 2.1 a 0.8 — ottimo segnale anti-infiammatorio. Continua cosi col protocollo attuale.")
- Mostrato nel `BiomarkerDashboardTab` sotto il PhenoAge hero card

---

### Parte D — Settings & UI

#### D1. Modifiche a AppSettings

Aggiungere campi:

```dart
class AppSettings {
  // ... campi esistenti ...
  final bool aiCoachEnabled;        // toggle globale AI
  final String? modelVersion;       // versione modello scaricato
  final double? lastBenchmarkTokS;  // ultimo benchmark tok/s

  const AppSettings({
    // ... esistenti ...
    this.aiCoachEnabled = true,
    this.modelVersion,
    this.lastBenchmarkTokS,
  });
}
```

#### D2. Modifiche a SettingsScreen

Aggiungere sezione "AI Coach" dopo la sezione "Coach":

```
── AI COACH ──
[Toggle] Coach AI attivo
[ModelDownloadCard]  ← widget download/status/elimina
```

#### D3. Modifiche a CoachScreen

- **Badge status:** sostituire il dot attuale con un badge piu ricco:
  - Verde pulsante + "AI Pronto (12.3 tok/s)" se modello caricato
  - Arancione + "Scaricamento in corso... 63%" se download attivo
  - Grigio + "Template-based (scarica modello per AI)" se non disponibile
- **Chat:** abilitare `TextField` + pulsante send quando `engine.isReady`
- **Streaming:** report e chat mostrano testo token per token con cursore lampeggiante

---

## 3. File da Modificare

| File | Azione | Modifiche |
|------|--------|-----------|
| `lib/core/llm/llm_runtime.dart` | Riscrivere | FFI bindings reali, `BitnetRuntime` con load/infer/stream/unload via dart:ffi |
| `lib/core/llm/llm_engine.dart` | Modificare | Auto-select runtime, benchmark, `generateStream()`, gestione lifecycle |
| `lib/core/llm/prompt_templates.dart` | Modificare | Aggiungere `ChatTemplate`, `TempoAdvisorTemplate`, `FatigueAdvisorTemplate`, `FastingAdvisorTemplate`, `BiomarkerInsightTemplate` |
| `lib/core/llm/model_manager.dart` | Creare | Download, resume, delete, checksum, version check, progress stream |
| `lib/core/models/app_settings.dart` | Modificare | Aggiungere `aiCoachEnabled`, `modelVersion`, `lastBenchmarkTokS` |
| `lib/core/models/settings_notifier.dart` | Modificare | Aggiungere setter per nuovi campi AI |
| `lib/app/providers.dart` | Modificare | Aggiungere `modelManagerProvider`, aggiornare `llmEngineProvider` con auto-init |
| `lib/features/settings/settings_screen.dart` | Modificare | Sezione "AI Coach" con toggle + `ModelDownloadCard` |
| `lib/features/coach/coach_screen.dart` | Modificare | Chat funzionante, streaming report, badge status migliorato |
| `lib/features/coach/widgets/model_download_card.dart` | Creare | Widget download con progress, pause, resume, delete |
| `lib/features/coach/widgets/chat_message.dart` | Creare | Bolla messaggio utente/coach con streaming |
| `lib/features/training/training_screen.dart` | Modificare | Card suggerimento AI pre-workout (se modello disponibile) |
| `lib/features/fasting/fasting_screen.dart` | Modificare | Card insight AI (se modello disponibile) |
| `lib/features/biomarkers/biomarker_dashboard_tab.dart` | Modificare | Interpretazione biomarker sotto PhenoAge card |
| `lib/core/models/workout_generator.dart` | Modificare | Hook opzionale per tempo adattivo da LLM |
| `android/app/src/main/jni/CMakeLists.txt` | Creare | Build config per libbitnet.so |
| `android/app/build.gradle` | Modificare | Aggiungere externalNativeBuild per CMake |
| `ios/bitnet_ios.podspec` | Creare | Build config per framework iOS |
| `ios/Podfile` | Modificare | Aggiungere pod bitnet_ios |
| `pubspec.yaml` | Modificare | Aggiungere `dio`, `ffi` (gia presente), `crypto` (per SHA256) |

---

## 4. Test Specification

### Unit Tests

| ID | Cosa testo | Input | Atteso | Priorita |
|----|-----------|-------|--------|----------|
| UT-01 | `BitnetRuntime.isModelAvailable` | File modello assente | `false` | Alta |
| UT-02 | `BitnetRuntime.isModelAvailable` | File modello presente | `true` | Alta |
| UT-03 | `LlmEngine.initBestRuntime` senza modello | Nessun file | Fallback a `TemplateFallbackRuntime` | Alta |
| UT-04 | `LlmEngine.initBestRuntime` con modello lento | <3 tok/s | Fallback a `TemplateFallbackRuntime` | Alta |
| UT-05 | `LlmEngine.initBestRuntime` con modello veloce | >=3 tok/s | Usa `BitnetRuntime` | Alta |
| UT-06 | `ModelManager.download` con resume | Download interrotto al 50% | Riprende dal 50% | Alta |
| UT-07 | `ModelManager.verifyChecksum` | File corrotto | Ritorna `false`, elimina file | Alta |
| UT-08 | `ChatTemplate.render` | Messaggio + contesto | Prompt formattato correttamente | Media |
| UT-09 | `TempoAdvisorTemplate.render` | Tier + blocco + RPE | JSON parsabile con tempo_ecc/tempo_con | Media |
| UT-10 | `AppSettings` con nuovi campi AI | JSON con/senza campi AI | Deserializzazione corretta con defaults | Alta |

### Integration Tests

| ID | Flusso | Componenti | Atteso | Priorita |
|----|--------|-----------|--------|----------|
| IT-01 | Download completo | ModelManager -> disk -> LlmEngine | Modello scaricato, engine inizializzato | Alta |
| IT-02 | Chat end-to-end | CoachScreen -> LlmEngine -> BitnetRuntime | Risposta visualizzata in streaming | Alta |
| IT-03 | Fallback graceful | LlmEngine senza modello -> ReportGenerator | Report template generato normalmente | Alta |
| IT-04 | Delete e re-download | Settings -> delete -> download | Modello eliminato, ri-scaricato, engine funzionante | Media |

### Edge Cases

| ID | Scenario | Condizione | Comportamento atteso |
|----|----------|-----------|---------------------|
| EC-01 | RAM insufficiente | Device con <2GB RAM | Mostra avviso, non carica modello, usa template |
| EC-02 | Disco pieno durante download | Spazio esaurito a meta | Errore chiaro, file parziale preservato per resume |
| EC-03 | App in background durante inference | iOS background limit | Completa generazione corrente, poi unload |
| EC-04 | Download su rete cellulare | Connessione costosa | Dialog "Scaricare 1.2GB su rete mobile?" |
| EC-05 | Modello corrotto | Checksum mismatch | Elimina e notifica utente di riscaricare |
| EC-06 | Concurrent generate calls | Due report richiesti insieme | Queue: secondo aspetta il primo |

---

## 5. Implementation Notes

### Ordine di implementazione consigliato

1. **Fase 1 — FFI Layer** (Parte A): compilare bitnet.cpp, scrivere bindings Dart, verificare caricamento modello su un device fisico
2. **Fase 2 — Download** (Parte B): `ModelManager`, UI download, resume, checksum
3. **Fase 3 — Engine upgrade** (Parte C1-C2): auto-select runtime, benchmark, streaming
4. **Fase 4 — Coach chat** (Parte C3): abilitare chat, `ChatTemplate`, UI streaming
5. **Fase 5 — AI features** (Parte C4): tempo adattivo, fatigue advisor, fasting insights, biomarker interpretation
6. **Fase 6 — Settings** (Parte D): toggle, model management card, status badge

### Dipendenze esterne da aggiungere

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.4.0          # Download con resume e progress
  crypto: ^3.0.3       # SHA256 checksum
  # ffi: ^2.1.3        # Gia presente
  # path_provider: ...  # Gia presente (via drift)
```

### Rischi

| Rischio | Mitigazione |
|---------|-------------|
| bitnet.cpp non compila su iOS/Android | Testare compilazione PRIMA di tutto il resto. Se fallisce, valutare llama.cpp come alternativa |
| Performance < 3 tok/s su device medi | Il modello 2B4T e piccolo — i benchmark pubblici mostrano ~10 tok/s su Snapdragon 8 Gen 2. Se insufficiente, valutare quantizzazione piu aggressiva |
| RAM pressure causa kill dell'app | Unload aggressivo in background, monitorare `didReceiveMemoryWarning` (iOS) / `onTrimMemory` (Android) |
| Download 1.2GB scoraggia utenti | Mostrare chiaramente che l'app funziona anche senza (template fallback). Download opzionale |

---

## 6. Verifica (Checklist "Done")

- [ ] `libbitnet.so` compila e si carica su Android arm64
- [ ] Framework bitnet compila e si carica su iOS arm64
- [ ] `BitnetRuntime.load()` carica modello da disco via FFI
- [ ] `BitnetRuntime.infer()` genera testo coerente
- [ ] `BitnetRuntime.streamStart/streamNext/streamDone` funzionano
- [ ] `BitnetRuntime.unload()` libera memoria
- [ ] Download modello con progress bar funzionante
- [ ] Resume download interrotto funzionante
- [ ] Checksum SHA256 verificato dopo download
- [ ] Eliminazione modello da settings funzionante
- [ ] `LlmEngine` sceglie automaticamente runtime (bitnet vs template)
- [ ] Benchmark tok/s eseguito e salvato in settings
- [ ] Fallback a template se <3 tok/s o modello assente
- [ ] Chat abilitata nel Coach screen quando modello pronto
- [ ] Streaming token visibile nella UI (report e chat)
- [ ] Toggle "AI Coach" in settings funzionante
- [ ] `ModelDownloadCard` mostra stato corretto (download/pronto/assente)
- [ ] Badge status nel Coach screen aggiornato
- [ ] `AppSettings` serializza/deserializza nuovi campi senza rompere dati esistenti
- [ ] Nessuna regressione sui report template-based
- [ ] RAM check prima del caricamento modello
- [ ] Unload automatico in background

---

**Verified by:** —
**Commit:** —
