# Feature: Sleep Environment Optimization

**Status:** COMPLETED
**Created:** 2026-03-14
**Approved:** 2026-03-14
**Completed:** 2026-03-14

---

## 1. Overview

**What?** Trasformare il sleep tracking da semplice input orari/qualità a un sistema proattivo di ottimizzazione del sonno con reminder ambiente, cutoff automatici, e coaching evidence-based.
**Why?** Il Protocollo Phoenix §3.6 prescrive temperatura 18-19°C, eliminazione luce blu, cutoff caffeina/alcol. L'app traccia solo orari e qualità ma non guida l'utente verso un ambiente di sonno ottimale.
**For whom?** Tutti gli utenti — il sonno è il pilastro fondamentale di recovery.
**Success metric:** Reminder automatici pre-sonno; quality score migliorato nel tempo; utente riceve coaching ambientale.

---

## 2. Evidenza Scientifica

### 2.1 Temperatura
- **Okamoto-Mizuno et al. 2012**: 18-19°C è l'optimum per qualità del sonno
- **Harding et al. 2019**: Temperature >24°C riducono il sonno REM del 30%
- **Raccomandazione**: Reminder serale "Imposta la camera a 18-19°C"

### 2.2 Luce Blu
- **Chang et al. 2015** (PNAS): Schermi LED prima di dormire riducono melatonina del 55%, ritardano il sonno di 10min, riducono REM
- **Cutoff**: 2h prima del bedtime (es. se bedtime=23:00 → reminder alle 21:00)
- **Raccomandazione**: Notifica "Luce blu: spegni schermi o attiva filtro"

### 2.3 Caffeina
- **Drake et al. 2013** (JCSM): Caffeina 6h prima riduce sonno di 1h; effetti misurabili fino a 8-10h
- **Cutoff**: 8-10h prima del bedtime (es. bedtime=23:00 → ultima caffeina 13:00-15:00)
- **Raccomandazione**: Notifica mattutina "Ultimo caffè entro le 13:00"

### 2.4 Alcol
- **Ebrahim et al. 2013** (Alcoholism C&E Research): L'alcol sopprime REM del 10-20% anche a dosi moderate
- **Protocollo**: Zero alcol ideale. Se consumato, almeno 4h prima del sonno
- **Raccomandazione**: Informazione nel coaching, non reminder (non siamo moralisti)

### 2.5 Routine Pre-Sonno
- **Irish et al. 2015**: Una routine pre-sonno consistente migliora la latenza del sonno di 20-30min
- **Raccomandazione**: "Routine serale" checklist opzionale

### 2.6 Tradizione Cinese: Orologio degli Organi e Zi Wu Jiao

#### Orologio degli Organi (子午流注 — Zi Wu Liu Zhu)
Il TCM divide le 24 ore in finestre di 2 ore per organo. Le più rilevanti per il sonno:
- **23:00-01:00 (Cistifellea)**: Deve essere in **sonno profondo**, non solo "a letto". Mancando questa finestra si compromette metabolismo biliare e regolazione emotiva
- **01:00-03:00 (Fegato)**: Picco detossificazione epatica. Svegliarsi in questa finestra è associato a stress emotivo non processato. Corrisponde al picco secrezione melatonina
- **21:00-23:00 (Triplice Riscaldatore)**: Finestra esplicita per il wind-down — regolazione endocrina e metabolica
- **Differenza pratica**: Il framework cinese prescrive di essere **addormentati entro le 23:00**, non semplicemente "a letto entro le 22:30"

#### Zi Wu Jiao (子午觉) — Protocollo Nap Specifico
- **Regola**: Dormire a Zi (23-01) per sonno notturno, nap a Wu (11-13) per recovery diurno
- **Durata nap**: 15-30 minuti MASSIMO (mai >1 ora)
- **Evidenza (PubMed-indexed cohort studies)**: Nella popolazione anziana cinese, napping pomeridiano correlato con migliori orientamento, linguaggio e memoria. Nap <30min = rischio più basso di declino cognitivo. Nap >60min = rischio AUMENTATO
- **Cardiovascolare**: Sonno notturno insufficiente + nap moderato NON aumenta rischio CVD, mentre sonno insufficiente da solo sì. Il nap strategico compensa parzialmente notti corte

#### Pao Jiao (泡脚) — Bagno Piedi Caldo Pre-Sonno
- **Protocollo**: Piedi in acqua 40-50°C per 20 minuti, ~1 ora prima di dormire
- **Meccanismo**: Vasodilatazione nei piedi drena sangue dal core → accelera il calo di temperatura centrale che triggera l'addormentamento. Meccanismo inverso ma complementare a "camera fredda"
- **Base**: Documentato nell'Huangdi Neijing (2.500+ anni). Praticato in tutta la Cina
- **Evidenza**: Meta-analisi TCM herbal bath therapy for insomnia (PMC 7373592). Meccanismo termoregolatorio validato — allineato con ricerca occidentale che mostra bagno caldo 1-2h prima migliora latenza sonno di ~10 minuti

#### Suan Zao Ren Tang (SZRT) — Formula Erboristica Sonno
- Composizione: Seme di giuggiola acida + Poria + Lovage + Anemarrhena + Liquirizia
- **Meccanismo**: Modulazione GABAergica e serotoninergica via jujuboside A, spinosin, sanjoinine A
- **Evidenza**: Meta-analysis 13 RCT, 1.454 pazienti — SZRT monoterapia superiore a placebo (P<0.01), meno effetti collaterali del diazepam
- **Rilevanza per Phoenix**: Alternativa naturale, non-dipendenza alla melatonina. Da menzionare nel coaching come opzione

### 2.7 Tradizione Russa: 6 Cronotopi e Adattogeni Mattutini

#### Putilov — 6 Cronotopi (vs 2 Occidentali)
Arcady Putilov (Accademia Russa delle Scienze, Novosibirsk) ha identificato 6 cronotopi con il modello LIVEMAN:
| Tipo | Pattern | Implicazione Training |
|------|---------|----------------------|
| **L**ethargic | Allerta permanentemente bassa | Sessioni brevi, recovery focus |
| **I**nconclusive | Nessun pattern chiaro | Flessibilità orari |
| **V**igilant | Allerta permanentemente alta | Può allenarsi in qualsiasi momento |
| **E**vening (gufo) | Allerta crescente verso sera | Training pomeridiano/serale |
| **M**orning (allodola) | Allerta decrescente | Training mattutino |
| **A**fternoon | Picco allerta nel pomeriggio | Training primo pomeriggio |
| **N**apping | Calo allerta nel pomeriggio | **Beneficia più dal Zi Wu Jiao** (nap 11-13) |

**Implicazione per Phoenix**: Il tipo "Napping" beneficia specificamente dal protocollo cinese Zi Wu Jiao. Il tipo "Afternoon" deve EVITARE i nap. Il timing dell'allenamento potrebbe essere personalizzato per cronotipo.

#### Stack Adattogeni Mattutini per Sonno Notturno
- **ADAPT-232** (formula sovietica declassificata): Rhodiola + Schisandra + Eleuthero
- Sviluppata dal Ministero della Difesa URSS per cosmonauti e atleti olimpici
- **Meccanismo paradossale**: Assunta al MATTINO, migliora il sonno NOTTURNO — gli adattogeni modulano l'asse HPA, riducono spike cortisolo diurno → miglior declino cortisolico serale → addormentamento più rapido
- **NON prendere prima di dormire** — l'effetto è indiretto via regolazione stress diurno

#### Raccomandazioni Sonno Atleti Russi
- **Durata**: 8+ ore MINIMO. Atleti con <8h hanno rischio infortunio 1.7× maggiore
- **Blocchi training pesante**: 9-10 ore raccomandate per atleti elite
- **Nap diurno**: La medicina sportiva russa raccomanda esplicitamente nap anche dopo notte completa — "effetto positivo addizionale" sul recovery
- **Temperatura**: 18-22°C (range più ampio dell'occidentale 18-19°C). Standard GOST/SanPiN specificano 20-22°C

**Fonti russe**: Putilov 6 chronotypes (PubMed 34372716); Sleep of Professional Athletes (ns03.ru); ADAPT-232 Soviet research
**Fonti cinesi**: Chinese Body Clock (ResearchGate); Napping and Cognitive Function (PMC 7839842); SZRT meta-analysis (Frontiers Pharmacology); Pao Jiao (PMC 7373592)

---

## 3. Technical Approach

### 3.1 Sleep Environment Config

```dart
class SleepEnvironment {
  final TimeOfDay targetBedtime;       // User's target bedtime
  final TimeOfDay targetWakeTime;      // User's target wake time
  final bool blueLightReminder;        // Enable blue light cutoff reminder
  final bool caffeineReminder;         // Enable caffeine cutoff reminder
  final bool temperatureReminder;      // Enable room temp reminder
  final int blueLightCutoffHours;      // Default 2h before bedtime
  final int caffeineCutoffHours;       // Default 10h before bedtime

  TimeOfDay get blueLightCutoff =>
    _subtractHours(targetBedtime, blueLightCutoffHours);

  TimeOfDay get caffeineCutoff =>
    _subtractHours(targetBedtime, caffeineCutoffHours);
}
```

### 3.2 Sleep Coaching

```dart
class SleepCoach {
  /// Generate evening coaching based on settings and history
  List<SleepTip> eveningTips(SleepEnvironment env, SleepHistory history) {
    final tips = <SleepTip>[];

    // Temperature
    if (env.temperatureReminder) {
      tips.add(SleepTip(
        icon: '🌡️',
        message: 'Camera a 18-19°C per sonno ottimale',
        citation: 'Okamoto-Mizuno 2012',
      ));
    }

    // Quality trend
    final avgQuality = history.averageQuality7Days;
    if (avgQuality < 3.0) {
      tips.add(SleepTip(
        message: 'La qualità del sonno è in calo. Prova a mantenere orari più regolari.',
        priority: 'high',
      ));
    }

    // Regularity
    if (history.regularityScore == 'low') {
      tips.add(SleepTip(
        message: 'Variazione orari >60min negli ultimi 7gg. La regolarità è il fattore #1.',
      ));
    }

    return tips;
  }
}
```

### 3.3 Notification Schedule

```dart
class SleepNotificationScheduler {
  /// Schedule all sleep-related notifications based on bedtime
  Future<void> scheduleFor(SleepEnvironment env) async {
    // Caffeine cutoff (morning notification)
    if (env.caffeineReminder) {
      await _schedule(
        time: env.caffeineCutoff,
        title: 'Ultimo caffè',
        body: 'Dopo le ${_format(env.caffeineCutoff)} la caffeina interferisce con il sonno',
      );
    }

    // Blue light cutoff (evening)
    if (env.blueLightReminder) {
      await _schedule(
        time: env.blueLightCutoff,
        title: 'Blue Light Off',
        body: 'Spegni schermi o attiva filtro luce blu — il sonno inizia ora',
      );
    }

    // Temperature reminder (30min before bedtime)
    if (env.temperatureReminder) {
      await _schedule(
        time: _subtractMinutes(env.targetBedtime, 30),
        title: 'Camera pronta',
        body: 'Imposta la camera a 18-19°C e oscura le luci',
      );
    }
  }
}
```

### 3.4 Integration with Existing SleepTab

Il SleepTab attuale traccia bedtime/wake/quality. Aggiungiamo:
- Sezione "Ambiente" con toggle per ogni reminder
- Bedtime/wake time picker (già parzialmente presente) → diventa il source per i cutoff
- Evening coaching card con tips personalizzati

---

## 4. UI Changes

### 4.1 SleepTab Enhancement
- **Sezione "Ambiente Sonno"**: 3 toggle (luce blu, caffeina, temperatura) con orari calcolati
- **Evening Tips Card**: Coaching tips basati su trend qualità + ambiente
- **Target Bedtime/Wake**: Time picker che alimenta il sistema di cutoff

### 4.2 Settings Integration
- In Settings → Notifiche: sezione "Sonno" con toggle granulari
- "Bedtime target" e "Wake target" configurabili

### 4.3 Coach Messages
- Mattutino (se caffeina reminder attivo): "Ultimo caffè entro le 13:00 — proteggi il sonno di stasera"
- Serale: "Tra 30 minuti è bedtime. Camera a 18-19°C, schermi off."

---

## 5. Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `core/models/sleep_environment.dart` | Create | SleepEnvironment config, SleepCoach, cutoff calculations |
| `features/conditioning/sleep_tab.dart` | Modify | Add environment section, evening tips, target bedtime picker |
| `core/notifications/notification_scheduler.dart` | Modify | Add caffeine/blue light/temperature reminders |
| `core/models/settings_notifier.dart` | Modify | Sleep environment settings |
| `core/models/coach_prompts.dart` | Modify | Sleep-aware morning/evening messages |

---

## 6. Test Specification

### Unit Tests
| ID | What I'm testing | Input | Expected | Priority |
|----|------------------|-------|----------|----------|
| UT-01 | Blue light cutoff | bedtime=23:00, cutoff=2h | 21:00 | High |
| UT-02 | Caffeine cutoff | bedtime=23:00, cutoff=10h | 13:00 | High |
| UT-03 | Caffeine cutoff wraps | bedtime=22:00, cutoff=10h | 12:00 | High |
| UT-04 | Low quality tips | avg_quality=2.5 | High-priority regularity tip | Medium |

---

## 7. Dipendenze

- **SleepTab (esistente)**: Si estende, non si riscrive
- **NotificationScheduler (esistente)**: Aggiunge nuovi tipi di notifica
- **Indipendente** dalle altre fasi

---

**Attesa PROCEED.**
