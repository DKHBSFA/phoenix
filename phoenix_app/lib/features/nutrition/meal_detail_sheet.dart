import 'package:flutter/material.dart';

import '../../app/design_tokens.dart';
import '../../core/models/meal_plan_generator.dart';

/// Bottom sheet showing full meal details: ingredients, cooking method, macros.
class MealDetailSheet extends StatelessWidget {
  final PlannedMeal meal;

  const MealDetailSheet({super.key, required this.meal});

  static void show(BuildContext context, PlannedMeal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MealDetailSheet(meal: meal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.phoenix.textPrimary;
    final subtitleColor = context.phoenix.textSecondary;
    final surfaceColor = context.phoenix.surface;
    final borderColor = context.phoenix.border;
    final bgColor = context.phoenix.bg;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(Radii.lg)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(Spacing.lg),
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),

              // Title
              Text(
                'Pasto ${meal.mealNumber} — ${meal.timeSlot}',
                style:
                    PhoenixTypography.titleLarge.copyWith(color: textColor),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                meal.description,
                style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
              ),
              const SizedBox(height: Spacing.lg),

              // Macro summary
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: Border.all(color: borderColor),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: Spacing.sm,
                  runSpacing: Spacing.xs,
                  children: [
                    _MacroChip(
                        label: 'Proteine', value: '${meal.proteinG.round()}g', color: textColor),
                    _MacroChip(
                        label: 'Carb', value: '${meal.carbG.round()}g', color: textColor),
                    _MacroChip(
                        label: 'Grassi', value: '${meal.fatG.round()}g', color: textColor),
                    _MacroChip(
                        label: 'Fibre', value: '${meal.fiberG.round()}g', color: textColor),
                    _MacroChip(
                        label: 'Calorie', value: '${meal.calories.round()}', color: textColor),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.lg),

              // Ingredients
              Text(
                'INGREDIENTI',
                style: PhoenixTypography.caption.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              ...meal.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.xs),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ing.name,
                          style: PhoenixTypography.bodyLarge
                              .copyWith(color: textColor),
                        ),
                        Text(
                          '${ing.grams.round()}g',
                          style: PhoenixTypography.bodyLarge.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: Spacing.lg),

              // Cooking method
              Text(
                'PREPARAZIONE',
                style: PhoenixTypography.caption.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                meal.cookingMethod,
                style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
              ),
              const SizedBox(height: Spacing.lg),

              // Disclaimer footer
              Text(
                'Informazioni a scopo educativo. Consulta il tuo medico.',
                style: PhoenixTypography.caption.copyWith(
                  color: subtitleColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final subtitleColor = context.phoenix.textSecondary;

    return Column(
      children: [
        Text(
          value,
          style: PhoenixTypography.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: PhoenixTypography.caption.copyWith(color: subtitleColor),
        ),
      ],
    );
  }
}
