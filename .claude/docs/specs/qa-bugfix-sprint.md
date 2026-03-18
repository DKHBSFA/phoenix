# Feature: QA Bugfix Sprint — P0 + P1

**Status:** COMPLETATA
**Created:** 2026-03-13
**Riferimento:** `.claude/docs/qa-review-2026-03-13.md`

---

## 1. Overview

**What?** Risolvere tutti i bug P0 (critici) e P1 (importanti) identificati nella QA review, organizzati in batch logici per minimizzare conflitti e massimizzare testabilità.

**Why?** I P0 impediscono il lancio (onboarding rotto, errori visibili, contenuto nascosto). I P1 degradano l'esperienza utente e la coerenza visiva.

**Scope:** Solo fix a codice esistente. Nessuna feature nuova (testing P0/#1, periodizzazione P1/#7, macro tracking P1/#8 sono feature separate e richiedono spec dedicate).

---

## 2. Piano di implementazione

### Batch A — Fix UI critici (B1, B4/B5, B11, B9, B7, B15)
Tutti nella stessa area: componenti UI condivisi e singoli screen. Nessuna logica business toccata.

| # | Bug | File | Cosa fare |
|---|-----|------|-----------|
| B1 | Ring labels troncate | `home_screen.dart` → `_RingLabel` | Abbreviare label: "Allenamento" → icona + "da fare"/"fatto". Oppure: usare `Column` verticale sotto ogni ring invece di `Row` orizzontale |
| B4 | Tab Dashboard mancante (Bio) | `biomarkers_screen.dart` | Ridurre padding pill tabs e/o abbreviare label ("Dashboard" → "Home", oppure aggiungere icona e rimuovere testo) |
| B5 | Tab Sonno mancante (Cond.) | `conditioning_screen.dart` | Stesso approccio di B4: label più corte o scroll indicator |
| B11 | Bottom nav text non colora | `home_screen.dart` → `_BottomNav` | Aggiungere `selectedTabTextStyle` e `unselectedTabTextStyle` al `TDBottomTabBar` |
| B9 | Progress bar arancioni (Cond.) | `cold_tab.dart` | Passare `color: PhoenixColors.conditioningAccent` ai `TDProgress` |
| B7 | Bottoni blu/lilla | `nutrition_tab.dart`, `weight_tab.dart` | Sostituire `ElevatedButton` residui con `TDButton(theme: TDButtonTheme.primary)` |
| B15 | Timer separator viola | Timer conditioning (widget) | Cambiare colore ":" da `conditioningAccent` a colore testo primario |

**Verifica:** Rebuild APK → controllare home, conditioning, biomarker, fasting/nutrition, weight su device.

---

### Batch B — Onboarding fix (B2, B12)

| # | Bug | File | Cosa fare |
|---|-----|------|-----------|
| B2 | Year picker full-screen | `onboarding_screen.dart` | Sostituire `DropdownButton` con `showDatePicker(initialDatePickerMode: DatePickerMode.year)` o `TDDatePicker` wheel. Se TDesign ha un picker year-only, usare quello |
| B12 | Progress bar senza contesto | `onboarding_screen.dart` | Aggiungere "Passo X di N" sotto la barra di progresso |

**Verifica:** Reinstallare, cancellare dati app, passare l'intero onboarding.

---

### Batch C — Model download + safety (B3, #2)

| # | Bug | File | Cosa fare |
|---|-----|------|-----------|
| B3 | Errore rosso model download | `model_download_card.dart`, `model_manager.dart` | Se `modelUrl` è null/empty, nascondere la card e mostrare un testo informativo ("Modello AI disponibile in futuro") invece dell'errore. Non mostrare mai rosso a meno che il download fallisca davvero |
| #2 | Disclaimer medico fasting L3 | `fasting_screen.dart` (timer tab, livello 3) | Aggiungere `TDDialog` di conferma quando l'utente seleziona Livello 3: "Il digiuno prolungato (18-24h) richiede supervisione medica. Prosegui solo se il tuo medico lo ha approvato." con bottoni "Annulla" / "Ho capito, prosegui" |

**Verifica:** Testare: (a) Settings → Coach AI → la card non mostra errore. (b) Fasting → Timer → selezionare L3 → dialog appare.

---

### Batch D — Empty states + safety UX (#3, #4, B10)

| # | Bug | File | Cosa fare |
|---|-----|------|-----------|
| #3 | Empty states mancanti | `home_screen.dart` (stats, sessions), `training_screen.dart` (sessions), `conditioning_screen.dart` (history) | Per ogni empty state, wrappare con `TDEmpty` + CTA button contestuale. Es: "Nessun allenamento oggi" + bottone "Inizia ora" |
| #4 | Swipe-delete senza undo | `nutrition_tab.dart` | Dopo delete, mostrare `TDToast` con azione "Annulla" per 5 secondi. Implementare soft-delete: segnare come eliminato, rimuovere dalla UI, effettivamente eliminare solo dopo timeout |
| B10 | Empty state inconsistenti | Vari | Unificare con pattern: `TDEmpty(image: ..., description: ...) + TDButton CTA` |

**Verifica:** (a) Primo avvio → ogni screen ha empty state guidato. (b) Fasting → Nutrizione → swipe delete meal → toast "Annulla" appare → tap annulla → meal ripristinato.

---

### Batch E — Lingua e label (#5, B13)

| # | Bug | File | Cosa fare |
|---|-----|------|-----------|
| #5 | Lingua mista bottom nav | `home_screen.dart` → `_BottomNav` | "Training" → "Allenamento", "Fasting" → "Digiuno", "Bio" → "Biomarker", "Coach" → "Coach" (OK, è un anglicismo accettato) |
| B13 | Label inglesi Settings | `settings_screen.dart` | "Tier" → "Livello", "Equipment" → "Attrezzatura" |
| #5b | Header inglesi screen | `training_screen.dart`, `conditioning_screen.dart`, ecc. | "Training" → "Allenamento" (header), verificare coerenza su tutti gli screen |

**Verifica:** Navigare tutti gli screen, verificare che non ci siano label inglesi residue (eccetto "Coach", "PhenoAge" che sono termini tecnici).

---

### Batch F — Conditioning nella nav (#6)

| # | Bug | File | Cosa fare |
|---|-----|------|-----------|
| #6 | Conditioning sepolto | `home_screen.dart` | **Opzione A:** Aggiungere Conditioning come 4° tab della bottom nav (tra Fasting e Bio), portando a 6 tab. Bottom nav con 6 tab è troppo → rimuovere quick actions dalla home e usare lo spazio guadagnato. **Opzione B:** Sostituire le Quick Actions 2×2 con un singolo banner "Condizionamento" prominente. **Opzione C:** Integrare Cold/Sleep/Meditation come sub-feature in altri tab. |

**Decisione necessaria:** Quale opzione? A richiede ristrutturazione nav. B è il fix minimo. C è un redesign.

**Raccomandazione:** Opzione B per ora — trasformare la card "Log condizionamento" in un elemento hero con progress (es. "Freddo: 0/5 questa settimana · Sonno: non registrato") che porta direttamente allo screen.

---

## 3. File da modificare (riepilogo)

| File | Batch | Cambiamenti |
|------|-------|-------------|
| `home_screen.dart` | A, E, F | Ring labels, bottom nav text style + label italiane, conditioning visibility |
| `biomarkers_screen.dart` | A | Pill tab label/padding |
| `conditioning_screen.dart` | A, E | Pill tab label/padding, header italiano |
| `cold_tab.dart` | A | TDProgress color |
| `nutrition_tab.dart` | A, D | Button color, swipe undo |
| `weight_tab.dart` | A | Button color |
| `onboarding_screen.dart` | B | Year picker, progress label |
| `model_download_card.dart` | C | Nascondere errore se URL mancante |
| `fasting_screen.dart` | C, D | Disclaimer L3, empty states |
| `training_screen.dart` | D, E | Empty states, header italiano |
| `settings_screen.dart` | E | Label italiane |
| Timer widget (conditioning) | A | Separator color |

---

## 4. Cosa NON tocchiamo

Escluso da questa spec (richiede spec dedicata):
- **#1 Testing** → spec separata (unit test PhenoAge, cold constraint, progression)
- **#7 Periodizzazione** → feature nuova (mesocicli, deload)
- **#8 Macro tracking** → feature nuova (food DB, carbs/fat)
- **#9 Micro-interactions** → spec separata (confetti, achievement cards)
- **#10 State management refactor** → refactoring architetturale
- **#11 Error logging** → infra (crashlytics, sentry)
- **#12 Card style unification** → design system refactor
- **Tutti i P2** → backlog

---

## 5. Ordine di implementazione

```
Batch A: Fix UI critici (1 sessione)
  └→ Checkpoint: rebuild + verifica visiva home, conditioning, bio, fasting

Batch B: Onboarding fix (1 sessione)
  └→ Checkpoint: reinstall + onboarding completo

Batch C: Model download + safety (1 sessione)
  └→ Checkpoint: settings + fasting L3 dialog

Batch D: Empty states + undo (1 sessione)
  └→ Checkpoint: primo avvio + swipe delete + undo

Batch E: Lingua (1 sessione)
  └→ Checkpoint: navigazione completa, nessun inglese residuo

Batch F: Conditioning visibility (richiede decisione)
  └→ Checkpoint: da definire
```

---

## 6. Rischi

| Rischio | Impatto | Mitigazione |
|---------|---------|-------------|
| Pill tabs abbreviate perdono chiarezza | Medio | Testare su device: se il testo abbreviato è ambiguo, usare solo icone |
| TDDatePicker non ha modalità year-only | Medio | Fallback: CupertinoPicker custom con lista anni |
| Soft-delete meals aggiunge complessità al DAO | Basso | Usare timer locale (non DB), delete effettivo dopo 5s senza undo |
| Traduzione bottom nav rompe layout | Basso | "Allenamento" è lungo — verificare che TDBottomTabBar non tronchi |

---

*Attendo PROCEED per iniziare da Batch A.*
