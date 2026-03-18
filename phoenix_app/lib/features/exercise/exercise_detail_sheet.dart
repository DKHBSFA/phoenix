import 'package:flutter/material.dart';

import '../../app/design_tokens.dart';
import '../../core/database/database.dart';
import 'widgets/exercise_hero.dart';
import 'widgets/muscle_badge.dart';
import 'widgets/numbered_steps.dart';
import 'widgets/stats_grid.dart';

/// Shows exercise detail as a modal bottom sheet.
///
/// Call [ExerciseDetailSheet.show] to open it.
class ExerciseDetailSheet extends StatelessWidget {
  final Exercise exercise;
  /// Optional override for sets/reps (from WorkoutPlan context).
  final int? sets;
  final int? repsMin;
  final int? repsMax;
  final int? tempoEcc;
  final int? tempoCon;

  const ExerciseDetailSheet({
    super.key,
    required this.exercise,
    this.sets,
    this.repsMin,
    this.repsMax,
    this.tempoEcc,
    this.tempoCon,
  });

  /// Show the detail sheet for an exercise.
  static void show(
    BuildContext context, {
    required Exercise exercise,
    int? sets,
    int? repsMin,
    int? repsMax,
    int? tempoEcc,
    int? tempoCon,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseDetailSheet(
        exercise: exercise,
        sets: sets,
        repsMin: repsMin,
        repsMax: repsMax,
        tempoEcc: tempoEcc,
        tempoCon: tempoCon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtitleColor = context.phoenix.textSecondary;

    final effectiveSets = sets ?? exercise.defaultSets;
    final effectiveRepsMin = repsMin ?? exercise.defaultRepsMin;
    final effectiveRepsMax = repsMax ?? exercise.defaultRepsMax;
    final effectiveTempoEcc = tempoEcc ?? exercise.defaultTempoEcc;
    final effectiveTempoCon = tempoCon ?? exercise.defaultTempoCon;
    final repsLabel = effectiveRepsMin == effectiveRepsMax
        ? '$effectiveRepsMin'
        : '$effectiveRepsMin-$effectiveRepsMax';

    final primaryMuscles = MuscleBadge.parse(exercise.musclesPrimary);
    final secondaryMuscles = MuscleBadge.parse(exercise.musclesSecondary);
    final steps = NumberedSteps.parseSteps(exercise.executionCues);

    final hasMuscles = primaryMuscles.isNotEmpty || secondaryMuscles.isNotEmpty;
    final hasSteps = steps.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? PhoenixColors.darkSurface : PhoenixColors.lightBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.xl)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, 0, Spacing.screenH, Spacing.xxl),
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: Spacing.sm),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.phoenix.textQuaternary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: Spacing.sm),

              // Hero placeholder
              ExerciseHero(category: exercise.category),

              const SizedBox(height: Spacing.lg),

              // Exercise name
              Text(
                exercise.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: Spacing.sm),

              // Category + level badges
              Wrap(
                spacing: Spacing.sm,
                runSpacing: Spacing.xs,
                children: [
                  _Badge(
                    label: exercise.category.toUpperCase(),
                    color: ExerciseHero.categoryColor(exercise.category, isDark: isDark),
                  ),
                  _Badge(
                    label: exercise.exerciseType.toUpperCase(),
                    color: context.phoenix.textSecondary,
                  ),
                  _Badge(
                    label: 'LV. ${exercise.phoenixLevel}',
                    color: subtitleColor,
                  ),
                ],
              ),

              const SizedBox(height: Spacing.lg),

              // Stats grid
              StatsGrid(
                sets: effectiveSets,
                repsLabel: repsLabel,
                tempoEcc: effectiveTempoEcc,
                tempoCon: effectiveTempoCon,
                equipment: exercise.equipment,
              ),

              // Description (executionCues as plain text)
              if (exercise.executionCues.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                _SectionHeader(icon: Icons.description, title: 'Descrizione'),
                const SizedBox(height: Spacing.sm),
                Text(
                  exercise.executionCues,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
              ],

              // Numbered steps
              if (hasSteps) ...[
                const SizedBox(height: Spacing.lg),
                _SectionHeader(icon: Icons.format_list_numbered, title: 'Come eseguire'),
                const SizedBox(height: Spacing.sm),
                NumberedSteps(steps: steps),
              ],

              // Instructions (rich content)
              if (exercise.instructions.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                _InstructionsSection(
                  instructions: exercise.instructions,
                  subtitleColor: subtitleColor,
                ),
              ],

              // Muscles
              if (hasMuscles) ...[
                const SizedBox(height: Spacing.lg),
                _SectionHeader(icon: Icons.sports_martial_arts, title: 'Muscoli'),
                const SizedBox(height: Spacing.sm),
                if (primaryMuscles.isNotEmpty) ...[
                  Text(
                    'Primari',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: subtitleColor),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.xs,
                    children: primaryMuscles
                        .map((m) => MuscleBadge(muscle: m, isPrimary: true))
                        .toList(),
                  ),
                ],
                if (secondaryMuscles.isNotEmpty) ...[
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Secondari',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: subtitleColor),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.xs,
                    children: secondaryMuscles
                        .map((m) => MuscleBadge(muscle: m, isPrimary: false))
                        .toList(),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: context.phoenix.textPrimary, size: 20),
        const SizedBox(width: Spacing.sm),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Renders the structured instructions content with parsed sections.
class _InstructionsSection extends StatelessWidget {
  final String instructions;
  final Color subtitleColor;

  const _InstructionsSection({
    required this.instructions,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = PhoenixColors.error;
    final successColor = PhoenixColors.completed;

    final sections = instructions.split('\n\n');
    final widgets = <Widget>[];

    for (final section in sections) {
      final trimmed = section.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('PERCHÉ:')) {
        widgets.add(const SizedBox(height: Spacing.md));
        widgets.add(_SectionHeader(icon: Icons.lightbulb_outline, title: 'Perché'));
        widgets.add(const SizedBox(height: Spacing.xs));
        widgets.add(Text(
          trimmed.substring(7).trim(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: subtitleColor,
            height: 1.5,
          ),
        ));
      } else if (trimmed.startsWith('ERRORI COMUNI:')) {
        widgets.add(const SizedBox(height: Spacing.md));
        widgets.add(_SectionHeader(icon: Icons.warning_amber_rounded, title: 'Errori comuni'));
        widgets.add(const SizedBox(height: Spacing.xs));
        final lines = trimmed.substring(14).trim().split('\n');
        for (final line in lines) {
          final l = line.trim();
          if (l.isEmpty) continue;
          final text = l.startsWith('•') ? l.substring(1).trim() : l;
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.cancel_outlined, size: 16, color: errorColor),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ));
        }
      } else if (trimmed.startsWith('RESPIRAZIONE:')) {
        widgets.add(const SizedBox(height: Spacing.md));
        widgets.add(_SectionHeader(icon: Icons.air, title: 'Respirazione'));
        widgets.add(const SizedBox(height: Spacing.xs));
        widgets.add(Text(
          trimmed.substring(13).trim(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: subtitleColor,
            height: 1.5,
          ),
        ));
      } else if (trimmed.startsWith('VARIANTE FACILITATA:')) {
        widgets.add(const SizedBox(height: Spacing.md));
        widgets.add(Container(
          padding: const EdgeInsets.all(Spacing.sm + 2),
          decoration: BoxDecoration(
            color: successColor.withAlpha(20),
            borderRadius: BorderRadius.circular(Radii.sm),
            border: Border.all(color: successColor.withAlpha(50)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.swap_horiz, size: 18, color: successColor),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  trimmed.substring(20).trim(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ));
      } else {
        // Regular description paragraph
        widgets.add(Text(
          trimmed,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: subtitleColor,
            height: 1.5,
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.menu_book, title: 'Istruzioni dettagliate'),
        const SizedBox(height: Spacing.sm),
        ...widgets,
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}
