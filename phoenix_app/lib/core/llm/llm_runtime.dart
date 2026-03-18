import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'template_chat.dart';

// ─── FFI typedefs ────────────────────────────────────────────────

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

// ─── Abstract interface ──────────────────────────────────────────

/// Abstract interface for LLM runtimes.
/// If BitNet is replaced with another runtime, only this layer changes.
abstract class LlmRuntime {
  bool get isModelAvailable;
  Future<void> load();
  Future<void> unload();
  Future<String> infer(String prompt, {int maxTokens = 512});

  /// Streaming API — call streamStart, then iterate streamNext until streamDone.
  void streamStart(String prompt, {int maxTokens = 512});
  String? streamNext();
  bool streamDone();
}

// ─── Model path helper ───────────────────────────────────────────

const _modelFileName = 'Qwen3-1.7B-Q2_K.gguf';

Future<String> modelDirectoryPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/models';
}

Future<String> modelFilePath() async {
  final dirPath = await modelDirectoryPath();
  return '$dirPath/$_modelFileName';
}

Future<bool> isModelDownloaded() async {
  final path = await modelFilePath();
  return File(path).existsSync();
}

// ─── BitNet runtime (real FFI) ───────────────────────────────────

/// BitNet b1.58 2B4T runtime via dart:ffi → bitnet.cpp shared library.
class BitnetRuntime implements LlmRuntime {
  final String? modelPath;

  DynamicLibrary? _lib;
  Pointer<Void> _ctx = nullptr;
  bool _loaded = false;
  Completer<void>? _inferLock;

  // FFI function pointers
  BitnetInit? _init;
  BitnetGenerate? _generate;
  BitnetStreamStart? _streamStart;
  BitnetStreamNext? _streamNext;
  BitnetStreamDone? _streamDoneF;
  BitnetFree? _free;
  BitnetFreeString? _freeString;

  BitnetRuntime({this.modelPath});

  @override
  bool get isModelAvailable {
    if (modelPath != null) return File(modelPath!).existsSync();
    return false;
  }

  @override
  Future<void> load() async {
    if (_loaded) return;

    final path = modelPath ?? await modelFilePath();
    debugPrint('[BitnetRuntime] load: checking model at $path');

    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Model file not found: $path');
    }

    final fileSize = file.lengthSync();
    debugPrint('[BitnetRuntime] load: file size = ${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB');

    if (fileSize < 1024 * 1024) {
      throw StateError('Model file too small ($fileSize bytes) — likely incomplete');
    }

    // Load native library
    debugPrint('[BitnetRuntime] load: opening native library...');
    _lib = _openNativeLib();
    _bindFunctions();

    // Initialize context with model — this is a blocking FFI call
    debugPrint('[BitnetRuntime] load: calling bitnet_init (this may take 10-30s)...');
    final pathPtr = path.toNativeUtf8();
    try {
      _ctx = _init!(pathPtr);
      if (_ctx == nullptr) {
        throw StateError('bitnet_init returned null — model load failed');
      }
      _loaded = true;
      debugPrint('[BitnetRuntime] load: model loaded successfully');
    } finally {
      calloc.free(pathPtr);
    }
  }

  DynamicLibrary _openNativeLib() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libbitnet.so');
    } else if (Platform.isIOS) {
      // On iOS, the framework is statically linked
      return DynamicLibrary.process();
    } else {
      throw UnsupportedError(
          'BitNet runtime not supported on ${Platform.operatingSystem}');
    }
  }

  void _bindFunctions() {
    final lib = _lib!;
    try {
      _init = lib.lookupFunction<BitnetInitNative, BitnetInit>('bitnet_init');
      _generate = lib.lookupFunction<BitnetGenerateNative, BitnetGenerate>(
          'bitnet_generate');
      _streamStart =
          lib.lookupFunction<BitnetStreamStartNative, BitnetStreamStart>(
              'bitnet_stream_start');
      _streamNext =
          lib.lookupFunction<BitnetStreamNextNative, BitnetStreamNext>(
              'bitnet_stream_next');
      _streamDoneF =
          lib.lookupFunction<BitnetStreamDoneNative, BitnetStreamDone>(
              'bitnet_stream_done');
      _free = lib.lookupFunction<BitnetFreeNative, BitnetFree>('bitnet_free');
      _freeString =
          lib.lookupFunction<BitnetFreeStringNative, BitnetFreeString>(
              'bitnet_free_string');
    } catch (e) {
      debugPrint('[BitnetRuntime] _bindFunctions failed: native library incompatible');
      rethrow;
    }
  }

  @override
  Future<void> unload() async {
    if (!_loaded) return;
    if (_ctx != nullptr) {
      _free!(_ctx);
      _ctx = nullptr;
    }
    _loaded = false;
  }

  /// Maximum prompt size to prevent buffer overflow in native code (10 KB).
  static const _maxPromptBytes = 10 * 1024;

  /// Get the native context pointer address (for background isolate calls).
  int get ctxAddress => _ctx.address;
  bool get isLoaded => _loaded;

  @override
  Future<String> infer(String prompt, {int maxTokens = 512}) async {
    if (!_loaded || _ctx == nullptr) {
      throw StateError('Model not loaded or has been unloaded');
    }
    if (prompt.length > _maxPromptBytes) {
      debugPrint('[BitnetRuntime] Prompt truncated: ${prompt.length} > $_maxPromptBytes bytes');
      prompt = prompt.substring(0, _maxPromptBytes);
    }

    // Serialize FFI calls — llama_context is NOT thread-safe.
    // Wait for any previous inference to finish before starting a new one.
    while (_inferLock != null) {
      debugPrint('[BitnetRuntime] infer: waiting for previous inference to finish...');
      await _inferLock!.future;
    }
    _inferLock = Completer<void>();

    try {
      // Run FFI in a background isolate to avoid blocking the UI thread
      final result = await compute(_inferInBackground, {
        'ctx': _ctx.address,
        'prompt': prompt,
        'maxTokens': maxTokens,
      });
      return result;
    } finally {
      final lock = _inferLock;
      _inferLock = null;
      lock?.complete();
    }
  }

  /// Top-level function for compute() — runs FFI inference in a background isolate.
  /// DynamicLibrary.open() returns the same process-wide handle, so FFI works across isolates.
  static String _inferInBackground(Map<String, dynamic> args) {
    final ctxAddress = args['ctx'] as int;
    final prompt = args['prompt'] as String;
    final maxTokens = args['maxTokens'] as int;

    final lib = Platform.isAndroid
        ? DynamicLibrary.open('libbitnet.so')
        : DynamicLibrary.process();

    final generate = lib.lookupFunction<BitnetGenerateNative, BitnetGenerate>(
        'bitnet_generate');
    final freeString =
        lib.lookupFunction<BitnetFreeStringNative, BitnetFreeString>(
            'bitnet_free_string');

    final ctx = Pointer<Void>.fromAddress(ctxAddress);
    final promptPtr = prompt.toNativeUtf8();
    try {
      final resultPtr = generate(ctx, promptPtr, maxTokens);
      if (resultPtr == nullptr) return '';
      try {
        // Use allowMalformed to handle invalid UTF-8 from model output
        final len = _strlen(resultPtr.cast<Uint8>());
        final bytes = resultPtr.cast<Uint8>().asTypedList(len);
        return utf8.decode(bytes, allowMalformed: true);
      } catch (_) {
        return '';
      } finally {
        freeString(resultPtr);
      }
    } finally {
      calloc.free(promptPtr);
    }
  }

  /// Get C string length (strlen equivalent).
  static int _strlen(Pointer<Uint8> ptr) {
    var len = 0;
    while (ptr.elementAt(len).value != 0) {
      len++;
    }
    return len;
  }

  @override
  void streamStart(String prompt, {int maxTokens = 512}) {
    if (!_loaded || _ctx == nullptr) {
      throw StateError('Model not loaded or has been unloaded');
    }
    if (prompt.length > _maxPromptBytes) {
      debugPrint('[BitnetRuntime] Prompt truncated: ${prompt.length} > $_maxPromptBytes bytes');
      prompt = prompt.substring(0, _maxPromptBytes);
    }
    final promptPtr = prompt.toNativeUtf8();
    try {
      _streamStart!(_ctx, promptPtr, maxTokens);
    } finally {
      calloc.free(promptPtr);
    }
  }

  @override
  String? streamNext() {
    if (!_loaded || _ctx == nullptr) return null;
    final ptr = _streamNext!(_ctx);
    if (ptr == nullptr) return null;
    try {
      return ptr.toDartString();
    } finally {
      _freeString!(ptr);
    }
  }

  @override
  bool streamDone() {
    if (!_loaded || _ctx == nullptr) return true;
    return _streamDoneF!(_ctx) != 0;
  }
}

// ─── Template fallback runtime ───────────────────────────────────

/// Fallback runtime that uses TemplateChat for contextual responses
/// when LLM is unavailable (e.g., model not downloaded, or device too slow).
class TemplateFallbackRuntime implements LlmRuntime {
  TemplateChat? _chat;

  // Streaming state
  String _streamBuffer = '';
  int _streamPos = 0;
  bool _streamActive = false;

  TemplateFallbackRuntime({TemplateChat? chat}) : _chat = chat;

  void setChat(TemplateChat chat) => _chat = chat;

  @override
  bool get isModelAvailable => true; // Always available

  @override
  Future<void> load() async {}

  @override
  Future<void> unload() async {}

  @override
  Future<String> infer(String prompt, {int maxTokens = 512}) async {
    if (_chat == null) {
      return 'Coach attivo. Configura il sistema per risposte personalizzate.';
    }
    // Extract user message from the rendered prompt
    final userMessage = _extractUserMessage(prompt);
    return _chat!.respond(userMessage);
  }

  @override
  void streamStart(String prompt, {int maxTokens = 512}) {
    // Generate response synchronously won't work since respond() is async.
    // We'll buffer via a flag and fill in generateStream in LlmEngine.
    _streamBuffer = '';
    _streamPos = 0;
    _streamActive = true;
    // The actual async generation is handled by LlmEngine.generateStream()
    // which calls infer() then simulates streaming.
  }

  @override
  String? streamNext() {
    if (!_streamActive || _streamPos >= _streamBuffer.length) return null;
    final end = (_streamPos + 3).clamp(0, _streamBuffer.length);
    final chunk = _streamBuffer.substring(_streamPos, end);
    _streamPos = end;
    return chunk;
  }

  @override
  bool streamDone() {
    if (!_streamActive) return true;
    return _streamPos >= _streamBuffer.length;
  }

  /// Extract the user message from a rendered Qwen chat template prompt.
  static String _extractUserMessage(String prompt) {
    // Qwen format: <|im_start|>user\n...<|im_end|>
    final userBlock = RegExp(r'<\|im_start\|>user\n(.*?)<\|im_end\|>', dotAll: true);
    final match = userBlock.firstMatch(prompt);
    if (match != null) {
      // Get the last line (the actual user message, not context data)
      final content = match.group(1)?.trim() ?? prompt;
      final lines = content.split('\n');
      return lines.last.trim();
    }
    // Legacy fallback
    final utenteLine = RegExp(r'Utente:\s*(.+?)(?:\nCoach:|$)');
    final legacyMatch = utenteLine.firstMatch(prompt);
    if (legacyMatch != null) return legacyMatch.group(1)?.trim() ?? prompt;
    return prompt;
  }
}
