import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/sleep_notifier.dart';
import 'package:phoenix_app/core/ring/sleep_parser.dart';

void main() {
  group('SleepSummary', () {
    test('qualityLabel is Ottimo for good sleep', () {
      final summary = SleepSummary.fromSession(SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 18, 23, 0), end: DateTime(2026, 3, 19, 0, 30)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 0, 30), end: DateTime(2026, 3, 19, 3, 0)),
          SleepPeriod(stage: SleepStage.rem, start: DateTime(2026, 3, 19, 3, 0), end: DateTime(2026, 3, 19, 4, 40)),
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 19, 4, 40), end: DateTime(2026, 3, 19, 5, 30)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 5, 30), end: DateTime(2026, 3, 19, 7, 0)),
        ],
      ));
      expect(summary.qualityLabel, 'Ottimo');
      expect(summary.totalSleep.inHours, 8);
      expect(summary.efficiency, greaterThan(0.85));
    });

    test('qualityLabel is Scarso for bad sleep', () {
      final summary = SleepSummary.fromSession(SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 1, 0), end: DateTime(2026, 3, 19, 3, 0)),
          SleepPeriod(stage: SleepStage.awake, start: DateTime(2026, 3, 19, 3, 0), end: DateTime(2026, 3, 19, 4, 0)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 4, 0), end: DateTime(2026, 3, 19, 5, 0)),
        ],
      ));
      expect(summary.qualityLabel, 'Scarso');
    });

    test('notificationBody formats correctly', () {
      final summary = SleepSummary.fromSession(SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 18, 23, 0), end: DateTime(2026, 3, 19, 0, 30)),
          SleepPeriod(stage: SleepStage.rem, start: DateTime(2026, 3, 19, 0, 30), end: DateTime(2026, 3, 19, 2, 0)),
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 19, 2, 0), end: DateTime(2026, 3, 19, 6, 0)),
        ],
      ));
      final body = summary.notificationBody;
      expect(body, contains('Deep'));
      expect(body, contains('REM'));
    });
  });
}
