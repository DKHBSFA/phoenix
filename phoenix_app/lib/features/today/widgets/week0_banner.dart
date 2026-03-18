import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../core/models/week0_generator.dart' as w0;
import '../../../core/models/workout_plan.dart';
import '../../../core/database/database.dart';
import '../../../core/database/tables.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

/// Provider for Week 0 completed session count from DB.
final week0CompletedCountProvider = FutureProvider<int>((ref) async {
  final dao = ref.watch(week0DaoProvider);
  return dao.completedCount();
});

/// Banner shown on Today screen when Week 0 familiarization is active.
class Week0Banner extends ConsumerWidget {
  const Week0Banner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    if (!settings.week0Active) return const SizedBox.shrink();

    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    final sessions = w0.Week0Generator.generatePlan();
    final completedAsync = ref.watch(week0CompletedCountProvider);
    final completedCount = completedAsync.valueOrNull ?? 0;
    final isCompleted = completedCount >= 6;

    // Next session to do
    final nextIndex = completedCount.clamp(0, 5);
    final nextSession = sessions[nextIndex];

    return ProtocolCardShell(
      title: 'SETTIMANA 0 — FAMILIARIZZAZIONE',
      completed: isCompleted,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCompleted
                ? 'Familiarizzazione completata! Pronto per il protocollo.'
                : '6 sessioni per apprendere i pattern motori fondamentali',
            style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
          ),
          const SizedBox(height: Spacing.sm),
          // Session dots
          Row(
            children: List.generate(6, (i) {
              final isDone = i < completedCount;
              final isCurrent = i == completedCount && !isCompleted;
              return Padding(
                padding: const EdgeInsets.only(right: Spacing.xs),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? PhoenixColors.completed.withAlpha(51)
                        : isCurrent
                            ? PhoenixColors.inProgress.withAlpha(51)
                            : Colors.transparent,
                    border: Border.all(
                      color: isDone
                          ? PhoenixColors.completed
                          : isCurrent
                              ? PhoenixColors.inProgress
                              : subtitleColor.withAlpha(77),
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check, size: 14, color: PhoenixColors.completed)
                        : Text(
                            '${i + 1}',
                            style: PhoenixTypography.caption.copyWith(
                              color: isCurrent ? PhoenixColors.inProgress : subtitleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
          if (!isCompleted) ...[
            const SizedBox(height: Spacing.md),
            Text(
              'Sessione ${completedCount + 1}: ${nextSession.focusLabel}',
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              '${nextSession.exercises.length} esercizi · ${nextSession.sets} serie × ${nextSession.reps} reps · RPE ${nextSession.targetRpeMin.round()}-${nextSession.targetRpeMax.round()}',
              style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Principio di Bernstein: pochi cue alla volta per automatizzare i pattern',
              style: PhoenixTypography.caption.copyWith(
                color: subtitleColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Build a WorkoutPlan from the Week0 session
                  final plan = _buildWeek0WorkoutPlan(nextSession);
                  Navigator.pushNamed(
                    context,
                    PhoenixRouter.workout,
                    arguments: plan,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: textColor),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: const Text('Inizia Sessione'),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Center(
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(settingsProvider.notifier).setWeek0Skipped();
                },
                child: Text(
                  'Salta familiarizzazione',
                  style: PhoenixTypography.caption.copyWith(
                    color: subtitleColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Convert a w0.Week0Session into a WorkoutPlan compatible with WorkoutSessionScreen.
  WorkoutPlan _buildWeek0WorkoutPlan(w0.Week0Session session) {
    final exercises = session.exercises.map((e) {
      // Create a minimal Exercise object for the session screen
      final exercise = Exercise(
        id: -1, // Virtual — not from DB
        name: e.name,
        category: e.pattern,
        exerciseType: ExerciseType.compound,
        phoenixLevel: 1,
        equipment: Equipment.bodyweight,
        musclesPrimary: e.pattern,
        musclesSecondary: '',
        instructions: e.instructions,
        imagePaths: '',
        animationPath: '',
        advancementCriteria: '',
        executionCues: e.instructions,
        defaultSets: session.sets,
        defaultTempoEcc: 3,
        defaultTempoCon: 2,
        defaultRepsMin: session.reps,
        defaultRepsMax: session.reps,
        dayType: 'all',
      );
      return PlannedExercise(
        exercise: exercise,
        sets: session.sets,
        repsMin: session.reps,
        repsMax: session.reps,
        tempoEcc: 3,
        tempoCon: 2,
        restSeconds: session.restSeconds,
      );
    }).toList();

    return WorkoutPlan(
      dayName: 'Week 0 — ${session.focusLabel}',
      type: WorkoutType.strength,
      exercises: exercises,
      estimatedMinutes: (session.exercises.length * session.sets * 1.5 + session.exercises.length * 2).round(),
    );
  }
}
