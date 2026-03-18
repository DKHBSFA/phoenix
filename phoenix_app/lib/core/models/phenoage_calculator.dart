import 'dart:math';

/// PhenoAge calculator based on Levine et al. 2018
/// "An epigenetic biomarker of aging for lifespan and healthspan"
/// Aging (Albany NY). 2018;10(4):573-591.
///
/// Uses 9 blood biomarkers + chronological age to estimate biological age.
class PhenoAgeCalculator {
  PhenoAgeCalculator._();

  /// The 9 biomarker keys required for PhenoAge calculation.
  static const requiredMarkers = [
    'albumin',
    'creatinine',
    'glucose',
    'hscrp',
    'lymphocytes_pct',
    'mcv',
    'rdw',
    'alkaline_phosphatase',
    'wbc',
  ];

  /// Coefficients from Levine 2018 supplementary Table S1.
  /// These are the Gompertz regression coefficients for mortality hazard.
  static const _b0 = -19.9067; // intercept
  static const _coeffAge = 0.0804;
  static const _coeffAlbumin = -0.0336; // g/dL (protective)
  static const _coeffCreatinine = 0.0095; // mg/dL
  static const _coeffGlucose = 0.1953; // log(mg/dL)
  static const _coeffLnCRP = 0.0954; // log(mg/L)
  static const _coeffLymphocytePct = -0.0120; // %
  static const _coeffMCV = 0.0268; // fL
  static const _coeffRDW = 0.3306; // %
  static const _coeffAlkPhos = 0.00188; // U/L
  static const _coeffWBC = 0.0554; // 10^3 cells/µL

  /// Gamma parameter from Gompertz distribution fit.
  // ignore: unused_field — retained for Levine 2018 mortality projection formula
  static const _gamma = -1.51714;

  /// Lambda parameter (baseline hazard scaling).
  static const _lambda = 0.0076927;

  /// Calculates PhenoAge from blood biomarkers and chronological age.
  ///
  /// Returns null if any required value is null or out of plausible range.
  static double? calculate({
    required int chronologicalAge,
    required double? albumin, // g/dL
    required double? creatinine, // mg/dL
    required double? glucose, // mg/dL
    required double? hscrp, // mg/L
    required double? lymphocytePct, // %
    required double? mcv, // fL
    required double? rdw, // %
    required double? alkalinePhosphatase, // U/L
    required double? wbc, // 10^3 cells/µL
  }) {
    // All 9 markers must be present
    if (albumin == null ||
        creatinine == null ||
        glucose == null ||
        hscrp == null ||
        lymphocytePct == null ||
        mcv == null ||
        rdw == null ||
        alkalinePhosphatase == null ||
        wbc == null) {
      return null;
    }

    // Basic sanity checks — reject physiologically impossible values
    if (chronologicalAge < 18 ||
        chronologicalAge > 120 ||
        albumin <= 0 ||
        creatinine <= 0 ||
        glucose <= 0 ||
        hscrp <= 0 ||
        wbc <= 0 ||
        alkalinePhosphatase <= 0 ||
        lymphocytePct < 0 || lymphocytePct > 100 ||
        mcv < 50 || mcv > 150 ||
        rdw < 5 || rdw > 30) {
      return null;
    }

    // Step 1: Calculate the linear predictor (xb)
    final lnCRP = log(hscrp);
    final lnGlucose = log(glucose);

    final xb = _b0 +
        _coeffAge * chronologicalAge +
        _coeffAlbumin * albumin +
        _coeffCreatinine * creatinine +
        _coeffGlucose * lnGlucose +
        _coeffLnCRP * lnCRP +
        _coeffLymphocytePct * lymphocytePct +
        _coeffMCV * mcv +
        _coeffRDW * rdw +
        _coeffAlkPhos * alkalinePhosphatase +
        _coeffWBC * wbc;

    // Step 2: Calculate mortality score (M)
    // M = 1 - exp(-exp(xb) * (exp(120 * gamma) - 1) / gamma)
    final expXb = exp(xb);
    final mortalityScore =
        1.0 - exp(-expXb * (exp(120.0 * _lambda) - 1.0) / _lambda);

    // Step 3: Convert mortality score to PhenoAge
    // PhenoAge = 141.50225 + ln(-0.00553 * ln(1 - mortalityScore)) / 0.090165
    if (mortalityScore <= 0 || mortalityScore >= 1) return null;

    final phenoAge =
        141.50225 + log(-0.00553 * log(1.0 - mortalityScore)) / 0.090165;

    // Sanity check result
    if (phenoAge.isNaN || phenoAge.isInfinite || phenoAge < 0 || phenoAge > 150) {
      return null;
    }

    return double.parse(phenoAge.toStringAsFixed(1));
  }

  /// Returns which of the 9 required markers are missing from a blood panel.
  static List<String> missingMarkers(Map<String, dynamic> panel) {
    return requiredMarkers
        .where((key) => panel[key] == null)
        .toList();
  }

  /// Human-readable label for each marker key.
  static const markerLabels = {
    'albumin': 'Albumina',
    'creatinine': 'Creatinina',
    'glucose': 'Glicemia',
    'hscrp': 'hsCRP',
    'lymphocytes_pct': 'Linfociti %',
    'mcv': 'MCV',
    'rdw': 'RDW',
    'alkaline_phosphatase': 'Fosfatasi alcalina',
    'wbc': 'Globuli bianchi',
  };

  /// Unit for each marker.
  static const markerUnits = {
    'albumin': 'g/dL',
    'creatinine': 'mg/dL',
    'glucose': 'mg/dL',
    'hscrp': 'mg/L',
    'lymphocytes_pct': '%',
    'mcv': 'fL',
    'rdw': '%',
    'alkaline_phosphatase': 'U/L',
    'wbc': '×10³/µL',
  };
}
