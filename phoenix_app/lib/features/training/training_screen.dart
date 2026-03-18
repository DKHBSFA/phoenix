import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/database/tables.dart';
import '../../core/llm/prompt_templates.dart';
import '../../core/models/workout_plan.dart';
import '../coach/widgets/ai_insight_card.dart';
import '../exercise/exercise_detail_sheet.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(todayWorkoutPlanProvider);

    return SafeArea(
      child: planAsync.when(
        loading: () => Center(child: TDLoading(size: TDLoadingSize.medium)),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (plan) => _TrainingContent(plan: plan),
      ),
    );
  }
}

class _TrainingContent extends ConsumerWidget {
  final WorkoutPlan plan;
  const _TrainingContent({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, Spacing.screenTop, Spacing.screenH, Spacing.sm),
            child: Text(
              'Allenamento',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: PhoenixColors.trainingAccent,
              ),
            ),
          ).animate().fadeIn(duration: AnimDurations.normal),
        ),

        // AI fatigue advisor card (only if LLM available)
        SliverToBoxAdapter(
          child: AiInsightCard(
            engine: ref.watch(llmEngineProvider),
            template: FatigueAdvisorTemplate(),
            context: const {
              'rpe_7d': [],
              'durations_7d': [],
              'volume_7d': [],
              'streak': 0,
              'last_duration_score': '',
            },
            icon: Icons.psychology,
            title: 'Suggerimento AI',
            accentColor: PhoenixColors.trainingAccent,
          ),
        ),

        // Today's workout card
        SliverToBoxAdapter(
          child: plan.isRestDay
              ? _RestDayCard(plan: plan)
              : _WorkoutDayCard(plan: plan),
        ),

        // Recent sessions header — Stitch pattern 3.13
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, Spacing.lg, Spacing.screenH, Spacing.sm),
            child: Row(
              children: [
                const Icon(Icons.history, color: PhoenixColors.trainingAccent, size: 20),
                const SizedBox(width: Spacing.sm),
                Text(
                  'Ultime sessioni',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Recent sessions list
        SliverToBoxAdapter(
          child: _RecentSessions(),
        ),
      ],
    );
  }
}

class _WorkoutDayCard extends StatelessWidget {
  final WorkoutPlan plan;
  const _WorkoutDayCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleColor = context.phoenix.textSecondary;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH, vertical: Spacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(CardTokens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day name & type
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: PhoenixColors.trainingAccent.withAlpha(31),
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: Icon(Icons.fitness_center,
                      color: PhoenixColors.trainingAccent, size: 28),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.dayName, style: theme.textTheme.titleLarge),
                      Text(
                        _typeLabel(plan.type),
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: subtitleColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md, vertical: Spacing.xs),
                  decoration: BoxDecoration(
                    color: context.phoenix.elevated,
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: Text(
                    '${plan.exercises.length} esercizi • ~${plan.estimatedMinutes} min',
                    style: TextStyle(color: subtitleColor, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Spacing.md),
            const Divider(height: 1),
            const SizedBox(height: Spacing.md),

            // Exercise list preview — tappable rows with thumbnail (pattern 3.4/3.11)
            ...plan.exercises.map((ex) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.md),
                    onTap: () => ExerciseDetailSheet.show(
                      context,
                      exercise: ex.exercise,
                      sets: ex.sets,
                      repsMin: ex.repsMin,
                      repsMax: ex.repsMax,
                      tempoEcc: ex.tempoEcc,
                      tempoCon: ex.tempoCon,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: context.phoenix.elevated,
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                      child: Row(
                        children: [
                          // Category thumbnail (pattern 3.4)
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _exerciseTypeColor(ex.exercise.exerciseType).withAlpha(26),
                              borderRadius: BorderRadius.circular(Radii.sm),
                            ),
                            child: Icon(
                              _categoryIcon(ex.exercise.category),
                              size: 22,
                              color: _exerciseTypeColor(ex.exercise.exerciseType),
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex.exercise.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: Spacing.xxs),
                                Row(
                                  children: [
                                    // Exercise type badge (pattern 3.11)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: _exerciseTypeColor(ex.exercise.exerciseType).withAlpha(26),
                                        borderRadius: BorderRadius.circular(Radii.sm),
                                      ),
                                      child: Text(
                                        ex.exercise.exerciseType.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                          color: _exerciseTypeColor(ex.exercise.exerciseType),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: Spacing.xs),
                                    Text(
                                      '${ex.sets} × ${ex.repsLabel}',
                                      style: TextStyle(color: subtitleColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 20, color: subtitleColor),
                        ],
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: Spacing.md),

            // Start button
            TDButton(
              text: 'Inizia allenamento',
              type: TDButtonType.fill,
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              isBlock: true,
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pushNamed(
                  context,
                  PhoenixRouter.workout,
                  arguments: plan,
                );
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: AnimDurations.normal, delay: AnimDurations.stagger)
        .slideY(begin: 0.03, end: 0);
  }

  String _typeLabel(String type) {
    switch (type) {
      case WorkoutType.strength:
        return 'Forza';
      case WorkoutType.cardio:
        return 'Recupero attivo';
      case WorkoutType.power:
        return 'Potenza / Skill';
      default:
        return type;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case ExerciseCategory.push: return Icons.fitness_center;
      case ExerciseCategory.pull: return Icons.height;
      case ExerciseCategory.squat: return Icons.directions_walk;
      case ExerciseCategory.hinge: return Icons.accessibility_new;
      case ExerciseCategory.core: return Icons.shield;
      default: return Icons.sports;
    }
  }

  Color _exerciseTypeColor(String type) {
    switch (type) {
      case ExerciseType.compound:
        return PhoenixColors.trainingAccent;
      case ExerciseType.accessory:
        return PhoenixColors.warning;
      case ExerciseCategory.core:
        return PhoenixColors.fastingAccent;
      default:
        return PhoenixColors.darkTextSecondary;
    }
  }
}

class _RestDayCard extends StatelessWidget {
  final WorkoutPlan plan;
  const _RestDayCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleColor = context.phoenix.textSecondary;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH, vertical: Spacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(CardTokens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: PhoenixColors.success.withAlpha(31),
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  child: const Icon(Icons.self_improvement,
                      color: PhoenixColors.success, size: 28),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.dayName, style: theme.textTheme.titleLarge),
                      Text(
                        'Recupero attivo',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: subtitleColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            _SuggestionRow(
              icon: Icons.directions_run,
              text: 'Zone 2 cardio — 20-30 min',
            ),
            const SizedBox(height: Spacing.sm),
            _SuggestionRow(
              icon: Icons.accessibility_new,
              text: 'Stretching PNF — 15 min',
            ),
            const SizedBox(height: Spacing.sm),
            _SuggestionRow(
              icon: Icons.self_improvement,
              text: 'Mobilità articolare — 10 min',
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: AnimDurations.normal, delay: AnimDurations.stagger)
        .slideY(begin: 0.03, end: 0);
  }
}

class _SuggestionRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SuggestionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18,
            color: context.phoenix.textTertiary),
        const SizedBox(width: Spacing.sm),
        Text(text, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _RecentSessions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutDao = ref.watch(workoutDaoProvider);
    final subtitleColor = context.phoenix.textSecondary;

    return StreamBuilder(
      stream: workoutDao.watchRecentSessions(limit: 5),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH, vertical: Spacing.lg),
            child: Column(
              children: [
                Icon(Icons.fitness_center,
                    size: 48,
                    color: context.phoenix.textQuaternary),
                const SizedBox(height: Spacing.md),
                Text(
                  'Nessuna sessione ancora',
                  style: TextStyle(color: subtitleColor),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  'Inizia il tuo primo allenamento!',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        final sessions = snapshot.data!;
        return Column(
          children: sessions.map((session) {
            final duration = session.durationMinutes?.toStringAsFixed(0) ?? '—';
            final date = '${session.startedAt.day}/${session.startedAt.month}';
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: Spacing.screenH),
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _scoreColor(session.durationScore),
                ),
              ),
              title: Text(_typeLabel(session.type)),
              subtitle: Text('$date • ${duration} min'),
              dense: true,
            );
          }).toList(),
        );
      },
    );
  }

  Color _scoreColor(String? score) {
    switch (score) {
      case DurationScore.green:
        return PhoenixColors.success;
      case DurationScore.yellow:
        return PhoenixColors.warning;
      case DurationScore.red:
        return PhoenixColors.error;
      default:
        return PhoenixColors.darkTextQuaternary;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case WorkoutType.strength:
        return 'Forza';
      case WorkoutType.cardio:
        return 'Recupero attivo';
      case WorkoutType.power:
        return 'Potenza';
      default:
        return type;
    }
  }
}
