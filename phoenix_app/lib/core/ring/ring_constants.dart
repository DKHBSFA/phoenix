/// Colmi R10 Smart Ring — BLE constants and command definitions.
///
/// Ported from:
/// - CitizenOneX/colmi_r06_fbp (Dart, MIT)
/// - tahnok/colmi_r02_client (Python, MIT)
/// - Gadgetbridge PR #3896 (Java, AGPL-3.0)
library;

// ═══════════════════════════════════════════════════════════════════
// BLE UUIDs
// ═══════════════════════════════════════════════════════════════════

/// Nordic UART Service UUID (used by all Colmi rings)
const kRingServiceUuid = '6e40fff0-b5a3-f393-e0a9-e50e24dcca9e';

/// Write characteristic — Phoenix → Ring
const kRingRxCharUuid = '6e400002-b5a3-f393-e0a9-e50e24dcca9e';

/// Notify characteristic — Ring → Phoenix
const kRingTxCharUuid = '6e400003-b5a3-f393-e0a9-e50e24dcca9e';

/// Device Information Service
const kDeviceInfoServiceUuid = '0000180a-0000-1000-8000-00805f9b34fb';

/// Hardware Revision
const kDeviceHwCharUuid = '00002a27-0000-1000-8000-00805f9b34fb';

/// Firmware Revision
const kDeviceFwCharUuid = '00002a26-0000-1000-8000-00805f9b34fb';

/// BLE advertised name pattern for Colmi rings (R02-R10)
final kRingNamePattern = RegExp(r'^R\d{1,2}_[0-9A-Z]{4}$');

// ═══════════════════════════════════════════════════════════════════
// PACKET FORMAT
// ═══════════════════════════════════════════════════════════════════

/// All packets are exactly 16 bytes.
/// byte[0] = command, byte[1..14] = payload, byte[15] = checksum.
const kPacketLength = 16;

/// Error bit — set in response byte[0] when ring reports an error.
const kErrorBit = 0x80;

// ═══════════════════════════════════════════════════════════════════
// COMMANDS (byte[0])
// ═══════════════════════════════════════════════════════════════════

/// Set time (BCD-encoded). Response contains capability flags.
const cmdSetTime = 0x01;

/// Read battery level + charging status.
const cmdBattery = 0x03;

/// Power off the ring.
const cmdPowerOff = 0x08;

/// Find device (vibrate ring).
const cmdFindDevice = 0x10;

/// Read heart rate log (multi-packet, 288 slots/day × 5 min).
const cmdReadHeartRate = 0x15;

/// Heart rate log settings (sampling interval).
const cmdHeartRateLogSettings = 0x16;

/// Sync SpO2 history.
const cmdSyncSpO2 = 0x37;

/// Sync step data (multi-packet, 15-min intervals, BCD dates).
const cmdGetStepSomeday = 0x43;

/// Sync sleep data.
const cmdSyncSleep = 0x44;

/// Find device (vibrate).
const cmdFindDeviceAlt = 0x50;

/// Start real-time streaming (HR, SpO2, HRV).
const cmdStartRealTime = 0x69;

/// Stop real-time streaming.
const cmdStopRealTime = 0x6A;

/// Read raw PPG sensor data.
const cmdRawPpg = 0x68;

/// Read raw accelerometer data.
const cmdRawAccel = 0x67;

/// Read raw SpO2 sensor data.
const cmdRawSpo2 = 0x66;

// ═══════════════════════════════════════════════════════════════════
// REAL-TIME READING TYPES (byte[1] of 0x69 packet)
// ═══════════════════════════════════════════════════════════════════

/// Real-time reading types for [cmdStartRealTime].
class RealTimeReadingType {
  RealTimeReadingType._();
  static const heartRate = 1;
  static const bloodPressure = 2;
  static const spo2 = 3;
  static const fatigue = 4;
  static const healthCheck = 5;
  static const ecg = 7;
  static const pressure = 8;
  static const bloodSugar = 9;
  static const hrv = 10;
}

/// Real-time action codes (byte[2] of 0x69 packet).
class RealTimeAction {
  RealTimeAction._();
  static const start = 1;
  static const pause = 2;
  static const continueReading = 3;
  static const stop = 4;
}

// ═══════════════════════════════════════════════════════════════════
// CAPABILITY FLAGS (from set_time response)
// ═══════════════════════════════════════════════════════════════════

/// Parsed capability flags from the [cmdSetTime] response.
///
/// These tell Phoenix which sensors/features the specific ring firmware
/// supports, enabling graceful degradation.
class RingCapabilities {
  final bool supportsTemperature;
  final bool supportsBloodOxygen;
  final bool supportsHrv;
  final bool supportsPressure;
  final bool supportsBloodSugar;
  final bool supportsGps;
  final bool newSleepProtocol;
  final bool supportsManualHeart;

  const RingCapabilities({
    this.supportsTemperature = false,
    this.supportsBloodOxygen = false,
    this.supportsHrv = false,
    this.supportsPressure = false,
    this.supportsBloodSugar = false,
    this.supportsGps = false,
    this.newSleepProtocol = false,
    this.supportsManualHeart = false,
  });

  /// Parse capability flags from set_time response packet (bytes 1-14).
  factory RingCapabilities.fromPacket(List<int> packet) {
    assert(packet.length == kPacketLength);
    // Response payload starts at byte[1]
    final b = packet.sublist(1);
    return RingCapabilities(
      supportsTemperature: b[0] == 1,
      supportsBloodOxygen: (b[3] & 2) != 0,
      supportsGps: (b[10] & 8) != 0,
      supportsManualHeart: (b[11] & 1) != 0,
      supportsBloodSugar: (b[11] & 128) != 0,
      supportsPressure: (b[13] & 16) != 0,
      supportsHrv: (b[13] & 32) != 0,
      newSleepProtocol: b[8] == 1,
    );
  }

  Map<String, bool> toJson() => {
        'supportsTemperature': supportsTemperature,
        'supportsBloodOxygen': supportsBloodOxygen,
        'supportsHrv': supportsHrv,
        'supportsPressure': supportsPressure,
        'supportsBloodSugar': supportsBloodSugar,
        'supportsGps': supportsGps,
        'newSleepProtocol': newSleepProtocol,
        'supportsManualHeart': supportsManualHeart,
      };

  @override
  String toString() => 'RingCapabilities(temp=$supportsTemperature, spo2=$supportsBloodOxygen, '
      'hrv=$supportsHrv, pressure=$supportsPressure, gps=$supportsGps)';
}
