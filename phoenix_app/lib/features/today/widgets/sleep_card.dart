import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/design_tokens.dart';
import '../../../app/router.dart';
import '../../../core/models/daily_protocol.dart';
import '../../../core/ring/sleep_notifier.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

class SleepCard extends StatelessWidget {
  final SleepData data;
  final bool logged;

  /// Optional ring-derived sleep summary (null when no ring data).
  final SleepSummary? ringSummary;

  const SleepCard({
    super.key,
    required this.data,
    required this.logged,
    this.ringSummary,
  });

  @override
  Widget build(BuildContext context) {
    if (ringSummary != null) {
      return _buildRingEnriched(context, ringSummary!);
    }
    return _buildManual(context);
  }

  // ── Ring-enriched layout ──────────────────────────────────────

  Widget _buildRingEnriched(BuildContext context, SleepSummary summary) {
    final p = context.phoenix;

    final qualityColor = switch (summary.qualityLabel) {
      'Ottimo' => PhoenixColors.success,
      'Buono' => PhoenixColors.conditioningAccent,
      _ => PhoenixColors.warning,
    };

    return ProtocolCardShell(
      title: 'SONNO',
      completed: logged,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, PhoenixRouter.conditioning);
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration + quality badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  summary.totalSleepFormatted,
                  style: PhoenixTypography.bodyLarge.copyWith(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: qualityColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(Radii.sm),
                    border: Border.all(color: qualityColor.withAlpha(80)),
                  ),
                  child: Text(
                    summary.qualityLabel,
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: qualityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Spacing.xs),

            // Stage mini-row
            _StageMiniRow(
              deep: summary.deep,
              light: summary.light,
              rem: summary.rem,
            ),

            const SizedBox(height: Spacing.xs),

            // Tap hint
            Row(
              children: [
                Icon(Icons.bar_chart_rounded, size: 13, color: p.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Tocca per ipnogramma completo',
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: p.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Manual (original) layout ────────────────────────────────

  Widget _buildManual(BuildContext context) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    final durationStr = data.duration != null
        ? '${data.duration!.inHours}h ${data.duration!.inMinutes % 60}m'
        : null;
    final stars = data.qualityStars != null
        ? '${'★' * data.qualityStars!}${'☆' * (5 - data.qualityStars!)}'
        : null;

    return ProtocolCardShell(
      title: 'SONNO',
      completed: logged,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target: ${data.targetBedtime ?? "23:00"} – ${data.targetWake ?? "07:00"}',
            style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
          ),
          if (durationStr != null) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              'Ieri: $durationStr${stars != null ? " $stars" : ""}',
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
          ],
          if (!logged) ...[
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, PhoenixRouter.conditioning);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: textColor),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: const Text('Registra'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Stage mini-row ─────────────────────────────────────────────

class _StageMiniRow extends StatelessWidget {
  final Duration deep;
  final Duration light;
  final Duration rem;

  const _StageMiniRow({
    required this.deep,
    required this.light,
    required this.rem,
  });

  static String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StagePill(label: 'Deep', value: _fmt(deep), color: const Color(0xFF1A237E)),
        const SizedBox(width: Spacing.xs),
        _StagePill(label: 'Light', value: _fmt(light), color: const Color(0xFF42A5F5)),
        const SizedBox(width: Spacing.xs),
        _StagePill(label: 'REM', value: _fmt(rem), color: const Color(0xFFAB47BC)),
      ],
    );
  }
}

class _StagePill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StagePill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label $value',
          style: PhoenixTypography.bodyMedium.copyWith(
            color: context.phoenix.textSecondary,
          ),
        ),
      ],
    );
  }
}
