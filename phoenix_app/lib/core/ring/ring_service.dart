/// Colmi R10 Smart Ring — BLE connection lifecycle.
///
/// Handles scanning, connecting, pairing (set time + capability detection),
/// reconnection, and command dispatch via [universal_ble].
///
/// Design: thin wrapper around universal_ble, isolating all BLE logic so
/// the package can be swapped without touching the rest of Phoenix.
library;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_ble/universal_ble.dart';

import 'ring_constants.dart';
import 'ring_protocol.dart';
import 'sleep_parser.dart';

// ═══════════════════════════════════════════════════════════════════
// EXCEPTIONS
// ═══════════════════════════════════════════════════════════════════

class BluetoothUnavailableException implements Exception {
  final AvailabilityState state;
  const BluetoothUnavailableException(this.state);

  String get message {
    switch (state) {
      case AvailabilityState.poweredOff:
        return 'Bluetooth è disattivato. Attivalo nelle impostazioni.';
      case AvailabilityState.unauthorized:
        return 'Permesso Bluetooth negato. Autorizza Phoenix nelle impostazioni.';
      case AvailabilityState.unsupported:
        return 'Questo dispositivo non supporta Bluetooth Low Energy.';
      default:
        return 'Bluetooth non disponibile.';
    }
  }

  @override
  String toString() => 'BluetoothUnavailableException: $message';
}

// ═══════════════════════════════════════════════════════════════════
// CONNECTION STATE
// ═══════════════════════════════════════════════════════════════════

enum RingConnectionState {
  disconnected,
  scanning,
  connecting,
  connected,
  ready, // connected + time set + capabilities read
}

// ═══════════════════════════════════════════════════════════════════
// SCAN RESULT
// ═══════════════════════════════════════════════════════════════════

class RingScanResult {
  final String deviceId;
  final String name;
  final int? rssi;

  const RingScanResult({
    required this.deviceId,
    required this.name,
    this.rssi,
  });
}

// ═══════════════════════════════════════════════════════════════════
// RING SERVICE
// ═══════════════════════════════════════════════════════════════════

class RingService {
  RingService();

  // ── State streams ──────────────────────────────────────────────

  final _connectionState = ValueNotifier<RingConnectionState>(
    RingConnectionState.disconnected,
  );
  ValueListenable<RingConnectionState> get connectionState => _connectionState;

  final _scanResults = StreamController<RingScanResult>.broadcast();
  Stream<RingScanResult> get scanResults => _scanResults.stream;

  final _batteryLevel = ValueNotifier<int?>(null);
  ValueListenable<int?> get batteryLevel => _batteryLevel;

  final _realTimeReadings = StreamController<RealTimeReading>.broadcast();
  Stream<RealTimeReading> get realTimeReadings => _realTimeReadings.stream;

  // ── Internal state ─────────────────────────────────────────────

  String? _deviceId;
  String? get deviceId => _deviceId;

  RingCapabilities? _capabilities;
  RingCapabilities? get capabilities => _capabilities;

  String? _firmwareVersion;
  String? get firmwareVersion => _firmwareVersion;

  String? _hardwareVersion;
  String? get hardwareVersion => _hardwareVersion;

  // Completers for request-response commands
  final Map<int, Completer<List<int>>> _pendingCommands = {};

  // Multi-packet parsers
  HeartRateLogParser? _hrParser;
  Completer<HeartRateLog>? _hrCompleter;

  SportDetailParser? _stepParser;
  Completer<List<SportDetail>>? _stepCompleter;

  SleepDataParser? _sleepParser;
  Completer<SleepSession>? _sleepCompleter;

  Timer? _reconnectTimer;
  bool _autoReconnect = false;

  // ── Lifecycle ──────────────────────────────────────────────────

  /// Initialize BLE callbacks. Call once at app startup.
  void init() {
    UniversalBle.onScanResult = _onScanResult;
    UniversalBle.onConnectionChange = _onConnectionChange;
    UniversalBle.onValueChange = _onValueChange;
  }

  /// Clean up resources.
  void dispose() {
    _reconnectTimer?.cancel();
    _scanResults.close();
    _realTimeReadings.close();
  }

  // ── Scanning ───────────────────────────────────────────────────

  /// Start scanning for Colmi rings.
  ///
  /// Checks Bluetooth availability first; throws [BluetoothUnavailableException]
  /// if BLE is off or permissions are denied.
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    // Check Bluetooth is available (triggers system permission dialog on first call)
    final availability = await UniversalBle.getBluetoothAvailabilityState();
    if (availability != AvailabilityState.poweredOn) {
      throw BluetoothUnavailableException(availability);
    }

    _connectionState.value = RingConnectionState.scanning;

    await UniversalBle.startScan(
      scanFilter: ScanFilter(
        withServices: [kRingServiceUuid],
      ),
    );

    // Auto-stop after timeout
    Future.delayed(timeout, () {
      if (_connectionState.value == RingConnectionState.scanning) {
        stopScan();
      }
    });
  }

  /// Stop scanning.
  Future<void> stopScan() async {
    await UniversalBle.stopScan();
    if (_connectionState.value == RingConnectionState.scanning) {
      _connectionState.value = RingConnectionState.disconnected;
    }
  }

  void _onScanResult(BleDevice device) {
    final name = device.name ?? '';
    if (name.isEmpty) return;

    // Accept any Colmi ring pattern
    if (kRingNamePattern.hasMatch(name) || name.contains('R10')) {
      _scanResults.add(RingScanResult(
        deviceId: device.deviceId,
        name: name,
        rssi: device.rssi,
      ));
    }
  }

  // ── Connection ─────────────────────────────────────────────────

  /// Connect to a specific ring by device ID.
  Future<void> connect(String deviceId) async {
    await stopScan();
    _deviceId = deviceId;
    _autoReconnect = true;
    _connectionState.value = RingConnectionState.connecting;

    await UniversalBle.connect(deviceId);
  }

  /// Disconnect from the ring.
  Future<void> disconnect() async {
    _autoReconnect = false;
    _reconnectTimer?.cancel();
    if (_deviceId != null) {
      await UniversalBle.disconnect(_deviceId!);
    }
    _deviceId = null;
    _capabilities = null;
    _firmwareVersion = null;
    _hardwareVersion = null;
    _batteryLevel.value = null;
    _connectionState.value = RingConnectionState.disconnected;
  }

  void _onConnectionChange(String deviceId, bool isConnected, String? error) {
    if (deviceId != _deviceId) return;

    if (isConnected) {
      _connectionState.value = RingConnectionState.connected;
      _setupNotifications();
    } else {
      _connectionState.value = RingConnectionState.disconnected;
      _batteryLevel.value = null;
      if (_autoReconnect) {
        _scheduleReconnect();
      }
    }
  }

  Future<void> _setupNotifications() async {
    if (_deviceId == null) return;

    // Subscribe to ring notifications (TX characteristic)
    await UniversalBle.subscribeNotifications(
      _deviceId!,
      kRingServiceUuid,
      kRingTxCharUuid,
    );

    // Now pair: set time → read capabilities
    await _pair();
  }

  /// Pair with the ring: set time and read capabilities + device info.
  Future<void> _pair() async {
    // Set time — response contains capability flags
    final timePacket = setTimePacket(DateTime.now().toUtc());
    final response = await _sendAndWait(cmdSetTime, timePacket);
    if (response != null) {
      _capabilities = RingCapabilities.fromPacket(response);
    }

    // Read battery
    await refreshBattery();

    // Read firmware/hardware version
    await _readDeviceInfo();

    _connectionState.value = RingConnectionState.ready;
  }

  Future<void> _readDeviceInfo() async {
    if (_deviceId == null) return;
    try {
      final fw = await UniversalBle.read(
        _deviceId!,
        kDeviceInfoServiceUuid,
        kDeviceFwCharUuid,
      );
      _firmwareVersion = utf8.decode(fw);

      final hw = await UniversalBle.read(
        _deviceId!,
        kDeviceInfoServiceUuid,
        kDeviceHwCharUuid,
      );
      _hardwareVersion = utf8.decode(hw);
    } catch (e) {
      debugPrint('RingService: could not read device info: $e');
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      if (_deviceId != null && _autoReconnect) {
        debugPrint('RingService: attempting reconnect to $_deviceId');
        _connectionState.value = RingConnectionState.connecting;
        try {
          await UniversalBle.connect(_deviceId!);
        } catch (e) {
          debugPrint('RingService: reconnect failed: $e');
          _scheduleReconnect(); // retry
        }
      }
    });
  }

  // ── Notification handler ───────────────────────────────────────

  void _onValueChange(
    String deviceId,
    String characteristicId,
    Uint8List value,
    int? timestamp,
  ) {
    if (deviceId != _deviceId) return;
    if (characteristicId.toLowerCase() != kRingTxCharUuid) return;
    if (value.length != kPacketLength) return;

    final cmd = value[0];

    // Check for error bit
    if (cmd & kErrorBit != 0) {
      debugPrint('RingService: error response for cmd 0x${(cmd & 0x7F).toRadixString(16)}');
      return;
    }

    // Route to pending command completers
    if (_pendingCommands.containsKey(cmd)) {
      _pendingCommands[cmd]!.complete(List<int>.from(value));
      _pendingCommands.remove(cmd);
      return;
    }

    // Route to multi-packet parsers
    if (cmd == cmdReadHeartRate && _hrParser != null) {
      final result = _hrParser!.parse(List<int>.from(value));
      if (result != null && _hrCompleter != null && !_hrCompleter!.isCompleted) {
        _hrCompleter!.complete(result);
      }
      return;
    }

    if (cmd == cmdGetStepSomeday && _stepParser != null) {
      final result = _stepParser!.parse(List<int>.from(value));
      if (result != null && _stepCompleter != null && !_stepCompleter!.isCompleted) {
        _stepCompleter!.complete(result);
      }
      return;
    }

    if (cmd == cmdSyncSleep && _sleepParser != null) {
      final result = _sleepParser!.parse(List<int>.from(value));
      if (result != null && _sleepCompleter != null && !_sleepCompleter!.isCompleted) {
        _sleepCompleter!.complete(result);
      }
      return;
    }

    // Real-time readings
    if (cmd == cmdStartRealTime) {
      _realTimeReadings.add(parseRealTimeReading(List<int>.from(value)));
      return;
    }

    debugPrint('RingService: unhandled packet cmd=0x${cmd.toRadixString(16)}');
  }

  // ── Command helpers ────────────────────────────────────────────

  Future<void> _sendPacket(Uint8List packet) async {
    if (_deviceId == null) return;
    await UniversalBle.write(
      _deviceId!,
      kRingServiceUuid,
      kRingRxCharUuid,
      packet,
      withoutResponse: true,
    );
  }

  /// Send a packet and wait for a single response with matching command byte.
  Future<List<int>?> _sendAndWait(
    int cmd,
    Uint8List packet, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final completer = Completer<List<int>>();
    _pendingCommands[cmd] = completer;
    await _sendPacket(packet);
    try {
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      _pendingCommands.remove(cmd);
      debugPrint('RingService: timeout waiting for cmd 0x${cmd.toRadixString(16)}');
      return null;
    }
  }

  // ── Public commands ────────────────────────────────────────────

  /// Read battery level.
  Future<BatteryInfo?> refreshBattery() async {
    final response = await _sendAndWait(cmdBattery, batteryPacket());
    if (response == null) return null;
    final info = parseBattery(response);
    _batteryLevel.value = info.level;
    return info;
  }

  /// Make the ring vibrate (find device).
  Future<void> findDevice() async {
    await _sendPacket(findDevicePacket());
  }

  /// Read heart rate log for a given day.
  Future<HeartRateLog?> readHeartRateLog(DateTime day) async {
    _hrParser = HeartRateLogParser();
    _hrCompleter = Completer<HeartRateLog>();

    final dayMidnight = DateTime.utc(day.year, day.month, day.day);
    await _sendPacket(readHeartRatePacket(dayMidnight));

    try {
      return await _hrCompleter!.future.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      debugPrint('RingService: timeout reading HR log');
      return null;
    } finally {
      _hrParser = null;
      _hrCompleter = null;
    }
  }

  /// Read step data for [daysAgo] (0 = today).
  Future<List<SportDetail>?> readSteps(int daysAgo) async {
    _stepParser = SportDetailParser();
    _stepCompleter = Completer<List<SportDetail>>();

    await _sendPacket(readStepsPacket(daysAgo));

    try {
      return await _stepCompleter!.future.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      debugPrint('RingService: timeout reading steps');
      return null;
    } finally {
      _stepParser = null;
      _stepCompleter = null;
    }
  }

  /// Read HR log settings.
  Future<HrLogSettings?> readHrLogSettings() async {
    final response = await _sendAndWait(
      cmdHeartRateLogSettings,
      readHrLogSettingsPacket(),
    );
    if (response == null) return null;
    return parseHrLogSettings(response);
  }

  /// Set HR log settings.
  Future<void> setHrLogSettings({
    required bool enabled,
    required int intervalMinutes,
  }) async {
    await _sendAndWait(
      cmdHeartRateLogSettings,
      writeHrLogSettingsPacket(enabled: enabled, intervalMinutes: intervalMinutes),
    );
  }

  /// Start real-time HR streaming.
  Future<void> startRealTimeHr() async {
    await _sendPacket(startRealTimePacket(RealTimeReadingType.heartRate));
  }

  /// Stop real-time HR streaming.
  Future<void> stopRealTimeHr() async {
    await _sendPacket(stopRealTimePacket(RealTimeReadingType.heartRate));
  }

  /// Start real-time HRV streaming.
  Future<void> startRealTimeHrv() async {
    await _sendPacket(startRealTimePacket(RealTimeReadingType.hrv));
  }

  /// Stop real-time HRV streaming.
  Future<void> stopRealTimeHrv() async {
    await _sendPacket(stopRealTimePacket(RealTimeReadingType.hrv));
  }

  /// Start real-time SpO2 streaming.
  Future<void> startRealTimeSpO2() async {
    await _sendPacket(startRealTimePacket(RealTimeReadingType.spo2));
  }

  /// Stop real-time SpO2 streaming.
  Future<void> stopRealTimeSpO2() async {
    await _sendPacket(stopRealTimePacket(RealTimeReadingType.spo2));
  }

  /// Probe if raw PPG is supported (send command, check for response vs error).
  Future<bool> probeRawPpgSupport() async {
    final response = await _sendAndWait(cmdRawPpg, rawPpgPacket(), timeout: const Duration(seconds: 2));
    if (response != null) {
      // Got a response — stop immediately
      await _sendPacket(rawPpgStopPacket());
      return true;
    }
    return false;
  }

  /// Start raw PPG streaming.
  Future<void> startRawPpg() async {
    await _sendPacket(rawPpgPacket());
  }

  /// Stop raw PPG streaming.
  Future<void> stopRawPpg() async {
    await _sendPacket(rawPpgStopPacket());
  }

  /// Start raw accelerometer streaming.
  Future<void> startRawAccel() async {
    await _sendPacket(rawAccelPacket());
  }

  /// Stop raw accelerometer streaming.
  Future<void> stopRawAccel() async {
    await _sendPacket(rawAccelStopPacket());
  }

  /// Read sleep data for last night.
  Future<SleepSession?> readSleep() async {
    _sleepParser = SleepDataParser();
    _sleepCompleter = Completer<SleepSession>();

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    await _sendPacket(syncSleepPacket(DateTime.utc(yesterday.year, yesterday.month, yesterday.day)));

    try {
      return await _sleepCompleter!.future.timeout(const Duration(seconds: 15));
    } on TimeoutException {
      debugPrint('RingService: timeout reading sleep data');
      return null;
    } finally {
      _sleepParser = null;
      _sleepCompleter = null;
    }
  }
}
