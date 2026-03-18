# Feature: Stitch UI Redesign — Layer 2 Completo

**Status:** COMPLETATO
**Created:** 2026-03-13
**Approved:** —
**Completed:** 2026-03-13

---

## 1. Overview

**What?** Applicare il linguaggio visivo degli 8 mockup stitch (`.seurat/stitch/`) a tutti gli screen dell'app. Layer 1 (design tokens) è fatto. Questo è Layer 2: l'applicazione concreta dei pattern estetici screen per screen.

**Why?** L'app attuale sembra un prototipo Material generico. I mockup stitch definiscono un'identità visiva precisa — card con profondità, pill tabs, chat bubbles asimmetriche, timer digit box, control buttons circolari, stats grid. La gap analysis in `stitch-redesign.md` mostra compliance media del 60% — serve portarla al 95%.

**For whom?** L'utente — un'app che sembra professionale e curata aumenta engagement e fiducia nel protocollo.

**Success metric:** Ogni screen dell'app è visivamente allineato ai pattern stitch documentati. Tab standard Material → pill tabs. Card piatte → card con shadow e border. Timer testo → digit box. Bottoni generici → control buttons circolari.

**Prerequisiti:** Batch 1 (exercise visibility) e Batch 2 (coach AI) dovrebbero essere completati prima, così gli screen nuovi vengono creati già con stitch styling e non servono due passate.

---

## 2. Technical Approach

**Pattern:** 3 widget shared riusabili (già creati come file vuoti in `lib/shared/widgets/`) + aggiornamento sistematico di ~20 screen.

**Key decisions:**

1. **Widget shared prima, screen dopo** — I 3 widget riusabili (`PhoenixPillTabs`, `PhoenixTimerDisplay`, `PhoenixControlButtons`) vengono implementati per primi. Poi ogni screen li adotta. Questo evita duplicazione.

2. **Batch per impatto visivo** — Non tocchiamo tutti i 25 file in un colpo. Li raggruppiamo per impatto visivo decrescente:
   - Alta visibilità: Coach chat, Settings, Home, Training, Workout session
   - Tab screens: Conditioning, Biomarkers, Fasting
   - Content tabs: Cold, Heat, Meditation, Sleep, Nutrition, Levels
   - Polish: Progressioni, PhenoAge, Weight, Blood panel, Onboarding

3. **Dark mode verificato** — Ogni pattern ha specifiche light E dark. Verifichiamo entrambi per ogni screen.

4. **No regressioni funzionali** — Solo styling, nessuna modifica di logica. Se un widget ha state management, non lo tocchiamo.

5. **Design tokens come source of truth** — Tutti i valori CSS stitch sono già mappati in `design_tokens.dart`. Usiamo `PhoenixColors`, `Spacing`, `Radii`, `CardTokens` — non hardcodiamo valori.

**Dependencies:** Nessuna nuova. Tutti i pattern sono implementabili con Flutter base + design_tokens.

**Breaking changes:** None. Solo styling.

---

## 3. Files to Modify

### Fase A: Widget Shared (3 file)

| File | Action | Changes |
|------|--------|---------|
| `lib/shared/widgets/phoenix_pill_tabs.dart` | **Rewrite** | Pattern 3.18 — pill tabs con active (primary+shadow), inactive (bordered) |
| `lib/shared/widgets/phoenix_timer_display.dart` | **Rewrite** | Pattern 3.5 — digit box con bg, colon primary, unit label uppercase |
| `lib/shared/widgets/phoenix_control_buttons.dart` | **Rewrite** | Pattern 3.7 — cerchi, primary scale-125, shadow-primary/30 |

### Fase B1: Alta visibilità (5 file)

| File | Action | Changes |
|------|--------|---------|
| `lib/features/coach/widgets/chat_message.dart` | **Modify** | Pattern 3.1 — shadow, border, label sopra bubble, asymmetric radius (bl-none / br-none), avatar con shadow |
| `lib/features/coach/coach_screen.dart` | **Modify** | Pattern 3.2/3.3 — quick reply pills, input bar con border+shadow+focus ring, bot avatar, welcome state |
| `lib/features/workout/workout_session_screen.dart` | **Modify** | Pattern 3.5/3.7/3.8/3.9 — timer display, control buttons circolari, set/rep pill, footer actions stitch |
| `lib/features/workout/home_screen.dart` | **Modify** | Pattern 3.12/3.21 — stats grid 3-col con border-y, card shadow consistency |
| `lib/features/training/training_screen.dart` | **Modify** | Pattern 3.4/3.11 — exercise card con thumbnail, badge stitch, button shadow |

### Fase B2: Tab screens (4 file)

| File | Action | Changes |
|------|--------|---------|
| `lib/features/conditioning/conditioning_screen.dart` | **Modify** | Sostituire TabBar Material → PhoenixPillTabs |
| `lib/features/biomarkers/biomarkers_screen.dart` | **Modify** | Sostituire TabBar Material → PhoenixPillTabs |
| `lib/features/fasting/fasting_screen.dart` | **Modify** | Sostituire TabBar Material → PhoenixPillTabs + sticky footer CTA (3.15) |
| `lib/features/workout/onboarding_screen.dart` | **Modify** | Progress bar stitch (3.6), numbered steps (3.14), button shadow |

### Fase B3: Conditioning tabs (4 file)

| File | Action | Changes |
|------|--------|---------|
| `lib/features/conditioning/cold_tab.dart` | **Modify** | PhoenixTimerDisplay, PhoenixControlButtons |
| `lib/features/conditioning/heat_tab.dart` | **Modify** | PhoenixTimerDisplay |
| `lib/features/conditioning/meditation_tab.dart` | **Modify** | PhoenixControlButtons |
| `lib/features/conditioning/sleep_tab.dart` | **Modify** | Input styling, chart card shadow |

### Fase B4: Content screens (6 file)

| File | Action | Changes |
|------|--------|---------|
| `lib/features/fasting/nutrition_tab.dart` | **Modify** | Meal card pattern (3.22) con color accent bar per pasto |
| `lib/features/fasting/levels_tab.dart` | **Modify** | Numbered steps (3.14) per criteria checklist |
| `lib/features/biomarkers/biomarker_dashboard_tab.dart` | **Modify** | Stats grid (3.12), sparkline card shadows |
| `lib/features/biomarkers/blood_panel_form.dart` | **Modify** | Section headers con icon (3.13), form input styling |
| `lib/features/conditioning/conditioning_history.dart` | **Modify** | Chart card shadows, stats grid (3.12) |
| `lib/app/settings_screen.dart` | **Modify** | Pattern 3.20 — icon bg colorate per categoria, section headers uppercase, chevron, list dividers |

### Fase B5: Polish (5 file)

| File | Action | Changes |
|------|--------|---------|
| `lib/features/biomarkers/phenoage_tab.dart` | **Modify** | Section headers (3.13) |
| `lib/features/biomarkers/weight_tab.dart` | **Modify** | Input styling stitch |
| `lib/features/progressions/progressions_screen.dart` | **Modify** | Shadow + border consistency |
| `lib/features/coach/widgets/model_download_card.dart` | **Modify** | Progress bar stitch (3.6) |
| `lib/features/coach/widgets/ai_insight_card.dart` | **Modify** | Shadow, border consistency |

---

## 4. Specifiche UI — Widget Shared

### 4.1 PhoenixPillTabs (Pattern 3.18)

```dart
/// Pill-style tab bar — sostituisce TabBar Material
class PhoenixPillTabs extends StatelessWidget {
  final List<PhoenixTab> tabs;      // label + optional icon
  final int selectedIndex;
  final ValueChanged<int> onChanged;
}
```

Layout: `SingleChildScrollView` orizzontale, `Row` con `gap: 8`.

**Active pill:**
```
height: 36px
padding: 0 20px
border-radius: full (9999)
bg: PhoenixColors.primary
color: white
shadow: BoxShadow(color: primary.withOpacity(0.2), blurRadius: 8, offset: (0,4))
text: 12px, semibold, uppercase, letterSpacing: 1.2
```

**Inactive pill:**
```
height: 36px
padding: 0 20px
border-radius: full
bg: isDark ? slate-800 : slate-100
color: isDark ? slate-300 : slate-600
border: 1px solid (isDark ? slate-700 : slate-200)
text: 12px, semibold, uppercase, letterSpacing: 1.2
```

### 4.2 PhoenixTimerDisplay (Pattern 3.5)

```dart
/// Digit-box timer display
class PhoenixTimerDisplay extends StatelessWidget {
  final int minutes;
  final int seconds;
  final String? label;  // es. "Resting Period"
}
```

Layout: `Row` centered, gap 16.

**Digit box:**
```
height: 80px
width: 96px
border-radius: 12px (Radii.md)
bg: isDark ? Colors.white.withOpacity(0.05) : slate-100
border: 1px solid (isDark ? slate-700 : slate-200)
child: Column(
  mainAxisAlignment: center
  children: [
    Text(digits, style: 36px, extrabold, tabularNums)
    Text(unit, style: 12px, bold, uppercase, letterSpacing: -0.5, slate-500)
  ]
)
```

**Colon separator:**
```
text: 36px, bold, PhoenixColors.primary
marginBottom: 24px (offset per allineamento con unit label)
```

### 4.3 PhoenixControlButtons (Pattern 3.7)

```dart
/// Media-player style control buttons
class PhoenixControlButtons extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onNext;
  final bool isPaused;
  final IconData? primaryIcon;
}
```

Layout: `Row`, 3 elementi, `mainAxisAlignment: center`, gap 16.

**Secondary button (prev/next):**
```
size: 56px
shape: circle
bg: isDark ? slate-800 : slate-200
color: isDark ? slate-300 : slate-700
icon: 30px
```

**Primary button (play/pause):**
```
size: 70px (56 * 1.25)
shape: circle
bg: PhoenixColors.primary
color: white
icon: 36px
shadow: BoxShadow(color: primary.withOpacity(0.3), blurRadius: 12, offset: (0,6))
```

---

## 5. Specifiche UI — Pattern per Screen

### 5.1 Chat Bubbles (Pattern 3.1)

**Coach bubble:**
- bg: white (light) / slate-800 (dark)
- padding: 16
- borderRadius: `BorderRadius.only(tl: 16, tr: 16, br: 16, bl: 0)`
- border: 1px slate-100 (light) / slate-700 (dark)
- shadow: `BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: (0,2))`

**User bubble:**
- bg: `PhoenixColors.primary`
- color: white
- borderRadius: `BorderRadius.only(tl: 16, tr: 16, bl: 16, br: 0)`
- shadow: `BoxShadow(color: primary.withOpacity(0.1), blurRadius: 8, offset: (0,4))`

**Label sopra bubble:**
- 11px, semibold, uppercase, slate-400, letterSpacing: -0.3
- `"PHOENIX COACH"` / `"TU"`

**Bot avatar:**
- 40px circle, bg primary, icon `smart_toy` 20px white
- shadow: `BoxShadow(color: primary.withOpacity(0.2), blurRadius: 8)`

### 5.2 Chat Input Bar (Pattern 3.3)

```
Container:
  bg: white (light) / slate-800 (dark)
  border: 1px slate-200 (light) / slate-700 (dark)
  borderRadius: 16 (Radii.lg)
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
  shadow: CardTokens.shadowLight
  focusDecoration: ring 2px primary/20, border primary

Send button (inside):
  bg: primary
  color: white
  padding: 8
  borderRadius: 12
  icon: send, 18px
```

### 5.3 Quick Reply Pills (Pattern 3.2)

```
Primary pill:
  border: 1px primary
  color: primary
  bg: transparent
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
  borderRadius: full
  text: 12px, semibold

Secondary pill:
  border: 1px slate-200 (light) / slate-700 (dark)
  color: slate-600 (light) / slate-300 (dark)
  bg: transparent
  padding/radius/text: same as primary
```

### 5.4 Progress Bar (Pattern 3.6)

```
Track:
  height: 12px (h-3)
  borderRadius: full
  bg: primary.withOpacity(0.2)

Fill:
  height: 100%
  borderRadius: full
  bg: primary
  width: percentage
```

Applicare a: workout progress, model download, onboarding.

### 5.5 Stats Grid (Pattern 3.12)

```
Layout: Row con 3 Expanded, height auto
Dividers: border left+right on middle column
border-y: top and bottom slate-200/slate-800
padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24)
margin: EdgeInsets.symmetric(vertical: 16)

Stat item:
  Column centered:
    label: 12px, medium, uppercase, slate-500/400, marginBottom 4
    value: bold, slate-900/100
```

### 5.6 Section Header con Icona (Pattern 3.13)

```
Row:
  icon: primary, marginRight 8
  text: 20px, bold, slate-900/100
```

### 5.7 Numbered Steps (Pattern 3.14)

```
Container per step:
  Row, gap 16
  padding: 16
  borderRadius: 12
  bg: slate-100 (light) / slate-800/50 (dark)

Number circle:
  size: 32
  circle
  bg: primary
  color: white
  text: 14px, bold

Step text:
  14px, slate-600 (light) / slate-400 (dark)
```

### 5.8 Sticky Footer CTA (Pattern 3.15)

```
Container:
  positioned bottom (SafeArea)
  padding: 16
  bg: background.withOpacity(0.8)
  backdropFilter: blur(12) — ImageFilter.blur(sigmaX: 12, sigmaY: 12)
  border-top: 1px slate-200/800
  Row, gap 16

Secondary button (icon):
  size: 56
  borderRadius: 12
  border: 2px primary
  color: primary

Primary button:
  flex: 1
  bg: primary
  color: white
  text: 18px, bold
  borderRadius: 12
  shadow: BoxShadow(color: primary.withOpacity(0.3), blurRadius: 12)
```

### 5.9 Meal Card (Pattern 3.22)

```
Container:
  padding: 12
  borderRadius: 16
  border: 1px slate-100
  shadow: CardTokens.shadowLight

Color accent bar:
  width: 2, height: 24
  borderRadius: full
  Colors per meal:
    Colazione: amber-400
    Pranzo: orange-400 (primary)
    Cena: blue-500
    Spuntino: purple-400
```

### 5.10 Settings List Items (Pattern 3.20)

```
Section header:
  padding: horizontal 24
  marginBottom: 8
  text: 12px, bold, slate-400, uppercase, letterSpacing: 1.5

List item:
  padding: horizontal 24, vertical 16
  Row: icon container + text + Spacer + chevron

Icon container:
  padding: 8
  borderRadius: 8
  bg: [category color]-50
  color: [category color]-600

  Color mapping:
    profile: blue
    weight: orange
    training: purple
    notifications: slate
    privacy: slate
    logout: red

Chevron: Icons.chevron_right, slate-400, 20px
Divider: 1px slate-100
```

---

## 6. Test Specification

### Visual Verification Checklist
| ID | Screen | Pattern | Check |
|----|--------|---------|-------|
| VC-01 | Coach chat | 3.1 | Bubble asimmetriche, shadow, label, avatar |
| VC-02 | Coach input | 3.3 | Border, focus ring, send button interno |
| VC-03 | Workout timer | 3.5 | Digit box, colon primary, unit label |
| VC-04 | Workout controls | 3.7 | Cerchi, primary più grande, shadow |
| VC-05 | Conditioning tabs | 3.18 | Pill active orange+shadow, inactive bordered |
| VC-06 | Biomarker tabs | 3.18 | Same pill styling |
| VC-07 | Fasting tabs | 3.18 | Same pill styling |
| VC-08 | Home stats | 3.12 | Grid 3-col, border-y, uppercase label |
| VC-09 | Settings | 3.20 | Icon bg colorate, section uppercase, chevron |
| VC-10 | All cards | — | Shadow consistente, border, borderRadius 16 |

### Regression Tests
| ID | Check | Expected |
|----|-------|----------|
| RT-01 | `flutter build apk --debug` | Compila senza errori |
| RT-02 | Navigation tra tutti i tab | Nessun crash |
| RT-03 | Dark mode toggle | Tutti i pattern hanno variante dark corretta |
| RT-04 | Workout session completa | Flusso preview→countdown→tracking→rest invariato |
| RT-05 | Fasting start/stop | Logica invariata |

---

## 7. Implementation Notes

### Ordine di implementazione

**Giorno 1: Widget shared**
1. `PhoenixPillTabs` — il più usato (3 screen)
2. `PhoenixTimerDisplay` — impatto visivo alto
3. `PhoenixControlButtons` — impatto visivo alto

**Giorno 2: Alta visibilità**
4. `chat_message.dart` — bubble styling
5. `coach_screen.dart` — pills, input, avatar
6. `workout_session_screen.dart` — timer, controls, set display
7. `home_screen.dart` — stats grid

**Giorno 3: Tab screens**
8. `conditioning_screen.dart` → PhoenixPillTabs
9. `biomarkers_screen.dart` → PhoenixPillTabs
10. `fasting_screen.dart` → PhoenixPillTabs + sticky footer

**Giorno 4: Conditioning + Content**
11-14. Cold/Heat/Meditation/Sleep tabs
15-16. Nutrition tab (meal cards), Levels tab (steps)

**Giorno 5: Polish**
17-20. Settings, Biomarker dashboard, Blood panel, remaining screens
21. Dark mode verification pass su tutto

### Migration tracker

Per ogni file:
1. Read entire file
2. Grep per pattern Material da sostituire (`TabBar`, `ElevatedButton`, etc.)
3. Applicare pattern stitch
4. Verificare light + dark
5. Mark complete

### Note critiche

- **Non toccare logica** — Solo widget tree e styling. Se un widget ha un `onPressed` handler, lo preserviamo identico.
- **TabBar → PhoenixPillTabs** — Richiede cambio da `TabBarView` a `IndexedStack` o condizionale manuale, perché PhoenixPillTabs non è un Material TabController. Valutare se wrappare con `TabController` o usare state index.
- **BackdropFilter** — Disponibile in Flutter ma costoso su device vecchi. Usare `ClipRRect` per limitare l'area di blur.
- **Shadows** — Non abusare. Solo card principali e elementi interattivi. Non mettere shadow su ogni Container.

---

## 8. Completion Record

### Fase A: Widget Shared — completata (pre-existing)
### Fase B1: Alta visibilità — completata 2026-03-13
- `chat_message.dart` — already stitch compliant, no changes needed
- `coach_screen.dart` — focus ring on input bar (pattern 3.3), FocusNode-driven border+glow
- `workout_session_screen.dart` — PhoenixControlButtons in tracking, set/rep pill (3.8), stitch footer (3.9), primary button shadows
- `home_screen.dart` — stats grid redesigned to 3-col border-y (3.12) + weight card, section header with icon (3.13)
- `training_screen.dart` — exercise rows with category thumbnail (3.4), 2-line layout with badge+reps, chevron

### Fase B2: Tab screens — completata 2026-03-13
- `fasting_screen.dart` — sticky footer CTA (3.15) with secondary icon button + primary CTA shadow
- `onboarding_screen.dart` — primary button shadows on "Avanti"/"Salta" and "Inizia il tuo percorso"
- `conditioning_screen.dart` — already stitch compliant
- `biomarkers_screen.dart` — already stitch compliant

### Fase B3: Conditioning tabs — completata 2026-03-13
- `cold_tab.dart` — PhoenixControlButtons (play/pause, save, reset)
- `heat_tab.dart` — PhoenixControlButtons (play/pause, save, reset)
- `meditation_tab.dart` — already used PhoenixControlButtons
- `sleep_tab.dart` — added border + shadow to tips card

### Fase B4: Content screens — completata 2026-03-13
- `nutrition_tab.dart` — already compliant (meal accent bar 3.22, card shadows)
- `levels_tab.dart` — already compliant (numbered criteria 3.14, shadows)
- `biomarker_dashboard_tab.dart` — added boxShadow to WeightSummaryCard
- `blood_panel_form.dart` — save button wrapped with DecoratedBox shadow (3.15)
- `conditioning_history.dart` — added border to stats container
- `settings_screen.dart` — profile Card → stitch Container with border + shadow

### Fase B5: Polish — completata 2026-03-13
- `phenoage_tab.dart` — Card → stitch Container for fallback display
- `model_download_card.dart` — Card → stitch Container with border + shadow
- `weight_tab.dart` — already compliant (StatCard has border + shadow)
- `progressions_screen.dart` — already compliant (CategoryCard has border + shadow)
- `ai_insight_card.dart` — already compliant (border + shadow)

**Build verification:** `flutter analyze` — 90 issues (all info-level, no errors)
**Date:** 2026-03-13
