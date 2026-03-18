# Spec: Phoenix UX Upgrade — Estetica, TTS Coach, Light Mode, Audit UX

**Data:** 2026-03-12
**Tipo:** Enhancement (multi-area)
**Stato:** Completato 2026-03-12

---

## Cosa stiamo costruendo

Upgrade complessivo dell'esperienza utente: (1) TTS Coach motivazionale con frasi parlate, (2) miglioramento estetico basato su principi ZeePalm/Material Design, (3) dual theme light+dark, (4) fix UX da audit del codice.

---

## 1. TTS Coach Motivazionale

**Pacchetto:** `flutter_tts` (nativo Android/iOS, fallback silenzioso su Linux/web)

**File nuovo:** `lib/core/tts/coach_voice.dart`

**Comportamento:**
- Frasi motivazionali in italiano, tono diretto/provocatorio
- 3 trigger:
  - **Notifica schedulata** — se non apri l'app entro le 10:00: "Quando pensi di allenarti oggi?"
  - **Inattivita** — 2+ giorni senza allenamento: "Perche hai smesso di volerti bene?"
  - **Durante workout** — tra le serie, frasi brevi: "Dai, un'altra serie."
- Pool di frasi randomizzate per non ripetere
- Configurabile: on/off, volume, velocita parlato
- Si integra con `NotificationService` per i trigger schedulati

**Frasi esempio:**
```
// Motivazione mattutina
"Buongiorno. Il protocollo ti aspetta."
"Oggi e il giorno giusto per migliorare."
"Quando pensi di allenarti?"

// Inattivita (2+ giorni)
"Sono due giorni che non ti alleni. Tutto bene?"
"Perche hai smesso di volerti bene?"
"Il tuo corpo non si trasforma da solo."

// Durante workout
"Dai, un'altra serie."
"Non mollare adesso."
"Concentrati. Forma perfetta."
"Ultimo set. Dai tutto."

// Post-workout
"Grande sessione. Il corpo ringrazia."
"Un passo piu vicino alla rinascita."
```

---

## 2. Miglioramento Estetico

### 2a. Design tokens centralizzati

**File:** `lib/app/design_tokens.dart`

```dart
class Spacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class Radii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;
}
```

### 2b. Gradient e visual richness

- **Card principali**: sottile gradient overlay (non piatto)
- **Timer circolari**: glow effect intorno al progresso
- **Fasting banner**: gradient animato
- **Progress bars**: gradient con shimmer per stati attivi

### 2c. Animazioni con flutter_animate

- **Ingresso card**: fadeIn + slideUp staggerato (50ms delay per card)
- **Completamento set**: scale bounce + checkmark
- **Timer**: pulse glow durante countdown
- **Navigazione**: transizioni hero per le icone principali
- **Milestone raggiunta**: confetti/particle effect leggero

### 2d. Tipografia migliorata

- Peso differenziato: titoli 700, body 400, label 500
- Line height: 1.4 per body, 1.2 per titoli
- Letter spacing leggero sui titoli grandi

### 2e. Icone e visual

- Icone piu grandi nella bottom nav (28px)
- Indicatore attivo piu visibile (dot sotto icona selezionata)
- Touch target minimo 48x48 su tutti i bottoni

---

## 3. Dual Theme (Light + Dark)

### Dark theme (esistente, migliorato)
- Sfondo: `#1A1A2E` (invariato)
- Card surface: `#16213E` con bordo sottile `Colors.white10`
- Testo primario: `Colors.white`
- Testo secondario: `Colors.white70`

### Light theme (nuovo)
- Sfondo: `#F5F5F7` (grigio caldissimo)
- Card surface: `#FFFFFF` con shadow soft
- Primary: `#FF6B35` (invariato)
- Testo primario: `#1A1A2E`
- Testo secondario: `#64748B`
- AppBar: bianca con testo scuro

### Toggle
- In `MaterialApp`: `themeMode: themeMode` da provider Riverpod
- Toggle nella bottom nav o in un futuro Settings screen
- Persiste in `UserSettings` table (gia esistente)

---

## 4. Audit UX dal codice

### Problemi identificati dalla lettura del codice:

| # | Problema | Dove | Fix |
|---|---------|------|-----|
| 1 | **Empty state generico** — utente nuovo vede card vuote senza guida | HomeScreen | Aggiungere onboarding card "Inizia il primo allenamento" |
| 2 | **BottomNav non mantiene stato** — ogni tap fa pushNamed, creando stack infinito | HomeScreen._BottomNav | Usare IndexedStack o NavigatorState per tab switching |
| 3 | **Timer digiuno non persiste** — se chiudi l'app, il timer ricomincia da 0 visivamente | FastingScreen | Il dato e in DB (startedAt), il timer si ricalcola. OK ma serve verifica |
| 4 | **RPE slider senza label** — utente non sa cosa significa RPE 1-10 | WorkoutSessionScreen | Aggiungere label descrittive (1=facile, 10=massimale) |
| 5 | **Nessun feedback haptic** — tap silenziosi | Globale | Aggiungere HapticFeedback.lightImpact() sui tap |
| 6 | **Progressioni statiche** — mock data, non collegato a DB | ProgressionsScreen | Collegare a ProgressionHistory table |
| 7 | **Coach LLM non ha fallback UI** — se il modello non c'e, l'utente non capisce cosa fare | CoachScreen | Migliorare empty state con spiegazione chiara |
| 8 | **Workout session senza back confirmation** — puoi uscire a meta allenamento senza avviso | WorkoutSessionScreen | Aggiungere WillPopScope con dialog di conferma |

---

## File che tocco

| File | Modifica |
|------|----------|
| `pubspec.yaml` | Aggiungere `flutter_tts` |
| `lib/app/theme.dart` | Light theme, design tokens, gradient defs |
| `lib/app/design_tokens.dart` | **NUOVO** — spacing, radii, durations |
| `lib/core/tts/coach_voice.dart` | **NUOVO** — TTS engine con frasi |
| `lib/app/providers.dart` | Provider per CoachVoice e themeMode |
| `lib/main.dart` | ThemeMode da provider |
| `lib/features/workout/home_screen.dart` | BottomNav fix, empty state, animazioni |
| `lib/features/workout/workout_session_screen.dart` | RPE labels, haptic, back confirmation |
| `lib/features/fasting/fasting_screen.dart` | Glow timer, animazioni |
| `lib/features/coach/coach_screen.dart` | Better empty state |
| `lib/core/notifications/notification_service.dart` | TTS integration |

---

## Come verifico

1. `flutter analyze` — 0 errori
2. `flutter run -d linux` — app si avvia senza crash
3. Toggle light/dark — entrambi i temi visibili
4. Frasi TTS — verificabile solo su Android/iOS (su Linux fallback silenzioso)
5. Animazioni visibili sulle card e transizioni

---

## Priorita implementazione

1. Design tokens + dual theme (fondamenta)
2. Animazioni flutter_animate (visual impact immediato)
3. TTS Coach (feature nuova)
4. Fix UX (audit items)
