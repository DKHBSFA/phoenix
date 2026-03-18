/// Age & sex-based training adaptation engine.
///
/// Evidence:
/// - Fragala et al. 2019, NSCA Position Statement (decade-by-decade)
/// - McNulty et al. 2020, Sports Medicine (menstrual cycle — trivial effect)
/// - Kemmler et al. 2020 (post-menopausal: ≥70% 1RM for bone density)
/// - Huiberts et al. 2024 (concurrent training — minimal interference in women)
/// - Cruz-Jentoft et al. 2019, EWGSOP2 (sarcopenia onset ~40, accelerates >60)
/// - Hawkins & Wiswell 2003 (VO2max decline ~10%/decade sedentary, ~5-6.5% trained)

// ---------------------------------------------------------------------------
// Age parameters
// ---------------------------------------------------------------------------

/// Training parameters adapted by age decade (Fragala 2019 NSCA).
class AgeParams {
  /// Multiplier applied to weekly set volume (1.0 = full volume).
  final double weeklySetMultiplier;

  /// Minimum recovery hours between same muscle group sessions.
  final int recoveryHours;

  /// Rep range bounds for compound exercises.
  final int repRangeLow;
  final int repRangeHigh;

  /// Pre-workout warmup duration in minutes.
  final int warmupMinutes;

  /// Mobility priority level.
  final String mobilityPriority; // 'standard' / 'elevated' / 'high' / 'critical'

  /// Human-readable decade label (Italian).
  final String decadeLabel;

  /// Key training focus for this decade (Italian).
  final String focusIt;

  const AgeParams({
    required this.weeklySetMultiplier,
    required this.recoveryHours,
    required this.repRangeLow,
    required this.repRangeHigh,
    required this.warmupMinutes,
    required this.mobilityPriority,
    required this.decadeLabel,
    required this.focusIt,
  });
}

// ---------------------------------------------------------------------------
// Sex-specific parameters
// ---------------------------------------------------------------------------

/// Adaptations based on biological sex.
class SexAdaptation {
  /// Whether concurrent training (strength + cardio same session) is safe.
  /// true for women (Huiberts 2024), cautious for men.
  final bool concurrentTrainingSafe;

  /// Minimum load percentage for bone density maintenance.
  /// Higher for post-menopausal women (Kemmler 2020: ≥70% 1RM).
  final int minLoadPercentForBone;

  /// Whether to suggest iron supplementation monitoring.
  final bool monitorIron;

  /// Italian coaching note for this profile.
  final String coachNoteIt;

  const SexAdaptation({
    required this.concurrentTrainingSafe,
    required this.minLoadPercentForBone,
    required this.monitorIron,
    required this.coachNoteIt,
  });
}

// ---------------------------------------------------------------------------
// Engine
// ---------------------------------------------------------------------------

class AgeAdaptationEngine {
  const AgeAdaptationEngine();

  /// Get age-adapted training parameters.
  ///
  /// Based on Fragala et al. 2019 NSCA Position Statement.
  AgeParams forAge(int age) {
    if (age < 30) {
      return const AgeParams(
        weeklySetMultiplier: 1.0,
        recoveryHours: 48,
        repRangeLow: 6,
        repRangeHigh: 15,
        warmupMinutes: 5,
        mobilityPriority: 'standard',
        decadeLabel: '18-29',
        focusIt: 'Costruire base, peak performance',
      );
    }
    if (age < 40) {
      return const AgeParams(
        weeklySetMultiplier: 0.9,
        recoveryHours: 60,
        repRangeLow: 6,
        repRangeHigh: 12,
        warmupMinutes: 7,
        mobilityPriority: 'standard',
        decadeLabel: '30-39',
        focusIt: 'Mantenere massa, prevenire sarcopenia',
      );
    }
    if (age < 50) {
      return const AgeParams(
        weeklySetMultiplier: 0.8,
        recoveryHours: 72,
        repRangeLow: 8,
        repRangeHigh: 12,
        warmupMinutes: 10,
        mobilityPriority: 'elevated',
        decadeLabel: '40-49',
        focusIt: 'Densit\u00e0 ossea, mobilit\u00e0, contrastare declino',
      );
    }
    if (age < 60) {
      return const AgeParams(
        weeklySetMultiplier: 0.7,
        recoveryHours: 84,
        repRangeLow: 8,
        repRangeHigh: 15,
        warmupMinutes: 10,
        mobilityPriority: 'high',
        decadeLabel: '50-59',
        focusIt: 'Equilibrio, prevenzione cadute, massa muscolare',
      );
    }
    if (age < 70) {
      return const AgeParams(
        weeklySetMultiplier: 0.6,
        recoveryHours: 96,
        repRangeLow: 10,
        repRangeHigh: 15,
        warmupMinutes: 12,
        mobilityPriority: 'critical',
        decadeLabel: '60-69',
        focusIt: 'Funzionalit\u00e0 quotidiana, equilibrio, mobilit\u00e0',
      );
    }
    return const AgeParams(
      weeklySetMultiplier: 0.5,
      recoveryHours: 108,
      repRangeLow: 12,
      repRangeHigh: 20,
      warmupMinutes: 15,
      mobilityPriority: 'critical',
      decadeLabel: '70+',
      focusIt: 'Prevenzione cadute, indipendenza funzionale',
    );
  }

  /// Get sex-specific adaptations.
  ///
  /// [biologicalSex] 'male' / 'female' / 'prefer_not_to_say'
  /// [age] for menopausal status inference
  /// [isPostMenopausal] explicit override (null = infer from age)
  SexAdaptation forSex(
    String biologicalSex, {
    int age = 30,
    bool? isPostMenopausal,
  }) {
    if (biologicalSex == 'female') {
      final postMeno = isPostMenopausal ?? (age >= 50);

      if (postMeno) {
        // Kemmler 2020: post-menopausal women need ≥70% 1RM for bone density
        return const SexAdaptation(
          concurrentTrainingSafe: true,
          minLoadPercentForBone: 70,
          monitorIron: true,
          coachNoteIt:
              'Post-menopausa: priorit\u00e0 carichi pesanti (\u226570% 1RM) '
              'per mantenere densit\u00e0 ossea (Kemmler 2020). '
              'Il training ad alta intensit\u00e0 \u00e8 sicuro e pi\u00f9 efficace.',
        );
      }

      // Pre-menopausal women
      // McNulty 2020: menstrual cycle effect is trivial
      // Huiberts 2024: concurrent training safe
      return const SexAdaptation(
        concurrentTrainingSafe: true,
        minLoadPercentForBone: 60,
        monitorIron: true,
        coachNoteIt:
            'Il ciclo mestruale ha effetto trascurabile sulla performance '
            '(McNulty 2020). Allenati normalmente. '
            'Concurrent training (forza+cardio) sicuro (Huiberts 2024).',
      );
    }

    // Male or prefer_not_to_say — standard protocol
    return const SexAdaptation(
      concurrentTrainingSafe: false, // cautious for men
      minLoadPercentForBone: 60,
      monitorIron: false,
      coachNoteIt: 'Protocollo standard. '
          'Monitora testosterone nei biomarker se TRE 16:8 (Moro 2016).',
    );
  }

  /// Apply age adaptation to periodization workout params.
  ///
  /// Returns adjusted sets based on age multiplier.
  int adjustSets(int baseSets, int age) {
    final params = forAge(age);
    return (baseSets * params.weeklySetMultiplier).round().clamp(2, baseSets);
  }

  /// Whether the user should consider Tai Chi / Baduanjin as mobility work.
  ///
  /// Based on Chinese research:
  /// - Tai Chi reduces falls 41% at ≥3h/week (>50)
  /// - Yijinjing superior for bone density
  /// - Baduanjin feasible for pre-frail
  bool shouldSuggestTaiChi(int age) => age >= 50;

  /// Italian recommendation for Tai Chi / traditional practice.
  String taiChiRecommendation(int age) {
    if (age < 50) return '';
    if (age < 60) {
      return 'Considera Tai Chi o Baduanjin come mobility work (2-3x/settimana). '
          'Benefici su equilibrio e densit\u00e0 ossea documentati.';
    }
    if (age < 70) {
      return 'Tai Chi Yang 24-form raccomandato (\u22653h/settimana): '
          'riduce cadute del 41%. Baduanjin come alternativa pi\u00f9 semplice.';
    }
    return 'Tai Chi o Baduanjin fortemente raccomandato per equilibrio '
        'e prevenzione cadute. Yijinjing per densit\u00e0 ossea colonna lombare.';
  }
}
