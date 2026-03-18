import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../../../core/ring/workout_bio_tracker.dart';

/// Compact bio data overlay for workout screens.
///
/// Shows live HR, SpO2, HRV, and stress index from the ring during a
/// workout session. Hidden when tracker is inactive.
///
/// During a set: HR + zone color only.
/// During rest: HR + SpO2, HRV, Stress Index on a second line.
class BioOverlay extends StatelessWidget {
  final WorkoutBioTracker tracker;
  final bool isResting;

  const BioOverlay({
    super.key,
    required this.tracker,
    this.isResting = false,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: tracker.isActive,
      builder: (context, active, _) {
        if (!active) return const SizedBox.shrink();
        return _BioOverlayContent(tracker: tracker, isResting: isResting);
      },
    );
  }
}

class _BioOverlayContent extends StatelessWidget {
  final WorkoutBioTracker tracker;
  final bool isResting;

  const _BioOverlayContent({
    required this.tracker,
    required this.isResting,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.phoenix;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.smMd,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(Radii.none),
        border: Border.all(color: colors.border, width: Borders.thin),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HrLine(hrNotifier: tracker.currentHr),
          if (isResting) ...[
            const SizedBox(height: Spacing.xxs),
            _RestLine(
              spo2Notifier: tracker.currentSpo2,
              rmssdNotifier: tracker.currentRmssd,
              stressNotifier: tracker.currentStressIndex,
            ),
          ],
        ],
      ),
    );
  }
}

// ── HR line ───────────────────────────────────────────────────────

class _HrLine extends StatelessWidget {
  final ValueNotifier<int?> hrNotifier;

  const _HrLine({required this.hrNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: hrNotifier,
      builder: (context, hr, _) {
        if (hr == null) return const SizedBox.shrink();
        final zoneColor = _hrZoneColor(hr);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 12, color: zoneColor),
            const SizedBox(width: Spacing.xs),
            Text(
              '$hr BPM',
              style: PhoenixTypography.caption.copyWith(color: zoneColor),
            ),
          ],
        );
      },
    );
  }

  /// Maps HR to a zone color using the Phoenix functional palette.
  /// Zones follow the 5-zone model aligned with HrZones in hr_zones.dart.
  Color _hrZoneColor(int hr) {
    if (hr < 100) return PhoenixColors.success;       // Zone 1 — recovery green
    if (hr < 130) return PhoenixColors.success;       // Zone 2 — aerobic green
    if (hr < 150) return PhoenixColors.warning;       // Zone 3 — tempo yellow
    if (hr < 170) return PhoenixColors.warning;       // Zone 4 — threshold orange/yellow
    return PhoenixColors.error;                       // Zone 5 — max red
  }
}

// ── Rest-phase detail line ────────────────────────────────────────

class _RestLine extends StatelessWidget {
  final ValueNotifier<int?> spo2Notifier;
  final ValueNotifier<double?> rmssdNotifier;
  final ValueNotifier<double?> stressNotifier;

  const _RestLine({
    required this.spo2Notifier,
    required this.rmssdNotifier,
    required this.stressNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SpO2Chip(notifier: spo2Notifier),
        _RmssdChip(notifier: rmssdNotifier),
        _StressChip(notifier: stressNotifier),
      ],
    );
  }
}

class _SpO2Chip extends StatelessWidget {
  final ValueNotifier<int?> notifier;

  const _SpO2Chip({required this.notifier});

  @override
  Widget build(BuildContext context) {
    final textSecondary = context.phoenix.textSecondary;
    return ValueListenableBuilder<int?>(
      valueListenable: notifier,
      builder: (context, spo2, _) {
        if (spo2 == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(right: Spacing.sm),
          child: Text(
            'SpO\u2082 $spo2%',
            style: PhoenixTypography.micro.copyWith(color: textSecondary),
          ),
        );
      },
    );
  }
}

class _RmssdChip extends StatelessWidget {
  final ValueNotifier<double?> notifier;

  const _RmssdChip({required this.notifier});

  @override
  Widget build(BuildContext context) {
    final textSecondary = context.phoenix.textSecondary;
    return ValueListenableBuilder<double?>(
      valueListenable: notifier,
      builder: (context, rmssd, _) {
        if (rmssd == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(right: Spacing.sm),
          child: Text(
            'HRV ${rmssd.toStringAsFixed(0)}ms',
            style: PhoenixTypography.micro.copyWith(color: textSecondary),
          ),
        );
      },
    );
  }
}

class _StressChip extends StatelessWidget {
  final ValueNotifier<double?> notifier;

  const _StressChip({required this.notifier});

  @override
  Widget build(BuildContext context) {
    final textSecondary = context.phoenix.textSecondary;
    return ValueListenableBuilder<double?>(
      valueListenable: notifier,
      builder: (context, si, _) {
        if (si == null) return const SizedBox.shrink();
        return Text(
          'SI ${si.toStringAsFixed(0)}',
          style: PhoenixTypography.micro.copyWith(color: textSecondary),
        );
      },
    );
  }
}
