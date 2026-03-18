import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../app/design_tokens.dart';

class MuscleBadge extends StatelessWidget {
  final String muscle;
  final bool isPrimary;

  const MuscleBadge({
    super.key,
    required this.muscle,
    this.isPrimary = true,
  });

  /// Parse comma-separated muscle string into individual names.
  static List<String> parse(String muscles) {
    if (muscles.isEmpty) return [];
    return muscles.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accent = context.phoenix.textPrimary;
    final bgColor = isPrimary
        ? accent.withAlpha(26)
        : (isDark ? PhoenixColors.darkOverlay : PhoenixColors.lightElevated);

    final textColor = isPrimary
        ? accent
        : context.phoenix.textSecondary;

    return TDTag(
      muscle.toUpperCase(),
      size: TDTagSize.small,
      shape: TDTagShape.round,
      isLight: true,
      backgroundColor: bgColor,
      textColor: textColor,
    );
  }
}
