import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../exercise/exercise_detail_sheet.dart';

class ProgressionsScreen extends ConsumerWidget {
  const ProgressionsScreen({super.key});

  static const _categories = [ExerciseCategory.push, ExerciseCategory.pull, ExerciseCategory.squat, ExerciseCategory.hinge, ExerciseCategory.core];
  static const _categoryLabels = {
    ExerciseCategory.push: 'Push',
    ExerciseCategory.pull: 'Pull',
    ExerciseCategory.squat: 'Squat',
    ExerciseCategory.hinge: 'Hinge',
    ExerciseCategory.core: 'Core',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: const TDNavBar(title: 'Progressioni'),
      body: profileAsync.when(
        loading: () => Center(child: TDLoading(size: TDLoadingSize.medium)),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (profile) {
          final equipment = profile?.equipment ?? 'bodyweight';
          final tier = profile?.trainingTier ?? 'beginner';
          final maxLevel = _tierToMaxLevel(tier);

          return _ProgressionsList(
            equipment: equipment,
            currentMaxLevel: maxLevel,
          );
        },
      ),
    );
  }

  int _tierToMaxLevel(String tier) {
    switch (tier) {
      case 'beginner': return 2;
      case 'intermediate': return 4;
      case 'advanced': return 6;
      default: return 2;
    }
  }
}

class _ProgressionsList extends ConsumerWidget {
  final String equipment;
  final int currentMaxLevel;

  const _ProgressionsList({
    required this.equipment,
    required this.currentMaxLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseDao = ref.watch(exerciseDaoProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.md),
      itemCount: ProgressionsScreen._categories.length,
      itemBuilder: (context, index) {
        final category = ProgressionsScreen._categories[index];
        final label = ProgressionsScreen._categoryLabels[category] ?? category;

        return FutureBuilder<List<Exercise>>(
          future: exerciseDao.getProgressionChain(category, equipment),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(height: 100, child: Center(child: TDLoading(size: TDLoadingSize.medium)));
            }
            final exercises = snapshot.data!;
            if (exercises.isEmpty) return const SizedBox.shrink();

            return _CategoryCard(
              category: label,
              exercises: exercises,
              currentLevel: currentMaxLevel,
            )
                .animate()
                .fadeIn(
                  duration: AnimDurations.normal,
                  delay: AnimDurations.stagger * (index + 1),
                )
                .slideY(begin: 0.03, end: 0);
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final List<Exercise> exercises;
  final int currentLevel;

  const _CategoryCard({
    required this.category,
    required this.exercises,
    required this.currentLevel,
  });

  IconData get _categoryIcon {
    switch (category) {
      case 'Push': return Icons.fitness_center;
      case 'Pull': return Icons.height;
      case 'Squat': return Icons.directions_walk;
      case 'Hinge': return Icons.accessibility_new;
      case 'Core': return Icons.shield;
      default: return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lockedColor =
        isDark ? PhoenixColors.darkTextTertiary : PhoenixColors.lightTextSecondary;
    final textColor = context.phoenix.textPrimary;
    final inactiveCircle = context.phoenix.elevated;
    final lockedNumberColor = context.phoenix.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: context.phoenix.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              children: [
                Icon(_categoryIcon, color: theme.colorScheme.primary),
                const SizedBox(width: Spacing.sm),
                Text(category, style: theme.textTheme.titleLarge),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md, vertical: Spacing.xs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: Text(
                    'Livello $currentLevel',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),

            ...List.generate(exercises.length, (i) {
              final ex = exercises[i];
              final level = ex.phoenixLevel;
              final isCurrent = level == currentLevel;
              final isCompleted = level < currentLevel;
              final isLocked = level > currentLevel;

              return InkWell(
                borderRadius: BorderRadius.circular(Radii.sm),
                onTap: () => ExerciseDetailSheet.show(
                  context,
                  exercise: ex,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent
                              ? theme.colorScheme.primary
                              : isCompleted
                                  ? PhoenixColors.success
                                  : inactiveCircle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  size: 16, color: PhoenixColors.darkTextPrimary)
                              : Text(
                                  '$level',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? PhoenixColors.darkTextPrimary
                                        : lockedNumberColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Text(
                          ex.name,
                          style: TextStyle(
                            color: isLocked ? lockedColor : textColor,
                            fontWeight: isCurrent ? FontWeight.bold : null,
                            fontSize: isCurrent ? 16 : 14,
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Icon(Icons.arrow_forward,
                            color: lockedColor, size: 18),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
    );
  }
}
