# Spec: LLM Native Bridge (llama.cpp → Flutter FFI)

## Cosa sto costruendo

Un bridge C che collega llama.cpp (già presente in `android/app/src/main/jni/llama.cpp/`) al codice Dart FFI esistente (`llm_runtime.dart`), permettendo inferenza on-device del modello BitNet b1.58 2B-4T su Android.

## Compatibilità verificata

| Componente | Stato | Dettaglio |
|------------|-------|-----------|
| Modello GGUF | OK | `ggml-model-i2_s.gguf` da HuggingFace, usa tipi ternari `TQ1_0`/`TQ2_0` |
| llama.cpp (jni/) | OK | Build b5233, supporta `TQ1_0` (type 34) e `TQ2_0` (type 35) |
| CPU backend ARM | OK | `ggml-cpu/ops.cpp` implementa operazioni per tipi ternari |
| API llama.cpp | OK | `llama_model_load_from_file()` + `llama_new_context_with_model()` presenti in `include/llama.h` |
| Download modello | OK | `ModelManager` scarica da URL HuggingFace reale, resume con dio, checksum SHA256 |
| Fallback | OK | `LlmEngine.initBestRuntime()` → se benchmark < 3 tok/s, switcha a TemplateChat |
| FFI Dart | OK | Typedef in `llm_runtime.dart` matchano le firme C del bridge (Pointer<Void>/Pointer<Utf8>/Int32) |

## Stato attuale

- **llama.cpp** è già copiato in `jni/llama.cpp/` (sorgente completo con ggml, build b5233)
- **CMakeLists.txt** in `jni/` esiste ma punta a file inesistenti (`bitnet-cpp/bitnet.cpp` ecc.)
- **build.gradle.kts** ha il blocco `externalNativeBuild` commentato, pronto da attivare
- **llm_runtime.dart** ha l'interfaccia FFI completa (`BitnetRuntime`) che cerca `libbitnet.so` e chiama `bitnet_init/generate/stream_start/stream_next/stream_done/free/free_string`
- **BitNet repo** clonato in `/PHOENIX/BitNet/` — i kernel ottimizzati sono in `BitNet/src/ggml-bitnet-lut.cpp` (ottimizzazione futura, non necessari per funzionare)

## File da toccare

| File | Azione |
|------|--------|
| `jni/phoenix_bridge.c` | **NUOVO** — wrapper C (~150 righe) |
| `jni/CMakeLists.txt` | **RISCRIVERE** — build llama.cpp + bridge come `libbitnet.so` |
| `android/app/build.gradle.kts` | **EDIT** — decommentare blocco cmake + ndk abiFilters |
| `phoenix_app/lib/core/llm/llm_runtime.dart` | **NO TOUCH** — typedef già allineati |

## Cosa posso riusare

- **llama.cpp in jni/** — sorgente completo, include CMakeLists.txt proprio, ggml, common
- **llm_runtime.dart** — interfaccia FFI già scritta, nomi funzione matchano
- **model_manager.dart** — download del GGUF già funzionante
- **llm_engine.dart** — orchestrazione runtime/template già pronta, benchmark e fallback inclusi
- **examples/llama.android/** dentro llama.cpp — riferimento per CMake cross-compilation Android

## Piano di implementazione

### 1. Scrivere `jni/phoenix_bridge.c`

Wrapper C che espone 7 funzioni con `extern "C"`:

```c
// Lifecycle
void* bitnet_init(const char* model_path);
void  bitnet_free(void* ctx);

// Blocking generation
char* bitnet_generate(void* ctx, const char* prompt, int max_tokens);
void  bitnet_free_string(char* str);

// Streaming
void  bitnet_stream_start(void* ctx, const char* prompt, int max_tokens);
char* bitnet_stream_next(void* ctx);
int   bitnet_stream_done(void* ctx);
```

Internamente usa le API llama.cpp:
- `bitnet_init` → `llama_model_load_from_file()` + `llama_new_context_with_model()` + `llama_sampler_chain_init()`
- `bitnet_generate` → `llama_tokenize()` + loop `llama_decode()` + `llama_sampler_sample()` + `llama_token_to_piece()` → strdup result
- `bitnet_stream_start` → tokenize + primo `llama_decode()`, salva stato streaming nel contesto
- `bitnet_stream_next` → `llama_sampler_sample()` + `llama_decode()` per il token successivo → strdup singolo token
- `bitnet_stream_done` → return 1 se EOS o n_cur >= n_max
- `bitnet_free` → `llama_sampler_free()` + `llama_free()` + `llama_model_free()`
- `bitnet_free_string` → `free()` sulla stringa allocata con strdup

Struttura contesto interna:
```c
typedef struct {
    struct llama_model*   model;
    struct llama_context* ctx;
    struct llama_sampler* sampler;
    // streaming state
    llama_token* tokens;
    int          n_tokens;
    int          n_cur;
    int          n_max;
    bool         streaming;
} phoenix_ctx;
```

### 2. Riscrivere `jni/CMakeLists.txt`

- Target: `libbitnet.so` (SHARED)
- Compila llama.cpp via `add_subdirectory(llama.cpp)` (usa il suo CMakeLists.txt)
- Disabilita tutto tranne CPU: `-DGGML_METAL=OFF -DGGML_CUDA=OFF -DGGML_VULKAN=OFF`
- Compila `phoenix_bridge.c` e linka contro `llama`, `ggml`, `common`
- Flags: `-O3 -DNDEBUG`
- Riferimento: `llama.cpp/examples/llama.android/llama/src/main/cpp/CMakeLists.txt`

### 3. Attivare build nativo in Gradle

In `build.gradle.kts`:
- Decommentare `externalNativeBuild { cmake { ... } }`
- Decommentare `ndk { abiFilters += listOf("arm64-v8a") }`
- Aggiungere cmake arguments: `-DGGML_METAL=OFF -DGGML_CUDA=OFF`
- Verificare che `ndkVersion` sia compatibile (≥ r25)

### 4. Kernel BitNet (fase 2 — opzionale)

I kernel ternari ottimizzati (`ggml-bitnet-lut.cpp`) da `BitNet/src/` possono essere aggiunti al build per guadagnare ~1.5x speed e ~50% energia su ARM. Da fare dopo che il bridge base funziona. Richiede:
- Copiare `BitNet/src/ggml-bitnet-lut.cpp` + `BitNet/include/ggml-bitnet.h` in `jni/`
- Aggiungere al CMake con `-DBITNET_ARM_TL1=ON`
- Zero modifiche al bridge C o al codice Dart

## Verifica

1. `flutter build apk` compila senza errori (il `.so` viene generato)
2. Il `.so` viene incluso nell'APK sotto `lib/arm64-v8a/libbitnet.so`
3. Su device: `LlmEngine.initBestRuntime()` carica BitnetRuntime con successo
4. Benchmark: genera 20 token, misura tok/s (atteso: 3-8 tok/s su Snapdragon 7xx+)
5. Streaming funziona: `stream_start` → loop `stream_next` → `stream_done` == true
6. Fallback: se benchmark < 3 tok/s, TemplateChat si attiva automaticamente

## Rischi

| Rischio | Mitigazione |
|---------|-------------|
| llama.cpp CMake non compila con NDK | Seguire pattern da `examples/llama.android/` (già testato dal progetto llama.cpp) |
| Modello troppo grande per RAM su device economici | Fallback automatico a TemplateChat; `minRamMb: 2000` nel manifest |
| Tempo di caricamento modello lungo (10-30s) | Caricamento asincrono già previsto in `LlmEngine`, UI mostra stato loading |
| Crash su architetture non arm64 | `abiFilters` limita a `arm64-v8a`; su emulatore x86 il `.so` non si carica → fallback a TemplateChat |
