import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';

class NumberedSteps extends StatelessWidget {
  final List<String> steps;

  const NumberedSteps({super.key, required this.steps});

  /// Parse execution cues string into individual steps.
  static List<String> parseSteps(String cues) {
    if (cues.isEmpty) return [];
    return cues
        .split(RegExp(r'\.\s+'))
        .where((s) => s.trim().length > 3)
        .map((s) => s.trim().endsWith('.') ? s.trim() : '${s.trim()}.')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return Column(
      children: List.generate(steps.length, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i < steps.length - 1 ? Spacing.sm : 0),
          child: _StepRow(number: i + 1, text: steps[i]),
        );
      }),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? PhoenixColors.darkElevated : PhoenixColors.lightElevated;
    final numberColor = context.phoenix.textPrimary;
    final textColor =
        isDark ? PhoenixColors.darkTextSecondary : PhoenixColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: numberColor.withAlpha(26),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: numberColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
