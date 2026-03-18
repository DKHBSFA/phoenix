import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../core/models/daily_protocol.dart';
import '../../../core/models/meal_plan_generator.dart';
import '../../../shared/widgets/medical_disclaimer_dialog.dart';
import '../../../shared/widgets/protocol_card_shell.dart';
import '../../nutrition/meal_detail_sheet.dart';

class NutritionCard extends ConsumerWidget {
  final NutritionProgress progress;

  const NutritionCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    final completed = progress.mealsLogged >= 3;

    final mealPlanAsync = ref.watch(mealPlanProvider);

    return ProtocolCardShell(
      title: 'ALIMENTAZIONE',
      completed: completed,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finestra: ${progress.eatingWindow}',
            style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
          ),
          const SizedBox(height: Spacing.sm),

          // Day type label (Phase M)
          if (progress.macroTargets != null) ...[
            Text(
              '${progress.macroTargets!.dayTypeLabel} — ${progress.macroTargets!.dayTypeRationale}',
              style: PhoenixTypography.caption.copyWith(
                color: subtitleColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: Spacing.sm),
          ],

          // Protein progress bar
          _MacroBar(
            label: 'Proteine',
            current: progress.proteinEaten,
            target: progress.proteinTarget,
            color: PhoenixColors.inProgress,
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          // Phase M: additional macro bars (carb, fat, fiber)
          if (progress.macroTargets != null) ...[
            const SizedBox(height: Spacing.xs),
            _MacroBar(
              label: 'Carb',
              current: progress.carbEaten,
              target: progress.macroTargets!.carbG,
              color: const Color(0xFF4A90D9),
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            const SizedBox(height: Spacing.xs),
            _MacroBar(
              label: 'Grassi',
              current: progress.fatEaten,
              target: progress.macroTargets!.fatG,
              color: const Color(0xFFE6A23C),
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            const SizedBox(height: Spacing.xs),
            _MacroBar(
              label: 'Fibre',
              current: progress.fiberEaten,
              target: progress.macroTargets!.fiberG,
              color: const Color(0xFF67C23A),
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
          ],

          const SizedBox(height: Spacing.md),

          // Meal plan list
          mealPlanAsync.when(
            data: (plan) => _MealList(
              meals: plan.meals,
              mealsLogged: progress.mealsLogged,
              textColor: textColor,
              subtitleColor: subtitleColor,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: Spacing.md),

          // Log pasto button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                HapticFeedback.lightImpact();
                final accepted =
                    await MedicalDisclaimerDialog.showIfNeeded(context, ref);
                if (!accepted || !context.mounted) return;
                Navigator.pushNamed(context, PhoenixRouter.fasting);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(color: textColor),
                padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
              ),
              child: const Text('Log pasto'),
            ),
          ),

          // Disclaimer footer
          const SizedBox(height: Spacing.sm),
          Text(
            'Informazioni a scopo educativo. Consulta il tuo medico.',
            style: PhoenixTypography.caption.copyWith(
              color: subtitleColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealList extends StatelessWidget {
  final List<PlannedMeal> meals;
  final int mealsLogged;
  final Color textColor;
  final Color subtitleColor;

  const _MealList({
    required this.meals,
    required this.mealsLogged,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();

    return Column(
      children: meals.map((meal) {
        final parts = meal.timeSlot.split(':');
        final mealTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 12,
          minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
        );

        final isLogged = meal.mealNumber <= mealsLogged;
        final isNext = !isLogged &&
            (meal.mealNumber == mealsLogged + 1) &&
            _isTimeNearOrPast(now, mealTime);

        return GestureDetector(
          onTap: () => MealDetailSheet.show(context, meal),
          child: Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  child: Icon(
                    isLogged ? Icons.check_circle : Icons.circle_outlined,
                    size: 16,
                    color: isLogged ? PhoenixColors.completed : subtitleColor,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Pasto ${meal.mealNumber} (${meal.timeSlot})',
                              style: PhoenixTypography.bodyLarge.copyWith(
                                color: textColor,
                                fontWeight: isNext ? FontWeight.w700 : FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isNext) ...[
                            const SizedBox(width: Spacing.xs),
                            Text(
                              '← prossimo',
                              style: PhoenixTypography.caption.copyWith(
                                color: subtitleColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        meal.description,
                        style: PhoenixTypography.bodyMedium.copyWith(
                          color: subtitleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${meal.proteinG.round()}g P · ${meal.carbG.round()}g C · ${meal.fatG.round()}g F · ${meal.calories.round()} kcal',
                        style: PhoenixTypography.caption.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 16, color: subtitleColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isTimeNearOrPast(TimeOfDay now, TimeOfDay mealTime) {
    final nowMin = now.hour * 60 + now.minute;
    final mealMin = mealTime.hour * 60 + mealTime.minute;
    return nowMin >= mealMin - 120;
  }
}

/// Reusable macro progress bar row.
class _MacroBar extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final Color color;
  final Color textColor;
  final Color subtitleColor;

  const _MacroBar({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
          ),
        ),
        const SizedBox(width: Spacing.xs),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: PhoenixColors.pending,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        SizedBox(
          width: 80,
          child: Text(
            '${current.round()}/${target.round()}g',
            style: PhoenixTypography.bodyMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
