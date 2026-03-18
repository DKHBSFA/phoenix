# Protocollo Nutrizionale Phoenix — Verificato

**Data:** 2026-03-13
**Metodo:** Ricerca trilingue (EN/ZH/RU), ~45 ricerche, 80+ fonti con DOI
**Scopo:** Sostituire il piano alimentare bodybuilding del DIETARY REGIME.xlsx con un protocollo basato su evidenze per ringiovanimento cellulare via autofagia

---

## DISCLAIMER

**Questo documento è basato su letteratura scientifica a scopo esclusivamente educativo e informativo. NON costituisce consiglio medico, prescrizione dietetica o raccomandazione terapeutica. Qualsiasi protocollo alimentare, di integrazione o di digiuno deve essere validato da un medico o professionista sanitario abilitato, in base alla situazione clinica individuale. L'autore e l'applicazione Phoenix declinano ogni responsabilità per l'uso improprio delle informazioni contenute in questo documento.**

---

## 1. IL PROBLEMA FONDAMENTALE

Il piano alimentare attuale è stato scritto con mentalità **bodybuilding**:
- 7 pasti/giorno dalle 07:00 alle 22:00 (finestra 15h — incompatibile con TRE)
- ~2950 kcal per 96kg (surplus calorico per ipertrofia)
- 1.6-2.2 g/kg proteine (massimizza mTOR → sopprime autofagia)
- Focus su "muscle volume", "shredding", "lean mass"
- Integratori scelti per bodybuilding (termogenici, collagene, acido ialuronico)

**L'obiettivo di Phoenix è ringiovanimento cellulare**, non ipertrofia. L'ipertrofia è un effetto collaterale positivo del protocollo, ma non l'obiettivo.

---

## 2. MECCANISMO CHIAVE: IL CICLO mTOR/AUTOFAGIA

### Come funziona

mTOR e autofagia sono **mutuamente esclusivi** in qualsiasi momento:

```
STATO FED (leucina + insulina alta):
  mTORC1 attivo → fosforila ULK1 a Ser757 → BLOCCA autofagia
  → Sintesi proteica attiva → Riparazione muscolare

STATO FASTED (12-16h senza nutrienti):
  mTORC1 inattivo → AMPK fosforila ULK1 a Ser317/777 → ATTIVA autofagia
  → Pulizia cellulare → Riciclo mitocondri danneggiati
```

**Consenso trilingue:** Il cycling tra questi due stati è superiore alla soppressione cronica di mTOR o alla sua attivazione cronica.

**Fonti:**
- Singh et al., 2025, JCI Insight — DOI: 10.1172/jci.insight.188845
- MCE Chinese review — medchemexpress.cn
- CyberLeninka Russian review — cyberleninka.ru
- Jamshed et al., 2019, Nutrients — DOI: 10.3390/nu11061234

### Il cycling opera su 3 scale temporali

| Scala | Meccanismo | Evidenza |
|-------|-----------|---------|
| **Giornaliero** (TRE) | 14-16h digiuno → autofagia basale. 8-10h alimentazione → mTOR per riparazione | Bensalem 2025 (n=121, RCT): iTRE aumenta significativamente flusso autofagico vs controlli (p=0.04) |
| **Settimanale** (protein cycling) | Giorni basso-proteici → autofagia profonda. Giorni training → mTOR pieno | Chen 2025: digiuno moderato intermittente aumenta massa muscolare E autofagia nei topi |
| **Trimestrale** (FMD) | 5 giorni very-low-protein → autofagia sistemica + mobilizzazione staminali | Longo 2024 (Nature Comm): 3 cicli FMD → -2.5 anni età biologica |

---

## 3. PRINCIPIO FONDAMENTALE: DOSAGGI PARAMETRICI

**Nessun dosaggio nel protocollo Phoenix è fisso.** Ogni valore (macro, integratori, calorie, timing) è una funzione di:

1. **Peso corporeo** — base per calcolo proteine, calorie, e diversi integratori
2. **Valori del sangue** — ferritina, vitamina D (25-OH), B12, omocisteina, NAD+ (se disponibile), IGF-1, hs-CRP determinano quali integratori servono e a quale dose
3. **Stadio Phoenix** — il livello dell'utente nel protocollo determina l'intensità del cycling:
   - **Livello 1 (Fondazione):** TRE 12h, protein cycling leggero (training/normal), no autophagy day dedicato
   - **Livello 2 (Adattamento):** TRE 14-16h, protein cycling completo (training/normal/autophagy), primo ciclo FMD
   - **Livello 3 (Avanzato):** TRE 16h, autophagy day settimanale, FMD trimestrale, senolitici intermittenti
4. **Percorso nell'app** — quante settimane/mesi l'utente è attivo, compliance storica, trend biomarker

### Logica di personalizzazione nell'app

```
Input: peso_kg, sesso, età, livello_phoenix, valori_sangue (opzionali), settimane_attive
Output: piano_giornaliero { pasti, macro_target, integratori, tipo_giorno }

// Proteine
proteine_training = peso_kg * fattore_tier(livello)  // L1: 1.4, L2: 1.3, L3: 1.2
proteine_normal = peso_kg * 0.8-1.0
proteine_autophagy = peso_kg * 0.4-0.5  // solo L2+

// Calorie (stimate, non contate dall'utente)
calorie_base = peso_kg * 28-32  // aggiustato per livello attività
calorie_autophagy_day = peso_kg * 18-20

// Integratori condizionali
if (ferritina > 150 ng/mL) → NO ferro (mai)
if (25-OH-D < 30 ng/mL) → D3 5000 IU, altrimenti 2000 IU
if (omocisteina > 12 μmol/L) → B complex + folato prioritario
if (hs-CRP > 1.0 mg/L) → curcumina + omega-3 dose alta (2g)
if (livello >= 2 && settimane >= 12) → introduci NMN
if (livello >= 3 && settimane >= 24) → introduci fisetina intermittente
```

L'utente NON deve fare calcoli. L'app presenta il piano del giorno già personalizzato. I valori del sangue sono opzionali ma migliorano la personalizzazione.

---

## 4. PROTEINE: IL NUOVO RANGE

### Cosa dice la letteratura

| Fonte | Lingua | Range proteico | Contesto |
|-------|--------|---------------|----------|
| Levine et al. 2014, Cell Metabolism | EN | <10% calorie da proteine (50-65: ↑75% mortalità con >20%) | 6,381 adulti NHANES III |
| Longo FMD 2024 | EN | 0.4-0.5 g/kg nei giorni FMD | RCT, -2.5 anni età biologica |
| Tian Lu / Westlake 2025, Cell | ZH | 8% vs 20% calorie: restrizione inverte 237 proteine aging-related | 41 tessuti murini, proteomica |
| Biomolecula review | RU | <10% calorie: IGF-1 basso, mortalità ridotta | Review nutrigerontologia |
| US Guidelines 2025-2030 | EN/RU | 1.2-1.6 g/kg | Salute generale, NON longevità |
| Wilkinson 2023 | EN | 25-30g/pasto (soglia leucina per MPS) | Systematic review |
| Chen 2025 | EN/ZH | Restrizione moderata (70%) > severa (30%) | Topi, massa muscolare |

### Il conflitto proteine-longevità

**Prima dei 65 anni:** Proteine elevate (>20% calorie) = +75% mortalità, 4× rischio cancro. Effetto abolito per proteine vegetali. (Levine 2014)

**Dopo i 65 anni:** Proteine elevate diventano PROTETTIVE (↓ mortalità, ↓ cancro). Il bilancio si sposta verso la prevenzione della sarcopenia. (Levine 2014)

**Insight critico (Chen 2025):** Dopo una fase di digiuno, la fase di rialimentazione diventa PIÙ anabolica grazie al priming AMPK → maggiore efficienza metabolica e nutrient partitioning.

### Range raccomandato per Phoenix

**Abbandono del range fisso 1.6-2.2 g/kg. Sostituzione con protein cycling:**

| Tipo di giorno | Proteine | g per 80kg | Scopo | Frequenza |
|---------------|----------|-----------|-------|-----------|
| **Training day** | 1.2-1.6 g/kg | 96-128g | mTOR attivo, sintesi proteica, riparazione | 3-4×/settimana |
| **Normal day** | 0.8-1.0 g/kg | 64-80g | Intake moderato, autofagia parziale | 2-3×/settimana |
| **Autophagy day** | 0.4-0.5 g/kg | 32-40g | Autofagia profonda, pulizia cellulare | 1×/settimana |
| **FMD (trimestrale)** | ~0.3 g/kg, 750-1100 kcal/giorno | ~25g | Autofagia sistemica, rigenerazione staminali | 5 giorni, 4×/anno |

**Nota età:** Dopo i 65 anni, spostare il bilancio: training 1.4-1.6 g/kg, normal 1.2 g/kg, autophagy day 1×/mese.

**Preferenza fonte:** Proteine vegetali nei giorni non-training (minor stimolazione mTOR per g, minor metionina). Proteine animali concentrate nei giorni training.

---

## 5. TRE: STRUTTURA DELLA FINESTRA ALIMENTARE

### Evidenze

| Studio | Risultato chiave |
|--------|-----------------|
| Bensalem 2025 (RCT, n=121) | iTRE aumenta flusso autofagico vs controlli (p=0.04). Restrizione calorica sola NON raggiunge significatività |
| Jamshed 2019 | Early TRE (8-14): geni autofagia (LC3A, SIRT1) ↑ mattina, mTOR ↑ sera → ciclo circadiano naturale |
| Zhejiang University 2025 | Curva U: finestre troppo corte (<6h) o troppo lunghe (>12h) aumentano rischio cardiovascolare e cancro |
| Drosophila study (via TRE research) | Il digiuno notturno (= alimentazione precoce) è necessario e sufficiente per i benefici di longevità via autofagia circadiana |

### Finestra raccomandata

**8-10 ore, timing precoce (es. 09:00-17:00 o 08:00-18:00)**

- L'early TRE supera il late TRE su grasso corporeo, età metabolica e glicemia a digiuno (RCT 2025)
- Allenamento a digiuno la mattina per massima autofagia; primo pasto come recupero
- Ultimo pasto almeno 3h prima di dormire

### Struttura pasti (3 pasti nella finestra)

| Pasto | Ora (esempio) | Composizione | Proteine | Calorie |
|-------|-------------|-------------|----------|---------|
| **Pasto 1** (post-training) | 09:00 | Refeeding gentile: verdure cotte, olio EVO, cereali integrali, noci/semi, legumi | 20-25g | ~650 |
| **Pasto 2** (principale) | 13:00 | Pasto più grande: pesce o legumi, verdure abbondanti, carboidrati complessi | 25-30g | ~900 |
| **Pasto 3** (leggero) | 16:30 | Più leggero: verdure, legumi/uova moderati, grassi sani | 20-25g | ~650 |

**Calorie totali:** ~2100-2400 kcal (vs 2950 attuali). TRE riduce naturalmente l'intake del 15-20%. CALERIE trial: anche 12% CR riduce 9 biomarker di senescenza cellulare.

---

## 6. FOOD DATABASE: VERIFICA E CORREZIONI

### Claim verificati del xlsx

| # | Claim | Verdetto | Evidenza |
|---|-------|---------|---------|
| 1 | "Pistacchi: alto litio per umore/cervello" | ⚠️ **Parziale** | Litio presente ma a dosi 100-1000× sotto livelli terapeutici |
| 2 | "Pomodoro: fonte litio" | ⚠️ **Parziale** | Stesso problema di dose |
| 3 | "Barbabietola per FGF21" | ❌ **Non supportato** | FGF21 è primariamente un ormone da digiuno, non indotto da betaina alimentare |
| 4 | "Avena: amido resistente per butirrato" | ⚠️ **Meccanismo errato** | L'avena funziona via beta-glucani, non amido resistente |
| 5 | "Banana verde: amido resistente e butirrato" | ✅ **Confermato** | Amido resistente tipo 2, ben documentato |
| 6 | "Mirtilli: aumento BDNF e plasticità sinaptica" | ⚠️ **Parziale** | Evidenza in modelli animali e piccoli trial umani, ma effetti modesti |
| 7 | "Tè verde: catechine per FGF21" | ❌ **Meccanismo errato** | EGCG agisce via inibizione mTOR, non FGF21 |
| 8 | "Prezzemolo: apigenina per neurogenesi ippocampale" | ⚠️ **Parziale** | Apigenina presente ma a dosi insufficienti dal solo prezzemolo |
| 9 | "Cioccolato 99%: flavanoli per FGF21" | ❌ **Non supportato** | Nessuna evidenza di induzione FGF21. I flavanoli hanno altri benefici |
| 10 | "Spinaci: acido alfa-lipoico per stress ossidativo" | ⚠️ **Parziale** | ALA presente ma a dosi 100× sotto livelli terapeutici |
| 11 | "Broccoli: sulforafano per infiammazione" | ✅ **Confermato** | Ben documentato. Germogli di broccoli 10-100× più potenti |
| 12 | "Riso/patata raffreddata: amido resistente per butirrato" | ✅ **Confermato** | Amido resistente tipo 3, ben documentato |

**Problemi principali nel food DB:**
1. I claim FGF21 sono largamente inventati (3 alimenti attribuiti FGF21 senza evidenza)
2. Conflazione di dose: composto presente ma a concentrazioni terapeuticamente irrilevanti
3. Gli alimenti ricchi di spermidina sono sottorappresentati

### Gerarchia alimenti per ringiovanimento cellulare

**Tier 1 — Ringiovanimento multi-meccanismo (consumo quotidiano):**

| Alimento | Meccanismi | Composti chiave |
|----------|-----------|-----------------|
| Germogli di broccoli | Autofagia, NAD+, senolitico, telomeri, mitocondri, staminali (6/6) | Sulforafano, NMN, quercetina |
| Tè verde | Autofagia, senolitico, telomeri, mitocondri, staminali (5/6) | EGCG |
| Fragole | Senolitico, telomeri, mitocondri, staminali (4/6) | Fisetina, ellagitannine |
| Melagrana | Mitocondri, staminali, autofagia, telomeri (4/6) | Precursori urolitina A |
| Noci | Mitocondri, telomeri, senolitico, staminali (4/6) | Ellagitannine, omega-3 ALA |
| Salmone/sgombro | NAD+, telomeri, mitocondri, staminali (4/6) | Omega-3 DHA/EPA, niacina |

**Tier 2 — Forte meccanismo singolo (3-5×/settimana):**

| Alimento | Meccanismo principale | Composto |
|----------|---------------------|----------|
| Germe di grano | Autofagia (fonte #1 spermidina: 24-35 mg/100g) | Spermidina |
| Mirtilli | Telomeri, staminali, mitocondri, senolitico | Antociani |
| Spinaci/cavolo riccio | Telomeri, NAD+, senolitico | Folato, quercetina |
| Cipolla rossa | Senolitico | Quercetina, fisetina |
| Edamame/soia | Autofagia, NAD+ | Spermidina, NMN, genisteina |
| Funghi shiitake | Autofagia, NAD+ | Spermidina, niacina, ergotioneina |

**Tier 3 — Supporto longevità (consumo regolare):**

| Alimento | Perché |
|----------|--------|
| Capperi | Fonte #1 quercetina (234-365 mg/100g) |
| Olio EVO | Attivazione AMPK, polifenoli |
| Avocado | Fonte NMN |
| Cioccolato fondente 99% | Flavanoli (NON per FGF21) |
| Mandorle | Ellagitannine (precursore urolitina A) |
| Lamponi | Ellagitannine, fisetina |
| Lenticchie/ceci | Spermidina (quantità moderate) |
| Asparagi | Spermidina |
| Semi di lino | Omega-3 ALA, telomeri |

**Tier 4 — Neutri (servono i macro ma nessun vantaggio longevità specifico):**

| Alimento | Nota |
|----------|------|
| Petto di pollo | Proteine lean, nessun composto longevità unico |
| Coscia di pollo | Come sopra |
| Tacchino | Come sopra |
| Filetto di maiale | Bassa rilevanza longevità; niacina inferiore al pesce |
| Manzo magro | Contiene carnosina/creatina (neuroprotettivi), ma carne rossa associata a ↑mortalità. Meglio sostituito con pesce |
| Riso integrale | Fonte energia, nessun composto longevità specifico |
| Patata dolce/yam | Beta-carotene utile ma non driver longevità |
| Banana | Poco NR, primariamente energia |
| Noci pecan | Polifenoli ma inferiori alle noci comuni (no ellagitannine) |

### Alimenti MANCANTI nel DB (da aggiungere)

| Alimento | Perché | Priorità |
|----------|--------|----------|
| **Germe di grano** | Fonte #1 spermidina al mondo (24-35 mg/100g) — l'alimento pro-autofagia più importante | CRITICA |
| **Melagrana** | Fonte primaria precursori urolitina A per mitofagia | CRITICA |
| **Noci** | Ellagitannine (urolitina A) + omega-3 ALA + protezione telomeri | ALTA |
| **Capperi** | Fonte #1 quercetina (senolitico) | ALTA |
| **Cipolla rossa** | Quercetina + fisetina (senolitico) | ALTA |
| **Funghi shiitake** | Spermidina + ergotioneina + niacina | ALTA |
| **Edamame** | Spermidina (20.7 mg/100g) + NMN + genisteina | ALTA |
| **Semi di lino** | Omega-3 ALA per protezione telomeri | MODERATA |
| **Cachi** | Fonte fisetina (10.5 μg/g) | MODERATA |
| **Formaggio stagionato** | Spermidina (~20 mg/100g), ma latticini dibattuti per longevità | MODERATA |

---

## 7. INTEGRATORI: VERIFICA E REVISIONE

### I 15 integratori originali

| # | Integratore | Longevità? | Verdetto | Note |
|---|------------|-----------|---------|------|
| 1 | Omega-3 (1000mg EPA/DHA) | **Sì** | ✅ MANTENERE | DO-HEALTH trial: rallenta aging epigenetico 3-4 mesi. Core supplement |
| 2 | Curcumina + BioPerine (500mg) | **Sì** | ✅ MANTENERE | Top anti-infiammatorio, attiva autofagia (Frontiers Pharmacology 2025) |
| 3 | Vitamina D3 (5000 IU) | **Sì** | ✅ MANTENERE | Sicuro long-term (studio 7 anni), abbinare sempre a K2 |
| 4 | Vitamina C (500mg) | **Parziale** | ✅ MANTENERE (bassa priorità) | Supporto generale, non driver longevità. Ottenibile dalla dieta |
| 5 | **Thermopure** | **No — DANNOSO** | ❌ RIMUOVERE | Zero evidenza longevità. Rischi cardiovascolari e epatotossicità documentati. Meta-analisi: nessun vantaggio vs dieta+esercizio |
| 6 | **Ferro + Acido folico** | **No — DANNOSO** | ❌ RIMUOVERE ferro | Studi Mendelian randomization (UK Biobank, 1M+): ferro alto ↓ durata vita. Ferro supplementare accelera aging fenotipico (PMC 2025). Mantenere folato solo se necessario |
| 7 | Vitamina K (100mcg) | **Sì** | ⚠️ MODIFICARE | Aumentare a 180-200mcg MK-7 (non K1). RCT 3 anni: MK-7 migliora salute cardiovascolare. Sinergia essenziale con D3 |
| 8 | CoQ10 (30mg) | **Sì** | ⚠️ MODIFICARE | Dose troppo bassa. Aumentare a 100-200mg ubiquinolo. JACC: ↓43% eventi cardiovascolari, ↓42% mortalità |
| 9 | Vitamina B complex | **Parziale** | ✅ MANTENERE | Gestione omocisteina, prevenzione carenza. Non driver primario |
| 10 | **Collagene** | **No** | ❌ RIMUOVERE | Systematic review 2025 (Am J Med): ZERO evidenza indipendente. Studi positivi tutti industry-funded |
| 11 | Magnesio | **Sì** | ⚠️ MODIFICARE | Specificare forma (glicinato o treonato) e dose (300-400mg). Review 2024: correlato a TUTTI gli hallmark of aging |
| 12 | Glucosamina + Condroitina | **Parziale** | ✅ MANTENERE (secondario) | Sorprendente: -27% mortalità totale, -58% mortalità cardiovascolare (NHANES). Evidenza osservazionale |
| 13 | **Cocco + Collagene + Vit C** | **No** | ❌ RIMUOVERE | Prodotto cosmetico. Ridondante con vit C separata. Nessuna base longevità |
| 14 | **Acido ialuronico** | **No** | ❌ RIMUOVERE | Meta-analisi 2025: ZERO benefici significativi anche per la pelle |
| 15 | Clorella | **Parziale** | ✅ MANTENERE (bassa priorità) | Estende lifespan 10-18% in C. elegans (2024). Evidenza umana debole |

### Integratori da AGGIUNGERE

| Integratore | Evidenza | Dose | Priorità |
|------------|---------|------|----------|
| **NMN** | Forte (RCT umani multipli). NAD+ ↑44%. Migliora velocità cammino, qualità sonno, sensibilità insulinica | 250-500mg/giorno, mattina a stomaco vuoto | **ALTA** |
| **Spermidina** (o germe di grano) | Moderata-forte. Studio 20 anni: -60% mortalità nel quintile più alto. Attiva autofagia | 1-6mg/giorno (o 10-20g germe di grano) | **ALTA** |
| **Fisetina** | Moderata (preclinica + trial umani in corso). Senolitico | 100-500mg, 2-3 giorni/mese (protocollo intermittente) | CONSIDERARE |
| **PQQ** | Moderata. Biogenesi mitocondriale, sinergico con CoQ10 e NMN | 10-20mg/giorno | CONSIDERARE |
| **Acido alfa-lipoico** | Moderata. Antiossidante duale (idro e liposolubile), supporto mitocondriale | 300-600mg/giorno | CONSIDERARE |

**NON aggiungere:** Resveratrolo (fallito in trial umani, biodisponibilità pessima, meccanismo smentito da studi CRISPR. GlaxoSmithKline ha investito >$1B e abbandonato).

### Stack longevità Phoenix proposto

**Tier 1 — Core (evidenza umana forte):**

| Integratore | Dose | Timing |
|------------|------|--------|
| Omega-3 EPA/DHA | 1000-2000mg | Con pasto grasso |
| Vitamina D3 | 5000 IU | Mattina, con grassi |
| Vitamina K2 MK-7 | 180-200mcg | Con D3 |
| CoQ10 ubiquinolo | 100-200mg | Con pasto grasso |
| Magnesio glicinato/treonato | 300-400mg | Sera |
| NMN | 250-500mg | Mattina, stomaco vuoto |
| Curcumina + BioPerine | 500mg | Con pasto |

**Tier 2 — Supporto (evidenza moderata):**

| Integratore | Dose | Timing |
|------------|------|--------|
| Vitamina B complex | Standard | Mattina |
| Spermidina (germe di grano) | 1-6mg | Mattina |
| Vitamina C | 500mg | Qualsiasi |
| Clorella | Standard | Mattina |
| Glucosamina + Condroitina | Standard | Con pasto |

**Tier 3 — Opzionale/Intermittente:**

| Integratore | Dose | Protocollo |
|------------|------|-----------|
| Fisetina | 100-500mg | 2-3 giorni/mese (senolitico) |
| Acido alfa-lipoico | 300-600mg | Quotidiano |
| PQQ | 10-20mg | Quotidiano, con CoQ10 |

---

## 8. PIANO PASTI SETTIMANALE TIPO (Training Day)

**Peso esempio: 80kg | Finestra: 09:00-17:00 | Proteine training day: ~115g**

### Pasto 1 — 09:00 (post-allenamento, refeeding)

| Ingrediente | Grammi | Proteine | Motivo longevità |
|------------|--------|----------|-----------------|
| Uova intere | 2 (120g) | 15g | Colina, niacina |
| Germe di grano | 15g | 4g | **Spermidina** (3.5-5mg) |
| Avena integrale | 50g | 8g | Beta-glucani |
| Mirtilli | 100g | 1g | Antociani, telomeri |
| Noci | 20g | 3g | Ellagitannine (urolitina A) |
| Tè verde | 200ml | 0g | EGCG (inibizione mTOR) |

**Totale:** ~31g P, ~550 kcal

### Pasto 2 — 13:00 (principale)

| Ingrediente | Grammi | Proteine | Motivo longevità |
|------------|--------|----------|-----------------|
| Salmone | 150g | 30g | Omega-3, niacina, telomeri |
| Riso integrale raffreddato | 150g (cotto) | 4g | Amido resistente tipo 3 |
| Broccoli | 200g | 6g | Sulforafano, NMN |
| Olio EVO | 10g | 0g | AMPK, polifenoli |
| Cipolla rossa | 50g | 1g | Quercetina (senolitico) |
| Spinaci crudi (insalata) | 80g | 2g | Folato, quercetina |

**Totale:** ~43g P, ~750 kcal

### Pasto 3 — 16:30 (leggero)

| Ingrediente | Grammi | Proteine | Motivo longevità |
|------------|--------|----------|-----------------|
| Lenticchie | 150g (cotte) | 14g | Spermidina, folati |
| Edamame | 80g | 9g | Spermidina, NMN |
| Asparagi | 150g | 3g | Spermidina |
| Avocado | 50g | 1g | NMN |
| Semi di lino | 10g | 2g | Omega-3 ALA, telomeri |
| Melagrana (semi) | 80g | 1g | Urolitina A |
| Cioccolato fondente 99% | 10g | 1g | Flavanoli |

**Totale:** ~31g P, ~600 kcal

**Totale giornaliero training day:** ~105g P (1.3 g/kg), ~1900 kcal

### Giorno low-protein (autophagy day, 1×/settimana)

- Stessa finestra TRE
- Solo verdure, cereali integrali, frutta, grassi sani
- Niente carne, pesce, uova, latticini
- ~35g proteine (da legumi e cereali)
- ~1500 kcal
- Focus su alimenti Tier 1 pro-autofagia

---

## 9. CONFRONTO VECCHIO vs NUOVO

| Aspetto | DIETARY REGIME (vecchio) | Protocollo Phoenix (nuovo) |
|---------|------------------------|---------------------------|
| Obiettivo | Ipertrofia, body composition | Ringiovanimento cellulare |
| Pasti/giorno | 7 (07:00-22:00) | 3 (09:00-17:00) |
| Finestra alimentare | ~15h | 8h (TRE) |
| Calorie | ~2950 | ~1900-2400 |
| Dosaggi | Fissi (96kg hardcoded) | **Parametrici** (peso, sangue, livello Phoenix, percorso) |
| Proteine | 1.6-2.2 g/kg fisso | 0.4-1.6 g/kg cycling |
| Fonte proteica | Primariamente animale | Mista, vegetale nei giorni rest |
| Alimenti focus | Pollo, riso, proteine lean | Germe di grano, pesce, verdure crucifere, frutti di bosco |
| FGF21 claims | 3 alimenti attribuiti (falso) | Rimossi |
| Integratori | 15 (5 inutili/dannosi) | 7-12 (basati su evidenza) |
| Ferro supplementare | Sì (14mg) | **No** (accelera aging) |
| Termogenici | Sì | **No** (rischi senza benefici) |
| NMN | Assente | **Aggiunto** (core) |
| Spermidina | Assente | **Aggiunto** (core) |
| Protein cycling | Assente | Sì (3 tipi di giorno) |
| FMD trimestrale | Assente | Sì (protocollo Longo) |

---

## 10. FONTI PRINCIPALI (per meccanismo)

### Proteine / mTOR / Autofagia
- Singh et al., 2025. JCI Insight. DOI: 10.1172/jci.insight.188845
- Levine et al., 2014. Cell Metabolism. DOI: 10.1016/j.cmet.2014.02.006
- Longo et al., 2024. Nature Communications. DOI: 10.1038/s41467-024-45260-9
- Tian Lu et al., 2025. Cell 188(25). DOI: 10.1016/j.cell.2025.10.004
- Chen et al., 2025. Nutrition & Metabolism. DOI: 10.1186/s12986-025-01001-3
- Bensalem et al., 2025. J Physiology. DOI: 10.1113/JP287938
- Jamshed et al., 2019. Nutrients. DOI: 10.3390/nu11061234
- Biomolecula.ru — Nutrigerontologia review
- CyberLeninka — mTOR signaling review

### Alimenti pro-autofagia
- Eisenberg et al., 2016. Nature Medicine. DOI: 10.1038/nm.4222
- Hofer et al., 2022. Nature Aging. DOI: 10.1038/s43587-022-00322-9
- Fernandez-Sanz et al., 2024. Nature Cell Biology. DOI: 10.1038/s41556-024-01468-x
- Pang et al., 2025. bioRxiv. DOI: 10.1101/2025.05.11.653363
- Ryu et al., 2016. Nature Medicine. DOI: 10.1038/nm.4132
- Andreux et al., 2019. Nature Metabolism. DOI: 10.1038/s42255-019-0073-4

### Integratori
- DO-HEALTH trial. PubMed: 39900648
- JACC Heart Failure — CoQ10 landmark
- Iron overload aging: PMC 12246624, PMC 8544343
- Thermogenics meta-analysis: PubMed 33427571
- Collagen review: PubMed 40324552
- Vitamin K2 MK-7 RCT: PMC 8483258
- Magnesium hallmarks of aging: MDPI 2024
- NMN trials: renuebyscience.com/human-trials
- Spermidine 20-year study: Nature Medicine 2016

---

*Questo documento sostituisce la sezione nutrizionale del DIETARY REGIME.xlsx come fonte di verità per il piano alimentare Phoenix.*
