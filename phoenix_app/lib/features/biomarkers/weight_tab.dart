import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/database/daos/biomarker_dao.dart';

/// Weight tracking tab with trend chart, 7-day moving average, and quick add.
class WeightTab extends ConsumerStatefulWidget {
  final BiomarkerDao dao;
  const WeightTab({super.key, required this.dao});

  @override
  ConsumerState<WeightTab> createState() => _WeightTabState();
}

class _WeightTabState extends ConsumerState<WeightTab> {
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return StreamBuilder<List<Biomarker>>(
      stream: widget.dao.watchByType(BiomarkerType.weight),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return _EmptyWeightState(
            controller: _weightController,
            onSave: _saveWeight,
          );
        }

        final entries = data.reversed.toList();
        final latest = entries.last;
        final latestValues = _parseValuesJson(latest.valuesJson);
        final currentWeight = (latestValues?['kg'] as num?)?.toDouble();

        // Build data points
        final weights = <_WeightPoint>[];
        for (final entry in entries) {
          final v = _parseValuesJson(entry.valuesJson);
          final kg = (v?['kg'] as num?)?.toDouble();
          if (kg != null) {
            weights.add(_WeightPoint(date: entry.date, kg: kg));
          }
        }

        // Calculate 7-day moving average
        final movingAvg = _calculateMovingAverage(weights, 7);

        // Stats
        final firstWeight = weights.isNotEmpty ? weights.first.kg : null;
        final deltaTotal = currentWeight != null && firstWeight != null
            ? currentWeight - firstWeight
            : null;

        double? deltaWeek;
        if (weights.length >= 2) {
          final weekAgo = DateTime.now().subtract(const Duration(days: 7));
          final weekEntry = weights.lastWhere(
            (w) => w.date.isBefore(weekAgo),
            orElse: () => weights.first,
          );
          deltaWeek = currentWeight != null ? currentWeight - weekEntry.kg : null;
        }

        // BMI
        double? bmi;
        if (currentWeight != null && profile != null && profile.heightCm > 0) {
          final heightM = profile.heightCm / 100;
          bmi = currentWeight / (heightM * heightM);
        }

        return ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // Stats row
            _StatsRow(
              currentWeight: currentWeight,
              deltaTotal: deltaTotal,
              deltaWeek: deltaWeek,
              bmi: bmi,
              isDark: isDark,
            ),
            const SizedBox(height: Spacing.md),

            // Chart
            SizedBox(
              height: 220,
              child: _WeightChart(
                weights: weights,
                movingAvg: movingAvg,
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // Quick add
            _QuickAddRow(
              controller: _weightController,
              onSave: _saveWeight,
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveWeight() async {
    final kg = double.tryParse(_weightController.text.trim());
    if (kg == null || kg <= 0) return;

    await widget.dao.addBiomarker(BiomarkersCompanion.insert(
      date: DateTime.now(),
      type: BiomarkerType.weight,
      valuesJson: jsonEncode({'kg': kg}),
    ));

    // Keep user profile weight in sync
    await ref.read(userProfileDaoProvider).updateWeight(kg);

    _weightController.clear();
  }

  static Map<String, dynamic>? _parseValuesJson(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }

  List<_WeightPoint> _calculateMovingAverage(
      List<_WeightPoint> data, int window) {
    if (data.length < window) return [];
    final result = <_WeightPoint>[];
    for (var i = window - 1; i < data.length; i++) {
      var sum = 0.0;
      for (var j = 0; j < window; j++) {
        sum += data[i - j].kg;
      }
      result.add(_WeightPoint(
        date: data[i].date,
        kg: sum / window,
      ));
    }
    return result;
  }
}

class _WeightPoint {
  final DateTime date;
  final double kg;
  const _WeightPoint({required this.date, required this.kg});
}

class _StatsRow extends StatelessWidget {
  final double? currentWeight;
  final double? deltaTotal;
  final double? deltaWeek;
  final double? bmi;
  final bool isDark;

  const _StatsRow({
    required this.currentWeight,
    required this.deltaTotal,
    required this.deltaWeek,
    required this.bmi,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Attuale',
            value: currentWeight != null
                ? '${currentWeight!.toStringAsFixed(1)} kg'
                : '—',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: _StatCard(
            label: 'Settimana',
            value: deltaWeek != null
                ? '${deltaWeek! > 0 ? '+' : ''}${deltaWeek!.toStringAsFixed(1)} kg'
                : '—',
            color: deltaWeek != null
                ? (deltaWeek!.abs() < 0.1
                    ? null
                    : deltaWeek! > 0
                        ? PhoenixColors.warning
                        : PhoenixColors.success)
                : null,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: _StatCard(
            label: 'BMI',
            value: bmi != null ? bmi!.toStringAsFixed(1) : '—',
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.smMd),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: context.phoenix.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: context.phoenix.textSecondary,
              )),
          const SizedBox(height: Spacing.xs),
          Text(value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  )),
        ],
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  final List<_WeightPoint> weights;
  final List<_WeightPoint> movingAvg;

  const _WeightChart({
    required this.weights,
    required this.movingAvg,
  });

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < weights.length; i++) {
      spots.add(FlSpot(i.toDouble(), weights[i].kg));
    }

    final maSpots = <FlSpot>[];
    if (movingAvg.isNotEmpty) {
      final offset = weights.length - movingAvg.length;
      for (var i = 0; i < movingAvg.length; i++) {
        maSpots.add(FlSpot((i + offset).toDouble(), movingAvg[i].kg));
      }
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: context.phoenix.border,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (v, meta) => Text(
                v.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 11,
                  color: context.phoenix.textTertiary,
                ),
              ),
            ),
          ),
          bottomTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Raw weight points
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: PhoenixColors.biomarkersAccent,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 3,
                color: PhoenixColors.biomarkersAccent,
                strokeWidth: 0,
              ),
            ),
          ),
          // 7-day moving average
          if (maSpots.isNotEmpty)
            LineChartBarData(
              spots: maSpots,
              isCurved: true,
              color: PhoenixColors.biomarkersAccent.withAlpha(128),
              barWidth: 2,
              dotData: const FlDotData(show: false),
              dashArray: [5, 3],
            ),
        ],
      ),
    );
  }
}

class _QuickAddRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;

  const _QuickAddRow({required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (_) => onSave(),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        _BrutalistAddButton(onTap: onSave),
      ],
    );
  }
}

class _EmptyWeightState extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;

  const _EmptyWeightState({
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_weight_outlined,
                size: 64,
                color: context.phoenix.textQuaternary),
            const SizedBox(height: Spacing.md),
            Text('Nessun dato peso',
                style: TextStyle(
                  color: context.phoenix.textSecondary,
                )),
            const SizedBox(height: Spacing.lg),
            _QuickAddRow(controller: controller, onSave: onSave),
          ],
        ),
      ),
    );
  }
}

class _BrutalistAddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BrutalistAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? Colors.white : Colors.black,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.smMd,
          ),
          child: Text(
            '+ PESO',
            style: PhoenixTypography.button.copyWith(
              color: isDark ? Colors.black : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
