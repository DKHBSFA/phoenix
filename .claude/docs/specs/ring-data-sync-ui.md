# Ring Data Sync & UI ✅ Completato 2026-03-18

## Cosa sto costruendo

Aggiungere alla `RingSettingsScreen` la sezione di sincronizzazione dati e una schermata di visualizzazione dei dati scaricati dal ring. Il `RingService` ha già tutti i comandi — manca solo la UI e la logica di salvataggio.

## Scope

### 1. Sezione Sync nella RingSettingsScreen (quando ring connesso)

- **Pulsante "Sincronizza dati"** — scarica HR log (oggi + ieri) + steps (oggi + ieri)
- **Indicatore ultimo sync** — "Ultimo sync: oggi 14:32" o "Mai sincronizzato"
- **Progress** durante il sync
- **Impostazioni HR log** — intervallo campionamento (lettura + modifica)

### 2. Schermata Ring Data (tap su "Visualizza dati")

- **HR Log** — grafico a barre orizzontale delle ultime 24h (288 slot × 5 min)
- **Passi** — totale giornaliero + grafico intervalli 15 min
- **Real-time** — pulsante per avviare streaming HR live (test/debug)

### 3. Salvataggio DB

I dati vanno salvati nelle tabelle esistenti dove possibile:
- HR log → `conditioning_sessions` o nuova tabella `ring_hr_samples`
- Steps → campo in `ring_devices` (last_sync metadata) + visualizzazione diretta

## File che tocco

| File | Cosa |
|------|------|
| `features/settings/ring_settings_screen.dart` | Aggiungere sezione sync + data actions |
| `features/settings/ring_data_screen.dart` | **NUOVO** — visualizzazione dati ring |
| `core/database/daos/ring_device_dao.dart` | Aggiungere update lastSync |
| `app/router.dart` | Aggiungere route ring_data |

## Cosa riuso

- `RingService.readHeartRateLog()` — già implementato
- `RingService.readSteps()` — già implementato
- `RingService.startRealTimeHr()` / `stopRealTimeHr()` — già implementato
- `RingService.readHrLogSettings()` / `setHrLogSettings()` — già implementato
- `RingService.realTimeReadings` stream — già implementato
- `fl_chart` — già in dipendenze per grafici

## Come verifico

1. Connettere ring → sezione sync visibile
2. Tap "Sincronizza" → scarica HR + steps, mostra progress
3. Tap "Visualizza dati" → schermata con grafici HR e passi
4. Tap "HR Live" → streaming real-time con BPM visibile
5. Senza ring → sezione sync non visibile, nessun crash
