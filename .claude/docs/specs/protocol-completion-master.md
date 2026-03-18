# Master Plan: Protocol Completion

**Status:** DRAFT
**Created:** 2026-03-14
**Updated:** 2026-03-14 (aggiunto Fasi H-N dopo ricerca aggiuntiva sui gap rimanenti — copertura target: ~98%)
**Context:** Audit del 2026-03-14 ha rivelato che l'app implementa ~60% del Protocollo Phoenix. I gap più critici riguardano il pilastro Training (periodizzazione, rotazione, media, cardio, mobilità) e la comunicazione del protocollo all'utente. Confronto con Blueprint Johnson ha evidenziato gap critici su HIIT, warmup e stability. Ricerca aggiuntiva sui gap rimanenti ha permesso di creare spec complete per HRV, fasting avanzato, adattamenti sesso/età, supplementazione, sonno, macro tracking e Week 0.

---

## Il Problema

L'app Phoenix ha solide fondamenta (cold exposure, PhenoAge, meal plan, biomarker alerts) ma il cuore del pilastro Training è incompleto:

1. **Nessun media** — l'utente non vede immagini né video dell'esercizio
2. **DB esercizi non validato** — 80 esercizi senza filtro scientifico vs obiettivi del protocollo
3. **Nessuna periodizzazione** — stessi parametri ogni settimana, ogni mese
4. **Nessuna rotazione** — stessi esercizi per sempre, il muscolo si adatta
5. **Nessun cardio strutturato** — HIIT e Zone 2 prescritti dal protocollo ma giorni cardio vuoti
6. **Nessun warmup/mobility/stretching** — il protocollo prescrive 5-10min pre/post, l'app parte diretta
7. **Protocollo invisibile** — l'utente non sa cosa sia il Phoenix Protocol né la scienza dietro
8. **Nessun HRV tracking** — il predittore #1 di recovery non è tracciato
9. **Fasting L3 assente** — il livello più potente per autofagia non è implementato
10. **Nessun adattamento sesso/età** — tutti ricevono lo stesso programma
11. **Nessuna supplementazione** — biomarker tracciati ma senza raccomandazioni
12. **Sleep passivo** — solo tracking, nessuna guida ambientale
13. **Solo proteine** — carb cycling e fibre prescritti dal protocollo ma non tracciati
14. **Nessuna familiarizzazione** — utenti nuovi partono diretti con carichi pesanti

---

## Piano di Lavoro — 14 Fasi

### Fase A — Media Esercizi
**Spec:** `specs/phase-a-exercise-media.md`
**Cosa:** Integrare immagini/GIF da database open source (Free Exercise DB + ExerciseDB)
**Impatto:** L'utente vede finalmente come eseguire ogni esercizio
**Dipendenze:** Nessuna — può partire subito

### Fase B — Validazione Scientifica e Arricchimento DB Esercizi
**Spec:** `specs/phase-b-exercise-enrichment.md`
**Cosa:** Validare ogni esercizio contro i criteri del protocollo (5 filtri scientifici), scartare isolamenti inutili, aggiungere esercizi mancanti (carries, kettlebell, Turkish get-up). Target: 60-80 esercizi unici validati × 2-3 equipment = 150-200 entries.
**Impatto:** DB basato sulla scienza, non sul bodybuilding
**Dipendenze:** Idealmente dopo Fase A (nuovi esercizi con media)

### Fase C — Sistema di Periodizzazione
**Spec:** `specs/phase-c-periodization.md`
**Cosa:** Implementare i 3 modelli del protocollo + % carico 1RM + deload automatico:
- **Beginner:** Progressione lineare (4×10→12→15, +2.5kg)
- **Intermediate:** DUP — Daily Undulating Periodization (Forza/Ipertrofia/Resistenza)
- **Advanced:** Block periodization (Accumulo→Trasformazione→Realizzazione→Deload)
**Impatto:** Il cuore mancante del protocollo. Senza questo, l'app è un tracker statico.
**Dipendenze:** Fase B (serve il DB validato)

### Fase D — Rotazione Mesociclica Esercizi
**Spec:** `specs/phase-d-exercise-rotation.md`
**Cosa:** Sistema di rotazione che cambia gli esercizi ogni mesociclo (≥70% nuovi), con pool per slot, lock/exclude utente
**Impatto:** L'utente ha un programma che evolve nel tempo
**Dipendenze:** Fase B + Fase C (serve DB ampio + logica mesocicli)

### Fase E — Paper Scientifico In-App
**Spec:** `specs/phase-e-scientific-paper.md`
**Cosa:** Sezione in-app che spiega il Protocollo Phoenix come paper scientifico: 6 capitoli, 122+ citazioni DOI, link contestuali da ogni card protocollo
**Impatto:** L'utente capisce cosa fa e perché — fiducia e aderenza
**Dipendenze:** Nessuna — può partire in parallelo con qualsiasi fase

### Fase F — Cardio Strutturato (HIIT + Zone 2 + HR Zones)
**Spec:** `specs/phase-f-structured-cardio.md`
**Cosa:** Trasformare i giorni "Active Recovery" in sessioni cardio guidate:
- **Mercoledì:** Tabata HIIT (20s/20s × 8 round) + Zone 2
- **Sabato:** Norwegian 4×4 (4min@85-95% / 3min@60-70% × 4 round) + Zone 2
- HR zone calculator (220-age), timer guidato, audio cues, VO2max tracking
**Impatto:** VO2max è il predittore #1 di mortalità (Mandsager 2018)
**Dipendenze:** Nessuna per la struttura base. Integrazione con Fase C per variare intensità per fase del mesociclo.

### Fase G — Warmup, Mobility, Stability & Stretching
**Spec:** `specs/phase-g-warmup-mobility.md`
**Cosa:** Aggiungere a ogni sessione:
- **Pre:** Dynamic warmup 5-10min specifico per giorno
- **Intra:** Stability work 5-10min per tier
- **Post:** Cool-down 5-10min con stretching statico o PNF
- Adattamento per età (>50: warmup più lungo, PNF raccomandato)
**Impatto:** Prevenzione infortuni, flessibilità, propriocezione
**Dipendenze:** Fase A (media per i movimenti)

### Fase H — HRV Tracking & Recovery Intelligence
**Spec:** `specs/phase-h-hrv-tracking.md`
**Cosa:** Integrare tracking HRV da wearable (Apple Watch/Garmin/Oura) o input manuale:
- LnRMSSD come metrica primaria (Plews et al. 2013)
- Baseline 14 giorni, 7-day rolling average
- Soglia SWC (0.5 × SD) per decisioni auto-training
- Volume auto-ridotto quando HRV basso (0.8× low, 0.5× very low)
- Deload forzato se 3+ giorni in calo
**Impatto:** Recovery-aware training — l'app adatta l'intensità allo stato reale dell'atleta
**Dipendenze:** Flutter `health` package. Si integra con Fase C (deload trigger).

### Fase I — Advanced Fasting (Level 3 + FMD)
**Spec:** `specs/phase-i-advanced-fasting.md`
**Cosa:** Completare il sistema digiuno con:
- **Extended Fast 72-120h**: Safety checks ogni 6-12h, soglia glicemia <54 mg/dL = stop
- **FMD 5 giorni** (Longo): Giorno 1 ~1100kcal, Giorni 2-5 ~800kcal, macro specifiche
- Refeeding protocol strutturato (24-48h: brodo → verdure cotte → normale)
- Gate medico obbligatorio, prerequisito L2 completato
**Impatto:** Autofagia massima — il pilastro più potente del protocollo per ringiovanimento cellulare
**Dipendenze:** L2 fasting system (esistente). Medical disclaimer system (esistente).

### Fase J — Adaptive Profiles (Sex + Age Adaptations)
**Spec:** `specs/phase-j-adaptive-profiles.md`
**Cosa:** Adattamenti evidence-based per sesso e decade:
- **Sesso**: Ciclo mestruale opt-in (McNulty 2020: effetto triviale — suggerimenti, non imposizioni), post-menopausa ≥70% 1RM per densità ossea (Kemmler 2020), concurrent training OK per donne (Huiberts 2024)
- **Età**: Volume/recupero/rep range per decade (Fragala 2019 NSCA), warmup crescente, sarcopenia prevention
- AgeParams: multiplier volume, recovery hours, warmup minutes per decade
**Impatto:** Ogni utente riceve un programma adattato alla sua fisiologia
**Dipendenze:** Si integra con Fase C (volume multiplier) e Fase G (warmup duration).

### Fase K — Conditional Supplementation
**Spec:** `specs/phase-k-conditional-supplements.md`
**Cosa:** Raccomandazioni integratori biomarker-triggered:
- Vitamina D3+K2 (25(OH)D <30), Omega-3 (Index <8%), Creatina (tutti >40), Magnesio (Mg <1.8), Ferro alternate-day (ferritina <30, Stoffel 2020), Collagene 15g pre-training (Shaw 2017)
- Anti-raccomandazione Resveratrolo (Gliemann 2013: annulla benefici esercizio)
- Prioritizzazione high/medium/low, exit criteria
**Impatto:** Supplementazione mirata — zero sprechi, massima efficacia
**Dipendenze:** Biomarker system (esistente). Indipendente dal training.

### Fase L — Sleep Environment Optimization
**Spec:** `specs/phase-l-sleep-optimization.md`
**Cosa:** Da tracking passivo a coaching proattivo:
- Reminder temperatura 18-19°C (Okamoto-Mizuno 2012)
- Blue light cutoff: notifica bedtime-2h (Chang 2015)
- Caffeine cutoff: notifica bedtime-10h (Drake 2013)
- Evening coaching con tips personalizzati su trend qualità
**Impatto:** Sonno è il pilastro #1 di recovery — ora l'app guida attivamente
**Dipendenze:** SleepTab (esistente). NotificationScheduler (esistente).

### Fase M — Complete Macro Tracking
**Spec:** `specs/phase-m-macro-tracking.md`
**Cosa:** Da sole proteine a macro completi con carb cycling:
- Carb cycling: 4-5g/kg training, 3-4g/kg rest, 2-3g/kg autophagy (Impey 2018)
- Target grassi: 25-37% kcal per tipo giorno
- Fibre: 30-40g/giorno (Reynolds 2019, Lancet)
- Meal templates arricchiti con tutti i macro
- NutritionCard con 4 barre progresso
**Impatto:** Nutrizione completa — non solo proteine ma tutti i macro per longevità
**Dipendenze:** Meal template system (esistente). NutritionCalculator (esistente).

### Fase N — Week 0 Familiarization
**Spec:** `specs/phase-n-week0-familiarization.md`
**Cosa:** 6 sessioni di familiarizzazione per utenti nuovi o di ritorno:
- 6 pattern motori (squat, hinge, push, pull, core, carry)
- 2 set × 10-12 reps, RPE 4-6, focus tecnica
- Trigger: nuovo utente, >2 settimane inattività, cambio tier
- Fitts & Posner motor learning model (cognitivo→associativo)
**Impatto:** Riduzione rischio infortunio, aderenza a lungo termine, base motoria solida
**Dipendenze:** Onboarding (esistente). WorkoutGenerator (esistente). Fase A (media).

---

## Ordine di Esecuzione

```
WAVE 1 — Indipendenti (partono in parallelo)
├── Fase A (Media Esercizi)
├── Fase E (Paper Scientifico)
├── Fase F (Cardio HIIT)
├── Fase G (Warmup/Mobility)
├── Fase K (Supplementazione)
├── Fase L (Sleep Optimization)
└── Fase M (Macro Tracking)

WAVE 2 — Dipendono da Wave 1
├── Fase B (Enrichment) ← dopo Fase A
├── Fase H (HRV) ← indipendente ma si integra con C
├── Fase I (Fasting L3) ← indipendente
├── Fase J (Adaptive Profiles) ← si integra con C e G
└── Fase N (Week 0) ← dopo Fase A

WAVE 3 — Dipendono da Wave 2
├── Fase C (Periodizzazione) ← dopo Fase B
└   integra H (HRV deload) + J (age multiplier)

WAVE 4 — Dipendono da Wave 3
└── Fase D (Rotazione) ← dopo Fase C
```

### Parallelismo massimo:
- **Wave 1**: 7 fasi in parallelo (A, E, F, G, K, L, M)
- **Wave 2**: 4 fasi in parallelo (B, H, I, J, N)
- **Wave 3**: 1 fase (C con integrazioni)
- **Wave 4**: 1 fase (D)

---

## Metriche di Successo

| Metrica | Prima | Dopo |
|---------|-------|------|
| Esercizi con media | 0/80 (0%) | 100% |
| Esercizi validati scientificamente | 0/80 (0%) | 100% (60-80 unici × 2-3 equipment) |
| Modelli di periodizzazione | 0/3 | 3/3 (Lineare/DUP/Block) |
| Rotazione esercizi | Mai | Ogni mesociclo (≥70% nuovi) |
| Sessioni HIIT strutturate | 0/settimana | 2/settimana (Tabata + Norwegian) |
| Zone 2 cardio guidato | 0 min/settimana | 40-60 min/settimana |
| Warmup pre-workout | Mai | Ogni sessione (5-10min) |
| Stability work | Mai | Ogni sessione forza (5-10min) |
| Cool-down/stretching | Mai | Ogni sessione (5-10min PNF o statico) |
| HRV tracking | Assente | Daily, recovery-aware training |
| Fasting Level 3 | Assente | Extended + FMD con safety checks |
| Adattamenti per sesso | Nessuno | Ciclo opt-in, menopausa, concurrent training |
| Adattamenti per età | Nessuno | Decade-by-decade (volume/recovery/warmup) |
| Supplementazione | Assente | Biomarker-triggered, 6+ integratori evidence-based |
| Sleep optimization | Tracking passivo | Coaching proattivo con reminder ambiente |
| Macro tracking | Solo proteine | Carb cycling + grassi + fibre con target per giorno |
| Week 0 familiarizzazione | Assente | 6 sessioni per nuovi utenti |
| Documentazione protocollo in-app | Assente | Completa con 122+ citazioni |
| **Copertura protocollo** | **~60%** | **~98%** |

---

## Gap Residui (~2%)

| Gap | Sezione | Note |
|-----|---------|------|
| HRV da wearable specifici (Oura API, WHOOP API) | §5.4 | Dipende da partnership/API key. Flutter `health` copre la maggior parte |
| Fasting Level 3 supervisione medica in-app | §4.1 | Richiede integrazione con sistemi sanitari — fuori scope app |
| Tracking automatico macronutrienti (barcode scanner) | §4.2 | Scartato intenzionalmente: adherence <50% dopo 2 settimane |

Questi gap sono irriducibili senza integrazioni esterne o cambio di paradigma.

---

**Attesa PROCEED per iniziare l'implementazione.**
