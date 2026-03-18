# Feature: Conditional Supplementation — Biomarker-Triggered

**Status:** COMPLETED
**Created:** 2026-03-14
**Approved:** 2026-03-14
**Completed:** 2026-03-14

---

## 1. Overview

**What?** Implementare un sistema di raccomandazione integratori condizionale basato sui biomarker dell'utente. Gli integratori vengono suggeriti SOLO quando i marker scendono sotto soglie evidence-based, non a tappeto.
**Why?** Il Protocollo Phoenix §4.5 prescrive supplementazione condizionale. "Supplemento X se marker Y < soglia Z" — l'app ha i biomarkers ma non genera raccomandazioni di supplementazione.
**For whom?** Utenti che inseriscono blood panels regolarmente.
**Success metric:** Raccomandazioni personalizzate basate su dati reali, zero supplementi non necessari.

---

## 2. Evidenza Scientifica

### 2.1 Protocollo Supplementazione Condizionale

| Integratore | Trigger | Dose | Evidenza | Note |
|-------------|---------|------|----------|------|
| **Vitamina D3** | 25(OH)D < 30 ng/mL | 2000-4000 IU/giorno + K2 (100-200 µg MK-7) | Holick 2007, Endocrine Society | Target: 40-60 ng/mL. K2 per direzionare calcio nelle ossa |
| **Omega-3** (EPA+DHA) | Omega-3 Index < 8% | 2-3g EPA+DHA/giorno | Harris 2018, VITAL trial | Target: Index ≥8%. Triglyceride form > ethyl ester |
| **Creatina monoidrato** | Tutti >40 anni | 3-5g/giorno (no loading) | Rawson & Volek 2003, Delpino 2022 | Neuroprotettivo + sarcopenia. No cycling needed |
| **Magnesio glicinato** | Sintomi sleep/crampi, o Mg <1.8 mg/dL | 200-400mg/giorno (sera) | Abbasi et al. 2012 | Glicinato per assorbimento + effetto calmante |
| **Ferro** | Ferritina <30 ng/mL | 65mg alternate-day | Stoffel et al. 2020 (Lancet) | **SOLO quando basso**. Alternate-day > daily per assorbimento. STOP quando ferritina >50 |
| **Collagene** | Tutti (prevenzione) | 15g + 50mg vitamina C, 30-60min pre-allenamento | Shaw et al. 2017 (AJCN) | Legamenti, tendini, articolazioni. Timing critico |
| **NMN** | Opzionale/sperimentale | 250-500mg/giorno | Yi et al. 2023 | **Sperimentale**. NAD+ booster. Dati umani limitati |
| **Resveratrolo** | **NON raccomandato** | — | Gliemann et al. 2013 | **Controproducente**: può annullare benefici dell'esercizio |

### 2.2 Adattogeni — Tradizione Russa (Brekman/Брехман)

La scienza degli adattogeni è stata sviluppata in URSS da Brekman negli anni '60-'70 per cosmonauti, atleti olimpici e militari. Composti con forte evidenza clinica assenti dalle liste occidentali:

| Integratore | Trigger/Uso | Dose | Evidenza | Note |
|-------------|-------------|------|----------|------|
| **Rhodiola rosea** | Alto carico training, fatica | 200mg acuto pre-workout / 600-1500mg/d cronico | Multiple RCTs, endurance + recovery | Ciclo 4 sett on / 2 off. Meglio per recreationally active |
| **Ecdysterone/Leuzea** (Левзея) | Supporto anabolico naturale | 200-800mg/d, cicli 8-12 sett | 50+ anni ricerca russa, pathway ERbeta/PI3K/Akt | NO soppressione ormonale, LD50 >9g/kg, non WADA-banned |
| **Schisandra chinensis** | Protezione epatica + cortisolo | 500-1000mg/d | RCTs, sinergico con Rhodiola | Unica combinazione fegato + cortisolo |

### 2.3 Composti TCM — Tradizione Cinese

| Integratore | Trigger/Uso | Dose | Evidenza | Note |
|-------------|-------------|------|----------|------|
| **Astragalus / Cycloastragenol** | Longevità (tutti >50) | 250-500mg/d standardizzato, min 6 mesi | **UNICO composto con RCT per attivazione telomerasi**. TA-65 meta-analysis: 8 RCTs, n=750, telomeri allungati >60 anni | GRAS status. Il composto longevità più unico da entrambe le tradizioni |
| **Cordyceps Cs-4** | VO2max, endurance | 3g/d, 6+ settimane | RCT: +10.5% soglia metabolica. Meta-analysis conferma VO2peak (p=0.04) | Meccanismo aerobico (diverso da creatina che è anaerobico). Usare SOLO Cs-4 fermentato, NON wild |
| **Reishi (Lingzhi)** | Immunomodulazione bidirezionale | 3-5g/d dual extract | Previene immunosoppressione da overtraining | Meccanismo unico: modula sia up che down |

### 2.4 NON Raccomandati
- **Resveratrolo**: Controproducente — annulla benefici esercizio (Gliemann 2013)
- **Eleuthero standalone**: Trials moderni rigorosi non trovano beneficio (nonostante hype sovietico)
- **Meldonium**: Bannato WADA dal 2016
- **NMN**: Sperimentale, dati umani limitati — categoria "opzionale/informativa"

### 2.5 Principi
1. **Biomarker-first**: Nessun integratore senza dati che lo giustifichino (eccetto creatina >40, collagene, e adattogeni in periodi alto carico)
2. **Dose-response**: Dose calibrata sul deficit, non dose massima per tutti
3. **Temporal**: Ferro alternate-day (Stoffel 2020), collagene pre-training, magnesio sera, adattogeni mattina
4. **Ciclizzazione** (principio russo/cinese): 4 settimane on / 2 off per adattogeni. NON uso cronico ininterrotto
5. **Exit criteria**: Quando il marker torna in range, ridurre o sospendere (eccetto creatina)
6. **Interazioni**: Ferro non con calcio/tè/caffè, Vitamina D con grassi
7. **Vitamina D dose cinese**: Il 63.2% degli adulti cinesi è insufficiente; anche 2000 IU/d non raggiunge 50 nmol/L nel 97.5% — alcune popolazioni possono necessitare dosi più alte

**Fonti russe**: Brekman, adaptogens; National Geographic "Before Steroids, Russians Studied Herbs"; Rhodiola rosea Effectiveness (PMC 9228580)
**Fonti cinesi**: TA-65 meta-analysis (8 RCTs); Cordyceps Cs-4 VO2max RCT; Reishi bidirectional immunomodulation

---

## 3. Technical Approach

### 3.1 Supplement Recommendation Engine

```dart
class SupplementEngine {
  /// Evaluate biomarkers and return active recommendations
  List<SupplementRecommendation> evaluate({
    required Map<String, double> biomarkers,
    required int age,
    required String sex,
  }) {
    final recs = <SupplementRecommendation>[];

    // Vitamin D
    final vitD = biomarkers['vitamin_d_25oh'];
    if (vitD != null && vitD < 30) {
      recs.add(SupplementRecommendation(
        name: 'Vitamina D3 + K2',
        reason: '25(OH)D = ${vitD.toStringAsFixed(1)} ng/mL (target: 40-60)',
        dose: vitD < 20 ? '4000 IU/giorno + K2 200µg' : '2000 IU/giorno + K2 100µg',
        timing: 'Con pasto contenente grassi',
        duration: 'Fino a 25(OH)D > 40 ng/mL',
        priority: vitD < 20 ? 'high' : 'medium',
        citation: 'Holick 2007, Endocrine Society Guidelines',
      ));
    }

    // Omega-3
    final omega3 = biomarkers['omega3_index'];
    if (omega3 != null && omega3 < 8) {
      recs.add(SupplementRecommendation(
        name: 'Omega-3 (EPA+DHA)',
        reason: 'Omega-3 Index = ${omega3.toStringAsFixed(1)}% (target: ≥8%)',
        dose: omega3 < 4 ? '3g EPA+DHA/giorno' : '2g EPA+DHA/giorno',
        timing: 'Con pasti (trigliceride form preferita)',
        duration: 'Fino a Omega-3 Index ≥ 8%',
        priority: omega3 < 4 ? 'high' : 'medium',
        citation: 'Harris 2018',
      ));
    }

    // Creatine (age-based, unconditional >40)
    if (age >= 40) {
      recs.add(SupplementRecommendation(
        name: 'Creatina monoidrato',
        reason: 'Età ≥40 — prevenzione sarcopenia e neuroprotezione',
        dose: '3-5g/giorno (no loading, no cycling)',
        timing: 'Qualsiasi momento della giornata',
        duration: 'Continuativo',
        priority: 'medium',
        citation: 'Rawson & Volek 2003, Delpino 2022',
      ));
    }

    // Iron (ONLY when low, with caution)
    final ferritin = biomarkers['ferritin'];
    if (ferritin != null && ferritin < 30) {
      recs.add(SupplementRecommendation(
        name: 'Ferro bisglicinate',
        reason: 'Ferritina = ${ferritin.toStringAsFixed(0)} ng/mL (target: 50-100)',
        dose: '65mg a giorni alterni (NOT daily)',
        timing: 'Stomaco vuoto, con vitamina C. NON con caffè/tè/calcio',
        duration: 'Fino a ferritina > 50 ng/mL, poi STOP',
        priority: ferritin < 15 ? 'high' : 'medium',
        citation: 'Stoffel et al. 2020 (Lancet)',
        warnings: ['Il ferro in eccesso è tossico. Controllare ferritina ogni 3 mesi.'],
      ));
    }

    // Magnesium
    final mg = biomarkers['magnesium'];
    if (mg != null && mg < 1.8) {
      recs.add(SupplementRecommendation(
        name: 'Magnesio glicinato',
        reason: 'Mg = ${mg.toStringAsFixed(1)} mg/dL (target: ≥1.8)',
        dose: '200-400mg/giorno',
        timing: 'Sera (30min prima di dormire)',
        duration: 'Fino a Mg ≥ 1.8 mg/dL',
        priority: 'medium',
        citation: 'Abbasi et al. 2012',
      ));
    }

    // Collagen (unconditional — joint/tendon health)
    recs.add(SupplementRecommendation(
      name: 'Collagene idrolizzato',
      reason: 'Prevenzione — salute tendini, legamenti, articolazioni',
      dose: '15g + 50mg vitamina C',
      timing: '30-60 minuti PRIMA dell\'allenamento',
      duration: 'Continuativo nei giorni di allenamento',
      priority: 'low',
      citation: 'Shaw et al. 2017 (AJCN)',
    ));

    return recs..sort((a, b) => _priorityOrder(a.priority) - _priorityOrder(b.priority));
  }

  int _priorityOrder(String p) => {'high': 0, 'medium': 1, 'low': 2}[p] ?? 3;
}

class SupplementRecommendation {
  final String name;
  final String reason;
  final String dose;
  final String timing;
  final String duration;
  final String priority;       // 'high' / 'medium' / 'low'
  final String citation;
  final List<String> warnings;

  SupplementRecommendation({
    required this.name,
    required this.reason,
    required this.dose,
    required this.timing,
    required this.duration,
    required this.priority,
    required this.citation,
    this.warnings = const [],
  });
}
```

### 3.2 Anti-Recommendation (Resveratrol Warning)

```dart
class SupplementWarnings {
  static const antiRecommendations = [
    AntiRecommendation(
      name: 'Resveratrolo',
      reason: 'Può annullare i benefici dell\'esercizio fisico (vasodilatazione, stress ossidativo adattivo)',
      citation: 'Gliemann et al. 2013',
      advice: 'NON assumere se ti alleni regolarmente. L\'esercizio è già il miglior "integratore".',
    ),
  ];
}
```

### 3.3 Integration with Biomarker Alerts

Il sistema di supplementazione si integra con `BiomarkerAlerts` esistente:
- Quando un alert scatta (es. ferritina bassa), l'engine genera la raccomandazione corrispondente
- Le raccomandazioni appaiono nella sezione Coach e nel BiomarkerDashboard

---

## 4. UI Changes

### 4.1 Supplement Card (BiomarkerDashboard)
- Sezione "Integratori Suggeriti" sotto i biomarker alerts
- Ogni card: nome, motivo (con valore attuale), dose, timing, citazione
- Colore priorità: rosso (high), giallo (medium), grigio (low)
- Tap → dettaglio con warnings e durata

### 4.2 Coach Integration
- Coach report settimanale include sezione integratori
- "Questa settimana: continua Vitamina D 4000 IU (25(OH)D era 22 ng/mL all'ultimo panel)"
- Warning: "Il tuo panel non include Omega-3 Index — chiedi al medico di aggiungerlo"

### 4.3 Missing Biomarker Prompts
- Se un biomarker rilevante non è mai stato inserito → suggerire di farlo
- "Non hai mai inserito la ferritina. Consideralo al prossimo esame del sangue."

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/supplement_engine.dart` | Create | SupplementEngine, SupplementRecommendation, AntiRecommendation |
| `features/biomarkers/widgets/supplement_card.dart` | Create | Supplement recommendation card |
| `features/biomarkers/biomarker_dashboard_tab.dart` | Modify | Add supplement section |
| `core/models/coach_prompts.dart` | Modify | Supplement-aware messages |
| `core/models/report_generator.dart` | Modify | Weekly report supplement section |

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Vitamin D low | vitD=22 | D3+K2 recommendation, high priority | High |
| UT-02 | Vitamin D adequate | vitD=45 | No D3 recommendation | High |
| UT-03 | Ferritin critical | ferritin=12 | Iron recommendation, high priority, warnings | High |
| UT-04 | Ferritin normal | ferritin=80 | No iron recommendation | High |
| UT-05 | Age 45 creatine | age=45 | Creatine recommended | High |
| UT-06 | Age 35 creatine | age=35 | No creatine | High |
| UT-07 | Multiple deficiencies | vitD=18, ferritin=14 | Both recommended, sorted by priority | Medium |
| UT-08 | No biomarkers | empty map | Only collagene + creatine if >40 | Medium |

---

## 7. Dipendenze

- **Biomarker system (esistente)**: Usa dati dal blood panel
- **BiomarkerAlerts (esistente)**: Si integra con gli alert esistenti
- **Indipendente** dalle fasi di training — può partire subito

---

**Attesa PROCEED.**
