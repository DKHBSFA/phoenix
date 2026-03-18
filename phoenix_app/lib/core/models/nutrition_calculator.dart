/// Calculates daily macro targets based on user profile.
///
/// From Phoenix Protocol §4.1:
/// - Protein: 1.6-2.2 g/kg based on tier
/// - Per-meal minimum: 0.4 g/kg (at least 3 meals)
class NutritionCalculator {
  final double weightKg;
  final String tier; // 'beginner' / 'intermediate' / 'advanced'

  const NutritionCalculator({
    required this.weightKg,
    required this.tier,
  });

  /// Daily protein target in grams.
  double get dailyProteinGrams {
    final multiplier = switch (tier) {
      'advanced' => 2.2,
      'intermediate' => 1.8,
      _ => 1.6,
    };
    return weightKg * multiplier;
  }

  /// Minimum protein per meal (0.4 g/kg).
  double get perMealProteinMin => weightKg * 0.4;

  /// Optimal protein per meal (0.55 g/kg).
  double get perMealProteinMax => weightKg * 0.55;

  /// Recommended number of meals to hit daily target.
  int get recommendedMeals {
    final perMeal = perMealProteinMax;
    return (dailyProteinGrams / perMeal).ceil().clamp(3, 5);
  }

  /// Protein per meal to hit daily target in [recommendedMeals].
  double get proteinPerMeal => dailyProteinGrams / recommendedMeals;

  /// Suggested eating window hours based on fasting level.
  static int eatingWindowHours(int fastingLevel) {
    return switch (fastingLevel) {
      2 => 6, // 18h fast → 6h window
      3 => 4, // 20h+ fast → 4h window
      _ => 8, // 16h fast → 8h window (level 1 default)
    };
  }

  /// Target fasting hours for each level.
  static double targetHoursForLevel(int level) {
    return switch (level) {
      2 => 18.0,
      3 => 22.0,
      _ => 14.0,
    };
  }

  /// Level descriptions.
  static String levelDescription(int level) {
    return switch (level) {
      1 => 'Flessibilità metabolica baseline',
      2 => 'Chetosi iniziale, segnale autofagico',
      3 => 'Autofagia profonda (avanzati)',
      _ => '',
    };
  }

  /// Level target range label.
  static String levelTargetLabel(int level) {
    return switch (level) {
      1 => '12-14h',
      2 => '16-18h',
      3 => '18-24h+',
      _ => '',
    };
  }
}

/// Complete macro targets for a day, computed from weight and day type.
///
/// Based on Phoenix Protocol §4.2:
/// - Carb cycling: training 4-5g/kg, normal 3-4g/kg, autophagy 2-3g/kg (Impey 2018)
/// - Fat: 25-37% kcal by day type
/// - Fiber: 30-40g/day (Reynolds 2019, Lancet)
class MacroTargets {
  final double proteinG;
  final double carbG;
  final double fatG;
  final double fiberG;
  final double totalKcal;
  final String dayType;

  const MacroTargets({
    required this.proteinG,
    required this.carbG,
    required this.fatG,
    required this.fiberG,
    required this.totalKcal,
    required this.dayType,
  });

  /// Compute daily macro targets from weight, day type, and training tier.
  factory MacroTargets.forDay({
    required double weightKg,
    required String dayType,
    required String tier,
  }) {
    final calc = NutritionCalculator(weightKg: weightKg, tier: tier);
    final protein = calc.dailyProteinGrams;

    final carbPerKg = switch (dayType) {
      'training' => 4.5,
      'normal' => 3.5,
      'autophagy' => 2.5,
      _ => 3.5,
    };
    final carb = weightKg * carbPerKg;

    final fiber = dayType == 'autophagy' ? 27.0 : 35.0;

    final fatPercent = switch (dayType) {
      'training' => 0.27,
      'normal' => 0.32,
      'autophagy' => 0.37,
      _ => 0.30,
    };

    final proteinKcal = protein * 4;
    final carbKcal = carb * 4;
    final totalKcal = (proteinKcal + carbKcal) / (1 - fatPercent);
    final fatG = (totalKcal * fatPercent) / 9;

    return MacroTargets(
      proteinG: protein,
      carbG: carb,
      fatG: fatG,
      fiberG: fiber,
      totalKcal: totalKcal,
      dayType: dayType,
    );
  }

  /// Day type label in Italian.
  String get dayTypeLabel => switch (dayType) {
        'training' => 'Giorno Training',
        'normal' => 'Giorno Normale',
        'autophagy' => 'Giorno Autofagia',
        _ => 'Giorno',
      };

  /// Day type rationale for the user.
  String get dayTypeRationale => switch (dayType) {
        'training' => 'Più carboidrati per performance',
        'normal' => 'Mantenimento equilibrato',
        'autophagy' => 'Low-carb per favorire chetosi',
        _ => '',
      };
}
