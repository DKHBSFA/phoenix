import 'dart:math';

/// Recovery status combining Plews RMSSD framework + Bayevsky SI + Shlyk Type IV
enum RecoveryStatus {
  veryLow, // >1 SD below -> deload/rest
  low, // 0.5-1 SD below -> reduce volume 20%
  prenosological, // Bayevsky: SI elevated but RMSSD ok -> early warning
  normal, // Within +/-0.5 SD -> train as planned
  high, // >0.5 SD above -> good recovery
  suspiciouslyHigh, // Shlyk Type IV: >2 SD above -> possible dysregulation
}

/// A single HRV reading
class HrvReading {
  final int? id;
  final DateTime timestamp;
  final double rmssd; // Raw RMSSD in ms
  final double lnRmssd; // Natural log transform
  final double? stressIndex; // Bayevsky SI
  final String source; // 'apple_watch' / 'garmin' / 'oura' / 'manual'
  final String context; // 'morning' / 'post_workout' / 'sleep'

  HrvReading({
    this.id,
    required this.timestamp,
    required this.rmssd,
    double? lnRmssd,
    this.stressIndex,
    required this.source,
    this.context = 'morning',
  }) : lnRmssd = lnRmssd ?? log(rmssd);
}

/// Computed HRV baseline from readings
class HrvBaseline {
  final double mean7Day; // 7-day rolling average LnRMSSD
  final double sd7Day; // 7-day rolling SD
  final double mean14Day; // 14-day baseline mean
  final double sd14Day; // 14-day baseline SD
  final int readingsCount; // Total readings (need >=14 for baseline)

  const HrvBaseline({
    required this.mean7Day,
    required this.sd7Day,
    required this.mean14Day,
    required this.sd14Day,
    required this.readingsCount,
  });

  bool get isEstablished => readingsCount >= 14;

  /// SWC = 0.5 x SD (Smallest Worthwhile Change, Plews 2014)
  double get swc => sd14Day * 0.5;

  /// Recovery status from today's reading
  /// Combines: Plews RMSSD framework + Bayevsky SI prenosological + Shlyk Type IV
  RecoveryStatus statusFor(double todayLnRmssd, {double? stressIndex}) {
    if (!isEstablished) return RecoveryStatus.normal;

    final delta = todayLnRmssd - mean7Day;

    // Bayevsky 4-state: SI elevated but RMSSD still normal -> prenosological warning
    if (stressIndex != null && stressIndex > 300) return RecoveryStatus.veryLow;
    if (stressIndex != null && stressIndex > 150 && delta >= -swc) {
      return RecoveryStatus.prenosological;
    }

    // Shlyk Type IV: very high HRV may indicate dysregulation, not recovery
    if (delta > sd14Day * 2) return RecoveryStatus.suspiciouslyHigh;

    if (delta < -sd14Day) return RecoveryStatus.veryLow;
    if (delta < -swc) return RecoveryStatus.low;
    if (delta > swc) return RecoveryStatus.high;
    return RecoveryStatus.normal;
  }
}

/// Recovery recommendation for training adaptation
class RecoveryRecommendation {
  final RecoveryStatus status;
  final double volumeMultiplier; // 1.0 normal, 0.8 low, 0.5 very low
  final bool suggestDeload;
  final String coachMessage;
  final int consecutiveLowDays; // days in a row below baseline

  const RecoveryRecommendation({
    required this.status,
    required this.volumeMultiplier,
    required this.suggestDeload,
    required this.coachMessage,
    this.consecutiveLowDays = 0,
  });
}

/// HRV trend data for charts
class HrvTrend {
  final List<HrvReading> readings;
  final double? baselineMean;
  final double? baselineSd;

  const HrvTrend({
    required this.readings,
    this.baselineMean,
    this.baselineSd,
  });
}

/// Static utility class for HRV analysis
class HrvAnalysis {
  HrvAnalysis._();

  /// Compute baseline from a list of readings (most recent first)
  static HrvBaseline computeBaseline(List<HrvReading> readings) {
    if (readings.isEmpty) {
      return const HrvBaseline(
        mean7Day: 0,
        sd7Day: 0,
        mean14Day: 0,
        sd14Day: 0,
        readingsCount: 0,
      );
    }

    // Take up to 14 readings for baseline, up to 7 for rolling
    final last14 = readings.length > 14 ? readings.sublist(0, 14) : readings;
    final last7 = readings.length > 7 ? readings.sublist(0, 7) : readings;

    final values14 = last14.map((r) => r.lnRmssd).toList();
    final values7 = last7.map((r) => r.lnRmssd).toList();

    return HrvBaseline(
      mean7Day: _mean(values7),
      sd7Day: _sd(values7),
      mean14Day: _mean(values14),
      sd14Day: _sd(values14),
      readingsCount: readings.length,
    );
  }

  /// Compute recovery recommendation
  static RecoveryRecommendation recommend({
    required HrvBaseline baseline,
    required double todayLnRmssd,
    double? stressIndex,
    required int consecutiveLowDays,
  }) {
    final status =
        baseline.statusFor(todayLnRmssd, stressIndex: stressIndex);

    final (multiplier, deload, message) = switch (status) {
      RecoveryStatus.veryLow => (
        0.5,
        true,
        'HRV molto sotto la baseline. Riposo attivo o deload consigliato.',
      ),
      RecoveryStatus.low => (
        0.8,
        consecutiveLowDays >= 3,
        'HRV sotto la baseline. Volume ridotto del 20% oggi.',
      ),
      RecoveryStatus.prenosological => (
        0.85,
        false,
        'Indice di stress elevato. Il corpo sta compensando \u2014 monitora i prossimi giorni.',
      ),
      RecoveryStatus.normal => (
        1.0,
        false,
        'Recovery nella norma. Allenamento come da programma.',
      ),
      RecoveryStatus.high => (
        1.0,
        false,
        'Ottimo recupero! Il corpo risponde bene.',
      ),
      RecoveryStatus.suspiciouslyHigh => (
        0.9,
        false,
        'HRV insolitamente alto. Possibile disregolazione \u2014 osserva i prossimi giorni.',
      ),
    };

    return RecoveryRecommendation(
      status: status,
      volumeMultiplier: multiplier,
      suggestDeload: deload,
      coachMessage: message,
      consecutiveLowDays: consecutiveLowDays,
    );
  }

  /// Count consecutive days with LnRMSSD below baseline - SWC
  static int countConsecutiveLowDays(
    List<HrvReading> readings,
    HrvBaseline baseline,
  ) {
    if (!baseline.isEstablished || readings.isEmpty) return 0;

    final threshold = baseline.mean7Day - baseline.swc;
    int count = 0;

    // readings should be most recent first — count from today backwards
    for (final reading in readings) {
      if (reading.lnRmssd < threshold) {
        count++;
      } else {
        break;
      }
    }

    return count;
  }

  static double _mean(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double _sd(List<double> values) {
    if (values.length < 2) return 0;
    final m = _mean(values);
    final sumSquares =
        values.map((v) => (v - m) * (v - m)).reduce((a, b) => a + b);
    return sqrt(sumSquares / (values.length - 1));
  }
}
