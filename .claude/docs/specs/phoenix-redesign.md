# Phoenix Visual Redesign — Cross-Market Synthesis

**Date:** 2026-03-12
**Status:** Fase 1 completata
**Sources:** 3 report di ricerca (Western, Russian, Chinese — 35+ app analizzate)

---

## 1. Cross-Market Pattern Mapping

### 1.1 Universali (presenti in tutti e 3 i mercati)

| Pattern | Western | Russian | Chinese | Adozione Phoenix |
|---------|---------|---------|---------|------------------|
| **Dark-first** | WHOOP, Oura, Fitbod, Zero | Welltory, FitnessKit, Meditopia | Keep (dark option), Huawei | ✅ Dark come default, light secondario |
| **Circular progress rings** | Apple Health, WHOOP, Oura | Welltory HRV dial | Huawei 3-ring, Xiaomi goal arc | ✅ 3 anelli per i 3 pilastri |
| **Card-based layout** | Tutti | Tutti | Tutti | ✅ Card come unità base del layout |
| **Bottom tab bar (4-5 item)** | Tutti (3-5 tabs) | Tutti | Tutti (4-5 tabs) | ✅ 5 tabs |
| **Large numeric readouts** | WHOOP (84%), Zero timer | Welltory (24 metriche), Kenko | Boohee dashboard, Huawei | ✅ Numeri 48-64pt come hero element |
| **Color-per-metric** | WHOOP (green/blue/yellow) | FitnessKit (activity colors) | Huawei (red/green/blue rings) | ✅ Colore per pilastro |
| **Staggered fade-in animations** | Gentler Streak, Oura | Kenko | Keep | ✅ Già implementato, da raffinare |
| **Off-white text (no #FFF puro)** | WHOOP, Strava dark | FitnessKit dark theme | Keep (no pure black text) | ✅ #E8E8ED su dark |
| **Haptic feedback** | Hevy, Fitbod | Standard | Standard | ✅ Già implementato |

### 1.2 Best-in-class per mercato (pattern unici da importare)

| Pattern | Origine | Descrizione | Per quale screen Phoenix |
|---------|---------|-------------|--------------------------|
| **3 dial circolari in dashboard** | WHOOP (Western) | Home screen = 3 anelli ciascuno con score 0-100 | Home |
| **"One Big Thing"** | Oura (Western) | Focus sul singolo insight più rilevante oggi | Home |
| **Timer time-of-day color shift** | Zero (Western) | Colore del timer cambia con l'ora del giorno | Fasting |
| **Milestone markers sul cerchio** | Zero (Western) | 12h, 16h, 24h come tacche sulla circumferenza | Fasting |
| **Calm + accent palette** | Kenko (Russian) | Base neutra, rarissimi accenti vivaci solo per CTA | Globale |
| **Banking-app quality benchmark** | FitnessKit (Russian) | Transizioni fluide, card polish, spacing sistematico | Globale |
| **Deep purple gradients per meditazione** | Meditopia (Russian) | Sfumature viola/blu profonde per stati meditativi | Conditioning |
| **Split-screen exercise selection** | Kenko (Russian) | Browse libreria + selezione su metà schermo | Workout |
| **Activity rings (3 concentrici)** | Huawei/Xiaomi (Chinese) | Move/Exercise/Stand come 3 anelli colorati | Home |
| **Rudder navigation** | Boohee (Chinese) | FAB centrale elevato per azione primaria | Home (start workout) |
| **Named tabs over icons** | Xiaomi 2024 (Chinese) | Label di testo sotto le icone, non icone sole | Nav bar |
| **Goal rainbow arc** | Xiaomi (Chinese) | Arco multicolore per progress multi-metrica | Home header |
| **Calorie-to-treats equivalence** | Huawei/Xiaomi (Chinese) | Dati emotivamente risonanti (icone cibo) | Post-workout summary |
| **Purple restraint** | Keep (Chinese) | 1 colore brand + bianco + grigi, accenti solo per CTA | Globale |

### 1.3 Pattern da NON adottare

| Pattern | Perché no |
|---------|-----------|
| Super-app bloat (Keep, Codoon) | Phoenix è un protocollo, non un marketplace |
| Social feed / community tab | Phoenix è personale, non social |
| Carousel banner promozionali | No e-commerce, no ads |
| Coin economy / gamification monetaria | Contraddice la filosofia del protocollo |
| 27-step onboarding (Meditopia) | Troppo per v1 — max 5-7 step |
| Serif typography (Calm) | Non coerente con estetica "cockpit scientifico" |

---

## 2. Phoenix Design Identity

### 2.1 Filosofia

**"Scientific cockpit, human warmth."**

- La serietà del WHOOP (dashboard da cockpit, dati come strumenti)
- L'umanità del Gentler Streak (non aggressivo, non intimidatorio)
- L'eleganza del Keep (restraint cromatico, tipografia pulita)
- La qualità del banking-app russo (polish, transizioni, spacing)

### 2.2 Color System

```
BRAND
  phoenix.primary     = #E8A838   (amber/gold — rinascita, fuoco, fenice)
  phoenix.primaryDark = #C48820

PILLAR COLORS (colore per pilastro)
  training.accent     = #F59E0B   (amber — energia, movimento)
  training.surface    = #F59E0B @ 12% opacity

  fasting.accent      = #06B6D4   (cyan — purezza, acqua, digiuno)
  fasting.surface     = #06B6D4 @ 12% opacity

  conditioning.accent = #A78BFA   (violet — meditazione, freddo, calore)
  conditioning.surface= #A78BFA @ 12% opacity

  biomarkers.accent   = #34D399   (emerald — salute, vitalità)
  biomarkers.surface  = #34D399 @ 12% opacity

  coach.accent        = #F472B6   (rose — AI, intelligenza)
  coach.surface       = #F472B6 @ 12% opacity

DARK THEME
  bg.primary          = #0F0F14   (quasi-nero caldo, non freddo)
  bg.secondary        = #1A1A24   (card background)
  bg.tertiary         = #24243A   (elevated surface)
  border.subtle       = #FFFFFF @ 6% opacity
  text.primary        = #E8E8ED   (off-white, mai #FFFFFF)
  text.secondary      = #8B8BA0   (grigio medio)
  text.tertiary       = #5C5C72   (grigio scuro)

LIGHT THEME
  bg.primary          = #F5F5F7   (grigio caldo appena percepibile)
  bg.secondary        = #FFFFFF   (card)
  bg.tertiary         = #EBEBF0   (elevated)
  border.subtle       = #000000 @ 6% opacity
  text.primary        = #1A1A24   (quasi-nero)
  text.secondary      = #64748B   (slate)
  text.tertiary       = #94A3B8

SEMANTIC
  success             = #34D399
  warning             = #FBBF24
  error               = #EF4444
  info                = #60A5FA

STATUS (RPE / Duration Score)
  zone.green          = #34D399
  zone.yellow         = #FBBF24
  zone.red            = #EF4444
```

### 2.3 Typography

```
Font family: Inter (già in uso)

Display  — 48px / weight 700 / letter-spacing -0.02em  (numeri hero: timer, score)
H1       — 28px / weight 700 / letter-spacing -0.01em
H2       — 22px / weight 600
H3       — 18px / weight 600
Body     — 15px / weight 400 / line-height 1.5
Body sm  — 13px / weight 400
Caption  — 11px / weight 500 / letter-spacing 0.05em / UPPERCASE
Label    — 13px / weight 500

Numeri metriche: Use tabular figures (fontFeatures: [FontFeature.tabularFigures()])
```

### 2.4 Spacing & Layout

```
Grid base: 8px (come FitnessKit)

Spacing scale:
  xxs  = 2px
  xs   = 4px
  sm   = 8px
  md   = 16px
  lg   = 24px
  xl   = 32px
  xxl  = 48px

Card:
  border-radius  = 16px (Radii.lg)
  padding        = 20px
  gap tra card   = 12px
  shadow (light) = 0 2px 8px rgba(0,0,0,0.06)
  border (dark)  = 1px solid white @ 6%

Screen padding:
  horizontal     = 20px
  top            = 16px (sotto safe area)
```

### 2.5 Iconografia

- **Material Symbols Rounded** (peso 300 default, 500 per icone attive)
- Icone 24px nella nav bar, 20px inline
- Pillar icons personalizzati per la nav:
  - Home: `home_rounded` (o icona fenice custom)
  - Training: `fitness_center`
  - Fasting: `schedule` (o timer custom)
  - Bio: `monitor_heart`
  - Coach: `auto_awesome` (AI sparkle)

### 2.6 Animazioni

```
Principi:
  - Smooth, mai appariscenti (Kenko, non Codoon)
  - Duration base: 300ms (transizioni), 500ms (ring fill), 150ms (feedback)
  - Curve: easeOutCubic per entrate, easeInCubic per uscite
  - Stagger: 50ms tra elementi in lista

Specifiche:
  Entry cards     → fadeIn 300ms + slideY(0.02) con stagger 50ms
  Ring fill       → animateValue 800ms easeOutCubic (da 0 al valore)
  Tab switch      → crossFade 200ms
  Pull-to-refresh → physics-based spring
  Timer pulse     → scale 1.0→1.02→1.0, 2000ms, infinite, easeInOut
  Achievement     → scale 0→1.1→1.0, 400ms, con confetti particles
  Page transition → slideRight 300ms easeOutCubic (Material default)
```

---

## 3. Screen-by-Screen Redesign

### 3.1 Home Screen (Dashboard)

**Riferimenti:** WHOOP 3-dial + Oura "One Big Thing" + Huawei activity rings + Kenko dashboard

**Layout:**
```
┌─────────────────────────────┐
│  Phoenix          [☀️/🌙]   │  ← Brand + theme toggle
├─────────────────────────────┤
│                             │
│     ╭─────────────────╮     │
│     │  3 ACTIVITY RINGS│     │  ← 3 anelli concentrici
│     │  Training  72%   │     │     Amber / Cyan / Violet
│     │  Fasting   100%  │     │     Con score numerico al centro
│     │  Conditioning 45%│     │     Tocco → drill-down
│     ╰─────────────────╯     │
│                             │
│  "One Big Thing" Card       │  ← Insight LLM del giorno
│  ┌─────────────────────┐    │     (o prossima azione suggerita)
│  │ 💡 Oggi: giorno di  │    │
│  │ rest. HRV sopra la  │    │
│  │ media ieri (+12%).   │    │
│  └─────────────────────┘    │
│                             │
│  ┌──────┐  ┌──────┐        │  ← Quick action cards (2 colonne)
│  │ 🏋️   │  │ 🕐   │        │
│  │Start  │  │Start │        │
│  │Workout│  │Fast  │        │
│  │       │  │16:8  │        │
│  └──────┘  └──────┘        │
│                             │
│  ┌──────┐  ┌──────┐        │  ← Stats cards (2 colonne)
│  │ Bio   │  │ Cond │        │
│  │PhenoA │  │Cold  │        │
│  │ 32.1  │  │2:30  │        │
│  └──────┘  └──────┘        │
│                             │
└─────────────────────────────┘
│  🏠  🏋️  🕐  ❤️  ✨ │  ← Bottom nav (5 tabs, named)
│ Home Train Fast Bio Coach│
└─────────────────────────────┘
```

**Specifiche tecniche:**
- 3 activity rings: `CustomPainter` con 3 cerchi concentrici (amber, cyan, violet)
  - Raggio esterno: ~120px, gap tra anelli: 12px, stroke: 10px
  - Animazione fill da 0 al valore in 800ms easeOutCubic
  - Score numerico al centro (media pesata o "Phoenix Score" 0-100)
  - Tap su un anello → navigazione al pilastro corrispondente
- "One Big Thing" card: sfondo gradient leggero (pillar color @ 8%), testo LLM, icona
- Quick action cards: 2 colonne, background `bg.secondary`, pillar color accent border-left 3px
- Stats cards: 2 colonne, numero grande (Display), label sotto (Caption)
- Pull-to-refresh per aggiornare dati
- Scroll verticale per contenuto sotto i ring

### 3.2 Workout Session Screen

**Riferimenti:** Fitbod/Hevy (dark, data-dense, large touch) + Nike (expressive type) + Kenko (inline cards)

**Layout attivo (durante esercizio):**
```
┌─────────────────────────────┐
│  ← Back    PUSH DAY    0:00│  ← Timer sessione in alto a dx
├─────────────────────────────┤
│                             │
│  Diamond Push-up            │  ← Nome esercizio (H1)
│  Push · Livello 5           │  ← Categoria + livello (Caption, amber)
│                             │
│  ┌─────────────────────────┐│
│  │  Set 3 / 4              ││  ← Set corrente
│  │                         ││
│  │   [−]  12 reps  [+]    ││  ← Reps con bottoni grandi (48px)
│  │                         ││
│  │   RPE: ●●●●●●●○○○  7  ││  ← Slider RPE con pallini + label
│  │         "Molto duro"    ││     (da ricerca: label testuale)
│  │                         ││
│  │   Tempo: 3-1-2-0       ││  ← Metronomo (se attivo)
│  │                         ││
│  │  [  ✓ COMPLETA SET  ]  ││  ← CTA primario (amber, pieno)
│  └─────────────────────────┘│
│                             │
│  Set precedenti:            │  ← History inline
│  Set 1: 12 reps · RPE 6    │
│  Set 2: 12 reps · RPE 7    │
│                             │
│  ┌─────────────────────────┐│
│  │  Prossimo: Archer PU   ││  ← Preview esercizio successivo
│  │  4 set · Rest 90s      ││
│  └─────────────────────────┘│
└─────────────────────────────┘
```

**Rest timer (tra set):**
```
┌─────────────────────────────┐
│                             │
│         REST                │
│                             │
│       ╭───────╮             │
│       │       │             │  ← Cerchio countdown grande
│       │  47s  │             │     con ring progress amber
│       │       │             │     pulse animation (scale 1→1.02)
│       ╰───────╯             │
│                             │
│    [SKIP →]                 │  ← Skip button (outline)
│                             │
│  💬 "Ottimo set! Mantieni  │  ← TTS coach message (se abilitato)
│      il ritmo."            │
│                             │
└─────────────────────────────┘
```

**Specifiche:**
- Background `bg.primary` (quasi-nero) per massimo contrasto in palestra
- Reps: bottoni +/- tondi 48x48px, numero centrale Display size
- RPE: slider customizzato con 10 pallini, label testuale sotto (già implementata)
- CTA "Completa Set": pieno amber, 56px altezza, rounded 12px
- Timer rest: `CustomPainter` cerchio con progress ring, countdown Display size
- Haptic: medium impact su completa set, light su +/-
- TTS: frase motivazionale tra set (già implementato)
- Swipe down o back → PopScope con conferma (già implementato)

### 3.3 Fasting Screen

**Riferimenti:** Zero (full-screen timer, time-of-day shift, milestones) + GoFasting + Qing Duanshi

**Timer attivo:**
```
┌─────────────────────────────┐
│  Digiuno Livello 2 (18:6)  │  ← Header con livello
├─────────────────────────────┤
│                             │
│                             │
│        ╭─────────╮          │
│       ╱  12h ·   ╲         │  ← Milestone markers sulla
│      │   16h ·    │         │     circumferenza del cerchio
│      │   18h ✓    │         │
│      │            │         │
│      │   14:32    │         │  ← Countdown Display (48px)
│      │  rimanenti │         │     Label "rimanenti" (Caption)
│       ╲  24h ·   ╱         │
│        ╰─────────╯          │
│                             │
│  Iniziato: 20:00            │  ← Info start/end
│  Fine prevista: 14:00       │
│                             │
│  ┌─ Milestones ────────────┐│
│  │ ✅ 12h Autofagia base   ││  ← Milestone raggiunti (green)
│  │ ✅ 16h Chetosi lieve    ││
│  │ 🔒 18h Autofagia piena  ││  ← Prossimo (locked, con progress)
│  │ 🔒 24h Ricambio cellul. ││
│  └─────────────────────────┘│
│                             │
│  [ TERMINA DIGIUNO ]       │  ← CTA secondario (outline cyan)
│                             │
└─────────────────────────────┘
```

**Specifiche:**
- Timer cerchio: `CustomPainter`, raggio ~140px, stroke 12px, colore `fasting.accent` (cyan)
- **Time-of-day color shift** (da Zero):
  - Notte (22-06): bg scurisce a `#0A0A10`, ring diventa blu profondo `#1E40AF`
  - Mattina (06-12): bg si scalda leggermente, ring `#06B6D4` (cyan standard)
  - Pomeriggio (12-18): ring più luminoso
  - Sera (18-22): graduale ritorno al notturno
- Milestone markers: tacche bianche sulla circumferenza del cerchio alle ore target
- Milestone chips: card con icona (check verde / lock grigio), nome, descrizione breve
- Milestone raggiunto → animazione bounce + haptic + opzionale TTS
- Glow effect pulsante sul ring (già implementato, da mantenere)
- Level selector (quando non attivo): 3 card per Level 1/2/3 con ore e descrizione

### 3.4 Biomarkers Screen

**Riferimenti:** Oura Vitals (timeframe switching) + WHOOP (color-coded cards) + Welltory (data density)

**Layout:**
```
┌─────────────────────────────┐
│  Biomarkers     [W/M/6M/Y] │  ← Timeframe toggle
├─────────────────────────────┤
│                             │
│  PhenoAge                   │
│  ┌─────────────────────────┐│
│  │      32.1 anni          ││  ← Display size, emerald
│  │  ↓ 0.8 vs mese scorso  ││  ← Trend arrow + delta
│  │  ▁▂▃▃▄▃▂▃▄▃▅▄▃▂▃      ││  ← Sparkline mini-chart
│  └─────────────────────────┘│
│                             │
│  ┌──────┐  ┌──────┐        │  ← Metric cards 2 colonne
│  │ Peso │  │ HRV  │        │
│  │78.2kg│  │ 45ms │        │
│  │ ↓0.3 │  │ ↑3   │        │
│  └──────┘  └──────┘        │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │Gluco │  │Infla │        │
│  │92mg  │  │0.8   │        │
│  │ →    │  │ ↓0.1 │        │
│  └──────┘  └──────┘        │
│                             │
│  Blood Panel                │
│  ┌─────────────────────────┐│
│  │ Ultimo: 2026-02-15      ││
│  │ 12 valori · 2 anomali  ││  ← Summary con alert
│  │ [Vedi dettaglio →]      ││
│  └─────────────────────────┘│
│                             │
│  [+ Aggiungi misurazione]  │  ← FAB o CTA bottom
└─────────────────────────────┘
```

**Specifiche:**
- Timeframe toggle: `SegmentedButton` (W/M/6M/Y), cambia i dati di tutte le card
- PhenoAge card: hero card piena altezza con sparkline (`fl_chart`), colore emerald
- Metric cards: numero Display, label Caption, trend arrow con colore semantico (green down per peso = good, red up per infiammazione = bad)
- Sparkline: `LineChart` minimale senza assi, solo curva, altezza 40px
- Blood panel card: summary con count valori + alert se anomalie
- FAB "+" per aggiungere misurazione manuale

### 3.5 Conditioning Screen

**Riferimenti:** Meditopia (deep purple gradients) + Zero (timer-centric) + Calm (ambient bg)

**Layout selezione tipo:**
```
┌─────────────────────────────┐
│  Condizionamento            │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────────┐│
│  │  🧊 Esposizione Freddo  ││  ← Card con gradient bg
│  │  Ultimo: 2min @ 12°C   ││     (violet → deep blue)
│  │  [INIZIA →]             ││
│  └─────────────────────────┘│
│                             │
│  ┌─────────────────────────┐│
│  │  🔥 Esposizione Calore  ││  ← (violet → warm red)
│  │  Ultimo: 15min @ 80°C  ││
│  │  [INIZIA →]             ││
│  └─────────────────────────┘│
│                             │
│  ┌─────────────────────────┐│
│  │  🧘 Meditazione         ││  ← (violet → deep purple)
│  │  Ultimo: 10min          ││
│  │  [INIZIA →]             ││
│  └─────────────────────────┘│
│                             │
│  ┌─────────────────────────┐│
│  │  😴 Sonno               ││  ← (violet → midnight blue)
│  │  Media: 7.2h / notte   ││
│  │  [REGISTRA →]           ││
│  └─────────────────────────┘│
│                             │
└─────────────────────────────┘
```

**Timer attivo (es. cold exposure):**
```
┌─────────────────────────────┐
│  ← Esci    Freddo    12°C  │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────────┐│
│  │                         ││
│  │     ╭───────────╮       ││  ← Cerchio grande, ring violet
│  │     │           │       ││     con progress animato
│  │     │   2:47    │       ││     Display 48px
│  │     │  /3:00    │       ││     Target sotto (Caption)
│  │     ╰───────────╯       ││
│  │                         ││
│  │  ❄️ ❄️ ❄️               ││  ← Ambient particles
│  │                         ││     (fiocchi per cold,
│  └─────────────────────────┘│     onde per heat,
│                             │      punti per meditation)
│  Respira...                 │  ← Breathing cue (fade in/out)
│                             │
│  [ COMPLETA ]               │  ← CTA violet
└─────────────────────────────┘
```

**Specifiche:**
- Card selezione: gradient background per tipo (ognuno con sfumatura dal violet del pilastro al colore associato)
- Timer: `CustomPainter`, ring violet, ambient particles via `CustomPainter` (fiocchi, onde, cerchi)
- Background: gradient scuro che si adatta al tipo
  - Cold: `#0F0F14` → `#0A1628` (blu profondo)
  - Heat: `#0F0F14` → `#1A0A0A` (rosso scuro)
  - Meditation: `#0F0F14` → `#14081E` (viola profondo, come Meditopia)
- Breathing cue: testo "Inspira..." / "Espira..." con fade in/out 4s cycle
- Audio: suoni ambient opzionali (già in AudioEngine)

### 3.6 Coach Screen (LLM)

**Riferimenti:** Oura Advisor (AI insight) + Headspace (personalità calda)

**Layout:**
```
┌─────────────────────────────┐
│  Coach Phoenix       [⚙️]   │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────────┐│
│  │ ✨ Modello: phi-3-mini  ││  ← Status bar modello
│  │    Offline · Pronto     ││
│  └─────────────────────────┘│
│                             │
│  Report disponibili:        │
│  ┌──────┐ ┌──────┐ ┌──────┐│
│  │Weekly│ │Fasting│ │Progr.││  ← Chip scrollabili
│  └──────┘ └──────┘ └──────┘│
│                             │
│  ─── Conversazione ─────── │
│                             │
│  🤖 Buongiorno. Ieri hai   │  ← Messaggio coach (card rose)
│     completato la sessione  │
│     in 42 minuti, RPE medio│
│     6.8. Ottima intensità. │
│                             │
│  👤 Come posso migliorare  │  ← Messaggio utente
│     il mio tempo di rest?  │
│                             │
│  🤖 Basandomi sui tuoi     │  ← Risposta con typing animation
│     dati, i rest tra set...│
│                             │
│  ┌─────────────────────────┐│
│  │ Scrivi messaggio...  [→]││  ← Input field bottom
│  └─────────────────────────┘│
└─────────────────────────────┘
```

**Specifiche:**
- Status bar modello: card con icona sparkle, nome modello, stato (Pronto/Caricamento/Errore)
- Report chips: scroll orizzontale, tap → genera report
- Chat: card alternate (coach = `coach.surface` bg, utente = `bg.tertiary`)
- Typing indicator: 3 pallini animati (bounce staggerato)
- Input: `TextField` con bordo arrotondato, send button rose
- Empty state: icona `auto_awesome` grande, testo esplicativo (già implementato, da allineare al nuovo stile)

### 3.7 Progressions Screen

**Riferimenti:** Hevy (progression charts) + Apple Health (rings)

**Layout:**
```
┌─────────────────────────────┐
│  Progressioni               │
├─────────────────────────────┤
│                             │
│  ┌─── Push ─────────── L5 ─┐│
│  │ 🏋️                      ││
│  │ ✅ 1. Wall Push-up      ││  ← Green check
│  │ ✅ 2. Incline Push-up   ││
│  │ ✅ 3. Knee Push-up      ││
│  │ ✅ 4. Push-up           ││
│  │ → 5. Diamond Push-up    ││  ← Current (amber, bold)
│  │ 🔒 6. Archer Push-up    ││  ← Locked (text.tertiary)
│  │                         ││
│  │  ▓▓▓▓▓▓▓▓▓░░░  83%    ││  ← Progress bar amber
│  └─────────────────────────┘│
│                             │
│  ┌─── Pull ─────────── L2 ─┐│
│  │ ...                     ││
│  └─────────────────────────┘│
│                             │
└─────────────────────────────┘
```

**Specifiche:**
- Card per categoria con header (icona + nome + badge livello)
- Step con icona stato: ✅ completato (green), → corrente (amber, bold), 🔒 locked (text.tertiary)
- Progress bar lineare in fondo alla card (pillar color)
- Staggered fadeIn per card (già implementato)
- Connettore verticale tra step (linea sottile 1px)

---

## 4. Bottom Navigation

**5 tabs con label:**

```
┌─────────────────────────────────────────┐
│  🏠      🏋️      🕐      ❤️      ✨    │
│ Home   Training  Fasting  Bio    Coach  │
└─────────────────────────────────────────┘
```

- Icone Material Symbols Rounded (peso 300 inattive, 500 attive)
- Label sempre visibili (named tabs, pattern Xiaomi 2024)
- Colore attivo: `phoenix.primary` (amber)
- Colore inattivo: `text.tertiary`
- Nessuna rudder navigation per v1 (troppo complesso)
- `IndexedStack` per preservare stato (già implementato)
- Workout session resta come push route (già implementato)

---

## 5. Implementation Priority

### Fase 1: Foundation (color system + typography + card layout)
1. Riscrivere `design_tokens.dart` con il nuovo color system completo
2. Riscrivere `theme.dart` con dark/light theme allineati alla spec
3. Aggiornare bottom navigation (5 tabs, named, nuovi colori)
4. Aggiornare tutte le card al nuovo border-radius/padding/spacing

### Fase 2: Home Screen
5. Implementare 3 activity rings (`CustomPainter`)
6. "One Big Thing" card
7. Quick action cards + stats cards
8. Pull-to-refresh

### Fase 3: Feature Screens
9. Fasting: timer redesign con milestones sulla circumferenza + time-of-day shift
10. Workout: layout dati-denso per sessione attiva + rest timer migliorato
11. Biomarkers: timeframe toggle + sparklines + metric cards
12. Conditioning: gradient backgrounds per tipo + ambient particles
13. Coach: chat UI + status bar modello
14. Progressions: connettori verticali + progress bar per categoria

### Fase 4: Polish
15. Tutte le animazioni secondo spec (ring fill, stagger, pulse)
16. Light theme pass completo
17. Accessibility pass (contrasti, touch target 48px min, semantics)

---

## 6. File da modificare / creare

| File | Azione | Fase |
|------|--------|------|
| `lib/app/design_tokens.dart` | Riscrivere completamente | 1 |
| `lib/app/theme.dart` | Riscrivere completamente | 1 |
| `lib/features/workout/home_screen.dart` | Riscrivere | 2 |
| `lib/widgets/activity_rings.dart` | **Nuovo** — CustomPainter 3 rings | 2 |
| `lib/widgets/metric_card.dart` | **Nuovo** — Card riusabile per metriche | 2 |
| `lib/widgets/sparkline_chart.dart` | **Nuovo** — Mini line chart | 4 (bio) |
| `lib/features/fasting/fasting_screen.dart` | Riscrivere timer | 3 |
| `lib/features/workout/workout_session_screen.dart` | Refactor layout | 3 |
| `lib/features/biomarkers/biomarkers_screen.dart` | Riscrivere | 3 |
| `lib/features/conditioning/conditioning_screen.dart` | Riscrivere | 3 |
| `lib/features/coach/coach_screen.dart` | Refactor | 3 |
| `lib/features/progressions/progressions_screen.dart` | Refactor | 3 |

---

*Spec basata sulla sintesi di 35+ app analizzate nei mercati Western, Russian e Chinese. Pattern selezionati per coerenza con la filosofia Phoenix: rigore scientifico, calore umano, assenza di bloat.*
