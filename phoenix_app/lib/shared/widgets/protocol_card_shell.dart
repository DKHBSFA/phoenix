import 'package:flutter/material.dart';

import '../../app/design_tokens.dart';

/// Shared card shell for protocol items on the Today screen.
/// Used by TrainingCard, FastingCard, NutritionCard, ColdCard,
/// MeditationCard, and SleepCard.
class ProtocolCardShell extends StatelessWidget {
  final String title;
  final bool completed;
  final Color borderColor;
  final Color surfaceColor;
  final Widget child;

  const ProtocolCardShell({
    super.key,
    required this.title,
    required this.completed,
    required this.borderColor,
    required this.surfaceColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = context.phoenix.textTertiary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xs + 2,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: PhoenixTypography.caption.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  completed ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 20,
                  color: completed ? PhoenixColors.completed : titleColor,
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}
