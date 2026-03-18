# Feature: Adaptive Profiles — Sex & Age Adaptations

**Status:** DRAFT
**Created:** 2026-03-14
**Approved:** —
**Completed:** —

---

## 1. Overview

**What?** Implementare adattamenti per sesso (ciclo mestruale, menopausa, gravidanza) e per età (decade-by-decade prescriptions) come prescritto dal Protocollo Phoenix §2.8 e §2.9.
**Why?** Un protocollo longevity che ignora le differenze fisiologiche per sesso e decade è incompleto. La periodizzazione, i carichi, i tempi di recupero e la nutrizione devono adattarsi.
**For whom?** Tutti gli utenti — ogni persona ha un'età e un sesso che influenzano la prescrizione ottimale.
**Success metric:** L'app adatta automaticamente volume, intensità, recupero, e nutrizione in base a profilo sesso/età.

---

## 2. Evidenza Scientifica

### 2.1 Adattamenti per Sesso

#### Ciclo Mestruale e Performance
- **McNulty et al. 2020** (Sports Medicine, meta-analysis): L'effetto del ciclo mestruale sulla performance è **triviale** (effect size <0.1). Non ci sono fasi "buone" o "cattive" per allenarsi
- **Raccomandazione**: NON imporre restrizioni basate sul ciclo. Offrire il tracking come strumento di consapevolezza, ma non modificare automaticamente l'allenamento
- **Eccezione**: Se l'utente riporta sintomi severi (dismenorrea, affaticamento marcato), suggerire riduzione volume quel giorno

#### Donne e Allenamento di Forza
- **Huiberts et al. 2024**: L'interferenza concurrent training (forza + cardio) è **minima nelle donne** — possono fare entrambi nella stessa sessione
- **Raccomandazione**: Non separare obbligatoriamente forza/cardio per donne

#### Menopausa
- **Kemmler et al. 2020**: Post-menopausa richiede carico ≥70% 1RM per mantenere densità ossea
- **Shojaa et al. 2020**: L'allenamento ad alta intensità è sicuro e più efficace di bassa intensità per donne post-menopausa
- **Raccomandazione**: Per donne >50, prioritizzare carichi pesanti (non ridurre per "sicurezza")

#### TRE e Testosterone
- **Moro et al. 2016**: TRE 16:8 può ridurre testosterone nei maschi magri (~15%)
- **Clinicamente**: Effetto statisticamente significativo ma clinicamente trascurabile nella maggior parte dei casi
- **Raccomandazione**: Monitorare testosterone nei biomarkers, non modificare protocollo TRE

### 2.2 Adattamenti per Età

#### Framework Decade-by-Decade (Fragala et al. 2019, NSCA Position Statement)

| Decade | Volume | Recupero | Rep Range | Focus | Rischio Infortunio |
|--------|--------|----------|-----------|-------|-------------------|
| 18-29 | 16-20 set/muscolo/sett | 48h tra stessi muscoli | 6-15 | Costruire base, peak performance | Basso — tecnica è il focus |
| 30-39 | 14-18 set/muscolo/sett | 48-72h | 6-12 | Mantenere massa, prevenire sarcopenia | Basso-medio |
| 40-49 | 12-16 set/muscolo/sett | 72h | 8-12 | Densità ossea, mobilità, contrastare declino | Medio — articolazioni |
| 50-59 | 10-14 set/muscolo/sett | 72-96h | 8-15 | Equilibrio, prevenzione cadute, massa muscolare | Medio-alto |
| 60-69 | 8-12 set/muscolo/sett | 96h | 10-15 | Funzionalità quotidiana, equilibrio, mobilità | Alto |
| 70+ | 6-10 set/muscolo/sett | 96-120h | 12-20 | Prevenzione cadute, indipendenza | Alto — supervisione |

#### VO2max Decline
- **Hawkins & Wiswell 2003**: Declino ~10%/decade dopo i 30 in sedentari, ~5-6.5%/decade in allenati
- L'allenamento HIIT è il **miglior intervento** per rallentare il declino (Milanović et al. 2015)
- **Raccomandazione**: HIIT rimane nel protocollo per TUTTE le età, con adattamento intensità

#### Sarcopenia
- **Cruz-Jentoft et al. 2019** (EWGSOP2): Perdita massa muscolare inizia a ~40, accelera dopo 60
- Allenamento di forza ad alta intensità è l'intervento primario
- **Raccomandazione**: NON ridurre intensità con l'età — ridurre volume e aumentare recupero

### 2.3 Tradizione Russa: Seluyanov e Metodo Statodinamico

#### Seluyanov (Селуянов В.Н.) — Ipertrofia Fibre Lente
Il professor Seluyanov ha sviluppato un metodo specificamente per fibre muscolari a contrazione lenta, ignorato dall'Occidente:
- **Parametri**: 20-40% 1RM, tempo super-lento, set 30-60s, tensione continua (no lockout)
- **Risultati documentati**: +25.6% 1RM in 6 settimane, +20% soglia anaerobica in 8 settimane
- **Perché è rilevante per longevità**: Le fibre lente sono quelle che declinano meno con l'età ma vengono ignorate dal training occidentale (che si focalizza su fibre veloci/ipertrofia)
- **Tier riabilitazione**: 10-25% 1RM — efficace per anziani e infortunati, aumenta flusso sanguigno senza stress articolare
- **Warning glicolitico**: Seluyanov avvertiva esplicitamente che sovraccarico lattico (>15 mmol/L) **danneggia i mitocondri** — contraddice l'approccio occidentale "HIIT per tutto" e si allinea con la scienza della longevità

#### Protocollo Mitocondriale (Seluyanov Protocollo 3)
- 10-20% 1RM con circuiti intervallati
- Costruisce densità mitocondriale senza stress cardiovascolare
- **Complementare ai protocolli digiuno/autofagia** di Phoenix

**Fonti**: Seluyanov, "Preparazione Fisica nella Lotta", RGUFKSMiT; sistema GTO norme nazionali per età/sesso

### 2.4 Tradizione Cinese: Tai Chi, Baduanjin, Yijinjing

#### Yijinjing — Migliore Esercizio Singolo per Densità Ossea
- **Superiore a Tai Chi e Baduanjin** per colonna lombare (+0.07-0.08 g/cm²) e collo del femore
- Largamente sconosciuto in Occidente
- **Baduanjin + supplementazione calcio** produce gli effetti BMD più forti (SMD = 3.77 per collo del femore)

#### Tai Chi — Dati Dose-Risposta Precisi
- **24-form Yang-style**: riduce cadute del 41% a ≥3 ore/settimana
- Baduanjin (八段锦) fattibile anche per pre-fragili
- **Attivazione duale mTOR + AMPK**: questi esercizi attivano simultaneamente sintesi proteica E pulizia autofagica/mitocondriale. Il training occidentale attiva principalmente solo mTOR. L'attivazione duale è più allineata con gli obiettivi di longevità
- **Tai Chi aumenta l'attività della telomerasi** via upregulation di SOD e GPx

#### Implicazione per Phoenix
Per utenti >50-60 anni, il protocollo potrebbe suggerire Tai Chi/Baduanjin come mobility work (Fase G) con benefici aggiuntivi su BMD, equilibrio e telomerasi — NON come sostituto della forza, ma come complemento

**Fonti**: Meta-analisi Tai Chi cadute; Yijinjing BMD studies; Baduanjin + calcium (Frontiers); Tai Chi telomerase activity

---

## 3. Technical Approach

### 3.1 Profile Model Extension

```dart
// Extend existing user profile
class AdaptiveProfile {
  final String biologicalSex;      // 'male' / 'female' / 'prefer_not_to_say'
  final int age;
  final DateTime birthDate;
  final bool? isPostMenopausal;    // Female only
  final bool? tracksCycle;         // Female only, opt-in

  String get decade => '${(age ~/ 10) * 10}s';  // '30s', '40s', etc.
}
```

### 3.2 Age Adaptation Engine

```dart
class AgeAdaptation {
  /// Get training parameters adapted for age
  static AgeParams forAge(int age) {
    if (age < 30) return AgeParams(
      weeklySetMultiplier: 1.0,
      recoveryHours: 48,
      repRangeLow: 6, repRangeHigh: 15,
      warmupMinutes: 5,
      mobilityPriority: 'standard',
    );
    if (age < 40) return AgeParams(
      weeklySetMultiplier: 0.9,
      recoveryHours: 60,
      repRangeLow: 6, repRangeHigh: 12,
      warmupMinutes: 7,
      mobilityPriority: 'standard',
    );
    if (age < 50) return AgeParams(
      weeklySetMultiplier: 0.8,
      recoveryHours: 72,
      repRangeLow: 8, repRangeHigh: 12,
      warmupMinutes: 10,
      mobilityPriority: 'elevated',
    );
    if (age < 60) return AgeParams(
      weeklySetMultiplier: 0.7,
      recoveryHours: 84,
      repRangeLow: 8, repRangeHigh: 15,
      warmupMinutes: 10,
      mobilityPriority: 'high',
    );
    if (age < 70) return AgeParams(
      weeklySetMultiplier: 0.6,
      recoveryHours: 96,
      repRangeLow: 10, repRangeHigh: 15,
      warmupMinutes: 12,
      mobilityPriority: 'critical',
    );
    return AgeParams(
      weeklySetMultiplier: 0.5,
      recoveryHours: 108,
      repRangeLow: 12, repRangeHigh: 20,
      warmupMinutes: 15,
      mobilityPriority: 'critical',
    );
  }
}

class AgeParams {
  final double weeklySetMultiplier;  // Applied to base volume
  final int recoveryHours;           // Min hours between same muscle group
  final int repRangeLow;
  final int repRangeHigh;
  final int warmupMinutes;
  final String mobilityPriority;     // 'standard' / 'elevated' / 'high' / 'critical'
}
```

### 3.3 Sex-Specific Adaptations

```dart
class SexAdaptation {
  /// Training modifications for biological sex
  static SexParams forProfile(AdaptiveProfile profile) {
    if (profile.biologicalSex == 'female') {
      return SexParams(
        canCombineStrengthCardio: true,  // No concurrent interference
        minimumLoadPercent: profile.isPostMenopausal == true ? 70 : null,
        cycleSymptomsCheck: profile.tracksCycle == true,
        nutritionNotes: _femalNutritionNotes(profile),
      );
    }
    return SexParams(
      canCombineStrengthCardio: false,  // Standard split
      minimumLoadPercent: null,
      cycleSymptomsCheck: false,
      nutritionNotes: _maleNutritionNotes(profile),
    );
  }

  static List<String> _femalNutritionNotes(AdaptiveProfile p) {
    final notes = <String>[];
    if (p.isPostMenopausal == true) {
      notes.add('Calcio: ≥1200mg/giorno (vs 1000mg standard)');
      notes.add('Vitamina D: monitorare più frequentemente');
    }
    notes.add('Ferro: monitorare ferritina (mestruazioni → rischio anemia)');
    return notes;
  }

  static List<String> _maleNutritionNotes(AdaptiveProfile p) {
    return [
      'TRE 16:8 può ridurre testosterone (~15%) — monitorare nei biomarkers',
    ];
  }
}
```

### 3.4 Cycle Tracking (Opt-in)

```dart
class CycleTracker {
  /// Log cycle day (opt-in, no automatic training changes)
  Future<void> logCycleDay(DateTime date, CyclePhase phase);

  /// Get current cycle phase if tracking
  CyclePhase? currentPhase(DateTime date);

  /// Suggest (not enforce) based on symptoms reported today
  String? symptomBasedSuggestion(List<String> symptoms) {
    if (symptoms.contains('severe_fatigue') || symptoms.contains('severe_cramps')) {
      return 'Considera una sessione più leggera oggi — il tuo corpo ti sta parlando.';
    }
    return null;  // No modification — train as planned
  }
}

enum CyclePhase { menstrual, follicular, ovulatory, luteal }
```

### 3.5 Integration Points

```dart
// WorkoutGenerator receives age/sex adaptations
class WorkoutGenerator {
  WorkoutPlan generateForDay({
    required int weekday,
    required String tier,
    required String equipment,
    required AdaptiveProfile profile,  // NEW
    double volumeMultiplier = 1.0,     // From HRV (Phase H)
  }) {
    final ageParams = AgeAdaptation.forAge(profile.age);
    final sexParams = SexAdaptation.forProfile(profile);

    // Apply age volume multiplier
    final adjustedSets = (baseSets * ageParams.weeklySetMultiplier * volumeMultiplier).round();

    // Clamp reps to age-appropriate range
    final reps = reps.clamp(ageParams.repRangeLow, ageParams.repRangeHigh);

    // Post-menopausal minimum load
    if (sexParams.minimumLoadPercent != null) {
      loadPercent = max(loadPercent, sexParams.minimumLoadPercent!);
    }
  }
}
```

### 3.6 Database Changes

```sql
-- Extend user_settings
-- (settings_json already exists, add fields):
-- "biological_sex": "male"/"female"/"prefer_not_to_say"
-- "is_post_menopausal": true/false
-- "tracks_cycle": true/false

-- Cycle tracking (opt-in)
CREATE TABLE cycle_log (
  id INTEGER PRIMARY KEY,
  date INTEGER NOT NULL UNIQUE,
  phase TEXT NOT NULL,          -- 'menstrual'/'follicular'/'ovulatory'/'luteal'
  symptoms_json TEXT,           -- ["cramps", "fatigue", ...]
  notes TEXT
);
```

---

## 4. UI Changes

### 4.1 Onboarding Addition
- Step aggiuntivo: Sesso biologico (male/female/prefer not to say)
- Se female: "Desideri tracciare il ciclo mestruale?" (opt-in)
- Se female >45: "Sei in menopausa o post-menopausa?"
- Età calcolata automaticamente dalla data di nascita (già presente)

### 4.2 Settings
- Sezione "Profilo Adattivo" con:
  - Sesso biologico (modificabile)
  - Tracking ciclo on/off
  - Stato menopausa
  - Info: "L'app adatta volume, recupero e warmup in base alla tua età"

### 4.3 Cycle Tracking (se attivo)
- In Today Screen: badge opzionale con fase ciclo
- Input rapido: "Oggi: follicolare / mestruale / ..."
- Se sintomi severi riportati: coach suggerisce (non impone) riduzione

### 4.4 Coach Messages Age-Aware
- "A 55 anni, il warmup è fondamentale. I tuoi 10 minuti di mobilità proteggono le articolazioni."
- "Dopo i 40, la densità ossea è una priorità. I carichi pesanti sono il tuo alleato."
- Post-menopausa: "Con carico ≥70% 1RM stai investendo nella densità ossea."

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/adaptive_profile.dart` | Create | AdaptiveProfile, AgeAdaptation, SexAdaptation, AgeParams, SexParams |
| `core/models/cycle_tracker.dart` | Create | CycleTracker, CyclePhase, opt-in tracking |
| `core/database/tables.dart` | Modify | Add cycle_log table |
| `core/database/database.dart` | Modify | Migration |
| `core/database/daos/cycle_dao.dart` | Create | CRUD cycle entries |
| `core/models/workout_generator.dart` | Modify | Accept AdaptiveProfile, apply age/sex multipliers |
| `core/models/coach_prompts.dart` | Modify | Age-aware and sex-aware messages |
| `features/onboarding/onboarding_screen.dart` | Modify | Add sex/menopause step |
| `core/models/settings_notifier.dart` | Modify | Add adaptive profile fields |

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Age params 25yo | age=25 | multiplier=1.0, recovery=48h, warmup=5min | High |
| UT-02 | Age params 55yo | age=55 | multiplier=0.7, recovery=84h, warmup=10min | High |
| UT-03 | Age params 72yo | age=72 | multiplier=0.5, recovery=108h, warmup=15min | High |
| UT-04 | Post-menopausal min load | female, postMeno=true | minimumLoadPercent=70 | High |
| UT-05 | Cycle no auto-change | phase=menstrual, no symptoms | No training modification | High |
| UT-06 | Cycle with severe symptoms | severe_cramps | Suggestion message returned | Medium |
| UT-07 | Male TRE note | male | Testosterone monitoring note | Medium |

### Edge Cases
| ID | Scenario | Condition | Expected behavior |
|----|----------|-----------|-------------------|
| EC-01 | Sex not disclosed | prefer_not_to_say | Default male parameters (no cycle, no menopause) |
| EC-02 | Age 17 | Below 18 | Use 18-29 params |
| EC-03 | Cycle tracking disabled mid-use | tracks_cycle toggled off | Stop showing cycle UI, keep historical data |

---

## 7. Dipendenze

- **Fase C (Periodizzazione)**: Age multipliers si applicano al volume generato dalla periodizzazione
- **Fase G (Warmup/Mobility)**: Durata warmup usa ageParams.warmupMinutes
- **Fase H (HRV)**: volumeMultiplier combinato con age multiplier
- **Può partire in parallelo** con le altre fasi — solo configurazione e calcolo

---

**Attesa PROCEED.**
