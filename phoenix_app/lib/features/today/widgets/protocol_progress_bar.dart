import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';

/// Horizontal progress bar showing "N/6 Protocollo giornaliero".
class ProtocolProgressBar extends StatelessWidget {
  final int completed;
  final int total;

  const ProtocolProgressBar({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = context.phoenix.textPrimary;
    final progress = total > 0 ? completed / total : 0.0;
    final allDone = completed >= total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Protocollo giornaliero',
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            Text(
              '$completed/$total',
              style: PhoenixTypography.numeric.copyWith(
                color: allDone ? PhoenixColors.completed : textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: PhoenixColors.pending,
            valueColor: AlwaysStoppedAnimation(
              allDone ? PhoenixColors.completed : PhoenixColors.inProgress,
            ),
          ),
        ),
      ],
    );
  }
}
