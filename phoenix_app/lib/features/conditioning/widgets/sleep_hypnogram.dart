import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../../../core/ring/sleep_parser.dart';

/// Visual sleep stage timeline using fl_chart.
class SleepHypnogram extends StatelessWidget {
  final List<SleepPeriod> stages;
  const SleepHypnogram({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) return const SizedBox.shrink();

    // Map stage to Y value: deep=0, light=1, rem=2, awake=3
    double stageY(SleepStage s) => switch (s) {
          SleepStage.deep => 0,
          SleepStage.light => 1,
          SleepStage.rem => 2,
          SleepStage.awake => 3,
        };

    Color stageColor(SleepStage s) => switch (s) {
          SleepStage.deep => const Color(0xFF1A237E),
          SleepStage.light => const Color(0xFF42A5F5),
          SleepStage.rem => const Color(0xFFAB47BC),
          SleepStage.awake => PhoenixColors.warning,
        };

    final firstStart = stages.first.start;

    // Scatter plot showing sleep stages over time
    final spots = <ScatterSpot>[];
    for (final s in stages) {
      // Create dots every 5 minutes
      var t = s.start;
      while (t.isBefore(s.end)) {
        final x = t.difference(firstStart).inMinutes.toDouble();
        final y = stageY(s.stage);
        spots.add(ScatterSpot(
          x,
          y,
          dotPainter: FlDotCirclePainter(radius: 4, color: stageColor(s.stage)),
        ));
        t = t.add(const Duration(minutes: 5));
      }
    }

    final totalMinutes = stages.last.end.difference(firstStart).inMinutes;

    return SizedBox(
      height: 100,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: spots,
          scatterTouchData: ScatterTouchData(enabled: false),
          minX: 0,
          maxX: totalMinutes.toDouble(),
          minY: -0.5,
          maxY: 3.5,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (v, _) => Text(
                  switch (v.toInt()) {
                    0 => 'Deep',
                    1 => 'Light',
                    2 => 'REM',
                    3 => 'Sveglio',
                    _ => '',
                  },
                  style: TextStyle(fontSize: 9, color: context.phoenix.textTertiary),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 60,
                getTitlesWidget: (v, _) {
                  final dt = firstStart.add(Duration(minutes: v.toInt()));
                  return Text(
                    '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 9, color: context.phoenix.textTertiary),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
