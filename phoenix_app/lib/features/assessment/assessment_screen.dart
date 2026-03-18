import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/models/assessment_scoring.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({super.key});

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  bool _showingForm = false;

  @override
  Widget build(BuildContext context) {
    final textColor = context.phoenix.textPrimary;
    final bgColor = context.phoenix.bg;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Assessment',
          style: PhoenixTypography.titleLarge.copyWith(color: textColor),
        ),
        actions: [
          if (!_showingForm)
            IconButton(
              icon: Icon(Icons.add, color: textColor),
              onPressed: () => setState(() => _showingForm = true),
              tooltip: 'Nuovo assessment',
            ),
        ],
      ),
      body: _showingForm
          ? _AssessmentForm(
              onComplete: () => setState(() => _showingForm = false),
              onCancel: () => setState(() => _showingForm = false),
            )
          : const _AssessmentHistory(),
    );
  }
}

// ─── Assessment Form ──────────────────────────────────────────────

class _AssessmentForm extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const _AssessmentForm({required this.onComplete, required this.onCancel});

  @override
  ConsumerState<_AssessmentForm> createState() => _AssessmentFormState();
}

class _AssessmentFormState extends ConsumerState<_AssessmentForm> {
  final _pushupCtrl = TextEditingController();
  final _wallSitCtrl = TextEditingController();
  final _plankCtrl = TextEditingController();
  final _sitReachCtrl = TextEditingController();
  final _cooperCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _chestCtrl = TextEditingController();
  final _armCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  int _expandedTest = -1;
  bool _saving = false;

  @override
  void dispose() {
    _pushupCtrl.dispose();
    _wallSitCtrl.dispose();
    _plankCtrl.dispose();
    _sitReachCtrl.dispose();
    _cooperCtrl.dispose();
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    _chestCtrl.dispose();
    _armCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.phoenix.textPrimary;
    final subtitleColor = context.phoenix.textSecondary;
    final surfaceColor = context.phoenix.surface;
    final borderColor = context.phoenix.border;

    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      children: [
        Text(
          'Nuovo Assessment',
          style: PhoenixTypography.titleLarge.copyWith(color: textColor),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          'Completa i test che riesci. Tap su ogni test per le istruzioni.',
          style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
        ),
        const SizedBox(height: Spacing.lg),

        // Test cards
        ...AssessmentTests.tests.asMap().entries.map((entry) {
          final i = entry.key;
          final test = entry.value;
          final ctrl = _controllerForTest(test.id);
          final isExpanded = _expandedTest == i;

          return Padding(
            padding: const EdgeInsets.only(bottom: Spacing.cardGap),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  // Header row
                  InkWell(
                    onTap: () => setState(() {
                      _expandedTest = isExpanded ? -1 : i;
                    }),
                    borderRadius: BorderRadius.circular(Radii.lg),
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.md),
                      child: Row(
                        children: [
                          Text(test.icon, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: Spacing.smMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      test.name,
                                      style: PhoenixTypography.titleMedium
                                          .copyWith(color: textColor),
                                    ),
                                    if (test.optional) ...[
                                      const SizedBox(width: Spacing.sm),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: borderColor),
                                          borderRadius: BorderRadius.circular(Radii.sm),
                                        ),
                                        child: Text(
                                          'Opzionale',
                                          style: PhoenixTypography.caption
                                              .copyWith(color: subtitleColor),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '${test.measure} (${test.unit})',
                                  style: PhoenixTypography.bodyMedium
                                      .copyWith(color: subtitleColor),
                                ),
                              ],
                            ),
                          ),
                          // Input field inline
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: ctrl,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[\d.-]'),
                                ),
                              ],
                              textAlign: TextAlign.center,
                              style: PhoenixTypography.numeric.copyWith(
                                color: textColor,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                hintText: '—',
                                hintStyle: TextStyle(color: subtitleColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Radii.sm),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Radii.sm),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Spacing.sm,
                                  horizontal: Spacing.sm,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Icon(
                            isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: subtitleColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded instructions
                  if (isExpanded) ...[
                    Divider(height: 1, color: borderColor),
                    Padding(
                      padding: const EdgeInsets.all(Spacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Istruzioni',
                            style: PhoenixTypography.bodyLarge.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          ...test.instructions.asMap().entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: Spacing.xs,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    child: Text(
                                      '${e.key + 1}.',
                                      style: PhoenixTypography.bodyMedium
                                          .copyWith(
                                        color: subtitleColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.value,
                                      style: PhoenixTypography.bodyMedium
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            'Fonte: ${test.source}',
                            style: PhoenixTypography.caption
                                .copyWith(color: subtitleColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),

        // Measurements section
        const SizedBox(height: Spacing.md),
        Text(
          'Misure corporee',
          style: PhoenixTypography.titleMedium.copyWith(color: textColor),
        ),
        const SizedBox(height: Spacing.smMd),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            children: [
              _MeasureRow(
                label: 'Peso',
                unit: 'kg',
                controller: _weightCtrl,
                textColor: textColor,
                subtitleColor: subtitleColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: Spacing.smMd),
              _MeasureRow(
                label: 'Vita',
                unit: 'cm',
                controller: _waistCtrl,
                textColor: textColor,
                subtitleColor: subtitleColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: Spacing.smMd),
              _MeasureRow(
                label: 'Petto',
                unit: 'cm',
                controller: _chestCtrl,
                textColor: textColor,
                subtitleColor: subtitleColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: Spacing.smMd),
              _MeasureRow(
                label: 'Braccio',
                unit: 'cm',
                controller: _armCtrl,
                textColor: textColor,
                subtitleColor: subtitleColor,
                borderColor: borderColor,
              ),
            ],
          ),
        ),

        // Notes
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _notesCtrl,
          maxLines: 3,
          style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
          decoration: InputDecoration(
            hintText: 'Note (opzionale)',
            hintStyle: TextStyle(color: subtitleColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Radii.lg),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Radii.lg),
              borderSide: BorderSide(color: borderColor),
            ),
            filled: true,
            fillColor: surfaceColor,
          ),
        ),

        // Buttons
        const SizedBox(height: Spacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.lg),
                  ),
                ),
                child: const Text('Annulla'),
              ),
            ),
            const SizedBox(width: Spacing.smMd),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: textColor,
                  foregroundColor: context.phoenix.bg,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.lg),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salva Assessment'),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xl),
      ],
    );
  }

  TextEditingController _controllerForTest(String testId) {
    switch (testId) {
      case 'pushup':
        return _pushupCtrl;
      case 'wall_sit':
        return _wallSitCtrl;
      case 'plank':
        return _plankCtrl;
      case 'sit_and_reach':
        return _sitReachCtrl;
      case 'cooper':
        return _cooperCtrl;
      default:
        return _pushupCtrl;
    }
  }

  Future<void> _save() async {
    // At least one test must be filled
    final hasAnyValue = _pushupCtrl.text.isNotEmpty ||
        _wallSitCtrl.text.isNotEmpty ||
        _plankCtrl.text.isNotEmpty ||
        _sitReachCtrl.text.isNotEmpty ||
        _cooperCtrl.text.isNotEmpty ||
        _weightCtrl.text.isNotEmpty;

    if (!hasAnyValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila almeno un test.')),
      );
      return;
    }

    setState(() => _saving = true);

    final profile = await ref.read(userProfileProvider.future);
    final sex = profile?.sex ?? 'male';
    final age = profile?.birthYear != null
        ? DateTime.now().year - profile!.birthYear
        : 30;

    final pushupReps = int.tryParse(_pushupCtrl.text);
    final wallSitSec = int.tryParse(_wallSitCtrl.text);
    final plankSec = int.tryParse(_plankCtrl.text);
    final sitReachCm = double.tryParse(_sitReachCtrl.text);
    final cooperM = double.tryParse(_cooperCtrl.text);
    final weightKg = double.tryParse(_weightCtrl.text);
    final waistCm = double.tryParse(_waistCtrl.text);
    final chestCm = double.tryParse(_chestCtrl.text);
    final armCm = double.tryParse(_armCtrl.text);

    final scoresJson = AssessmentScoring.generateScoresJson(
      pushupReps: pushupReps,
      wallSitSeconds: wallSitSec,
      plankSeconds: plankSec,
      sitAndReachCm: sitReachCm,
      cooperDistanceM: cooperM,
      sex: sex,
      age: age,
    );

    final dao = ref.read(assessmentDaoProvider);
    await dao.addAssessment(AssessmentsCompanion(
      date: drift.Value(DateTime.now()),
      pushupMaxReps: drift.Value(pushupReps),
      wallSitSeconds: drift.Value(wallSitSec),
      plankHoldSeconds: drift.Value(plankSec),
      sitAndReachCm: drift.Value(sitReachCm),
      cooperDistanceM: drift.Value(cooperM),
      weightKg: drift.Value(weightKg),
      waistCm: drift.Value(waistCm),
      chestCm: drift.Value(chestCm),
      armCm: drift.Value(armCm),
      notes: drift.Value(_notesCtrl.text),
      scoresJson: drift.Value(scoresJson),
    ));

    if (mounted) {
      HapticFeedback.mediumImpact();
      widget.onComplete();
    }
  }
}

// ─── Measurement Row ─────────────────────────────────────────────

class _MeasureRow extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final Color textColor;
  final Color subtitleColor;
  final Color borderColor;

  const _MeasureRow({
    required this.label,
    required this.unit,
    required this.controller,
    required this.textColor,
    required this.subtitleColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: PhoenixTypography.bodyLarge.copyWith(color: textColor),
          ),
        ),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            textAlign: TextAlign.center,
            style: PhoenixTypography.numeric.copyWith(
              color: textColor,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              hintText: '—',
              hintStyle: TextStyle(color: subtitleColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.sm),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.sm),
                borderSide: BorderSide(color: borderColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: Spacing.sm,
                horizontal: Spacing.sm,
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        SizedBox(
          width: 28,
          child: Text(
            unit,
            style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
          ),
        ),
      ],
    );
  }
}

// ─── Assessment History ──────────────────────────────────────────

class _AssessmentHistory extends ConsumerWidget {
  const _AssessmentHistory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = context.phoenix.textPrimary;
    final subtitleColor = context.phoenix.textSecondary;
    final surfaceColor = context.phoenix.surface;
    final borderColor = context.phoenix.border;

    final assessmentsStream = ref.watch(assessmentDaoProvider).watchAll();

    return StreamBuilder<List<Assessment>>(
      stream: assessmentsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _EmptyState(
            textColor: textColor,
            subtitleColor: subtitleColor,
          );
        }

        final assessments = snapshot.data!;
        final latest = assessments.first;

        return ListView(
          padding: const EdgeInsets.all(Spacing.screenH),
          children: [
            // Status card
            _DueStatusCard(
              assessments: assessments,
              textColor: textColor,
              subtitleColor: subtitleColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: Spacing.lg),

            // Trend charts (if 2+ assessments)
            if (assessments.length >= 2) ...[
              Text(
                'Trend',
                style: PhoenixTypography.titleMedium.copyWith(color: textColor),
              ),
              const SizedBox(height: Spacing.smMd),
              _TrendChart(
                label: 'Push-up',
                unit: 'reps',
                assessments: assessments,
                valueExtractor: (a) => a.pushupMaxReps?.toDouble(),
                textColor: textColor,
                subtitleColor: subtitleColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
              ),
              _TrendChart(
                label: 'Plank',
                unit: 's',
                assessments: assessments,
                valueExtractor: (a) => a.plankHoldSeconds?.toDouble(),
                textColor: textColor,
                subtitleColor: subtitleColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
              ),
              _TrendChart(
                label: 'Wall Sit',
                unit: 's',
                assessments: assessments,
                valueExtractor: (a) => a.wallSitSeconds?.toDouble(),
                textColor: textColor,
                subtitleColor: subtitleColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: Spacing.lg),
            ],

            // History list
            Text(
              'Storico',
              style: PhoenixTypography.titleMedium.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.smMd),
            for (var i = 0; i < assessments.length; i++)
              _AssessmentCard(
                assessment: assessments[i],
                isLatest: assessments[i].id == latest.id,
                previous: i < assessments.length - 1
                    ? assessments[i + 1]
                    : null,
                textColor: textColor,
                subtitleColor: subtitleColor,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
              ),
          ],
        );
      },
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final Color textColor;
  final Color subtitleColor;

  const _EmptyState({required this.textColor, required this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center, size: 64, color: subtitleColor),
            const SizedBox(height: Spacing.md),
            Text(
              'Nessun assessment',
              style: PhoenixTypography.titleLarge.copyWith(color: textColor),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Completa il tuo primo assessment per misurare il tuo punto di partenza. '
              'Il test si ripete ogni 4 settimane per tracciare i progressi.',
              textAlign: TextAlign.center,
              style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              '5 test validati: Push-up, Wall Sit, Plank, Sit & Reach, Cooper',
              textAlign: TextAlign.center,
              style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Due Status Card ────────────────────────────────────────────

class _DueStatusCard extends ConsumerWidget {
  final List<Assessment> assessments;
  final Color textColor;
  final Color subtitleColor;
  final Color surfaceColor;
  final Color borderColor;

  const _DueStatusCard({
    required this.assessments,
    required this.textColor,
    required this.subtitleColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = assessments.first;
    final daysSince = DateTime.now().difference(latest.date).inDays;
    final isDue = daysSince >= 28;
    final daysLeft = (28 - daysSince).clamp(0, 28);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: isDue ? PhoenixColors.completed : borderColor,
          width: isDue ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDue
                  ? PhoenixColors.completed.withAlpha(31)
                  : borderColor.withAlpha(31),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Center(
              child: Icon(
                isDue ? Icons.check_circle : Icons.schedule,
                color: isDue ? PhoenixColors.completed : subtitleColor,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDue
                      ? 'Assessment disponibile!'
                      : 'Prossimo tra $daysLeft giorni',
                  style: PhoenixTypography.titleMedium.copyWith(color: textColor),
                ),
                Text(
                  'Ultimo: ${DateFormat('d MMM yyyy', 'it_IT').format(latest.date)} '
                  '($daysSince giorni fa)',
                  style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
                ),
              ],
            ),
          ),
          if (!isDue)
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: daysSince / 28,
                    strokeWidth: 4,
                    backgroundColor: borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                  Text(
                    '$daysSince',
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Trend Chart ─────────────────────────────────────────────────

class _TrendChart extends StatelessWidget {
  final String label;
  final String unit;
  final List<Assessment> assessments;
  final double? Function(Assessment) valueExtractor;
  final Color textColor;
  final Color subtitleColor;
  final Color surfaceColor;
  final Color borderColor;

  const _TrendChart({
    required this.label,
    required this.unit,
    required this.assessments,
    required this.valueExtractor,
    required this.textColor,
    required this.subtitleColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Filter assessments with valid values, reversed for chronological order
    final dataPoints = assessments.reversed
        .where((a) => valueExtractor(a) != null)
        .toList();

    if (dataPoints.length < 2) return const SizedBox.shrink();

    final spots = dataPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), valueExtractor(e.value)!);
    }).toList();

    final latest = valueExtractor(dataPoints.last)!;
    final first = valueExtractor(dataPoints.first)!;
    final delta = latest - first;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: PhoenixTypography.bodyLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${latest.toStringAsFixed(latest == latest.roundToDouble() ? 0 : 1)} $unit',
                      style: PhoenixTypography.numeric.copyWith(
                        color: textColor,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: delta >= 0
                            ? PhoenixColors.success.withAlpha(31)
                            : PhoenixColors.error.withAlpha(31),
                        borderRadius: BorderRadius.circular(Radii.sm),
                      ),
                      child: Text(
                        '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(delta == delta.roundToDouble() ? 0 : 1)}',
                        style: PhoenixTypography.caption.copyWith(
                          color: delta >= 0
                              ? PhoenixColors.success
                              : PhoenixColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Spacing.smMd),
            SizedBox(
              height: 80,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: textColor,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: textColor,
                            strokeWidth: 0,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: textColor.withAlpha(20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Assessment Card (history item) ─────────────────────────────

class _AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  final Assessment? previous;
  final bool isLatest;
  final Color textColor;
  final Color subtitleColor;
  final Color surfaceColor;
  final Color borderColor;

  const _AssessmentCard({
    required this.assessment,
    required this.isLatest,
    this.previous,
    required this.textColor,
    required this.subtitleColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.cardGap),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(
            color: isLatest ? textColor.withAlpha(80) : borderColor,
          ),
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMMM yyyy', 'it_IT').format(assessment.date),
                  style: PhoenixTypography.titleMedium.copyWith(color: textColor),
                ),
                if (isLatest)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: Text(
                      'Ultimo',
                      style: PhoenixTypography.caption.copyWith(
                        color: surfaceColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.smMd),

            // Results grid
            Wrap(
              spacing: Spacing.md,
              runSpacing: Spacing.sm,
              children: [
                if (assessment.pushupMaxReps != null)
                  _ResultChip(
                    label: 'Push-up',
                    value: '${assessment.pushupMaxReps}',
                    unit: 'reps',
                    delta: previous?.pushupMaxReps != null
                        ? assessment.pushupMaxReps! - previous!.pushupMaxReps!
                        : null,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                if (assessment.plankHoldSeconds != null)
                  _ResultChip(
                    label: 'Plank',
                    value: '${assessment.plankHoldSeconds}',
                    unit: 's',
                    delta: previous?.plankHoldSeconds != null
                        ? assessment.plankHoldSeconds! -
                            previous!.plankHoldSeconds!
                        : null,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                if (assessment.wallSitSeconds != null)
                  _ResultChip(
                    label: 'Wall Sit',
                    value: '${assessment.wallSitSeconds}',
                    unit: 's',
                    delta: previous?.wallSitSeconds != null
                        ? assessment.wallSitSeconds! -
                            previous!.wallSitSeconds!
                        : null,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                if (assessment.sitAndReachCm != null)
                  _ResultChip(
                    label: 'Flessibilità',
                    value: assessment.sitAndReachCm!.toStringAsFixed(1),
                    unit: 'cm',
                    delta: previous?.sitAndReachCm != null
                        ? (assessment.sitAndReachCm! -
                                previous!.sitAndReachCm!)
                            .toDouble()
                        : null,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                if (assessment.cooperDistanceM != null)
                  _ResultChip(
                    label: 'Cooper',
                    value: assessment.cooperDistanceM!.toStringAsFixed(0),
                    unit: 'm',
                    delta: previous?.cooperDistanceM != null
                        ? (assessment.cooperDistanceM! -
                                previous!.cooperDistanceM!)
                            .toDouble()
                        : null,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                if (assessment.weightKg != null)
                  _ResultChip(
                    label: 'Peso',
                    value: assessment.weightKg!.toStringAsFixed(1),
                    unit: 'kg',
                    delta: previous?.weightKg != null
                        ? (assessment.weightKg! - previous!.weightKg!)
                            .toDouble()
                        : null,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    invertDelta: true, // lower weight = improvement for most
                  ),
              ],
            ),

            if (assessment.notes.isNotEmpty) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                assessment.notes,
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: subtitleColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final num? delta;
  final Color textColor;
  final Color subtitleColor;
  final bool invertDelta;

  const _ResultChip({
    required this.label,
    required this.value,
    required this.unit,
    this.delta,
    required this.textColor,
    required this.subtitleColor,
    this.invertDelta = false,
  });

  @override
  Widget build(BuildContext context) {
    final isImproved = delta != null &&
        (invertDelta ? delta! < 0 : delta! > 0);
    final isWorse = delta != null &&
        (invertDelta ? delta! > 0 : delta! < 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PhoenixTypography.caption.copyWith(color: subtitleColor),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value $unit',
              style: PhoenixTypography.bodyLarge.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (delta != null && delta != 0) ...[
              const SizedBox(width: 4),
              Text(
                '${delta! > 0 ? '+' : ''}${delta is double ? (delta as double).toStringAsFixed(1) : delta}',
                style: PhoenixTypography.caption.copyWith(
                  color: isImproved
                      ? PhoenixColors.success
                      : isWorse
                          ? PhoenixColors.error
                          : subtitleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
