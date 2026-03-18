# Feature: Exercise Media from Open Source Databases

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Integrare immagini e GIF animate per ogni esercizio nel DB, utilizzando database open source (Free Exercise DB + ExerciseDB).
**Why?** L'utente attualmente vede solo un placeholder colorato. Senza media visuale, non può capire come eseguire correttamente l'esercizio — il che rende inutili le istruzioni testuali.
**For whom?** Tutti gli utenti, specialmente principianti che non conoscono i movimenti.
**Success metric:** 100% degli esercizi ha almeno 1 immagine; 80%+ ha GIF animata dell'esecuzione.

---

## 2. Fonti Dati

### Free Exercise DB (Primaria)
- **Repo:** `github.com/yuhonas/free-exercise-db`
- **Esercizi:** 800+
- **Media:** JPG (2 immagini per esercizio: posizione iniziale + finale)
- **Licenza:** Public Domain — zero restrizioni
- **Formato dati:** JSON con campi: id, name, force, level, mechanic, equipment, primaryMuscles, secondaryMuscles, instructions, category, images[]
- **Accesso immagini:** CDN GitHub raw + ImageKit.io per resize dinamico

### ExerciseDB (Secondaria — per GIF)
- **API:** `exercisedb.io`
- **Esercizi:** 1,300+
- **Media:** GIF animate dell'esecuzione completa
- **Licenza:** AGPL v3 (API usage OK per app mobile)
- **Formato:** REST API con endpoint per body part, equipment, target muscle

### Strategia di Mapping

1. **Match automatico** per nome esercizio (fuzzy match: Levenshtein distance ≤ 3)
2. **Match manuale** per esercizi con nome italiano (traduzione → match)
3. **Fallback:** ExerciseDB API per esercizi non trovati in Free Exercise DB
4. **Ultimo resort:** Placeholder categorizzato (come oggi) per esercizi ultra-specifici

---

## 3. Technical Approach

### 3.1 Asset Storage

**Decisione:** Bundle locale (non download runtime)

**Perché:**
- L'app funziona offline (no internet required)
- Consistenza garantita
- ~80 esercizi × 2 JPG (50KB ciascuno) = ~8MB — accettabile
- GIF opzionali scaricabili on-demand (più pesanti: ~200KB ciascuna)

### 3.2 Struttura Asset

```
phoenix_app/assets/exercises/
├── images/
│   ├── bench_press_0.jpg      # posizione iniziale
│   ├── bench_press_1.jpg      # posizione finale
│   ├── squat_0.jpg
│   ├── squat_1.jpg
│   └── ...
├── gifs/                       # opzionale, download on-demand
│   ├── bench_press.gif
│   └── ...
└── mapping.json                # exercise_id → asset filenames
```

### 3.3 Database Changes

Aggiungere colonne alla tabella `exercises`:

```sql
ALTER TABLE exercises ADD COLUMN image_asset_prefix TEXT;  -- 'bench_press' → bench_press_0.jpg, bench_press_1.jpg
ALTER TABLE exercises ADD COLUMN gif_url TEXT;              -- URL ExerciseDB per download on-demand
ALTER TABLE exercises ADD COLUMN source_db TEXT;            -- 'free_exercise_db' | 'exercisedb' | 'manual'
```

### 3.4 Widget Updates

**ExerciseHero** — sostituire placeholder colorato con immagine reale:
- Mostrare `image_0.jpg` come hero statico
- Se GIF disponibile, alternare tra immagini o mostrare GIF
- Fallback al placeholder colorato se asset mancante

**ExerciseDetailSheet** — aggiungere carousel:
- Immagine posizione iniziale
- Immagine posizione finale
- GIF animata (se disponibile)

**WorkoutSessionScreen** — preview esercizio inline con immagine

---

## 4. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `assets/exercises/images/` | Create | ~160 JPG (80 esercizi × 2) |
| `assets/exercises/mapping.json` | Create | Mapping exercise_id → asset prefix |
| `core/database/tables.dart` | Modify | Add image_asset_prefix, gif_url, source_db columns |
| `core/database/database.dart` | Modify | Migration v9 (add columns) |
| `core/database/seed/exercise_seed.dart` | Modify | Add image_asset_prefix per exercise |
| `features/exercise/widgets/exercise_hero.dart` | Modify | Real image instead of placeholder |
| `features/exercise/exercise_detail_sheet.dart` | Modify | Image carousel |
| `features/workout/workout_session_screen.dart` | Modify | Inline exercise preview with image |
| `pubspec.yaml` | Modify | Add assets/exercises/ to asset bundle |
| `tools/map_exercises.dart` | Create | Script to match Phoenix exercises → Free Exercise DB |

---

## 5. Mapping Script

Tool offline (Dart CLI) che:
1. Carica `exercises.json` da Free Exercise DB
2. Carica il seed data di Phoenix
3. Fuzzy-match per nome (normalizzato lowercase, senza punteggiatura)
4. Genera report: matched / unmatched / ambiguous
5. Scarica JPG per i match confermati
6. Genera `mapping.json`

Output atteso:
- ~60-70% match automatico
- ~20% match manuale (nomi italiani → traduzione)
- ~10% senza match (esercizi molto specifici → fallback ExerciseDB o placeholder)

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Image asset resolution | exercise with prefix | Correct asset path | High |
| UT-02 | Fallback when no image | exercise without prefix | Placeholder shown | High |
| UT-03 | Mapping JSON parsing | Valid JSON | All exercises mapped | Medium |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Exercise detail opens with image | Tap exercise → sheet | Image visible, not placeholder | High |
| IT-02 | Workout preview shows image | Start workout | Exercise image in preview step | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Missing asset file | File deleted/corrupted | Graceful fallback to colored placeholder |
| EC-02 | Very large GIF | >1MB GIF | Lazy load, show static image first |

---

## 7. Implementation Notes

- Le immagini Free Exercise DB sono JPG ~50KB, qualità sufficiente per mobile
- Le GIF ExerciseDB sono più pesanti (~200KB) — considerare download on-demand
- Mantenere il placeholder come fallback — mai rompere l'UI
- Naming convention asset: snake_case del nome esercizio inglese
- Considerare `CachedNetworkImage` per GIF on-demand (già nel progetto via dio)

---

**Attesa PROCEED.**
