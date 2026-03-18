import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/design_tokens.dart';
import '../../../app/router.dart';
import '../../../core/models/daily_protocol.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

class ColdCard extends StatelessWidget {
  final ColdStats stats;
  final bool completed;

  const ColdCard({super.key, required this.stats, required this.completed});

  @override
  Widget build(BuildContext context) {
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final titleColor = p.textTertiary;

    final doseMin = stats.weeklyDoseSeconds ~/ 60;
    final targetMin = stats.weeklyTargetSeconds ~/ 60;
    final hasStrengthAlert = stats.hoursSinceStrength != null;

    return ProtocolCardShell(
      title: 'FREDDO',
      completed: completed,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target: ${_formatSeconds(stats.targetSeconds)} · Dose: $doseMin/${targetMin}min',
            style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
          ),
          if (hasStrengthAlert) ...[
            const SizedBox(height: Spacing.xs),
            Row(
              children: [
                const Icon(Icons.warning_amber, size: 16, color: PhoenixColors.alert),
                const SizedBox(width: Spacing.xs),
                Text(
                  'Attendi ${(6 - stats.hoursSinceStrength!).toStringAsFixed(1)}h dopo forza',
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: PhoenixColors.alert,
                  ),
                ),
              ],
            ),
          ],
          if (!completed) ...[
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: hasStrengthAlert
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, PhoenixRouter.conditioning);
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: hasStrengthAlert ? titleColor : textColor),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: const Text('Inizia timer'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatSeconds(int secs) {
    if (secs < 60) return '${secs}s';
    final min = secs ~/ 60;
    final rem = secs % 60;
    if (rem == 0) return '${min}min';
    return '${min}min ${rem}s';
  }
}
