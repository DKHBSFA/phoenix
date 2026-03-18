/// Cold exposure progression calculator.
///
/// Protocol: Start 30s, +30s/week, target 2-3 min.
/// Frequency: 5x/week, weekly dose ~11 min.
/// Constraint: NEVER within 6h post-strength training.
class ColdProgression {
  /// Calculate which week the user is on based on their first cold session date.
  static int currentWeek(DateTime? firstSessionDate) {
    if (firstSessionDate == null) return 1;
    final days = DateTime.now().difference(firstSessionDate).inDays;
    return (days ~/ 7) + 1;
  }

  /// Target duration in seconds for the given week.
  /// Week 1: 30s, Week 2: 60s, ..., caps at 180s (3 min).
  static int targetSeconds(int week) {
    final target = 30 * week;
    return target.clamp(30, 180);
  }

  /// Target formatted as readable string.
  static String targetFormatted(int week) {
    final secs = targetSeconds(week);
    if (secs < 60) return '${secs}s';
    final mins = secs ~/ 60;
    final remainder = secs % 60;
    if (remainder == 0) return '${mins}min';
    return '${mins}min ${remainder}s';
  }

  /// Weekly dose target in seconds (11 minutes = 660s).
  static const weeklyDoseTargetSeconds = 660;

  /// Sessions per week target.
  static const sessionsPerWeekTarget = 5;

  /// Recommended temperature range.
  static const tempMinC = 14.0;
  static const tempMaxC = 15.0;

  /// Hours after strength training before cold is safe.
  static const strengthCooldownHours = 6;

  /// Check if cold exposure is safe given last strength workout time.
  /// Returns hours remaining if not safe, null if safe.
  static double? hoursSinceStrength(DateTime? lastStrengthEnd) {
    if (lastStrengthEnd == null) return null;
    final elapsed = DateTime.now().difference(lastStrengthEnd).inMinutes / 60.0;
    if (elapsed < strengthCooldownHours) return elapsed;
    return null;
  }

  /// Calculate weekly stats from a list of cold sessions this week.
  static ColdWeekStats weekStats({
    required List<ColdSessionData> sessionsThisWeek,
    required int week,
  }) {
    final totalSeconds =
        sessionsThisWeek.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return ColdWeekStats(
      week: week,
      targetSeconds: targetSeconds(week),
      sessionsCompleted: sessionsThisWeek.length,
      totalDoseSeconds: totalSeconds,
    );
  }
}

class ColdSessionData {
  final int durationSeconds;
  final double? temperature;
  final DateTime date;

  const ColdSessionData({
    required this.durationSeconds,
    this.temperature,
    required this.date,
  });
}

class ColdWeekStats {
  final int week;
  final int targetSeconds;
  final int sessionsCompleted;
  final int totalDoseSeconds;

  const ColdWeekStats({
    required this.week,
    required this.targetSeconds,
    required this.sessionsCompleted,
    required this.totalDoseSeconds,
  });

  double get doseMinutes => totalDoseSeconds / 60.0;
  double get doseTargetMinutes => ColdProgression.weeklyDoseTargetSeconds / 60.0;
  double get doseProgress =>
      (totalDoseSeconds / ColdProgression.weeklyDoseTargetSeconds).clamp(0.0, 1.0);
  double get sessionProgress =>
      (sessionsCompleted / ColdProgression.sessionsPerWeekTarget).clamp(0.0, 1.0);
}
