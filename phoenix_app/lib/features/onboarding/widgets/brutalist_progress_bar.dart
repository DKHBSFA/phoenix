import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';

/// Brutalist download progress bar: 2px border, left-to-right fill.
/// Reusable across onboarding and anywhere a download/progress bar is needed.
class BrutalistProgressBar extends StatelessWidget {
  final double progress; // 0.0 → 1.0
  final bool isDark;

  const BrutalistProgressBar({
    super.key,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = context.phoenix.border;
    final fillColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: Borders.medium,
        ),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(color: fillColor),
      ),
    );
  }
}
