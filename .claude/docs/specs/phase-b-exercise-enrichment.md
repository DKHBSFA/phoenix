# Feature: Exercise Database — Validazione Scientifica e Arricchimento

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Validare ogni esercizio nel DB (esistenti + candidati dai materiali originali) contro gli obiettivi del Protocollo Phoenix, poi arricchire il DB con esercizi scientificamente giustificati.
**Why?** Il DB attuale (~80 esercizi) è stato costruito senza validazione critica. I materiali originali (Month A/B/C, Calisthenic.xlsx) contengono esercizi pensati per bodybuilding, non per longevità. Importarli ciecamente ripeterebbe l'errore. Ogni esercizio deve guadagnarsi il suo posto nel protocollo.
**For whom?** Tutti gli utenti — la selezione degli esercizi determina se l'app produce forza (longevità) o solo volume muscolare (estetica).
**Success metric:** Ogni esercizio nel DB ha una giustificazione scientifica rispetto al protocollo; la selezione complessiva copre tutti i pattern motori richiesti con varietà sufficiente per la rotazione.

---

## 2. Il Problema Fondamentale

### L'obiettivo del training nel Protocollo Phoenix NON è l'ipertrofia

La gerarchia degli obiettivi (dal protocollo §2.1):

1. **Forza** — previene sarcopenia, predittore di mortalità (Garcia-Hermoso: alta forza = -31% mortalità, -40% nelle donne)
2. **VO2max** — miglior singolo predittore di mortalità per tutte le cause (Mandsager 2018, n=122,007)
3. **Autofagia** — richiede intensità elevata (Schwalm 2015: l'intensità conta più della dieta)
4. **Massa muscolare** — conseguenza della forza, non obiettivo primario
5. **Flessibilità** — integrata via tempo eccentrico + PNF

### I materiali originali (Excel) hanno problemi documentati

L'analisi critica (`training-analysis-verified.md`) ha identificato:

| Problema | Excel Month A/B/C | Cosa serve per il protocollo |
|----------|-------------------|------------------------------|
| Rep range | 12-21 reps (endurance) | 1-8 forza, 8-12 ipertrofia (periodizzato) |
| Carico | ~40-60% fisso | 60-95% progressivo per tier |
| Progressione | Reps ↑ con carico fisso (overload invertito) | Carico ↑ o reps ↑ con periodizzazione |
| Volume isolamento | 16+ set/settimana bicipiti/tricipiti | 4-8 set/muscolo sufficienti (Pelland 2025) |
| Grip strength | Assente | Esplicito: farmer walks, carries (PURE Study) |
| Compound ratio | ~50% isolation | 70-80% compound multi-articolari |
| Periodizzazione | Nessuna | DUP o Block (Moesgaard 2022) |

**Conclusione: gli Excel non vanno importati come-sono. Vanno usati come fonte di esercizi candidati, filtrati dai criteri del protocollo.**

---

## 3. Criteri di Ammissione al DB

Ogni esercizio deve superare questo filtro:

### Criterio 1: Pattern motorio richiesto dal protocollo
L'esercizio copre uno di questi pattern?
- Push orizzontale / Push verticale
- Pull orizzontale / Pull verticale
- Squat (knee-dominant)
- Hip-dominant (deadlift, hip thrust, Nordic curl)
- Carry (farmer walk, suitcase carry) — per grip strength
- Core anti-rotazione / anti-estensione
- Cardio/condizionamento (HIIT, Zone 2)

**Se no → ESCLUSO** (es: cable internal rotation isolata, concentration curl)

### Criterio 2: Contributo alla forza (non solo volume)
L'esercizio può essere caricato progressivamente fino a 80%+ 1RM?
- **Compound multi-articolare:** sì → AMMESSO come compound
- **Isolamento con carico significativo:** ammesso come accessory (max 1-2 per sessione)
- **Isolamento leggero / pompa muscolare:** ESCLUSO

### Criterio 3: Rapporto rischio/beneficio per longevità
- **Behind-the-neck press, upright row:** rischio spalla elevato → ESCLUSO
- **Smith machine squat/hack squat:** pattern motorio vincolato → ammesso solo come variante facilitata
- **Esercizi esplosivi (clap push-ups, jump squats):** ammessi solo per Advanced (rischio per principianti)
- **Eccentric-dominant (Nordic curl):** PRIORITARIO — -51% strain hamstring (meta-analisi)

### Criterio 4: Compatibilità con i vincoli del protocollo
- **Tempo eccentrico ≥2s** possibile? Se l'esercizio non si presta al tempo controllato → valutare
- **Compatibile con digiuno intermittente?** Esercizi a volume estremo → cautela
- **Recupero ragionevole in 48-72h?** Se troppo distruttivo → solo per Advanced

### Criterio 5: Disponibilità per equipment type
L'esercizio ha almeno una variante per ciascun equipment setting?
- Palestra: bilanciere/macchina/cavi
- Home gym: manubri/elastici/panca
- Corpo libero: bodyweight puro

Se manca una variante → cercare equivalente o accettare gap documentato.

---

## 4. Audit dei Materiali Originali

### 4.1 Month A — Verdetto per esercizio

| Esercizio Excel | Pattern | Verdict | Motivazione |
|----------------|---------|---------|-------------|
| Machine Leg Press | Squat | ✅ AMMESSO | Compound gambe, caricabile, buon entry-level |
| Machine Leg Extension | Isolation | ⚠️ ACCESSORY | Isolamento quadricipiti, utile per riabilitazione/volume aggiuntivo |
| Machine Leg Curl | Isolation | ⚠️ ACCESSORY | Isolamento hamstring, utile ma Nordic Curl è superiore |
| Machine Fly | Isolation | ❌ ESCLUSO | Isolamento pettorale leggero, sostituito da DB Fly caricabile |
| Machine Calf Raise | Isolation | ⚠️ ACCESSORY | Polpacci utili per corsa/equilibrio, ammesso come accessory |
| Machine Hip Adduction | Isolation | ❌ ESCLUSO | Volume basso impatto su longevità, sostituito da squat sumo/cossack |
| Preacher Curl Machine | Isolation | ❌ ESCLUSO | Bicipiti isolati non prioritari per forza/longevità |
| Leverage Machine Iso Row | Pull orizz. | ✅ AMMESSO | Pattern pull, caricabile |
| Dumbbell Pullover | Push/Pull ibrido | ⚠️ ACCESSORY | Espansione toracica, mobilità spalla — ammesso come accessory |
| Cable Internal Rotation | Isolation | ❌ ESCLUSO | Rehab-specifico, non training generale |
| Cable Reverse Crossover | Isolation | ❌ ESCLUSO | Volume pettorale superfluo |
| Barbell Deep Squat | Squat | ✅ AMMESSO PRIORITARIO | Compound fondamentale, full ROM |
| Cable Rope Hammer Curl | Isolation | ❌ ESCLUSO | Volume bicipiti superfluo |
| Dual Cable Triceps | Isolation | ❌ ESCLUSO | Sostituito da dip/close-grip press |

### 4.2 Month B — Verdetto per esercizio

| Esercizio Excel | Pattern | Verdict | Motivazione |
|----------------|---------|---------|-------------|
| Barbell Hip Thrust | Hip-dominant | ✅ AMMESSO PRIORITARIO | Attivazione glutei superiore, caricabile, transfer funzionale |
| Barbell Military Press | Push verticale | ✅ AMMESSO PRIORITARIO | Fondamentale overhead, full-body stability |
| Barbell Drag Curl | Isolation | ❌ ESCLUSO | Variante curl non necessaria |
| Smith Machine Hack Squat | Squat | ⚠️ ACCESSORY | Pattern vincolato, ammesso come variante facilitata |
| Cable Seated Row | Pull orizz. | ✅ AMMESSO | Pattern pull, buona variante |
| Cable Mid Chest Crossover | Isolation | ❌ ESCLUSO | Volume pettorale superfluo |
| Cable External Rotation | Isolation | ❌ ESCLUSO | Rehab-specifico |
| Dumbbell Bulgarian Split Squat | Squat unilaterale | ✅ AMMESSO PRIORITARIO | Unilaterale, equilibrio, transfer funzionale elevato |
| EZ Bar Skull Crusher | Isolation | ⚠️ ACCESSORY | Tricipiti caricabili, ammesso come accessory |
| Machine Hip Abduction | Isolation | ❌ ESCLUSO | Sostituito da squat laterali |
| Machine Reverse Fly | Pull orizz. | ⚠️ ACCESSORY | Postura/spalle posteriori, utile come accessory |
| Machine Seated Calf Raise | Isolation | ⚠️ ACCESSORY | Come sopra |
| Machine Bicep Curl | Isolation | ❌ ESCLUSO | Volume bicipiti superfluo |

### 4.3 Calisthenic.xlsx — Verdetto per livello

**Beginner (30) — Verdetto:**
- ✅ AMMESSI (22): Wall Push-Ups, Knee Push-Ups, Incline Push-Ups, Floor Press, Inverted Rows, Bodyweight Squats, Lunges, Reverse Lunges, Step-Ups, Good Mornings, BW Romanian Deadlift, Glute Bridges, Single-Leg Glute Bridges, Plank, Side Plank, Bird Dog, Dead Bug, Superman, Prone Cobra, Pike Push-Ups, Sumo Squats, Scapular Retractions
- ❌ ESCLUSI (5): Fire Hydrants, Donkey Kicks, Bicycle Crunches (bassa efficacia per core anti-estensione), Russian Twists (flessione spinale sotto carico — rischio lombare)
- ⚠️ DA VALUTARE (3): Diamond Knee Push-Ups, Floor Tricep Dips (rischio spalla in estensione), Side Lunges

**Intermediate (30) — Verdetto:**
- ✅ AMMESSI PRIORITARI: Standard Push-Ups, Decline Push-Ups, Diamond Push-Ups, Archer Push-Ups, Parallel Bar Dips, Negative Pull-Ups, Full Pull-Ups, Elevated Inverted Rows, Bulgarian Split Squats, Cossack Squats, Nordic Hamstring Curls, L-Sit Holds, Hanging Leg Raises, Hollow Body Holds, Glute-Ham Raises
- ❌ ESCLUSI: Shrimp Squats (rischio ginocchio per intermedi), Jump Squats/Lunge Jumps (esplosivi premature per livello intermedio)
- ⚠️ ACCESSORY: Commando Pull-Ups, Towel Grip Rows, Dragon Flag Negatives, Windshield Wipers, V-Ups

**Advanced (30) — Verdetto:**
- ✅ AMMESSI: Muscle-Ups, Handstand Push-Ups, Pistol Squats, Front Lever Pull-Ups, Typewriter Pull-Ups, Weighted Dips, Dragon Flags, Back Lever Holds
- ⚠️ AMMESSI CON CAUTELA: Planche variants (stress polso), Human Flag (richiede preparazione specifica), Clap Push-Ups (esplosivi OK per advanced)
- ❌ ESCLUSI: Jump Pistol Squats (rischio ginocchio estremo), Dragon Pistol Squats (rischio/beneficio sfavorevole)

### 4.4 Esercizi MANCANTI dai materiali originali ma RICHIESTI dal protocollo

| Esercizio | Pattern | Perché manca | Perché è CRITICO |
|-----------|---------|-------------|------------------|
| Farmer Walk | Carry | Non negli Excel | PURE Study: grip strength predice mortalità |
| Suitcase Carry | Carry unilat. | Non negli Excel | Core anti-flessione laterale + grip |
| Deadlift | Hip-dominant | Non negli Excel | Fondamentale forza posterior chain |
| Trap Bar Deadlift | Hip-dominant | Non negli Excel | Variante più sicura del conventional |
| Pendlay Row | Pull orizz. | Non negli Excel | Compound back con alta forza di presa |
| Face Pull | Pull orizz. | Non negli Excel | Salute spalla, postura |
| Pallof Press | Core anti-rot. | Non negli Excel | Core anti-rotazione — pattern mancante |
| Ab Wheel Rollout | Core anti-ext. | Non negli Excel | Core anti-estensione avanzato |
| Turkish Get-Up | Full body | Non negli Excel | Mobilità + stabilità + forza integrata |
| Box Jump | Potenza | Non negli Excel | Potenza lower body (Power day) |

---

## 5. DB Target — Composizione Finale

### Distribuzione obiettivo per categoria

| Categoria | Compound | Accessory | Totale | Varianti equipment |
|-----------|----------|-----------|--------|---------------------|
| Push (orizz + vert) | 8-10 | 4-6 | 12-16 | ×3 (gym/home/bw) |
| Pull (orizz + vert) | 8-10 | 4-6 | 12-16 | ×3 |
| Squat | 6-8 | 3-4 | 9-12 | ×3 |
| Hinge | 6-8 | 3-4 | 9-12 | ×3 |
| Core | 4-6 | 4-6 | 8-12 | ×2-3 |
| Carry | 3-4 | — | 3-4 | ×2 (gym/bw) |
| Condizionamento | 4-6 | — | 4-6 | ×1-2 |
| **TOTALE** | | | **~60-80 unici** | **~150-200 con varianti** |

### Nota critica: Qualità > Quantità

Il numero 165 degli Excel è fuorviante — include molti isolamenti inutili per il protocollo. L'obiettivo reale è **60-80 esercizi unici ben selezionati**, ognuno con 2-3 varianti per equipment, per un totale di 150-200 entries nel DB.

Meglio 70 esercizi con giustificazione scientifica che 165 importati senza filtro.

---

## 6. Processo di Lavoro

### Step 0: Audit del DB attuale
- Ogni esercizio esistente (~80) passa i 5 criteri di ammissione?
- Quali vanno riclassificati (compound→accessory, o rimossi)?
- Quali hanno istruzioni insufficienti?

### Step 1: Selezione candidati
- Filtrare gli Excel con i criteri §3
- Aggiungere esercizi mancanti dal protocollo (§4.4)
- Cross-reference con Free Exercise DB per istruzioni e media

### Step 2: Validazione scientifica
Per ogni esercizio candidato:
1. **Quale pattern motorio copre?** (deve mappare a uno dei pattern §3.1)
2. **Evidenza di efficacia?** (almeno 1 studio o consenso biomeccanico)
3. **Rapporto rischio/beneficio?** (specialmente per >50 anni)
4. **Caricabilità progressiva?** (può essere reso più pesante nel tempo?)
5. **Compatibilità con tempo eccentrico 2-3s?**

### Step 3: Costruzione catene di progressione
Per ogni pattern motorio:
- Bodyweight: L1 (facilitato) → L10 (elite)
- Gym: L1 (macchina guidata) → L6 (bilanciere avanzato)
- Home: L1 (manubri leggeri) → L5 (manubri pesanti + elastici)

### Step 4: Scrittura seed data
- Istruzioni ricche per TUTTI (PERCHÉ, ERRORI, RESPIRAZIONE, VARIANTE)
- Cue di esecuzione dal protocollo §2.7 dove disponibili
- Fonte biomeccanica citata

### Step 5: Verifica finale
- Tutti i pattern motori coperti (nessun gap)
- Compound:Isolation ratio ≥ 70:30
- Ogni catena di progressione completa (no link rotti)
- Carry/grip training presente
- Rapporto set/settimana per muscolo ragionevole (4-8 per longevità, fino a 16-20 per advanced)

---

## 7. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/database/tables.dart` | Modify | Add sub_category, name_en, longevity_rationale, source columns |
| `core/database/database.dart` | Modify | Migration (add columns) |
| `core/database/seed/exercise_seed.dart` | Rewrite | ~150-200 entries validati scientificamente |
| `core/database/daos/exercise_dao.dart` | Modify | Queries by sub_category, pattern type, carry exercises |
| `core/models/workout_generator.dart` | Modify | Add carry exercises, improve compound/accessory selection |
| `features/progressions/progressions_screen.dart` | Modify | Add carry category, longer chains |
| `docs/exercise-validation-report.md` | Create | Report di validazione: ogni esercizio + verdetto + fonte |

---

## 8. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | All protocol patterns covered | DB scan | Every pattern has ≥3 exercises per equipment | High |
| UT-02 | Compound:Isolation ratio | DB scan | ≥70% compound+accessory | High |
| UT-03 | Progression chains complete | Each category×equipment | No broken links, L1 exists | High |
| UT-04 | Every exercise has instructions | All exercises | Non-empty, structured (PERCHÉ/ERRORI/RESPIRAZIONE) | High |
| UT-05 | Carry exercises present | DB scan | ≥3 carry exercises | High |
| UT-06 | No excluded exercises in DB | Exclusion list | Zero matches | Medium |
| UT-07 | Eccentric tempo ≥2s default | All exercises | defaultTempoEcc ≥ 2 | Medium |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Equipment change | gym→bodyweight | Every pattern still has exercises |
| EC-02 | Beginner with exclusions | 5 exercises excluded (injuries) | Still has compound for every pattern |

---

## 9. Output: Exercise Validation Report

Documento generato da questo processo (non codice):

```markdown
# Exercise Validation Report

## Esercizi AMMESSI (con giustificazione)
| # | Nome | Pattern | Tipo | Fonte | Evidenza | Note |
|---|------|---------|------|-------|----------|------|
| 1 | Barbell Deep Squat | Squat | Compound | Excel A + Protocol §2 | Full ROM superiore (Wolf 2023) | Fondamentale |

## Esercizi ESCLUSI (con motivazione)
| # | Nome | Fonte originale | Motivo esclusione |
|---|------|----------------|-------------------|
| 1 | Preacher Curl Machine | Excel A | Isolamento bicipiti non prioritario per longevità |

## Esercizi AGGIUNTI (non negli Excel, richiesti dal protocollo)
| # | Nome | Pattern | Perché aggiunto |
|---|------|---------|----------------|
| 1 | Farmer Walk | Carry | PURE Study: grip strength predice mortalità |

## Gap Analysis
| Pattern | Coverage | Note |
|---------|----------|------|
| Push orizz. | 12 esercizi ✅ | |
| Carry | 4 esercizi ✅ | Nuovo — non era negli Excel |
```

---

## 10. Rischi

| Rischio | Mitigazione |
|---------|-------------|
| Ridurre troppo (DB troppo piccolo per rotazione) | Minimo 60 unici — sufficiente per 3+ mesocicli senza ripetizione |
| Bias verso compound (trascurare accessory utili) | Mantenere 20-30% accessory per volume supplementare e rehab |
| Calisthenic advanced irrealistico | Validare che i requisiti pre-accesso siano chiari |
| Escludere esercizi che l'utente già conosce e ama | L'utente può proporre aggiunte — ma devono passare i criteri |

---

**Attesa PROCEED.**
