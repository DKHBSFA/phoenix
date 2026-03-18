import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/design_tokens.dart';
import '../../../app/router.dart';
import '../../../core/models/daily_protocol.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

class FastingCard extends StatelessWidget {
  final FastingStatus status;

  const FastingCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    final completed = status.status == ActivityStatus.completed;
    final active = status.status == ActivityStatus.inProgress;

    return ProtocolCardShell(
      title: 'DIGIUNO',
      completed: completed,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (completed)
            Text(
              '${status.hoursCompleted}h completate',
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            )
          else if (active) ...[
            Text(
              '${status.hoursCompleted}h / ${status.targetHours.round()}h',
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              'Acqua: ${status.waterCount} bicchieri',
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
          ] else ...[
            Text(
              'Non iniziato',
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, PhoenixRouter.fasting);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: textColor),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: const Text('Inizia digiuno'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
