import 'sleep_parser.dart';

/// Computed sleep summary from ring data.
class SleepSummary {
  final Duration timeInBed;
  final Duration totalSleep;
  final Duration deep;
  final Duration light;
  final Duration rem;
  final Duration awake;
  final double efficiency;
  final int? hrMin;
  final int? hrAvg;
  final double? tempDelta;
  final double? rmssd;
  final String qualityLabel;

  const SleepSummary({
    required this.timeInBed,
    required this.totalSleep,
    required this.deep,
    required this.light,
    required this.rem,
    required this.awake,
    required this.efficiency,
    this.hrMin,
    this.hrAvg,
    this.tempDelta,
    this.rmssd,
    required this.qualityLabel,
  });

  factory SleepSummary.fromSession(
    SleepSession session, {
    int? hrMin,
    int? hrAvg,
    double? tempDelta,
    double? rmssd,
  }) {
    final totalSleep = session.totalSleep;
    final timeInBed = session.timeInBed;
    final deep = session.deep;
    final rem = session.rem;
    final efficiency = session.efficiency;

    final deepPct = timeInBed.inSeconds > 0 ? deep.inSeconds / timeInBed.inSeconds : 0.0;
    final remPct = timeInBed.inSeconds > 0 ? rem.inSeconds / timeInBed.inSeconds : 0.0;

    String quality;
    if (deepPct >= 0.20 && efficiency >= 0.85 && remPct >= 0.20) {
      quality = 'Ottimo';
    } else if (deepPct >= 0.15 && efficiency >= 0.75) {
      quality = 'Buono';
    } else {
      quality = 'Scarso';
    }

    return SleepSummary(
      timeInBed: timeInBed,
      totalSleep: totalSleep,
      deep: deep,
      light: session.light,
      rem: rem,
      awake: session.awake,
      efficiency: efficiency,
      hrMin: hrMin,
      hrAvg: hrAvg,
      tempDelta: tempDelta,
      rmssd: rmssd,
      qualityLabel: quality,
    );
  }

  String get totalSleepFormatted {
    final h = totalSleep.inHours;
    final m = totalSleep.inMinutes % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  String get notificationTitle =>
      'Sonno: $totalSleepFormatted — $qualityLabel';

  String get notificationBody {
    final deepF = '${deep.inHours}h ${(deep.inMinutes % 60).toString().padLeft(2, '0')}m';
    final remF = '${rem.inHours}h ${(rem.inMinutes % 60).toString().padLeft(2, '0')}m';
    var body = 'Deep $deepF · REM $remF';
    if (hrAvg != null) body += ' · HR $hrAvg';
    return body;
  }
}
