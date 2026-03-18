import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';

/// Modal medical disclaimer that MUST be accepted before accessing
/// nutrition, supplements, or fasting content.
///
/// - Checkbox must be manually checked before button activates
/// - Acceptance stored in AppSettings with timestamp
/// - Re-shown every 90 days
class MedicalDisclaimerDialog extends ConsumerStatefulWidget {
  const MedicalDisclaimerDialog({super.key});

  /// Shows the disclaimer if needed. Returns true if accepted (or already valid).
  static Future<bool> showIfNeeded(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    if (settings.isDisclaimerValid) return true;

    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MedicalDisclaimerDialog(),
    );
    return accepted == true;
  }

  @override
  ConsumerState<MedicalDisclaimerDialog> createState() =>
      _MedicalDisclaimerDialogState();
}

class _MedicalDisclaimerDialogState
    extends ConsumerState<MedicalDisclaimerDialog> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final textColor = context.phoenix.textPrimary;
    final subtitleColor = context.phoenix.textSecondary;
    final surfaceColor = context.phoenix.surface;
    final borderColor = context.phoenix.border;

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.lg),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'AVVISO IMPORTANTE',
                style: PhoenixTypography.titleLarge.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Spacing.md),

              // Body
              Text(
                'Phoenix fornisce informazioni basate su letteratura scientifica '
                'a scopo ESCLUSIVAMENTE educativo e informativo.\n\n'
                'Phoenix NON è un dispositivo medico, NON fornisce diagnosi, e '
                'NON sostituisce il parere di un medico, un nutrizionista o '
                'altro professionista sanitario abilitato.\n\n'
                'Prima di iniziare qualsiasi protocollo alimentare, di '
                'integrazione o di digiuno, CONSULTA IL TUO MEDICO, '
                'specialmente se:',
                style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
              ),
              const SizedBox(height: Spacing.sm),

              // Bullet points
              _bullet('Hai patologie pregresse', textColor),
              _bullet('Assumi farmaci', textColor),
              _bullet('Sei in gravidanza o allattamento', textColor),
              _bullet('Hai meno di 18 anni', textColor),
              const SizedBox(height: Spacing.md),

              Text(
                'Gli integratori suggeriti non sono prescrizioni mediche. '
                'I dosaggi sono indicativi e vanno validati dal tuo medico '
                'in base ai tuoi esami del sangue.\n\n'
                "L'uso dell'app è sotto la tua esclusiva responsabilità.",
                style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
              ),
              const SizedBox(height: Spacing.lg),

              // Checkbox
              GestureDetector(
                onTap: () => setState(() => _checked = !_checked),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _checked,
                        onChanged: (v) =>
                            setState(() => _checked = v ?? false),
                        activeColor: textColor,
                        checkColor: surfaceColor,
                        side: BorderSide(color: subtitleColor),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        'Ho letto, compreso e accettato. Mi impegno a '
                        'consultare un professionista sanitario prima di '
                        'seguire qualsiasi indicazione.',
                        style: PhoenixTypography.bodyMedium
                            .copyWith(color: subtitleColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.lg),

              // Accept button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checked
                      ? () {
                          ref
                              .read(settingsProvider.notifier)
                              .setDisclaimerAccepted();
                          Navigator.of(context).pop(true);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _checked ? textColor : borderColor,
                    foregroundColor: surfaceColor,
                    disabledBackgroundColor: borderColor,
                    disabledForegroundColor: subtitleColor,
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                  ),
                  child: Text(
                    'ACCETTO E PROSEGUO',
                    style: PhoenixTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: Spacing.md, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: PhoenixTypography.bodyLarge.copyWith(color: color)),
          Expanded(
            child: Text(
              text,
              style: PhoenixTypography.bodyLarge.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
