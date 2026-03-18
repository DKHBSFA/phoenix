import 'dart:convert';

import '../database/daos/meal_template_dao.dart';
import '../database/database.dart';
import '../database/tables.dart';

/// A single meal in today's plan, scaled by user weight.
class PlannedMeal {
  final int mealNumber;
  final String timeSlot;
  final String description;
  final List<PlannedIngredient> ingredients;
  final double proteinG;
  final double carbG;
  final double fatG;
  final double fiberG;
  final double calories;
  final String cookingMethod;
  final String timing;

  const PlannedMeal({
    required this.mealNumber,
    required this.timeSlot,
    required this.description,
    required this.ingredients,
    required this.proteinG,
    this.carbG = 0,
    this.fatG = 0,
    this.fiberG = 0,
    required this.calories,
    required this.cookingMethod,
    required this.timing,
  });
}

/// An ingredient with scaled grams.
class PlannedIngredient {
  final String name;
  final double grams;

  const PlannedIngredient({required this.name, required this.grams});
}

/// Today's complete meal plan.
class MealPlan {
  final String dayType;
  final List<PlannedMeal> meals;
  final double proteinTargetG;
  final double calorieTarget;

  const MealPlan({
    required this.dayType,
    required this.meals,
    required this.proteinTargetG,
    required this.calorieTarget,
  });

  double get totalProteinG =>
      meals.fold(0.0, (sum, m) => sum + m.proteinG);

  double get totalCalories =>
      meals.fold(0.0, (sum, m) => sum + m.calories);
}

/// Generates a daily meal plan scaled by user weight.
///
/// Protein cycling from Phoenix Protocol §4.1:
/// - Training day: 1.6 g/kg (80kg → 128g)
/// - Normal day: 1.2 g/kg (80kg → 96g)
/// - Autophagy day: 0.4 g/kg (80kg → 32g)
class MealPlanGenerator {
  final MealTemplateDao _dao;

  MealPlanGenerator(this._dao);

  /// Generate today's meal plan.
  Future<MealPlan> generateForDay({
    required double weightKg,
    required String dayType, // 'training' / 'normal' / 'autophagy'
  }) async {
    final templates = await _dao.getByDayType(dayType);
    final proteinTarget = _proteinTarget(weightKg, dayType);
    final calorieTarget = _calorieTarget(weightKg, dayType);

    // Scale factor: templates are for 80kg reference
    final scale = weightKg / 80.0;

    final meals = templates.map((t) => _scaleMeal(t, scale)).toList();

    return MealPlan(
      dayType: dayType,
      meals: meals,
      proteinTargetG: proteinTarget,
      calorieTarget: calorieTarget,
    );
  }

  PlannedMeal _scaleMeal(MealTemplate t, double scale) {
    final rawIngredients = jsonDecode(t.ingredients) as List<dynamic>;
    final ingredients = rawIngredients.map((item) {
      final map = item as Map<String, dynamic>;
      final baseGrams = (map['grams'] as num).toDouble();
      return PlannedIngredient(
        name: map['name'] as String,
        grams: (baseGrams * scale).roundToDouble(),
      );
    }).toList();

    return PlannedMeal(
      mealNumber: t.mealNumber,
      timeSlot: t.timeSlot,
      description: t.description,
      ingredients: ingredients,
      proteinG: t.proteinEstimateG * scale,
      carbG: (t.carbEstimateG ?? 0) * scale,
      fatG: (t.fatEstimateG ?? 0) * scale,
      fiberG: (t.fiberEstimateG ?? 0) * scale,
      calories: t.caloriesEstimate * scale,
      cookingMethod: t.cookingMethod,
      timing: t.timing,
    );
  }

  /// Protein target by day type (g/kg body weight).
  static double _proteinTarget(double weightKg, String dayType) {
    final multiplier = switch (dayType) {
      NutritionDayType.training => 1.6,
      NutritionDayType.normal => 1.2,
      NutritionDayType.autophagy => 0.4,
      _ => 1.2,
    };
    return weightKg * multiplier;
  }

  /// Calorie estimate by day type.
  static double _calorieTarget(double weightKg, String dayType) {
    // Base: ~28 kcal/kg for maintenance
    final multiplier = switch (dayType) {
      NutritionDayType.training => 30.0,
      NutritionDayType.normal => 26.0,
      NutritionDayType.autophagy => 20.0,
      _ => 26.0,
    };
    return weightKg * multiplier;
  }

  /// Determine day type from weekday and workout schedule.
  static String dayTypeForWeekday(int weekday) {
    // Sunday = autophagy day (1/week as per protocol)
    if (weekday == DateTime.sunday) return NutritionDayType.autophagy;
    // Training days: Mon, Tue, Thu, Fri (4-day upper/lower split)
    if (weekday == DateTime.monday ||
        weekday == DateTime.tuesday ||
        weekday == DateTime.thursday ||
        weekday == DateTime.friday) {
      return NutritionDayType.training;
    }
    // Wed, Sat = normal/rest days
    return NutritionDayType.normal;
  }
}
