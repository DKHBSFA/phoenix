import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_app/core/ring/signal_processor.dart';

void main() {
  late SignalProcessor processor;

  setUp(() => processor = SignalProcessor());

  group('validation', () {
    test('isValidHr rejects out of range', () {
      expect(processor.isValidHr(0), false);
      expect(processor.isValidHr(29), false);
      expect(processor.isValidHr(30), true);
      expect(processor.isValidHr(120), true);
      expect(processor.isValidHr(220), true);
      expect(processor.isValidHr(221), false);
    });

    test('isValidSpO2 rejects out of range', () {
      expect(processor.isValidSpO2(69), false);
      expect(processor.isValidSpO2(70), true);
      expect(processor.isValidSpO2(98), true);
      expect(processor.isValidSpO2(100), true);
      expect(processor.isValidSpO2(101), false);
    });

    test('isValidTemp rejects out of range', () {
      expect(processor.isValidTemp(29.9), false);
      expect(processor.isValidTemp(30.0), true);
      expect(processor.isValidTemp(36.5), true);
      expect(processor.isValidTemp(42.0), true);
      expect(processor.isValidTemp(42.1), false);
    });
  });

  group('outlier detection', () {
    test('detects outlier beyond 2 SD', () {
      final window = [70, 72, 71, 73, 70, 72, 71, 70, 72, 71];
      expect(processor.isOutlier(150, window), true);
      expect(processor.isOutlier(72, window), false);
    });

    test('handles small window gracefully', () {
      expect(processor.isOutlier(70, [70]), false);
      expect(processor.isOutlier(70, []), false);
    });
  });

  group('smoothing', () {
    test('moving average smooths data', () {
      final data = [60, 80, 60, 80, 60, 80, 60, 80, 60, 80];
      final smoothed = processor.smooth(data, window: 3);
      for (var i = 1; i < smoothed.length - 1; i++) {
        expect(smoothed[i], closeTo(70, 15));
      }
    });
  });

  group('IBI computation', () {
    test('computeHr from IBI', () {
      final ibi = [800, 800, 800, 800, 800];
      expect(processor.computeHr(ibi), 75);
    });

    test('computeRmssd from IBI', () {
      final ibi = [800, 800, 800, 800, 800];
      expect(processor.computeRmssd(ibi), 0.0);

      final varIbi = [800, 850, 780, 830, 810];
      expect(processor.computeRmssd(varIbi), greaterThan(0));
    });

    test('computeStressIndex from IBI', () {
      final ibi = [800, 850, 780, 830, 810];
      final si = processor.computeStressIndex(ibi);
      expect(si, greaterThan(0));
    });
  });

  group('SQI', () {
    test('constant signal gets low SQI (stuck sensor)', () {
      final stuck = List.filled(20, 100);
      expect(processor.assessSignalQuality(stuck), lessThan(0.3));
    });

    test('wild jumps get low SQI (motion artifact)', () {
      final noisy = [60, 180, 50, 200, 40, 190, 55, 210];
      expect(processor.assessSignalQuality(noisy), lessThan(0.5));
    });

    test('normal physiological signal gets high SQI', () {
      final normal = [72, 74, 73, 75, 72, 71, 73, 74, 72, 73, 74, 72, 71, 73, 75];
      expect(processor.assessSignalQuality(normal), greaterThan(0.7));
    });
  });
}
