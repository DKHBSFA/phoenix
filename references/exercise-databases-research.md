# Ricerca: Database Esercizi Open Source

**Data:** 2026-03-12
**Scopo:** Identificare il miglior database open source di esercizi con immagini/animazioni per l'app Phoenix.

---

## Candidati analizzati

### 1. free-exercise-db

| Campo | Dettaglio |
|-------|-----------|
| **Repository** | https://github.com/yuhonas/free-exercise-db |
| **Licenza** | Public Domain |
| **Esercizi** | 800+ |
| **Formato dati** | JSON |
| **Asset visivi** | Immagini statiche (no GIF animate) |
| **Struttura dati** | Nome, categoria, muscoli primari/secondari, istruzioni, immagini |
| **Dipendenze esterne** | Nessuna — dati locali |
| **Frontend incluso** | Vue.js (browsable, searchable) |

**Pro:**
- Public domain = zero vincoli legali, uso commerciale e modifiche libere
- JSON locale = funziona offline, nessuna API key, nessun rate limit
- Struttura dati pulita e facile da integrare

**Contro:**
- Solo immagini statiche, nessuna GIF animata
- 800 esercizi: molti, ma non tutti con immagini di alta qualità

---

### 2. wger Workout Manager

| Campo | Dettaglio |
|-------|-----------|
| **Repository** | https://github.com/wger-project/wger |
| **Licenza** | AGPL v3 |
| **Esercizi** | Database contributivo (wiki-style) |
| **Formato dati** | REST API (OpenAPI documented) |
| **Asset visivi** | Immagini SVG (da Wikipedia/Everkinetic) |
| **Funzionalità extra** | Tracking nutrizione, pesi, workout planning |
| **Hosting** | Self-hosted (Django/Python) |
| **Docs** | https://wger.readthedocs.io/ |

**Pro:**
- Piattaforma completa: esercizi, nutrizione, tracking — overlap significativo con Phoenix
- Self-hosted = controllo totale, estendibile
- REST API completa con documentazione OpenAPI
- Immagini SVG scalabili

**Contro:**
- AGPL v3 = copyleft forte, codice derivato deve restare open source
- Libreria immagini limitata (community chiede espansione — issue #2196)
- Overhead di deployment: Django, PostgreSQL, Celery

---

### 3. ExerciseDB API

| Campo | Dettaglio |
|-------|-----------|
| **Repository** | https://github.com/ExerciseDB/exercisedb-api |
| **Licenza** | Ambigua sugli asset visivi |
| **Esercizi** | 1300+ (claim 11000+ nella v2 a pagamento) |
| **Formato dati** | REST API |
| **Asset visivi** | GIF animate per ogni esercizio + target muscoli |
| **Struttura dati** | Nome, target, equipment, bodyPart, GIF, istruzioni |
| **Dipendenze esterne** | API esterna (rate limit nella versione free) |

**Pro:**
- Il più ricco visivamente: GIF animate per ogni esercizio
- Dati ben strutturati con target muscolare specifico

**Contro:**
- Licenza degli asset GIF non chiaramente public domain — rischio legale
- Dipendenza da API esterna con rate limit
- v2 a pagamento: il modello potrebbe cambiare

---

### 4. Open Training Exercises

| Campo | Dettaglio |
|-------|-----------|
| **Repository** | https://github.com/chaosbastler/opentraining-exercises |
| **Licenza** | CC BY-SA 3.0 (Everkinetic) |
| **Formato dati** | XML + immagini |
| **Asset visivi** | Illustrazioni anatomiche (Everkinetic) |

**Pro:**
- Illustrazioni anatomiche di qualità con muscoli evidenziati
- CC BY-SA 3.0 = utilizzabile con attribuzione

**Contro:**
- Set limitato di esercizi
- Formato XML meno pratico del JSON
- Progetto poco attivo

---

## Raccomandazione per Phoenix

**Base dati: free-exercise-db** + curazione specifica per il protocollo.

### Motivazione

1. **Licenza:** Public domain elimina ogni rischio legale. AGPL (wger) forzerebbe l'open source su tutto il codice derivato. ExerciseDB ha licenza ambigua sugli asset.

2. **Architettura:** Phoenix usa un set specifico di ~50-80 esercizi (progressioni calistheniche push/pull/squat/hinge/core dalla sezione 2.7 del protocollo). Non servono 11.000 esercizi — servono quelli giusti, fatti bene.

3. **Offline-first:** JSON locale significa che l'app funziona senza connessione. Nessuna dipendenza da API esterne che possono cambiare pricing o sparire.

4. **Asset visivi:** Per le GIF animate degli esercizi specifici del protocollo, opzioni complementari:
   - Illustrazioni Everkinetic (CC BY-SA 3.0) per anatomia muscolare
   - Generazione propria per le progressioni bodyweight specifiche di Phoenix
   - Eventuale integrazione futura con asset da ExerciseDB se la licenza viene chiarita

### Struttura dati target

```json
{
  "id": "push-lvl3-diamond-pushup",
  "name": "Diamond Push-up",
  "category": "push",
  "phoenix_level": 3,
  "progression_next": "push-lvl4-pseudo-planche",
  "progression_prev": "push-lvl2-pushup",
  "advancement_criteria": "3×12 per 2 sessioni consecutive",
  "muscles_primary": ["triceps", "chest"],
  "muscles_secondary": ["anterior_deltoid", "core"],
  "equipment": "none",
  "instructions": ["...", "..."],
  "images": ["diamond-pushup-01.png", "diamond-pushup-02.png"],
  "animation": "diamond-pushup.gif",
  "source": "free-exercise-db + Overcoming Gravity"
}
```

---

## Fonti

- [free-exercise-db (GitHub)](https://github.com/yuhonas/free-exercise-db)
- [free-exercise-db (Frontend)](https://yuhonas.github.io/free-exercise-db/)
- [wger Workout Manager (GitHub)](https://github.com/wger-project/wger)
- [wger REST API docs](https://wger.readthedocs.io/)
- [ExerciseDB API (GitHub)](https://github.com/ExerciseDB/exercisedb-api)
- [ExerciseDB API docs](https://www.exercisedb.dev/docs)
- [Open Training Exercises (GitHub)](https://github.com/chaosbastler/opentraining-exercises)
