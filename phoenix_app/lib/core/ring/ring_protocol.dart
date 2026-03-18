/// Colmi R10 Smart Ring — packet encoding/decoding and command parsers.
///
/// All communication uses 16-byte packets:
///   byte[0]  = command
///   byte[1-14] = payload
///   byte[15] = checksum (sum of bytes 0..14 & 0xFF)
///
/// Ported from tahnok/colmi_r02_client (Python, MIT).
library;

import 'dart:typed_data';

import 'ring_constants.dart';

// ═══════════════════════════════════════════════════════════════════
// PACKET BUILD / VALIDATE
// ═══════════════════════════════════════════════════════════════════

/// Build a 16-byte command packet.
///
/// [command] goes in byte[0], optional [subData] fills bytes 1+.
Uint8List makePacket(int command, [List<int>? subData]) {
  assert(command >= 0 && command <= 255);
  assert(subData == null || subData.length <= 14);

  final packet = Uint8List(kPacketLength);
  packet[0] = command;

  if (subData != null) {
    for (var i = 0; i < subData.length; i++) {
      packet[i + 1] = subData[i];
    }
  }

  packet[kPacketLength - 1] = _checksum(packet);
  return packet;
}

/// Verify a received packet's checksum. Returns false if invalid.
bool verifyPacket(List<int> packet) {
  if (packet.length != kPacketLength) return false;
  return packet[kPacketLength - 1] == _checksum(packet);
}

int _checksum(List<int> packet) {
  var sum = 0;
  for (var i = 0; i < kPacketLength - 1; i++) {
    sum += packet[i];
  }
  return sum & 0xFF;
}

// ═══════════════════════════════════════════════════════════════════
// BCD ENCODING (used for time/date fields)
// ═══════════════════════════════════════════════════════════════════

/// Convert integer (0-99) to BCD byte.
int byteToBcd(int b) {
  assert(b >= 0 && b < 100);
  return ((b ~/ 10) << 4) | (b % 10);
}

/// Convert BCD byte back to integer.
int bcdToDecimal(int b) {
  return (((b >> 4) & 0x0F) * 10) + (b & 0x0F);
}

// ═══════════════════════════════════════════════════════════════════
// COMMAND PACKETS
// ═══════════════════════════════════════════════════════════════════

/// Build set-time packet (BCD-encoded UTC time).
/// Response contains capability flags — parse with [RingCapabilities.fromPacket].
Uint8List setTimePacket(DateTime utc) {
  final data = <int>[
    byteToBcd(utc.year % 100),
    byteToBcd(utc.month),
    byteToBcd(utc.day),
    byteToBcd(utc.hour),
    byteToBcd(utc.minute),
    byteToBcd(utc.second),
    1, // language: 1 = English, 0 = Chinese
  ];
  return makePacket(cmdSetTime, data);
}

/// Build battery query packet.
Uint8List batteryPacket() => makePacket(cmdBattery);

/// Build find-device (vibrate) packet.
Uint8List findDevicePacket() => makePacket(cmdFindDevice);

/// Build power-off packet.
Uint8List powerOffPacket() => makePacket(cmdPowerOff, [0x01]);

/// Build read-heart-rate-log packet for a given day (UTC midnight timestamp).
Uint8List readHeartRatePacket(DateTime dayUtc) {
  final ts = dayUtc.toUtc().millisecondsSinceEpoch ~/ 1000;
  final data = <int>[
    ts & 0xFF,
    (ts >> 8) & 0xFF,
    (ts >> 16) & 0xFF,
    (ts >> 24) & 0xFF,
  ];
  return makePacket(cmdReadHeartRate, data);
}

/// Build read HR log settings packet.
Uint8List readHrLogSettingsPacket() =>
    makePacket(cmdHeartRateLogSettings, [0x01]);

/// Build write HR log settings packet.
Uint8List writeHrLogSettingsPacket({required bool enabled, required int intervalMinutes}) {
  assert(intervalMinutes > 0 && intervalMinutes < 256);
  return makePacket(cmdHeartRateLogSettings, [
    0x02,
    enabled ? 1 : 2,
    intervalMinutes,
  ]);
}

/// Build read-steps packet for [daysAgo] (0 = today).
Uint8List readStepsPacket(int daysAgo) =>
    makePacket(cmdGetStepSomeday, [daysAgo, 0x0F, 0x00, 0x5F, 0x01]);

/// Build start real-time reading packet.
Uint8List startRealTimePacket(int readingType) =>
    makePacket(cmdStartRealTime, [readingType, RealTimeAction.start]);

/// Build continue real-time reading packet.
Uint8List continueRealTimePacket(int readingType) =>
    makePacket(cmdStartRealTime, [readingType, RealTimeAction.continueReading]);

/// Build stop real-time reading packet.
Uint8List stopRealTimePacket(int readingType) =>
    makePacket(cmdStopRealTime, [readingType, 0, 0]);

/// Build packet to sync sleep data.
Uint8List syncSleepPacket(DateTime dayUtc) {
  return makePacket(cmdSyncSleep, [
    byteToBcd(dayUtc.year % 100),
    byteToBcd(dayUtc.month),
    byteToBcd(dayUtc.day),
  ]);
}

/// Build packet to read raw PPG sensor data.
Uint8List rawPpgPacket() => makePacket(cmdRawPpg, [0x01]); // start

/// Build packet to stop raw PPG.
Uint8List rawPpgStopPacket() => makePacket(cmdRawPpg, [0x00]); // stop

/// Build packet to read raw accelerometer data.
Uint8List rawAccelPacket() => makePacket(cmdRawAccel, [0x01]);

/// Build packet to stop raw accelerometer.
Uint8List rawAccelStopPacket() => makePacket(cmdRawAccel, [0x00]);

// ═══════════════════════════════════════════════════════════════════
// RESPONSE PARSERS
// ═══════════════════════════════════════════════════════════════════

/// Battery info from [cmdBattery] response.
class BatteryInfo {
  final int level;
  final bool charging;

  const BatteryInfo({required this.level, required this.charging});

  @override
  String toString() => 'BatteryInfo(level=$level%, charging=$charging)';
}

/// Parse battery response packet.
BatteryInfo parseBattery(List<int> packet) {
  assert(packet[0] == cmdBattery);
  return BatteryInfo(level: packet[1], charging: packet[2] != 0);
}

/// HR log settings from [cmdHeartRateLogSettings] response.
class HrLogSettings {
  final bool enabled;
  final int intervalMinutes;

  const HrLogSettings({required this.enabled, required this.intervalMinutes});

  @override
  String toString() => 'HrLogSettings(enabled=$enabled, interval=${intervalMinutes}min)';
}

/// Parse HR log settings response.
HrLogSettings parseHrLogSettings(List<int> packet) {
  assert(packet[0] == cmdHeartRateLogSettings);
  return HrLogSettings(
    enabled: packet[2] == 1,
    intervalMinutes: packet[3],
  );
}

/// A single real-time reading (HR, SpO2, or HRV).
class RealTimeReading {
  final int type;
  final int value;
  final bool isError;
  final int errorCode;

  const RealTimeReading({
    required this.type,
    required this.value,
    this.isError = false,
    this.errorCode = 0,
  });

  @override
  String toString() => isError
      ? 'RealTimeReading(type=$type, ERROR=$errorCode)'
      : 'RealTimeReading(type=$type, value=$value)';
}

/// Parse real-time reading response.
RealTimeReading parseRealTimeReading(List<int> packet) {
  assert(packet[0] == cmdStartRealTime);
  final kind = packet[1];
  final errorCode = packet[2];
  if (errorCode != 0) {
    return RealTimeReading(type: kind, value: 0, isError: true, errorCode: errorCode);
  }
  return RealTimeReading(type: kind, value: packet[3]);
}

// ═══════════════════════════════════════════════════════════════════
// MULTI-PACKET PARSERS (HR log, Steps)
// ═══════════════════════════════════════════════════════════════════

/// A full day of heart rate readings (288 slots × 5 min).
class HeartRateLog {
  final List<int> heartRates;
  final DateTime timestamp;
  final int size;

  const HeartRateLog({
    required this.heartRates,
    required this.timestamp,
    required this.size,
  });

  /// Returns (bpm, time) pairs, filtering out zero readings.
  List<(int bpm, DateTime time)> withTimes() {
    final result = <(int, DateTime)>[];
    final base = DateTime.utc(timestamp.year, timestamp.month, timestamp.day);
    for (var i = 0; i < heartRates.length; i++) {
      if (heartRates[i] > 0) {
        result.add((heartRates[i], base.add(Duration(minutes: i * 5))));
      }
    }
    return result;
  }
}

/// Stateful parser for multi-packet heart rate log responses.
///
/// Feed packets sequentially via [parse]. Returns `null` for intermediate
/// packets, a [HeartRateLog] when complete, or throws on error.
class HeartRateLogParser {
  List<int> _raw = [];
  DateTime? _timestamp;
  int _size = 0;
  int _index = 0;

  /// Parse one packet. Returns result when all packets received, null otherwise.
  /// Returns empty [HeartRateLog] with size=0 if ring reports no data.
  HeartRateLog? parse(List<int> packet) {
    final subType = packet[1];

    // Error / no data
    if (subType == 255) {
      _reset();
      return HeartRateLog(heartRates: [], timestamp: DateTime.now().toUtc(), size: 0);
    }

    // For today's data, subType 23 signals end
    if (_isToday() && subType == 23) {
      final result = _buildResult();
      _reset();
      return result;
    }

    if (subType == 0) {
      // Header packet: size, range
      _size = packet[2];
      _raw = List.filled(_size * 13, -1);
      _index = 0;
      return null;
    } else if (subType == 1) {
      // First data packet: contains timestamp
      final ts = packet[2] |
          (packet[3] << 8) |
          (packet[4] << 16) |
          (packet[5] << 24);
      // Handle signed 32-bit
      _timestamp = DateTime.fromMillisecondsSinceEpoch(
        ts * 1000,
        isUtc: true,
      );
      // First packet carries 9 HR values (bytes 6-14)
      for (var i = 0; i < 9 && _index + i < _raw.length; i++) {
        _raw[_index + i] = packet[6 + i];
      }
      _index += 9;
      return null;
    } else {
      // Subsequent data packets: 13 HR values (bytes 2-14)
      for (var i = 0; i < 13 && _index + i < _raw.length; i++) {
        _raw[_index + i] = packet[2 + i];
      }
      _index += 13;

      // Last packet?
      if (subType == _size - 1) {
        final result = _buildResult();
        _reset();
        return result;
      }
      return null;
    }
  }

  HeartRateLog _buildResult() {
    return HeartRateLog(
      heartRates: _normalizedRates(),
      timestamp: _timestamp ?? DateTime.now().toUtc(),
      size: _size,
    );
  }

  List<int> _normalizedRates() {
    var hr = List<int>.from(_raw);
    if (hr.length > 288) {
      hr = hr.sublist(0, 288);
    } else if (hr.length < 288) {
      hr.addAll(List.filled(288 - hr.length, 0));
    }
    // Replace negative sentinel values with 0
    for (var i = 0; i < hr.length; i++) {
      if (hr[i] < 0) hr[i] = 0;
    }
    return hr;
  }

  bool _isToday() {
    if (_timestamp == null) return false;
    final now = DateTime.now().toUtc();
    return _timestamp!.year == now.year &&
        _timestamp!.month == now.month &&
        _timestamp!.day == now.day;
  }

  void _reset() {
    _raw = [];
    _timestamp = null;
    _size = 0;
    _index = 0;
  }
}

/// A single step/sport detail entry (15-min interval).
class SportDetail {
  final int year;
  final int month;
  final int day;
  final int timeIndex;
  final int calories;
  final int steps;
  final int distanceM;

  const SportDetail({
    required this.year,
    required this.month,
    required this.day,
    required this.timeIndex,
    required this.calories,
    required this.steps,
    required this.distanceM,
  });

  DateTime get timestamp => DateTime.utc(
        year, month, day,
        timeIndex ~/ 4,
        (timeIndex % 4) * 15,
      );
}

/// Stateful parser for multi-packet step data responses.
class SportDetailParser {
  bool _newCalorieProtocol = false;
  int _index = 0;
  final List<SportDetail> _details = [];

  /// Parse one packet. Returns list when complete, null for intermediate.
  /// Returns empty list if ring reports no data.
  List<SportDetail>? parse(List<int> packet) {
    assert(packet[0] == cmdGetStepSomeday);

    // No data
    if (_index == 0 && packet[1] == 255) {
      _reset();
      return [];
    }

    // Header
    if (_index == 0 && packet[1] == 240) {
      _newCalorieProtocol = packet[3] == 1;
      _index++;
      return null;
    }

    // Data packet
    final year = bcdToDecimal(packet[1]) + 2000;
    final month = bcdToDecimal(packet[2]);
    final day = bcdToDecimal(packet[3]);
    final timeIndex = packet[4];
    var calories = packet[7] | (packet[8] << 8);
    if (_newCalorieProtocol) calories *= 10;
    final steps = packet[9] | (packet[10] << 8);
    final distance = packet[11] | (packet[12] << 8);

    _details.add(SportDetail(
      year: year,
      month: month,
      day: day,
      timeIndex: timeIndex,
      calories: calories,
      steps: steps,
      distanceM: distance,
    ));

    // Check if this is the last packet (current index == total - 1)
    if (packet[5] == packet[6] - 1) {
      final result = List<SportDetail>.from(_details);
      _reset();
      return result;
    }

    _index++;
    return null;
  }

  void _reset() {
    _newCalorieProtocol = false;
    _index = 0;
    _details.clear();
  }
}
