# Feature: Advanced Fasting — Level 3 (Extended Fasts + FMD)

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Completare il sistema di digiuno con il Livello 3: digiuni estesi 72-120h e Fasting Mimicking Diet (FMD) secondo il protocollo ProLon di Valter Longo. Aggiungere safety thresholds, refeeding protocol strutturato, e supervisione medica obbligatoria.
**Why?** Il Protocollo Phoenix §4.1 prescrive 3 livelli di digiuno. L'app implementa solo L1 (16:8) e L2 (24-48h). L3 è il più potente per autofagia ma il più pericoloso — richiede guida strutturata.
**For whom?** Utenti avanzati che hanno completato L2 con successo e hanno approvazione medica.
**Success metric:** L3 accessibile con gate medico; FMD come alternativa; safety alerts automatici; refeeding guidato.

---

## 2. Evidenza Scientifica

### 2.1 Autofagia e Digiuno Esteso
- **Autophagy peaks**: I marcatori autofagici (LC3-II, p62) raggiungono il picco a **48-72h** nei modelli animali
- **Nota critica**: La maggior parte dei dati sono su modelli murini. Nei umani, marcatori indiretti (chetoni >3 mmol/L) suggeriscono autofagia attiva dopo 48h ma la conferma diretta è limitata
- **De Cabo & Mattson 2019** (NEJM): Review completa sui benefici del digiuno intermittente e esteso
- **Longo & Mattson 2014**: I cicli di digiuno promuovono rigenerazione delle cellule staminali immunitarie

### 2.2 FMD — Fasting Mimicking Diet
- **Brandhorst et al. 2015** (Cell Metabolism): 3 cicli FMD riducono IGF-1, glucosio a digiuno, CRP, pressione sanguigna
- **Protocollo ProLon** (Longo):
  - **Giorno 1**: ~1100 kcal (10% proteine, 56% grassi, 34% carboidrati)
  - **Giorni 2-5**: ~800 kcal (9% proteine, 44% grassi, 47% carboidrati)
  - Macro-composition specifica per mantenere le vie autofagiche attive nonostante l'assunzione calorica
- **Frequenza**: 1 ciclo ogni 2-3 mesi (massimo 4-6/anno)
- **Wei et al. 2017**: FMD riduce fattori di rischio per diabete, CVD, cancro e invecchiamento

### 2.3 Safety Thresholds
| Parametro | Soglia critica | Azione |
|-----------|---------------|--------|
| Glicemia | <54 mg/dL (3.0 mmol/L) | INTERROMPERE il digiuno immediatamente |
| Glicemia | 54-70 mg/dL | Warning + monitoraggio ogni 2h |
| Elettroliti | Sintomi (crampi, palpitazioni, confusione) | INTERROMPERE + elettroliti |
| Pressione | <90/60 mmHg con vertigini | INTERROMPERE |
| BMI | <18.5 | NON iniziare L3 |

### 2.4 Refeeding Syndrome
- **Rischio**: Dopo >48h digiuno, reintroduzione rapida di carboidrati può causare shift elettrolitico fatale (ipofosfatemia)
- **Prevenzione**: Reintroduzione graduale su 24-48h
- **Mehanna et al. 2008** (BMJ): Linee guida NICE per prevenzione refeeding syndrome

### 2.5 Tradizione Russa: РДТ — Razgruzochno-Dieticheskaya Terapiya (Nikolaev/Filonov)

La Russia ha una tradizione clinica unica di digiuno terapeutico (РДТ) sviluppata da Yuri Nikolaev negli anni '60-'80, con 22+ cliniche attive e 10.000+ pazienti documentati (Goryachinsk dal 1995). Riconosciuta ufficialmente dal Ministero della Salute russo nel 2005.

#### Tre Stadi Fisiologici (vs ore fisse occidentali)
| Stadio | Giorni | Segni | Significato |
|--------|--------|-------|-------------|
| 1. Eccitazione alimentare | 1-3 | Fame intensa, irritabilità, pensiero ossessivo sul cibo | Il corpo cerca ancora cibo esterno |
| 2. Acidosi crescente | 3-7 | Lingua bianca, alito acetonico, debolezza, poi miglioramento | Transizione a chetosi, autofagia attiva |
| 3. Compensazione | 6+ | **Crisi acidotica** poi improvviso benessere, lingua si schiarisce | Adattamento metabolico completo |

**Differenza critica**: Il framework russo determina quando interrompere il digiuno in base allo **stadio raggiunto**, non al tempo trascorso. La "crisi acidotica" (tipicamente giorno 7-10) è considerata la soglia necessaria per l'effetto terapeutico — concetto assente dalla letteratura occidentale.

#### Refeeding Russo: Durata = Durata Digiuno
- Il periodo di recupero **DEVE eguagliare** il periodo di digiuno (vs 24-48h occidentali)
- Progressione: succo diluito (giorni 1-2) → alimenti crudi grattugiati → porridge → cibo completo
- **Niente carne per minimo 7 giorni** post-digiuno
- **Giorni 4-6 post-digiuno**: periodo di pericolo per spike appetito estremo — l'app deve avvisare

#### Digiuno Frazionato (Filonov)
Ciclare attraverso digiuni più brevi progressivi con nutrizione ristorativa tra l'uno e l'altro:
- Ciclo 1: 5-7 giorni → renutrizione completa
- Ciclo 2: 7-9 giorni → renutrizione completa
- Ciclo 3: 9-11 giorni → renutrizione completa
- Ogni ciclo produce adattamento acidotico più rapido

**Fonti**: Nikolaev Five Stages of Fasting; Siberika Therapeutic Fasting Technique; Belovodie Medical Center; Ayurmedica Goryachinsk Clinic

### 2.6 Tradizione Cinese: 辟谷 (Bigu) — Digiuno Daoista

Il Bigu è una pratica daoista millenaria di digiuno che ha ricevuto validazione scientifica moderna.

#### Non è Digiuno ad Acqua Puro
Il Bigu mantiene <5% dell'apporto calorico da erbe medicinali, minerali e cibi crudi. Strutturalmente simile all'FMD di Longo ma sviluppato millenni prima.

#### Pathway Taurina-Microbioma (Journal of Nutrition 2021)
- Studio su 43 adulti sani: 5 giorni di Bigu
- **La taurina plasmatica spike del 31-46% al giorno 3**, inversamente correlata con glucosio e sintesi de novo colesterolo (P<0.001)
- Questa soglia di 3 giorni attiva un **loop regolatorio taurina-microbiota** — meccanismo nuovo non presente nei framework occidentali
- **Implicazione per Phoenix**: Il giorno 3 è un milestone metabolico da tracciare (non solo le ore)

#### Refeeding Cinese: 3× Durata
Ancora più conservativo del russo 1:1:
- 1 settimana di digiuno richiede 3 settimane di transizione alimentare
- Si inizia con zuppa di miglio (piccoli sorsi)
- **Meditazione/Qigong è REQUISITO**, non supplementare, per il digiuno esteso nella tradizione cinese

#### Frequenza
Massimo 2-3 cicli completi per anno (vs Longo 4-6/anno per FMD)

**Fonti**: Bigu Taurine Study (J Nutr 2021, PMID 33979839); Wang et al. Bigu Cohort Study (medRxiv 2020); Blood Pressure and Ketogenesis in Qigong Bigu (AEP 2021)

---

## 3. I 2 Protocolli Level 3

### 3.1 Extended Fast (72-120h)

**Prerequisiti:**
- L2 completato con successo (almeno 3 digiuni 48h con tolerance_score ≥ 3)
- Disclaimer medico firmato (specifico per L3)
- BMI ≥ 18.5

**Struttura:**
1. **Pre-fast (24h)**: Ultimo pasto ricco di grassi sani, ridurre carboidrati
2. **Digiuno (72-120h)**: Solo acqua, elettroliti (sodio, potassio, magnesio), caffè nero opzionale
3. **Monitoraggio**: Glicemia ogni 12h (input manuale), sintomi checklist
4. **Refeeding (24-48h)**:
   - Ora 0-6: Brodo osseo (200-300ml ogni 2h)
   - Ora 6-12: Verdure cotte morbide + proteine leggere (uova, pesce bianco)
   - Ora 12-24: Pasti normali piccoli, evitare zuccheri semplici
   - Ora 24-48: Ritorno graduale a porzioni normali

### 3.2 FMD — Fasting Mimicking Diet (5 giorni)

**Prerequisiti:**
- L2 completato (almeno 2 digiuni 24h+)
- Disclaimer medico firmato
- BMI ≥ 20

**Struttura:**
| Giorno | Kcal | Proteine | Grassi | Carb | Alimenti suggeriti |
|--------|------|----------|--------|------|--------------------|
| 1 | 1100 | 10% | 56% | 34% | Zuppe vegetali, olive, noci, crackers lino, tè verde |
| 2-5 | 800 | 9% | 44% | 47% | Zuppe vegetali, olive, kale chips, barrette noci, tè |

**Frequenza**: 1 ciclo ogni 2-3 mesi (max 4-6/anno)

---

## 4. Technical Approach

### 4.1 Data Model

```dart
class ExtendedFastConfig {
  final String protocol;        // 'extended_72h' / 'extended_96h' / 'extended_120h' / 'fmd_5day'
  final int targetHours;
  final bool medicalApproved;
  final DateTime? medicalApprovalDate;
  final List<RefeedingPhase> refeedingPlan;
}

class RefeedingPhase {
  final int hourStart;
  final int hourEnd;
  final String description;
  final List<String> allowedFoods;
  final String restrictions;
}

class FastingSafetyCheck {
  final DateTime timestamp;
  final double? glucoseMgDl;
  final List<String> symptoms;     // checklist items
  final bool shouldContinue;       // auto-computed from thresholds
  final String? warningMessage;
}
```

### 4.2 Safety Engine

```dart
class FastingSafetyEngine {
  /// Check if user can start L3
  CanStartResult canStartLevel3(UserProfile profile, FastingHistory history);

  /// Evaluate safety check
  SafetyVerdict evaluateCheck(FastingSafetyCheck check) {
    if (check.glucoseMgDl != null && check.glucoseMgDl! < 54) {
      return SafetyVerdict.stopImmediately(
        'Glicemia critica: ${check.glucoseMgDl} mg/dL. Interrompi il digiuno e assumi carboidrati.'
      );
    }
    if (check.glucoseMgDl != null && check.glucoseMgDl! < 70) {
      return SafetyVerdict.warning(
        'Glicemia bassa. Monitorare ogni 2h. Se scende sotto 54, interrompere.'
      );
    }
    // Symptom checks...
    return SafetyVerdict.ok;
  }

  /// Schedule next safety check reminder
  Duration nextCheckIn(int hoursElapsed) {
    if (hoursElapsed < 48) return Duration(hours: 12);
    return Duration(hours: 6);  // More frequent after 48h
  }
}
```

### 4.3 FMD Meal Plan

```dart
class FmdMealPlan {
  /// Generate meal plan for FMD day
  static FmdDayPlan forDay(int dayNumber, double weightKg) {
    final targetKcal = dayNumber == 1 ? 1100 : 800;
    // Generate meals within macro constraints
  }
}
```

### 4.4 Refeeding Guide

```dart
class RefeedingGuide {
  /// Get current refeeding phase based on hours since fast ended
  RefeedingPhase currentPhase(DateTime fastEndTime);

  /// Notification schedule for refeeding reminders
  List<ScheduledReminder> refeedingReminders(DateTime fastEndTime);
}
```

### 4.5 Database Changes

```sql
-- Extend fasting_sessions for L3
ALTER TABLE fasting_sessions ADD COLUMN protocol TEXT DEFAULT 'standard';
-- 'standard' / 'extended' / 'fmd'
ALTER TABLE fasting_sessions ADD COLUMN medical_approved INTEGER DEFAULT 0;
ALTER TABLE fasting_sessions ADD COLUMN refeeding_started_at INTEGER;
ALTER TABLE fasting_sessions ADD COLUMN refeeding_completed INTEGER DEFAULT 0;

-- Safety checks during extended fasts
CREATE TABLE fasting_safety_checks (
  id INTEGER PRIMARY KEY,
  session_id INTEGER NOT NULL,
  timestamp INTEGER NOT NULL,
  glucose_mg_dl REAL,
  symptoms_json TEXT,           -- ["crampi", "vertigini", ...]
  verdict TEXT NOT NULL,         -- 'ok' / 'warning' / 'stop'
  notes TEXT,
  FOREIGN KEY (session_id) REFERENCES fasting_sessions(id)
);

-- FMD day tracking
CREATE TABLE fmd_day_logs (
  id INTEGER PRIMARY KEY,
  session_id INTEGER NOT NULL,
  day_number INTEGER NOT NULL,  -- 1-5
  target_kcal INTEGER,
  actual_kcal_estimate INTEGER,
  meals_json TEXT,               -- [{description, kcal, protein_g, fat_g, carb_g}]
  compliance_score INTEGER,     -- 1-5
  FOREIGN KEY (session_id) REFERENCES fasting_sessions(id)
);
```

---

## 5. UI Changes

### 5.1 LevelsTab Update
- L3 card con lock: "Richiede 3+ digiuni L2 completati + approvazione medica"
- Sub-opzioni: "Digiuno Esteso 72h" / "Digiuno Esteso 96h" / "FMD 5 giorni"
- Medical disclaimer specifico (più severo del generico 90gg)

### 5.2 Extended Fast Timer
- Timer con milestone markers: 24h / 48h / 72h / 96h / 120h
- Safety check prompts ogni 6-12h (glicemia + sintomi checklist)
- Alert rosso se safety threshold superata
- Countdown a prossimo safety check

### 5.3 FMD Tracker
- 5 giorni con piano pasti per ogni giorno
- Macro target e compliance tracking
- Suggerimenti alimenti per ogni pasto

### 5.4 Refeeding Guide
- Post-fast: schermata dedicata con timeline refeeding
- Notifiche per ogni fase ("Ora 6: puoi introdurre verdure cotte")
- Checklist alimenti per fase

---

## 6. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/fasting_safety.dart` | Create | FastingSafetyEngine, SafetyVerdict, thresholds |
| `core/models/fmd_meal_plan.dart` | Create | FMD meal plans for 5 days |
| `core/models/refeeding_guide.dart` | Create | RefeedingGuide, phase timeline, reminders |
| `core/database/tables.dart` | Modify | fasting_safety_checks + fmd_day_logs tables, fasting_sessions columns |
| `core/database/database.dart` | Modify | Migration |
| `core/database/daos/fasting_dao.dart` | Modify | Safety check CRUD, FMD day logs, L3 eligibility query |
| `features/fasting/levels_tab.dart` | Modify | L3 card, medical gate, protocol selection |
| `features/fasting/extended_fast_screen.dart` | Create | Timer + safety checks + refeeding |
| `features/fasting/fmd_tracker_screen.dart` | Create | 5-day FMD with meal tracking |
| `features/fasting/widgets/refeeding_timeline.dart` | Create | Refeeding phase timeline widget |
| `features/fasting/widgets/safety_check_dialog.dart` | Create | Glucose + symptoms checklist dialog |
| `core/notifications/notification_service.dart` | Modify | Safety check + refeeding reminders |
| `core/models/coach_prompts.dart` | Modify | L3 fasting messages |

---

## 7. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Safety threshold critical | glucose=50 | stopImmediately | High |
| UT-02 | Safety threshold warning | glucose=65 | warning | High |
| UT-03 | Safety threshold OK | glucose=80 | ok | High |
| UT-04 | L3 eligibility - not ready | 1 L2 fast | canStart=false | High |
| UT-05 | L3 eligibility - ready | 3 L2 fasts, tolerance≥3 | canStart=true | High |
| UT-06 | FMD day 1 calories | Day 1 | targetKcal=1100 | High |
| UT-07 | FMD day 3 calories | Day 3 | targetKcal=800 | High |
| UT-08 | Refeeding phase 0-6h | 3h post-fast | "Brodo osseo" phase | High |
| UT-09 | BMI gate | BMI=17.5 | canStart=false | High |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Medical approval expired | >90 days | Re-approval required |
| EC-02 | User skips safety check | 12h without check | Escalating notifications |
| EC-03 | First L3 attempt | No prior L3 | Extra warnings + shorter target (72h recommended) |

---

## 8. Dipendenze

- **L2 fasting system**: Prerequisito funzionale (deve essere completato)
- **Fase C (Periodizzazione)**: Durante L3, allenamento deve essere ridotto o sospeso
- **Medical disclaimer system**: Già esistente, ma serve disclaimer specifico L3
- **Indipendente** dalle altre fasi di protocol completion

---

**Attesa PROCEED.**
