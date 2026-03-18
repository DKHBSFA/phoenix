import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';

class ConditioningHistory extends ConsumerStatefulWidget {
  final String type;
  const ConditioningHistory({super.key, required this.type});

  @override
  ConsumerState<ConditioningHistory> createState() =>
      _ConditioningHistoryState();
}

class _ConditioningHistoryState extends ConsumerState<ConditioningHistory> {
  List<ConditioningSession> _sessions = [];
  int _totalCount = 0;
  int _streak = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dao = ref.read(conditioningDaoProvider);
    final sessions = await dao.getRecentByType(widget.type, days: 30);
    final total = await dao.countByType(widget.type);
    final streak = await dao.currentStreak(widget.type);

    if (mounted) {
      setState(() {
        _sessions = sessions;
        _totalCount = total;
        _streak = streak;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return SizedBox(height: 100, child: Center(child: TDLoading(size: TDLoadingSize.medium)));
    }

    if (_sessions.isEmpty) {
      return Text(
        'Nessuna sessione precedente',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: context.phoenix.textTertiary,
        ),
      );
    }

    // Calculate stats
    final avgSeconds =
        _sessions.fold<int>(0, (s, e) => s + e.durationSeconds) ~/
            _sessions.length;
    final avgMins = avgSeconds ~/ 60;
    final avgSecs = avgSeconds % 60;

    // Trend: compare first half vs second half average
    final half = _sessions.length ~/ 2;
    String trend = '→';
    if (_sessions.length >= 4) {
      final firstHalf = _sessions.sublist(0, half);
      final secondHalf = _sessions.sublist(half);
      final firstAvg =
          firstHalf.fold<int>(0, (s, e) => s + e.durationSeconds) /
              firstHalf.length;
      final secondAvg =
          secondHalf.fold<int>(0, (s, e) => s + e.durationSeconds) /
              secondHalf.length;
      if (secondAvg > firstAvg * 1.1) {
        trend = '↑';
      } else if (secondAvg < firstAvg * 0.9) {
        trend = '↓';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats row — Stitch pattern 3.12
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: context.phoenix.border,
            ),
            boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat(label: 'Totali', value: '$_totalCount'),
              _MiniStat(label: 'Streak', value: '$_streak gg'),
              _MiniStat(label: 'Media', value: '${avgMins}m ${avgSecs}s'),
              _MiniStat(label: 'Trend', value: trend),
            ],
          ),
        ),

        const SizedBox(height: Spacing.md),

        // Trend chart — Stitch pattern 3.13
        Row(
          children: [
            const Icon(Icons.show_chart, color: PhoenixColors.conditioningAccent, size: 20),
            const SizedBox(width: Spacing.sm),
            Text('Ultimi 30 giorni',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          height: 150,
          child: _TrendChart(
            sessions: _sessions,
            isDark: isDark,
            showTemperature: widget.type == ConditioningType.cold,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: PhoenixColors.conditioningAccent,
          ),
        ),
        const SizedBox(height: Spacing.xxs),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: context.phoenix.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _TrendChart extends StatelessWidget {
  final List<ConditioningSession> sessions;
  final bool isDark;
  final bool showTemperature;

  const _TrendChart({
    required this.sessions,
    required this.isDark,
    this.showTemperature = false,
  });

  @override
  Widget build(BuildContext context) {
    final durationSpots = <FlSpot>[];
    final tempSpots = <FlSpot>[];

    for (var i = 0; i < sessions.length; i++) {
      final s = sessions[i];
      durationSpots.add(FlSpot(i.toDouble(), s.durationSeconds / 60.0));
      if (showTemperature && s.temperature != null) {
        tempSpots.add(FlSpot(i.toDouble(), s.temperature!));
      }
    }

    final maxDuration = durationSpots.isEmpty
        ? 5.0
        : durationSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 1;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxDuration,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxDuration > 10 ? 5 : 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark
                ? PhoenixColors.darkOverlay
                : PhoenixColors.lightElevated,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (sessions.length / 5).ceilToDouble().clamp(1, 10),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= sessions.length) {
                  return const SizedBox();
                }
                final d = sessions[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${d.day}/${d.month}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? PhoenixColors.darkTextTertiary
                          : PhoenixColors.lightTextTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(0)}m',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: durationSpots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: PhoenixColors.conditioningAccent,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 3,
                color: PhoenixColors.conditioningAccent,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: PhoenixColors.conditioningAccent.withAlpha(26),
            ),
          ),
        ],
        lineTouchData: const LineTouchData(enabled: false),
      ),
    );
  }
}
