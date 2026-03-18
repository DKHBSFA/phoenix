# Fase 4: Biomarker Completi

**Prerequisiti:** Fase 1 (età per PhenoAge, peso per trend), Fase 2-3 (storico per alert logic)
**Output:** Inserimento analisi sangue completo, PhenoAge funzionante, trend, alert automatici.

---

## 4.1 Ristrutturazione BiomarkersScreen

### Tab attuali → nuovi

Attualmente: PhenoAge, Peso, HRV, Sangue (tutti placeholder)

Nuova struttura con 4 tab:

1. **Dashboard** — overview di tutti i marker con sparkline
2. **Sangue** — inserimento + storico analisi del sangue
3. **Peso** — trend peso con media mobile
4. **PhenoAge** — calculator + storico età biologica

(HRV rimane placeholder — dipende da integrazione wearable, Fase 5+)

---

## 4.2 Tab Dashboard Biomarker

### UI

**Card superiore: PhenoAge**
- Numero grande (display font, emerald): "34.2 anni"
- Sotto: "Età cronologica: 38 → Δ -3.8 anni"
- Freccia trend (↑↓→) basata su ultimo vs penultimo calcolo
- Sparkline mini (ultimi 6 mesi)

**Grid 2 colonne: Marker principali**

Ogni card mostra:
- Nome marker
- Ultimo valore + unità
- Delta vs precedente (↑ rosso se peggiora, ↓ verde se migliora)
- Sparkline micro (ultimi 4-6 valori)

Marker da mostrare:
- Peso (kg)
- Glicemia (mg/dL)
- hsCRP (mg/L)
- HbA1c (%)
- Testosterone (ng/dL) — se disponibile
- Ferritina (µg/L)

### Timeframe toggle

`SegmentedButton`: 1M / 3M / 6M / 1A / Tutto
Cambia il range dei sparkline e dei delta.

---

## 4.3 Tab Sangue — Form inserimento

### Panel base (analisi standard italiana)

Form con sezioni espandibili:

**Sezione: Metabolico**
- Glicemia (mg/dL) — range ref: 70-100
- HbA1c (%) — range ref: <5.7
- Trigliceridi (mg/dL) — range ref: <150
- Colesterolo totale (mg/dL) — range ref: <200
- HDL (mg/dL) — range ref: >40 M, >50 F
- Non-HDL (mg/dL) — calcolato: totale - HDL

**Sezione: Epatico**
- AST/GOT (U/L) — range ref: <40
- ALT/GPT (U/L) — range ref: <41
- GGT (U/L) — range ref: <55 M, <38 F

**Sezione: Renale**
- Creatinina (mg/dL) — range ref: 0.7-1.3 M, 0.6-1.1 F

**Sezione: Ematologico (CBC)**
- Globuli rossi (milioni/µL)
- Emoglobina (g/dL)
- Ematocrito (%)
- MCV (fL)
- MCH (pg)
- MCHC (g/dL)
- RDW (%)
- Piastrine (migliaia/µL)
- Globuli bianchi (migliaia/µL)
- Neutrofili (%)
- Linfociti (%)
- Monociti (%)

**Sezione: Ferro**
- Ferritina (µg/L) — range ref: 30-300 M, 20-200 F

**Sezione: Proteine**
- Proteine totali (g/dL) — range ref: 6.0-8.3

### Panel esteso (opzionale, espandibile)

- Testosterone totale (ng/dL) — range ref: 300-1000 M
- Testosterone libero (pg/mL)
- Cortisolo (µg/dL) — range ref: 6-23 (mattino)
- TSH (mIU/L) — range ref: 0.4-4.0
- T3 libero (pg/mL)
- T4 libero (ng/dL)
- Vitamina D 25-OH (ng/mL) — range ref: 30-100
- hsCRP (mg/L) — range ref: <1.0 basso rischio, 1-3 medio, >3 alto
- CK (U/L) — range ref: 30-200
- IGF-1 (ng/mL) — range ref: varia per età

### UI del form

- Data analisi (DatePicker, default oggi)
- Laboratorio (TextField opzionale)
- Sezioni collassabili (ExpansionTile)
- Ogni campo: label + TextField numerico + unità + range di riferimento in grigio
- Valori fuori range evidenziati in rosso/arancione
- Tasto "Salva" in basso

### Salvataggio

Salvare in tabella `Biomarkers` con `type = 'blood_panel'` e `valuesJson`:

```json
{
  "date": "2026-03-12",
  "lab": "Lab XYZ",
  "glucose": 92,
  "hba1c": 5.1,
  "triglycerides": 120,
  "cholesterol_total": 185,
  "hdl": 55,
  "ast": 25,
  "alt": 30,
  "ggt": 22,
  "creatinine": 0.9,
  "rbc": 4.8,
  "hemoglobin": 14.5,
  "hematocrit": 43,
  "mcv": 89,
  "platelets": 220,
  "wbc": 6.5,
  "neutrophils_pct": 58,
  "lymphocytes_pct": 32,
  "ferritin": 85,
  "total_protein": 7.2,
  "testosterone": 520,
  "cortisol": 15,
  "tsh": 2.1,
  "vitamin_d": 42,
  "hscrp": 0.8,
  "ck": 150,
  "igf1": 180
}
```

---

## 4.4 PhenoAge Calculator

### Formula (Levine 2018)

PhenoAge usa 9 biomarker + età cronologica:

1. Albumina (g/dL)
2. Creatinina (mg/dL)
3. Glicemia (mg/dL)
4. hsCRP (mg/L) — log-trasformato
5. Linfociti (%)
6. MCV (fL)
7. RDW (%)
8. Fosfatasi alcalina (U/L)
9. Globuli bianchi (migliaia/µL)

**Nota:** Albumina e Fosfatasi alcalina non sono nel panel base sopra. Aggiungere come campi opzionali:
- Albumina nel panel base sezione Proteine
- Fosfatasi alcalina nel panel base sezione Epatico

### Implementazione

`lib/core/models/phenoage_calculator.dart` — **NUOVO**

```dart
class PhenoAgeCalculator {
  /// Calcola PhenoAge secondo Levine et al. 2018
  /// Restituisce null se mancano marker necessari
  static double? calculate({
    required int chronologicalAge,
    required double albumin,       // g/dL
    required double creatinine,    // mg/dL
    required double glucose,       // mg/dL
    required double hscrp,         // mg/L (log-trasformato internamente)
    required double lymphocytePct, // %
    required double mcv,           // fL
    required double rdw,           // %
    required double alkalinePhosphatase, // U/L
    required double wbc,           // migliaia/µL
  }) {
    // Coefficienti dalla tabella supplementare Levine 2018
    // (implementare formula completa)
    // ...
  }
}
```

I coefficienti esatti della regressione di Cox sono pubblicati nel paper supplementary.

### UI Tab PhenoAge

**Se dati sufficienti (9 marker + età):**
- Età biologica grande (display, emerald se < cronologica, red se >)
- Δ anni: differenza
- Grafico storico (LineChart, fl_chart)
- Lista marker usati con valori attuali

**Se dati insufficienti:**
- Messaggio: "Per calcolare PhenoAge servono 9 marker specifici"
- Checklist di quali marker mancano
- Tasto "Inserisci analisi sangue" → naviga a tab Sangue

---

## 4.5 Tab Peso

### Miglioramento del tracking attuale

- Peso iniziale da onboarding (linea di riferimento)
- Grafico trend con media mobile 7 giorni
- Ultimo peso, delta da inizio, delta da settimana scorsa
- Tasto rapido "+ Peso" (solo un numero)
- BMI calcolato (peso / altezza² dal profilo)

---

## 4.6 Alert Logic

### Regole dal protocollo (sezione 5.3)

Dopo ogni inserimento analisi sangue, controllare:

```dart
class BiomarkerAlerts {
  static List<Alert> check(Map<String, dynamic> current, Map<String, dynamic>? previous, String sex) {
    final alerts = <Alert>[];

    // Testosterone drop >20% in 3 mesi
    if (previous != null && current['testosterone'] != null && previous['testosterone'] != null) {
      final drop = (previous['testosterone'] - current['testosterone']) / previous['testosterone'];
      if (drop > 0.20) {
        alerts.add(Alert(
          severity: AlertSeverity.high,
          title: 'Testosterone in calo significativo',
          message: 'Calo del ${(drop * 100).toInt()}%. Considera ridurre la finestra di digiuno (16h → 14h).',
          action: 'Ridurre TRE',
        ));
      }
    }

    // Ferritina bassa
    final ferritinThreshold = sex == 'female' ? 20.0 : 30.0;
    if (current['ferritin'] != null && current['ferritin'] < ferritinThreshold) {
      alerts.add(Alert(
        severity: AlertSeverity.high,
        title: 'Ferritina bassa',
        message: 'Ferritina ${current['ferritin']} µg/L (sotto ${ferritinThreshold.toInt()}). Rischio anemia sportiva.',
        action: 'Supplementazione ferro + ridurre volume allenamento',
      ));
    }

    // hsCRP elevato cronico
    if (current['hscrp'] != null && current['hscrp'] > 3.0) {
      alerts.add(Alert(
        severity: AlertSeverity.medium,
        title: 'Infiammazione sistemica elevata',
        message: 'hsCRP ${current['hscrp']} mg/L (>3.0). Verificare volume allenamento e qualità recupero.',
        action: 'Audit volume/frequenza/recupero',
      ));
    }

    // Linfociti bassi (immunodepressione)
    if (current['lymphocytes_pct'] != null && current['lymphocytes_pct'] < 20) {
      alerts.add(Alert(
        severity: AlertSeverity.high,
        title: 'Linfociti sotto range',
        message: 'Linfociti ${current['lymphocytes_pct']}% (<20%). Possibile immunodepressione da sovrallenamento.',
        action: 'Ridurre intensità e volume immediatamente',
      ));
    }

    return alerts;
  }
}
```

### UI Alert

Dopo inserimento analisi → se alert presenti:
- Dialog con lista alert, colorati per severità (rosso/arancione)
- Ogni alert ha: titolo, descrizione, azione suggerita
- Disclaimer: "Queste sono indicazioni del protocollo Phoenix. Consulta il tuo medico."

---

## 4.7 Disclaimer medico

Visibile nel footer della schermata biomarker:
> "I dati mostrati sono tracciati per consapevolezza personale. Interpretali sempre con il supporto del tuo medico."

Non bloccante, non popup. Sempre visibile come testo piccolo.

---

## 4.8 File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/models/phenoage_calculator.dart` | **Nuovo** — formula Levine 2018 |
| `lib/core/models/biomarker_alerts.dart` | **Nuovo** — logica alert |
| `lib/core/models/biomarker_reference_ranges.dart` | **Nuovo** — range di riferimento per sesso |
| `lib/features/biomarkers/biomarkers_screen.dart` | **Riscritto** — 4 tab con dashboard |
| `lib/features/biomarkers/blood_panel_form.dart` | **Nuovo** — form inserimento analisi |
| `lib/features/biomarkers/phenoage_tab.dart` | **Nuovo** — calculator + storico |
| `lib/features/biomarkers/weight_tab.dart` | **Nuovo** — trend peso migliorato |
| `lib/features/biomarkers/biomarker_dashboard_tab.dart` | **Nuovo** — overview |

---

## 4.9 Verifica completamento

- [ ] Tab Dashboard mostra overview con sparkline
- [ ] Form sangue con tutti i campi del panel base
- [ ] Sezione panel esteso espandibile
- [ ] Valori fuori range evidenziati
- [ ] Dati salvati correttamente nel DB
- [ ] PhenoAge calcolato quando 9 marker presenti
- [ ] PhenoAge mostra checklist marker mancanti se incompleto
- [ ] Alert generati correttamente (testare con dati edge case)
- [ ] Peso con trend e media mobile
- [ ] Disclaimer medico visibile
- [ ] `flutter analyze` 0 errors
