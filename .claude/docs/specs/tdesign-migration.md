# Feature: Migrazione a TDesign Flutter

**Status:** COMPLETATA
**Created:** 2026-03-13
**Approved:** 2026-03-13

---

## 1. Overview

**What?** Adottare TDesign Flutter (`tdesign_flutter ^0.2.7`) come fondazione visiva dell'app, sostituendo i componenti Material grezzi con componenti TDesign pre-costruiti e ricostruendo i widget custom Phoenix usando i pattern Dart estratti dal codice sorgente TDesign.

**Why?** L'UI attuale sembra un prototipo Material generico. Il tentativo precedente (Stitch) di replicare design da screenshot e HTML e' fallito perche' richiedeva interpretazione visiva. TDesign e' diverso: sono file Dart leggibili, con pattern concreti (shadow, animazioni, stato, feedback tattile) che posso riusare direttamente — compasso, non disegno a mano libera.

**Success metric:** Ogni screen usa componenti TDesign per la parte base (bottoni, input, dialog, tabs, card, toast, loading) e widget custom ricostruiti usando i pattern Dart TDesign (stesse shadow, animazioni, state management) per la parte specifica fitness.

---

## 2. Strategia

### Fase 0: Studio (prerequisito)
Leggere i sorgenti TDesign locali (`tdesign-flutter/`) per estrarre:
- Pattern di stato (`_TDButtonStatus` → defaultState/active/disable, 100ms delay)
- Sistema shadow a 3 livelli (base/middle/top)
- Sistema colori e come TDesign mappa semantic → theme
- Come TDesign costruisce animazioni (`AnimationController` + `Tween` + `AnimatedBuilder`)
- Come TDesign gestisce dark mode nel theme
- Pattern di composizione widget (public API → internal state → rendering)

Documentare i pattern estratti in un file di riferimento interno prima di toccare qualsiasi codice.

### Fase 1: Integrazione Theme
Sostituire `design_tokens.dart` con un theme system che integra TDesign + Phoenix.

**Approccio:** NON eliminare `design_tokens.dart` subito. Creare un bridge:
- `TDTheme` come base (shadow, radius, spacing, font)
- Phoenix pillar colors (training/fasting/conditioning/biomarkers) come estensione
- Dark mode tramite `TDTheme` dark variant + Phoenix dark overrides

**File coinvolti:**
| File | Azione |
|------|--------|
| `pubspec.yaml` | Aggiungere `tdesign_flutter: ^0.2.7` |
| `lib/app/phoenix_theme.dart` | **Nuovo** — bridge TDesign ↔ Phoenix colors |
| `lib/app/design_tokens.dart` | Gradualmente deprecare, redirect a phoenix_theme |
| `lib/main.dart` | Wrappare con TDTheme provider |

### Fase 2: Componenti Base — Sostituzione Diretta
Sostituire widget Material con equivalenti TDesign dove esiste un 1:1.

| Widget attuale | TDesign equivalente | Dove usato |
|---|---|---|
| `ElevatedButton` / `TextButton` | `TDButton` | Ovunque (~25 screen) |
| `TextField` / `InputDecoration` | `TDInput` / `TDTextarea` | Coach chat, blood panel, settings |
| `TabBar` Material | `TDTabs` / `TDTabBar` | Conditioning, Biomarkers (attualmente PhoenixPillTabs) |
| `AlertDialog` | `TDDialog` | Conferme, alert biomarker |
| `SnackBar` | `TDToast` / `TDMessage` | Feedback azioni |
| `CircularProgressIndicator` | `TDLoading` | Loading states |
| `LinearProgressIndicator` | `TDProgress` | Download model, workout progress |
| `Switch` | `TDSwitch` | Settings |
| `Checkbox` | `TDCheckbox` | Fasting criteria, onboarding |
| `Slider` | `TDSlider` | RPE input |
| `BottomNavigationBar` | `TDBottomTabBar` | Home navigation |
| `Scaffold AppBar` | `TDNavBar` | Tutti gli screen |
| `Card` Material | `TDCell` / `TDCellGroup` | Liste, settings items |
| `Badge` generico | `TDBadge` / `TDTag` | Muscle badges, level tags |
| `Skeleton loading` | `TDSkeleton` | Loading states futuri |
| `BottomSheet` | `TDPopup` | Exercise detail, pickers |
| `Rate/stars` | `TDRate` | Sleep quality |
| `SearchBar` | `TDSearchBar` | Exercise search (futuro) |
| `Stepper` / `Steps` | `TDSteps` | Onboarding, numbered steps |
| `NoticeBar` | `TDNoticeBar` | Alert biomarker, cold 6h warning |
| `ActionSheet` | `TDActionSheet` | Menu azioni |
| `Divider` | `TDDivider` | Liste, settings |
| `Empty state` | `TDEmpty` | Nessun dato |
| `Swipe to delete` | `TDSwipeCell` | Meal log delete |
| `Calendar` | `TDCalendar` | Futuro: selezione date |

### Fase 3: Widget Custom — Ricostruzione con Pattern TDesign
Questi componenti non hanno equivalente TDesign. Li ricostruisco usando i pattern Dart estratti in Fase 0.

| Widget | Pattern TDesign da riusare | Note |
|---|---|---|
| `ActivityRings` | `TDProgress` circular: AnimationController, Tween, ClipRRect, colori da theme | 3 ring concentrici, CustomPainter |
| `PhoenixTimerDisplay` | `TDTimeCounter`: digit rendering, stato, font features | Mantiene digit box, migliora con TDesign shadow/border/animation |
| `PhoenixControlButtons` | `TDButton`: GestureDetector 3-state (default/active/disable), 100ms delay feedback, shadow levels | Mantiene layout circolare, aggiunge feedback tattile TDesign |
| `PhoenixPillTabs` | `TDTabs`: valutare se TDTabs e' gia' sufficiente, altrimenti ricostruire con stessi pattern | Probabilmente sostituibile direttamente |
| `ChatMessage` | `TDCell` per struttura, shadow system TDesign, `TDAvatar` per bot avatar | Bubble asimmetriche + avatar + label |
| `BreathingCircle` | `TDProgress` circular + animazione custom: stessa struttura AnimationController | Cerchio animato breathing |
| `ConditioningHistory` | `TDProgress` per barre, shadow system per card chart | Trend chart + stats |
| `ExerciseCard` | `TDCell` + `TDTag` + `TDImage` | Card orizzontale con thumbnail |
| `ExerciseDetailSheet` | `TDPopup` come container, `TDSteps` per numbered steps, `TDTag` per badges | Bottom sheet completo |
| `ModelDownloadCard` | `TDProgress` linear + `TDButton` per azioni | Progress con pause/resume |
| `AiInsightCard` | `TDCollapse` / `TDCollapsePanel` per expand/collapse | Card espandibile |
| `BloodPanelForm` | `TDForm` + `TDInput` + `TDCollapse` per sezioni | Form strutturato |
| `StatsGrid` | Pattern `TDCell` per struttura, `TDDivider` | Griglia 3-col con divider |
| `MealCard` | `TDSwipeCell` + `TDCell` + color accent bar | Swipe to delete + accent |

### Fase 4: Pulizia
- Rimuovere `design_tokens.dart` (tutto migrato a phoenix_theme)
- Rimuovere `shared/widgets/phoenix_pill_tabs.dart` (se sostituito da TDTabs)
- Rimuovere `shared/widgets/phoenix_timer_display.dart` (ricostruito)
- Rimuovere `shared/widgets/phoenix_control_buttons.dart` (ricostruito)
- Rimuovere `flutter_animate` se non piu' necessario (TDesign ha le sue animazioni)
- Verificare che `google_fonts` sia ancora necessario (TDesign ha td_font_family)

---

## 3. File da Modificare

### Fase 1: Theme (4 file)
| File | Azione |
|------|--------|
| `pubspec.yaml` | Aggiungere tdesign_flutter, rimuovere flutter_animate se possibile |
| `lib/app/phoenix_theme.dart` | **Nuovo** — TDTheme + Phoenix extensions |
| `lib/app/design_tokens.dart` | Deprecare, forward a phoenix_theme |
| `lib/main.dart` | TDTheme wrapping |

### Fase 2: Componenti Base (~25 file)
Tutti i file in `lib/features/` che usano widget Material base. Batch per area:

**Batch 2A — Navigation & Structure:**
| File | Cambiamento |
|------|-------------|
| `home_screen.dart` | BottomNavigationBar → TDBottomTabBar |
| Tutti gli screen con AppBar | AppBar → TDNavBar |

**Batch 2B — Buttons & Input:**
| File | Cambiamento |
|------|-------------|
| Tutti gli screen con ElevatedButton | → TDButton |
| `coach_screen.dart` | TextField → TDInput, focus ring |
| `blood_panel_form.dart` | TextField → TDInput, sections con TDCollapse |
| `settings_screen.dart` | Switch → TDSwitch, list items → TDCell |

**Batch 2C — Feedback & Display:**
| File | Cambiamento |
|------|-------------|
| Loading states | CircularProgress → TDLoading |
| Conferme | AlertDialog → TDDialog |
| Snackbar | → TDToast |
| `sleep_tab.dart` | Star rating → TDRate |

### Fase 3: Widget Custom (~15 file)
| File | Cambiamento |
|------|-------------|
| `widgets/activity_rings.dart` | Ricostruire CustomPainter con pattern TDProgress |
| `widgets/phoenix_timer_display.dart` | Ricostruire con pattern TDTimeCounter |
| `widgets/phoenix_control_buttons.dart` | Ricostruire con pattern TDButton state machine |
| `widgets/phoenix_pill_tabs.dart` | Valutare sostituzione con TDTabs o ricostruire |
| `widgets/chat_message.dart` | Ricostruire con TDAvatar + TDCell pattern + shadow system |
| `conditioning/meditation_tab.dart` | BreathingCircle con pattern TDProgress |
| `conditioning/conditioning_history.dart` | Stats + chart con TDesign shadow/card |
| `exercise/exercise_card.dart` | TDCell + TDTag + TDImage pattern |
| `exercise/exercise_detail_sheet.dart` | TDPopup + TDSteps + TDTag |
| `exercise/widgets/muscle_badge.dart` | → TDTag |
| `exercise/widgets/stats_grid.dart` | TDCell + TDDivider pattern |
| `exercise/widgets/numbered_steps.dart` | → TDSteps |
| `coach/widgets/model_download_card.dart` | TDProgress + TDButton |
| `coach/widgets/ai_insight_card.dart` | TDCollapsePanel |
| `fasting/nutrition_tab.dart` | MealCard con TDSwipeCell |

### Fase 4: Pulizia (3-5 file)
| File | Azione |
|------|--------|
| `design_tokens.dart` | Eliminare |
| `phoenix_pill_tabs.dart` | Eliminare se sostituito |
| `phoenix_timer_display.dart` | Eliminare se ricostruito |
| `phoenix_control_buttons.dart` | Eliminare se ricostruito |
| `pubspec.yaml` | Rimuovere dipendenze non piu' necessarie |

---

## 4. Rischi e Mitigazioni

| Rischio | Impatto | Mitigazione |
|---------|---------|-------------|
| TDesign theme conflitto con Material theme | Alto | Fase 1 crea bridge esplicito, test prima di proseguire |
| TDesign componenti non customizzabili abbastanza | Medio | Fase 0 studia i sorgenti — se un componente e' troppo rigido, ricostruiamo con i pattern |
| Regressioni funzionali | Alto | Mai toccare logica, solo widget tree. Test dopo ogni batch |
| TDesign dark mode non maturo (aggiunto in v0.2.6) | Medio | Verificare ogni componente in dark, fallback a override manuale |
| Performance: TDesign aggiunge peso | Basso | E' tree-shakeable, importi solo quello che usi |
| TDesign aggiornamenti rompono API | Basso | Pinnare versione esatta in pubspec |

---

## 5. Ordine di Implementazione

```
Fase 0: Studio sorgenti TDesign (1 sessione)
  └→ Output: documento pattern estratti

Fase 1: Theme integration (1 sessione)
  └→ Output: app compila con TDesign theme, aspetto invariato
  └→ Checkpoint: VERIFICARE su device/emulatore

Fase 2A: Navigation (1 sessione)
  └→ BottomTabBar + NavBar
  └→ Checkpoint: navigazione funziona

Fase 2B: Buttons & Input (1-2 sessioni)
  └→ Tutti i bottoni + input
  └→ Checkpoint: interazioni funzionano

Fase 2C: Feedback & Display (1 sessione)
  └→ Dialog, toast, loading, rating
  └→ Checkpoint: feedback funziona

Fase 3: Widget Custom (2-3 sessioni)
  └→ Un widget alla volta, partendo dal piu' visibile
  └→ Checkpoint per ogni widget

Fase 4: Pulizia (1 sessione)
  └→ Rimuovere vecchio codice
  └→ Build finale pulito
```

---

## 6. Prerequisiti

1. **Repository TDesign clonato** nella root del progetto → per leggere sorgenti Dart
2. **Android SDK installato** → per buildare APK e verificare visivamente
3. **Device o emulatore** → per screenshot tour prima/dopo

Senza il punto 2 e 3 possiamo fare Fase 0 e Fase 1, ma non possiamo verificare il risultato visivo.

---

## 7. Cosa NON cambia

- Tutta la logica business (workout generator, fasting, cold progression, PhenoAge, etc.)
- Database e DAO
- LLM engine e model manager
- State management (Riverpod)
- Navigation routes
- Audio engine
- Notifications
- Background tasks

Solo il layer UI viene toccato. Se un widget ha `onPressed`, `onChanged`, o qualsiasi handler, resta identico.
