/// Biomarker-triggered conditional supplementation engine.
///
/// Three-tradition evidence base:
/// Western: Holick 2007, Harris 2018, Rawson & Volek 2003, Delpino 2022,
///          Stoffel 2020 (Lancet), Shaw 2017 (AJCN), Gliemann 2013
/// Russian: Brekman adaptogens, ADAPT-232, Rhodiola rosea (PMC 9228580),
///          Ecdysterone/Leuzea (50+ years research)
/// Chinese: TA-65 meta-analysis (8 RCTs), Cordyceps Cs-4 VO2max RCT,
///          Reishi bidirectional immunomodulation
///
/// Principles:
/// 1. Biomarker-first: no supplement without data (except creatine >40,
///    collagen, adaptogens in high-load periods)
/// 2. Dose-response: calibrated on deficit, not max dose
/// 3. Temporal: iron alternate-day, collagen pre-training, Mg evening,
///    adaptogens morning
/// 4. Cycling (Russian/Chinese): 4 weeks on / 2 off for adaptogens
/// 5. Exit criteria: when marker returns to range, reduce or stop
class SupplementEngine {
  const SupplementEngine();

  /// Evaluate biomarkers and return active recommendations, sorted by priority.
  ///
  /// [trainingLoad] is optional: 'high', 'moderate', 'low'. When 'high',
  /// adaptogens are recommended with higher priority.
  List<SupplementRecommendation> evaluate({
    required Map<String, double> biomarkers,
    required int age,
    required String sex,
    String trainingLoad = 'moderate',
  }) {
    final recs = <SupplementRecommendation>[];

    // ── Western supplements ──────────────────────────────────────

    // Vitamin D3 + K2
    final vitD = biomarkers['vitamin_d_25oh'];
    if (vitD != null && vitD < 30) {
      recs.add(SupplementRecommendation(
        name: 'Vitamina D3 + K2',
        tradition: SupplementTradition.western,
        reason: '25(OH)D = ${vitD.toStringAsFixed(1)} ng/mL (target: 40-60)',
        dose: vitD < 20
            ? '4000 IU/giorno + K2 200\u00b5g MK-7'
            : '2000 IU/giorno + K2 100\u00b5g MK-7',
        timing: 'Con pasto contenente grassi',
        exitCriteria: '25(OH)D > 40 ng/mL',
        cycling: 'Continuativo fino a target raggiunto',
        priority: vitD < 20
            ? SupplementPriority.high
            : SupplementPriority.medium,
        citation: 'Holick 2007, Endocrine Society',
        notes: [
          'K2 direziona il calcio nelle ossa, non nelle arterie.',
          '63.2% degli adulti cinesi \u00e8 insufficiente; alcune popolazioni necessitano dosi pi\u00f9 alte.',
        ],
      ));
    }

    // Omega-3 (EPA+DHA)
    final omega3 = biomarkers['omega3_index'];
    if (omega3 != null && omega3 < 8) {
      recs.add(SupplementRecommendation(
        name: 'Omega-3 (EPA+DHA)',
        tradition: SupplementTradition.western,
        reason:
            'Omega-3 Index = ${omega3.toStringAsFixed(1)}% (target: \u22658%)',
        dose: omega3 < 4 ? '3g EPA+DHA/giorno' : '2g EPA+DHA/giorno',
        timing: 'Con pasti (forma trigliceride > etil estere)',
        exitCriteria: 'Omega-3 Index \u2265 8%',
        priority: omega3 < 4
            ? SupplementPriority.high
            : SupplementPriority.medium,
        citation: 'Harris 2018, VITAL trial',
      ));
    }

    // Creatine (unconditional >40)
    if (age >= 40) {
      recs.add(SupplementRecommendation(
        name: 'Creatina monoidrato',
        tradition: SupplementTradition.western,
        reason: 'Prevenzione sarcopenia e neuroprotezione (\u226540 anni)',
        dose: '3-5g/giorno (no loading, no cycling)',
        timing: 'Qualsiasi momento della giornata',
        exitCriteria: 'Continuativo',
        priority: SupplementPriority.medium,
        citation: 'Rawson & Volek 2003, Delpino 2022',
        notes: ['Meccanismo anaerobico. Complementare a Cordyceps (aerobico).'],
      ));
    }

    // Iron (ONLY when low)
    final ferritin = biomarkers['ferritin'];
    if (ferritin != null && ferritin < 30) {
      recs.add(SupplementRecommendation(
        name: 'Ferro bisglicinate',
        tradition: SupplementTradition.western,
        reason:
            'Ferritina = ${ferritin.toStringAsFixed(0)} ng/mL (target: 50-100)',
        dose: '65mg a giorni alterni (NOT daily)',
        timing: 'Stomaco vuoto con vitamina C. NON con caff\u00e8/t\u00e8/calcio',
        exitCriteria: 'Ferritina > 50 ng/mL, poi STOP',
        priority: ferritin < 15
            ? SupplementPriority.high
            : SupplementPriority.medium,
        citation: 'Stoffel et al. 2020 (Lancet)',
        warnings: [
          'Il ferro in eccesso \u00e8 tossico. Controllare ferritina ogni 3 mesi.',
          'Alternate-day \u00e8 superiore a daily per assorbimento (Stoffel 2020).',
        ],
      ));
    }

    // Magnesium
    final mg = biomarkers['magnesium'];
    if (mg != null && mg < 1.8) {
      recs.add(SupplementRecommendation(
        name: 'Magnesio glicinato',
        tradition: SupplementTradition.western,
        reason: 'Mg = ${mg.toStringAsFixed(1)} mg/dL (target: \u22651.8)',
        dose: '200-400mg/giorno',
        timing: 'Sera (30min prima di dormire)',
        exitCriteria: 'Mg \u2265 1.8 mg/dL',
        priority: SupplementPriority.medium,
        citation: 'Abbasi et al. 2012',
        notes: ['Glicinato per assorbimento + effetto calmante serale.'],
      ));
    }

    // Collagen (unconditional — joint/tendon prevention)
    recs.add(SupplementRecommendation(
      name: 'Collagene idrolizzato',
      tradition: SupplementTradition.western,
      reason: 'Prevenzione: salute tendini, legamenti, articolazioni',
      dose: '15g + 50mg vitamina C',
      timing: '30-60 min PRIMA dell\'allenamento',
      exitCriteria: 'Continuativo nei giorni di allenamento',
      priority: SupplementPriority.low,
      citation: 'Shaw et al. 2017 (AJCN)',
      notes: ['Timing critico: la vitamina C attiva la sintesi di collagene.'],
    ));

    // ── Russian adaptogens (Brekman tradition) ───────────────────

    // Rhodiola rosea — conditionally recommended in high training load
    if (trainingLoad == 'high') {
      recs.add(SupplementRecommendation(
        name: 'Rhodiola rosea',
        tradition: SupplementTradition.russian,
        reason: 'Alto carico di allenamento \u2014 supporto endurance e recovery',
        dose: '200mg acuto pre-workout OPPURE 600-1500mg/giorno cronico',
        timing: 'Mattino (MAI prima di dormire)',
        exitCriteria: 'Quando il carico torna a livelli normali',
        cycling: '4 settimane on / 2 settimane off',
        priority: SupplementPriority.medium,
        citation: 'Multiple RCTs, PMC 9228580',
        notes: [
          'Meglio per recreationally active. Ciclizzare sempre.',
          'Sinergico con Schisandra chinensis.',
        ],
      ));
    }

    // Ecdysterone/Leuzea — conditionally in training blocks
    if (trainingLoad == 'high' || (age >= 35 && trainingLoad == 'moderate')) {
      recs.add(SupplementRecommendation(
        name: 'Ecdysterone / Leuzea (\u041b\u0435\u0432\u0437\u0435\u044f)',
        tradition: SupplementTradition.russian,
        reason: 'Supporto anabolico naturale \u2014 pathway ERbeta/PI3K/Akt',
        dose: '200-800mg/giorno',
        timing: 'Con pasti, distribuito nella giornata',
        exitCriteria: 'Ciclizzare dopo 8-12 settimane',
        cycling: '8-12 settimane on / 4 settimane off',
        priority: SupplementPriority.low,
        citation: '50+ anni ricerca russa, pathway ERbeta/PI3K/Akt',
        notes: [
          'NO soppressione ormonale, LD50 >9g/kg (sicurissimo).',
          'Non WADA-banned. Nessun effetto collaterale noto.',
        ],
      ));
    }

    // Schisandra — when training load is high (liver protection + cortisol)
    if (trainingLoad == 'high') {
      recs.add(SupplementRecommendation(
        name: 'Schisandra chinensis',
        tradition: SupplementTradition.russian,
        reason: 'Protezione epatica + modulazione cortisolo sotto stress',
        dose: '500-1000mg/giorno',
        timing: 'Mattino, insieme a Rhodiola (sinergismo)',
        exitCriteria: 'Quando lo stress/carico si riduce',
        cycling: '4 settimane on / 2 settimane off',
        priority: SupplementPriority.low,
        citation: 'ADAPT-232 / Ricerca sovietica',
        notes: [
          'Unica combinazione fegato + cortisolo tra gli adattogeni.',
          'Parte della formula ADAPT-232 (Rhodiola + Schisandra + Eleuthero).',
        ],
      ));
    }

    // ── Chinese TCM compounds ────────────────────────────────────

    // Astragalus / Cycloastragenol — longevity, unconditional >50
    if (age >= 50) {
      recs.add(SupplementRecommendation(
        name: 'Astragalus / Cycloastragenol',
        tradition: SupplementTradition.chinese,
        reason: 'Longevit\u00e0 \u2014 UNICO composto con RCT per attivazione telomerasi',
        dose: '250-500mg/giorno standardizzato, minimo 6 mesi',
        timing: 'Mattino, con pasto',
        exitCriteria: 'Continuativo (longevit\u00e0)',
        priority: SupplementPriority.medium,
        citation: 'TA-65 meta-analysis: 8 RCTs, n=750',
        notes: [
          'GRAS status. Telomeri allungati significativamente nei >60 anni.',
          'Il composto longevit\u00e0 pi\u00f9 unico da entrambe le tradizioni russa e cinese.',
        ],
      ));
    }

    // Cordyceps Cs-4 — VO2max, endurance (complementary to creatine)
    recs.add(SupplementRecommendation(
      name: 'Cordyceps Cs-4',
      tradition: SupplementTradition.chinese,
      reason: 'VO2max e endurance \u2014 meccanismo aerobico (complementare a creatina)',
      dose: '3g/giorno, minimo 6 settimane',
      timing: 'Mattino, con pasto',
      exitCriteria: 'Continuativo durante periodi di training',
      cycling: '6 settimane on / 2 settimane off',
      priority: SupplementPriority.low,
      citation: 'RCT: +10.5% soglia metabolica. Meta-analysis VO2peak (p=0.04)',
      notes: [
        'Usare SOLO Cs-4 fermentato, NON wild (costoso e meno standardizzato).',
        'Meccanismo aerobico: complementare a creatina (anaerobico).',
      ],
    ));

    // Reishi — immunomodulation (recommended during heavy training)
    if (trainingLoad == 'high' || trainingLoad == 'moderate') {
      recs.add(SupplementRecommendation(
        name: 'Reishi (Lingzhi / \u7075\u829d)',
        tradition: SupplementTradition.chinese,
        reason:
            'Immunomodulazione bidirezionale \u2014 previene immunosoppressione da overtraining',
        dose: '3-5g/giorno dual extract (acqua + alcol)',
        timing: 'Sera (effetto calmante)',
        exitCriteria: 'Continuativo durante periodi di training intenso',
        priority: SupplementPriority.low,
        citation: 'Reishi bidirectional immunomodulation studies',
        notes: [
          'Meccanismo unico: modula il sistema immunitario sia up che down.',
          'Dual extract necessario per estrarre sia polisaccaridi che triterpeni.',
        ],
      ));
    }

    // ── Experimental / Informative ───────────────────────────────

    // NMN (informative only)
    if (age >= 40) {
      recs.add(SupplementRecommendation(
        name: 'NMN (sperimentale)',
        tradition: SupplementTradition.western,
        reason: 'NAD+ booster \u2014 dati umani limitati, categoria informativa',
        dose: '250-500mg/giorno',
        timing: 'Mattino',
        exitCriteria: 'Opzionale \u2014 monitorare la ricerca',
        priority: SupplementPriority.informative,
        citation: 'Yi et al. 2023',
        notes: [
          'SPERIMENTALE: dati umani ancora limitati.',
          'Categoria informativa \u2014 non una raccomandazione attiva.',
        ],
        warnings: [
          'Dati a lungo termine assenti. Consultare il medico.',
        ],
      ));
    }

    recs.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return recs;
  }

  /// Biomarkers that the user hasn't entered but that drive recommendations.
  List<String> missingBiomarkers(Map<String, double> biomarkers) {
    final missing = <String>[];
    const relevantKeys = [
      ('vitamin_d_25oh', 'Vitamina D 25(OH)D'),
      ('omega3_index', 'Omega-3 Index'),
      ('ferritin', 'Ferritina'),
      ('magnesium', 'Magnesio'),
    ];
    for (final (key, label) in relevantKeys) {
      if (!biomarkers.containsKey(key)) {
        missing.add(label);
      }
    }
    return missing;
  }

  /// Anti-recommendations (supplements to avoid).
  static const antiRecommendations = [
    AntiRecommendation(
      name: 'Resveratrolo',
      tradition: SupplementTradition.western,
      reason:
          'Pu\u00f2 annullare i benefici dell\'esercizio (vasodilatazione, stress ossidativo adattivo)',
      citation: 'Gliemann et al. 2013',
      advice:
          'NON assumere se ti alleni regolarmente. L\'esercizio \u00e8 gi\u00e0 il miglior "integratore".',
    ),
    AntiRecommendation(
      name: 'Eleuthero (standalone)',
      tradition: SupplementTradition.russian,
      reason:
          'Trial moderni rigorosi non trovano beneficio significativo. Hype sovietico non confermato',
      citation: 'Revisione sistematica moderna',
      advice:
          'Solo come parte di formule combinate (es. ADAPT-232 con Rhodiola + Schisandra). Da solo non giustificato.',
    ),
    AntiRecommendation(
      name: 'Meldonium',
      tradition: SupplementTradition.russian,
      reason:
          'Bannato WADA dal 2016. Rischio legale per atleti, anche amatoriali in competizioni',
      citation: 'WADA Prohibited List 2016+',
      advice:
          'EVITARE completamente. Nessun beneficio giustifica il rischio legale/etico.',
    ),
  ];
}

/// Which evidence tradition the supplement comes from.
enum SupplementTradition { western, russian, chinese }

enum SupplementPriority { high, medium, low, informative }

class SupplementRecommendation {
  final String name;
  final SupplementTradition tradition;
  final String reason;
  final String dose;
  final String timing;
  final String exitCriteria;
  final String? cycling;
  final SupplementPriority priority;
  final String citation;
  final List<String> warnings;
  final List<String> notes;

  const SupplementRecommendation({
    required this.name,
    required this.tradition,
    required this.reason,
    required this.dose,
    required this.timing,
    required this.exitCriteria,
    this.cycling,
    required this.priority,
    required this.citation,
    this.warnings = const [],
    this.notes = const [],
  });

  /// Human-readable tradition label.
  String get traditionLabel => switch (tradition) {
        SupplementTradition.western => 'Occidentale',
        SupplementTradition.russian => 'Russa',
        SupplementTradition.chinese => 'Cinese (TCM)',
      };
}

class AntiRecommendation {
  final String name;
  final SupplementTradition tradition;
  final String reason;
  final String citation;
  final String advice;

  const AntiRecommendation({
    required this.name,
    required this.tradition,
    required this.reason,
    required this.citation,
    required this.advice,
  });
}
