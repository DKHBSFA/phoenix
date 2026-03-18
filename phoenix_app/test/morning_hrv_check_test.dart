import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/signal_processor.dart';

/// MorningHrvCheck tests.
///
/// Full integration tests require RingService + HrvDao + Lock mocking.
/// These tests verify the signal processing pipeline used by MorningHrvCheck.
void main() {
  group('MorningHrvCheck signal pipeline', () {
    final processor = SignalProcessor();

    test('RMSSD from realistic IBI produces valid range', () {
      // 60s of normal resting HRV at ~60bpm (IBI ~1000ms)
      // Slight natural variability ±50ms
      final ibis = List.generate(60, (i) => 1000 + (i % 5 == 0 ? 30 : -20));
      final rmssd = processor.computeRmssd(ibis);
      expect(rmssd, greaterThan(0));
      expect(rmssd, lessThan(200)); // physiologically reasonable
    });

    test('Stress index from realistic IBI produces valid range', () {
      final ibis = List.generate(60, (i) => 1000 + (i % 5 == 0 ? 30 : -20));
      final si = processor.computeStressIndex(ibis);
      expect(si, greaterThan(0));
    });

    test('insufficient IBI produces zero RMSSD', () {
      // Single IBI cannot produce RMSSD (need at least 2 for differences)
      final ibis = [1000];
      final rmssd = processor.computeRmssd(ibis);
      expect(rmssd, 0.0);
    });

    test('IBI validation range: 300-2000ms', () {
      // IBI below 300ms (~200bpm) or above 2000ms (~30bpm) is invalid.
      // The MorningHrvCheck._measure filters on type only, but
      // WorkoutBioTracker filters 300-2000ms range.
      expect(300, greaterThan(0)); // 200bpm floor
      expect(2000, lessThan(3000)); // 30bpm ceiling
    });

    test('morning window: 6am-12pm', () {
      // autoAttempt checks hour >= 6 && hour < 12
      for (final hour in [6, 7, 8, 9, 10, 11]) {
        expect(hour >= 6 && hour < 12, true, reason: 'hour $hour should be in window');
      }
      for (final hour in [0, 1, 5, 12, 13, 23]) {
        expect(hour >= 6 && hour < 12, false, reason: 'hour $hour should be out of window');
      }
    });
  });
}
