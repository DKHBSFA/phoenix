# Workout Session UX Upgrade + Audit Bug Fixes

**Spec unificata:** Riscrittura fase tracking workout + correzione bug emersi dall'audit sistematico.

---

## Parte A — Audit Bug Fixes

### A1. CRITICO: Conditioning routing in OneBigThing
**File:** `lib/features/workout/home_screen.dart:359-360`
**Bug:** `IconType.conditioning` naviga a `onNavigateToTab(2)` (Fasting) invece di usare `Navigator.pushNamed(context, PhoenixRouter.conditioning)`.
**Fix:** Nel metodo `_navigateForType`, il case `conditioning` deve fare `Navigator.pushNamed(context, PhoenixRouter.conditioning)` come già fa la QuickActionsGrid. Serve accesso a `BuildContext` (aggiungere parametro o usare `navigatorKey`).

### A2. Theme default `dark` → `system`
**File:** `lib/core/models/app_settings.dart:15,52`
**Bug:** Default e fallback JSON entrambi `'dark'`. Nuovo utente parte in dark mode forzato.
**Fix:** Cambiare entrambi i default a `'system'`.

### A3. Eating window hardcoded a livello 1
**File:** `lib/features/fasting/nutrition_tab.dart:154-156`
**Bug:** `startHour = 10`, `windowHours = eatingWindowHours(1)`. Ignora il livello di digiuno reale.
**Fix:** Leggere il livello di digiuno corrente da `fastingDaoProvider` e passarlo a `eatingWindowHours()`. La start hour dovrebbe adattarsi al livello (L1: 10:00-18:00, L2: 12:00-18:00, L3: 14:00-18:00).

### A4. Reports coach non salvati in DB
**File:** `lib/core/models/report_generator.dart`
**Bug:** I report generati non vengono persistiti nella tabella `llm_reports`.
**Fix:** Dopo la generazione, salvare il report via `LlmReportDao`. Aggiungere DAO se non esiste.

### A5. Conditioning daily target arbitrario
**File:** `lib/core/models/activity_rings_data.dart:27`
**Bug:** `_conditioningDailyTarget = 3` — troppo alto e non configurabile.
**Fix:** Abbassare a `1` (1 sessione/giorno è realistico).

---

## Parte B — Workout Session UX Upgrade

### B1. Breathing Circle (Tempo Visual Guide)

Cerchio animato centrale nella fase tracking, sincronizzato col tempo dell'esercizio:

- **Fase eccentrica** (es. 3s): cerchio si espande lentamente, label "ECCENTRICA ↓"
- **Pausa** (es. 1s): cerchio fermo, label "PAUSA"
- **Fase concentrica** (es. 2s): cerchio si contrae, label "CONCENTRICA ↑"
- Colori: `PhoenixColors.warning` (amber) per eccentrica, `Color(0xFF06B6D4)` (cyan) per pausa, `PhoenixColors.success` (verde) per concentrica
- Dopo l'ultima rep (countdown a 0), flash verde + haptic

**Implementazione:**
- `AnimationController` con durata = 1 ciclo completo (ecc + pausa + conc)
- `AnimatedBuilder` con `CustomPainter` che disegna cerchio con raggio variabile
- Il progress del controller (0.0→1.0) mappa sulle 3 fasi in proporzione

### B2. Auto-counting Reps (Countdown)

Il conteggio reps avanza automaticamente sincronizzato col breathing circle:

- Ogni ciclo completo (ecc + pausa + conc) = 1 rep completata
- Counter inizia dal target reps e **scende** a 0 (countdown)
- L'utente può premere "Serie completata" in qualsiasi momento per fermarsi prima
- Quando reps arrivano a 0 → automaticamente vai alla conferma RPE
- Reps effettive = (target - reps rimanenti al momento dello stop)

**Stato:**
- `_repsRemaining` (int) — inizializzato a `repsMax`
- Decrementato a ogni ciclo completo del breathing circle
- Se _repsRemaining == 0 → auto-complete set

### B3. Audio Metronomo Collegato

Collegare `AudioEngine.startMetronome()` alla fase tracking:

- **Start:** Quando _phase diventa tracking, chiamare `audioEngine.startMetronome(eccentricSeconds: tempoEcc, concentricSeconds: tempoCon)`
- **Stop:** Quando la fase tracking finisce (completeSet o endSession)
- Il metronomo emette già tick a ogni transizione di fase (implementato in AudioEngine)

### B4. RPE Explanation Dialog (Primo Utilizzo)

Prima del primo set in assoluto, mostrare dialog esplicativo:

- **Trigger:** Flag `rpeExplained` in AppSettings (nuovo campo, default `false`)
- **Contenuto dialog:**
  - Titolo: "RPE — Rate of Perceived Exertion"
  - "Misura quanto ti senti affaticato dopo ogni serie (1-10)"
  - Scala visiva: 1-3 Facile | 4-6 Moderato | 7-8 Difficile | 9-10 Massimale
  - Tasto "Ho capito" → salva `rpeExplained = true` in settings
- **Quando:** Dopo il countdown del primo set, prima di mostrare il tracking

### B5. RPE Stimata dal Sistema (Post-Set)

Dopo "Serie completata", il sistema suggerisce RPE:

- **Logica:**
  - Reps completate < target min → RPE 9 (near failure)
  - Reps completate == target min → RPE 7-8 (hard)
  - Reps completate tra min e max → RPE 6-7 (solid)
  - Reps completate >= target max → RPE 5-6 (could do more)
  - Se interrotto manualmente prima del countdown → RPE 8-9

- **UI (nuova sotto-fase `rpeConfirm`):**
  - Card con RPE suggerita grande (numero + label)
  - Pulsanti +/- per aggiustare (no slider)
  - Tasto "Conferma" → salva e vai a riposo

### B6. Execution Cues durante il Tracking

Mostrare i cue di esecuzione dell'esercizio anche durante la fase tracking (attualmente solo in preview):

- Container sotto il breathing circle con `exercise.executionCues`
- Stesso stile della preview ma più compatto

---

## Flusso aggiornato della sessione

```
1. PREVIEW — Nome + set×reps + muscoli + cue esecuzione [invariato]
2. RPE EXPLANATION — Dialog (solo primo utilizzo in assoluto) [NUOVO]
3. COUNTDOWN — 3-2-1 [invariato]
4. TRACKING — [RISCRITTO]:
   ┌─────────────────────────────────┐
   │  Nome esercizio                 │
   │  Serie 2/4                      │
   │                                 │
   │     ┌───────────┐               │
   │     │  CERCHIO   │ ← pulsante   │
   │     │  ANIMATO   │   sync tempo │
   │     └───────────┘               │
   │   ECCENTRICA ↓ (3s)             │
   │                                 │
   │       ⑧ reps rimanenti          │
   │                                 │
   │  "Spingi il petto..."  ← cues   │
   │                                 │
   │  Set precedenti: 10@RPE7...     │
   │                                 │
   │  [    Serie completata    ]      │
   └─────────────────────────────────┘
5. RPE CONFIRM — [NUOVO sotto-fase]:
   ┌─────────────────────────────────┐
   │  RPE suggerita                  │
   │       ⑦                         │
   │  "Molto difficile"             │
   │     [-]    [+]                  │
   │  [    Conferma    ]             │
   └─────────────────────────────────┘
6. REST — Timer riposo [invariato]
```

---

## Enum _Phase aggiornato

```dart
enum _Phase { preview, countdown, tracking, rpeConfirm, resting, complete }
```

---

## File da modificare

| File | Azione |
|------|--------|
| `lib/features/workout/workout_session_screen.dart` | Riscrittura tracking: breathing circle, auto-count, RPE confirm, audio, cues |
| `lib/features/workout/home_screen.dart` | Fix conditioning routing in OneBigThing |
| `lib/core/models/app_settings.dart` | Aggiungere `rpeExplained`, fix default theme→system |
| `lib/core/audio/audio_engine.dart` | Aggiungere callback `onPhaseChange` + `onCycleComplete` |
| `lib/features/fasting/nutrition_tab.dart` | Fix eating window → livello digiuno reale |
| `lib/core/models/report_generator.dart` | Salvare report in DB dopo generazione |
| `lib/core/models/activity_rings_data.dart` | Target conditioning 3→1 |

---

## Verifica

- [ ] Cerchio pulsante sincronizzato col tempo eccentrico/concentrico
- [ ] Audio tick a ogni transizione fase
- [ ] Reps countdown automatico
- [ ] RPE explanation al primo utilizzo
- [ ] RPE suggerita dal sistema post-set con +/-
- [ ] Cue esecuzione visibili durante tracking
- [ ] Conditioning routing corretto in OneBigThing
- [ ] Theme default 'system'
- [ ] Eating window dinamica per livello
- [ ] Reports salvati in DB
- [ ] `flutter analyze` 0 errors
