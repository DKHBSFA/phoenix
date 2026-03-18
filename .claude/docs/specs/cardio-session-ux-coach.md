# Cardio Session: UX + Coach Voice Fix

## Cosa sto costruendo

La `CardioSessionScreen` è troppo vuota — l'utente vede solo un timer e non sa cosa fare. Il coach vocale (TTS) non è integrato. Serve:

1. **Contenuto informativo per fase** — istruzioni, target HR, suggerimenti esercizio
2. **Coach voice durante cardio** — cue vocali ai cambi fase + motivazione

## File che tocco

| File | Cosa cambio |
|------|-------------|
| `features/cardio/cardio_session_screen.dart` | Aggiungere info panel per fase, integrare CoachVoice |
| `core/tts/coach_voice.dart` | Aggiungere trigger e frasi cardio-specifiche |

## Cosa riuso

- `CoachVoice` + `coachVoiceProvider` — già funzionanti nel workout
- `CardioProtocols` — già hanno `exerciseSuggestion` nei round
- `HrZones` — già ha target per zona

## Dettaglio modifiche

### 1. Coach Voice: nuovi trigger cardio

Aggiungere a `CoachTrigger`:
- `cardioWarmup` — "Riscaldamento. Mantieni un ritmo leggero."
- `cardioWork` — "Vai! Massimo sforzo!" / "Spingi, dai tutto!"
- `cardioRest` — "Recupera. Respira profondamente."
- `cardioZone2` — "Zona 2. Ritmo costante, puoi parlare."
- `cardioCooldown` — "Defaticamento. Rallenta gradualmente."
- `cardioDone` — "Sessione completata. Grande lavoro!"

### 2. CardioSessionScreen: info panel per fase

Per ogni fase mostrare sotto il timer:

**Riscaldamento:**
- "Mobilità leggera e attivazione cardiovascolare"
- "Intensità: 50-60% HR max"
- Icona/badge con zona target

**Lavoro (HIIT):**
- Nome esercizio suggerito (già in `exerciseSuggestion`)
- Round counter "Round 3/8"
- "Massima intensità!"

**Recupero:**
- "Recupero attivo — cammina o marcia leggera"
- Countdown al prossimo round

**Zona 2:**
- "Corsa/camminata a ritmo parlabile"
- "60-70% HR max — dovresti riuscire a parlare"

**Cooldown:**
- "Stretching leggero e respirazione profonda"
- "Lascia che il battito scenda naturalmente"

### 3. Integrazione CoachVoice in CardioSessionScreen

- `_startPhase()` → chiama `coachVoice.speak(trigger)` ad ogni cambio fase
- La screen diventa `ConsumerStatefulWidget` per accedere al provider

## Come verifico

1. Avviare sessione Tabata → verificare che ogni fase mostri istruzioni
2. Verificare che il TTS parli ad ogni cambio fase
3. Disabilitare coach voice nelle settings → verificare che non parli
4. Testare anche Zone 2 Only e Norwegian
