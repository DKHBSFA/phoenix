import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../../../core/database/database.dart';
import 'exercise_hero.dart';
import 'muscle_badge.dart';

/// Horizontal exercise card with category thumbnail, name, muscle badges, and meta.
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final String? setsRepsLabel;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.setsRepsLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtitleColor =
        isDark ? PhoenixColors.darkTextSecondary : PhoenixColors.lightTextSecondary;
    final catColor = ExerciseHero.categoryColor(exercise.category, isDark: isDark);
    final catIcon = ExerciseHero.categoryIcon(exercise.category);
    final muscles = MuscleBadge.parse(exercise.musclesPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(
            color: isDark ? PhoenixColors.darkBorder : PhoenixColors.lightBorder,
          ),
          boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 112,
              color: catColor.withAlpha(31),
              child: Center(
                child: Icon(catIcon, size: 36, color: catColor),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md, vertical: Spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      exercise.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    if (muscles.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: muscles
                            .take(3)
                            .map((m) => MuscleBadge(
                                  muscle: m,
                                  isPrimary: m == muscles.first,
                                ))
                            .toList(),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_alt, size: 14, color: subtitleColor),
                        const SizedBox(width: 4),
                        Text(
                          'Lv. ${exercise.phoenixLevel}',
                          style: TextStyle(fontSize: 12, color: subtitleColor),
                        ),
                        if (setsRepsLabel != null) ...[
                          const SizedBox(width: Spacing.md),
                          Icon(Icons.timer_outlined, size: 14, color: subtitleColor),
                          const SizedBox(width: 4),
                          Text(
                            setsRepsLabel!,
                            style: TextStyle(fontSize: 12, color: subtitleColor),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Chevron
            if (onTap != null)
              Padding(
                padding: const EdgeInsets.only(right: Spacing.sm),
                child: Icon(Icons.chevron_right, color: subtitleColor, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
