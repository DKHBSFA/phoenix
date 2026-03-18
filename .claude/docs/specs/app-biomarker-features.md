# Spec: Biomarker Tracking — Funzionalità App

**Riferimento protocollo:** `references/phoenix-protocol.md` → sezione Biomarker Tracking
**Stato:** da sviluppare

---

## Funzionalità

1. **Upload PDF** — OCR per estrarre valori dal formato italiano standard (S-Glucosio, S-Ferritina, ecc.)
2. **Inserimento manuale** — fallback se OCR non disponibile o formato non riconosciuto
3. **Mapping nomi** — dizionario italiano → marker protocollo (es. "S-Colesterolo Totale" → colesterolo totale)
4. **Trend tracking** — grafici longitudinali tra prelievi successivi (non singoli valori)
5. **Alert algoritmici** — segnalazioni su trend negativi con suggerimenti di adattamento:
   - Testosterone calato >20% in 3 mesi → suggerire riduzione finestra digiuno
   - Ferritina <30 µg/L → suggerire integrazione ferro + revisione volume
   - Cortisolo elevato + prestazioni calanti → trigger protocollo deload (stadio 2)
   - Linfociti sotto range → segnale immunodepressione (stadio 3)
   - hsCRP elevato → verificare volume allenamento e recupero
6. **Disclaimer** — l'app traccia trend e segnala anomalie, NON interpreta clinicamente. Ogni alert include "consulta il tuo medico"

---

*Questo file verrà sviluppato quando si passerà all'implementazione dell'app.*
