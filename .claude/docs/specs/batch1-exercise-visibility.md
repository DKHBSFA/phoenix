# Feature: Esercizi Visibili — Dettaglio, Spiegazioni, Immagini

**Status:** COMPLETED
**Created:** 2026-03-13
**Approved:** 2026-03-13
**Completed:** 2026-03-13

---

## 1. Overview

**What?** Creare una schermata dettaglio esercizio completa e rendere le spiegazioni/cues visibili ovunque servano — training screen, workout session, progressioni.

**Why?** L'app ha ~80 esercizi con execution cues nel DB ma li mostra solo in un punto nascosto (preview pre-serie). L'utente non vede mai cosa deve fare, come farlo, né ha un riferimento visivo. I design reference stitch (`dettaglio_esercizio/`, `lista_esercizi/`) mostrano un'esperienza ricca con video hero, badge muscoli, step numerati — l'app attuale è una lista piatta di nomi.

**For whom?** Utente che si allena — deve sapere COME eseguire ogni esercizio prima e durante il workout.

**Success metric:** Ogni esercizio è tappabile e mostra: nome, muscoli, livello, cues di esecuzione come step numerati, badge equipment/category. La training screen mostra card con thumbnail placeholder e badge muscoli.

---

## 2. Technical Approach

**Pattern:** Nuova screen `ExerciseDetailScreen` + refactor delle card esercizio esistenti.

**Key decisions:**

1. **No immagini reali per ora** — Non abbiamo asset fotografici per ~80 esercizi. Usiamo placeholder colorati con icona categoria (come fa la stitch con le thumbnail). Le immagini verranno aggiunte in futuro quando disponibili. Il campo `imagePaths` nel DB resta vuoto ma l'UI mostra un placeholder dignitoso.

2. **Execution cues → step numerati** — Il campo `executionCues` contiene testo piatto (una stringa). Lo splittiamo su `. ` (punto+spazio) per ottenere step separati e li rendiamo come numbered steps (pattern stitch 3.14).

3. **Schermata dettaglio come bottom sheet** — Invece di navigare a una nuova route (che interrompe il flusso workout), usiamo un `DraggableScrollableSheet` modale. Questo permette di consultare i dettagli senza perdere il contesto.

4. **Badge muscoli dal DB** — `musclesPrimary` e `musclesSecondary` sono stringhe comma-separated. Li parsiamo e mostriamo come badge colorati (pattern stitch 3.11).

5. **Stats grid** — Mostriamo: sets × reps, tempo (ecc/con), equipment. Pattern stitch 3.12.

**Dependencies:** Nessuna nuova dipendenza. Tutto già disponibile nel DB e design_tokens.

**Breaking changes:** None. Aggiungiamo UI, non modifichiamo logica esistente.

---

## 3. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `lib/features/exercise/exercise_detail_sheet.dart` | **Create** | Bottom sheet con dettaglio esercizio completo |
| `lib/features/exercise/widgets/exercise_card.dart` | **Create** | Card esercizio riusabile (thumbnail + badge + meta) pattern stitch 3.4 |
| `lib/features/exercise/widgets/muscle_badge.dart` | **Create** | Badge muscolo primary/secondary, pattern stitch 3.11 |
| `lib/features/exercise/widgets/stats_grid.dart` | **Create** | Grid 3-col stats (sets, tempo, equipment), pattern stitch 3.12 |
| `lib/features/exercise/widgets/numbered_steps.dart` | **Create** | Step numerati da executionCues, pattern stitch 3.14 |
| `lib/features/exercise/widgets/exercise_hero.dart` | **Create** | Hero section con placeholder colorato + icona + play button placeholder |
| `lib/features/training/training_screen.dart` | **Modify** | Sostituire lista piatta con `ExerciseCard` tappabili |
| `lib/features/workout/workout_session_screen.dart` | **Modify** | Aggiungere bottone info (ⓘ) che apre `ExerciseDetailSheet` |
| `lib/features/progressions/progressions_screen.dart` | **Modify** | Rendere esercizi tappabili → apre dettaglio |

---

## 4. Specifiche UI (da stitch reference)

### 4.1 ExerciseDetailSheet

Layout verticale scrollabile in bottom sheet (90% altezza):

```
┌─────────────────────────────────┐
│ ═══ drag handle ═══             │
│                                 │
│ ┌─────────────────────────────┐ │
│ │     HERO PLACEHOLDER        │ │
│ │   (aspect 16:9, rounded-xl) │ │
│ │   icona categoria centrata  │ │
│ │   bg: primary/20            │ │
│ └─────────────────────────────┘ │
│                                 │
│ Dumbbell Bench Press            │  ← text-3xl font-bold
│ [CHEST] [STRENGTH] [INTERMEDIATE]│  ← badge pattern 3.11
│                                 │
│ ─── Stats Grid (3 col) ──────  │  ← pattern 3.12
│  3×8-12  │  3s/2s  │  Gym      │
│  Sets    │  Tempo  │  Equip    │
│ ──────────────────────────────  │
│                                 │
│ 📋 Descrizione                  │  ← section header 3.13
│ [executionCues come testo]      │
│                                 │
│ 📝 Come eseguire                │  ← section header 3.13
│ ┌─────────────────────────────┐ │
│ │ (1) Step uno dal cue split  │ │  ← numbered step 3.14
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ (2) Step due dal cue split  │ │
│ └─────────────────────────────┘ │
│                                 │
│ 💪 Muscoli                      │
│ Primary: [badges]               │
│ Secondary: [badges]             │
│                                 │
│ ┌─────────────────────────────┐ │
│ │     Inizia esercizio  ▶     │ │  ← solo se aperto da fuori workout
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

### 4.2 ExerciseCard (per liste)

Pattern stitch 3.4 — card orizzontale:

```
┌──────────┬──────────────────────┐
│          │ Exercise Name    ♡   │  h=112px
│ THUMB    │ [CHEST] [TRICEPS]    │  thumbnail w=112px
│ (icon)   │ ◉ Level 2  ⏱ 3×8-12│  rounded-2xl
└──────────┴──────────────────────┘
```

- Thumbnail: bg colorato per categoria + icona (no foto per ora)
  - push: `PhoenixColors.primary` (arancione)
  - pull: `Color(0xFF3B82F6)` (blue)
  - squat: `Color(0xFF10B981)` (green)
  - hinge: `Color(0xFF8B5CF6)` (purple)
  - core: `Color(0xFFF59E0B)` (amber)
- Badge muscoli: primary = bg primary/10 + text primary, secondary = bg slate-200 + text slate-600

### 4.3 Parsing executionCues → steps

```dart
List<String> _parseSteps(String cues) {
  if (cues.isEmpty) return [];
  // Split on ". " but keep meaningful sentences
  return cues
      .split(RegExp(r'\.\s+'))
      .where((s) => s.trim().length > 3)
      .map((s) => s.trim().endsWith('.') ? s.trim() : '${s.trim()}.')
      .toList();
}
```

### 4.4 Colori categoria per placeholder hero

| Category | Bg Color | Icon |
|----------|----------|------|
| push | primary/20 | `fitness_center` |
| pull | blue-500/20 | `rowing` |
| squat | green-500/20 | `directions_walk` |
| hinge | purple-500/20 | `accessibility_new` |
| core | amber-500/20 | `self_improvement` |

---

## 5. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Step parsing da cues | `"Scapole addotte. Gomiti 45°. Piedi a terra."` | `["Scapole addotte.", "Gomiti 45°.", "Piedi a terra."]` | High |
| UT-02 | Step parsing stringa vuota | `""` | `[]` | High |
| UT-03 | Muscle badge parsing | `"Pettorali, Deltoidi anteriori"` | `["Pettorali", "Deltoidi anteriori"]` | High |
| UT-04 | Category color mapping | `"push"` | `PhoenixColors.primary` | Medium |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Tap exercise in training → sheet opens | TrainingScreen → ExerciseDetailSheet | Sheet mostra nome, cues, badge | High |
| IT-02 | Tap info in workout session → sheet opens | WorkoutSession → ExerciseDetailSheet | Sheet mostra dettaglio senza interrompere workout | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Esercizio senza cues | `executionCues == ""` | Sezione "Come eseguire" nascosta |
| EC-02 | Esercizio senza muscles | `musclesPrimary == ""` | Sezione muscoli nascosta |
| EC-03 | Cue con un solo punto | `"Corpo dritto."` | Un solo step mostrato |

---

## 6. Implementation Notes

### Ordine di implementazione

1. Creare i widget atomici: `muscle_badge.dart`, `stats_grid.dart`, `numbered_steps.dart`
2. Creare `exercise_hero.dart` (placeholder)
3. Creare `exercise_card.dart` (composizione dei widget)
4. Creare `exercise_detail_sheet.dart` (composizione finale)
5. Modificare `training_screen.dart` — sostituire lista
6. Modificare `workout_session_screen.dart` — aggiungere bottone info
7. Modificare `progressions_screen.dart` — tap → dettaglio

### Directory structure

```
lib/features/exercise/
├── exercise_detail_sheet.dart
└── widgets/
    ├── exercise_card.dart
    ├── exercise_hero.dart
    ├── muscle_badge.dart
    ├── numbered_steps.dart
    └── stats_grid.dart
```

---

## 7. Completion Record

**Status:** Completato
**Date:** 2026-03-13
