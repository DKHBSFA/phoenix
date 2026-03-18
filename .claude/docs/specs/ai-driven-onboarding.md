# AI-Driven Onboarding & Program Generation

## Cosa sto costruendo

L'AI coach è il cervello dell'onboarding: raccoglie dati personali + assessment fisico, genera il programma di allenamento personalizzato, e salva tutto per uso futuro. Ogni 3 mesi chiede all'utente come sta andando.

## Flusso rivisto

```
Welcome → INIZIA → [WiFi check + disclaimer] → download parte in background
                                                          ↓
                                               Personal Data (compilazione)
                                                          ↓
                                               Avanti → download finito?
                                                    ├─ Sì → Coach Assessment
                                                    └─ No → Schermata download progress
                                                              → quando finito → Coach Assessment
                                                          ↓
                                               Coach Assessment (AI chat):
                                                 - AI ha: nome, sesso, anno nascita, altezza, peso
                                                 - AI chiede su problemi fisici, dolori, infortuni
                                                 - AI chiede follow-up specifici (dove, da quanto, gravità)
                                                 - AI conferma comprensione
                                                 - AI genera programma personalizzato
                                                          ↓
                                               Confirm → salva tutto → Home
```

## Dati da persistere

### 1. Assessment fisico (`user_settings.settings_json`)

```json
{
  "physical_assessment": {
    "date": "2026-03-13",
    "limitations": [
      {
        "area": "lower_back",
        "type": "chronic",
        "severity": "moderato",
        "description": "ernia del disco, dolore parte bassa schiena",
        "since": "anni"
      }
    ],
    "chat_transcript": ["Coach: ...", "Utente: ...", ...],
    "next_reassessment": "2026-06-13"
  },
  "personal_data": {
    "name": "Davide",
    "sex": "M",
    "birth_year": 1987,
    "height_cm": 180,
    "weight_kg": 82
  }
}
```

### 2. Programma generato dall'AI

L'AI usa i dati per decidere:
- **Esercizi esclusi** (es. deadlift/squat pesante con ernia discale → sostituiti con alternative)
- **Livello iniziale** per categoria (push/pull/squat/hinge/core)
- **Volume/intensità** adattati
- **Note specifiche** per il coach durante le sessioni

Salvati in `user_settings.settings_json.training_program`:
```json
{
  "training_program": {
    "generated_date": "2026-03-13",
    "excluded_exercises": [14, 27, 33],
    "level_overrides": {"hinge": 1, "squat": 1},
    "notes": "Evitare carico assiale sulla colonna. Preferire esercizi unilaterali per il lower body.",
    "generated_by": "llm"
  }
}
```

### 3. Reassessment ogni 3 mesi

- `next_reassessment` salvato nella data assessment
- `NotificationScheduler` controlla e schedula reminder
- Dalla Today screen: banner "Assessment fisico: è ora di un check-up" (simile a AssessmentBanner)
- Il reassessment riusa la stessa chat AI ma con contesto storico

## File da toccare

| File | Cosa cambia |
|------|-------------|
| `onboarding_screen.dart` | Flow: Avanti → check download → waiting/assessment. AI prompt include dati personali |
| `prompt_templates.dart` | `PhysicalAssessmentTemplate` aggiornato con dati personali nel contesto |
| `user_settings` (DB) | Salvataggio assessment + training_program |
| `workout_generator.dart` | Legge `excluded_exercises` e `level_overrides` da settings |
| `notification_scheduler.dart` | Aggiunge reminder reassessment 3 mesi |
| `today_screen.dart` | Banner reassessment quando scaduto |

## Verifica

- [ ] Download inizia al tap INIZIA
- [ ] Se download non finito quando utente preme Avanti su dati personali → mostra progress
- [ ] Assessment NON parte senza LLM funzionante
- [ ] AI riceve nome/sesso/età/altezza/peso nel prompt
- [ ] Assessment results salvati in DB
- [ ] Programma allenamento personalizzato generato
- [ ] Esercizi esclusi rispettati nel workout generator
- [ ] Reminder 3 mesi schedulato
- [ ] Reassessment accessibile dalla Today screen
