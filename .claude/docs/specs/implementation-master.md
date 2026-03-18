# Phoenix App — Master Implementation Plan

**Data:** 2026-03-12
**Stato:** in corso
**Obiettivo:** Portare l'app da scaffolding a prodotto completo e funzionante

---

## Stato attuale

L'app ha: navigazione 5 tab, DB schema (vuoto), timer digiuno/condizionamento, inserimento peso senza contesto, coach TTS con frasi random, design system (colori/font/spacing).

**Manca tutto il resto.** Nessun onboarding, nessun esercizio nel DB, nessun programma di allenamento, nessuna alimentazione, biomarker placeholder, nessun settings, nessun profilo utente.

---

## Fasi di implementazione

Ogni fase ha la sua spec dedicata. Le fasi sono sequenziali (ogni fase dipende dalla precedente).

### Fase 1: Onboarding + Profilo + Settings
**Spec:** `implementation-phase1-onboarding.md`
**Perché prima:** Senza dati utente (età, peso, sesso, tier, equipment) nulla può essere personalizzato.

- Flusso onboarding al primo avvio (5-6 step)
- Raccolta: sesso, età, altezza, peso, livello training, equipment disponibile, obiettivi
- Self-test opzionali (push-up max, squat max, plank hold)
- Classificazione tier automatica (Beginner/Intermediate/Advanced)
- Tabella `user_profile` nel DB (non solo settings_json)
- Schermata Settings (tema, lingua coach, toggle spiegazioni, toggle metronomo, modifica profilo)
- Salvataggio e caricamento profilo persistente

### Fase 2: Exercise DB + Training Flow
**Spec:** `implementation-phase2-training.md`
**Perché seconda:** Il cuore dell'app. Richiede profilo utente per personalizzare.

- Seed 50-80 esercizi dal Phoenix Protocol (5 categorie × 6 livelli progressione)
- 3 varianti per esercizio (gym/home/bodyweight) basate su equipment utente
- Istruzioni di esecuzione (cue) per ogni esercizio
- Immagini placeholder (icone per gruppo muscolare, poi sostituibili con GIF)
- **Training tab redesign:** non più sessione immediata, ma "Allenamento del giorno"
  - Preview: lista esercizi, serie, reps target, tempo stimato
  - Tasto "Inizia allenamento"
- **Workout session migliorata:**
  - Pre-exercise: immagine + spiegazione coach (toggle da settings) + countdown 5s
  - Tracking: reps, RPE, tempo eccentric/concentric
  - Rest timer adattivo (dal protocollo, per tier + tipo esercizio)
  - Metronomo collegato (se abilitato in settings)
  - Storico set inline (set precedenti nella stessa sessione)
  - Duration score collegato a dati reali (non mock)
- Generazione programma settimanale basato su tier + giorno della settimana
- Auto-progressione: suggerimento avanzamento quando criteri raggiunti

### Fase 3: Alimentazione / Nutrizione
**Spec:** `implementation-phase3-nutrition.md`
**Perché terza:** Pilastro mancante. Il fasting timer esiste ma manca il contesto nutrizionale.

- Nuovo screen/sezione Alimentazione (o integrazione nel tab esistente)
- TRE (Time-Restricted Eating) integrato col timer digiuno esistente
- Finestra alimentare personalizzata (8-10h basata su orario allenamento)
- Calcolo macro target (proteine 1.6-2.2 g/kg, basato su peso dal profilo)
- Distribuzione pasti nella finestra (minimo 3, con 0.4-0.55 g/kg proteine ciascuno)
- Diario pasti semplificato (non calorie counting ossessivo — log cosa mangiato + tolleranza)
- Idratazione durante digiuno (reminder acqua + elettroliti)
- Livelli digiuno (1/2/3) con criteri oggettivi di avanzamento
- Refeeding journal post-digiuno

### Fase 4: Biomarker Completi
**Spec:** `implementation-phase4-biomarkers.md`
**Perché quarta:** Richiede profilo (età per PhenoAge) e storico allenamenti/digiuno per alert.

- Form inserimento analisi sangue completo (panel base: 15+ valori)
- Form panel esteso (testosterone, cortisolo, TSH, vitamina D, hsCRP, HbA1c, CK, IGF-1)
- PhenoAge calculator funzionante (9 marker Levine 2018 → età biologica)
- Trend visualization: sparkline per ogni marker, timeframe toggle (W/M/6M/Y)
- Alert logic automatica:
  - Testosterone ↓20% → suggerisci ridurre finestra digiuno
  - Ferritina <30 → suggerisci supplementazione ferro
  - hsCRP elevato → audit volume/recupero
  - Linfociti sotto range → segnala immunodepressione
- Peso con contesto (trend, media mobile, delta da onboarding)
- HRV placeholder (pronto per integrazione wearable)
- Disclaimer medico visibile

### Fase 5: Condizionamento + Sonno Completi
**Spec:** `implementation-phase5-conditioning.md`
**Perché quinta:** I timer base funzionano. Serve completare con progressioni e sonno.

- Progressione freddo strutturata (30s → 1min → 2min → 3min, +30s/settimana)
- Tracking temperatura + durata con storico trend
- Meditazione con breathing cue reali (inhale 4s → hold 4s → exhale 4s)
- Sleep tracking: log manuale (ora addormentamento, risveglio, qualità soggettiva)
- Sleep score basato su regolarità + durata (7-8h target)
- Storico sessioni con grafici (non solo lista)
- Vincoli temporali: freddo NON entro 6h post-allenamento forza (alert se violato)
- Integrazione con dashboard (streak condizionamento)

### Fase 6: Coach AI + Dashboard
**Spec:** `implementation-phase6-coach-dashboard.md`
**Perché ultima:** Richiede tutti i dati delle fasi precedenti per generare insight utili.

- Dashboard ridisegnata con activity rings (3 anelli concentrici: training/fasting/conditioning)
- Card "One Big Thing" (prossima azione prioritaria)
- Quick action cards funzionanti (non navigazione vuota)
- Stats cards con dati reali (PhenoAge, ultimo HRV, peso, streak)
- Coach AI: prompt template per post-workout, weekly, monthly, fasting
- Generazione report strutturati (non chat libera inizialmente)
- Se LLM non disponibile: report template-based (senza AI, con dati reali)
- Notifiche background (milestone digiuno, reminder allenamento, motivazionali)

---

## Dipendenze tra fasi

```
Fase 1 (Onboarding) ──→ Fase 2 (Training) ──→ Fase 3 (Nutrition)
                    │                      │
                    └──→ Fase 4 (Biomarkers)
                    │
                    └──→ Fase 5 (Conditioning)
                                           │
                    Tutte ────────────────→ Fase 6 (Coach + Dashboard)
```

Fase 1 è prerequisito per tutte. Fasi 2-5 possono procedere in parallelo dopo Fase 1, ma l'ordine proposto (2→3→4→5) segue la priorità d'uso. Fase 6 è l'ultima perché aggrega tutto.

---

## File di riferimento

| Documento | Cosa contiene |
|-----------|---------------|
| `references/phoenix-protocol.md` | Protocollo completo v2.0+ (fonte di verità per OGNI parametro) |
| `specs/phoenix-app-architecture.md` | Stack tecnico, data model, LLM engine |
| `specs/phoenix-redesign.md` | Design system, layout per screen, animazioni |
| `specs/app-biomarker-features.md` | Dettagli OCR, PhenoAge, alert logic |
| `specs/research-sleep-longevity-autophagy.md` | Ricerca sonno e autofagia |

---

## Regole per l'implementazione

1. **Ogni fase produce codice funzionante** — l'app deve girare senza errori dopo ogni fase
2. **flutter analyze 0 errors** dopo ogni fase
3. **Usare design tokens** — mai colori/spacing hardcoded
4. **Dati dal protocollo** — ogni parametro (rest time, reps, macro) viene da `phoenix-protocol.md`
5. **DB-first** — i dati vanno nel DB, non hardcoded nei widget
6. **Spec prima, codice dopo** — leggere la spec di fase, poi implementare
