# Architectural Decisions

**Why things are the way they are.**

When I make a choice that affects future work, I record it here. This prevents me from proposing contradictory approaches later.

---

## Format

```markdown
### [Short title]
**Date:** YYYY-MM-DD
**Decision:** What was decided
**Why:** Why this over alternatives
**Affects:** What this impacts going forward
```

---

## Decisions

### TDesign Flutter as UI foundation
**Date:** 2026-03-13
**Decision:** Adopted TDesign Flutter (local clone, ^0.2.7) as the visual component layer. Material widgets replaced where TDesign has a 1:1 equivalent. Custom Phoenix widgets kept where TDesign has no equivalent or migration would regress UX.
**Why:** TDesign provides consistent, battle-tested components (buttons, loading, toast, progress, swipe cells) with built-in dark mode, haptic feedback, and animation patterns. Previous attempt (Stitch) failed because it required interpreting screenshots. TDesign is Dart source code that can be read and reused directly.
**Affects:**
- All new UI code should prefer TDesign components over Material equivalents
- `phoenix_theme.dart` is the TDesign ↔ Phoenix bridge (colors, i18n)
- `design_tokens.dart` still provides PhoenixColors/Spacing/Radii — gradual migration later
- TextField stays Material (TDInput layout incompatible with current forms)
- PhoenixPillTabs stays custom (TDTabBar requires TabController, loses pill styling)
- Custom painters (ActivityRings, BreathingCircle) stay as-is (no TDesign equivalent)

---

*When I'm about to make an architectural choice, I check here first to stay consistent.*
