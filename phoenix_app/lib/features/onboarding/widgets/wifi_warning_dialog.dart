import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../app/design_tokens.dart';

/// Dialog shown when user is about to download 1.2 GB on mobile data.
class WifiWarningDialog extends StatelessWidget {
  const WifiWarningDialog({super.key});

  /// Shows the WiFi warning dialog. Returns true if user wants to continue.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const WifiWarningDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleColor = context.phoenix.textSecondary;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.signal_cellular_alt, color: PhoenixColors.warning),
          SizedBox(width: Spacing.sm),
          Text('Dati mobili'),
        ],
      ),
      content: Text(
        'Stai per scaricare 1.2 GB su dati mobili. '
        'Il coach AI funziona interamente offline — questo è l\'unico download necessario.',
        style: theme.textTheme.bodyMedium?.copyWith(color: subtitleColor),
      ),
      actions: [
        TDButton(
          text: 'Aspetta WiFi',
          type: TDButtonType.outline,
          theme: TDButtonTheme.defaultTheme,
          size: TDButtonSize.medium,
          onTap: () => Navigator.of(context).pop(false),
        ),
        TDButton(
          text: 'Scarica ora',
          type: TDButtonType.fill,
          theme: TDButtonTheme.primary,
          size: TDButtonSize.medium,
          onTap: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
