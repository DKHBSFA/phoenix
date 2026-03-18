import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';

class CoachMessage extends StatelessWidget {
  final String message;

  const CoachMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;
    final borderColor = p.border;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 1,
                color: borderColor,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                'Messaggio del Coach',
                style: PhoenixTypography.caption.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(child: Container(height: 1, color: borderColor)),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Text(
            '"$message"',
            style: PhoenixTypography.bodyLarge.copyWith(
              color: textColor,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
