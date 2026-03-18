import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../core/llm/model_manager.dart';

class ModelDownloadCard extends ConsumerWidget {
  const ModelDownloadCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(modelManagerProvider);
    final state = manager.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtitleColor =
        isDark ? PhoenixColors.darkTextSecondary : PhoenixColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH, vertical: Spacing.sm),
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(
          color: isDark ? PhoenixColors.darkBorder : PhoenixColors.lightBorder,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: _statusColor(state.status),
                  size: 24,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phoenix Coach AI',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        _statusSubtitle(state),
                        style: TextStyle(color: subtitleColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (state.status == ModelDownloadStatus.ready)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm, vertical: Spacing.xxs),
                    decoration: BoxDecoration(
                      color: PhoenixColors.success.withAlpha(31),
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: const Text(
                      'Attivo',
                      style: TextStyle(
                        color: PhoenixColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),

            // Progress bar (downloading / verifying)
            if (state.status == ModelDownloadStatus.downloading ||
                state.status == ModelDownloadStatus.verifying) ...[
              // Stitch pattern 3.6 progress bar
              const SizedBox(height: Spacing.md),
              state.status == ModelDownloadStatus.verifying
                  ? TDProgress(
                      type: TDProgressType.linear,
                      value: 0.0,
                      color: context.phoenix.textPrimary,
                      backgroundColor: context.phoenix.textPrimary.withAlpha(51),
                      strokeWidth: 12,
                      showLabel: false,
                    )
                  : TDProgress(
                      type: TDProgressType.linear,
                      value: state.progress.clamp(0.0, 1.0),
                      color: context.phoenix.textPrimary,
                      backgroundColor: context.phoenix.textPrimary.withAlpha(51),
                      strokeWidth: 12,
                      showLabel: false,
                    ),
              const SizedBox(height: Spacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.status == ModelDownloadStatus.verifying
                        ? 'Verifica checksum...'
                        : '${(state.progress * 100).toStringAsFixed(0)}%  ${state.progressLabel}',
                    style: TextStyle(color: subtitleColor, fontSize: 12),
                  ),
                  if (state.speedLabel.isNotEmpty)
                    Text(
                      '${state.speedLabel} — ${state.etaLabel}',
                      style: TextStyle(color: subtitleColor, fontSize: 12),
                    ),
                ],
              ),
            ],

            // Error message — show as warning, not alarming red
            if (state.status == ModelDownloadStatus.error &&
                state.errorMessage != null) ...[
              const SizedBox(height: Spacing.sm),
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: PhoenixColors.warningSurface,
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: PhoenixColors.warning, size: 18),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: isDark
                              ? PhoenixColors.darkTextPrimary
                              : PhoenixColors.lightTextPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Benchmark info
            if (state.status == ModelDownloadStatus.ready &&
                state.benchmarkTokPerSec != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                'Velocita: ${state.benchmarkTokPerSec!.toStringAsFixed(1)} tok/s',
                style: TextStyle(color: subtitleColor, fontSize: 13),
              ),
            ],

            const SizedBox(height: Spacing.md),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (state.status == ModelDownloadStatus.idle ||
                    state.status == ModelDownloadStatus.error ||
                    state.status == ModelDownloadStatus.paused)
                  TDButton(
                    text: state.status == ModelDownloadStatus.paused
                        ? 'Riprendi'
                        : 'Scarica modello (1.2 GB)',
                    type: TDButtonType.fill,
                    theme: TDButtonTheme.primary,
                    size: TDButtonSize.large,
                    icon: state.status == ModelDownloadStatus.paused
                        ? Icons.play_arrow
                        : Icons.download,
                    onTap: () => _startDownload(ref),
                  ),
                if (state.status == ModelDownloadStatus.downloading) ...[
                  TDButton(
                    text: 'Pausa',
                    type: TDButtonType.text,
                    theme: TDButtonTheme.defaultTheme,
                    onTap: () => manager.pauseDownload(),
                  ),
                  const SizedBox(width: Spacing.sm),
                  TDButton(
                    text: 'Annulla',
                    type: TDButtonType.text,
                    theme: TDButtonTheme.defaultTheme,
                    onTap: () => manager.pauseDownload(),
                  ),
                ],
                if (state.status == ModelDownloadStatus.ready)
                  TDButton(
                    text: 'Elimina modello',
                    iconWidget: const Icon(Icons.delete_outline, size: 18,
                        color: PhoenixColors.error),
                    type: TDButtonType.text,
                    theme: TDButtonTheme.defaultTheme,
                    onTap: () => _confirmDelete(context, ref),
                  ),
              ],
            ),
          ],
        ),
    );
  }

  Color _statusColor(ModelDownloadStatus status) {
    switch (status) {
      case ModelDownloadStatus.ready:
        return PhoenixColors.success;
      case ModelDownloadStatus.downloading:
      case ModelDownloadStatus.verifying:
      case ModelDownloadStatus.checking:
        return PhoenixColors.warning;
      case ModelDownloadStatus.error:
        return PhoenixColors.error;
      default:
        return PhoenixColors.darkTextTertiary;
    }
  }

  String _statusSubtitle(ModelDownloadState state) {
    switch (state.status) {
      case ModelDownloadStatus.idle:
        return 'Modello: BitNet 2B4T (1.2 GB)';
      case ModelDownloadStatus.checking:
        return 'Verifica...';
      case ModelDownloadStatus.downloading:
        return 'Download in corso...';
      case ModelDownloadStatus.paused:
        return 'Download in pausa — ${state.progressLabel}';
      case ModelDownloadStatus.verifying:
        return 'Verifica integrita...';
      case ModelDownloadStatus.ready:
        return 'Modello: BitNet 2B4T — 2.3 GB su disco';
      case ModelDownloadStatus.error:
        return 'Errore';
    }
  }

  void _startDownload(WidgetRef ref) {
    final manager = ref.read(modelManagerProvider);
    const manifest = ModelManifest.defaultManifest;
    final url = manifest.downloadUrl;
    final expectedSha256 = manifest.sha256Hash;
    if (url.isEmpty || !url.startsWith('https://')) {
      manager.setError('URL del modello non configurato. Aggiornamento necessario.');
      return;
    }
    manager.download(
      url: url,
      expectedSha256: expectedSha256.isNotEmpty ? expectedSha256 : null,
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminare il modello?'),
        content: const Text(
            'Il modello verra eliminato dal dispositivo. Potrai riscaricarlo in qualsiasi momento.'),
        actions: [
          TDButton(
            text: 'Annulla',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx),
          ),
          TDButton(
            text: 'Elimina',
            type: TDButtonType.fill,
            theme: TDButtonTheme.danger,
            size: TDButtonSize.large,
            onTap: () {
              Navigator.pop(ctx);
              ref.read(modelManagerProvider).deleteModel();
            },
          ),
        ],
      ),
    );
  }
}
