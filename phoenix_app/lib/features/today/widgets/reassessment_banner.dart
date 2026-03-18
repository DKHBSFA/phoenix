import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';

/// Shows a banner when the 3-month physical reassessment is due.
/// Reads nextReassessmentDate from settings.
class ReassessmentBanner extends ConsumerWidget {
  const ReassessmentBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final nextDateStr = settings.nextReassessmentDate;
    if (nextDateStr == null) return const SizedBox.shrink();

    final nextDate = DateTime.tryParse(nextDateStr);
    if (nextDate == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final isDue = now.isAfter(nextDate);
    final daysUntil = nextDate.difference(now).inDays;

    // Don't show if more than 14 days away
    if (!isDue && daysUntil > 14) return const SizedBox.shrink();

    final p = context.phoenix;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: p.surface,
          border: Border.all(
            color: isDue ? PhoenixColors.completed : p.border,
            width: isDue ? Borders.medium : Borders.thin,
          ),
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            Icon(
              isDue ? Icons.medical_services_outlined : Icons.schedule,
              color: isDue ? PhoenixColors.completed : p.textSecondary,
              size: 24,
            ),
            const SizedBox(width: Spacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDue
                        ? 'Check-up fisico disponibile'
                        : 'Check-up fisico',
                    style: PhoenixTypography.bodyLarge.copyWith(
                      color: p.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    isDue
                        ? 'Aggiorna il tuo assessment e il programma di allenamento'
                        : 'Prossimo tra $daysUntil giorni',
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: p.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
