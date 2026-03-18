import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/workout_bio_tracker.dart';

void main() {
  group('SetBioStats', () {
    test('computes average HR', () {
      final stats = SetBioStats.fromReadings(
        hrReadings: [120, 130, 140, 150],
        spo2: 97,
        rmssd: 35.0,
        stressIndex: 150.0,
        restingHr: 90,
        peakHr: 150,
        skinTemp: 36.5,
      );
      expect(stats.avgHr, 135.0);
      expect(stats.maxHr, 150);
      expect(stats.hrRecoveryBpm, 60);
    });
  });

  group('SessionBioStats', () {
    test('computes from sets', () {
      final stats = SessionBioStats.fromSets([
        SetBioStats.fromReadings(
          hrReadings: [120, 130, 140],
          spo2: 97,
          rmssd: 35.0,
          stressIndex: 150.0,
          restingHr: 80,
          peakHr: 140,
          skinTemp: 36.5,
        ),
      ]);
      expect(stats.avgHr, greaterThan(0));
    });
  });
}
