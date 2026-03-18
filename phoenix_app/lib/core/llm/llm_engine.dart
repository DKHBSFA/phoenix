import 'dart:async';

import 'package:flutter/foundation.dart';

import 'llm_runtime.dart';
import 'prompt_templates.dart';
import 'template_chat.dart';

enum LlmStatus { unloaded, loading, ready, generating, error }

class LlmEngine extends ChangeNotifier {
  LlmRuntime _runtime;
  LlmStatus _status = LlmStatus.unloaded;
  double _lastTokPerSec = 0;
  bool _isLlmRuntime = false;
  Timer? _inactivityTimer;

  static const _inactivityTimeout = Duration(minutes: 5);
  static const _minTokPerSec = 0.3;

  LlmEngine({LlmRuntime? runtime})
      : _runtime = runtime ?? TemplateFallbackRuntime();

  LlmStatus get status => _status;
  bool get isReady => _status == LlmStatus.ready;
  bool get isLlmAvailable => _isLlmRuntime;
  double get tokPerSec => _lastTokPerSec;

  bool get isModelDownloaded {
    // Quick sync check — the real async check is via ModelManager
    return _runtime.isModelAvailable;
  }

  /// Set status to ready if currently unloaded (for template-only mode).
  void setReadyIfUnloaded() {
    if (_status == LlmStatus.unloaded) {
      _status = LlmStatus.ready;
      notifyListeners();
    }
  }

  /// Attempt to initialize the best available runtime.
  /// If a model file exists and benchmarks ≥3 tok/s, use BitnetRuntime.
  /// Otherwise, fall back to templates with TemplateChat.
  ///
  /// Has a 90-second timeout — if model loading takes longer, falls back to templates.
  Future<void> initBestRuntime({TemplateChat? templateChat}) async {
    final downloaded = await isModelDownloaded2();
    if (!downloaded) {
      debugPrint('[LlmEngine] initBestRuntime: model not downloaded, using template fallback');
      _runtime = TemplateFallbackRuntime(chat: templateChat);
      _isLlmRuntime = false;
      _status = LlmStatus.ready;
      notifyListeners();
      return;
    }

    final path = await modelFilePath();
    final bitnet = BitnetRuntime(modelPath: path);
    try {
      _status = LlmStatus.loading;
      notifyListeners();

      debugPrint('[LlmEngine] initBestRuntime: loading model with 90s timeout...');

      // Timeout: if FFI load takes >90s, it's stuck — fall back to templates.
      // Note: the FFI call blocks the thread, so the timeout only works if
      // the native code returns (even with error). If it truly hangs,
      // the timeout won't fire — but the mmap fix should prevent hangs.
      await bitnet.load().timeout(
        const Duration(seconds: 90),
        onTimeout: () {
          debugPrint('[LlmEngine] initBestRuntime: TIMEOUT loading model');
          throw TimeoutException('Model loading timed out after 90s');
        },
      );

      debugPrint('[LlmEngine] initBestRuntime: model loaded, benchmarking...');

      // Benchmark: generate 20 tokens and measure speed.
      // Use proper chat template to avoid garbage output from raw text.
      // IMPORTANT: Do NOT use .timeout() — it doesn't cancel compute().
      // The FFI call will complete eventually; just await it fully.
      final benchPrompt = '<|im_start|>user\n/no_think\nCiao<|im_end|>\n<|im_start|>assistant\n';
      final sw = Stopwatch()..start();
      final benchResult = await bitnet.infer(benchPrompt, maxTokens: 20);
      sw.stop();
      final elapsed = sw.elapsedMilliseconds;
      _lastTokPerSec = elapsed > 0 ? 20 / (elapsed / 1000) : 0;
      debugPrint('[LlmEngine] initBestRuntime: benchmark = ${_lastTokPerSec.toStringAsFixed(1)} tok/s (${elapsed}ms, result=${benchResult.length} chars)');

      if (_lastTokPerSec < _minTokPerSec) {
        debugPrint('[LlmEngine] initBestRuntime: too slow, falling back to templates');
        await bitnet.unload();
        _runtime = TemplateFallbackRuntime(chat: templateChat);
        _isLlmRuntime = false;
      } else {
        _runtime = bitnet;
        _isLlmRuntime = true;
        debugPrint('[LlmEngine] initBestRuntime: BitNet runtime active');
      }
      _status = LlmStatus.ready;
    } catch (e) {
      debugPrint('[LlmEngine] initBestRuntime: error — $e, falling back to templates');
      try { await bitnet.unload(); } catch (e) { debugPrint('LLM unload error: $e'); }
      _runtime = TemplateFallbackRuntime(chat: templateChat);
      _isLlmRuntime = false;
      _status = LlmStatus.ready;
    }
    notifyListeners();
  }

  /// Async check if model file exists on disk.
  Future<bool> isModelDownloaded2() async {
    return await isModelDownloaded_();
  }

  Future<void> loadModel() async {
    if (_status == LlmStatus.ready || _status == LlmStatus.loading) return;
    _status = LlmStatus.loading;
    notifyListeners();
    try {
      await _runtime.load();
      _status = LlmStatus.ready;
    } catch (e) {
      _status = LlmStatus.error;
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }

  Future<void> unloadModel() async {
    _inactivityTimer?.cancel();
    if (_status == LlmStatus.unloaded) return;
    await _runtime.unload();
    _status = LlmStatus.unloaded;
    _isLlmRuntime = false;
    notifyListeners();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    if (_isLlmRuntime) {
      _inactivityTimer = Timer(_inactivityTimeout, () {
        unloadModel();
      });
    }
  }

  /// One-shot generation (full result returned at once).
  Future<String> generate({
    required PromptTemplate template,
    required Map<String, dynamic> context,
    int maxTokens = 512,
  }) async {
    if (_status != LlmStatus.ready) {
      await loadModel();
    }

    _status = LlmStatus.generating;
    notifyListeners();
    try {
      final prompt = template.render(context);
      var result = await _runtime.infer(prompt, maxTokens: maxTokens);
      // Strip Qwen3 thinking tokens if present
      if (_isLlmRuntime) result = stripThinkingTokens(result);
      _status = LlmStatus.ready;
      _resetInactivityTimer();
      notifyListeners();
      return result;
    } catch (e) {
      _status = LlmStatus.ready;
      notifyListeners();
      rethrow;
    }
  }

  /// Streaming generation — yields tokens as they appear.
  /// For LLM runtime: generates full response in background isolate (no ANR),
  /// then yields chunks to simulate streaming.
  /// For TemplateFallback: generates and yields character by character.
  Stream<String> generateStream({
    required PromptTemplate template,
    required Map<String, dynamic> context,
    int maxTokens = 512,
  }) async* {
    if (_status != LlmStatus.ready) {
      await loadModel();
    }

    _status = LlmStatus.generating;
    notifyListeners();

    try {
      final prompt = template.render(context);

      // Both paths now use infer() which runs in a background isolate for
      // BitnetRuntime (via compute()), keeping UI responsive.
      var result = await _runtime.infer(prompt, maxTokens: maxTokens);
      // Strip Qwen3 thinking tokens if present
      if (_isLlmRuntime) result = stripThinkingTokens(result);

      // Simulate streaming for consistent UX — yield in small chunks
      const chunkSize = 3;
      for (var i = 0; i < result.length; i += chunkSize) {
        final end = (i + chunkSize).clamp(0, result.length);
        yield result.substring(i, end);
        await Future.delayed(const Duration(milliseconds: 20));
      }
    } finally {
      _status = LlmStatus.ready;
      _resetInactivityTimer();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _runtime.unload();
    super.dispose();
  }
}

/// Async model downloaded check (uses path_provider).
Future<bool> isModelDownloaded_() => isModelDownloaded();
