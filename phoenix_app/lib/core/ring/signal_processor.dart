import 'dart:math' as math;

/// Signal processing pipeline for ring sensor data.
///
/// Levels:
/// 1. Validation — range checks, always active
/// 2. SQI — signal quality assessment for real-time data
/// 3. Smoothing/outlier — statistical filtering
/// 4. IBI derivation — HR, HRV (RMSSD), Stress Index from inter-beat intervals
///
/// Raw PPG pipeline (NLMS, AMPD) is gated on R10 support verification.
class SignalProcessor {
  /// SQI threshold — readings below this are discarded. Configurable.
  double sqiThreshold;

  SignalProcessor({this.sqiThreshold = 0.5});

  // ── Level 1: Validation ─────────────────────────────────────

  bool isValidHr(int bpm) => bpm >= 30 && bpm <= 220;
  bool isValidSpO2(int spo2) => spo2 >= 70 && spo2 <= 100;
  bool isValidTemp(double temp) => temp >= 30.0 && temp <= 42.0;

  /// Outlier detection: value > 2 SD from window mean.
  bool isOutlier(int value, List<int> window) {
    if (window.length < 2) return false;
    final mean = window.reduce((a, b) => a + b) / window.length;
    final variance =
        window.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
            window.length;
    final sd = math.sqrt(variance);
    return (value - mean).abs() > 2 * sd;
  }

  // ── Level 2: SQI (Signal Quality Index) ─────────────────────

  /// Assess signal quality from a window of readings.
  /// Returns 0.0 (discard) to 1.0 (reliable).
  double assessSignalQuality(List<int> readings) {
    if (readings.length < 5) return 0.0;

    // Check for stuck sensor (3+ identical consecutive readings)
    int stuckCount = 0;
    for (var i = 1; i < readings.length; i++) {
      if (readings[i] == readings[i - 1]) {
        stuckCount++;
      }
    }
    final stuckRatio = stuckCount / (readings.length - 1);
    if (stuckRatio > 0.5) return 0.1; // Likely stuck

    // Check for wild jumps (delta > 40 between consecutive)
    int jumpCount = 0;
    for (var i = 1; i < readings.length; i++) {
      if ((readings[i] - readings[i - 1]).abs() > 40) {
        jumpCount++;
      }
    }
    final jumpRatio = jumpCount / (readings.length - 1);

    // Check physiological range
    final inRange = readings.where((r) => r >= 30 && r <= 220).length;
    final rangeRatio = inRange / readings.length;

    // Compute coefficient of variation (CV)
    final mean = readings.reduce((a, b) => a + b) / readings.length;
    final variance =
        readings.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
            readings.length;
    final cv = math.sqrt(variance) / mean;

    // SQI: penalize stuck, jumps, out-of-range, high CV
    double sqi = 1.0;
    sqi -= stuckRatio * 0.5;
    sqi -= jumpRatio * 0.4;
    sqi -= (1 - rangeRatio) * 0.3;
    if (cv > 0.3) {
      sqi -= 0.3;
    } else if (cv > 0.15) {
      sqi -= 0.1;
    }

    return sqi.clamp(0.0, 1.0);
  }

  // ── Level 3: Smoothing ──────────────────────────────────────

  /// Moving average smoothing.
  List<double> smooth(List<int> values, {int window = 5}) {
    if (values.length <= window) {
      final avg = values.reduce((a, b) => a + b) / values.length;
      return List.filled(values.length, avg);
    }
    final result = <double>[];
    for (var i = 0; i < values.length; i++) {
      final start = math.max(0, i - window ~/ 2);
      final end = math.min(values.length, i + window ~/ 2 + 1);
      final slice = values.sublist(start, end);
      result.add(slice.reduce((a, b) => a + b) / slice.length);
    }
    return result;
  }

  /// Filter HR log: remove invalid + outliers, smooth.
  List<int> filterHrLog(List<int> rawHr) {
    final valid = rawHr.map((hr) => isValidHr(hr) ? hr : 0).toList();
    final nonZero = valid.where((v) => v > 0).toList();
    if (nonZero.length < 3) return valid;

    final result = <int>[];
    for (var i = 0; i < valid.length; i++) {
      if (valid[i] == 0) {
        result.add(0);
      } else {
        final windowStart = math.max(0, i - 5);
        final windowEnd = math.min(valid.length, i + 6);
        final window =
            valid.sublist(windowStart, windowEnd).where((v) => v > 0).toList();
        result.add(isOutlier(valid[i], window) ? 0 : valid[i]);
      }
    }
    return result;
  }

  // ── Level 4: IBI Derivation ─────────────────────────────────

  /// Compute heart rate (BPM) from inter-beat intervals (ms).
  int computeHr(List<int> ibi) {
    if (ibi.isEmpty) return 0;
    final avgIbi = ibi.reduce((a, b) => a + b) / ibi.length;
    return (60000 / avgIbi).round();
  }

  /// Compute RMSSD (ms) from IBI — standard HRV metric.
  double computeRmssd(List<int> ibi) {
    if (ibi.length < 2) return 0.0;
    double sumSquaredDiffs = 0;
    for (var i = 1; i < ibi.length; i++) {
      final diff = (ibi[i] - ibi[i - 1]).toDouble();
      sumSquaredDiffs += diff * diff;
    }
    return math.sqrt(sumSquaredDiffs / (ibi.length - 1));
  }

  /// Compute Bayevsky Stress Index from IBI.
  /// SI = AMo / (2 * Mo * MxDMn)
  double computeStressIndex(List<int> ibi) {
    if (ibi.length < 5) return 0.0;

    final minIbi = ibi.reduce(math.min);
    final maxIbi = ibi.reduce(math.max);
    final mxDMn = (maxIbi - minIbi).toDouble();
    if (mxDMn == 0) return 0.0;

    const binSize = 50;
    final bins = <int, int>{};
    for (final v in ibi) {
      final bin = (v ~/ binSize) * binSize;
      bins[bin] = (bins[bin] ?? 0) + 1;
    }

    var maxCount = 0;
    var modeBin = 0;
    for (final entry in bins.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        modeBin = entry.key;
      }
    }

    final amo = maxCount / ibi.length * 100;
    final mo = modeBin + binSize / 2;
    if (mo == 0) return 0.0;

    return amo / (2 * mo / 1000 * mxDMn / 1000);
  }
}
