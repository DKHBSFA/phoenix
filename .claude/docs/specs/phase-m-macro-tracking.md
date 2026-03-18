# Feature: Complete Macro Tracking — Carb Cycling, Fiber, Fat Targets

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Estendere il tracking nutrizionale dalle sole proteine a tutti i macronutrienti (carboidrati, grassi, fibre) con carb cycling per tipo di giorno e target template-based.
**Why?** Il Protocollo Phoenix §4.2 prescrive macro completi, non solo proteine. Il carb cycling (più carb nei giorni training, meno in autophagy) è parte integrante del protocollo. L'app attualmente traccia solo proteine.
**For whom?** Tutti gli utenti che usano il tracking nutrizionale.
**Success metric:** Target giornalieri per tutti i macro; carb cycling automatico per giorno; meal templates con macro completi.

---

## 2. Evidenza Scientifica

### 2.1 Approccio Template-Based (vs Barcode Scanning)
- **Adherence research**: Il barcode scanning ha un tasso di abbandono >50% dopo 2 settimane (Lieffers & Hanning 2012)
- **Template approach**: Piani pasto predefiniti con stime macro sono più sostenibili
- **Raccomandazione**: Estendere i meal templates esistenti con macro completi, NO barcode scanner

### 2.2 Carb Cycling
- **Impey et al. 2018** (Sports Medicine): "Fuel for the work required" — adattare carboidrati al volume di allenamento
- **Protocollo Phoenix approach**:

| Tipo Giorno | Carb (g/kg) | Grassi (% kcal) | Fibre (g) | Razionale |
|-------------|-------------|------------------|-----------|-----------|
| Training (forza) | 4-5 | 25-30% | 30-40 | Glicogeno per performance |
| Normale (riposo) | 3-4 | 30-35% | 30-40 | Mantenimento |
| Autophagy (digiuno) | 2-3 | 35-40% | 25-30 | Low-carb favorisce chetosi e autofagia |

### 2.3 Fibre
- **Reynolds et al. 2019** (Lancet): 25-30g/giorno minimo, 30-40g ottimale per mortalità
- **Fonti**: Già nel food database (legumi, verdure, cereali integrali)
- **Raccomandazione**: Target fisso 30-40g/giorno con tracking

### 2.4 Grassi
- **Target**: 20-35% delle kcal totali (AMDR)
- **Qualità**: Enfasi su grassi monoinsaturi (olio oliva) e omega-3 (pesce)
- **Raccomandazione**: Target come % delle kcal, non g/kg

### 2.5 Tradizione Cinese: Food Therapy (食疗) e Macro Differenziati

#### Chinese Dietary Guidelines 2022 vs Western
| Macro | Cina CDG 2022 | USDA DGA 2020 |
|-------|--------------|---------------|
| Carboidrati | **50-65%** | 45-65% |
| Proteine | 10-15% (popolazione) / 1.7-2.2 g/kg (atleti) | 10-35% |
| Grassi | **20-30%** | 20-35% |

#### Soia = Proteina Animale (Sports Medicine 2023, Systematic Review)
- Soia è **efficace quanto proteina animale** per forza e guadagni muscolari con resistance training
- 20g soia stimola MPS comparabile a whey/casein
- Tofu: 15-17g proteina completa / 100g + calcio (20% DV) + ferro (15% DV)
- Soia ha benefici antiossidanti addizionali post-esercizio
- **Implicazione per Phoenix**: Il food database dovrebbe includere tofu/soia con nota di equivalenza vs proteine animali

#### Five Element Food Therapy (五行食疗)
Classificazione alimenti per natura termica (non temperatura ma effetto metabolico):
- **Cibi "riscaldanti"** (zenzero, agnello, cannella): Post cold exposure recovery
- **Cibi "raffreddanti"** (fagiolo mung, cetriolo, anguria): Post infiammazione/HIIT
- **Cibi "neutri"** (riso, patata): Base quotidiana
- **Implicazione per Phoenix**: Il coach message post-condizionamento potrebbe suggerire cibi complementari (es. "Post cold exposure: zuppa di zenzero per supportare il riscaldamento")

#### Recovery Macro Ratio (Nutrizione Sportiva Cinese)
- Post-esercizio: **60-65% carb / 15-20% protein / ~20% fat** — più specifico del generico "hit protein"
- 20-40g proteine di alta qualità entro 3-4h post-exercise per massimizzare MPS

### 2.6 Tradizione Russa: Periodizzazione Nutrizionale per Mesociclo

#### Nutrizione per Fase (Volkov/Tradizione Sovietica)
| Fase Training | Carb | Proteine | Grassi | Razionale |
|--------------|------|----------|--------|-----------|
| Preparatoria | Moderato | **Alto** | Moderato | Supporto anabolico |
| Competitiva | **Alto** | Moderato | Basso | Glicogeno per performance |
| Transizione | Ridotto | Moderato | Moderato | Prevenzione composizione corporea avversa |

**Differenza dall'Occidente**: L'app potrebbe beneficiare di un **aggiustamento macro a livello di mesociclo** — una 4ª dimensione oltre il cycling giornaliero. Target settimanali/mensili che si adattano alla fase del training (volume vs intensità vs deload).

#### Kefir e Grano Saraceno (Alimenti Recovery Russi)
- **Kefir in atlete di calcio** (Nutrients 2025): Diversità microbiota intestinale migliorata, recovery e infiammazione ridotta. Proteina + probiotici + calcio + vitamina D + magnesio in un alimento
- **Grano saraceno** (гречка): Proteina completa per un cereale (tutti gli aminoacidi essenziali), basso indice glicemico, ricco di rutina (bioflavonoide per salute vascolare)
- **Implicazione per Phoenix**: Kefir e grano saraceno nel food database come alimenti recovery-oriented

#### Fibre e Diversità Alimentare
Ricerca cross-culturale conferma:
- Bassa fibra (comune nelle diete sportive occidentali ad alto contenuto proteico) **compromette il microbiota** e performance
- SCFA (acidi grassi a catena corta) prodotti dai batteri intestinali dalla fibra **migliorano capacità esercizio**
- Entrambe le tradizioni (russa: kefir, verdure fermentate; cinese: soia fermentata, verdure in salamoia) includono naturalmente cibi fermentati/ricchi di fibre

**Fonti cinesi**: Chinese CDC Dietary Guidelines 2022; Soy protein systematic review (PMC 10687132); Five Element Food Therapy
**Fonti russe**: Kefir and Athletic Performance (PMC 11820909); FSBI SPbNIIFK sports nutrition; Nutritional Habits of Combat Athletes (smjournal.ru)

---

## 3. Technical Approach

### 3.1 Extended NutritionCalculator

```dart
class MacroTargets {
  final double proteinG;       // Già esistente
  final double carbG;          // NUOVO
  final double fatG;           // NUOVO
  final double fiberG;         // NUOVO
  final double totalKcal;      // NUOVO

  /// Compute from weight and day type
  factory MacroTargets.forDay({
    required double weightKg,
    required String dayType,     // 'training' / 'normal' / 'autophagy'
    required String tier,
  }) {
    final protein = _proteinForTier(weightKg, tier);
    final carbPerKg = switch (dayType) {
      'training' => 4.5,
      'normal' => 3.5,
      'autophagy' => 2.5,
      _ => 3.5,
    };
    final carb = weightKg * carbPerKg;
    final fiber = dayType == 'autophagy' ? 27.0 : 35.0;

    // Calculate total kcal from protein + carb, then derive fat
    final proteinKcal = protein * 4;
    final carbKcal = carb * 4;
    final fatPercent = switch (dayType) {
      'training' => 0.27,
      'normal' => 0.32,
      'autophagy' => 0.37,
      _ => 0.30,
    };
    // totalKcal = (proteinKcal + carbKcal) / (1 - fatPercent)
    final totalKcal = (proteinKcal + carbKcal) / (1 - fatPercent);
    final fatG = (totalKcal * fatPercent) / 9;

    return MacroTargets(
      proteinG: protein,
      carbG: carb,
      fatG: fatG,
      fiberG: fiber,
      totalKcal: totalKcal,
    );
  }
}
```

### 3.2 Extend Meal Templates

```dart
// Current meal_templates has: protein_estimate_g, calories_estimate
// Add: carb_estimate_g, fat_estimate_g, fiber_estimate_g

// In MealTemplateSeed, update each template with full macros
// Example:
{
  'day_type': 'training',
  'meal_number': 1,
  'time_slot': 'breakfast',
  'protein_estimate_g': 40,
  'carb_estimate_g': 55,     // NEW
  'fat_estimate_g': 15,       // NEW
  'fiber_estimate_g': 8,      // NEW
  'calories_estimate': 515,
  'ingredients': [...],
}
```

### 3.3 Extend Meal Logging

```dart
// Current meal_logs has: protein_estimate
// Add macro estimates per meal

// In NutritionTab, show all macros:
// - Protein: 120/150g ████████░░ 80%
// - Carbs:   280/340g ██████░░░░ 82%
// - Fat:      65/80g  ████████░░ 81%
// - Fiber:    25/35g  ███████░░░ 71%
```

### 3.4 Database Changes

```sql
-- Extend meal_templates
ALTER TABLE meal_templates ADD COLUMN carb_estimate_g REAL DEFAULT 0;
ALTER TABLE meal_templates ADD COLUMN fat_estimate_g REAL DEFAULT 0;
ALTER TABLE meal_templates ADD COLUMN fiber_estimate_g REAL DEFAULT 0;

-- Extend meal_logs
ALTER TABLE meal_logs ADD COLUMN carb_estimate REAL;
ALTER TABLE meal_logs ADD COLUMN fat_estimate REAL;
ALTER TABLE meal_logs ADD COLUMN fiber_estimate REAL;
ALTER TABLE meal_logs ADD COLUMN calories_estimate REAL;
```

---

## 4. UI Changes

### 4.1 NutritionCard (Today Screen)
- Attualmente: solo protein progress bar
- Dopo: 4 barre (proteine, carb, grassi, fibre) con target per tipo giorno
- Label giorno: "Giorno Training — più carboidrati per performance"

### 4.2 NutritionTab Enhancement
- Macro donut chart (proteine/carb/grassi come %)
- Target vs actual per ogni macro
- Daily carb cycling indicator

### 4.3 Meal Logging
- Quando l'utente logga un pasto, stima tutti i macro (non solo proteine)
- Quick-add da template: auto-compila tutti i macro

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/nutrition_calculator.dart` | Modify | Add MacroTargets with carb/fat/fiber |
| `core/models/meal_plan_generator.dart` | Modify | Generate plans with full macros |
| `core/database/seed/meal_template_seed.dart` | Modify | Add carb/fat/fiber to all 9 templates |
| `core/database/tables.dart` | Modify | Extend meal_templates and meal_logs |
| `core/database/database.dart` | Modify | Migration |
| `features/today/widgets/nutrition_card.dart` | Modify | 4 macro progress bars |
| `features/fasting/nutrition_tab.dart` | Modify | Full macro display, donut chart |
| `core/database/daos/meal_log_dao.dart` | Modify | Include new macro columns |

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Training day carbs | 80kg, training | carb=360g (4.5g/kg) | High |
| UT-02 | Autophagy day carbs | 80kg, autophagy | carb=200g (2.5g/kg) | High |
| UT-03 | Fiber target training | training | 35g | High |
| UT-04 | Fat % training | training | ~27% of total kcal | High |
| UT-05 | Fat % autophagy | autophagy | ~37% of total kcal | High |
| UT-06 | Total kcal consistency | any | protein*4 + carb*4 + fat*9 ≈ totalKcal | High |

---

## 7. Dipendenze

- **Meal template system (esistente)**: Si estende con nuove colonne
- **NutritionCalculator (esistente)**: Si estende con MacroTargets
- **Indipendente** dalle fasi di training

---

**Attesa PROCEED.**
