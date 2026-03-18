// Phoenix LLM Bridge — llama.cpp (upstream + I2_S patches) → Dart FFI
// Exposes 7 C functions matching llm_runtime.dart typedefs.

#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include <unistd.h>

#include "llama.h"
#include "common.h"
#include "ggml.h"

#ifdef __ANDROID__
#include <android/log.h>
#define TAG "phoenix-bridge"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,  TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)
#else
#define LOGI(...) fprintf(stderr, __VA_ARGS__)
#define LOGE(...) fprintf(stderr, __VA_ARGS__)
#endif

// ─── Internal context ────────────────────────────────────────────

typedef struct {
    struct llama_model   * model;
    struct llama_context * ctx;
    struct llama_sampler * sampler;

    // streaming state
    llama_batch   batch;
    int           n_cur;
    int           n_max;
    bool          streaming;
    std::string   cached_piece;  // UTF-8 accumulator for partial codepoints
} phoenix_ctx;

// ─── Helpers ─────────────────────────────────────────────────────

static bool is_valid_utf8(const std::string & s) {
    const unsigned char * bytes = (const unsigned char *)s.c_str();
    while (*bytes) {
        int num;
        if      ((*bytes & 0x80) == 0x00) num = 1;
        else if ((*bytes & 0xE0) == 0xC0) num = 2;
        else if ((*bytes & 0xF0) == 0xE0) num = 3;
        else if ((*bytes & 0xF8) == 0xF0) num = 4;
        else return false;
        bytes++;
        for (int i = 1; i < num; i++) {
            if ((*bytes & 0xC0) != 0x80) return false;
            bytes++;
        }
    }
    return true;
}

// ─── Log redirect ───────────────────────────────────────────────

// Redirect llama.cpp internal logs to Android logcat
static void phoenix_log_callback(enum ggml_log_level level, const char * text, void * /* user_data */) {
    if (text == nullptr || text[0] == '\0') return;
    switch (level) {
        case GGML_LOG_LEVEL_ERROR: LOGE("%s", text); break;
        case GGML_LOG_LEVEL_WARN:  LOGI("WARN: %s", text); break;
        default:                   LOGI("%s", text); break;
    }
}

// ─── Public API ──────────────────────────────────────────────────

extern "C" {

// --- Lifecycle ---

void * bitnet_init(const char * model_path) {
    LOGI("bitnet_init: loading %s", model_path);

    // Redirect llama.cpp logs to logcat so we can see format/quant errors
    llama_log_set(phoenix_log_callback, nullptr);

    // Verify file exists and get size
    FILE * f = fopen(model_path, "rb");
    if (!f) {
        LOGE("bitnet_init: cannot open file %s", model_path);
        return nullptr;
    }
    fseek(f, 0, SEEK_END);
    long file_size = ftell(f);
    fclose(f);
    LOGI("bitnet_init: file size = %ld bytes (%.1f MB)", file_size, file_size / 1048576.0);

    if (file_size < 1024 * 1024) {
        LOGE("bitnet_init: file too small (%ld bytes) — likely incomplete download", file_size);
        return nullptr;
    }

    LOGI("bitnet_init: calling llama_backend_init");
    llama_backend_init();

    // Model params — mmap enabled for standard GGUF quants (Q4_K_M etc.)
    // Note: mmap was disabled for BitNet I2_S due to NaN issues, but standard quants work fine
    llama_model_params model_params = llama_model_default_params();
    model_params.use_mmap = true;
    model_params.n_gpu_layers = 0;  // CPU only

    LOGI("bitnet_init: loading model (mmap=on, gpu_layers=0)...");
    struct llama_model * model = llama_model_load_from_file(model_path, model_params);
    if (!model) {
        LOGE("bitnet_init: failed to load model");
        llama_backend_free();
        return nullptr;
    }
    LOGI("bitnet_init: model loaded successfully");

    // Context params — small context for mobile (saves ~100MB RAM)
    // Use big cores for inference — SD865 has 4 big (A77) + 4 little (A55)
    // Leave 2 cores for OS/UI, use up to 6 for inference
    int n_cores = (int)sysconf(_SC_NPROCESSORS_ONLN);
    int n_threads = std::max(1, std::min(n_cores - 2, 6));
    LOGI("bitnet_init: using %d threads (of %d cores)", n_threads, n_cores);

    llama_context_params ctx_params = llama_context_default_params();
    ctx_params.n_ctx           = 512;
    ctx_params.n_threads       = n_threads;
    ctx_params.n_threads_batch = n_threads;

    LOGI("bitnet_init: creating context (n_ctx=512)...");
    struct llama_context * ctx = llama_init_from_model(model, ctx_params);
    if (!ctx) {
        LOGE("bitnet_init: failed to create context");
        llama_model_free(model);
        llama_backend_free();
        return nullptr;
    }
    LOGI("bitnet_init: context created successfully");

    // Sampler — temperature + top_p for natural output
    auto sparams = llama_sampler_chain_default_params();
    sparams.no_perf = true;
    struct llama_sampler * sampler = llama_sampler_chain_init(sparams);
    llama_sampler_chain_add(sampler, llama_sampler_init_temp(0.7f));
    llama_sampler_chain_add(sampler, llama_sampler_init_top_p(0.9f, 1));
    llama_sampler_chain_add(sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));

    // Allocate phoenix context
    phoenix_ctx * pctx = new phoenix_ctx();
    pctx->model     = model;
    pctx->ctx       = ctx;
    pctx->sampler   = sampler;
    pctx->batch     = llama_batch_init(512, 0, 1);
    pctx->n_cur     = 0;
    pctx->n_max     = 0;
    pctx->streaming = false;

    LOGI("bitnet_init: success");
    return pctx;
}

void bitnet_free(void * handle) {
    if (!handle) return;
    phoenix_ctx * pctx = (phoenix_ctx *)handle;

    llama_batch_free(pctx->batch);
    llama_sampler_free(pctx->sampler);
    llama_free(pctx->ctx);
    llama_model_free(pctx->model);
    llama_backend_free();

    delete pctx;
    LOGI("bitnet_free: done");
}

// --- Blocking generation ---

char * bitnet_generate(void * handle, const char * prompt, int max_tokens) {
    if (!handle || !prompt) return nullptr;
    phoenix_ctx * pctx = (phoenix_ctx *)handle;

    // Tokenize prompt
    const auto tokens = common_tokenize(pctx->ctx, prompt, true, true);
    const int n_prompt = (int)tokens.size();

    if (n_prompt < 1) {
        LOGE("bitnet_generate: empty prompt after tokenization");
        return nullptr;
    }

    LOGI("bitnet_generate: %d prompt tokens, max_tokens=%d", n_prompt, max_tokens);

    // Clear KV cache
    llama_memory_clear(llama_get_memory(pctx->ctx), true);

    // Evaluate prompt
    common_batch_clear(pctx->batch);
    for (int i = 0; i < n_prompt; i++) {
        common_batch_add(pctx->batch, tokens[i], i, { 0 }, false);
    }
    pctx->batch.logits[pctx->batch.n_tokens - 1] = true;

    if (llama_decode(pctx->ctx, pctx->batch) != 0) {
        LOGE("bitnet_generate: prompt decode failed");
        return nullptr;
    }

    // Generate tokens
    std::string result;
    int n_cur = n_prompt;

    for (int i = 0; i < max_tokens; i++) {
        llama_token new_token = llama_sampler_sample(pctx->sampler, pctx->ctx, -1);

        if (llama_vocab_is_eog(llama_model_get_vocab(pctx->model), new_token)) {
            break;
        }

        result += common_token_to_piece(pctx->ctx, new_token);

        // Prepare next decode
        common_batch_clear(pctx->batch);
        common_batch_add(pctx->batch, new_token, n_cur, { 0 }, true);
        n_cur++;

        if (llama_decode(pctx->ctx, pctx->batch) != 0) {
            LOGE("bitnet_generate: decode failed at token %d", i);
            break;
        }
    }

    LOGI("bitnet_generate: produced %d chars", (int)result.size());
    return strdup(result.c_str());
}

void bitnet_free_string(char * str) {
    free(str);
}

// --- Streaming generation ---

void bitnet_stream_start(void * handle, const char * prompt, int max_tokens) {
    if (!handle || !prompt) return;
    phoenix_ctx * pctx = (phoenix_ctx *)handle;

    const auto tokens = common_tokenize(pctx->ctx, prompt, true, true);
    const int n_prompt = (int)tokens.size();

    if (n_prompt < 1) {
        LOGE("bitnet_stream_start: empty prompt");
        pctx->streaming = false;
        return;
    }

    LOGI("bitnet_stream_start: %d prompt tokens, max=%d", n_prompt, max_tokens);

    // Clear KV cache
    llama_memory_clear(llama_get_memory(pctx->ctx), true);

    // Evaluate prompt
    common_batch_clear(pctx->batch);
    for (int i = 0; i < n_prompt; i++) {
        common_batch_add(pctx->batch, tokens[i], i, { 0 }, false);
    }
    pctx->batch.logits[pctx->batch.n_tokens - 1] = true;

    if (llama_decode(pctx->ctx, pctx->batch) != 0) {
        LOGE("bitnet_stream_start: prompt decode failed");
        pctx->streaming = false;
        return;
    }

    pctx->n_cur     = n_prompt;
    pctx->n_max     = n_prompt + max_tokens;
    pctx->streaming = true;
    pctx->cached_piece.clear();
}

char * bitnet_stream_next(void * handle) {
    if (!handle) return nullptr;
    phoenix_ctx * pctx = (phoenix_ctx *)handle;

    if (!pctx->streaming) return nullptr;

    // Sample next token
    llama_token new_token = llama_sampler_sample(pctx->sampler, pctx->ctx, -1);

    // Check end of generation
    if (llama_vocab_is_eog(llama_model_get_vocab(pctx->model), new_token) || pctx->n_cur >= pctx->n_max) {
        pctx->streaming = false;

        // Flush any remaining cached bytes
        if (!pctx->cached_piece.empty()) {
            char * out = strdup(pctx->cached_piece.c_str());
            pctx->cached_piece.clear();
            return out;
        }
        return nullptr;
    }

    // Convert token to text
    std::string piece = common_token_to_piece(pctx->ctx, new_token);
    pctx->cached_piece += piece;

    // Prepare next decode
    common_batch_clear(pctx->batch);
    common_batch_add(pctx->batch, new_token, pctx->n_cur, { 0 }, true);
    pctx->n_cur++;

    if (llama_decode(pctx->ctx, pctx->batch) != 0) {
        LOGE("bitnet_stream_next: decode failed");
        pctx->streaming = false;
        return nullptr;
    }

    // Only return valid UTF-8 — accumulate partial codepoints
    if (is_valid_utf8(pctx->cached_piece)) {
        char * out = strdup(pctx->cached_piece.c_str());
        pctx->cached_piece.clear();
        return out;
    }

    // Return empty string — partial codepoint buffered
    return strdup("");
}

int bitnet_stream_done(void * handle) {
    if (!handle) return 1;
    phoenix_ctx * pctx = (phoenix_ctx *)handle;
    return pctx->streaming ? 0 : 1;
}

} // extern "C"
