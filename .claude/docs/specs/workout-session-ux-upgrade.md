# Workout Session UX Upgrade

**Problema:** La schermata di tracking esercizi è troppo manuale e non guidata. L'utente deve contare le reps da solo, non capisce cos'è l'RPE, non c'è guida visiva/sonora del tempo.

---

## Problemi identificati dall'utente

1. **Nessun video/animazione dell'esercizio** — Solo un'icona statica nella preview
2. **Nessun accompagnamento visivo del movimento** — Il tempo eccentrico/concentrico non è visibile
3. **Nessun accompagnamento sonoro** — Il metronomo esiste in AudioEngine ma non è collegato
4. **Rep counter manuale** — L'utente deve premere +/- invece di avere un conteggio automatico sincronizzato col tempo
5. **RPE non spiegata** — L'utente non sa cos'è, nessuna spiegazione all'inizio
6. **RPE dovrebbe essere stimata dal sistema** — Non scelta manualmente dall'utente

---

## Soluzione

### 1. Animazione esercizio (placeholder)

Dato che non abbiamo asset video reali, mostriamo:
- **Cerchio pulsante** che si espande/contrae col tempo (eccentrico = espandi, concentrico = contrai)
- Questo dà un riferimento visivo ritmico per guidare il movimento
- I **cue di esecuzione** del DB vengono mostrati durante il tracking (non solo nella preview)

### 2. Tempo Visual Guide — "Breathing Circle"

Cerchio animato centrale nella fase tracking:
- **Fase eccentrica** (es. 3s): cerchio si espande lentamente, label "ECCENTRICA ↓"
- **Pausa** (1s): cerchio fermo, label "PAUSA"
- **Fase concentrica** (es. 2s): cerchio si contrae, label "CONCENTRICA ↑"
- Colore: amber per eccentrica, cyan per pausa, verde per concentrica
- Dopo l'ultimo ciclo (reps raggiunte), flash verde + haptic

### 3. Audio sincronizzato

Collegare `AudioEngine.startMetronome()` durante il tracking:
- Tick audio a ogni transizione di fase (già implementato in AudioEngine)
- Avviare all'inizio della fase tracking
- Fermare a fine set

### 4. Auto-counting reps

Il conteggio reps avanza automaticamente:
- Ogni ciclo completo (ecc + pausa + conc) = 1 rep
- Counter inizia dal target reps e **scende** a 0 (countdown più intuitivo)
- L'utente può comunque premere "Serie completata" in qualsiasi momento per fermarsi prima
- Se le reps arrivano a 0, il set è automaticamente completo → va al riposo
- Le reps effettive = (target - reps rimanenti)

### 5. RPE spiegata

- **Primo accesso:** Mostrare un dialog/card esplicativa PRIMA del primo set con:
  - "**RPE (Rate of Perceived Exertion)**"
  - "Misura quanto ti senti affaticato dopo ogni serie (1-10)"
  - Scala visiva rapida: 😊 1-3 Facile → 😐 4-6 Moderato → 😰 7-8 Difficile → 🔥 9-10 Massimale
  - Tasto "Ho capito"
- Salvare flag in UserSettings per non mostrarlo più

### 6. RPE stimata dal sistema

Dopo ogni set, il sistema **suggerisce** un RPE basato su:
- Se l'utente ha completato tutte le reps target → RPE 6-7 (lavoro solido)
- Se ha interrotto prima del target → RPE 8-9 (vicino al cedimento)
- Se ha fatto più reps del target max → RPE 4-5 (troppo leggero)
- L'utente può confermare o aggiustare con +/- (non più slider)

Il suggerimento RPE appare come card dopo "Serie completata", con +/- per aggiustare e "Conferma" per procedere al riposo.

---

## File da modificare

| File | Azione |
|------|--------|
| `lib/features/workout/workout_session_screen.dart` | Riscrivere fase tracking + aggiungere RPE explanation |
| `lib/core/audio/audio_engine.dart` | Aggiungere callback per fase corrente |
| `lib/core/models/app_settings.dart` | Flag `rpeExplained` |

---

## Flusso aggiornato

1. **Preview** — Nome + set×reps + muscoli + cue esecuzione (invariato)
2. **Countdown** — 3-2-1 (invariato)
3. **Tracking** — NUOVO:
   - Cerchio pulsante centrale sincronizzato col tempo
   - Label fase (ECCENTRICA/PAUSA/CONCENTRICA)
   - Countdown reps (10→9→8...→0) automatico
   - Cue esecuzione visibili sotto
   - Audio metronomo attivo
   - Tasto "Serie completata" per fermarsi prima
   - A 0 reps → automaticamente RPE
4. **RPE Confirm** — NUOVO (sotto-fase):
   - RPE suggerita dal sistema (card con valore + descrizione)
   - +/- per aggiustare
   - "Conferma" → salva e vai a riposo
5. **Rest** — Timer riposo (invariato)

---

## Verifica

- [ ] Cerchio pulsante sincronizzato col tempo eccentrico/concentrico
- [ ] Audio tick a ogni transizione fase
- [ ] Reps countdown automatico
- [ ] RPE explanation al primo utilizzo
- [ ] RPE suggerita dal sistema post-set
- [ ] Cue esecuzione visibili durante tracking
- [ ] `flutter analyze` 0 errors
