# Feature: Phoenix v2 — Protocol-First Redesign

**Status:** COMPLETATA (Fase 0-6)
**Created:** 2026-03-13
**Feedback source:** User testing round 1 (12 issues identified)

---

## 1. Overview

**What?** Ristrutturazione dell'app Phoenix da "catalogo di funzionalità" a "protocollo giornaliero guidato", con nuovo screen Today come vista principale, redesign B/W minimale, piano alimentare integrato, e fix di tutti i bug segnalati dagli utenti.

**Why?** Gli utenti non capiscono cosa fare e quando. L'app presenta le attività come opzionali quando il protocollo Phoenix le richiede tutte. Il feedback unanime chiede: pragmatismo, chiarezza, guida.

**For whom?** Tutti gli utenti attuali e futuri di Phoenix.

**Success metric:** L'utente apre l'app e in <3 secondi sa cosa deve fare oggi. Ogni attività del protocollo è visibile senza navigazione.

---

## 2. Scope — 12 problemi, 5 workstream

### Workstream A: Today Screen (Protocol-First)
Risolve: **#1** (app divisa per tipo, non per giorno)

### Workstream B: Visual Redesign (B/W Minimale)
Risolve: **#3** (grafica confusionaria), **#9** (testo piccolo/layout scomodo)

### Workstream C: Piano Alimentare + Food DB
Risolve: **#4** (manca piano alimentare)

### Workstream D: Contenuto Esercizi + Flessibilità Equipment
Risolve: **#2** (no flessibilità equipment), **#5** (descrizioni scarse), **#6** (no immagini)

### Workstream E: Coach Proattivo + Assessment
Risolve: **#7** (motivazionali non proattivi), **#8** (no AI durante esercizi), **#12** (manca test periodico)

### Bug Fix Immediati (pre-workstream)
Risolve: **#10** (back gesture), **#11** (dati non salvati)

---

## 3. Bug Fix Immediati (P0)

### Bug 1: Back gesture esce dall'app
**File:** `phoenix_app/lib/features/workout/home_screen.dart`
**Problema:** `HomeScreen` usa `IndexedStack` senza `PopScope`. Android back button → app si chiude.
**Fix:** Aggiungere `PopScope` al `HomeScreen`:
- Se `_currentIndex > 0`: tornare al tab 0 (Today/Home)
- Se `_currentIndex == 0`: mostrare dialog "Vuoi uscire?"

### Bug 2: Peso non letto correttamente
**File:** `phoenix_app/lib/core/models/activity_rings_data.dart` (linea 241)
**Problema:** Peso salvato con chiave `'kg'` (in `weight_tab.dart:132`) ma letto con chiave `'weight_kg'`.
**Fix:** Cambiare `v['weight_kg']` → `v['kg']` in `activity_rings_data.dart`.
**Fix aggiuntivo:** Chiamare `UserProfileDao.updateWeight()` quando l'utente inserisce un nuovo peso in WeightTab, così il profilo resta aggiornato.

---

## 4. Workstream A: Today Screen

### Concetto
L'utente apre Phoenix e vede **"Il tuo protocollo oggi"**: una lista verticale di tutte le attività da completare, con progress bar e stato. Ogni voce si espande o porta al dettaglio.

### Struttura Today Screen

```
┌─────────────────────────────────┐
│  Phoenix         [data odierna] │
│  ─────────────────────────────  │
│  Protocollo giornaliero  3/6 ██░│
│                                 │
│  ┌─ ALLENAMENTO ─────── ☐ ───┐ │
│  │ Push Day (Livello 3)       │ │
│  │ 5 esercizi · ~45 min      │ │
│  │ [Inizia] [Corpo libero ↻] │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ ALIMENTAZIONE ───── ☐ ───┐ │
│  │ Finestra: 10:00 – 18:00   │ │
│  │ Proteine: 42/128g          │ │
│  │ Prossimo pasto: 13:00      │ │
│  │ [Vedi piano] [Log pasto]   │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ DIGIUNO ──────────── ✓ ──┐ │
│  │ 14h completate (L1)        │ │
│  │ Acqua: 6 bicchieri         │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ FREDDO ──────────── ☐ ───┐ │
│  │ Target: 90s · Dose: 3/11m │ │
│  │ [Inizia timer]             │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ MEDITAZIONE ──────── ☐ ──┐ │
│  │ Box breathing · 5 min      │ │
│  │ [Inizia]                   │ │
│  └────────────────────────────┘ │
│                                 │
│  ┌─ SONNO ──────────── ☐ ────┐ │
│  │ Target: 23:00 – 07:00     │ │
│  │ Ieri: 7h 20m ★★★★☆        │ │
│  │ [Registra]                 │ │
│  └────────────────────────────┘ │
│                                 │
│  ── Messaggio del Coach ──────  │
│  "Oggi è push day. Concentrati │
│   sulla connessione mente-     │
│   muscolo nel chest press."    │
│                                 │
│ [Today] [Storico] [Bio] [Coach]│
└─────────────────────────────────┘
```

### Navigazione (Opzione C)

**Bottom nav ridotta a 4 tab:**
1. **Oggi** — Today screen (default, il protocollo)
2. **Storico** — Sostituisce Training+Fasting+Conditioning. Timeline delle sessioni passate, filtri per tipo
3. **Bio** — Biomarkers (invariato)
4. **Coach** — Coach AI (invariato)

**Ogni card del Today screen** ha azioni inline (bottoni) e/o tap per aprire il dettaglio (push a screen dedicato: workout session, timer digiuno, timer freddo, etc.)

### File da creare/modificare

| File | Azione | Cosa |
|------|--------|------|
| `lib/features/today/today_screen.dart` | **Creare** | Screen principale con lista protocollo |
| `lib/features/today/widgets/protocol_card.dart` | **Creare** | Card generica per ogni voce del protocollo |
| `lib/features/today/widgets/training_card.dart` | **Creare** | Card allenamento con switch equipment |
| `lib/features/today/widgets/nutrition_card.dart` | **Creare** | Card alimentazione con progress proteine |
| `lib/features/today/widgets/fasting_card.dart` | **Creare** | Card digiuno con stato |
| `lib/features/today/widgets/cold_card.dart` | **Creare** | Card freddo con dose settimanale |
| `lib/features/today/widgets/meditation_card.dart` | **Creare** | Card meditazione |
| `lib/features/today/widgets/sleep_card.dart` | **Creare** | Card sonno |
| `lib/features/today/widgets/coach_message.dart` | **Creare** | Messaggio motivazionale proattivo |
| `lib/features/history/history_screen.dart` | **Creare** | Timeline unificata sessioni passate |
| `lib/features/workout/home_screen.dart` | **Modificare** | Nuova nav 4 tab, PopScope fix, Today come default |
| `lib/core/models/daily_protocol.dart` | **Creare** | Modello: cosa deve fare l'utente oggi, stato completamento |

### Logica DailyProtocol

```dart
class DailyProtocol {
  final WorkoutPlan? todayWorkout;
  final bool workoutCompleted;
  final FastingStatus fastingStatus; // active/completed/not_started
  final NutritionProgress nutritionProgress; // protein eaten/target
  final MealPlan todayMeals; // piano pasti del giorno
  final ColdWeekStats coldStats;
  final bool meditationDone;
  final SleepEntry? lastNightSleep;
  final String coachMessage; // generato da LLM o template

  int get completedCount; // quante attività fatte
  int get totalCount; // sempre 6
  double get progress => completedCount / totalCount;
}
```

---

## 5. Workstream B: Visual Redesign B/W Minimale

### Principi
1. **Solo bianco e nero** — nessun colore per pilastro. Accenti minimi (verde per completato, rosso per alert)
2. **Barre, non anelli** — progress bar orizzontali con valori numerici
3. **Testo più grande** — body minimo 16sp, titoli 20sp+
4. **Spaziatura generosa** — padding 16-24px, card con bordi sottili
5. **Valori numerici visibili** — "3/6", "42/128g", "90s" sempre in evidenza

### Design Tokens (aggiornamento)

```dart
// Colori — solo B/W + stato
class PhoenixColors {
  // Primari
  static const background = Color(0xFF000000);      // nero
  static const surface = Color(0xFF111111);          // card background
  static const surfaceLight = Color(0xFF1A1A1A);     // card hover/active
  static const border = Color(0xFF2A2A2A);           // bordi card
  static const textPrimary = Color(0xFFFFFFFF);      // bianco
  static const textSecondary = Color(0xFF888888);    // grigio
  static const textTertiary = Color(0xFF555555);     // grigio scuro

  // Stato (unici accenti)
  static const completed = Color(0xFF4CAF50);        // verde
  static const alert = Color(0xFFFF4444);            // rosso
  static const inProgress = Color(0xFFFFFFFF);       // bianco (barra attiva)
  static const pending = Color(0xFF333333);          // grigio (barra vuota)
}

// Tipografia — più grande
class PhoenixTypography {
  static const displayLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w700);
  static const titleLarge = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
  static const titleMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static const numeric = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'monospace');
}
```

### Componenti da sostituire

| Componente attuale | Sostituzione |
|-------------------|--------------|
| `ActivityRings` (3 anelli concentrici) | `ProtocolProgressBar` (barra orizzontale "3/6") |
| Card colorate per pilastro | Card bordo grigio, sfondo `surface` |
| `PhoenixPillTabs` colorate | Tab semplici bianche con underline |
| Bottoni colorati TDesign | Bottoni bianco su nero, bordo bianco |
| Icone colorate | Icone bianche monocromatiche |
| Quick Actions grid 2x2 | Eliminato (integrato in Today) |

### File da modificare

| File | Azione |
|------|--------|
| `lib/app/design_tokens.dart` | Riscrivere palette B/W |
| `lib/app/phoenix_theme.dart` | Aggiornare ThemeData per B/W |
| Tutti gli screen esistenti | Rimuovere colori per pilastro, applicare nuovi token |

### Nota su TDesign
TDesign resta come libreria componenti, ma con theme overrides B/W. Non serve rimuoverlo, basta che `PhoenixTDTheme` mappi tutto su B/W.

---

## 6. Workstream C: Piano Alimentare + Food DB

### Disclaimer medico-legale (OBBLIGATORIO)

**Ogni sezione dell'app che tocca nutrizione, integratori, digiuno o protocolli di salute DEVE mostrare un disclaimer e richiedere accettazione esplicita.**

#### Primo accesso a qualsiasi sezione nutrizione/integratori/digiuno

Dialog modale bloccante (non dismissibile con tap fuori):

```
┌─────────────────────────────────────────────┐
│                                             │
│  ⚕️  AVVISO IMPORTANTE                     │
│                                             │
│  Phoenix fornisce informazioni basate su    │
│  letteratura scientifica a scopo            │
│  ESCLUSIVAMENTE educativo e informativo.    │
│                                             │
│  Phoenix NON è un dispositivo medico,       │
│  NON fornisce diagnosi, e NON sostituisce   │
│  il parere di un medico, un nutrizionista   │
│  o altro professionista sanitario           │
│  abilitato.                                 │
│                                             │
│  Prima di iniziare qualsiasi protocollo     │
│  alimentare, di integrazione o di digiuno,  │
│  CONSULTA IL TUO MEDICO, specialmente se:   │
│  • Hai patologie pregresse                  │
│  • Assumi farmaci                           │
│  • Sei in gravidanza o allattamento         │
│  • Hai meno di 18 anni                      │
│                                             │
│  Gli integratori suggeriti non sono          │
│  prescrizioni mediche. I dosaggi sono       │
│  indicativi e vanno validati dal tuo medico │
│  in base ai tuoi esami del sangue.          │
│                                             │
│  L'uso dell'app è sotto la tua esclusiva    │
│  responsabilità.                            │
│                                             │
│  ☐ Ho letto, compreso e accettato.          │
│    Mi impegno a consultare un               │
│    professionista sanitario prima di        │
│    seguire qualsiasi indicazione.           │
│                                             │
│          [ACCETTO E PROSEGUO]               │
│                                             │
└─────────────────────────────────────────────┘
```

**Regole:**
- Il checkbox deve essere spuntato manualmente prima che il bottone diventi attivo
- L'accettazione viene salvata in `user_settings` con timestamp
- Il disclaimer viene ri-mostrato una volta ogni 90 giorni
- Un link "Disclaimer e responsabilità" è sempre visibile nelle impostazioni
- Ogni screen che mostra dosaggi integratori o piani alimentari ha un footer fisso: *"Informazioni a scopo educativo. Consulta il tuo medico."*
- Il disclaimer fasting L3 (già previsto nel QA sprint) resta separato e aggiuntivo

**File:**
| File | Azione |
|------|--------|
| `lib/shared/widgets/medical_disclaimer_dialog.dart` | **Creare** — dialog modale riutilizzabile |
| `lib/core/database/daos/user_profile_dao.dart` | Aggiungere `disclaimerAcceptedAt` |
| Tutti gli screen nutrizione/integratori/digiuno | Verificare disclaimer prima di mostrare contenuto |

---

### Fonte verificata

**Il DIETARY REGIME.xlsx è stato analizzato e superato.** La ricerca trilingue (EN/ZH/RU, 80+ fonti) ha prodotto un protocollo nutrizionale completamente nuovo: `references/nutrition-protocol-verified.md`

**Cambiamenti principali rispetto al xlsx:**
- 7 pasti → 3 pasti in finestra TRE 8h
- 2950 kcal fisso → ~2100-2400 kcal parametrico
- 1.6-2.2 g/kg proteine fisso → **protein cycling** (0.4-1.6 g/kg per tipo di giorno)
- 5 integratori eliminati (ferro, termogenici, collagene, HA, cocco+collagene)
- 2 integratori aggiunti (NMN, spermidina)
- 10 alimenti mancanti aggiunti (germe di grano, melagrana, noci, capperi, etc.)
- 3 claim FGF21 falsi rimossi
- Tutti i dosaggi sono **parametrici** (peso, sangue, livello Phoenix, percorso)

### Piano alimentare in-app

#### Nuovo modello dati

```dart
// Tabella food_items (seed dal protocollo verificato)
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();                    // "Germe di grano"
  TextColumn get category => text()();                // "Tier 1 — Ringiovanimento"
  RealColumn get proteinPer100g => real()();          // 23.0
  RealColumn get carbsPer100g => real()();            // 52.0
  RealColumn get fatsPer100g => real()();             // 10.0
  RealColumn get caloriesPer100g => real()();         // 360.0
  RealColumn get fiberPer100g => real().nullable()();
  IntColumn get glycemicIndex => integer().nullable()();
  TextColumn get portionExample => text()();          // "15g (54kcal)"
  TextColumn get useIdeas => text()();                // "Nel porridge, nello yogurt"
  TextColumn get longevityBenefit => text()();        // "Fonte #1 spermidina (24-35mg/100g) — attivatore autofagia"
  TextColumn get activeCompounds => text()();         // JSON: {"spermidine_mg": 30, "mechanisms": ["autophagy"]}
  IntColumn get longevityTier => integer()();         // 1-4 (1=multi-mechanism, 4=neutral)
  TextColumn get idealTiming => text().nullable()();  // "Pasto 1 (refeeding)"
}

// Tabella meal_templates (piani pasto per TRE)
class MealTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayOfWeek => text()();               // "monday"
  IntColumn get mealNumber => integer()();            // 1, 2, 3
  TextColumn get dayType => text()();                 // "training" / "normal" / "autophagy"
  TextColumn get description => text()();             // "Salmone con riso raffreddato e broccoli"
  TextColumn get ingredients => text()();             // JSON: [{"food_id": 1, "grams_per_kg": 1.5}, ...]
  RealColumn get proteinPerKgBody => real()();        // proteine per kg peso utente
  TextColumn get cookingMethod => text()();
  TextColumn get timing => text()();                  // "post-training", "principale", "leggero"
}
```

**Nota chiave:** `ingredients.grams_per_kg` — le quantità sono scalate per peso utente, non fisse.

#### Logica MealPlanGenerator

```dart
MealPlan generateForDay({
  required double weightKg,
  required int phoenixLevel,
  required String dayType,     // "training" / "normal" / "autophagy"
  required String dayOfWeek,
  BloodPanel? bloodPanel,      // opzionale, migliora personalizzazione
  required int weeksActive,
}) {
  // 1. Calcola target proteico per tipo giorno
  final proteinTarget = _proteinForDayType(weightKg, phoenixLevel, dayType);

  // 2. Calcola calorie stimate
  final calorieTarget = _caloriesForDayType(weightKg, dayType);

  // 3. Seleziona template pasti (rotazione settimanale × tipo giorno)
  final templates = getMealTemplates(dayOfWeek, dayType);

  // 4. Scala quantità per peso utente
  final meals = templates.map((t) => _scaleMeal(t, weightKg)).toList();

  // 5. Genera lista integratori personalizzata
  final supplements = _supplementsForProfile(
    weightKg, phoenixLevel, weeksActive, bloodPanel,
  );

  return MealPlan(meals: meals, proteinTarget: proteinTarget,
    calorieTarget: calorieTarget, supplements: supplements, dayType: dayType);
}
```

#### UI Piano Alimentare (nella NutritionCard del Today screen)

```
┌─ ALIMENTAZIONE ──────────────────┐
│ Finestra: 10:00 – 18:00          │
│ Proteine: ████████░░ 42/128g     │
│                                   │
│ Pasto 1 (10:00) ✓                │
│  Uova + avena + yogurt greco     │
│  35g P · 500 kcal                │
│                                   │
│ Pasto 2 (14:00) ← prossimo      │
│  Pollo + riso integrale + broccoli│
│  40g P · 550 kcal                │
│                                   │
│ Pasto 3 (17:30)                  │
│  Salmone + riso + spinaci        │
│  35g P · 450 kcal                │
│                                   │
│ [Dettaglio ricette] [Log pasto]  │
└──────────────────────────────────┘
```

#### Dettaglio ricetta (bottom sheet)

Quando l'utente tappa un pasto:
- Ingredienti con grammature
- Metodo cottura (dal xlsx)
- Macro breakdown
- Benefici degli ingredienti (dal food DB)
- Alternativa rapida (se non si ha tempo di cucinare)

#### File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/database/tables.dart` | Aggiungere `FoodItems`, `MealTemplates` |
| `lib/core/database/seed/food_seed.dart` | **Creare** — seed da xlsx (~50 alimenti) |
| `lib/core/database/seed/meal_template_seed.dart` | **Creare** — 7 giorni × 3 pasti |
| `lib/core/database/daos/food_dao.dart` | **Creare** — query food items |
| `lib/core/database/daos/meal_template_dao.dart` | **Creare** — query meal templates per giorno |
| `lib/core/models/meal_plan_generator.dart` | **Creare** — genera piano giornaliero scalato per peso |
| `lib/features/today/widgets/nutrition_card.dart` | Usare MealPlanGenerator |
| `lib/features/nutrition/meal_detail_sheet.dart` | **Creare** — dettaglio ricetta |

---

## 7. Workstream D: Contenuto Esercizi + Flessibilità Equipment

### D1: Descrizioni esercizi arricchite

**Stato attuale:** `executionCues` ha 1-3 frasi telegrafiche. `instructions` è vuoto.

**Azione:** Popolare il campo `instructions` con:
- Descrizione dell'esercizio (2-3 frasi)
- Muscoli coinvolti e perché
- Errori comuni da evitare (2-3 punti)
- Cue di respirazione
- Variante facilitata se disponibile

**Fonte:** `references/esecuzione-esercizi.md` + `references/phoenix-protocol.md` sezione 2.7

**Approccio:**
- Aggiornare `exercise_seed.dart` con `instructions` compilate per tutti gli ~80 esercizi
- Aggiornare `ExerciseDetailSheet` per mostrare `instructions` in una sezione espandibile sotto i numbered steps
- Aggiungere sezione "Errori comuni" con icona ⚠

### D2: Immagini esercizi

**Opzione realistica (no foto/video):** Generare illustrazioni SVG stilizzate (stick figure o silhouette) per ogni esercizio. Alternative:
- **Opzione A:** Illustrazioni AI-generated (richiede pipeline esterna)
- **Opzione B:** Icone schematiche per categoria + posizione (es. silhouette push-up)
- **Opzione C:** Nessuna immagine ma descrizione testuale molto dettagliata (fase 1)

**Raccomandazione:** Fase 1 = Opzione C (descrizioni ricche). Fase 2 = immagini quando disponibili. L'infrastruttura (`imagePaths` nel DB, `assets/exercises/`) è già pronta.

### D3: Flessibilità equipment

**Stato attuale:** `WorkoutGenerator.generateForDay()` usa l'equipment dalle impostazioni utente (fisso).

**Modifica:**
1. Aggiungere bottone "Corpo libero oggi" sulla TrainingCard del Today screen
2. Quando premuto, `WorkoutGenerator` rigenera il piano con `equipment: 'bodyweight'`
3. Il piano rigenerato rispetta livello e categoria del giorno (push/pull/squat/hinge/core)
4. Il seed ha già esercizi bodyweight per ogni categoria — basta passare il parametro

**File da modificare:**
| File | Azione |
|------|--------|
| `lib/core/database/seed/exercise_seed.dart` | Arricchire `instructions` per tutti gli esercizi |
| `lib/features/exercise/exercise_detail_sheet.dart` | Mostrare `instructions` espandibile + errori comuni |
| `lib/core/models/workout_generator.dart` | Accettare equipment override per singola sessione |
| `lib/features/today/widgets/training_card.dart` | Bottone switch equipment |

---

## 8. Workstream E: Coach Proattivo + Assessment

### E1: Messaggi motivazionali proattivi

**Attuale:** L'utente deve aprire Coach e chiedere.

**Nuovo:** Un messaggio del coach appare in fondo al Today screen, generato automaticamente.

**Logica generazione (template fallback se no LLM):**
- Mattina: messaggio basato sul workout del giorno
- Pre-workout: focus tecnico sull'esercizio principale
- Post-workout: congratulazioni + recovery tips
- Sera: reminder sonno + recap giornata

**Trigger:** `DailyProtocol` calcola il momento appropriato e genera il messaggio.

### E2: AI durante workout

**Attuale:** Nessuna integrazione LLM nel workout flow.

**Nuovo:** Se LLM disponibile, genera cue motivazionali tra le serie:
- Basati su RPE dell'ultimo set
- Modulati per difficoltà e livello
- In italiano, tono coach diretto

**Se LLM non disponibile:** Template motivazionali pre-scritti, selezionati per contesto (esercizio, set number, RPE).

**File:**
| File | Azione |
|------|--------|
| `lib/features/today/widgets/coach_message.dart` | Messaggio proattivo su Today |
| `lib/core/models/coach_prompts.dart` | **Creare** — template motivazionali per contesto |
| `lib/features/workout/workout_session_screen.dart` | Integrare cue tra le serie |

### E3: Assessment periodico

**Problema:** Nessun test strutturato per misurare il progresso.

**Proposta:** Assessment ogni 4 settimane con test validati:

| Test | Misura | Metodo | Fonte |
|------|--------|--------|-------|
| Push-up max reps | Forza upper body | ACSM push-up test | ACSM Guidelines 11th ed. |
| Wall sit | Resistenza lower body | Tempo fino a cedimento | Eurofit battery |
| Plank hold | Core endurance | Tempo fino a cedimento | McGill 2015 |
| Sit & reach | Flessibilità | Distanza raggiunta (cm) | Eurofit battery |
| Cooper test (opzionale) | VO2max stimato | Distanza in 12 min | Cooper 1968 |
| Peso + misure | Composizione | Bilancia + metro | — |

**Implementazione:**
- Ogni 4 settimane → notifica "È ora dell'assessment"
- Screen dedicato con istruzioni per ogni test
- Risultati salvati nel DB
- Trend nel tempo (grafico)
- Il coach commenta i risultati

**File:**
| File | Azione |
|------|--------|
| `lib/features/assessment/assessment_screen.dart` | **Creare** |
| `lib/core/database/tables.dart` | Aggiungere tabella `assessments` |
| `lib/core/database/daos/assessment_dao.dart` | **Creare** |
| `lib/core/models/assessment_scoring.dart` | **Creare** — scoring per test |

---

## 9. Workstream F: Ricerca Notturna + Aggiornamento Protocollo

### Concetto

Phoenix non è un'app statica — il protocollo si evolve con la scienza. L'app cerca autonomamente nuovi studi ogni notte e propone aggiornamenti al protocollo una volta al mese.

### Architettura

```
┌─ NOTTE (in carica + Wi-Fi) ──────────────────────────┐
│                                                        │
│  1. WorkManager trigger (03:00, se in carica + Wi-Fi) │
│                                                        │
│  2. Query API pubbliche (ultimi 30 giorni):           │
│     ├── PubMed/PMC (EN) — API E-utilities gratuita    │
│     ├── CNKI/Wanfang (ZH) — abstract cinesi           │
│     └── CyberLeninka/eLibrary (RU) — accesso aperto   │
│                                                        │
│  3. Keyword matching Phoenix:                          │
│     autophagy, spermidine, mTOR, time-restricted       │
│     eating, NAD+, senolytic, fisetin, cold exposure,   │
│     sulforaphane, urolithin, NMN, fasting, longevity   │
│                                                        │
│  4. Scarica abstract nuovi paper                       │
│                                                        │
│  5. BitNet locale (2B) valuta ciascuno:               │
│     ├── Rilevante per Phoenix? → sì/no                │
│     ├── Area? → nutrizione/esercizio/integratori/...  │
│     ├── Finding chiave? → 1 frase                     │
│     └── Impatto sul protocollo? → alto/medio/basso    │
│                                                        │
│  6. Salva i "sì" nel DB locale (tabella research_feed)│
└────────────────────────────────────────────────────────┘

┌─ COACH SCREEN (continuo) ────────────────────────────┐
│                                                        │
│  "Questa settimana: 3 nuovi studi rilevanti"          │
│  L'utente può leggere riassunto + abstract completo   │
└────────────────────────────────────────────────────────┘

┌─ AGGIORNAMENTO MENSILE ──────────────────────────────┐
│                                                        │
│  1. Ogni 30 giorni: BitNet analizza tutti i paper     │
│     raccolti nel mese                                  │
│                                                        │
│  2. Genera "Proposta aggiornamento protocollo":       │
│     ├── Cosa cambiare (es. "nuovo studio su dose      │
│     │   spermidina: 3mg → 6mg supportato da RCT")     │
│     ├── Perché (abstract + DOI)                        │
│     └── Livello di confidenza (1 studio vs meta-anal.) │
│                                                        │
│  3. L'utente APPROVA o RIFIUTA ogni modifica          │
│     Il protocollo NON cambia mai automaticamente       │
│                                                        │
│  4. Se approvata: aggiorna i parametri nel DB locale  │
│     (dosaggi integratori, alimenti tier, macro range)  │
└────────────────────────────────────────────────────────┘
```

### Nuova tabella DB

```dart
class ResearchFeed extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get foundDate => dateTime()();
  TextColumn get source => text()();              // "pubmed" / "cnki" / "cyberleninka"
  TextColumn get language => text()();            // "en" / "zh" / "ru"
  TextColumn get title => text()();
  TextColumn get abstractText => text()();
  TextColumn get doi => text().nullable()();
  TextColumn get url => text()();
  TextColumn get area => text()();                // "nutrition" / "exercise" / "supplements" / ...
  TextColumn get keySummary => text()();          // 1 frase dal BitNet
  TextColumn get impact => text()();              // "high" / "medium" / "low"
  BoolColumn get userRead => boolean().withDefault(const Constant(false))();
  BoolColumn get proposedUpdate => boolean().withDefault(const Constant(false))();
  TextColumn get updateProposal => text().nullable()(); // cosa cambiare nel protocollo
  TextColumn get updateStatus => text().nullable()();   // "pending" / "approved" / "rejected"
}
```

### File da creare

| File | Azione |
|------|--------|
| `lib/core/research/research_fetcher.dart` | **Creare** — query PubMed/CNKI/CyberLeninka API |
| `lib/core/research/research_evaluator.dart` | **Creare** — BitNet valuta abstract |
| `lib/core/research/protocol_updater.dart` | **Creare** — genera proposte aggiornamento mensili |
| `lib/core/database/tables.dart` | Aggiungere `ResearchFeed` |
| `lib/core/database/daos/research_feed_dao.dart` | **Creare** |
| `lib/features/coach/widgets/research_feed_card.dart` | **Creare** — card "nuovi studi" nel Coach |
| `lib/features/coach/protocol_update_sheet.dart` | **Creare** — bottom sheet proposta aggiornamento |
| `lib/core/background/background_tasks.dart` | Aggiungere task notturno ricerca |

### Vincoli

- **Mai modificare il protocollo senza approvazione utente**
- Query API solo con Wi-Fi + in carica (risparmio dati/batteria)
- BitNet si carica, valuta, si scarica — non resta in RAM tutta la notte
- Max 20 abstract per sessione notturna (limiti API + tempo BitNet)
- Disclaimer: "Questi studi sono presentati a scopo informativo. Consulta il tuo medico prima di modificare il protocollo."

---

## 10. Ordine di implementazione

```
Fase 0: Bug fix immediati (1 sessione)
  ├── Fix back gesture (PopScope su HomeScreen)
  └── Fix peso JSON key mismatch

Fase 1: Today Screen + Redesign B/W (2-3 sessioni)
  ├── Nuovi design tokens B/W
  ├── Today screen con card statiche
  ├── Nuova bottom nav 4 tab
  ├── DailyProtocol model
  └── History screen base

Fase 2: Piano Alimentare Verificato (2-3 sessioni)
  ├── Food DB seed (dal protocollo verificato, non xlsx)
  ├── Meal template seed (3 pasti × 7 giorni × 3 tipi giorno)
  ├── MealPlanGenerator parametrico (peso, livello, tipo giorno, sangue)
  ├── NutritionCard nel Today con protein cycling
  ├── Meal detail sheet con longevity benefit
  └── Supplements personalizzati per profilo

Fase 3: Contenuto Esercizi (1-2 sessioni)
  ├── Instructions arricchite per tutti gli esercizi
  ├── ExerciseDetailSheet aggiornato
  └── Equipment switch nel Today

Fase 4: Coach Proattivo (1-2 sessioni)
  ├── Coach message su Today
  ├── Template motivazionali
  └── Cue durante workout

Fase 5: Assessment (1 sessione)
  ├── Assessment screen
  ├── Tabella + DAO
  └── Scheduling ogni 4 settimane

Fase 6: Ricerca Notturna + Aggiornamento Protocollo (2 sessioni)
  ├── ResearchFetcher (PubMed/CNKI/CyberLeninka API)
  ├── ResearchEvaluator (BitNet valuta abstract)
  ├── Background task notturno
  ├── Research feed nel Coach screen
  ├── ProtocolUpdater (proposta mensile)
  └── UI approvazione/rifiuto aggiornamenti
```

---

## 11. Cosa NON è in scope

- Generazione immagini esercizi (fase futura)
- Integrazione con wearable/Apple Health/Google Fit
- Periodizzazione avanzata (mesocicli, deload)
- Calorie counting dettagliato (Phoenix è protein-first, non calorie-first)
- Multi-lingua (resta italiano)

---

## 12. Rischi

| Rischio | Impatto | Mitigazione |
|---------|---------|-------------|
| Redesign B/W tocca tutti gli screen | Alto | Fare prima design tokens, poi propagare gradualmente |
| Food DB verificato potrebbe avere gap | Basso | Il protocollo è basato su 80+ fonti trilingue; USDA cross-check per macro |
| Meal templates troppo rigidi | Medio | Permettere "swap" con alternative dalla stessa categoria |
| Assessment tests richiedono istruzioni molto precise | Medio | Descrizioni dettagliate + link a video esterni (YouTube) |
| History screen potrebbe essere complesso | Medio | Fase 1 = lista semplice filtrata per tipo. Niente grafici avanzati |

---

## 13. Database migration

**Versione attuale:** v4
**Nuova versione:** v5

**Nuove tabelle:**
- `food_items` (~60 righe seed — alimenti verificati con longevity tier + active compounds)
- `meal_templates` (~63 righe seed: 7 giorni × 3 pasti × 3 tipi giorno)
- `assessments` (vuota, utente popola)
- `research_feed` (vuota, popolata dal fetcher notturno)

**Modifiche tabelle esistenti:**
- Nessuna (i campi `instructions`, `imagePaths` esistono già in `exercises`)

---

*Attendo PROCEED per iniziare da Fase 0 (bug fix immediati).*
