# Workout Session Redesign

## What
Redesign the workout session flow with 3 changes:
1. **Inline exercise detail** — Remove the "i" button, show full exercise info directly on preview and during tracking
2. **Brutalist tempo animation** — Replace circular breathing animation with horizontal bar (left→right fill)
3. **AI coach post-exercise feedback** — After each set, AI coach asks about performance/pain via chat; replaces mechanical RPE confirm

## Files to touch

| File | Change |
|------|--------|
| `workout_session_screen.dart` | All 3 changes: rebuild preview, tracking, rpeConfirm phases + new coach chat phase |
| `exercise_detail_sheet.dart` | Keep (still useful from rest phase "i" button and other screens) |
| `phoenix_control_buttons.dart` | May need minor adjustments |
| `llm_engine.dart` | Add workout-specific prompt template |
| `prompt_templates.dart` | Add post-set coach prompt |
| `template_chat.dart` | Add workout feedback intent + template response |
| `coach_prompts.dart` | Add post-set analysis prompts |
| `workout_generator.dart` | Add method to adjust exercise level based on AI feedback |

## Existing code to reuse

- `LlmEngine.generate()` / `generateStream()` — AI inference
- `TemplateChat` — fallback when LLM unavailable
- `ExerciseDetailSheet` layout — extract inline widgets from it
- `NumberedSteps.parseSteps()` — for execution steps
- `MuscleBadge` — for muscle display
- `StatsGrid` — for sets/tempo/equip display
- `CoachPrompts` — existing prompt templates
- `ProgressionDao.checkProgressionCriteria()` — still used at session end

## Design

### 1. Inline Exercise Detail

**Preview phase:**
- Remove "Pronto" button centered layout
- Show scrollable detail: hero icon → name → badges (category, type, level) → stats grid (sets, tempo, equip) → description → numbered execution steps → muscles
- "Pronto" button pinned at bottom
- Remove "i" from navbar in preview phase

**Tracking phase:**
- Keep: exercise name, set pill, tempo bar (new), reps counter
- Below tracking area: execution cues (already there) + muscle chips
- "i" button remains in navbar ONLY during tracking/resting phases (for quick reference while hands busy)

### 2. Brutalist Tempo Bar

Replace `_BreathingCirclePainter` with a horizontal bar system:
- Full-width bar, height ~12px, border 2px
- Three segments: ECCENTRICA | PAUSA | CONCENTRICA
- Active segment fills left→right with white (dark) or black (light)
- Phase label above bar: "ECCENTRICA ↓" / "PAUSA" / "CONCENTRICA ↑" in Bebas Neue
- Reps counter large above the bar (keep current large number)
- No circles, no glows, no color — pure B/W except phase labels use warning/white/success

### 3. AI Coach Post-Exercise Feedback

**Flow change: rpeConfirm → coachChat**

After each SET (not exercise), instead of the mechanical RPE +/- UI:
1. Show a chat-style interface
2. AI asks: "Come è andata questa serie? Quante rep sei riuscito a fare?" (or similar)
3. User responds via text input (voice input = future enhancement)
4. AI interprets: extracts reps completed, perceived difficulty, any pain mentions
5. AI responds with encouragement + any adjustments
6. If pain detected: AI flags it, may suggest alternative exercises for remaining sets
7. Data saved: reps, RPE (AI-estimated from conversation), pain notes

**When LLM unavailable (template mode):**
- Show structured form instead: reps completed (stepper), RPE (current +/- UI), pain toggle + text field
- Template coach responds with pre-written encouragement based on RPE

**At session end:**
- AI reviews all set data, generates summary
- If pain was reported: AI adjusts future workout plan (store in user_settings or progression_history)
- Progression check still runs (existing logic)

**Prompt structure for LLM:**
```
Sei il coach Phoenix. L'utente ha appena completato la serie {setNumber}/{totalSets} di {exerciseName}.
Target: {repsTarget} rep. Tempo: {tempoEcc}s ecc / {tempoCon}s con.
Serie precedenti questa sessione: {setHistory}

Chiedi come è andata. Sii breve e diretto (max 2 frasi). Se l'utente menziona dolore, chiedi dove e proponi un'alternativa.
Rispondi SEMPRE in italiano.
```

## Verification
- Visual: preview shows full exercise detail inline
- Visual: tempo bar animates horizontally during tracking
- Functional: AI coach asks questions after each set
- Functional: pain detection triggers alternative exercise suggestion
- Functional: template fallback works when LLM unavailable
- Compile: `flutter analyze` clean
