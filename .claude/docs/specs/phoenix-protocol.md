# Spec: Protocollo Phoenix

## Cosa sto costruendo?

Il **Protocollo Phoenix** — un documento strutturato che definisce il sistema completo di allenamento, condizionamento e alimentazione. Questo documento diventa il "motore" dell'app: ogni algoritmo, ogni progressione, ogni adattamento parte da qui.

**Vincoli non negoziabili (dall'utente):**
- 7 giorni su 7 di attività (nessun giorno di riposo completo)
- Obiettivo: TUTTO (forza, ipertrofia, flessibilità, condizionamento, nutrizione, longevità)
- Equipment-agnostic: palestra, home gym, corpo libero
- Adattivo: algoritmi science-based che parametrizzano il protocollo in base all'utente

---

## Struttura del documento

### 1. ASSESSMENT INIZIALE
Sistema di valutazione per parametrizzare il protocollo.

**Input utente:**
- Età, sesso, peso, altezza
- Livello di allenamento (mai / <6 mesi / 6-24 mesi / >2 anni)
- Attrezzatura disponibile (palestra completa / home gym / corpo libero)
- Limitazioni fisiche / patologie
- Obiettivo primario (ranking: forza, ipertrofia, flessibilità, perdita grasso, longevità)

**Test fisici (autogestiti):**
- Push-up max reps (stima forza relativa upper body)
- Bodyweight squat max reps (stima forza relativa lower body)
- Plank hold max tempo (core endurance)
- Sit-and-reach o toe touch (flessibilità)
- Resting heart rate (condizionamento cardiovascolare)

**Output:** Classificazione in tier (Beginner / Intermediate / Advanced) per ciascun pilastro, che parametrizza carichi, volume, e progressione.

### 2. ALLENAMENTO (Pilastro 1)

**Struttura settimanale — 7 giorni:**

| Giorno | Focus | Tipo |
|--------|-------|------|
| 1 | Upper Body — Push | Resistenza |
| 2 | Lower Body — Quad dominant | Resistenza |
| 3 | Condizionamento + Flessibilità | Cardio + Mobilità |
| 4 | Upper Body — Pull | Resistenza |
| 5 | Lower Body — Hip dominant | Resistenza |
| 6 | Condizionamento + Flessibilità | Cardio + Mobilità |
| 7 | Full Body — Potenza/Skill | Metodo dinamico o pliometria |

**Nota:** I giorni 3, 6, 7 NON sono "riposo". Sono allenamento attivo con focus diverso. Questo rispetta il vincolo 7/7 senza compromettere il recupero muscolare (ogni gruppo ha 48-72h tra sessioni di resistenza).

**Parametri per tier (da ricerca trilingue):**

| Parametro | Beginner | Intermediate | Advanced |
|-----------|----------|--------------|----------|
| Carico | 40-60% 1RM | 60-80% 1RM | 70-95% 1RM |
| Reps/set | 10-15 | 6-12 | 1-8 (periodizzato) |
| Set/esercizio | 3 | 3-4 | 4-5 |
| Set/muscolo/sett | 10-12 | 12-16 | 16-20+ |
| Esercizi/sessione | 4-5 | 5-6 | 5-7 |
| Autoregolazione | RPE soggettivo | RPE/RIR | VBT (se disponibile) |
| Periodizzazione | Lineare (carico fisso, reps crescenti poi reset) | DUP (varia carico intra-settimana) | Block (accumulo→trasformazione→realizzazione) |

**Fonti:** Samsonova 2012 (40% per principianti), Sabadyr 2021, Currier 2023, Sokolova 2016, Pelland 2025, Moesgaard 2022, Verkhoshansky, survey cinese Zhong 2023.

**Progressione:**
- Beginner: sovraccarico lineare (+2.5-5% carico quando reps target raggiunte per tutte le serie)
- Intermediate: DUP con 3 zone (forza 3-5 reps, ipertrofia 8-12, resistenza 15-20) ruotate nella settimana
- Advanced: mesocicli a blocchi di 3-4 settimane (Verkhoshansky) con deload programmato

**Adattamento per attrezzatura:**

Ogni esercizio ha 3 varianti:
- **Gym:** versione con bilanciere/macchine (es. Barbell Back Squat)
- **Home:** versione con manubri/kettlebell/bande (es. Goblet Squat)
- **Bodyweight:** versione calistenica (es. Bulgarian Split Squat a corpo libero)

La selezione è automatica in base all'attrezzatura dichiarata.

### 3. CONDIZIONAMENTO (Pilastro 2)

**3a. Esposizione al freddo**

| Parametro | Valore | Progressione | Fonte |
|-----------|--------|-------------|-------|
| Temperatura | 14-15°C | Stabile | Buijze 2016, Søberg 2021 |
| Durata iniziale | 30 sec | +30 sec/settimana | Adattamento graduale |
| Durata target | 2-3 min | Mantenere | Buijze 2016 |
| Frequenza | 5x/settimana | — | Al-Horani 2024 |
| Timing | Mattino, MAI entro 6h post-resistenza | — | Roberts 2015, Piñero 2024 |
| Principio Søberg | Terminare su freddo (no riscaldamento attivo) | — | Søberg 2021 |
| Dose settimanale | ~11 min totali | — | Søberg (sintesi) |

**Controindicazioni:** cardiopatie, ipertensione non controllata, gravidanza (Shattock & Tipton 2012, Lundström 2025).

**3b. Flessibilità**

| Metodo | Frequenza | Parametri | Fonte |
|--------|-----------|-----------|-------|
| PNF | 3-5x/sett (giorni 3,6 + post-allenamento) | 3-5 cicli contract-relax per gruppo | Meta-analisi trilingue |
| Eccentrico combinato | Integrato nella resistenza | Tempo lento in eccentrica (3-4 sec) | Arntz 2022, Garmayev 2017 |
| Mobilità dinamica | Pre-allenamento quotidiana | 5-10 min warmup | Best practice |

**3c. Cardio / Energia**

| Tier | Giorni 3,6 | Giorno 7 |
|------|-----------|----------|
| Beginner | 20-30 min zona 2 (camminata veloce, bike, nuoto) | Circuito a corpo libero leggero |
| Intermediate | 25-35 min zona 2 + 5 min HIIT finale | Pliometria base (box jumps, med ball) |
| Advanced | 20 min zona 2 + 10-15 min HIIT o interval | Shock method (depth jumps, 5-10 reps, 3-4 min recupero) |

**Fonti:** Fonarev 2020, Nitsalov 2017, Galochkin 2018 (shock method), classificazione russa metodi dinamici.

### 4. PROTOCOLLO ALIMENTARE (Pilastro 3)

**Time-Restricted Eating (TRE):**

| Parametro | Raccomandazione | Adattamento | Fonte |
|-----------|----------------|-------------|-------|
| Finestra digiuno | 14-16h | Iniziare con 12h, +1h/settimana | Wewege 2024 |
| Finestra alimentare | 8-10h | Centrata su allenamento | Dai 2025 |
| Primo pasto | Post-allenamento (entro 2h) | Adattabile | Vieira 2025 |
| Proteine per pasto | 0.4-0.55 g/kg | Min 3 pasti nella finestra | Letteratura consolidata |
| Proteine giornaliere | 1.6-2.2 g/kg | Tier-dependent | Meta-analisi multiple |

**Avvertenze science-based:**
- TRE può ridurre testosterone sierico (Shkorfu 2025) — monitorare
- Dati CV a lungo termine insufficienti (Kibret 2025 vs Zhong 2024)
- AMPK da digiuno nel muscolo umano NON confermato (Storoschuk 2024)
- L'esercizio a digiuno aumenta ossidazione grassi acuta ma NON necessariamente perdita grasso nel tempo (Aird 2018)

**Idratazione:**
- Acqua + elettroliti (sodio, potassio, magnesio) al risveglio e post-allenamento
- Caffè nero (0 kcal) permesso durante il digiuno

### 5. MONITORAGGIO E SUPERCOMPENSAZIONE

**Segnali di sovrallenamento (scala Bichev 2020, 3 stadi):**

| Stadio | Segnali | Azione |
|--------|---------|--------|
| 1. Stagnazione | Plateau performance, sonno leggermente disturbato | Ridurre volume 20% per 1 settimana |
| 2. Instabilità | Umore instabile, appetito irregolare, prestazioni calanti | Deload completo (50% volume e intensità) per 1-2 settimane |
| 3. Calo drastico | Insonnia, immunodepressione, calo marcato prestazioni | Stop allenamento intenso, solo mobilità e camminate per 2-4 settimane |

**Recupero (fonti cinesi):**
- Sonno: 8-9h adulti, 10h <25 anni (国家体育总局)
- Giorni 3, 6: recupero attivo (cardio + flessibilità, non riposo passivo)

### 6. BIOMARKER TRACKING (Pilastro 4)

Sistema opzionale di monitoraggio ematico per feedback oggettivo sul protocollo.

**Pannello Base (SSN italiano — consigliato 2x/anno):**

Marker già inclusi in un emocromo + chimica clinica standard:

| Marker | Unità | Rilevanza Phoenix |
|--------|-------|-------------------|
| Glucosio | mg/dL | Effetto TRE su metabolismo glucidico |
| Creatinina | mg/dL | Funzione renale sotto carico 7/7 |
| AST, ALT, GGT | U/L | Stress epatico (sovrallenamento, integratori) |
| Proteine totali | g/dL | Stato nutrizionale, adeguatezza apporto proteico |
| Trigliceridi | mg/dL | Effetto TRE + freddo su metabolismo lipidico (Peres 2024) |
| Colesterolo totale/HDL/non-HDL | mg/dL | Rischio CV — controversia TRE (Zhong 2024 vs Kibret 2025) |
| Ferritina | µg/L | Anemia da sport — critico con allenamento 7/7 |
| Emocromo completo | vari | GB, GR, Hb, Ht, MCV, MCH, MCHC, RDW, piastrine |
| Formula leucocitaria | 10e9/L | Neutrofili, linfociti, monociti — immunodepressione = stadio 3 sovrallenamento (Bichev 2020) |

**Pannello Esteso (richiesta aggiuntiva — consigliato 2-4x/anno se TRE attivo):**

| Marker | Unità | Rilevanza Phoenix | Fonte |
|--------|-------|-------------------|-------|
| Testosterone totale/libero | ng/dL | TRE può ridurlo | Shkorfu 2025 |
| Cortisolo | µg/dL | Sovrallenamento stadio 2-3 | Bichev 2020 |
| TSH / T3 / T4 | mUI/L | Freddo cronico stimola tiroide; digiuno può sopprimerla | Søberg 2021 |
| Vitamina D (25-OH) | ng/mL | Correlata a forza muscolare e recupero | Letteratura consolidata |
| hsCRP | mg/L | Infiammazione sistemica — verifica protocollo non pro-infiammatorio | — |
| HbA1c | % | Sensibilità insulinica (obiettivo longevità) | — |
| CK (creatina chinasi) | U/L | Danno muscolare — oggettivizza sovrallenamento | — |
| IGF-1 | ng/mL | Asse somatotropo — digiuno modifica GH/IGF-1 | Pilis 2025 |

**NON misurabile (solo ricerca):**
- Autofagia (richiede assay PBMC con cloroquina — Bensalem 2025)
- AMPK/mTOR (biopsie muscolari)
- Attività BAT (PET-CT)

**Logiche di interpretazione per il protocollo:**

| Trend rilevato | Azione protocollo |
|----------------|-------------------|
| Testosterone calato >20% in 3 mesi | Ridurre finestra digiuno (da 16h a 14h o 12h) |
| Ferritina <30 µg/L | Integrazione ferro + revisione volume allenamento |
| Cortisolo elevato + prestazioni calanti | Trigger deload (stadio 2 sovrallenamento) |
| Linfociti sotto range | Segnale immunodepressione → stadio 3, stop intensità |
| hsCRP elevato persistente | Verificare volume, frequenza, recupero |
| TSH/T3 alterati | Rivalutare frequenza esposizione al freddo |
| Vitamina D <30 ng/mL | Integrazione + esposizione solare |

> **Implementazione app:** vedi `.claude/docs/specs/app-biomarker-features.md`

### 7. ALGORITMO DI ADATTAMENTO

> **Nota:** questa sezione descrive la logica del protocollo. L'implementazione software è materia della fase di sviluppo app.

L'algoritmo usa assessment + feedback continuo + biomarker per:

1. **Classificare** l'utente in tier per ogni pilastro
2. **Selezionare** esercizi in base ad attrezzatura
3. **Parametrizzare** carico, volume, reps secondo tier
4. **Progressare** (sovraccarico quando target raggiunto)
5. **Regredire** in caso di segnali di sovrallenamento (soggettivi O da biomarker)
6. **Adattare TRE** in base a trend ormonali (testosterone, cortisolo, tiroide)
7. **Segnalare** carenze nutrizionali (ferritina, vitamina D, proteine totali)
8. **Ri-testare** ogni 4-6 settimane (assessment fisico) + sincronizzare con cadenza biomarker

---

## File che toccherò

- `references/phoenix-protocol.md` — Il protocollo completo (NUOVO)
- `.claude/docs/request-log.md` — Entry #5
- `.claude/docs/registry.md` — Aggiornamento con il nuovo documento

## Cosa posso riusare

- Tutto il materiale in `references/` (protocol-1-verified, training-analysis-verified, training-research-trilingual)
- I parametri xlsx esistenti come template per la struttura degli esercizi
- `esecuzione-esercizi.md` per i principi di esecuzione (dove verificati)

## Come verifico che funziona

- Ogni parametro ha una fonte verificata (DOI o CyberLeninka/CNKI URL)
- La struttura 7/7 rispetta il recupero muscolare (48-72h tra sessioni dello stesso gruppo)
- I 3 tier producono programmi distinti e progressivi
- Le 3 modalità attrezzatura coprono tutti gli esercizi
- Le controindicazioni e avvertenze sono chiaramente indicate
