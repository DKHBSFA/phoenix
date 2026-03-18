# Fase 5: Condizionamento + Sonno Completi

**Prerequisiti:** Fase 1 (profilo), Fase 2 (orari allenamento per vincoli temporali)
**Output:** Progressione freddo strutturata, meditazione con breathing cue, sleep tracking, storico con grafici.

---

## 5.1 Condizionamento Freddo — Progressione strutturata

### Protocollo (sezione 3.1)

- Start: 30 secondi
- Progressione: +30s/settimana
- Target: 2-3 minuti
- Frequenza: 5x/settimana
- Temperatura: 14-15°C
- Dose settimanale target: ~11 minuti totali
- **Vincolo:** MAI entro 6h post-allenamento di forza (interferisce con ipertrofia)

### UI migliorata

**Card progressione:**
- Settimana corrente: N
- Target attuale: "1 minuto 30 secondi"
- Sessioni questa settimana: 3/5
- Dose settimanale: 4.5/11 minuti

**Alert timing:**
Se l'utente ha fatto allenamento di forza nelle ultime 6h:
- Banner giallo: "⚠️ Allenamento di forza 3h fa. Il freddo entro 6h può ridurre l'adattamento ipertrofico (Roberts et al. 2015). Consigliato attendere."
- Non bloccante, solo informativo

**Principio Søberg:**
Dopo la sessione, reminder: "Termina sul freddo — non riscaldarti attivamente"

### Timer migliorato

- Target time pre-impostato (dalla progressione settimanale)
- Countdown invece di count-up
- Quando raggiunto il target → vibrazione + suono + messaggio "Obiettivo raggiunto! Continua se vuoi."
- Il timer continua oltre il target se l'utente non ferma

---

## 5.2 Condizionamento Caldo

### Protocollo (sezione 3.2)

Opzionale, tracking semplice:
- Temperatura + durata
- Tipo: sauna / bagno caldo
- Storico con trend

### UI

Come attuale ma con storico trend (grafico durata nel tempo).

---

## 5.3 Meditazione con Breathing Cue

### Protocollo (sezione 3.3)

- Respirazione guidata: inhale 4s → hold 4s → exhale 4s → hold 4s (box breathing)
- Variante semplice: inhale 4s → exhale 6s (parasimpatico)
- Durata: 5-20 minuti

### UI

**Selettore tecnica:**
- Box Breathing (4-4-4-4)
- Rilassamento (4-6)
- Personalizzato (slider per ogni fase)

**Animazione breathing:**
- Cerchio che si espande (inhale) e contrae (exhale)
- Testo fading: "Inspira..." → "Trattieni..." → "Espira..." → "Trattieni..."
- Colore cerchio: viola (conditioning accent)
- Opzionale: suono sottile per transizioni fase

**Timer:**
- Countdown dal tempo scelto (5/10/15/20 min)
- Conteggio cicli completati
- Fine sessione: gong/vibrazione

### Implementazione

```dart
class BreathingController {
  final int inhaleSeconds;
  final int holdInSeconds;
  final int exhaleSeconds;
  final int holdOutSeconds;

  BreathingPhase currentPhase = BreathingPhase.inhale;
  int secondsInPhase = 0;
  int cyclesCompleted = 0;

  void tick() {
    secondsInPhase++;
    if (secondsInPhase >= currentPhaseDuration) {
      secondsInPhase = 0;
      currentPhase = nextPhase;
      if (currentPhase == BreathingPhase.inhale) cyclesCompleted++;
    }
  }
}

enum BreathingPhase { inhale, holdIn, exhale, holdOut }
```

---

## 5.4 Sleep Tracking

### Protocollo (sezione 3.5)

- Target: 7-8 ore/notte
- Regolarità > durata
- Qualità: deep sleep, consistenza orari

### Nuova tabella o uso esistente

Usare `ConditioningSessions` con `type = 'sleep'`:
- `durationSeconds` → durata sonno in secondi
- `temperature` → non usato per sleep
- `notes` → JSON con dati aggiuntivi

Oppure aggiungere campi specifici. Per semplicità, usare `notes` come JSON:

```json
{
  "bedtime": "23:30",
  "wakeTime": "07:15",
  "quality": 4,
  "deepSleepFeeling": "good",
  "notes": "Svegliato una volta"
}
```

### UI Sleep Tab

**Attualmente:** testo "In sviluppo". Sostituire con:

**Input giornaliero:**
- Ora addormentamento: TimePicker (default 23:00)
- Ora risveglio: TimePicker (default 07:00)
- Durata calcolata automaticamente
- Qualità soggettiva: 5 stelle o slider 1-5
- Note opzionali

**Card riepilogo:**
- Media sonno ultimi 7 giorni: "7h 23m"
- Regolarità: deviazione standard orari (bassa = buona)
- Score regolarità: "Alta" (verde) / "Media" (giallo) / "Bassa" (rosso)
- Target raggiunto: X/7 giorni questa settimana sopra 7h

**Grafico:**
- Barchart ultimi 14 giorni (altezza = ore, colore = qualità)
- Linea target 7h e 8h
- Orario addormentamento come punto sopra la barra

**Consigli (statici, dal protocollo):**
Card in basso con tips:
- "Stanza a 18-19°C"
- "Doccia calda 1-2h prima"
- "Luce solare al mattino"
- "No caffeina 8-12h prima"
- "No schermo blu 1h prima"

---

## 5.5 Storico con grafici per tutti i tipi

### Attualmente

`_ConditioningHistory` mostra solo testo delle ultime 5 sessioni.

### Miglioramento

Per ogni tipo (cold/heat/meditation/sleep):

**Grafico trend:**
- LineChart (fl_chart) con durata nel tempo
- Ultimi 30 giorni
- Per cold: anche temperatura come seconda linea

**Statistiche:**
- Sessioni totali
- Streak corrente (giorni consecutivi)
- Media durata
- Trend: ↑ migliorando / → stabile / ↓ in calo

---

## 5.6 Integrazione Dashboard

Nella home, la card condizionamento mostra:
- Streak freddo: "5 giorni consecutivi"
- Ultima meditazione: "ieri, 10 min"
- Sonno medio settimana: "7h 15m"

---

## 5.7 File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/models/breathing_controller.dart` | **Nuovo** — logica breathing cue |
| `lib/core/models/cold_progression.dart` | **Nuovo** — calcolo target settimanale freddo |
| `lib/core/models/sleep_score.dart` | **Nuovo** — calcolo regolarità + score |
| `lib/features/conditioning/conditioning_screen.dart` | **Riscritto** — 4 tab migliorati |
| `lib/features/conditioning/cold_tab.dart` | **Nuovo** — progressione + alert timing |
| `lib/features/conditioning/meditation_tab.dart` | **Nuovo** — breathing cue animato |
| `lib/features/conditioning/sleep_tab.dart` | **Nuovo** — tracking + grafici |
| `lib/features/conditioning/conditioning_history.dart` | **Nuovo** — grafici trend |

---

## 5.8 Verifica completamento

- [ ] Freddo: progressione settimanale visualizzata
- [ ] Freddo: alert se entro 6h da allenamento forza
- [ ] Freddo: countdown con target pre-impostato
- [ ] Meditazione: breathing cue con animazione cerchio
- [ ] Meditazione: 3 tecniche selezionabili
- [ ] Sleep: input giornaliero (orari + qualità)
- [ ] Sleep: grafico ultimi 14 giorni
- [ ] Sleep: score regolarità
- [ ] Storico con grafici per tutti i tipi
- [ ] Streak e statistiche
- [ ] `flutter analyze` 0 errors
