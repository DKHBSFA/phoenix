/// Reference ranges for blood panel markers, sex-dependent where applicable.
///
/// All ranges based on standard Italian laboratory reference values.
class BiomarkerReferenceRanges {
  BiomarkerReferenceRanges._();

  /// Returns the reference range for a given marker key and sex.
  /// Returns null if marker is not recognized.
  static ReferenceRange? getRange(String key, String sex) {
    final ranges = sex == 'female' ? _femaleOverrides : <String, ReferenceRange>{};
    return ranges[key] ?? _defaultRanges[key];
  }

  /// All marker definitions in display order, grouped by section.
  static const sections = [
    BiomarkerSection(
      name: 'Metabolico',
      markers: [
        MarkerDef(key: 'glucose', label: 'Glicemia', unit: 'mg/dL'),
        MarkerDef(key: 'hba1c', label: 'HbA1c', unit: '%'),
        MarkerDef(key: 'triglycerides', label: 'Trigliceridi', unit: 'mg/dL'),
        MarkerDef(
            key: 'cholesterol_total',
            label: 'Colesterolo totale',
            unit: 'mg/dL'),
        MarkerDef(key: 'hdl', label: 'HDL', unit: 'mg/dL'),
        MarkerDef(
            key: 'non_hdl',
            label: 'Non-HDL',
            unit: 'mg/dL',
            computed: true),
      ],
    ),
    BiomarkerSection(
      name: 'Epatico',
      markers: [
        MarkerDef(key: 'ast', label: 'AST/GOT', unit: 'U/L'),
        MarkerDef(key: 'alt', label: 'ALT/GPT', unit: 'U/L'),
        MarkerDef(key: 'ggt', label: 'GGT', unit: 'U/L'),
        MarkerDef(
            key: 'alkaline_phosphatase',
            label: 'Fosfatasi alcalina',
            unit: 'U/L'),
      ],
    ),
    BiomarkerSection(
      name: 'Renale',
      markers: [
        MarkerDef(key: 'creatinine', label: 'Creatinina', unit: 'mg/dL'),
      ],
    ),
    BiomarkerSection(
      name: 'Ematologico (CBC)',
      markers: [
        MarkerDef(key: 'rbc', label: 'Globuli rossi', unit: 'milioni/µL'),
        MarkerDef(key: 'hemoglobin', label: 'Emoglobina', unit: 'g/dL'),
        MarkerDef(key: 'hematocrit', label: 'Ematocrito', unit: '%'),
        MarkerDef(key: 'mcv', label: 'MCV', unit: 'fL'),
        MarkerDef(key: 'mch', label: 'MCH', unit: 'pg'),
        MarkerDef(key: 'mchc', label: 'MCHC', unit: 'g/dL'),
        MarkerDef(key: 'rdw', label: 'RDW', unit: '%'),
        MarkerDef(
            key: 'platelets', label: 'Piastrine', unit: 'migliaia/µL'),
        MarkerDef(
            key: 'wbc', label: 'Globuli bianchi', unit: 'migliaia/µL'),
        MarkerDef(key: 'neutrophils_pct', label: 'Neutrofili', unit: '%'),
        MarkerDef(key: 'lymphocytes_pct', label: 'Linfociti', unit: '%'),
        MarkerDef(key: 'monocytes_pct', label: 'Monociti', unit: '%'),
      ],
    ),
    BiomarkerSection(
      name: 'Ferro',
      markers: [
        MarkerDef(key: 'ferritin', label: 'Ferritina', unit: 'µg/L'),
      ],
    ),
    BiomarkerSection(
      name: 'Proteine',
      markers: [
        MarkerDef(
            key: 'total_protein', label: 'Proteine totali', unit: 'g/dL'),
        MarkerDef(key: 'albumin', label: 'Albumina', unit: 'g/dL'),
      ],
    ),
  ];

  /// Extended panel markers (optional, shown in expandable section).
  static const extendedSections = [
    BiomarkerSection(
      name: 'Ormonale',
      markers: [
        MarkerDef(
            key: 'testosterone', label: 'Testosterone totale', unit: 'ng/dL'),
        MarkerDef(
            key: 'testosterone_free',
            label: 'Testosterone libero',
            unit: 'pg/mL'),
        MarkerDef(key: 'cortisol', label: 'Cortisolo', unit: 'µg/dL'),
      ],
    ),
    BiomarkerSection(
      name: 'Tiroide',
      markers: [
        MarkerDef(key: 'tsh', label: 'TSH', unit: 'mIU/L'),
        MarkerDef(key: 't3_free', label: 'T3 libero', unit: 'pg/mL'),
        MarkerDef(key: 't4_free', label: 'T4 libero', unit: 'ng/dL'),
      ],
    ),
    BiomarkerSection(
      name: 'Altro',
      markers: [
        MarkerDef(
            key: 'vitamin_d', label: 'Vitamina D 25-OH', unit: 'ng/mL'),
        MarkerDef(key: 'hscrp', label: 'hsCRP', unit: 'mg/L'),
        MarkerDef(key: 'ck', label: 'CK', unit: 'U/L'),
        MarkerDef(key: 'igf1', label: 'IGF-1', unit: 'ng/mL'),
      ],
    ),
  ];

  // Default ranges (male or unisex)
  static const _defaultRanges = {
    'glucose': ReferenceRange(70, 100),
    'hba1c': ReferenceRange(null, 5.7),
    'triglycerides': ReferenceRange(null, 150),
    'cholesterol_total': ReferenceRange(null, 200),
    'hdl': ReferenceRange(40, null),
    'ast': ReferenceRange(null, 40),
    'alt': ReferenceRange(null, 41),
    'ggt': ReferenceRange(null, 55),
    'alkaline_phosphatase': ReferenceRange(44, 147),
    'creatinine': ReferenceRange(0.7, 1.3),
    'rbc': ReferenceRange(4.5, 5.5),
    'hemoglobin': ReferenceRange(13.5, 17.5),
    'hematocrit': ReferenceRange(38, 50),
    'mcv': ReferenceRange(80, 100),
    'mch': ReferenceRange(27, 33),
    'mchc': ReferenceRange(32, 36),
    'rdw': ReferenceRange(11.5, 14.5),
    'platelets': ReferenceRange(150, 400),
    'wbc': ReferenceRange(4.0, 11.0),
    'neutrophils_pct': ReferenceRange(40, 70),
    'lymphocytes_pct': ReferenceRange(20, 45),
    'monocytes_pct': ReferenceRange(2, 10),
    'ferritin': ReferenceRange(30, 300),
    'total_protein': ReferenceRange(6.0, 8.3),
    'albumin': ReferenceRange(3.5, 5.5),
    'testosterone': ReferenceRange(300, 1000),
    'cortisol': ReferenceRange(6, 23),
    'tsh': ReferenceRange(0.4, 4.0),
    'vitamin_d': ReferenceRange(30, 100),
    'hscrp': ReferenceRange(null, 1.0),
    'ck': ReferenceRange(30, 200),
  };

  // Female-specific overrides
  static const _femaleOverrides = {
    'hdl': ReferenceRange(50, null),
    'ggt': ReferenceRange(null, 38),
    'creatinine': ReferenceRange(0.6, 1.1),
    'rbc': ReferenceRange(4.0, 5.0),
    'hemoglobin': ReferenceRange(12.0, 16.0),
    'hematocrit': ReferenceRange(36, 44),
    'ferritin': ReferenceRange(20, 200),
  };
}

/// A reference range with optional lower and upper bounds.
class ReferenceRange {
  final double? low;
  final double? high;

  const ReferenceRange(this.low, this.high);

  /// Returns true if the value is within the reference range.
  bool isNormal(double value) {
    if (low != null && value < low!) return false;
    if (high != null && value > high!) return false;
    return true;
  }

  /// Returns 'low', 'high', or 'normal'.
  String status(double value) {
    if (low != null && value < low!) return 'low';
    if (high != null && value > high!) return 'high';
    return 'normal';
  }

  /// Formatted string like "70-100" or "<5.7" or ">40".
  String get displayString {
    if (low != null && high != null) return '${_fmt(low!)}-${_fmt(high!)}';
    if (low != null) return '>${_fmt(low!)}';
    if (high != null) return '<${_fmt(high!)}';
    return '—';
  }

  static String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

/// A section of biomarkers in the blood panel form.
class BiomarkerSection {
  final String name;
  final List<MarkerDef> markers;

  const BiomarkerSection({required this.name, required this.markers});
}

/// Definition of a single biomarker field.
class MarkerDef {
  final String key;
  final String label;
  final String unit;
  final bool computed;

  const MarkerDef({
    required this.key,
    required this.label,
    required this.unit,
    this.computed = false,
  });
}
