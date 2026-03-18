# Onboarding: Model Download + Coach Assessment

## What
Spostare il download del modello AI dal manuale (impostazioni) al primo avvio. Durante il download, raccogliere dati utente. Dopo il download, il coach AI intervista l'utente sui problemi fisici e filtra gli esercizi pericolosi a T0.

## Modello AI

- **Nome**: BitNet b1.58 2B4T
- **Download**: 1.2 GB (da HuggingFace)
- **Su disco**: 2.3 GB (ggml-model-i2_s.gguf)
- **RAM minima**: 2 GB
- **Sorgente**: `ModelManifest.defaultManifest` in `model_manager.dart`

## Decisioni prese

1. **WiFi**: Warning prima del download (1.2 GB), ma possibilità di scaricare anche su dati mobili. Messaggio che spiega il valore: coach AI on-premise, nessun dato esce dal telefono.
2. **Skip assessment**: Pulsante "Nessun problema fisico" disponibile.
3. **Rivalutazione**: Il coach chiede durante il riposo post-allenamento (3 min tra esercizi) se tutto ok. Il pulsante Coach è sempre disponibile da qualsiasi schermata workout. Assessment completo solo a T0 + on demand dalle impostazioni.
4. **Download fallito**: Fallback a template mode, riprovare dopo.
5. **Gestione modello**: `ModelDownloadCard` resta nelle impostazioni come "Gestisci modello" (elimina/ri-scarica). In futuro: più modelli.

## Flusso

### Step 1: Welcome
- Logo Phoenix + tagline brutalist
- "INIZIA" button

### Step 2: Dati base (no AI necessaria)
Form multi-campo, download parte in background:
1. Nome
2. Peso (kg) — per meal plan scaling
3. Altezza (cm) — per BMI
4. Sesso (M/F) — per scoring assessment, biomarker ranges
5. Data di nascita — per PhenoAge, scoring norme

### Step 3: Download in corso (se non finito)
Se i dati base sono completati prima del download:
- Schermata di attesa brutalist
- `BrutalistProgressBar`: border 2px, fill left→right
- Sotto la barra: percentuale + velocità + ETA
- Messaggi rotanti che spiegano cos'è il coach:
  - "Il tuo coach AI vive nel telefono. Zero cloud, zero dati condivisi."
  - "1.2 GB per un coach che capisce il tuo corpo."
  - "BitNet: AI che gira su telefono senza GPU."
  - "Nessun abbonamento. Nessun server. Solo tu e il protocollo."
- Warning WiFi: "Stai scaricando su dati mobili (1.2 GB). Vuoi continuare?" (solo se non WiFi)
- Se download fallisce: "Scaricamento non riuscito. Il coach funzionerà in modalità base. Riprova dalle impostazioni." → procedi con template mode

### Step 4: Coach Assessment (post-download)
Chat interface (stessa UI di post-set coach chat):

**Coach apre**:
> "Ciao [nome]. Prima di iniziare, ho bisogno di sapere una cosa: hai problemi fisici, dolori o infortuni di cui devo tenere conto?"

**Pulsante skip**: "NESSUN PROBLEMA" (sotto la chat)

**Se utente risponde**:
- AI estrae: articolazioni, tipo di problema, gravità
- Follow-up se necessario: "Dove esattamente? Da quanto tempo?"
- AI genera lista esercizi da escludere/modificare

**Output strutturato** (salvato in `user_settings.physicalLimitations`):
```json
{
  "physical_limitations": [
    {"area": "shoulder_right", "type": "impingement", "severity": "moderate"},
    {"area": "knee_left", "type": "pain", "severity": "mild"}
  ],
  "excluded_exercise_ids": [12, 34, 56],
  "modified_exercises": [
    {"exercise_id": 78, "note": "range ridotto", "max_level": 3}
  ],
  "assessment_date": "2026-03-13"
}
```

**Template fallback** (se LLM non disponibile):
Form strutturato con:
- Checkbox per zone del corpo: spalla dx/sx, gomito, polso, schiena alta/bassa, anca, ginocchio dx/sx, caviglia
- Per ogni zona selezionata: dropdown severità (lieve/moderato/severo)
- Mapping statico zona→esercizi esclusi (hardcoded, conservativo)

### Step 5: Conferma e inizio
- Coach riassume: "Perfetto. Eviteremo [lista esercizi] e partiremo dal livello 1. Sei pronto?"
- Se skip: "Ottimo! Partiamo dal livello 1. Se qualcosa non va durante l'allenamento, dimmelo."
- "INIZIA IL PROTOCOLLO" → HomeScreen

## File da toccare

| File | Change |
|------|--------|
| `main.dart` / routing | Check `isOnboardingComplete` in settings, redirect |
| NEW `features/onboarding/onboarding_screen.dart` | Multi-step: welcome → dati → download wait → coach chat → conferma |
| NEW `features/onboarding/widgets/brutalist_progress_bar.dart` | Riusabile progress bar (estratta da workout) |
| NEW `features/onboarding/widgets/wifi_warning_dialog.dart` | Dialog avviso download su dati mobili |
| `core/llm/prompt_templates.dart` | Aggiungere `PhysicalAssessmentTemplate` |
| `core/llm/template_chat.dart` | Aggiungere mapping statico zona→esercizi per fallback |
| `core/models/workout_generator.dart` | Filtrare `excluded_exercise_ids` dal piano |
| `core/database/daos/exercise_dao.dart` | `getForWorkout()` con parametro `excludeIds` |
| `core/models/app_settings.dart` | Parse/save `physicalLimitations`, `isOnboardingComplete` |
| `core/database/database.dart` | Migrazione DB per campo settings (o usa settings_json) |
| `features/coach/widgets/model_download_card.dart` | Resta come "Gestisci modello" nelle impostazioni |

## Codice da riusare

- `ModelManager.download()` — resume, progress callbacks, SHA256 checksum
- `PostSetCoachTemplate` pattern — chat → structured [DATI:] output → parse
- `TemplateChat.parseCoachData()` / `stripCoachData()` — parsing LLM output
- `_BrutalistTempoBar` → estrarre in `BrutalistProgressBar`
- `_buildChatArea()` / `_buildChatBubble()` da workout session — riusare per onboarding chat
- `ExerciseDao.getForWorkout()` — estendere con `excludeIds`
- `connectivity_plus` package — check WiFi vs dati mobili

## Verifica
- [ ] Download parte automatico al primo avvio
- [ ] Warning WiFi se su dati mobili
- [ ] Barra progresso brutalist visibile e accurata
- [ ] Messaggi rotanti durante attesa
- [ ] Coach chiede problemi fisici dopo download
- [ ] Skip "Nessun problema" funziona
- [ ] Template fallback con checkbox zone funziona
- [ ] Esercizi esclusi non appaiono in WorkoutGenerator
- [ ] Dati salvati in user_settings
- [ ] ModelDownloadCard resta nelle impostazioni come "Gestisci modello"
- [ ] Secondo avvio salta onboarding
- [ ] `flutter analyze` clean
