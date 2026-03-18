import 'dart:convert';
import 'dart:math';

/// Sleep analysis: regularity score, weekly averages, target tracking.
///
/// Protocol: 7-8h target, regularity > duration.
class SleepScore {
  /// Calculate sleep duration from bedtime and wake time.
  /// Handles overnight sleep (bedtime PM, wake AM).
  static Duration sleepDuration(DateTime bedtime, DateTime wakeTime) {
    var diff = wakeTime.difference(bedtime);
    if (diff.isNegative) {
      // Crossed midnight: add 24h
      diff = wakeTime.add(const Duration(days: 1)).difference(bedtime);
    }
    return diff;
  }

  /// Regularity score based on standard deviation of bedtimes.
  /// Returns 'high' (green), 'medium' (yellow), or 'low' (red).
  static SleepRegularity regularity(List<SleepEntry> entries) {
    if (entries.length < 3) {
      return SleepRegularity(label: 'Insufficiente', level: RegularityLevel.unknown, stdDevMinutes: 0);
    }

    // Convert bedtimes to minutes-since-midnight (handling overnight)
    final bedtimeMinutes = entries.map((e) {
      var mins = e.bedtime.hour * 60 + e.bedtime.minute;
      // If after midnight (0-6am range), treat as previous day late night
      if (mins < 360) mins += 1440; // Add 24h to 0-6am times
      return mins.toDouble();
    }).toList();

    final mean = bedtimeMinutes.reduce((a, b) => a + b) / bedtimeMinutes.length;
    final variance =
        bedtimeMinutes.map((m) => pow(m - mean, 2)).reduce((a, b) => a + b) /
            bedtimeMinutes.length;
    final stdDev = sqrt(variance);

    if (stdDev <= 30) {
      return SleepRegularity(label: 'Alta', level: RegularityLevel.high, stdDevMinutes: stdDev);
    } else if (stdDev <= 60) {
      return SleepRegularity(label: 'Media', level: RegularityLevel.medium, stdDevMinutes: stdDev);
    } else {
      return SleepRegularity(label: 'Bassa', level: RegularityLevel.low, stdDevMinutes: stdDev);
    }
  }

  /// Average sleep duration from entries.
  static Duration averageDuration(List<SleepEntry> entries) {
    if (entries.isEmpty) return Duration.zero;
    final totalMinutes = entries.fold<int>(
      0,
      (sum, e) => sum + sleepDuration(e.bedtime, e.wakeTime).inMinutes,
    );
    return Duration(minutes: totalMinutes ~/ entries.length);
  }

  /// Count of days meeting 7h+ target in the given entries.
  static int daysOnTarget(List<SleepEntry> entries) {
    return entries
        .where((e) => sleepDuration(e.bedtime, e.wakeTime).inMinutes >= 420)
        .length;
  }

  /// Parse sleep JSON from conditioning_sessions notes field.
  static SleepEntry? fromNotesJson(String notes, DateTime date) {
    if (notes.isEmpty) return null;
    try {
      final decoded = jsonDecode(notes);
      if (decoded is! Map<String, dynamic>) return null;

      final bedStr = decoded['bedtime'];
      final wakeStr = decoded['wakeTime'];
      if (bedStr is! String || wakeStr is! String) return null;

      final bedParts = bedStr.split(':');
      final wakeParts = wakeStr.split(':');
      if (bedParts.length != 2 || wakeParts.length != 2) return null;

      final bedH = int.tryParse(bedParts[0]);
      final bedM = int.tryParse(bedParts[1]);
      final wakeH = int.tryParse(wakeParts[0]);
      final wakeM = int.tryParse(wakeParts[1]);
      if (bedH == null || bedM == null || wakeH == null || wakeM == null) return null;
      if (bedH < 0 || bedH > 23 || bedM < 0 || bedM > 59) return null;
      if (wakeH < 0 || wakeH > 23 || wakeM < 0 || wakeM > 59) return null;

      return SleepEntry(
        date: date,
        bedtime: DateTime(date.year, date.month, date.day, bedH, bedM),
        wakeTime: DateTime(date.year, date.month, date.day, wakeH, wakeM),
        quality: (decoded['quality'] as num?)?.toInt() ?? 3,
        notes: decoded['notes'] as String? ?? '',
      );
    } catch (e) {
      // Parse error — return null for malformed data
      return null;
    }
  }

  /// Encode sleep entry to JSON for notes field.
  static String toNotesJson(SleepEntry entry) {
    return jsonEncode({
      'bedtime': '${entry.bedtime.hour.toString().padLeft(2, '0')}:${entry.bedtime.minute.toString().padLeft(2, '0')}',
      'wakeTime': '${entry.wakeTime.hour.toString().padLeft(2, '0')}:${entry.wakeTime.minute.toString().padLeft(2, '0')}',
      'quality': entry.quality,
      'notes': entry.notes,
    });
  }
}

class SleepEntry {
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int quality; // 1-5
  final String notes;

  const SleepEntry({
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    this.quality = 3,
    this.notes = '',
  });

  Duration get duration => SleepScore.sleepDuration(bedtime, wakeTime);
}

enum RegularityLevel { high, medium, low, unknown }

class SleepRegularity {
  final String label;
  final RegularityLevel level;
  final double stdDevMinutes;

  const SleepRegularity({
    required this.label,
    required this.level,
    required this.stdDevMinutes,
  });
}
