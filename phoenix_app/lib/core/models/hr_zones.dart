/// Calcolatore zone di frequenza cardiaca basato su formula 220-eta.
///
/// 5 zone standard + target specifici per protocolli cardio strutturati.
class HrZones {
  final int age;
  final int maxHr;

  const HrZones._({required this.age, required this.maxHr});

  factory HrZones({required int age}) {
    return HrZones._(age: age, maxHr: 220 - age);
  }

  // ── Zone standard ──────────────────────────────────────────────

  /// Zona 1 — Recupero attivo: 50-60% HR max
  (int low, int high) get zone1 => _range(0.50, 0.60);

  /// Zona 2 — Aerobico / ossidazione grassi: 60-70% HR max
  (int low, int high) get zone2 => _range(0.60, 0.70);

  /// Zona 3 — Tempo / soglia aerobica: 70-80% HR max
  (int low, int high) get zone3 => _range(0.70, 0.80);

  /// Zona 4 — Soglia anaerobica: 80-90% HR max
  (int low, int high) get zone4 => _range(0.80, 0.90);

  /// Zona 5 — VO2max / massimale: 90-100% HR max
  (int low, int high) get zone5 => _range(0.90, 1.00);

  // ── Target per protocolli specifici ────────────────────────────

  /// Target per protocollo specificato.
  ///
  /// [zone] puo essere:
  /// - 'zone1'..'zone5' — zone standard
  /// - 'zone2' — steady-state aerobico
  /// - 'hiit_work' — fase lavoro HIIT (zona 4-5, 85-95%)
  /// - 'hiit_recovery' — fase recupero HIIT (zona 1-2, 50-65%)
  /// - 'norwegian_work' — fase lavoro Norwegian 4x4 (85-95%)
  (int low, int high) targetFor(String zone) {
    return switch (zone) {
      'zone1' => zone1,
      'zone2' => zone2,
      'zone3' => zone3,
      'zone4' => zone4,
      'zone5' => zone5,
      'hiit_work' => _range(0.85, 0.95),
      'hiit_recovery' => _range(0.50, 0.65),
      'norwegian_work' => _range(0.85, 0.95),
      _ => zone2, // fallback sicuro
    };
  }

  /// Tutte le 5 zone come lista ordinata.
  List<({String name, int low, int high})> get allZones => [
        (name: 'Recupero', low: zone1.$1, high: zone1.$2),
        (name: 'Aerobico', low: zone2.$1, high: zone2.$2),
        (name: 'Tempo', low: zone3.$1, high: zone3.$2),
        (name: 'Soglia', low: zone4.$1, high: zone4.$2),
        (name: 'VO2max', low: zone5.$1, high: zone5.$2),
      ];

  /// Nome della zona per un dato BPM.
  String zoneNameFor(int bpm) {
    if (bpm <= zone1.$2) return 'Recupero';
    if (bpm <= zone2.$2) return 'Aerobico';
    if (bpm <= zone3.$2) return 'Tempo';
    if (bpm <= zone4.$2) return 'Soglia';
    return 'VO2max';
  }

  /// Indice zona (1-5) per un dato BPM.
  int zoneIndexFor(int bpm) {
    if (bpm <= zone1.$2) return 1;
    if (bpm <= zone2.$2) return 2;
    if (bpm <= zone3.$2) return 3;
    if (bpm <= zone4.$2) return 4;
    return 5;
  }

  (int, int) _range(double lowPct, double highPct) =>
      ((maxHr * lowPct).round(), (maxHr * highPct).round());
}
