import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../app/design_tokens.dart';
import '../../../core/models/supplement_engine.dart';

/// Displays supplement recommendations from the SupplementEngine.
class SupplementSection extends StatelessWidget {
  final List<SupplementRecommendation> recommendations;
  final List<String> missingBiomarkers;

  const SupplementSection({
    super.key,
    required this.recommendations,
    this.missingBiomarkers = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty && missingBiomarkers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.medication_outlined,
                color: PhoenixColors.biomarkersAccent, size: 20),
            const SizedBox(width: Spacing.sm),
            Text('Integratori suggeriti',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
          ],
        ),
        const SizedBox(height: Spacing.sm),

        // Recommendations
        for (final rec in recommendations) ...[
          _SupplementCard(recommendation: rec),
          const SizedBox(height: Spacing.sm),
        ],

        // Anti-recommendations
        if (recommendations.isNotEmpty)
          for (final anti in SupplementEngine.antiRecommendations) ...[
            _AntiRecommendationCard(anti: anti),
            const SizedBox(height: Spacing.sm),
          ],

        // Missing biomarkers prompt
        if (missingBiomarkers.isNotEmpty)
          _MissingBiomarkersCard(missing: missingBiomarkers),

        const SizedBox(height: Spacing.md),
      ],
    );
  }
}

class _SupplementCard extends StatefulWidget {
  final SupplementRecommendation recommendation;

  const _SupplementCard({required this.recommendation});

  @override
  State<_SupplementCard> createState() => _SupplementCardState();
}

class _SupplementCardState extends State<_SupplementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final rec = widget.recommendation;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final px = context.phoenix;

    final priorityColor = switch (rec.priority) {
      SupplementPriority.high => PhoenixColors.error,
      SupplementPriority.medium => PhoenixColors.warning,
      SupplementPriority.low => px.textTertiary,
      SupplementPriority.informative => PhoenixColors.biomarkersAccent,
    };

    final priorityLabel = switch (rec.priority) {
      SupplementPriority.high => 'Priorit\u00e0 alta',
      SupplementPriority.medium => 'Consigliato',
      SupplementPriority.low => 'Prevenzione',
      SupplementPriority.informative => 'Informativo',
    };

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: px.border),
          boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(rec.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                ),
                TDTag(
                  priorityLabel,
                  theme: switch (rec.priority) {
                    SupplementPriority.high => TDTagTheme.danger,
                    SupplementPriority.medium => TDTagTheme.warning,
                    SupplementPriority.low => TDTagTheme.defaultTheme,
                    SupplementPriority.informative => TDTagTheme.primary,
                  },
                  size: TDTagSize.small,
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),

            // Reason
            Text(rec.reason,
                style: TextStyle(
                  color: px.textSecondary,
                  fontSize: 13,
                )),

            // Dose
            const SizedBox(height: Spacing.xs),
            Row(
              children: [
                Icon(Icons.science_outlined,
                    size: 14, color: px.textTertiary),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(rec.dose,
                      style: TextStyle(
                        color: px.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      )),
                ),
              ],
            ),

            // Expanded details
            if (_expanded) ...[
              const SizedBox(height: Spacing.sm),
              _DetailRow(
                  icon: Icons.public,
                  label: 'Tradizione',
                  value: rec.traditionLabel),
              _DetailRow(
                  icon: Icons.schedule, label: 'Timing', value: rec.timing),
              if (rec.cycling != null)
                _DetailRow(
                    icon: Icons.autorenew,
                    label: 'Ciclizzazione',
                    value: rec.cycling!),
              _DetailRow(
                  icon: Icons.exit_to_app,
                  label: 'Uscita',
                  value: rec.exitCriteria),
              _DetailRow(
                  icon: Icons.menu_book,
                  label: 'Fonte',
                  value: rec.citation),
              for (final note in rec.notes)
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          size: 14, color: px.textTertiary),
                      const SizedBox(width: Spacing.xs),
                      Expanded(
                        child: Text(note,
                            style: TextStyle(
                              color: px.textSecondary,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                ),
              for (final w in rec.warnings)
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber,
                          size: 14, color: PhoenixColors.error),
                      const SizedBox(width: Spacing.xs),
                      Expanded(
                        child: Text(w,
                            style: TextStyle(
                              color: PhoenixColors.error,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                ),
            ],

            // Expand indicator
            if (!_expanded)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Center(
                  child: Icon(Icons.expand_more,
                      size: 16, color: px.textTertiary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: px.textTertiary),
          const SizedBox(width: Spacing.xs),
          Text('$label: ',
              style: TextStyle(
                color: px.textTertiary,
                fontSize: 12,
              )),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  color: px.textSecondary,
                  fontSize: 12,
                )),
          ),
        ],
      ),
    );
  }
}

class _AntiRecommendationCard extends StatelessWidget {
  final AntiRecommendation anti;

  const _AntiRecommendationCard({required this.anti});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final px = context.phoenix;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: PhoenixColors.error.withAlpha(isDark ? 25 : 15),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: PhoenixColors.error.withAlpha(51)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.block, size: 18, color: PhoenixColors.error),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${anti.name} — NON raccomandato',
                    style: TextStyle(
                      color: PhoenixColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    )),
                const SizedBox(height: Spacing.xxs),
                Text(anti.advice,
                    style: TextStyle(
                      color: px.textSecondary,
                      fontSize: 12,
                    )),
                Text(anti.citation,
                    style: TextStyle(
                      color: px.textTertiary,
                      fontSize: 11,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingBiomarkersCard extends StatelessWidget {
  final List<String> missing;

  const _MissingBiomarkersCard({required this.missing});

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: px.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: px.textTertiary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marker mancanti',
                    style: TextStyle(
                      color: px.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
                const SizedBox(height: Spacing.xxs),
                Text(
                  'Per raccomandazioni complete, inserisci: ${missing.join(", ")}',
                  style: TextStyle(
                    color: px.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
