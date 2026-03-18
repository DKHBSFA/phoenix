# Feature: Coach AI Funzionante — Report Template + Chat Sbloccata

**Status:** COMPLETED
**Created:** 2026-03-13
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Far funzionare il Coach screen con report template-based di qualità e sbloccare la chat con risposte intelligenti basate su template, senza dipendere dal modello LLM on-device.

**Why?** Il Coach AI mostra "Template-based (scarica modello per AI)" con una schermata vuota. La chat è disabilitata ("Chat disponibile quando il modello sarà scaricato"). Ma il modello LLM richiede: librerie native bitnet compilate (non esistono), URL di download (vuoto), ~1.2GB di spazio. Questo è un progetto a sé che richiede settimane. Nel frattempo, l'utente non ha NESSUN coach funzionante.

**Soluzione:** Trasformare il template fallback da stub inutile a sistema intelligente che genera report e risposte contestuali usando i dati reali dell'utente dal DB. L'architettura LLM resta intatta per il futuro, ma il fallback diventa un prodotto funzionale.

**For whom?** L'utente — deve poter consultare report sui propri allenamenti e interagire con un coach che risponde in base ai suoi dati.

**Success metric:**
- I 3 chip report generano contenuti utili basati su dati reali
- La chat è sbloccata e risponde con suggerimenti contestuali
- Lo status badge mostra "Coach Attivo" (non "Template-based")

---

## 2. Technical Approach

**Pattern:** Potenziare `ReportGenerator` + creare `TemplateChat` per risposte rule-based + modificare `CoachScreen` per sbloccare la chat.

**Key decisions:**

1. **Template fallback ≠ stub** — Il `TemplateFallbackRuntime.infer()` attualmente ritorna `'[Template-based summary - LLM not available]'`. Lo sostituiamo con logica che: (a) parsa il prompt per capire l'intent, (b) interroga il DB, (c) genera una risposta strutturata in italiano.

2. **Chat sbloccata sempre** — Rimuovere il gate `engine.isLlmAvailable` dalla chat. Il template runtime è perfettamente in grado di generare risposte utili. La distinzione sarà: badge "Coach" (template) vs "Coach AI" (LLM) — non "disabilitato".

3. **Intent detection rule-based** — Per la chat, classichiamo l'input utente in categorie semplici:
   - Contiene "allenamento/workout/eserciz" → risposta su training
   - Contiene "digiuno/fast" → risposta su fasting
   - Contiene "peso/weight/kg" → risposta su peso
   - Contiene "freddo/cold/caldo/heat" → risposta su conditioning
   - Contiene "sonno/sleep/dormire" → risposta su sleep
   - Default → riepilogo generale + suggerimento del giorno

4. **Report generator già funzionante** — `ReportGenerator` ha già `generatePostWorkout`, `generateWeekly`, `generateFasting` implementati con dati reali. Il problema è che il CoachScreen non li presenta bene. Miglioriamo la formattazione e aggiungiamo il report di fasting mancante.

5. **Streaming simulato** — Il template runtime simula streaming spezzando la risposta in chunk da 3 caratteri con delay 15ms. Manteniamo questo per coerenza UX con il futuro LLM.

6. **Nessun download model prompt** — Il `ModelDownloadCard` resta disponibile nelle impostazioni per chi vuole provare (futuro), ma non è più il gate per usare il coach.

**Dependencies:** Nessuna nuova.

**Breaking changes:** La chat si sblocca per tutti. Il badge cambia testo. Nessuna rottura di logica.

---

## 3. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `lib/core/llm/llm_runtime.dart` | **Modify** | `TemplateFallbackRuntime.infer()` → generazione contestuale dal DB |
| `lib/core/llm/llm_runtime.dart` | **Modify** | `TemplateFallbackRuntime.streamNext()` → streaming simulato funzionante |
| `lib/core/llm/template_chat.dart` | **Create** | Intent detection + response generation rule-based |
| `lib/core/models/report_generator.dart` | **Modify** | Migliorare formattazione, aggiungere emoji, sezioni più leggibili |
| `lib/features/coach/coach_screen.dart` | **Modify** | Sbloccare chat (rimuovere gate isLlmAvailable), cambiare badge text |
| `lib/features/coach/widgets/chat_message.dart` | **Modify** | Migliorare bubble styling (preparazione per stitch batch 3) |
| `lib/app/providers.dart` | **Modify** | Passare DAO references al TemplateFallbackRuntime |

---

## 4. Specifiche Funzionali

### 4.1 TemplateChat — Intent Detection

```dart
enum ChatIntent {
  training,    // allenamento, workout, esercizio, serie, rep
  fasting,     // digiuno, fast, finestra alimentare, autofagia
  weight,      // peso, kg, bilancia, massa
  conditioning,// freddo, cold, caldo, heat, meditazione, sonno
  biomarkers,  // sangue, biomarker, phenoage, analisi
  motivation,  // motivazione, stanco, difficile, non ce la faccio
  general,     // fallback
}
```

Keywords mapping (case-insensitive, Italian + English):

```dart
static ChatIntent detect(String input) {
  final lower = input.toLowerCase();
  if (lower.containsAny(['allenam', 'workout', 'eserciz', 'serie', 'rep', 'muscol']))
    return ChatIntent.training;
  if (lower.containsAny(['digiun', 'fast', 'mangia', 'finestra', 'autofag']))
    return ChatIntent.fasting;
  if (lower.containsAny(['peso', 'kg', 'bilancia', 'massa', 'weight']))
    return ChatIntent.weight;
  if (lower.containsAny(['fredd', 'cold', 'cald', 'heat', 'meditaz', 'sonn', 'sleep', 'respir']))
    return ChatIntent.conditioning;
  if (lower.containsAny(['sangu', 'biomark', 'phenoage', 'analis', 'esam']))
    return ChatIntent.biomarkers;
  if (lower.containsAny(['motiv', 'stanc', 'difficil', 'non ce la', 'mollare']))
    return ChatIntent.motivation;
  return ChatIntent.general;
}
```

### 4.2 Response Generation per Intent

Ogni intent genera una risposta strutturata interrogando i DAO appropriati:

**Training:**
```
Ecco il tuo stato allenamento:
- Streak attuale: X giorni
- Ultima sessione: [tipo] — [durata] min, RPE [valore]
- Sessioni questa settimana: X/Y

[Suggerimento basato su RPE/streak/tipo giorno]
```

**Fasting:**
```
Il tuo digiuno:
- Livello attuale: X
- Ultimo completato: Xh/Xh target
- Tolleranza: X/5

[Suggerimento basato su livello/tolleranza]
```

**Weight:**
```
Il tuo peso:
- Attuale: XX.X kg
- Trend 7gg: +/-X.X kg
- BMI: XX.X

[Commento sul trend]
```

**Conditioning:**
```
Condizionamento questa settimana:
- Freddo: X sessioni (streak: X gg)
- Caldo: X sessioni
- Meditazione: X sessioni
- Sonno medio: Xh Xmin

[Suggerimento su cosa manca]
```

**Motivation:**
```
[Messaggio motivazionale personalizzato basato su streak e progressi reali]
Hai completato X sessioni questo mese. Ogni sessione conta.
[Citazione/principio dal protocollo Phoenix]
```

**General:**
```
Ecco un riepilogo veloce:
- Allenamento: X sessioni (streak: X)
- Digiuno: livello X
- Condizionamento: X sessioni questa settimana
- Peso: XX.X kg

Cosa vuoi approfondire?
```

### 4.3 Report Formatting Upgrade

I report attuali in `ReportGenerator` sono funzionali ma scarni. Miglioriamo:

**Post-workout** — aggiungere:
- Nome esercizi (non solo "Esercizio #ID") → join con exercises table
- Sezione "Prossima sessione" con suggerimento giorno
- Formattazione markdown più leggibile

**Weekly** — aggiungere:
- Barra progresso visuale testuale (es. `████░░░░ 4/7`)
- Top esercizio della settimana (più volume)
- Suggerimento settimana prossima

**Fasting** — già implementato, migliorare:
- Aggiungere milestone raggiunto (es. "12h = flessibilità metabolica")
- Confronto con sessione precedente

### 4.4 Coach Screen UI Changes

**Badge status:**
- Prima: `● Template-based (scarica modello per AI)` (grigio)
- Dopo: `● Coach Attivo` (verde) — sempre, sia template che LLM
- Se LLM disponibile: `● Coach AI (X.X tok/s)` (verde con label diversa)

**Chat:**
- Prima: input disabilitato, placeholder "Chat disponibile quando il modello sarà scaricato"
- Dopo: input sempre abilitato, placeholder "Chiedi al coach..."

**Empty state:**
- Prima: "Seleziona un tipo di report" con icone grigie
- Dopo: messaggio di benvenuto del coach con 3 suggerimenti tappabili:
  - "Come è andato il mio allenamento?"
  - "Qual è il mio stato questa settimana?"
  - "Dammi motivazione!"

---

## 5. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Intent detection — training keywords | `"come va il mio allenamento?"` | `ChatIntent.training` | High |
| UT-02 | Intent detection — fasting keywords | `"parlami del digiuno"` | `ChatIntent.fasting` | High |
| UT-03 | Intent detection — mixed (first match) | `"peso dopo allenamento"` | `ChatIntent.training` | Medium |
| UT-04 | Intent detection — fallback | `"ciao come stai"` | `ChatIntent.general` | High |
| UT-05 | Intent detection — motivation | `"sono stanco oggi"` | `ChatIntent.motivation` | Medium |
| UT-06 | Response generation with no data | Empty DB | Graceful message "Non ho ancora dati..." | High |

### Integration Tests
| ID | Flow | Components | Expected | Priority |
|----|------|------------|----------|----------|
| IT-01 | Tap "Ultimo allenamento" chip | CoachScreen → ReportGenerator | Report con nomi esercizi, RPE, suggerimento | High |
| IT-02 | Type message → send | CoachScreen → TemplateChat → response | Risposta contestuale streamed | High |
| IT-03 | Tap suggested question | CoachScreen → TemplateChat | Risposta appropriata all'intent | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Nessun allenamento mai fatto | DB vuoto workout | "Non hai ancora completato un allenamento. Inizia dalla tab Training!" |
| EC-02 | Nessun digiuno completato | DB vuoto fasting | "Non hai ancora fatto un digiuno. Prova dalla tab Fasting!" |
| EC-03 | Domanda in inglese | `"how is my training?"` | Intent detection funziona (keywords English incluse) |
| EC-04 | Input vuoto | `""` | Non inviare, bottone send disabilitato |

---

## 6. Implementation Notes

### Ordine di implementazione

1. Creare `template_chat.dart` con intent detection + response stubs
2. Modificare `TemplateFallbackRuntime` per usare `TemplateChat`
3. Modificare `providers.dart` per passare i DAO al runtime
4. Migliorare `ReportGenerator` formattazione
5. Modificare `CoachScreen` — sbloccare chat, cambiare badge, welcome message
6. Testing end-to-end

### Architettura

```
CoachScreen
├── Report chips → ReportGenerator (esistente, migliorato)
│   ├── generatePostWorkout() → dati da WorkoutDao
│   ├── generateWeekly() → dati da tutti i DAO
│   └── generateFasting() → dati da FastingDao
│
└── Chat input → LlmEngine.generateStream()
    └── TemplateFallbackRuntime (potenziato)
        └── TemplateChat.respond(prompt)
            ├── detect(intent)
            ├── query(appropriate DAO)
            └── format(response in Italian)
```

### Note su streaming

Il `TemplateFallbackRuntime` attuale ha `streamNext()` che ritorna sempre `null`. Lo modifichiamo per:
1. `streamStart(prompt)` → genera risposta completa, la bufferizza
2. `streamNext()` → ritorna 3 caratteri alla volta dal buffer
3. `streamDone()` → true quando buffer esaurito

Questo simula l'esperienza di streaming LLM senza cambiare l'API.

---

## 7. Completion Record

**Status:** Completato
**Date:** 2026-03-13
