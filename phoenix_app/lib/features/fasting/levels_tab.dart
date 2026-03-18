import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/models/extended_fast.dart';
import '../../core/models/nutrition_calculator.dart';

class LevelsTab extends ConsumerWidget {
  const LevelsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        _LevelCard(level: 1, index: 0),
        const SizedBox(height: Spacing.cardGap),
        _LevelCard(level: 2, index: 1),
        const SizedBox(height: Spacing.cardGap),
        _LevelCard(level: 3, index: 2),
      ],
    );
  }
}

class _LevelCard extends ConsumerWidget {
  final int level;
  final int index;

  const _LevelCard({required this.level, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fastingDao = ref.watch(fastingDaoProvider);

    return FutureBuilder(
      future: Future.wait([
        fastingDao.getLevelStats(level),
        if (level > 1) fastingDao.canAdvanceToLevel(level) else Future.value(true),
      ]),
      builder: (context, snapshot) {
        final stats = snapshot.data?[0];
        final canAdvance = level == 1 ? true : (snapshot.data?[1] as bool? ?? false);

        final total = stats is ({int total, int goodTolerance})
            ? stats.total
            : 0;
        final goodTolerance = stats is ({int total, int goodTolerance})
            ? stats.goodTolerance
            : 0;

        // Determine status
        final _LevelStatus status;
        if (level == 1) {
          status = total > 0 ? _LevelStatus.inProgress : _LevelStatus.locked;
        } else {
          if (total > 0) {
            status = _LevelStatus.inProgress;
          } else if (canAdvance) {
            status = _LevelStatus.unlocked;
          } else {
            status = _LevelStatus.locked;
          }
        }

        // Criteria
        final criteria = _getCriteria(level, total, goodTolerance);

        return Container(
          padding: const EdgeInsets.all(CardTokens.padding),
          decoration: BoxDecoration(
            color:
                isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
            borderRadius: BorderRadius.circular(CardTokens.borderRadius),
            border: Border.all(
              color: status == _LevelStatus.locked
                  ? (isDark
                      ? PhoenixColors.darkBorder
                      : PhoenixColors.lightBorder)
                  : PhoenixColors.fastingAccent.withAlpha(60),
              width: status == _LevelStatus.locked ? 1 : 2,
            ),
            boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  _statusIcon(status),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'Livello $level',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm, vertical: Spacing.xxs),
                    decoration: BoxDecoration(
                      color: PhoenixColors.fastingAccent.withAlpha(30),
                      borderRadius: BorderRadius.circular(Radii.full),
                    ),
                    child: Text(
                      NutritionCalculator.levelTargetLabel(level),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: PhoenixColors.fastingAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                NutritionCalculator.levelDescription(level),
                style: TextStyle(
                    color: isDark
                        ? PhoenixColors.darkTextSecondary
                        : PhoenixColors.lightTextSecondary),
              ),

              if (level == 3) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  'Livello opzionale per utenti avanzati',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? PhoenixColors.darkTextTertiary
                        : PhoenixColors.lightTextTertiary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                // Extended fast protocols summary
                Container(
                  padding: const EdgeInsets.all(Spacing.smMd),
                  decoration: BoxDecoration(
                    color: PhoenixColors.fastingAccent.withAlpha(15),
                    borderRadius: BorderRadius.circular(Radii.sm),
                    border: Border.all(
                      color: PhoenixColors.fastingAccent.withAlpha(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protocolli disponibili:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? PhoenixColors.darkTextPrimary
                              : PhoenixColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      _protocolRow('Digiuno idrico', '72-120h', isDark),
                      _protocolRow('FMD (Longo)', '5 giorni', isDark),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        'Max 1 ciclo ogni ${FmdProtocol.minDaysBetweenCycles} giorni · '
                        'Max ${FmdProtocol.maxCyclesPerYear} cicli/anno',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? PhoenixColors.darkTextTertiary
                              : PhoenixColors.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: Spacing.md),

              // Criteria checklist — Stitch pattern 3.14 numbered steps
              ...criteria.asMap().entries.map((entry) {
                final idx = entry.key;
                final c = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.met
                              ? PhoenixColors.success
                              : (isDark
                                  ? PhoenixColors.darkOverlay
                                  : PhoenixColors.lightElevated),
                          border: c.met
                              ? null
                              : Border.all(
                                  color: isDark
                                      ? PhoenixColors.darkBorder
                                      : PhoenixColors.lightBorder,
                                ),
                        ),
                        child: Center(
                          child: c.met
                              ? const Icon(Icons.check, size: 16, color: PhoenixColors.darkTextPrimary)
                              : Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? PhoenixColors.darkTextSecondary
                                        : PhoenixColors.lightTextSecondary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: Spacing.smMd),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            c.label,
                            style: TextStyle(
                              fontSize: 13,
                              color: c.met
                                  ? (isDark
                                      ? PhoenixColors.darkTextPrimary
                                      : PhoenixColors.lightTextPrimary)
                                  : (isDark
                                      ? PhoenixColors.darkTextSecondary
                                      : PhoenixColors.lightTextSecondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Unlock button (if applicable)
              if (status == _LevelStatus.unlocked && level > 1) ...[
                const SizedBox(height: Spacing.md),
                TDButton(
                  text: 'Avanza a questo livello',
                  icon: Icons.arrow_upward,
                  type: TDButtonType.outline,
                  theme: TDButtonTheme.defaultTheme,
                  size: TDButtonSize.large,
                  isBlock: true,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _showAdvanceDialog(context);
                  },
                ),
              ],
            ],
          ),
        )
            .animate()
            .fadeIn(
                duration: AnimDurations.normal,
                delay: AnimDurations.stagger * (index + 1))
            .slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _protocolRow(String name, String duration, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(Icons.circle, size: 4,
            color: PhoenixColors.fastingAccent.withAlpha(120)),
          const SizedBox(width: Spacing.sm),
          Text(name,
            style: TextStyle(fontSize: 12,
              color: isDark ? PhoenixColors.darkTextSecondary
                  : PhoenixColors.lightTextSecondary)),
          const Spacer(),
          Text(duration,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              color: isDark ? PhoenixColors.darkTextPrimary
                  : PhoenixColors.lightTextPrimary)),
        ],
      ),
    );
  }

  Widget _statusIcon(_LevelStatus status) {
    return switch (status) {
      _LevelStatus.inProgress => const Icon(Icons.sync,
          color: PhoenixColors.fastingAccent, size: 20),
      _LevelStatus.unlocked => const Icon(Icons.lock_open,
          color: PhoenixColors.success, size: 20),
      _LevelStatus.locked => Icon(Icons.lock,
          color: PhoenixColors.darkTextTertiary, size: 20),
    };
  }

  // Level advancement thresholds
  static const _level1TotalRequired = 7;
  static const _level1GoodToleranceRequired = 5;
  static const _level2TotalRequired = 14;
  static const _level2GoodToleranceRequired = 10;

  List<_Criterion> _getCriteria(int level, int total, int goodTolerance) {
    return switch (level) {
      1 => [
          _Criterion('Almeno $_level1TotalRequired digiuni completati ($total/$_level1TotalRequired)', total >= _level1TotalRequired),
          _Criterion(
              'Tolleranza ≥ 3/5 per $_level1GoodToleranceRequired digiuni ($goodTolerance/$_level1GoodToleranceRequired)',
              goodTolerance >= _level1GoodToleranceRequired),
          _Criterion('Peso stabile (±1kg) per 7 giorni', false),
          _Criterion('Energia soggettiva ≥ 3/5', goodTolerance >= _level1GoodToleranceRequired),
        ],
      2 => [
          _Criterion('Almeno $_level2TotalRequired digiuni completati ($total/$_level2TotalRequired)', total >= _level2TotalRequired),
          _Criterion(
              'Tolleranza media ≥ 3/5 per $_level2GoodToleranceRequired digiuni ($goodTolerance/$_level2GoodToleranceRequired)',
              goodTolerance >= _level2GoodToleranceRequired),
          _Criterion('Sonno > 7h per 7 giorni', false),
          _Criterion('Glicemia stabile (se misurata)', false),
        ],
      3 => [
          _Criterion(
              '≥${Level3Criteria.requiredLevel2Fasts} digiuni L2 completati (≥24h, tolleranza ≥3/5)',
              total >= Level3Criteria.requiredLevel2Fasts),
          _Criterion('Disclaimer medico accettato (valido 90gg)', false),
          _Criterion('Pannello ematico recente (ultimi 30gg)', false),
          _Criterion('BMI ≥ ${ExtendedFastProtocol.minBmi}', false),
        ],
      _ => [],
    };
  }

  void _showAdvanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Avanzare al livello $level?'),
        content: Text(
          'Hai completato i criteri del livello ${level - 1}. '
          'Il livello $level prevede digiuni di '
          '${NutritionCalculator.levelTargetLabel(level)}.',
        ),
        actions: [
          TDButton(
            text: 'Non ancora',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx),
          ),
          TDButton(
            text: 'Avanza',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () {
              Navigator.pop(ctx);
              // Level advancement is implicit — the user just starts
              // fasting at the next level target hours
              TDToast.showSuccess('Livello $level sbloccato! Selezionalo al prossimo digiuno.', context: context);
            },
          ),
        ],
      ),
    );
  }
}

enum _LevelStatus { inProgress, unlocked, locked }

class _Criterion {
  final String label;
  final bool met;
  const _Criterion(this.label, this.met);
}
