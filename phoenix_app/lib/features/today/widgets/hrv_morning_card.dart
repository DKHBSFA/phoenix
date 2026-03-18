import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../shared/widgets/protocol_card_shell.dart';

class HrvMorningCard extends ConsumerWidget {
  const HrvMorningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final check = ref.watch(morningHrvCheckProvider);

    return ValueListenableBuilder<bool>(
      valueListenable: check.hrvPending,
      builder: (context, pending, _) {
        if (!pending) return const SizedBox.shrink();
        return _HrvCardBody(check: check);
      },
    );
  }
}

class _HrvCardBody extends StatefulWidget {
  final dynamic check; // MorningHrvCheck

  const _HrvCardBody({required this.check});

  @override
  State<_HrvCardBody> createState() => _HrvCardBodyState();
}

class _HrvCardBodyState extends State<_HrvCardBody> {
  bool _measuring = false;
  double? _completedRmssd;
  String? _recoveryLabel;

  Future<void> _startMeasurement() async {
    setState(() {
      _measuring = true;
      _completedRmssd = null;
      _recoveryLabel = null;
    });
    HapticFeedback.mediumImpact();

    final result = await widget.check.manualMeasure() as double?;

    if (mounted) {
      setState(() {
        _measuring = false;
        _completedRmssd = result;
        if (result != null) {
          _recoveryLabel = _labelForRmssd(result);
        }
      });
    }
  }

  String _labelForRmssd(double rmssd) {
    if (rmssd >= 50) return 'Pronto';
    if (rmssd >= 30) return 'Nella norma';
    return 'Recupero';
  }

  Color _colorForLabel(String label, BuildContext context) {
    return switch (label) {
      'Pronto' => PhoenixColors.success,
      'Nella norma' => context.phoenix.textPrimary,
      _ => PhoenixColors.warning,
    };
  }

  @override
  Widget build(BuildContext context) {
    final p = context.phoenix;

    return ProtocolCardShell(
      title: 'HRV MATTUTINA',
      completed: _completedRmssd != null,
      borderColor: p.border,
      surfaceColor: p.surface,
      child: _measuring
          ? _buildMeasuring(context, p)
          : _completedRmssd != null
              ? _buildResult(context, p)
              : _buildPrompt(context, p),
    );
  }

  Widget _buildPrompt(BuildContext context, p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Misura HRV al mattino a riposo.',
          style: PhoenixTypography.bodyLarge.copyWith(color: p.textSecondary),
        ),
        const SizedBox(height: Spacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _startMeasurement,
            style: OutlinedButton.styleFrom(
              foregroundColor: p.textPrimary,
              side: BorderSide(color: p.textPrimary),
              padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
            ),
            child: const Text('Inizia misurazione'),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasuring(BuildContext context, p) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.check.progress as ValueNotifier<double>,
      builder: (context, progress, _) {
        final secondsLeft = ((1.0 - progress) * 60).round();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Misurazione in corso...',
                  style: PhoenixTypography.bodyLarge.copyWith(
                    color: p.textSecondary,
                  ),
                ),
                Text(
                  '${secondsLeft}s',
                  style: PhoenixTypography.bodyLarge.copyWith(
                    color: p.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            // Progress bar
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 2,
                  width: double.infinity,
                  color: p.border,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 2,
                      color: p.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            // Running RMSSD
            ValueListenableBuilder<double?>(
              valueListenable: widget.check.currentRmssd as ValueNotifier<double?>,
              builder: (context, rmssd, _) {
                if (rmssd == null) {
                  return Text(
                    'Rimani fermo e respira normalmente.',
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: p.textTertiary,
                    ),
                  );
                }
                return Text(
                  'RMSSD: ${rmssd.toStringAsFixed(1)} ms',
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: p.textSecondary,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildResult(BuildContext context, p) {
    final label = _recoveryLabel ?? 'N/D';
    final labelColor = _recoveryLabel != null
        ? _colorForLabel(_recoveryLabel!, context)
        : p.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RMSSD',
                  style: PhoenixTypography.caption.copyWith(
                    color: p.textTertiary,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '${_completedRmssd!.toStringAsFixed(1)} ms',
                  style: PhoenixTypography.h2.copyWith(color: p.textPrimary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xxs,
              ),
              decoration: BoxDecoration(
                color: labelColor.withAlpha(30),
                border: Border.all(color: labelColor.withAlpha(80)),
              ),
              child: Text(
                label,
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
