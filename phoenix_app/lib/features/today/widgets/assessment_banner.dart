import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';

/// Shows an assessment banner when the periodic assessment is due (every 4 weeks).
/// Appears at the bottom of the Today screen protocol list.
class AssessmentBanner extends ConsumerWidget {
  const AssessmentBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;
    final surfaceColor = p.surface;
    final borderColor = p.border;

    final assessmentDao = ref.watch(assessmentDaoProvider);

    return FutureBuilder<bool>(
      future: assessmentDao.isAssessmentDue(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final isDue = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.sm,
          ),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, PhoenixRouter.assessment);
            },
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(
                  color: isDue ? PhoenixColors.completed : borderColor,
                  width: isDue ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.all(Spacing.md),
              child: Row(
                children: [
                  Icon(
                    isDue ? Icons.fitness_center : Icons.schedule,
                    color: isDue ? PhoenixColors.completed : subtitleColor,
                    size: 24,
                  ),
                  const SizedBox(width: Spacing.smMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDue
                              ? 'Assessment disponibile'
                              : 'Assessment periodico',
                          style: PhoenixTypography.bodyLarge.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        FutureBuilder<int>(
                          future: assessmentDao.daysUntilDue(),
                          builder: (context, daysSnap) {
                            final daysLeft = daysSnap.data ?? 0;
                            return Text(
                              isDue
                                  ? 'Misura i tuoi progressi — 5 test validati'
                                  : 'Prossimo tra $daysLeft giorni',
                              style: PhoenixTypography.bodyMedium
                                  .copyWith(color: subtitleColor),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: subtitleColor,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
