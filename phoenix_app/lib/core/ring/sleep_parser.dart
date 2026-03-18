import 'ring_protocol.dart';

/// Sleep stage types from ring.
enum SleepStage {
  light,
  deep,
  rem,
  awake;

  static SleepStage fromRingValue(int value) {
    return switch (value) {
      0x01 => SleepStage.light,
      0x02 => SleepStage.deep,
      0x03 => SleepStage.rem,
      0x04 => SleepStage.awake,
      _ => SleepStage.awake,
    };
  }

  static SleepStage fromLabel(String label) {
    return switch (label) {
      'light' => SleepStage.light,
      'deep' => SleepStage.deep,
      'rem' => SleepStage.rem,
      _ => SleepStage.awake,
    };
  }

  String get label => switch (this) {
        SleepStage.light => 'light',
        SleepStage.deep => 'deep',
        SleepStage.rem => 'rem',
        SleepStage.awake => 'awake',
      };
}

/// A single sleep period (stage + time range).
class SleepPeriod {
  final SleepStage stage;
  final DateTime start;
  final DateTime end;

  const SleepPeriod({
    required this.stage,
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);
}

/// Complete sleep session for one night.
class SleepSession {
  final DateTime nightDate;
  final List<SleepPeriod> stages;

  const SleepSession({required this.nightDate, required this.stages});

  Duration get timeInBed {
    if (stages.isEmpty) return Duration.zero;
    return stages.fold(Duration.zero, (sum, s) => sum + s.duration);
  }

  Duration get totalSleep => _sumStages([SleepStage.light, SleepStage.deep, SleepStage.rem]);
  Duration get deep => _sumStages([SleepStage.deep]);
  Duration get light => _sumStages([SleepStage.light]);
  Duration get rem => _sumStages([SleepStage.rem]);
  Duration get awake => _sumStages([SleepStage.awake]);

  double get efficiency {
    if (timeInBed.inSeconds == 0) return 0.0;
    return totalSleep.inSeconds / timeInBed.inSeconds;
  }

  Duration _sumStages(List<SleepStage> types) {
    return stages
        .where((s) => types.contains(s.stage))
        .fold(Duration.zero, (sum, s) => sum + s.duration);
  }
}

/// Stateful multi-packet parser for sleep sync (cmd 0x44).
///
/// Clean-room implementation based on publicly documented Colmi protocol.
class SleepDataParser {
  final List<SleepPeriod> _stages = [];
  DateTime? _nightDate;
  int _expectedPackets = 0;
  int _receivedPackets = 0;

  /// Feed a packet. Returns [SleepSession] when complete, null otherwise.
  SleepSession? parse(List<int> packet) {
    if (packet.length != 16) return null;

    final subType = packet[1];

    // No data response
    if (subType == 0xFF) {
      return SleepSession(
        nightDate: DateTime.now(),
        stages: const [],
      );
    }

    // Header packet (subType == 0)
    if (subType == 0) {
      _nightDate = DateTime(
        bcdToDecimal(packet[2]) + 2000,
        bcdToDecimal(packet[3]),
        bcdToDecimal(packet[4]),
      );
      _expectedPackets = packet[5];
      _receivedPackets = 0;
      _stages.clear();
      if (_expectedPackets == 0) {
        return SleepSession(nightDate: _nightDate!, stages: const []);
      }
      return null;
    }

    // Data packet
    _receivedPackets++;

    for (var i = 2; i + 4 < 15; i += 5) {
      final stageType = packet[i];
      if (stageType == 0) break;

      final startHour = packet[i + 1];
      final startMin = packet[i + 2];
      final endHour = packet[i + 3];
      final endMin = packet[i + 4];

      if (_nightDate == null) continue;

      var startDate = DateTime(
        _nightDate!.year, _nightDate!.month, _nightDate!.day,
        startHour, startMin,
      );
      var endDate = DateTime(
        _nightDate!.year, _nightDate!.month, _nightDate!.day,
        endHour, endMin,
      );

      if (startHour < 18) {
        startDate = startDate.add(const Duration(days: 1));
      }
      if (endHour < 18) {
        endDate = endDate.add(const Duration(days: 1));
      }

      _stages.add(SleepPeriod(
        stage: SleepStage.fromRingValue(stageType),
        start: startDate,
        end: endDate,
      ));
    }

    if (_receivedPackets >= _expectedPackets) {
      final session = SleepSession(
        nightDate: _nightDate!,
        stages: List.from(_stages),
      );
      _reset();
      return session;
    }

    return null;
  }

  void _reset() {
    _stages.clear();
    _nightDate = null;
    _expectedPackets = 0;
    _receivedPackets = 0;
  }
}
