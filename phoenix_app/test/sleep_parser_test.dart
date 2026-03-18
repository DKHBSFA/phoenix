import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/sleep_parser.dart';

void main() {
  group('SleepParser', () {
    test('parseSleepStage maps known values', () {
      expect(SleepStage.fromRingValue(0x01), SleepStage.light);
      expect(SleepStage.fromRingValue(0x02), SleepStage.deep);
      expect(SleepStage.fromRingValue(0x03), SleepStage.rem);
      expect(SleepStage.fromRingValue(0x04), SleepStage.awake);
      expect(SleepStage.fromRingValue(0xFF), SleepStage.awake);
    });

    test('SleepSession computes totalSleep excluding awake', () {
      final session = SleepSession(
        nightDate: DateTime(2026, 3, 18),
        stages: [
          SleepPeriod(stage: SleepStage.light, start: DateTime(2026, 3, 18, 23, 0), end: DateTime(2026, 3, 18, 23, 30)),
          SleepPeriod(stage: SleepStage.deep, start: DateTime(2026, 3, 18, 23, 30), end: DateTime(2026, 3, 19, 0, 30)),
          SleepPeriod(stage: SleepStage.awake, start: DateTime(2026, 3, 19, 0, 30), end: DateTime(2026, 3, 19, 0, 40)),
          SleepPeriod(stage: SleepStage.rem, start: DateTime(2026, 3, 19, 0, 40), end: DateTime(2026, 3, 19, 1, 20)),
        ],
      );
      expect(session.totalSleep.inMinutes, 130);
      expect(session.timeInBed.inMinutes, 140);
      expect(session.deep.inMinutes, 60);
      expect(session.rem.inMinutes, 40);
      expect(session.awake.inMinutes, 10);
    });
  });
}
