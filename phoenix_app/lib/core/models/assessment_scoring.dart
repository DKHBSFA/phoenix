import 'dart:convert';

/// Scoring logic for assessment tests based on ACSM, Eurofit, and McGill norms.
///
/// Each test returns a [TestScore] with rating and percentile category.
class AssessmentScoring {
  AssessmentScoring._();

  /// Rate pushup max reps (ACSM norms, male/female, age-adjusted).
  static TestScore scorePushups(int reps, {required String sex, required int age}) {
    // Simplified ACSM push-up norms (male, general adult 20-50)
    final thresholds = sex == 'male'
        ? _pushupMaleThresholds(age)
        : _pushupFemaleThresholds(age);
    return _rateFromThresholds(reps.toDouble(), thresholds);
  }

  /// Rate wall sit seconds (Eurofit battery).
  static TestScore scoreWallSit(int seconds) {
    return _rateFromThresholds(seconds.toDouble(), const [
      (30, TestRating.poor),
      (45, TestRating.belowAverage),
      (60, TestRating.average),
      (90, TestRating.good),
      (120, TestRating.excellent),
    ]);
  }

  /// Rate plank hold seconds (McGill 2015 norms).
  static TestScore scorePlank(int seconds) {
    return _rateFromThresholds(seconds.toDouble(), const [
      (30, TestRating.poor),
      (60, TestRating.belowAverage),
      (90, TestRating.average),
      (120, TestRating.good),
      (180, TestRating.excellent),
    ]);
  }

  /// Rate sit-and-reach cm (Eurofit battery, positive = past toes).
  static TestScore scoreSitAndReach(double cm, {required String sex}) {
    final thresholds = sex == 'male'
        ? const [
            (-5.0, TestRating.poor),
            (0.0, TestRating.belowAverage),
            (10.0, TestRating.average),
            (20.0, TestRating.good),
            (30.0, TestRating.excellent),
          ]
        : const [
            (0.0, TestRating.poor),
            (5.0, TestRating.belowAverage),
            (15.0, TestRating.average),
            (25.0, TestRating.good),
            (35.0, TestRating.excellent),
          ];
    return _rateFromThresholds(cm, thresholds);
  }

  /// Estimate VO2max from Cooper test distance (Cooper 1968).
  /// VO2max = (distance_m - 504.9) / 44.73
  static CooperResult scoreCooper(double distanceM, {required String sex, required int age}) {
    final vo2max = (distanceM - 504.9) / 44.73;
    final thresholds = sex == 'male'
        ? _cooperMaleThresholds(age)
        : _cooperFemaleThresholds(age);
    final score = _rateFromThresholds(vo2max, thresholds);
    return CooperResult(vo2max: vo2max, score: score);
  }

  /// Generate a JSON summary of all scores.
  static String generateScoresJson({
    int? pushupReps,
    int? wallSitSeconds,
    int? plankSeconds,
    double? sitAndReachCm,
    double? cooperDistanceM,
    required String sex,
    required int age,
  }) {
    final scores = <String, String>{};
    if (pushupReps != null) {
      scores['pushup'] = scorePushups(pushupReps, sex: sex, age: age).rating.name;
    }
    if (wallSitSeconds != null) {
      scores['wall_sit'] = scoreWallSit(wallSitSeconds).rating.name;
    }
    if (plankSeconds != null) {
      scores['plank'] = scorePlank(plankSeconds).rating.name;
    }
    if (sitAndReachCm != null) {
      scores['sit_and_reach'] = scoreSitAndReach(sitAndReachCm, sex: sex).rating.name;
    }
    if (cooperDistanceM != null) {
      scores['cooper'] = scoreCooper(cooperDistanceM, sex: sex, age: age).score.rating.name;
    }
    return jsonEncode(scores);
  }

  /// Compare two assessments and return deltas.
  static List<AssessmentDelta> compare(
    Map<String, dynamic> current,
    Map<String, dynamic> previous,
  ) {
    final deltas = <AssessmentDelta>[];

    void addDelta(String name, String unit, num? curr, num? prev) {
      if (curr != null && prev != null) {
        deltas.add(AssessmentDelta(
          testName: name,
          unit: unit,
          current: curr.toDouble(),
          previous: prev.toDouble(),
          delta: (curr - prev).toDouble(),
          improved: curr > prev,
        ));
      }
    }

    addDelta('Push-up', 'reps', current['pushupMaxReps'], previous['pushupMaxReps']);
    addDelta('Wall Sit', 's', current['wallSitSeconds'], previous['wallSitSeconds']);
    addDelta('Plank', 's', current['plankHoldSeconds'], previous['plankHoldSeconds']);
    addDelta('Sit & Reach', 'cm', current['sitAndReachCm'], previous['sitAndReachCm']);
    addDelta('Cooper', 'm', current['cooperDistanceM'], previous['cooperDistanceM']);
    addDelta('Peso', 'kg', current['weightKg'], previous['weightKg']);

    return deltas;
  }

  // ── Private helpers ──

  static List<(double, TestRating)> _pushupMaleThresholds(int age) {
    if (age < 30) {
      return const [
        (15, TestRating.poor),
        (20, TestRating.belowAverage),
        (30, TestRating.average),
        (40, TestRating.good),
        (50, TestRating.excellent),
      ];
    } else if (age < 40) {
      return const [
        (12, TestRating.poor),
        (17, TestRating.belowAverage),
        (25, TestRating.average),
        (35, TestRating.good),
        (45, TestRating.excellent),
      ];
    } else {
      return const [
        (10, TestRating.poor),
        (15, TestRating.belowAverage),
        (20, TestRating.average),
        (30, TestRating.good),
        (40, TestRating.excellent),
      ];
    }
  }

  static List<(double, TestRating)> _pushupFemaleThresholds(int age) {
    if (age < 30) {
      return const [
        (10, TestRating.poor),
        (15, TestRating.belowAverage),
        (22, TestRating.average),
        (30, TestRating.good),
        (40, TestRating.excellent),
      ];
    } else if (age < 40) {
      return const [
        (8, TestRating.poor),
        (12, TestRating.belowAverage),
        (18, TestRating.average),
        (25, TestRating.good),
        (35, TestRating.excellent),
      ];
    } else {
      return const [
        (5, TestRating.poor),
        (10, TestRating.belowAverage),
        (15, TestRating.average),
        (22, TestRating.good),
        (30, TestRating.excellent),
      ];
    }
  }

  static List<(double, TestRating)> _cooperMaleThresholds(int age) {
    if (age < 30) {
      return const [
        (33.0, TestRating.poor),
        (37.0, TestRating.belowAverage),
        (42.0, TestRating.average),
        (48.0, TestRating.good),
        (55.0, TestRating.excellent),
      ];
    } else {
      return const [
        (30.0, TestRating.poor),
        (34.0, TestRating.belowAverage),
        (38.0, TestRating.average),
        (44.0, TestRating.good),
        (50.0, TestRating.excellent),
      ];
    }
  }

  static List<(double, TestRating)> _cooperFemaleThresholds(int age) {
    if (age < 30) {
      return const [
        (28.0, TestRating.poor),
        (32.0, TestRating.belowAverage),
        (36.0, TestRating.average),
        (42.0, TestRating.good),
        (48.0, TestRating.excellent),
      ];
    } else {
      return const [
        (25.0, TestRating.poor),
        (29.0, TestRating.belowAverage),
        (33.0, TestRating.average),
        (38.0, TestRating.good),
        (44.0, TestRating.excellent),
      ];
    }
  }

  static TestScore _rateFromThresholds(
    double value,
    List<(double, TestRating)> thresholds,
  ) {
    TestRating rating = TestRating.poor;
    for (final (threshold, r) in thresholds) {
      if (value >= threshold) {
        rating = r;
      } else {
        break;
      }
    }
    return TestScore(rating: rating, value: value);
  }
}

enum TestRating {
  poor,
  belowAverage,
  average,
  good,
  excellent;

  String get displayName {
    switch (this) {
      case poor:
        return 'Scarso';
      case belowAverage:
        return 'Sotto media';
      case average:
        return 'Nella media';
      case good:
        return 'Buono';
      case excellent:
        return 'Eccellente';
    }
  }

  String get emoji {
    switch (this) {
      case poor:
        return '🔴';
      case belowAverage:
        return '🟠';
      case average:
        return '🟡';
      case good:
        return '🟢';
      case excellent:
        return '⭐';
    }
  }
}

class TestScore {
  final TestRating rating;
  final double value;
  const TestScore({required this.rating, required this.value});
}

class CooperResult {
  final double vo2max;
  final TestScore score;
  const CooperResult({required this.vo2max, required this.score});
}

class AssessmentDelta {
  final String testName;
  final String unit;
  final double current;
  final double previous;
  final double delta;
  final bool improved;

  const AssessmentDelta({
    required this.testName,
    required this.unit,
    required this.current,
    required this.previous,
    required this.delta,
    required this.improved,
  });
}

/// Test definitions with instructions for the assessment screen.
class AssessmentTests {
  AssessmentTests._();

  static const tests = [
    AssessmentTestInfo(
      id: 'pushup',
      name: 'Push-up Max',
      icon: '💪',
      measure: 'Ripetizioni massime',
      unit: 'reps',
      source: 'ACSM Guidelines 11th ed.',
      instructions: [
        'Posizione di partenza: mani larghe come le spalle, corpo in linea retta.',
        'Scendi fino a toccare il petto a terra (o quasi).',
        'Risali completamente estendendo le braccia.',
        'Conta quante ripetizioni riesci a fare senza fermarti.',
        'Interrompi quando non riesci a mantenere la forma corretta.',
      ],
    ),
    AssessmentTestInfo(
      id: 'wall_sit',
      name: 'Wall Sit',
      icon: '🦵',
      measure: 'Tempo fino a cedimento',
      unit: 'secondi',
      source: 'Eurofit battery',
      instructions: [
        'Schiena contro il muro, piedi a ~50cm dalla parete.',
        'Scivola giù fino a formare un angolo di 90° con le ginocchia.',
        'Cosce parallele al pavimento, schiena aderente al muro.',
        'Avvia il timer e mantieni la posizione più a lungo possibile.',
        'Ferma il timer quando ti alzi o le gambe cedono.',
      ],
    ),
    AssessmentTestInfo(
      id: 'plank',
      name: 'Plank Hold',
      icon: '🏋️',
      measure: 'Tempo fino a cedimento',
      unit: 'secondi',
      source: 'McGill 2015',
      instructions: [
        'Avambracci a terra, gomiti sotto le spalle.',
        'Corpo in linea retta dalla testa ai talloni.',
        'Contrai addome e glutei, non lasciare cadere i fianchi.',
        'Avvia il timer e mantieni la posizione.',
        'Ferma quando perdi la forma (fianchi cadono o salgono).',
      ],
    ),
    AssessmentTestInfo(
      id: 'sit_and_reach',
      name: 'Sit & Reach',
      icon: '🧘',
      measure: 'Distanza raggiunta',
      unit: 'cm',
      source: 'Eurofit battery',
      instructions: [
        'Siediti a terra con le gambe distese davanti a te.',
        'Piedi contro una superficie verticale (muro, scatola).',
        'Lo zero è alla punta dei piedi: positivo = oltre, negativo = prima.',
        'Allunga le braccia in avanti lentamente, senza rimbalzare.',
        'Misura il punto più lontano raggiunto con le dita (cm).',
      ],
    ),
    AssessmentTestInfo(
      id: 'cooper',
      name: 'Cooper Test',
      icon: '🏃',
      measure: 'Distanza in 12 minuti',
      unit: 'metri',
      source: 'Cooper 1968',
      optional: true,
      instructions: [
        'Scegli un percorso pianeggiante misurabile (pista, GPS).',
        'Riscaldamento di 5 minuti con jogging leggero.',
        'Avvia il timer: corri/cammina per esattamente 12 minuti.',
        'Copri la maggiore distanza possibile mantenendo un ritmo sostenibile.',
        'Al termine dei 12 minuti, misura la distanza totale percorsa.',
        'Questo test stima il tuo VO2max (capacità aerobica).',
      ],
    ),
  ];
}

class AssessmentTestInfo {
  final String id;
  final String name;
  final String icon;
  final String measure;
  final String unit;
  final String source;
  final bool optional;
  final List<String> instructions;

  const AssessmentTestInfo({
    required this.id,
    required this.name,
    required this.icon,
    required this.measure,
    required this.unit,
    required this.source,
    this.optional = false,
    required this.instructions,
  });
}
