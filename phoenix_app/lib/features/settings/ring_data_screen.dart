import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/ring/ring_constants.dart';
import '../../core/ring/ring_protocol.dart';
import '../../core/ring/ring_service.dart';

// ═══════════════════════════════════════════════════════════════════
// RING DATA SCREEN — HR log, steps, real-time HR
// ═══════════════════════════════════════════════════════════════════

class RingDataScreen extends ConsumerStatefulWidget {
  const RingDataScreen({super.key});

  @override
  ConsumerState<RingDataScreen> createState() => _RingDataScreenState();
}

class _RingDataScreenState extends ConsumerState<RingDataScreen> {
  HeartRateLog? _hrLog;
  List<SportDetail>? _steps;
  bool _loadingHr = false;
  bool _loadingSteps = false;

  // Real-time
  bool _rtActive = false;
  int? _rtBpm;
  StreamSubscription<RealTimeReading>? _rtSub;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _stopRealTime();
    super.dispose();
  }

  Future<void> _loadData() async {
    final ring = ref.read(ringServiceProvider);
    if (ring.connectionState.value != RingConnectionState.ready) return;

    setState(() {
      _loadingHr = true;
      _loadingSteps = true;
    });

    final now = DateTime.now();

    // Load in parallel
    final results = await Future.wait([
      ring.readHeartRateLog(now),
      ring.readSteps(0),
    ]);

    if (!mounted) return;
    setState(() {
      _hrLog = results[0] as HeartRateLog?;
      _steps = results[1] as List<SportDetail>?;
      _loadingHr = false;
      _loadingSteps = false;
    });
  }

  void _startRealTime() {
    final ring = ref.read(ringServiceProvider);
    ring.startRealTimeHr();
    _rtSub = ring.realTimeReadings.listen((reading) {
      if (reading.type == RealTimeReadingType.heartRate && !reading.isError) {
        if (mounted) setState(() => _rtBpm = reading.value);
      }
    });
    setState(() {
      _rtActive = true;
      _rtBpm = null;
    });
  }

  void _stopRealTime() {
    _rtSub?.cancel();
    _rtSub = null;
    final ring = ref.read(ringServiceProvider);
    if (ring.connectionState.value == RingConnectionState.ready) {
      ring.stopRealTimeHr();
    }
    if (mounted) {
      setState(() {
        _rtActive = false;
        _rtBpm = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const TDNavBar(title: 'Dati Ring'),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.md,
        ),
        children: [
          // ── HR Log ──
          _SectionTitle('Frequenza cardiaca', loading: _loadingHr),
          const SizedBox(height: Spacing.sm),
          if (_hrLog != null) _HrChart(hrLog: _hrLog!, isDark: isDark),
          if (_hrLog == null && !_loadingHr)
            _EmptyCard('Nessun dato HR. Sincronizza il ring.', isDark: isDark),

          const SizedBox(height: Spacing.lg),

          // ── Steps ──
          _SectionTitle('Passi', loading: _loadingSteps),
          const SizedBox(height: Spacing.sm),
          if (_steps != null) _StepsCard(steps: _steps!, isDark: isDark),
          if (_steps == null && !_loadingSteps)
            _EmptyCard('Nessun dato passi. Sincronizza il ring.', isDark: isDark),

          const SizedBox(height: Spacing.lg),

          // ── Real-time HR ──
          const _SectionTitle('HR Real-time', loading: false),
          const SizedBox(height: Spacing.sm),
          _RealTimeCard(
            active: _rtActive,
            bpm: _rtBpm,
            onStart: _startRealTime,
            onStop: _stopRealTime,
            isDark: isDark,
          ),

          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SUBWIDGETS
// ═══════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool loading;
  const _SectionTitle(this.title, {required this.loading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: context.phoenix.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        if (loading) ...[
          const SizedBox(width: Spacing.sm),
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        ],
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final bool isDark;
  const _EmptyCard(this.message, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        border: Border.all(color: context.phoenix.border),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13, color: context.phoenix.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── HR Bar Chart ──────────────────────────────────────────────────

class _HrChart extends StatelessWidget {
  final HeartRateLog hrLog;
  final bool isDark;
  const _HrChart({required this.hrLog, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final readings = hrLog.withTimes();
    if (readings.isEmpty) {
      return _EmptyCard('Nessuna lettura HR per oggi.', isDark: isDark);
    }

    // Summary stats
    final bpms = readings.map((r) => r.$1).toList();
    final avg = (bpms.reduce((a, b) => a + b) / bpms.length).round();
    final min = bpms.reduce((a, b) => a < b ? a : b);
    final max = bpms.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        border: Border.all(color: context.phoenix.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip('Media', '$avg', PhoenixColors.error),
              _StatChip('Min', '$min', PhoenixColors.success),
              _StatChip('Max', '$max', PhoenixColors.warning),
              _StatChip('Letture', '${readings.length}', context.phoenix.textSecondary),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Bar chart
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                barGroups: _buildBars(readings, context),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: TextStyle(fontSize: 10, color: context.phoenix.textTertiary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        // Show every ~4th label to avoid overlap
                        if (idx % 4 != 0 || idx >= readings.length) {
                          return const SizedBox.shrink();
                        }
                        final t = readings[idx].$2;
                        return Text(
                          '${t.hour}:${t.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 9, color: context.phoenix.textTertiary),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: context.phoenix.border,
                    strokeWidth: 0.5,
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIdx, rod, rodIdx) {
                      if (groupIdx >= readings.length) return null;
                      final t = readings[groupIdx].$2;
                      return BarTooltipItem(
                        '${rod.toY.toInt()} BPM\n${t.hour}:${t.minute.toString().padLeft(2, '0')}',
                        TextStyle(
                          color: context.phoenix.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBars(
    List<(int, DateTime)> readings,
    BuildContext context,
  ) {
    return List.generate(readings.length, (i) {
      final bpm = readings[i].$1.toDouble();
      final color = bpm > 100
          ? PhoenixColors.error
          : bpm > 60
              ? PhoenixColors.success
              : PhoenixColors.warning;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: bpm,
            color: color,
            width: readings.length > 50 ? 2 : 4,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: context.phoenix.textTertiary),
        ),
      ],
    );
  }
}

// ── Steps Card ────────────────────────────────────────────────────

class _StepsCard extends StatelessWidget {
  final List<SportDetail> steps;
  final bool isDark;
  const _StepsCard({required this.steps, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return _EmptyCard('Nessun dato passi per oggi.', isDark: isDark);
    }

    final totalSteps = steps.fold<int>(0, (sum, s) => sum + s.steps);
    final totalCalories = steps.fold<int>(0, (sum, s) => sum + s.calories);
    final totalDistanceM = steps.fold<int>(0, (sum, s) => sum + s.distanceM);

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        border: Border.all(color: context.phoenix.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip('Passi', '$totalSteps', context.phoenix.textPrimary),
              _StatChip('kcal', '$totalCalories', PhoenixColors.warning),
              _StatChip('m', '$totalDistanceM', PhoenixColors.success),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Bar chart (15-min intervals)
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                barGroups: List.generate(steps.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: steps[i].steps.toDouble(),
                        color: context.phoenix.textPrimary,
                        width: steps.length > 50 ? 2 : 4,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx % 8 != 0 || idx >= steps.length) {
                          return const SizedBox.shrink();
                        }
                        final t = steps[idx].timestamp;
                        return Text(
                          '${t.hour}:${t.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 9, color: context.phoenix.textTertiary),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIdx, rod, rodIdx) {
                      if (groupIdx >= steps.length) return null;
                      final s = steps[groupIdx];
                      final t = s.timestamp;
                      return BarTooltipItem(
                        '${s.steps} passi\n${t.hour}:${t.minute.toString().padLeft(2, '0')}',
                        TextStyle(
                          color: context.phoenix.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Real-time HR Card ─────────────────────────────────────────────

class _RealTimeCard extends StatelessWidget {
  final bool active;
  final int? bpm;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final bool isDark;

  const _RealTimeCard({
    required this.active,
    required this.bpm,
    required this.onStart,
    required this.onStop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        border: Border.all(
          color: active ? PhoenixColors.error : context.phoenix.border,
          width: active ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (active && bpm != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: PhoenixColors.error, size: 28),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    '$bpm',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: PhoenixColors.error,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    'BPM',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.phoenix.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          if (active && bpm == null)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: Column(
                children: [
                  const TDLoading(size: TDLoadingSize.small),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'In attesa del segnale...',
                    style: TextStyle(fontSize: 13, color: context.phoenix.textSecondary),
                  ),
                ],
              ),
            ),
          TDButton(
            text: active ? 'Ferma' : 'Avvia HR Live',
            icon: active ? Icons.stop : Icons.play_arrow,
            type: TDButtonType.fill,
            theme: active ? TDButtonTheme.danger : TDButtonTheme.primary,
            size: TDButtonSize.large,
            isBlock: true,
            onTap: active ? onStop : onStart,
          ),
        ],
      ),
    );
  }
}
