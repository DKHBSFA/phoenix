import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../app/design_tokens.dart';
import '../../core/database/database.dart';
import '../../core/database/daos/biomarker_dao.dart';
import '../../core/database/tables.dart';
import '../../core/llm/llm_engine.dart';
import '../../core/llm/prompt_templates.dart';
import '../../core/models/supplement_engine.dart';
import '../coach/widgets/ai_insight_card.dart';
import 'widgets/supplement_card.dart';

/// Overview dashboard showing PhenoAge hero card + grid of key markers.
class BiomarkerDashboardTab extends StatelessWidget {
  final BiomarkerDao dao;
  final LlmEngine? llmEngine;
  final int? userAge;
  final String userSex;
  const BiomarkerDashboardTab({
    super.key,
    required this.dao,
    this.llmEngine,
    this.userAge,
    this.userSex = 'male',
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Biomarker>>(
      stream: dao.watchByType(BiomarkerType.bloodPanel),
      builder: (context, bloodSnap) {
        return StreamBuilder<List<Biomarker>>(
          stream: dao.watchByType(BiomarkerType.weight),
          builder: (context, weightSnap) {
            return StreamBuilder<List<Biomarker>>(
              stream: dao.watchByType(BiomarkerType.phenoage),
              builder: (context, phenoSnap) {
                final bloodPanels = bloodSnap.data ?? [];
                final weights = weightSnap.data ?? [];
                final phenoAges = phenoSnap.data ?? [];

                if (bloodPanels.isEmpty &&
                    weights.isEmpty &&
                    phenoAges.isEmpty) {
                  return _EmptyState();
                }

                return ListView(
                  padding: const EdgeInsets.all(Spacing.md),
                  children: [
                    // PhenoAge hero card
                    if (phenoAges.isNotEmpty)
                      _PhenoAgeHeroCard(entries: phenoAges),
                    if (phenoAges.isNotEmpty)
                      const SizedBox(height: Spacing.md),

                    // AI biomarker interpretation
                    if (llmEngine != null && bloodPanels.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.md),
                        child: AiInsightCard(
                          engine: llmEngine!,
                          template: BiomarkerInsightTemplate(),
                          context: {
                            'current_panel': bloodPanels.isNotEmpty
                                ? bloodPanels.first.valuesJson
                                : '{}',
                            'previous_panel': bloodPanels.length >= 2
                                ? bloodPanels[1].valuesJson
                                : '{}',
                            'sex': 'M',
                            'pheno_age': phenoAges.isNotEmpty
                                ? phenoAges.first.valuesJson
                                : 'N/A',
                            'chrono_age': 'N/A',
                          },
                          icon: Icons.psychology,
                          title: 'Interpretazione AI',
                          accentColor: PhoenixColors.biomarkersAccent,
                        ),
                      ),

                    // Key markers grid — Stitch pattern 3.13
                    if (bloodPanels.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.science, color: PhoenixColors.biomarkersAccent, size: 20),
                          const SizedBox(width: Spacing.sm),
                          Text('Marker principali',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  )),
                        ],
                      ),
                      const SizedBox(height: Spacing.sm),
                      _MarkerGrid(panels: bloodPanels),
                      const SizedBox(height: Spacing.md),
                    ],

                    // Weight summary
                    if (weights.isNotEmpty) ...[
                      _WeightSummaryCard(entries: weights),
                    ],

                    const SizedBox(height: Spacing.md),

                    // Supplement recommendations
                    if (bloodPanels.isNotEmpty) ...[
                      Builder(builder: (context) {
                        final engine = const SupplementEngine();
                        final latestJson = jsonDecode(
                                bloodPanels.first.valuesJson)
                            as Map<String, dynamic>;
                        final biomarkerMap = <String, double>{};
                        for (final e in latestJson.entries) {
                          if (e.value is num) {
                            biomarkerMap[e.key] =
                                (e.value as num).toDouble();
                          }
                        }
                        final age = userAge ?? 30;
                        final recs = engine.evaluate(
                          biomarkers: biomarkerMap,
                          age: age,
                          sex: userSex,
                        );
                        final missing =
                            engine.missingBiomarkers(biomarkerMap);
                        return SupplementSection(
                          recommendations: recs,
                          missingBiomarkers: missing,
                        );
                      }),
                    ],

                    // Disclaimer
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Spacing.md),
                      child: Text(
                        'I dati mostrati sono tracciati per consapevolezza personale. Interpretali sempre con il supporto del tuo medico.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.phoenix.textTertiary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_heart_outlined,
                size: 64,
                color: px.textQuaternary),
            const SizedBox(height: Spacing.md),
            Text('Nessun dato biomarker',
                style: TextStyle(
                  color: px.textSecondary,
                )),
            const SizedBox(height: Spacing.sm),
            Text(
              'Inserisci il tuo peso o le analisi del sangue per iniziare.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: px.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhenoAgeHeroCard extends StatelessWidget {
  final List<Biomarker> entries;
  const _PhenoAgeHeroCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final latest = entries.first;
    final latestValues =
        jsonDecode(latest.valuesJson) as Map<String, dynamic>;
    final phenoAge = latestValues['phenoage'];
    final chronoAge = latestValues['chronological_age'];

    if (phenoAge == null) return const SizedBox.shrink();

    final delta = chronoAge != null
        ? (phenoAge as num).toDouble() - (chronoAge as num).toDouble()
        : null;
    final isYounger = delta != null && delta < 0;

    // Sparkline from last 6 entries
    final sparkSpots = <FlSpot>[];
    final recent = entries.take(6).toList().reversed.toList();
    for (var i = 0; i < recent.length; i++) {
      final v = jsonDecode(recent[i].valuesJson) as Map<String, dynamic>;
      final pa = v['phenoage'];
      if (pa != null) {
        sparkSpots.add(FlSpot(i.toDouble(), (pa as num).toDouble()));
      }
    }

    // Trend arrow
    String trendArrow = '→';
    if (entries.length >= 2) {
      final prevValues =
          jsonDecode(entries[1].valuesJson) as Map<String, dynamic>;
      final prevAge = prevValues['phenoage'];
      if (prevAge != null && phenoAge != null) {
        final diff =
            (phenoAge as num).toDouble() - (prevAge as num).toDouble();
        trendArrow = diff < -0.5
            ? '↓'
            : diff > 0.5
                ? '↑'
                : '→';
      }
    }

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(
          color: context.phoenix.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PhenoAge',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: PhoenixColors.biomarkersAccent,
                  )),
          const SizedBox(height: Spacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${(phenoAge as num).toStringAsFixed(1)} anni',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: isYounger
                          ? PhoenixColors.success
                          : PhoenixColors.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: Spacing.sm),
              Text(trendArrow,
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          if (chronoAge != null && delta != null) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              'Età cronologica: $chronoAge → Δ ${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)} anni',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.phoenix.textSecondary,
                  ),
            ),
          ],
          if (sparkSpots.length >= 2) ...[
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sparkSpots,
                      isCurved: true,
                      color: PhoenixColors.biomarkersAccent,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: PhoenixColors.biomarkersAccent.withAlpha(26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MarkerGrid extends StatelessWidget {
  final List<Biomarker> panels;
  const _MarkerGrid({required this.panels});

  static const _displayMarkers = [
    ('glucose', 'Glicemia', 'mg/dL'),
    ('hscrp', 'hsCRP', 'mg/L'),
    ('hba1c', 'HbA1c', '%'),
    ('testosterone', 'Testosterone', 'ng/dL'),
    ('ferritin', 'Ferritina', 'µg/L'),
    ('wbc', 'Globuli bianchi', '×10³/µL'),
  ];

  @override
  Widget build(BuildContext context) {
    final latestValues =
        jsonDecode(panels.first.valuesJson) as Map<String, dynamic>;

    Map<String, dynamic>? prevValues;
    if (panels.length >= 2) {
      prevValues =
          jsonDecode(panels[1].valuesJson) as Map<String, dynamic>;
    }

    // Collect sparkline data for each marker
    final sparkData = <String, List<FlSpot>>{};
    final recent = panels.take(6).toList().reversed.toList();
    for (final (key, _, _) in _displayMarkers) {
      final spots = <FlSpot>[];
      for (var i = 0; i < recent.length; i++) {
        final v = jsonDecode(recent[i].valuesJson) as Map<String, dynamic>;
        if (v[key] != null) {
          spots.add(FlSpot(i.toDouble(), (v[key] as num).toDouble()));
        }
      }
      if (spots.length >= 2) sparkData[key] = spots;
    }

    // Filter to only show markers that have data
    final available = _displayMarkers
        .where((m) => latestValues[m.$1] != null)
        .toList();

    if (available.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Spacing.sm,
      crossAxisSpacing: Spacing.sm,
      childAspectRatio: 1.4,
      children: [
        for (final (key, label, unit) in available)
          _MarkerCard(
            label: label,
            value: latestValues[key],
            unit: unit,
            prevValue: prevValues?[key],
            sparkSpots: sparkData[key],
            markerKey: key,
          ),
      ],
    );
  }
}

class _MarkerCard extends StatelessWidget {
  final String label;
  final dynamic value;
  final String unit;
  final dynamic prevValue;
  final List<FlSpot>? sparkSpots;
  final String markerKey;

  const _MarkerCard({
    required this.label,
    required this.value,
    required this.unit,
    this.prevValue,
    this.sparkSpots,
    required this.markerKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final numValue = (value as num?)?.toDouble();
    final numPrev = (prevValue as num?)?.toDouble();

    // Determine delta direction and color
    String? deltaText;
    Color? deltaColor;
    if (numValue != null && numPrev != null) {
      final delta = numValue - numPrev;
      // For most markers, lower is better (except HDL, testosterone)
      const higherIsBetter = {'hdl', 'testosterone', 'albumin'};
      final improvement = higherIsBetter.contains(markerKey)
          ? delta > 0
          : delta < 0;
      deltaText = '${delta > 0 ? '↑' : '↓'} ${delta.abs().toStringAsFixed(1)}';
      deltaColor = improvement ? PhoenixColors.success : PhoenixColors.error;
    }

    final px = context.phoenix;

    return Container(
      padding: const EdgeInsets.all(Spacing.smMd),
      decoration: BoxDecoration(
        color: px.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: px.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: px.textSecondary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: Spacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  numValue != null
                      ? (numValue == numValue.roundToDouble()
                          ? numValue.toInt().toString()
                          : numValue.toStringAsFixed(1))
                      : '—',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Text(unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: px.textTertiary,
                      )),
            ],
          ),
          if (deltaText != null) ...[
            const SizedBox(height: Spacing.xxs),
            Text(deltaText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: deltaColor)),
          ],
          if (sparkSpots != null && sparkSpots!.isNotEmpty) ...[
            const Spacer(),
            SizedBox(
              height: 20,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sparkSpots!,
                      isCurved: true,
                      color: PhoenixColors.biomarkersAccent.withAlpha(179),
                      barWidth: 1.5,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeightSummaryCard extends StatelessWidget {
  final List<Biomarker> entries;
  const _WeightSummaryCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final latest = entries.first;
    final latestValues =
        jsonDecode(latest.valuesJson) as Map<String, dynamic>;
    final weight = (latestValues['kg'] as num?)?.toDouble();
    if (weight == null) return const SizedBox.shrink();

    double? delta;
    if (entries.length >= 2) {
      final prev =
          jsonDecode(entries[1].valuesJson) as Map<String, dynamic>;
      final prevWeight = (prev['kg'] as num?)?.toDouble();
      if (prevWeight != null) delta = weight - prevWeight;
    }

    final px = context.phoenix;

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(
          color: px.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Row(
        children: [
          Icon(Icons.monitor_weight_outlined,
              color: PhoenixColors.biomarkersAccent),
          const SizedBox(width: Spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Peso',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: px.textSecondary,
                      )),
              Text('${weight.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
            ],
          ),
          if (delta != null) ...[
            const Spacer(),
            Text(
              '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: delta.abs() < 0.1
                        ? px.textSecondary
                        : delta > 0
                            ? PhoenixColors.warning
                            : PhoenixColors.success,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
