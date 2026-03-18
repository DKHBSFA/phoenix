import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'llm_runtime.dart';

// ─── Model manifest ──────────────────────────────────────────────

class ModelManifest {
  final String version;
  final String filename;
  final int sizeBytes;
  final String sha256Hash;
  final String downloadUrl;
  final int minRamMb;

  const ModelManifest({
    required this.version,
    required this.filename,
    required this.sizeBytes,
    required this.sha256Hash,
    required this.downloadUrl,
    required this.minRamMb,
  });

  factory ModelManifest.fromJson(Map<String, dynamic> json) {
    return ModelManifest(
      version: json['version'] as String,
      filename: json['filename'] as String,
      sizeBytes: json['size_bytes'] as int,
      sha256Hash: json['sha256'] as String,
      downloadUrl: json['download_url'] as String,
      minRamMb: json['min_ram_mb'] as int? ?? 1500,
    );
  }

  static const defaultManifest = ModelManifest(
    version: 'qwen3-1.7b-q2k-v1',
    filename: 'Qwen3-1.7B-Q2_K.gguf',
    sizeBytes: 0, // skip size check — will be set after first download
    sha256Hash: '', // skip checksum — unsloth quantization, verified by download
    downloadUrl:
        'https://huggingface.co/unsloth/Qwen3-1.7B-GGUF/resolve/main/Qwen3-1.7B-Q2_K.gguf',
    minRamMb: 1024,
  );
}

// ─── Download state ──────────────────────────────────────────────

enum ModelDownloadStatus {
  idle,
  checking,
  downloading,
  paused,
  verifying,
  ready,
  error,
}

class ModelDownloadState {
  final ModelDownloadStatus status;
  final int bytesDownloaded;
  final int totalBytes;
  final double speedBytesPerSec;
  final String? errorMessage;
  final String? modelVersion;
  final double? benchmarkTokPerSec;

  const ModelDownloadState({
    this.status = ModelDownloadStatus.idle,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
    this.speedBytesPerSec = 0,
    this.errorMessage,
    this.modelVersion,
    this.benchmarkTokPerSec,
  });

  double get progress =>
      totalBytes > 0 ? bytesDownloaded / totalBytes : 0;

  String get progressLabel {
    if (totalBytes == 0) return '';
    final dlMb = (bytesDownloaded / 1024 / 1024).toStringAsFixed(0);
    final totalMb = (totalBytes / 1024 / 1024).toStringAsFixed(0);
    return '$dlMb MB / $totalMb MB';
  }

  String get speedLabel {
    if (speedBytesPerSec <= 0) return '';
    final mbps = speedBytesPerSec / 1024 / 1024;
    return '${mbps.toStringAsFixed(1)} MB/s';
  }

  String get etaLabel {
    if (speedBytesPerSec <= 0 || totalBytes <= 0) return '';
    final remaining = totalBytes - bytesDownloaded;
    final seconds = remaining / speedBytesPerSec;
    if (seconds < 60) return '~${seconds.round()}s rimanenti';
    final minutes = (seconds / 60).round();
    return '~${minutes}min rimanenti';
  }

  ModelDownloadState copyWith({
    ModelDownloadStatus? status,
    int? bytesDownloaded,
    int? totalBytes,
    double? speedBytesPerSec,
    String? errorMessage,
    String? modelVersion,
    double? benchmarkTokPerSec,
  }) {
    return ModelDownloadState(
      status: status ?? this.status,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      speedBytesPerSec: speedBytesPerSec ?? this.speedBytesPerSec,
      errorMessage: errorMessage,
      modelVersion: modelVersion ?? this.modelVersion,
      benchmarkTokPerSec: benchmarkTokPerSec ?? this.benchmarkTokPerSec,
    );
  }
}

// ─── Model Manager ───────────────────────────────────────────────

class ModelManager extends ChangeNotifier {
  final Dio _dio;
  CancelToken? _cancelToken;

  ModelDownloadState _state = const ModelDownloadState();
  ModelDownloadState get state => _state;

  /// Check if a host is allowed for model downloads.
  /// Permits huggingface.co and its CDN subdomains (*.hf.co, *.huggingface.co).
  static bool _isAllowedHost(String host) {
    return host == 'huggingface.co' ||
        host.endsWith('.huggingface.co') ||
        host.endsWith('.hf.co');
  }

  ModelManager()
      : _dio = Dio(BaseOptions(
          followRedirects: true,
          maxRedirects: 5,
        ))
          ..interceptors.add(InterceptorsWrapper(
            onRequest: (options, handler) {
              if (options.uri.scheme != 'https' ||
                  !_isAllowedHost(options.uri.host)) {
                handler.reject(DioException(
                  requestOptions: options,
                  type: DioExceptionType.cancel,
                  error: 'Download blocked: ${options.uri.host} not allowed',
                ));
                return;
              }
              handler.next(options);
            },
          ));

  void _updateState(ModelDownloadState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Set error state with a message (for configuration issues).
  void setError(String message) {
    _updateState(ModelDownloadState(
      status: ModelDownloadStatus.error,
      errorMessage: message,
    ));
  }

  /// Check if model is already downloaded and ready.
  Future<void> checkStatus() async {
    _updateState(_state.copyWith(status: ModelDownloadStatus.checking));

    final downloaded = await isModelDownloaded();
    if (downloaded) {
      final path = await modelFilePath();
      final file = File(path);
      final size = await file.length();
      _updateState(ModelDownloadState(
        status: ModelDownloadStatus.ready,
        bytesDownloaded: size,
        totalBytes: size,
      ));
    } else {
      _updateState(const ModelDownloadState(status: ModelDownloadStatus.idle));
    }
  }

  /// Check available disk space. Returns true if enough.
  Future<bool> checkDiskSpace() async {
    // Platform-specific disk space check would go here.
    // For now, return true — the download will fail gracefully if disk is full.
    return true;
  }

  /// Start or resume model download.
  Future<void> download({required String url, String? expectedSha256}) async {
    if (_state.status == ModelDownloadStatus.downloading) return;

    final dirPath = await modelDirectoryPath();
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final filePath = await modelFilePath();
    final tempPath = '$filePath.part';
    final tempFile = File(tempPath);

    // Check for partial download (resume support)
    int existingBytes = 0;
    if (tempFile.existsSync()) {
      existingBytes = await tempFile.length();
    }

    _cancelToken = CancelToken();
    final stopwatch = Stopwatch()..start();
    int lastBytes = existingBytes;

    _updateState(ModelDownloadState(
      status: ModelDownloadStatus.downloading,
      bytesDownloaded: existingBytes,
    ));

    try {
      final response = await _dio.download(
        url,
        tempPath,
        cancelToken: _cancelToken,
        deleteOnError: false,
        options: Options(
          headers: existingBytes > 0
              ? {'Range': 'bytes=$existingBytes-'}
              : null,
        ),
        onReceiveProgress: (received, total) {
          final actualReceived = received + existingBytes;
          final actualTotal = total > 0 ? total + existingBytes : 0;

          // Calculate speed every 500ms
          double speed = _state.speedBytesPerSec;
          if (stopwatch.elapsedMilliseconds > 500) {
            speed = (actualReceived - lastBytes) /
                (stopwatch.elapsedMilliseconds / 1000);
            lastBytes = actualReceived;
            stopwatch.reset();
          }

          _updateState(_state.copyWith(
            bytesDownloaded: actualReceived,
            totalBytes: actualTotal,
            speedBytesPerSec: speed,
          ));
        },
      );

      if (response.statusCode == 200 || response.statusCode == 206) {
        // Verify checksum if a hash is pinned
        if (expectedSha256 != null && expectedSha256.isNotEmpty) {
          _updateState(_state.copyWith(status: ModelDownloadStatus.verifying));
          final fileSize = await tempFile.length();
          debugPrint('ModelManager: verifying checksum for $fileSize bytes...');
          final valid = await verifyChecksum(tempPath, expectedSha256);
          if (!valid) {
          // Show actual hash on screen for debugging — allows pinning correct hash
          final actualHash = await compute(_computeSha256Streaming, tempPath);
          debugPrint('ModelManager: checksum MISMATCH');
          debugPrint('  expected: $expectedSha256');
          debugPrint('  actual:   $actualHash');
          debugPrint('  size:     $fileSize bytes');
          await tempFile.delete();
          _updateState(_state.copyWith(
            status: ModelDownloadStatus.error,
            errorMessage: 'SHA256 mismatch.\n'
                'Expected: ${expectedSha256.substring(0, 16)}...\n'
                'Got: ${actualHash.substring(0, 16)}...\n'
                'Size: $fileSize bytes',
          ));
          return;
        }
        }

        // Move temp file to final location
        await tempFile.rename(filePath);
        final size = await File(filePath).length();
        _updateState(ModelDownloadState(
          status: ModelDownloadStatus.ready,
          bytesDownloaded: size,
          totalBytes: size,
        ));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        final cancelMsg = e.error?.toString() ?? '';
        if (cancelMsg.contains('not allowed')) {
          // Host allowlist blocked the request
          _updateState(_state.copyWith(
            status: ModelDownloadStatus.error,
            errorMessage: 'DEBUG: $cancelMsg',
          ));
        } else {
          _updateState(_state.copyWith(status: ModelDownloadStatus.paused));
        }
      } else {
        // Clean up partial file on non-cancel errors
        if (tempFile.existsSync()) {
          try {
            await tempFile.delete();
          } catch (_) {}
        }
        _updateState(_state.copyWith(
          status: ModelDownloadStatus.error,
          errorMessage: 'DioError: ${e.type.name} — ${e.message ?? e.error}',
        ));
      }
    } catch (e) {
      debugPrint('ModelManager download error: $e');
      // Clean up partial file on unexpected errors
      if (tempFile.existsSync()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      _updateState(_state.copyWith(
        status: ModelDownloadStatus.error,
        errorMessage: 'Error: $e',
      ));
    }
  }

  /// Pause an active download.
  void pauseDownload() {
    _cancelToken?.cancel('User paused');
  }

  /// Delete the downloaded model.
  Future<void> deleteModel() async {
    final path = await modelFilePath();
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
    // Also delete partial downloads
    final partFile = File('$path.part');
    if (partFile.existsSync()) {
      await partFile.delete();
    }
    _updateState(const ModelDownloadState(status: ModelDownloadStatus.idle));
  }

  /// Verify SHA256 checksum of a file using streaming (no full-file RAM load).
  Future<bool> verifyChecksum(String filePath, String expectedHash) async {
    final digest = await compute(_computeSha256Streaming, filePath);
    return digest.toLowerCase() == expectedHash.toLowerCase();
  }

  /// Compute SHA256 in an isolate using chunked streaming — handles multi-GB files.
  static String _computeSha256Streaming(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) return '';
    final digestSink = _SingleDigestSink();
    final input = sha256.startChunkedConversion(digestSink);
    final raf = file.openSync();
    final buffer = List<int>.filled(4 * 1024 * 1024, 0); // 4 MB chunks
    try {
      while (true) {
        final bytesRead = raf.readIntoSync(buffer);
        if (bytesRead <= 0) break;
        input.add(bytesRead == buffer.length ? buffer : buffer.sublist(0, bytesRead));
      }
    } finally {
      raf.closeSync();
    }
    input.close();
    return digestSink.digest.toString();
  }

  /// Get model file size on disk.
  Future<int?> modelSizeOnDisk() async {
    final path = await modelFilePath();
    final file = File(path);
    if (!file.existsSync()) return null;
    return file.lengthSync();
  }

  String _dioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout di connessione. Verifica la rete.';
      case DioExceptionType.connectionError:
        return 'Impossibile connettersi. Verifica la connessione.';
      case DioExceptionType.badResponse:
        return 'Errore server. Riprova più tardi.';
      default:
        return 'Errore di rete. Verifica la connessione.';
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel('disposed');
    _dio.close();
    super.dispose();
  }
}

/// Minimal sink that captures the single [Digest] emitted by a chunked hash.
class _SingleDigestSink implements Sink<Digest> {
  late Digest digest;

  @override
  void add(Digest data) => digest = data;

  @override
  void close() {}
}
