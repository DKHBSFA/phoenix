import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../core/models/workout_plan.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

class TrainingCard extends ConsumerWidget {
  final WorkoutPlan? workout;
  final bool completed;

  const TrainingCard({super.key, required this.workout, required this.completed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;
    final borderColor = p.border;
    final surfaceColor = p.surface;

    final isRest = workout == null || workout!.isRestDay;
    final isCardio = workout != null && workout!.isCardioDay;
    final equipmentOverride = ref.watch(equipmentOverrideProvider);
    final isBodyweight = equipmentOverride == 'bodyweight';

    return ProtocolCardShell(
      title: 'ALLENAMENTO',
      completed: completed || isRest,
      borderColor: borderColor,
      surfaceColor: surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCardio) ...[
            Text(
              workout!.dayName,
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              '~${workout!.estimatedMinutes} min · ${workout!.cardioPlan!.rounds.length} round',
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
            if (!completed) ...[
              const SizedBox(height: Spacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(
                      context,
                      PhoenixRouter.cardioSession,
                      arguments: workout!.cardioPlan,
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
                  child: const Text('Inizia Cardio'),
                ),
              ),
            ],
          ] else if (isRest) ...[
            Text(
              'Recupero attivo',
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              'Camminata, stretching, mobilità',
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
          ] else ...[
            Text(
              workout!.dayName,
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              '${workout!.exercises.length} esercizi · ~${workout!.estimatedMinutes} min',
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
            if (!completed) ...[
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(
                          context,
                          PhoenixRouter.workout,
                          arguments: workout,
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
                      child: const Text('Inizia'),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      ref.read(equipmentOverrideProvider.notifier).toggle(
                        'bodyweight',
                      );
                    },
                    icon: Icon(
                      isBodyweight ? Icons.fitness_center : Icons.self_improvement,
                      size: 18,
                    ),
                    label: Text(
                      isBodyweight ? 'Attrezzi' : 'Corpo libero',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isBodyweight ? PhoenixColors.completed : subtitleColor,
                      side: BorderSide(
                        color: isBodyweight ? PhoenixColors.completed : borderColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm + 2,
                        vertical: Spacing.smMd,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.sm),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
