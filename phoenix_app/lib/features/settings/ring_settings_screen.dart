import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/database/database.dart';
import '../../core/ring/ring_constants.dart';
import '../../core/ring/ring_protocol.dart';
import '../../core/ring/ring_service.dart';

// ═══════════════════════════════════════════════════════════════════
// RING SETTINGS SCREEN — scan, pair, status, battery
// ═══════════════════════════════════════════════════════════════════

class RingSettingsScreen extends ConsumerStatefulWidget {
  const RingSettingsScreen({super.key});

  @override
  ConsumerState<RingSettingsScreen> createState() => _RingSettingsScreenState();
}

class _RingSettingsScreenState extends ConsumerState<RingSettingsScreen> {
  final List<RingScanResult> _scanResults = [];
  StreamSubscription<RingScanResult>? _scanSub;
  bool _isScanning = false;
  bool _isSyncing = false;
  String? _syncStatus;
  HrLogSettings? _hrSettings;

  @override
  void initState() {
    super.initState();
    final ring = ref.read(ringServiceProvider);
    _scanSub = ring.scanResults.listen((result) {
      // Deduplicate by deviceId
      if (!_scanResults.any((r) => r.deviceId == result.deviceId)) {
        setState(() => _scanResults.add(result));
      }
    });
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _scanResults.clear();
      _isScanning = true;
    });
    final ring = ref.read(ringServiceProvider);
    try {
      await ring.startScan();
    } on BluetoothUnavailableException catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        TDToast.showText(e.message, context: context);
      }
      return;
    }

    // Auto-clear scanning state after timeout
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) setState(() => _isScanning = false);
    });
  }

  Future<void> _connectToRing(RingScanResult scanResult) async {
    final ring = ref.read(ringServiceProvider);
    await ring.connect(scanResult.deviceId);

    // Wait for ready state, then save to DB
    ring.connectionState.addListener(() async {
      if (ring.connectionState.value == RingConnectionState.ready) {
        final dao = ref.read(ringDeviceDaoProvider);
        final caps = ring.capabilities;
        await dao.savePairedRing(RingDevicesCompanion(
          id: const Value(1), // single device
          macAddress: Value(scanResult.deviceId),
          name: Value(scanResult.name),
          firmwareVersion: Value(ring.firmwareVersion ?? ''),
          hardwareVersion: Value(ring.hardwareVersion ?? ''),
          capabilitiesJson: Value(caps != null ? jsonEncode(caps.toJson()) : '{}'),
          batteryLevel: Value(ring.batteryLevel.value ?? -1),
          pairedAt: Value(DateTime.now()),
        ));
      }
    });
  }

  Future<void> _unpair() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disaccoppia ring?'),
        content: const Text(
          'Il ring verrà disconnesso. Potrai riassociarlo in qualsiasi momento.',
        ),
        actions: [
          TDButton(
            text: 'Annulla',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx, false),
          ),
          TDButton(
            text: 'Disaccoppia',
            type: TDButtonType.fill,
            theme: TDButtonTheme.danger,
            size: TDButtonSize.large,
            onTap: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final ring = ref.read(ringServiceProvider);
      await ring.disconnect();
      final dao = ref.read(ringDeviceDaoProvider);
      await dao.unpair();
    }
  }

  Future<void> _syncData() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Scaricamento HR log...';
    });

    final ring = ref.read(ringServiceProvider);
    final dao = ref.read(ringDeviceDaoProvider);
    final now = DateTime.now();

    try {
      // HR log today + yesterday
      await ring.readHeartRateLog(now);
      if (!mounted) return;
      setState(() => _syncStatus = 'HR log ieri...');
      await ring.readHeartRateLog(now.subtract(const Duration(days: 1)));

      if (!mounted) return;
      setState(() => _syncStatus = 'Passi oggi...');
      await ring.readSteps(0);

      if (!mounted) return;
      setState(() => _syncStatus = 'Passi ieri...');
      await ring.readSteps(1);

      // Update last sync in DB
      await dao.updateLastSync(1);

      if (!mounted) return;
      setState(() {
        _isSyncing = false;
        _syncStatus = null;
      });
      TDToast.showText('Sincronizzazione completata', context: context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSyncing = false;
        _syncStatus = null;
      });
      TDToast.showText('Errore sync: $e', context: context);
    }
  }

  Future<void> _loadHrSettings() async {
    final ring = ref.read(ringServiceProvider);
    final settings = await ring.readHrLogSettings();
    if (mounted && settings != null) {
      setState(() => _hrSettings = settings);
    }
  }

  Future<void> _changeHrInterval() async {
    if (_hrSettings == null) await _loadHrSettings();
    if (!mounted || _hrSettings == null) return;

    final intervals = [1, 5, 10, 15, 30, 60];
    final selected = await showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Intervallo campionamento HR'),
        children: intervals.map((min) => SimpleDialogOption(
          onPressed: () => Navigator.pop(ctx, min),
          child: Text(
            '$min min${min == _hrSettings!.intervalMinutes ? ' (attuale)' : ''}',
            style: TextStyle(
              fontWeight: min == _hrSettings!.intervalMinutes
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        )).toList(),
      ),
    );

    if (selected != null && selected != _hrSettings!.intervalMinutes) {
      final ring = ref.read(ringServiceProvider);
      await ring.setHrLogSettings(
        enabled: _hrSettings!.enabled,
        intervalMinutes: selected,
      );
      setState(() => _hrSettings = HrLogSettings(
        enabled: _hrSettings!.enabled,
        intervalMinutes: selected,
      ));
      if (mounted) {
        TDToast.showText('Intervallo impostato: $selected min', context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ring = ref.watch(ringServiceProvider);
    final pairedRing = ref.watch(pairedRingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const TDNavBar(title: 'Smart Ring'),
      body: ListenableBuilder(
        listenable: ring.connectionState,
        builder: (context, _) {
          final state = ring.connectionState.value;
          final hasPaired = pairedRing.valueOrNull != null;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: Spacing.md),
            children: [
              // ── Connection status ──
              _StatusCard(
                state: state,
                batteryNotifier: ring.batteryLevel,
                firmwareVersion: ring.firmwareVersion,
                capabilities: ring.capabilities,
                isDark: isDark,
              ),

              if (hasPaired && state == RingConnectionState.ready) ...[
                const SizedBox(height: Spacing.md),
                // ── Actions ──
                const _SectionHeader('Azioni'),
                _ActionTile(
                  icon: Icons.vibration,
                  title: 'Trova ring',
                  subtitle: 'Fa vibrare il ring',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ring.findDevice();
                  },
                ),
                _ActionTile(
                  icon: Icons.refresh,
                  title: 'Aggiorna batteria',
                  onTap: () => ring.refreshBattery(),
                ),
                // ── Sync section ──
                const SizedBox(height: Spacing.lg),
                const _SectionHeader('Dati'),
                if (_isSyncing)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.screenH,
                      vertical: Spacing.sm,
                    ),
                    child: Column(
                      children: [
                        const TDLoading(size: TDLoadingSize.small),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          _syncStatus ?? 'Sincronizzazione...',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.phoenix.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  _ActionTile(
                    icon: Icons.sync,
                    title: 'Sincronizza dati',
                    subtitle: pairedRing.valueOrNull?.lastSync != null
                        ? 'Ultimo: ${_formatLastSync(pairedRing.valueOrNull!.lastSync!)}'
                        : 'Mai sincronizzato',
                    onTap: _syncData,
                  ),
                _ActionTile(
                  icon: Icons.bar_chart,
                  title: 'Visualizza dati',
                  subtitle: 'HR log, passi, real-time',
                  onTap: () => Navigator.pushNamed(context, PhoenixRouter.ringData),
                ),
                _ActionTile(
                  icon: Icons.timer_outlined,
                  title: 'Intervallo HR log',
                  subtitle: _hrSettings != null
                      ? 'Ogni ${_hrSettings!.intervalMinutes} min'
                      : 'Tap per leggere',
                  onTap: _changeHrInterval,
                ),

                const SizedBox(height: Spacing.lg),
                const _SectionHeader('Gestione'),
                _ActionTile(
                  icon: Icons.link_off,
                  title: 'Disaccoppia ring',
                  subtitle: 'Rimuovi associazione',
                  onTap: _unpair,
                  danger: true,
                ),
              ],

              if (!hasPaired || state == RingConnectionState.disconnected) ...[
                const SizedBox(height: Spacing.lg),
                // ── Scan ──
                const _SectionHeader('Cerca ring'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
                  child: TDButton(
                    text: _isScanning ? 'Scansione in corso...' : 'Cerca Colmi R10',
                    icon: _isScanning ? null : Icons.bluetooth_searching,
                    type: TDButtonType.fill,
                    theme: TDButtonTheme.primary,
                    size: TDButtonSize.large,
                    isBlock: true,
                    disabled: _isScanning,
                    onTap: _isScanning ? null : _startScan,
                  ),
                ),

                if (_scanResults.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  const _SectionHeader('Dispositivi trovati'),
                  ..._scanResults.map((r) => _ScanResultTile(
                        result: r,
                        onTap: () => _connectToRing(r),
                        isConnecting: state == RingConnectionState.connecting,
                      )),
                ],

                if (_isScanning && _scanResults.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(Spacing.xl),
                    child: Center(child: TDLoading(size: TDLoadingSize.medium)),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

String _formatLastSync(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final syncDay = DateTime(dt.year, dt.month, dt.day);
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  if (syncDay == today) return 'oggi $h:$m';
  if (syncDay == today.subtract(const Duration(days: 1))) return 'ieri $h:$m';
  return '${dt.day}/${dt.month} $h:$m';
}

// ═══════════════════════════════════════════════════════════════════
// SUBWIDGETS
// ═══════════════════════════════════════════════════════════════════

class _StatusCard extends StatelessWidget {
  final RingConnectionState state;
  final ValueListenable<int?> batteryNotifier;
  final String? firmwareVersion;
  final RingCapabilities? capabilities;
  final bool isDark;

  const _StatusCard({
    required this.state,
    required this.batteryNotifier,
    required this.firmwareVersion,
    required this.capabilities,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (state) {
      RingConnectionState.disconnected => (
          Icons.bluetooth_disabled,
          'Disconnesso',
          PhoenixColors.error,
        ),
      RingConnectionState.scanning => (
          Icons.bluetooth_searching,
          'Scansione...',
          PhoenixColors.warning,
        ),
      RingConnectionState.connecting => (
          Icons.bluetooth_connected,
          'Connessione...',
          PhoenixColors.warning,
        ),
      RingConnectionState.connected => (
          Icons.bluetooth_connected,
          'Connesso (inizializzazione...)',
          PhoenixColors.warning,
        ),
      RingConnectionState.ready => (
          Icons.bluetooth_connected,
          'Connesso',
          PhoenixColors.success,
        ),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(color: context.phoenix.border),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(Radii.full),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: Spacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Colmi R10',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: context.phoenix.textPrimary,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (state == RingConnectionState.ready)
                ValueListenableBuilder<int?>(
                  valueListenable: batteryNotifier,
                  builder: (_, level, __) {
                    if (level == null || level < 0) return const SizedBox();
                    final batteryIcon = level > 80
                        ? Icons.battery_full
                        : level > 50
                            ? Icons.battery_5_bar
                            : level > 20
                                ? Icons.battery_3_bar
                                : Icons.battery_1_bar;
                    final batteryColor = level > 20
                        ? PhoenixColors.success
                        : PhoenixColors.error;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(batteryIcon, color: batteryColor, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$level%',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: batteryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),

          // Firmware + capabilities
          if (state == RingConnectionState.ready && firmwareVersion != null) ...[
            const SizedBox(height: Spacing.smMd),
            const Divider(height: 1),
            const SizedBox(height: Spacing.smMd),
            _DetailRow('Firmware', firmwareVersion!),
            if (capabilities != null) ...[
              _DetailRow('HRV', capabilities!.supportsHrv ? 'Supportato' : 'Non supportato'),
              _DetailRow('SpO2', capabilities!.supportsBloodOxygen ? 'Supportato' : 'Non supportato'),
              _DetailRow('Temperatura', capabilities!.supportsTemperature ? 'Supportato' : 'Non supportato'),
            ],
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: context.phoenix.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ScanResultTile extends StatelessWidget {
  final RingScanResult result;
  final VoidCallback onTap;
  final bool isConnecting;

  const _ScanResultTile({
    required this.result,
    required this.onTap,
    required this.isConnecting,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: PhoenixColors.success.withAlpha(20),
          borderRadius: BorderRadius.circular(Radii.full),
        ),
        child: const Icon(Icons.bluetooth, color: PhoenixColors.success),
      ),
      title: Text(result.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        result.rssi != null ? 'RSSI: ${result.rssi} dBm' : result.deviceId,
        style: TextStyle(fontSize: 12, color: context.phoenix.textTertiary),
      ),
      trailing: isConnecting
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.chevron_right),
      onTap: isConnecting ? null : () {
        HapticFeedback.mediumImpact();
        onTap();
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Spacing.lg, Spacing.lg, Spacing.lg, Spacing.sm),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.phoenix.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? PhoenixColors.error : context.phoenix.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(fontSize: 12, color: context.phoenix.textSecondary))
          : null,
      trailing: Icon(Icons.chevron_right, size: 20, color: context.phoenix.textTertiary),
      onTap: onTap,
    );
  }
}
