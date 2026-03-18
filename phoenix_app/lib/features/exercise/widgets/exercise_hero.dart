import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../app/design_tokens.dart';
import '../../../core/database/tables.dart';

/// Category-colored hero with exercise image or category placeholder.
///
/// Phase A: tries to load `assets/exercises/{exerciseId}.webp`.
/// Falls back to category-colored placeholder with icon.
class ExerciseHero extends StatelessWidget {
  final String category;

  /// Optional exercise ID for asset resolution.
  final int? exerciseId;

  const ExerciseHero({super.key, required this.category, this.exerciseId});

  /// Resolve the asset path for an exercise image.
  /// Returns null if no asset exists for this exercise.
  static String? assetPathFor(int exerciseId) {
    return 'assets/exercises/$exerciseId.webp';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = categoryColor(category, isDark: isDark);
    final icon = categoryIcon(category);
    final assetPath = exerciseId != null ? assetPathFor(exerciseId!) : null;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.xl),
        child: assetPath != null
            ? _AssetImageWithFallback(
                assetPath: assetPath,
                fallbackColor: color,
                fallbackIcon: icon,
              )
            : Container(
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                ),
                child: Center(
                  child: Icon(icon, size: 64, color: color),
                ),
              ),
      ),
    );
  }

  /// Color for category placeholder.
  static Color categoryColor(String category, {bool isDark = true}) {
    final textPrimary = isDark ? PhoenixColors.darkTextPrimary : PhoenixColors.lightTextPrimary;
    final textSecondary = isDark ? PhoenixColors.darkTextSecondary : PhoenixColors.lightTextSecondary;
    final textTertiary = isDark ? PhoenixColors.darkTextTertiary : PhoenixColors.lightTextTertiary;
    switch (category) {
      case ExerciseCategory.push:
        return textPrimary;
      case ExerciseCategory.pull:
        return textSecondary;
      case ExerciseCategory.squat:
        return PhoenixColors.success;
      case ExerciseCategory.hinge:
        return textTertiary;
      case ExerciseCategory.core:
        return PhoenixColors.warning;
      default:
        return textSecondary;
    }
  }

  /// Icon for category.
  static IconData categoryIcon(String category) {
    switch (category) {
      case ExerciseCategory.push:
        return Icons.fitness_center;
      case ExerciseCategory.pull:
        return Icons.rowing;
      case ExerciseCategory.squat:
        return Icons.directions_walk;
      case ExerciseCategory.hinge:
        return Icons.accessibility_new;
      case ExerciseCategory.core:
        return Icons.self_improvement;
      default:
        return Icons.sports;
    }
  }
}

/// Tries to load an asset image, falling back to the category placeholder.
class _AssetImageWithFallback extends StatefulWidget {
  final String assetPath;
  final Color fallbackColor;
  final IconData fallbackIcon;

  const _AssetImageWithFallback({
    required this.assetPath,
    required this.fallbackColor,
    required this.fallbackIcon,
  });

  @override
  State<_AssetImageWithFallback> createState() =>
      _AssetImageWithFallbackState();
}

class _AssetImageWithFallbackState extends State<_AssetImageWithFallback> {
  bool _assetExists = false;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checkAsset();
  }

  Future<void> _checkAsset() async {
    try {
      await rootBundle.load(widget.assetPath);
      if (mounted) setState(() { _assetExists = true; _checked = true; });
    } catch (_) {
      if (mounted) setState(() { _assetExists = false; _checked = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checked && _assetExists) {
      return Image.asset(
        widget.assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    return Container(
      color: widget.fallbackColor.withAlpha(51),
      child: Center(
        child: Icon(widget.fallbackIcon, size: 64, color: widget.fallbackColor),
      ),
    );
  }
}
