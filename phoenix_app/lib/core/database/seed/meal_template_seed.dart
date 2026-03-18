import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

/// Meal templates: 3 day types × 3 meals = 9 templates.
/// Based on verified nutrition protocol (80+ sources).
/// Protein values for 80kg reference; scaled by MealPlanGenerator.
final mealTemplateSeedData = <MealTemplatesCompanion>[
  // ═══════════════════════════════════════════
  // TRAINING DAY — higher protein, post-workout refeeding
  // ═══════════════════════════════════════════

  _meal(NutritionDayType.training, 1, '09:00',
    'Uova + germe di grano + avena + mirtilli + noci',
    [
      {'name': 'Uova intere', 'grams': 120},
      {'name': 'Germe di grano', 'grams': 15},
      {'name': 'Avena integrale', 'grams': 50},
      {'name': 'Mirtilli', 'grams': 100},
      {'name': 'Noci', 'grams': 20},
      {'name': 'Tè verde', 'grams': 200},
    ],
    31, 550, 'Porridge: avena + germe di grano cotti, mirtilli e noci sopra. Uova a parte strapazzate',
    'post-training',
    carbG: 62, fatG: 22, fiberG: 8),

  _meal(NutritionDayType.training, 2, '13:00',
    'Salmone + riso integrale + broccoli + spinaci',
    [
      {'name': 'Salmone', 'grams': 150},
      {'name': 'Riso integrale', 'grams': 150},
      {'name': 'Broccoli', 'grams': 200},
      {'name': 'Olio EVO', 'grams': 10},
      {'name': 'Cipolla rossa', 'grams': 50},
      {'name': 'Spinaci', 'grams': 80},
    ],
    43, 750, 'Salmone al forno 180°C 15min. Riso cotto e raffreddato (amido resistente). Broccoli al vapore. Insalata spinaci + cipolla',
    'principale',
    carbG: 85, fatG: 24, fiberG: 10),

  _meal(NutritionDayType.training, 3, '16:30',
    'Lenticchie + edamame + asparagi + avocado + melagrana',
    [
      {'name': 'Lenticchie', 'grams': 150},
      {'name': 'Edamame', 'grams': 80},
      {'name': 'Asparagi', 'grams': 150},
      {'name': 'Avocado', 'grams': 50},
      {'name': 'Semi di lino', 'grams': 10},
      {'name': 'Melagrana', 'grams': 80},
      {'name': 'Cioccolato fondente 99%', 'grams': 10},
    ],
    31, 600, 'Bowl: lenticchie base, edamame e asparagi grigliati sopra, avocado a fette, semi di lino. Melagrana e cioccolato come dessert',
    'leggero',
    carbG: 65, fatG: 18, fiberG: 18),

  // ═══════════════════════════════════════════
  // NORMAL DAY — moderate protein, balanced
  // ═══════════════════════════════════════════

  _meal(NutritionDayType.normal, 1, '10:00',
    'Yogurt greco + avena + fragole + noci + germe di grano',
    [
      {'name': 'Yogurt greco', 'grams': 150},
      {'name': 'Avena integrale', 'grams': 40},
      {'name': 'Fragole', 'grams': 150},
      {'name': 'Noci', 'grams': 15},
      {'name': 'Germe di grano', 'grams': 10},
      {'name': 'Tè verde', 'grams': 200},
    ],
    22, 450, 'Overnight oats: avena + yogurt la sera, mattina aggiungere fragole, noci, germe di grano',
    'colazione',
    carbG: 55, fatG: 16, fiberG: 7),

  _meal(NutritionDayType.normal, 2, '14:00',
    'Pollo + patata dolce + broccoli + capperi',
    [
      {'name': 'Petto di pollo', 'grams': 130},
      {'name': 'Patata dolce', 'grams': 150},
      {'name': 'Broccoli', 'grams': 200},
      {'name': 'Capperi', 'grams': 10},
      {'name': 'Olio EVO', 'grams': 10},
    ],
    38, 580, 'Pollo grigliato, patata dolce al forno, broccoli al vapore con capperi e olio EVO',
    'principale',
    carbG: 58, fatG: 16, fiberG: 9),

  _meal(NutritionDayType.normal, 3, '17:30',
    'Ceci + funghi shiitake + spinaci + lamponi',
    [
      {'name': 'Ceci', 'grams': 150},
      {'name': 'Funghi shiitake', 'grams': 80},
      {'name': 'Spinaci', 'grams': 100},
      {'name': 'Lamponi', 'grams': 100},
      {'name': 'Mandorle', 'grams': 15},
      {'name': 'Olio EVO', 'grams': 5},
    ],
    24, 480, 'Insalata calda: ceci e funghi saltati, su letto di spinaci. Mandorle e lamponi come dessert',
    'leggero',
    carbG: 52, fatG: 14, fiberG: 14),

  // ═══════════════════════════════════════════
  // AUTOPHAGY DAY — low protein, plant-only, 1×/settimana
  // ═══════════════════════════════════════════

  _meal(NutritionDayType.autophagy, 1, '10:00',
    'Avena + mirtilli + noci + semi di lino + tè verde',
    [
      {'name': 'Avena integrale', 'grams': 60},
      {'name': 'Mirtilli', 'grams': 100},
      {'name': 'Noci', 'grams': 15},
      {'name': 'Semi di lino', 'grams': 10},
      {'name': 'Tè verde', 'grams': 200},
    ],
    12, 400, 'Porridge: avena + semi di lino + noci cotti. Mirtilli freschi sopra',
    'colazione',
    carbG: 55, fatG: 14, fiberG: 9),

  _meal(NutritionDayType.autophagy, 2, '14:00',
    'Lenticchie + asparagi + cipolla rossa + olio EVO',
    [
      {'name': 'Lenticchie', 'grams': 120},
      {'name': 'Asparagi', 'grams': 150},
      {'name': 'Cipolla rossa', 'grams': 50},
      {'name': 'Olio EVO', 'grams': 10},
      {'name': 'Riso integrale', 'grams': 100},
    ],
    14, 450, 'Lenticchie stufate con cipolla. Asparagi grigliati. Riso integrale come base',
    'principale',
    carbG: 62, fatG: 12, fiberG: 14),

  _meal(NutritionDayType.autophagy, 3, '17:00',
    'Edamame + avocado + melagrana + cioccolato fondente',
    [
      {'name': 'Edamame', 'grams': 60},
      {'name': 'Avocado', 'grams': 50},
      {'name': 'Melagrana', 'grams': 80},
      {'name': 'Cioccolato fondente 99%', 'grams': 10},
      {'name': 'Mandorle', 'grams': 10},
    ],
    9, 350, 'Piatto freddo: edamame sgusciati, avocado a fette, semi melagrana. Cioccolato e mandorle come chiusura',
    'leggero',
    carbG: 30, fatG: 18, fiberG: 8),
];

MealTemplatesCompanion _meal(
  String dayType, int mealNumber, String timeSlot,
  String description, List<Map<String, dynamic>> ingredients,
  double proteinG, double calories, String cookingMethod,
  String timing, {
  double? carbG,
  double? fatG,
  double? fiberG,
}) {
  return MealTemplatesCompanion.insert(
    dayType: dayType,
    mealNumber: mealNumber,
    timeSlot: timeSlot,
    description: description,
    ingredients: jsonEncode(ingredients),
    proteinEstimateG: proteinG,
    caloriesEstimate: calories,
    cookingMethod: cookingMethod,
    timing: timing,
    carbEstimateG: Value(carbG),
    fatEstimateG: Value(fatG),
    fiberEstimateG: Value(fiberG),
  );
}
