import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/database/daos/biomarker_dao.dart';
import '../../core/models/phenoage_calculator.dart';

/// PhenoAge tab: shows biological age calculation, history, and missing markers checklist.
class PhenoAgeTab extends ConsumerWidget {
  final BiomarkerDao dao;
  const PhenoAgeTab({super.key, required this.dao});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return StreamBuilder<List<Biomarker>>(
      stream: dao.watchByType(BiomarkerType.phenoage),
      builder: (context, phenoSnap) {
        return StreamBuilder<List<Biomarker>>(
          stream: dao.watchByType(BiomarkerType.bloodPanel),
          builder: (context, bloodSnap) {
            final phenoEntries = phenoSnap.data ?? [];
            final bloodPanels = bloodSnap.data ?? [];

            // Check if we can calculate PhenoAge from latest blood panel
            Map<String, dynamic>? latestPanel;
            if (bloodPanels.isNotEmpty) {
              latestPanel = jsonDecode(bloodPanels.first.valuesJson)
                  as Map<String, dynamic>;
            }

            final chronoAge = _getChronoAge(profile);
            final canCalculate = latestPanel != null &&
                chronoAge != null &&
                PhenoAgeCalculator.missingMarkers(latestPanel).isEmpty;

            // Try to calculate if possible
            double? calculatedPhenoAge;
            if (canCalculate) {
              calculatedPhenoAge = PhenoAgeCalculator.calculate(
                chronologicalAge: chronoAge,
                albumin: _getDouble(latestPanel, 'albumin'),
                creatinine: _getDouble(latestPanel, 'creatinine'),
                glucose: _getDouble(latestPanel, 'glucose'),
                hscrp: _getDouble(latestPanel, 'hscrp'),
                lymphocytePct: _getDouble(latestPanel, 'lymphocytes_pct'),
                mcv: _getDouble(latestPanel, 'mcv'),
                rdw: _getDouble(latestPanel, 'rdw'),
                alkalinePhosphatase:
                    _getDouble(latestPanel, 'alkaline_phosphatase'),
                wbc: _getDouble(latestPanel, 'wbc'),
              );
            }

            if (phenoEntries.isEmpty && calculatedPhenoAge == null) {
              return _InsufficientDataView(
                latestPanel: latestPanel,
                chronoAge: chronoAge,
                onNavigateToBlood: () {
                  // Navigate to Sangue tab (index 1)
                  DefaultTabController.of(context).animateTo(1);
                },
              );
            }

            // Show latest PhenoAge (either calculated or from history)
            final displayAge = calculatedPhenoAge ??
                _getPhenoAgeFromEntry(phenoEntries.first);

            return ListView(
              padding: const EdgeInsets.all(Spacing.md),
              children: [
                // Hero card
                _PhenoAgeDisplay(
                  phenoAge: displayAge,
                  chronoAge: chronoAge,
                  isDark: isDark,
                ),
                const SizedBox(height: Spacing.md),

                // Save button if newly calculated
                if (calculatedPhenoAge != null && chronoAge != null)
                  _SaveCalculationButton(
                    phenoAge: calculatedPhenoAge,
                    chronoAge: chronoAge,
                    dao: dao,
                  ),

                // History chart — Stitch pattern 3.13
                if (phenoEntries.length >= 2) ...[
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      const Icon(Icons.timeline, color: PhoenixColors.biomarkersAccent, size: 20),
                      const SizedBox(width: Spacing.sm),
                      Text('Storico',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  SizedBox(
                    height: 200,
                    child: _HistoryChart(entries: phenoEntries),
                  ),
                ],

                // Markers used
                // Stitch pattern 3.13
                if (latestPanel != null) ...[
                  const SizedBox(height: Spacing.lg),
                  Row(
                    children: [
                      const Icon(Icons.checklist, color: PhoenixColors.biomarkersAccent, size: 20),
                      const SizedBox(width: Spacing.sm),
                      Text('Marker utilizzati',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  _MarkersList(panel: latestPanel),
                ],
              ],
            );
          },
        );
      },
    );
  }

  int? _getChronoAge(UserProfile? profile) {
    if (profile == null) return null;
    final now = DateTime.now();
    return now.year - profile.birthYear;
  }

  double? _getDouble(Map<String, dynamic> map, String key) {
    final v = map[key];
    if (v == null) return null;
    return (v as num).toDouble();
  }

  double? _getPhenoAgeFromEntry(Biomarker entry) {
    final values = jsonDecode(entry.valuesJson) as Map<String, dynamic>;
    final pa = values['phenoage'];
    return pa != null ? (pa as num).toDouble() : null;
  }
}

class _PhenoAgeDisplay extends StatelessWidget {
  final double? phenoAge;
  final int? chronoAge;
  final bool isDark;

  const _PhenoAgeDisplay({
    required this.phenoAge,
    required this.chronoAge,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (phenoAge == null) {
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
        child: Text(
          'Impossibile calcolare PhenoAge con i dati attuali.',
          style: TextStyle(
            color: context.phoenix.textSecondary,
          ),
        ),
      );
    }

    final delta =
        chronoAge != null ? phenoAge! - chronoAge!.toDouble() : null;
    final isYounger = delta != null && delta < 0;

    return Container(
      width: double.infinity,
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
        children: [
          Text('Età biologica',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: PhoenixColors.biomarkersAccent,
                  )),
          const SizedBox(height: Spacing.sm),
          Text(
            phenoAge!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: isYounger
                      ? PhoenixColors.success
                      : PhoenixColors.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text('anni',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.phoenix.textSecondary,
                  )),
          if (delta != null) ...[
            const SizedBox(height: Spacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md, vertical: Spacing.sm),
              decoration: BoxDecoration(
                color: (isYounger
                        ? PhoenixColors.success
                        : PhoenixColors.error)
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(Radii.full),
              ),
              child: Text(
                'Età cronologica: $chronoAge → Δ ${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)} anni',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          isYounger ? PhoenixColors.success : PhoenixColors.error,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SaveCalculationButton extends StatefulWidget {
  final double phenoAge;
  final int chronoAge;
  final BiomarkerDao dao;

  const _SaveCalculationButton({
    required this.phenoAge,
    required this.chronoAge,
    required this.dao,
  });

  @override
  State<_SaveCalculationButton> createState() =>
      _SaveCalculationButtonState();
}

class _SaveCalculationButtonState extends State<_SaveCalculationButton> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    if (_saved) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: PhoenixColors.success, size: 20),
            const SizedBox(width: Spacing.sm),
            Text('Salvato',
                style: TextStyle(color: PhoenixColors.success)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: TDButton(
        text: 'Salva calcolo PhenoAge',
        icon: Icons.save_outlined,
        type: TDButtonType.outline,
        theme: TDButtonTheme.defaultTheme,
        size: TDButtonSize.large,
        onTap: _savePhenoAge,
      ),
    );
  }

  Future<void> _savePhenoAge() async {
    await widget.dao.addBiomarker(BiomarkersCompanion.insert(
      date: DateTime.now(),
      type: BiomarkerType.phenoage,
      valuesJson: jsonEncode({
        'phenoage': widget.phenoAge,
        'chronological_age': widget.chronoAge,
      }),
    ));
    if (mounted) setState(() => _saved = true);
  }
}

class _HistoryChart extends StatelessWidget {
  final List<Biomarker> entries;

  const _HistoryChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    final reversed = entries.reversed.toList();
    for (var i = 0; i < reversed.length; i++) {
      final v = jsonDecode(reversed[i].valuesJson) as Map<String, dynamic>;
      final pa = v['phenoage'];
      if (pa != null) {
        spots.add(FlSpot(i.toDouble(), (pa as num).toDouble()));
      }
    }

    if (spots.length < 2) return const SizedBox.shrink();

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
                v.toInt().toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: context.phoenix.textTertiary,
                ),
              ),
            ),
          ),
          bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: PhoenixColors.biomarkersAccent,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: PhoenixColors.biomarkersAccent.withAlpha(26),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsufficientDataView extends StatelessWidget {
  final Map<String, dynamic>? latestPanel;
  final int? chronoAge;
  final VoidCallback onNavigateToBlood;

  const _InsufficientDataView({
    required this.latestPanel,
    required this.chronoAge,
    required this.onNavigateToBlood,
  });

  @override
  Widget build(BuildContext context) {
    final missing = latestPanel != null
        ? PhenoAgeCalculator.missingMarkers(latestPanel!)
        : PhenoAgeCalculator.requiredMarkers;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.science,
                size: 64,
                color: context.phoenix.textQuaternary),
            const SizedBox(height: Spacing.md),
            Text(
              'Per calcolare PhenoAge servono 9 marker specifici',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.phoenix.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (chronoAge == null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                'Serve anche l\'anno di nascita nel profilo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: PhoenixColors.warning, fontWeight: FontWeight.w500),
              ),
            ],
            const SizedBox(height: Spacing.md),

            // Checklist
            for (final key in PhenoAgeCalculator.requiredMarkers)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      missing.contains(key)
                          ? Icons.close
                          : Icons.check_circle,
                      size: 18,
                      color: missing.contains(key)
                          ? PhoenixColors.error
                          : PhoenixColors.success,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      PhenoAgeCalculator.markerLabels[key] ?? key,
                      style: TextStyle(
                        color: missing.contains(key)
                            ? context.phoenix.textPrimary
                            : PhoenixColors.success,
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      PhenoAgeCalculator.markerUnits[key] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.phoenix.textTertiary,
                          ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: Spacing.lg),
            FilledButton.icon(
              onPressed: onNavigateToBlood,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Inserisci analisi sangue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkersList extends StatelessWidget {
  final Map<String, dynamic> panel;

  const _MarkersList({required this.panel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final key in PhenoAgeCalculator.requiredMarkers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    PhenoAgeCalculator.markerLabels[key] ?? key,
                    style: TextStyle(
                      color: context.phoenix.textSecondary,
                    ),
                  ),
                ),
                Text(
                  panel[key] != null
                      ? '${panel[key]} ${PhenoAgeCalculator.markerUnits[key] ?? ''}'
                      : '—',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: panel[key] != null
                        ? context.phoenix.textPrimary
                        : PhoenixColors.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
