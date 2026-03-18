# Feature: In-App Scientific Paper — Il Protocollo Phoenix

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Sezione in-app che presenta il Protocollo Phoenix come paper scientifico, con citazioni DOI, diviso per pilastro, accessibile in qualsiasi momento.
**Why?** L'utente non sa cosa sia il Protocollo Phoenix. Senza capire la scienza dietro ciò che fa, manca fiducia, aderenza e motivazione. "Perché faccio cold exposure 5 volte a settimana?" — deve avere risposta nell'app.
**For whom?** Tutti gli utenti — specialmente chi vuole capire il "perché" dietro ogni componente del protocollo.
**Success metric:** L'utente può consultare la spiegazione scientifica di ogni elemento del protocollo direttamente nell'app, con fonti verificabili.

---

## 2. Contenuto — Struttura del Paper

### Fonte: `references/phoenix-protocol.md` v2.0

Il protocollo completo contiene 12 sezioni e 122+ citazioni trilingue (EN/ZH/RU). Il paper in-app sarà una versione leggibile e navigabile di questo documento.

### Struttura proposta:

```
1. INTRODUZIONE
   1.1 L'Obiettivo: Longevità Funzionale
   1.2 I Tre Pilastri
   1.3 Il Principio dell'Autofagia
   1.4 Come Funziona il Protocollo (overview)

2. PILASTRO 1: ALLENAMENTO
   2.1 Perché Allenarsi per la Longevità (non per l'estetica)
   2.2 La Struttura Settimanale (e perché questo split)
   2.3 Periodizzazione: perché i parametri cambiano
   2.4 Progressione: come il protocollo diventa più difficile
   2.5 Il Tempo sotto Tensione e la 3s Eccentrica
   2.6 Adattamenti per Età e Sesso

3. PILASTRO 2: CONDIZIONAMENTO
   3.1 Cold Exposure: la scienza del freddo
   3.2 Heat Exposure: sauna e proteine da shock termico
   3.3 Meditazione e Breathwork
   3.4 Sonno: il pilastro invisibile
   3.5 Flessibilità e Mobilità

4. PILASTRO 3: NUTRIZIONE
   4.1 Time-Restricted Eating e Autofagia
   4.2 Il Food Database: 4 Tier di Longevità
   4.3 Protein Cycling e Day Types
   4.4 Digiuno Prolungato: Livelli 2 e 3
   4.5 Cosa NON Funziona (avvertenze evidence-based)

5. MONITORAGGIO
   5.1 Biomarker: cosa tracciare e perché
   5.2 PhenoAge: la tua età biologica
   5.3 Segnali di Sovrallenamento
   5.4 HRV: il segnale del recupero

6. BIBLIOGRAFIA
   Tutte le 122+ citazioni con DOI linkabili
```

---

## 3. Technical Approach

### 3.1 Formato Contenuto

**Decisione:** Markdown pre-renderizzato come asset, non fetch da server.

**Perché:**
- Offline-first (coerente con la filosofia dell'app)
- Contenuto statico, cambia solo con release dell'app
- Nessuna dipendenza da backend

**Formato file:** Markdown con metadata YAML frontmatter

```
assets/protocol/
├── 01_introduzione.md
├── 02_allenamento.md
├── 03_condizionamento.md
├── 04_nutrizione.md
├── 05_monitoraggio.md
└── 06_bibliografia.md
```

### 3.2 Rendering

Usare `flutter_markdown` (già compatibile con il progetto) per renderizzare il contenuto markdown con:
- **Typography:** Usa PhoenixTypography per coerenza visiva
- **Citazioni:** `[1]` linkabili → scrollano alla bibliografia
- **DOI link:** Tappabili → apre nel browser
- **Immagini/diagrammi:** Asset locali dove necessario
- **Dark mode:** Automatico via theme

### 3.3 Navigation

**Accesso dalla schermata Coach:**
- Nuovo chip "Protocollo" tra i report chips
- Oppure: nuova voce in Settings → "Il Protocollo Phoenix"

**Accesso contestuale:**
- Da ogni card del protocollo (Training, Fasting, Cold, ecc.) → icona info → apre la sezione rilevante
- Es: da ColdCard → tap info → apre §3.1 Cold Exposure

**UI della schermata:**
- Tab bar per sezione (Intro / Allenamento / Condizionamento / Nutrizione / Monitoraggio)
- Scroll verticale per il contenuto
- Table of contents collassabile
- Bookmark/segnalibro per sezioni preferite
- Barra di ricerca per trovare argomenti

### 3.4 Citazioni

Formato in-text: `[Huberman 2021]` o `[1]`

Tapping su citazione → bottom sheet con:
- Autori, titolo, journal, anno
- DOI (tappabile → browser)
- 1-2 righe di abstract/relevanza per il protocollo

---

## 4. Processo di Scrittura

### Step 1: Estrazione da phoenix-protocol.md
- Prendere il contenuto scientifico dal protocollo v2.0
- Riscrivere in tono divulgativo (non accademico) ma rigoroso
- Mantenere TUTTE le citazioni DOI

### Step 2: Adattamento per Mobile
- Paragrafi brevi (max 3-4 righe)
- Un concetto per sezione
- Callout box per "IL PUNTO CHIAVE" di ogni sezione
- Infografiche semplici dove possibile (es. timeline giornaliera, progressione freddo)

### Step 3: Traduzione
- Contenuto primario in italiano
- Citazioni in lingua originale
- (Futuro: versione inglese)

### Step 4: Review
- Cross-check ogni citazione DOI
- Verificare che nessuna affermazione sia senza fonte
- Flaggare aree dove la ricerca è controversa o limitata

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `assets/protocol/01_introduzione.md` | Create | Capitolo 1 |
| `assets/protocol/02_allenamento.md` | Create | Capitolo 2 |
| `assets/protocol/03_condizionamento.md` | Create | Capitolo 3 |
| `assets/protocol/04_nutrizione.md` | Create | Capitolo 4 |
| `assets/protocol/05_monitoraggio.md` | Create | Capitolo 5 |
| `assets/protocol/06_bibliografia.md` | Create | 122+ citazioni |
| `features/protocol/protocol_screen.dart` | Create | Main screen with tab navigation |
| `features/protocol/protocol_section_view.dart` | Create | Markdown rendering per sezione |
| `features/protocol/citation_sheet.dart` | Create | Bottom sheet per citazione DOI |
| `features/coach/coach_screen.dart` | Modify | Add "Protocollo" chip |
| `features/today/widgets/*.dart` | Modify | Add info icon → contextual link |
| `pubspec.yaml` | Modify | Add flutter_markdown, assets/protocol/ |
| `app/router.dart` or navigation | Modify | Add protocol route |

---

## 6. Contenuto Chiave per Sezione (Estratto)

### §1 Introduzione — Hook
> Il Protocollo Phoenix non è una dieta né un programma di allenamento. È un sistema integrato di 3 pilastri — allenamento, condizionamento e nutrizione — progettato per ridurre l'età biologica attivando i meccanismi di riparazione cellulare del corpo.

### §3.1 Cold Exposure — Esempio di sezione
> **Cosa fai:** Doccia fredda o immersione 14-15°C, da 30 secondi (settimana 1) a 3 minuti (settimana 6+), 5 volte a settimana.
>
> **Perché funziona:** L'esposizione al freddo attiva la norepinefrina (+200-300%), aumenta il tessuto adiposo bruno, e — quando la dose settimanale raggiunge 11 minuti — produce i benefici metabolici documentati da Søberg et al. [1].
>
> **La regola delle 6 ore:** Mai cold exposure entro 6 ore da un allenamento di forza. Il freddo attenua la risposta infiammatoria necessaria per l'adattamento muscolare [2].
>
> [1] Søberg S et al. (2021). Cell Reports Medicine. DOI: 10.1016/j.xcrm.2021.100434
> [2] Malta ES et al. (2021). Int J Sports Physiol Perform. DOI: 10.1123/ijspp.2020-0127

---

## 7. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Markdown parsing | Valid .md file | Rendered without errors | High |
| UT-02 | Citation tap | Tap [1] | Citation sheet opens with correct DOI | High |
| UT-03 | DOI link | Tap DOI | url_launcher opens browser | Medium |
| UT-04 | Dark mode rendering | Dark theme | Correct colors, readable text | Medium |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Coach → Protocollo | Tap chip → screen | Correct section loads | High |
| IT-02 | ColdCard → §3.1 | Tap info → protocol | Opens at Cold Exposure section | High |
| IT-03 | Search | Type "autofagia" | Relevant sections shown | Medium |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Missing asset file | .md file deleted | Graceful error message |
| EC-02 | Very long section | §2 Allenamento | Smooth scroll, no jank |
| EC-03 | No internet for DOI | Airplane mode | DOI tap shows "offline" message |

---

## 8. Rischi

| Rischio | Mitigazione |
|---------|-------------|
| Contenuto troppo lungo per mobile | Sezioni brevi, callout, TOC navigabile |
| Citazioni DOI rotte | Verificare tutti i DOI prima del release |
| Tono troppo accademico | Riscrivere in tono divulgativo, test con utente non-scientifico |
| flutter_markdown limitazioni | Fallback a widget custom per formattazione complessa |

---

**Attesa PROCEED.**
