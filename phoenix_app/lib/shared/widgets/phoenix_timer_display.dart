import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/design_tokens.dart';

/// Stitch-style timer display with digit boxes and primary colon.
/// Pattern 3.5 from stitch-redesign spec.
class PhoenixTimerDisplay extends StatelessWidget {
  final int minutes;
  final int seconds;
  final String? label;
  final Color? accentColor;

  const PhoenixTimerDisplay({
    super.key,
    required this.minutes,
    required this.seconds,
    this.label,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DigitBox(
              value: minutes.toString().padLeft(2, '0'),
              unitLabel: 'MIN',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: context.phoenix.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            _DigitBox(
              value: seconds.toString().padLeft(2, '0'),
              unitLabel: 'SEC',
            ),
          ],
        ),
        if (label != null) ...[
          const SizedBox(height: Spacing.md),
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              color: context.phoenix.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

class _DigitBox extends StatelessWidget {
  final String value;
  final String unitLabel;

  const _DigitBox({
    required this.value,
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80,
          width: 96,
          decoration: BoxDecoration(
            color: isDark
                ? PhoenixColors.darkElevated.withAlpha(128)
                : PhoenixColors.lightElevated,
            borderRadius: BorderRadius.circular(Radii.md),
            border: Border.all(
              color: context.phoenix.border,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: context.phoenix.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          unitLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: context.phoenix.textTertiary,
          ),
        ),
      ],
    );
  }
}
