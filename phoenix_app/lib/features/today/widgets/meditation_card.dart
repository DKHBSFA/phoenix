import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/design_tokens.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

class MeditationCard extends StatelessWidget {
  final bool completed;

  const MeditationCard({super.key, required this.completed});

  @override
  Widget build(BuildContext context) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return ProtocolCardShell(
      title: 'MEDITAZIONE',
      completed: completed,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            completed ? 'Completata' : 'Box breathing · 5 min',
            style: PhoenixTypography.bodyLarge.copyWith(
              color: completed ? subtitleColor : textColor,
            ),
          ),
          if (!completed) ...[
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, PhoenixRouter.conditioning);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: textColor),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: const Text('Inizia'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
