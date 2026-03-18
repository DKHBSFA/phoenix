/// Alert severity levels for biomarker checks.
enum AlertSeverity { high, medium, low }

/// A single biomarker alert with actionable recommendation.
class BiomarkerAlert {
  final AlertSeverity severity;
  final String title;
  final String message;
  final String action;

  const BiomarkerAlert({
    required this.severity,
    required this.title,
    required this.message,
    required this.action,
  });
}

/// Checks blood panel values against Phoenix Protocol rules (section 5.3).
class BiomarkerAlerts {
  BiomarkerAlerts._();

  /// Generates alerts based on current panel and optional previous panel.
  ///
  /// [sex] should be 'male' or 'female'.
  static List<BiomarkerAlert> check(
    Map<String, dynamic> current,
    Map<String, dynamic>? previous,
    String sex,
  ) {
    final alerts = <BiomarkerAlert>[];

    // Testosterone drop >20%
    if (previous != null &&
        current['testosterone'] != null &&
        previous['testosterone'] != null) {
      final prev = (previous['testosterone'] as num).toDouble();
      final curr = (current['testosterone'] as num).toDouble();
      if (prev > 0) {
        final drop = (prev - curr) / prev;
        if (drop > 0.20) {
          alerts.add(BiomarkerAlert(
            severity: AlertSeverity.high,
            title: 'Testosterone in calo significativo',
            message:
                'Calo del ${(drop * 100).toInt()}%. Considera ridurre la finestra di digiuno (16h → 14h).',
            action: 'Ridurre TRE',
          ));
        }
      }
    }

    // Ferritin low
    final ferritinThreshold = sex == 'female' ? 20.0 : 30.0;
    if (current['ferritin'] != null) {
      final ferritin = (current['ferritin'] as num).toDouble();
      if (ferritin < ferritinThreshold) {
        alerts.add(BiomarkerAlert(
          severity: AlertSeverity.high,
          title: 'Ferritina bassa',
          message:
              'Ferritina $ferritin µg/L (sotto ${ferritinThreshold.toInt()}). Rischio anemia sportiva.',
          action: 'Supplementazione ferro + ridurre volume allenamento',
        ));
      }
    }

    // hsCRP elevated (chronic inflammation)
    if (current['hscrp'] != null) {
      final hscrp = (current['hscrp'] as num).toDouble();
      if (hscrp > 3.0) {
        alerts.add(BiomarkerAlert(
          severity: AlertSeverity.medium,
          title: 'Infiammazione sistemica elevata',
          message:
              'hsCRP $hscrp mg/L (>3.0). Verificare volume allenamento e qualità recupero.',
          action: 'Audit volume/frequenza/recupero',
        ));
      }
    }

    // Lymphocytes low (immunosuppression)
    if (current['lymphocytes_pct'] != null) {
      final lymph = (current['lymphocytes_pct'] as num).toDouble();
      if (lymph < 20) {
        alerts.add(BiomarkerAlert(
          severity: AlertSeverity.high,
          title: 'Linfociti sotto range',
          message:
              'Linfociti $lymph% (<20%). Possibile immunodepressione da sovrallenamento.',
          action: 'Ridurre intensità e volume immediatamente',
        ));
      }
    }

    // Cortisol elevated + could indicate overtraining
    if (current['cortisol'] != null) {
      final cortisol = (current['cortisol'] as num).toDouble();
      if (cortisol > 23) {
        alerts.add(BiomarkerAlert(
          severity: AlertSeverity.medium,
          title: 'Cortisolo elevato',
          message:
              'Cortisolo $cortisol µg/dL (>23). Possibile stress cronico o sovrallenamento.',
          action: 'Considerare protocollo deload (stadio 2)',
        ));
      }
    }

    // Glucose elevated
    if (current['glucose'] != null) {
      final glucose = (current['glucose'] as num).toDouble();
      if (glucose > 100) {
        alerts.add(BiomarkerAlert(
          severity: glucose > 126 ? AlertSeverity.high : AlertSeverity.medium,
          title: 'Glicemia elevata',
          message:
              'Glicemia $glucose mg/dL (${glucose > 126 ? "diabetico" : "prediabetico"}). Monitorare.',
          action: 'Verificare aderenza al protocollo TRE',
        ));
      }
    }

    return alerts;
  }
}
