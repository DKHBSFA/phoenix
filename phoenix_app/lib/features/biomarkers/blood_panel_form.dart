import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/models/biomarker_reference_ranges.dart';
import '../../core/models/biomarker_alerts.dart';
import '../../shared/widgets/phoenix_switch_tile.dart';

class BloodPanelForm extends ConsumerStatefulWidget {
  const BloodPanelForm({super.key});

  @override
  ConsumerState<BloodPanelForm> createState() => _BloodPanelFormState();
}

class _BloodPanelFormState extends ConsumerState<BloodPanelForm> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  final _labController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _showExtended = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Create controllers for all markers
    for (final section in BiomarkerReferenceRanges.sections) {
      for (final marker in section.markers) {
        if (!marker.computed) {
          _controllers[marker.key] = TextEditingController();
        }
      }
    }
    for (final section in BiomarkerReferenceRanges.extendedSections) {
      for (final marker in section.markers) {
        _controllers[marker.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _labController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final sex = profile?.sex ?? 'male';

    return Scaffold(
      appBar: TDNavBar(
        title: 'Analisi del sangue',
        rightBarItems: [
          TDNavBarItem(
            customWidget: GestureDetector(
              onTap: _saving ? null : () => _save(sex),
              child: Text(
                'Salva',
                style: TextStyle(
                  color: _saving ? context.phoenix.textQuaternary : context.phoenix.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.md),
          children: [
            // Date picker
            _DateRow(
              date: _date,
              onChanged: (d) => setState(() => _date = d),
            ),
            const SizedBox(height: Spacing.sm),

            // Lab name
            TextField(
              controller: _labController,
              decoration: const InputDecoration(
                labelText: 'Laboratorio (opzionale)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: Spacing.md),

            // Base panel sections
            for (final section in BiomarkerReferenceRanges.sections)
              _SectionTile(
                section: section,
                controllers: _controllers,
                sex: sex,
                allControllers: _controllers,
              ),

            const SizedBox(height: Spacing.md),

            // Extended panel toggle
            PhoenixSwitchTile(
              title: 'Panel esteso',
              subtitle: 'Ormoni, tiroide, vitamine',
              value: _showExtended,
              onChanged: (v) => setState(() => _showExtended = v),
            ),

            if (_showExtended)
              for (final section in BiomarkerReferenceRanges.extendedSections)
                _SectionTile(
                  section: section,
                  controllers: _controllers,
                  sex: sex,
                  allControllers: _controllers,
                ),

            const SizedBox(height: Spacing.lg),

            // Save button — Stitch pattern 3.15 shadow CTA
            SizedBox(
              width: double.infinity,
              height: TouchTargets.buttonHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Radii.md),
                  boxShadow: const [],
                ),
                child: _saving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: TDLoading(size: TDLoadingSize.small),
                      )
                    : TDButton(
                        text: 'Salva analisi',
                        type: TDButtonType.fill,
                        theme: TDButtonTheme.primary,
                        size: TDButtonSize.large,
                        isBlock: true,
                        onTap: () => _save(sex),
                      ),
              ),
            ),
            const SizedBox(height: Spacing.xxl),
          ],
        ),
      ),
    );
  }

  Future<void> _save(String sex) async {
    setState(() => _saving = true);

    try {
      final values = <String, dynamic>{
        'date': _date.toIso8601String().substring(0, 10),
        'lab': _labController.text.trim(),
      };

      // Collect all non-empty values with biomarker-specific range validation
      for (final entry in _controllers.entries) {
        final text = entry.value.text.trim();
        if (text.isNotEmpty) {
          final parsed = double.tryParse(text);
          if (parsed != null && parsed >= 0) {
            final maxVal = _biomarkerMaxValues[entry.key] ?? 10000.0;
            if (parsed <= maxVal) {
              values[entry.key] = parsed;
            }
          }
        }
      }

      // Compute non-HDL if both values present
      if (values['cholesterol_total'] != null && values['hdl'] != null) {
        values['non_hdl'] = (values['cholesterol_total'] as double) -
            (values['hdl'] as double);
      }

      final dao = ref.read(biomarkerDaoProvider);

      await dao.addBiomarker(BiomarkersCompanion.insert(
        date: _date,
        type: BiomarkerType.bloodPanel,
        valuesJson: jsonEncode(values),
      ));

      // Check for alerts
      if (mounted) {
        // Get previous panel for comparison
        final previousPanels =
            await dao.getByType(BiomarkerType.bloodPanel, limit: 2);
        Map<String, dynamic>? previousValues;
        if (previousPanels.length >= 2) {
          try {
            final decoded = jsonDecode(previousPanels[1].valuesJson);
            if (decoded is Map<String, dynamic>) {
              previousValues = decoded;
            }
          } catch (_) {
            // Previous panel data corrupted — skip comparison
          }
        }

        final alerts = BiomarkerAlerts.check(values, previousValues, sex);
        if (alerts.isNotEmpty && mounted) {
          await _showAlertDialog(alerts);
        }

        if (mounted) Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Maximum plausible values per biomarker (prevents nonsensical entries).
  static const _biomarkerMaxValues = <String, double>{
    'glucose': 600, // mg/dL
    'hba1c': 20, // %
    'triglycerides': 2000, // mg/dL
    'cholesterol_total': 500, // mg/dL
    'hdl': 200, // mg/dL
    'ast': 500, // U/L
    'alt': 500, // U/L
    'ggt': 1000, // U/L
    'alkaline_phosphatase': 500, // U/L
    'creatinine': 15, // mg/dL
    'albumin': 10, // g/dL
    'wbc': 50, // 10^3/μL
    'rbc': 10, // 10^6/μL
    'hemoglobin': 25, // g/dL
    'hematocrit': 70, // %
    'platelets': 1000, // 10^3/μL
    'lymphocytes': 90, // %
    'neutrophils': 95, // %
    'crp': 300, // mg/L
    'hscrp': 50, // mg/L
    'ferritin': 2000, // ng/mL
    'iron': 500, // μg/dL
    'testosterone_total': 2000, // ng/dL
    'cortisol': 60, // μg/dL
    'tsh': 50, // mIU/L
    'ft3': 10, // pg/mL
    'ft4': 5, // ng/dL
    'vitamin_d': 200, // ng/mL
    'vitamin_b12': 2000, // pg/mL
    'folate': 40, // ng/mL
    'homocysteine': 100, // μmol/L
    'insulin': 300, // μU/mL
    'igf1': 800, // ng/mL
    'dheas': 1000, // μg/dL
    'estradiol': 500, // pg/mL
    'psa': 100, // ng/mL
  };

  Future<void> _showAlertDialog(List<BiomarkerAlert> alerts) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: PhoenixColors.warning, size: 24),
            const SizedBox(width: Spacing.sm),
            const Text('Alert biomarker'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final alert in alerts) ...[
                _AlertCard(alert: alert),
                const SizedBox(height: Spacing.sm),
              ],
              const SizedBox(height: Spacing.sm),
              Text(
                'Queste sono indicazioni del protocollo Phoenix. Consulta il tuo medico.',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: ctx.phoenix.textTertiary,
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TDButton(
            text: 'Capito',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final BiomarkerAlert alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = alert.severity == AlertSeverity.high
        ? PhoenixColors.error
        : PhoenixColors.warning;

    return Container(
      padding: const EdgeInsets.all(Spacing.smMd),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: Spacing.xs),
          Text(alert.message, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Spacing.xs),
          Text('→ ${alert.action}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  const _DateRow({required this.date, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data analisi',
          border: OutlineInputBorder(),
          isDense: true,
          suffixIcon: Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final BiomarkerSection section;
  final Map<String, TextEditingController> controllers;
  final String sex;
  final Map<String, TextEditingController> allControllers;

  const _SectionTile({
    required this.section,
    required this.controllers,
    required this.sex,
    required this.allControllers,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      // Stitch pattern 3.13 section header
      title: Row(
        children: [
          Icon(Icons.biotech, color: PhoenixColors.biomarkersAccent, size: 18),
          const SizedBox(width: Spacing.sm),
          Text(section.name,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md, vertical: Spacing.sm),
          child: Column(
            children: [
              for (final marker in section.markers)
                if (!marker.computed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: _MarkerField(
                      marker: marker,
                      controller: controllers[marker.key]!,
                      sex: sex,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MarkerField extends StatelessWidget {
  final MarkerDef marker;
  final TextEditingController controller;
  final String sex;

  const _MarkerField({
    required this.marker,
    required this.controller,
    required this.sex,
  });

  @override
  Widget build(BuildContext context) {
    final range = BiomarkerReferenceRanges.getRange(marker.key, sex);
    final rangeText = range?.displayString ?? '';

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: marker.label,
        suffixText: marker.unit,
        helperText: rangeText.isNotEmpty ? 'Rif: $rangeText' : null,
        helperStyle: TextStyle(
          color: context.phoenix.textTertiary,
          fontSize: 12,
        ),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (_) {
        // Trigger color change if value out of range
        final val = double.tryParse(controller.text.trim());
        if (val != null && range != null && !range.isNormal(val)) {
          // Value out of range — visual indicator handled by decoration
        }
      },
    );
  }
}
