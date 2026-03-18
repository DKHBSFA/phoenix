# Redesign Completo — Ispirazione Stitch

**Date:** 2026-03-12
**Status:** Layer 1 completato, Layer 2 da implementare
**Source:** `.seurat/stitch/` (8 screen HTML+PNG)

---

## 1. Obiettivo

Applicare a tutti gli screen dell'app Phoenix il linguaggio visivo estratto dagli 8 mockup stitch. Il design system base (colori, font, radii, theme) è già allineato. Questa spec copre **Layer 2**: l'applicazione screen-by-screen dei pattern estetici concreti.

---

## 2. Layer 1 — Design System (COMPLETATO)

Già applicato in `design_tokens.dart` + `theme.dart`:

- **Palette:** primary `#EC5B13`, warm dark `#221610`, warm light `#F8F6F6`
- **Font:** Public Sans (UI) + IBM Plex Mono (numeri/timer)
- **Radii:** sm=8, md=12, lg=16, xl=24
- **Input:** filled, no border, focus ring primary/50
- **Card:** rounded-16, border warm, shadow-sm light
- **Button:** rounded-16, primary bg, white text
- **Chip:** pill, primary/10 bg, uppercase bold 11px

---

## 3. Pattern Catalog — Estratti dagli HTML Stitch

Ogni pattern è catalogato con sorgente, specifiche CSS esatte, e dove applicarlo nell'app.

### 3.1 Chat Bubbles
**Sorgente:** `assistente_ai/code.html` righe 66-91

#### Coach bubble
```
bg: white (light) / slate-800 (dark)
padding: 16px
border-radius: 16px (rounded-2xl), bottom-left: 0 (rounded-bl-none)
border: 1px solid slate-100 (light) / slate-700 (dark)
shadow: shadow-sm
text: 14px leading-relaxed
```

#### User bubble
```
bg: primary (#EC5B13)
color: white
padding: 16px
border-radius: 16px (rounded-2xl), bottom-right: 0 (rounded-br-none)
shadow: shadow-md shadow-primary/10
text: 14px leading-relaxed
```

#### Bot avatar
```
size: 40px (size-10)
shape: circle (rounded-full)
bg: primary
color: white
shadow: shadow-lg shadow-primary/20
icon: smart_toy 20px
```

#### Label sopra bubble
```
font-size: 11px (text-[11px])
font-weight: 600 (font-semibold)
color: slate-400 (light) / slate-500 (dark)
text-transform: uppercase
letter-spacing: tight (tracking-tight)
margin-left: 8px
```

**Applicare a:** `chat_message.dart`

### 3.2 Quick Reply Pills
**Sorgente:** `assistente_ai/code.html` righe 120-130

```
Primary pill:
  border: 1px solid primary
  color: primary
  bg: transparent → hover: primary/5
  padding: 8px 16px (py-2 px-4)
  border-radius: full (rounded-full)
  font: 12px semibold (text-xs font-semibold)

Secondary pill:
  border: 1px solid slate-200 (light) / slate-700 (dark)
  color: slate-600 (light) / slate-300 (dark)
  bg: transparent → hover: slate-100 (light) / slate-800 (dark)
  (stesso padding/radius/font)
```

**Applicare a:** `coach_screen.dart` (report chips, chat suggestions)

### 3.3 Chat Input Bar
**Sorgente:** `assistente_ai/code.html` righe 133-148

```
Container:
  bg: white (light) / slate-800 (dark)
  border: 1px solid slate-200 (light) / slate-700 (dark)
  border-radius: 16px (rounded-2xl)
  padding: 8px 16px (py-2 px-4)
  shadow: shadow-sm
  focus-within: ring-2 ring-primary/20, border-color: primary

Send button (interno):
  bg: primary
  color: white
  padding: 8px (p-2)
  border-radius: 12px (rounded-xl)

Icon buttons (mic, add):
  color: slate-400 → hover: primary
  padding: 4px (p-1)
```

**Applicare a:** `coach_screen.dart` (input area chat)

### 3.4 Exercise Card (lista)
**Sorgente:** `lista_esercizi/code.html` righe 91-118

```
Container:
  display: flex row
  bg: slate-50 (light) / slate-800/50 (dark)
  border-radius: 16px (rounded-2xl)
  border: 1px solid slate-100 (light) / slate-800 (dark)
  overflow: hidden
  hover: border-color primary/30
  cursor: pointer

Thumbnail:
  width: 112px (w-28)
  height: 112px (h-28)
  object-fit: cover
  gradient overlay: from-black/20 to-transparent (bottom-to-top)

Content area:
  flex: 1
  padding: 12px (p-3)
  display: flex column, justify-between

Title:
  font-weight: 700 (font-bold)
  color: slate-900 (light) / white (dark)
  hover: primary color

Muscle badges:
  font-size: 10px (text-[10px])
  padding: 2px 8px (py-0.5 px-2)
  border-radius: full
  font-weight: 700 (font-bold)
  text-transform: uppercase
  Primary badge: bg primary/10, color primary
  Secondary badge: bg slate-200 (light) / slate-700 (dark), color slate-600/400

Meta info:
  display: flex row, gap 12px (gap-3)
  color: slate-500 (light) / slate-400 (dark)
  icon: 14px (text-sm)
  text: 12px medium (text-xs font-medium)

Favorite icon:
  color: slate-300 → hover: primary
  size: 18px (text-lg)
  active state: primary color, filled icon
```

**Applicare a:** exercise list views, training_screen.dart

### 3.5 Workout Timer Display
**Sorgente:** `esecuzione_allenamento/code.html` righe 78-95

```
Timer container:
  display: flex row, gap 16px (gap-4), items-center

Digit box:
  height: 80px (h-20)
  width: 96px (w-24)
  border-radius: 12px (rounded-xl)
  bg: slate-100 (light) / slate-800/50 (dark)
  border: 1px solid slate-200 (light) / slate-700 (dark)
  display: flex, items-center, justify-center

Digit text:
  font-size: 36px (text-4xl)
  font-weight: 800 (font-extrabold)
  font-feature: tabular-nums

Colon separator:
  font-size: 36px (text-4xl)
  font-weight: 700 (font-bold)
  color: primary
  margin-bottom: 24px (mb-6) — offset per allineare con label

Unit label:
  font-size: 12px (text-xs)
  font-weight: 700 (font-bold)
  text-transform: uppercase
  letter-spacing: tighter (tracking-tighter)
  color: slate-500 (light) / slate-400 (dark)

Resting label:
  margin-top: 16px (mt-4)
  color: slate-400 (light) / slate-500 (dark)
  font-size: 14px (text-sm)
```

**Applicare a:** `workout_session_screen.dart` (rest timer), `cold_tab.dart`, `heat_tab.dart`, `meditation_tab.dart`

### 3.6 Progress Bar
**Sorgente:** `esecuzione_allenamento/code.html` riga 66-68

```
Track:
  height: 12px (h-3)
  border-radius: full (rounded-full)
  bg: primary/20

Fill:
  height: 100%
  border-radius: full (rounded-full)
  bg: primary
  width: [percentage]%
```

**Applicare a:** `workout_session_screen.dart`, `onboarding_screen.dart`, `model_download_card.dart`

### 3.7 Workout Control Buttons
**Sorgente:** `esecuzione_allenamento/code.html` righe 104-114

```
Layout: grid 3-col, gap 16px (gap-4), items-center, max-w-md

Secondary control (prev/next):
  aspect-ratio: square
  shape: circle (rounded-full)
  bg: slate-200 (light) / slate-800 (dark)
  color: slate-700 (light) / slate-300 (dark)
  icon: 30px (text-3xl)

Primary control (play/pause):
  aspect-ratio: square
  shape: circle (rounded-full)
  bg: primary
  color: white
  scale: 1.25 (scale-125)
  shadow: shadow-lg shadow-primary/30
  icon: 36px (text-4xl)
```

**Applicare a:** `workout_session_screen.dart`, `meditation_tab.dart`

### 3.8 Set/Rep Display
**Sorgente:** `esecuzione_allenamento/code.html` righe 97-101

```
Set number:
  font-size: 48px (text-5xl)
  font-weight: 900 (font-black)
  letter-spacing: tight (tracking-tight)
  text-align: center

Rep/weight pill:
  padding: 8px 24px (py-2 px-6)
  border-radius: full (rounded-full)
  bg: primary/10
  border: 1px solid primary/20

  Text: primary color, 24px bold (text-2xl font-bold), tracking-tight
  Separator: mx-2, opacity-30, color slate-400
```

**Applicare a:** `workout_session_screen.dart`

### 3.9 Action Buttons (footer)
**Sorgente:** `esecuzione_allenamento/code.html` righe 116-124

```
Layout: flex row, gap 12px (gap-3)

Secondary button:
  flex: 1
  padding: 16px vertical (py-4)
  bg: slate-100 (light) / slate-800 (dark)
  border-radius: 12px (rounded-xl)
  font-weight: 700 (font-bold)
  color: slate-700 (light) / slate-300 (dark)
  border: 1px solid slate-200 (light) / slate-700 (dark)

Primary button:
  flex: 1
  padding: 16px vertical (py-4)
  bg: primary
  color: white
  border-radius: 12px (rounded-xl)
  font-weight: 700 (font-bold)
  shadow: shadow-md
```

**Applicare a:** `workout_session_screen.dart`, form screens

### 3.10 Exercise Detail — Video Hero
**Sorgente:** `dettaglio_esercizio/code.html` righe 49-67

```
Container:
  aspect-ratio: 16/9 (aspect-video)
  margin: 0 16px (mx-4)
  border-radius: 12px (rounded-xl)
  overflow: hidden
  shadow: shadow-lg
  bg-size: cover, bg-position: center

Overlay:
  bg: black/30 → hover: black/20
  transition: all

Play button:
  size: 64px (size-16)
  shape: circle (rounded-full)
  bg: primary
  color: white
  shadow: shadow-xl
  hover: scale(1.1) (hover:scale-110)
  transition: transform

Progress scrubber (bottom):
  bg gradient: from-black/80 to-transparent (bottom-to-top)
  bar height: 6px (h-1.5)
  played: primary color
  thumb: 14px circle, primary bg, 2px white border, shadow-md
  remaining: white/30
  timestamps: white, 12px medium
```

**Applicare a:** future exercise detail screen

### 3.11 Exercise Detail — Badges
**Sorgente:** `dettaglio_esercizio/code.html` righe 71-84

```
Container: flex row, gap 8px (gap-2), wrap

Badge:
  height: 32px (h-8)
  padding: 0 12px (px-3)
  border-radius: 8px (rounded-lg)
  bg: primary/10 (light) / primary/20 (dark)
  border: 1px solid primary/20
  display: flex, items-center

  Icon: primary color, 14px (text-sm), margin-right 6px (mr-1.5)
  Text: primary color, 12px (text-xs), semibold, uppercase, tracking-wider
```

**Applicare a:** training_screen.dart (exercise type badges), workout_session_screen.dart

### 3.12 Stats Grid (3 colonne)
**Sorgente:** `dettaglio_esercizio/code.html` righe 87-100

```
Layout:
  display: grid, 3-col, gap 16px (gap-4)
  padding: 16px horizontal, 24px vertical (px-4 py-6)
  border: top + bottom, slate-200 (light) / slate-800 (dark)
  margin: 16px vertical (my-4)

Stat item:
  display: flex column, items-center

  Label: slate-500/400, 12px (text-xs), medium, uppercase, margin-bottom 4px
  Value: slate-900/100, font-bold

Middle column: border left + right (border-x)
```

**Applicare a:** `biomarker_dashboard_tab.dart`, `home_screen.dart` (stats cards)

### 3.13 Section Header con Icona
**Sorgente:** `dettaglio_esercizio/code.html` righe 104-107

```
display: flex, items-center
icon: primary color, margin-right 8px (mr-2)
text: slate-900/100, 20px (text-xl), font-bold
```

**Applicare a:** tutti gli screen con sezioni (biomarkers, conditioning, settings)

### 3.14 Numbered Steps
**Sorgente:** `dettaglio_esercizio/code.html` righe 137-149

```
Container:
  display: flex row, gap 16px (gap-4)
  padding: 16px (p-4)
  border-radius: 12px (rounded-xl)
  bg: slate-100 (light) / slate-800/50 (dark)

Number circle:
  size: 32px (size-8)
  shape: circle (rounded-full)
  bg: primary
  color: white
  font-weight: 700 (font-bold)
  font-size: 14px (text-sm)
  flex-shrink: 0

Step text:
  color: slate-600 (light) / slate-400 (dark)
  font-size: 14px (text-sm)
```

**Applicare a:** `onboarding_screen.dart`, `levels_tab.dart` (fasting criteria)

### 3.15 Sticky Footer CTA
**Sorgente:** `dettaglio_esercizio/code.html` righe 154-162

```
Container:
  position: fixed bottom
  padding: 16px (p-4)
  bg: background-light/80 (light) / background-dark/80 (dark)
  backdrop-filter: blur(12px) (-md)
  border-top: 1px solid slate-200 (light) / slate-800 (dark)
  display: flex row, gap 16px (gap-4)

Secondary button (heart/icon):
  size: 56px (size-14)
  border-radius: 12px (rounded-xl)
  border: 2px solid primary
  color: primary
  hover: bg primary/10

Primary button:
  flex: 1
  bg: primary
  color: white
  font-weight: 700 (font-bold)
  font-size: 18px (text-lg)
  border-radius: 12px (rounded-xl)
  shadow: shadow-lg shadow-primary/30
  hover: brightness(110%)
  active: scale(0.98)
  transition: all
```

**Applicare a:** `workout_session_screen.dart` (bottom actions), `fasting_screen.dart` (start fast button)

### 3.16 Header con Back Button
**Sorgente:** `lista_esercizi/code.html` righe 49-58

```
Layout: flex row, items-center, justify-between
padding: 16px horizontal, 24px top, 8px bottom (px-4 pt-6 pb-2)
bg: white/80 (light) / slate-900/80 (dark)
backdrop-filter: blur(12px)
sticky: top, z-20

Back button:
  size: 40px (w-10 h-10)
  shape: circle (rounded-full)
  bg: slate-100 (light) / slate-800 (dark)
  icon: slate-600 (light) / slate-300 (dark), arrow_back

Title:
  font-size: 20px (text-xl)
  font-weight: 700 (font-bold)
  letter-spacing: tight (tracking-tight)

Action button (right): stessa struttura del back button
```

**Applicare a:** tutti gli screen con AppBar custom

### 3.17 Search Bar
**Sorgente:** `lista_esercizi/code.html` righe 60-65

```
Container: relative, margin-bottom 16px (mb-4)

Input:
  width: 100%
  padding-left: 40px (pl-10)
  padding-right: 16px (pr-4)
  padding-vertical: 12px (py-3)
  bg: slate-100 (light) / slate-800 (dark)
  border: none
  border-radius: 12px (rounded-xl)
  font-size: 14px (text-sm)
  focus: ring-2 ring-primary/50
  placeholder: text-slate-500

Search icon:
  position: absolute, left 12px (pl-3), vertically centered
  color: slate-400 → focus-within: primary
  transition: colors
```

**Applicare a:** future search functionality

### 3.18 Filter Tabs (pill-style)
**Sorgente:** `lista_esercizi/code.html` righe 67-80

```
Layout: flex row, gap 8px (gap-2), overflow-x-auto, no-scrollbar

Active tab:
  height: 36px (h-9)
  padding: 0 20px (px-5)
  border-radius: full (rounded-full)
  bg: primary
  color: white
  shadow: shadow-lg shadow-primary/20
  text: 12px semibold uppercase tracking-wider

Inactive tab:
  height: 36px (h-9)
  padding: 0 20px (px-5)
  border-radius: full (rounded-full)
  bg: slate-100 (light) / slate-800 (dark)
  color: slate-600 (light) / slate-300 (dark)
  border: 1px solid slate-200 (light) / slate-700 (dark)
  text: 12px semibold uppercase tracking-wider
```

**Applicare a:** `conditioning_screen.dart`, `biomarkers_screen.dart`, `fasting_screen.dart` (tab bars)

### 3.19 Bottom Navigation Bar
**Sorgente:** `lista_esercizi/code.html` righe 209-231

```
Container:
  position: absolute/fixed bottom
  bg: white/90 (light) / slate-900/90 (dark)
  backdrop-filter: blur(16px) (-xl)
  border-top: 1px solid slate-100 (light) / slate-800 (dark)
  padding: 12px horizontal, 12px vertical (px-6 py-3)
  z-index: 30

Nav item (inactive):
  display: flex column, items-center, gap 4px (gap-1)
  icon color: slate-400
  label: 10px (text-[10px]), font-bold, uppercase, tracking-wider

Nav item (active):
  icon color: primary
  icon style: filled (FILL 1)
  label: same as inactive but primary color

FAB (central button, opzionale):
  size: 56px (w-14 h-14)
  offset: -24px top (relative -top-6)
  shape: circle (rounded-full)
  bg: primary
  color: white
  shadow: shadow-lg shadow-primary/40
  ring: 4px solid white (light) / slate-900 (dark)
  icon: 30px (text-3xl)
```

**Applicare a:** bottom navigation bar globale dell'app

### 3.20 Settings List Items
**Sorgente:** `generated_screen_4/code.html` righe 85-210

```
Section header:
  padding: 0 24px (px-6)
  margin-bottom: 8px (mb-2)
  font-size: 12px (text-xs)
  font-weight: 700 (font-bold)
  color: slate-400
  text-transform: uppercase
  letter-spacing: wider (tracking-wider)

List item:
  padding: 16px 24px (px-6 py-4)
  display: flex row, items-center, justify-between
  cursor: pointer
  active: bg slate-200 (active feedback)

  Icon container:
    padding: 8px (p-2)
    border-radius: 8px (rounded-lg)
    bg: [color]-50 (pastello per categoria)
    color: [color]-600

    Colori per categoria:
      User profile: blue-50 / blue-600
      Body progress: orange-50 / orange-600
      Workout history: purple-50 / purple-600
      Achievements: pink-50 / pink-600
      Linked devices: cyan-50 / cyan-600
      Notifications: slate-100 / slate-600
      Privacy: slate-100 / slate-600
      Log out: red-50 / red-600

  Text: font-medium
  Chevron: slate-400, 20px (h-5 w-5), stroke-width 2

Dividers: 1px solid slate-100 (divide-y)
Section border: top + bottom (border-y border-slate-100)
```

**Applicare a:** `settings_screen.dart`

### 3.21 Profile Stats Bar
**Sorgente:** `generated_screen_4/code.html` righe 69-82

```
Layout: grid 3-col, gap 16px (gap-4)

Stat box:
  text-align: center
  padding: 12px (p-3)
  bg: slate-50
  border-radius: 12px (rounded-xl)

  Label: 12px (text-xs), slate-500, uppercase, font-medium
  Value: 18px (text-lg), font-bold
  Unit suffix: 12px (text-xs) — per "kg" ecc.
```

**Applicare a:** `home_screen.dart` (stats), `settings_screen.dart` (profile header)

### 3.22 Meal Card
**Sorgente:** `generated_screen_3/code.html` righe 98-118

```
Container:
  bg: white
  padding: 12px (p-3)
  border-radius: 16px (rounded-2xl)
  border: 1px solid slate-100
  shadow: card-shadow (4px blur, 5% black)

Header:
  display: flex row, justify-between, items-center, margin-bottom 12px
  Color accent bar: 2px width × 24px height (w-2 h-6), rounded-full
    Breakfast: yellow-400
    Lunch: orange-400
    Dinner: blue-500
    Snacks: purple-400
  Title: font-bold, slate-800
  Kcal: 12px semibold, slate-400

Content:
  display: flex row, items-center, gap 12px (space-x-3)
  Thumbnail: 64px (w-16 h-16), rounded-xl, object-cover
  Name: 14px semibold (text-sm font-semibold), slate-700
  Meta: 12px (text-xs), slate-400
```

**Applicare a:** `nutrition_tab.dart` (meal diary)

---

## 4. Gap Analysis — Screen per Screen

**Legenda:** OK = allineato, PARTIAL = struttura ok ma mancano dettagli, MISSING = pattern non applicato

| # | File | Compliance | Gap principale |
|---|------|-----------|----------------|
| 1 | `chat_message.dart` | 40% | Shadow mancante, border mancante, label sopra bubble mancante |
| 2 | `coach_screen.dart` | 50% | Quick reply pills non stitch, input bar non stitch, avatar bot senza shadow |
| 3 | `workout_session_screen.dart` | 85% | Timer box OK, progress bar OK. Mancano: control buttons come cerchi, set display con pill, footer actions stitch |
| 4 | `home_screen.dart` | 80% | Rings OK. Mancano: stats grid pattern 3.12, card shadows consistenti |
| 5 | `training_screen.dart` | 60% | Card structure OK. Mancano: exercise badges stitch (3.11), button shadow |
| 6 | `conditioning_screen.dart` | 50% | Tab standard Material. Manca: pill filter tabs (3.18) |
| 7 | `cold_tab.dart` | 75% | Alert cards OK. Mancano: timer display stitch (3.5), control buttons (3.7) |
| 8 | `heat_tab.dart` | 60% | Manca: timer display stitch (3.5) |
| 9 | `meditation_tab.dart` | 70% | Breathing circle OK. Mancano: control buttons stitch (3.7) |
| 10 | `sleep_tab.dart` | 55% | Mancano: input form styling, chart card styling |
| 11 | `fasting_screen.dart` | 50% | Tab standard Material. Mancano: pill tabs (3.18), start button sticky footer (3.15) |
| 12 | `nutrition_tab.dart` | 55% | Manca: meal card pattern (3.22) con color accent bar |
| 13 | `levels_tab.dart` | 60% | Mancano: numbered steps (3.14) per criteria checklist |
| 14 | `biomarkers_screen.dart` | 50% | Tab standard Material. Manca: pill tabs (3.18) |
| 15 | `biomarker_dashboard_tab.dart` | 70% | Hero card OK. Mancano: stats grid (3.12), sparkline card shadows |
| 16 | `phenoage_tab.dart` | 65% | Manca: section headers con icon (3.13) |
| 17 | `weight_tab.dart` | 60% | Manca: input styling stitch |
| 18 | `blood_panel_form.dart` | 55% | Mancano: section headers (3.13), form input styling |
| 19 | `conditioning_history.dart` | 65% | Mancano: chart card shadows, stats grid (3.12) |
| 20 | `progressions_screen.dart` | 80% | Level cards OK. Mancano: shadow e border consistency |
| 21 | `settings_screen.dart` | 45% | Manca: icon in colored bg (3.20), section headers uppercase, chevron styling |
| 22 | `onboarding_screen.dart` | 55% | Mancano: progress bar stitch (3.6), numbered steps (3.14), button shadow |
| 23 | `model_download_card.dart` | 75% | Card OK. Manca: progress bar stitch (3.6) |
| 24 | `ai_insight_card.dart` | 75% | Card OK. Mancano: shadow, border consistency |
| 25 | `activity_rings.dart` | 85% | Colors OK (usa primary). Minor: label styling |

---

## 5. Strategia di Implementazione

### Fase A: Widget Comuni Riusabili (3 nuovi widget)

Prima di toccare gli screen, creare widget shared per i pattern più ripetuti:

#### A1. `PhoenixTimerDisplay` (pattern 3.5)
```dart
// lib/shared/widgets/phoenix_timer_display.dart
// Props: minutes, seconds, label (opzionale)
// Usato da: workout_session, cold_tab, heat_tab, meditation_tab
```

#### A2. `PhoenixControlButtons` (pattern 3.7)
```dart
// lib/shared/widgets/phoenix_control_buttons.dart
// Props: onPrevious, onPrimaryAction, onNext, isPaused, primaryIcon
// Usato da: workout_session, meditation_tab
```

#### A3. `PhoenixPillTabs` (pattern 3.18)
```dart
// lib/shared/widgets/phoenix_pill_tabs.dart
// Props: tabs (list<String>), selectedIndex, onChanged
// Usato da: conditioning_screen, biomarkers_screen, fasting_screen
```

### Fase B: Screen-by-Screen (priorità per impatto visivo)

**Batch 1 — Alta visibilità (5 file)**
1. `chat_message.dart` — bubble shadow + border + label + asymmetric radius
2. `coach_screen.dart` — quick reply pills, input bar, avatar shadow
3. `settings_screen.dart` — icon bg colorate, section headers, chevron, list dividers
4. `workout_session_screen.dart` — usare PhoenixTimerDisplay, PhoenixControlButtons, set pill, footer actions
5. `home_screen.dart` — stats grid, card shadow consistency

**Batch 2 — Tab screens (4 file)**
6. `conditioning_screen.dart` — usare PhoenixPillTabs
7. `biomarkers_screen.dart` — usare PhoenixPillTabs
8. `fasting_screen.dart` — usare PhoenixPillTabs + sticky footer CTA
9. `onboarding_screen.dart` — progress bar stitch, numbered steps, button shadow

**Batch 3 — Conditioning tabs (4 file)**
10. `cold_tab.dart` — usare PhoenixTimerDisplay, PhoenixControlButtons
11. `heat_tab.dart` — usare PhoenixTimerDisplay
12. `meditation_tab.dart` — usare PhoenixControlButtons
13. `sleep_tab.dart` — input styling, chart card shadow

**Batch 4 — Content screens (6 file)**
14. `training_screen.dart` — exercise badges, button shadow
15. `nutrition_tab.dart` — meal card pattern con color accent bar
16. `levels_tab.dart` — numbered steps per criteria
17. `biomarker_dashboard_tab.dart` — stats grid, sparkline shadows
18. `blood_panel_form.dart` — section headers con icon, form styling
19. `conditioning_history.dart` — chart card shadows, stats grid

**Batch 5 — Polish (4 file)**
20. `phenoage_tab.dart` — section headers
21. `weight_tab.dart` — input styling
22. `progressions_screen.dart` — shadow + border consistency
23. `model_download_card.dart` + `ai_insight_card.dart` — progress bar stitch, shadow

---

## 6. File da creare

| File | Tipo | Pattern |
|------|------|---------|
| `lib/shared/widgets/phoenix_timer_display.dart` | Widget | 3.5 |
| `lib/shared/widgets/phoenix_control_buttons.dart` | Widget | 3.7 |
| `lib/shared/widgets/phoenix_pill_tabs.dart` | Widget | 3.18 |

---

## 7. File da modificare

Totale: ~25 file esistenti + 3 nuovi

---

## 8. Verifica

- [ ] `flutter build apk --debug` compila senza errori
- [ ] 3 widget shared creati e funzionanti
- [ ] Chat bubbles: shadow, border, label, asymmetric radius
- [ ] Timer display: digit box, colon primary, unit label
- [ ] Control buttons: cerchi, primary scale-125, shadow
- [ ] Pill tabs: active primary+shadow, inactive bordered
- [ ] Settings: icon bg colorate, section headers uppercase
- [ ] Progress bars: h-3, rounded-full, primary/20 track
- [ ] Footer CTA: backdrop-blur, shadow-primary/30, active:scale(0.98)
- [ ] Stats grid: 3-col, border-y, uppercase label
- [ ] Card shadows: CardTokens.shadowLight applicato uniformemente
- [ ] Nessuna regressione funzionale
- [ ] Dark theme verificato su tutti gli screen modificati
