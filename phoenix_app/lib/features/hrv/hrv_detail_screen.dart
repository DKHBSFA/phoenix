import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/design_tokens.dart';
import '../../core/models/hrv_engine.dart';

class HrvDetailScreen extends StatefulWidget {
  const HrvDetailScreen({super.key});

  @override
  State<HrvDetailScreen> createState() => _HrvDetailScreenState();
}

class _HrvDetailScreenState extends State<HrvDetailScreen> {
  final _rmssdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedSource = 'manual';
  final List<HrvReading> _readings = [];

  HrvBaseline get _baseline => HrvAnalysis.computeBaseline(_readings);

  static const _sources = <String, String>{
    'manual': 'Manuale',
    'apple_watch': 'Apple Watch',
    'garmin': 'Garmin',
    'oura': 'Oura',
  };

  @override
  void dispose() {
    _rmssdController.dispose();
    super.dispose();
  }

  void _addReading() {
    if (!_formKey.currentState!.validate()) return;

    final rmssd = double.parse(_rmssdController.text.trim());
    setState(() {
      _readings.insert(
        0,
        HrvReading(
          timestamp: DateTime.now(),
          rmssd: rmssd,
          source: _selectedSource,
        ),
      );
      _rmssdController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ph = context.phoenix;
    final baseline = _baseline;

    return Scaffold(
      backgroundColor: ph.bg,
      appBar: AppBar(
        backgroundColor: ph.bg,
        foregroundColor: ph.textPrimary,
        title: Text(
          'HRV — VARIABILITÀ CARDIACA',
          style: PhoenixTypography.h3.copyWith(color: ph.textPrimary),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH,
          vertical: Spacing.screenTop,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(ph, baseline),
            const SizedBox(height: Spacing.cardGap),
            _buildChartPlaceholder(ph),
            const SizedBox(height: Spacing.cardGap),
            _buildInputSection(ph),
            const SizedBox(height: Spacing.cardGap),
            _buildBaselineInfoCard(ph, baseline),
            const SizedBox(height: Spacing.cardGap),
            _buildRecoveryLegendCard(ph),
            const SizedBox(height: Spacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Text(
                'LnRMSSD è il gold standard per la variabilità cardiaca. '
                'Misura ogni mattina al risveglio.',
                style: PhoenixTypography.caption.copyWith(
                  color: ph.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }

  // ── Status card ──────────────────────────────────────────────────

  Widget _buildStatusCard(dynamic ph, HrvBaseline baseline) {
    if (!baseline.isEstablished) {
      final daysIn = baseline.readingsCount;
      return Container(
        padding: const EdgeInsets.all(CardTokens.padding),
        decoration: BoxDecoration(
          color: ph.surface,
          border: Border.all(color: ph.border, width: Borders.medium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GIORNO $daysIn/14',
              style: PhoenixTypography.h2.copyWith(color: ph.textPrimary),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              'Inserisci misurazioni mattutine per stabilire la baseline',
              style: PhoenixTypography.bodyMedium.copyWith(
                color: ph.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Baseline established — show today's status
    final todayReading = _readings.isNotEmpty ? _readings.first : null;
    final consecutiveLow = HrvAnalysis.countConsecutiveLowDays(
      _readings,
      baseline,
    );
    final recommendation = todayReading != null
        ? HrvAnalysis.recommend(
            baseline: baseline,
            todayLnRmssd: todayReading.lnRmssd,
            consecutiveLowDays: consecutiveLow,
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: ph.surface,
        border: Border.all(color: ph.border, width: Borders.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'OGGI',
                style: PhoenixTypography.h3.copyWith(color: ph.textPrimary),
              ),
              const Spacer(),
              if (recommendation != null)
                _buildStatusBadge(recommendation.status),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          if (todayReading != null) ...[
            Text(
              'LnRMSSD: ${todayReading.lnRmssd.toStringAsFixed(2)}',
              style: PhoenixTypography.numeric.copyWith(
                color: ph.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            if (recommendation != null) ...[
              Text(
                'Volume: ${(recommendation.volumeMultiplier * 100).toInt()}%',
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: ph.textSecondary,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                recommendation.coachMessage,
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: ph.textSecondary,
                ),
              ),
            ],
          ] else
            Text(
              'Nessuna lettura oggi. Aggiungi la misurazione mattutina.',
              style: PhoenixTypography.bodyMedium.copyWith(
                color: ph.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(RecoveryStatus status) {
    final (label, color) = switch (status) {
      RecoveryStatus.veryLow => ('MOLTO BASSO', PhoenixColors.error),
      RecoveryStatus.low => ('BASSO', PhoenixColors.warning),
      RecoveryStatus.prenosological => ('PRENOSOLOGICO', PhoenixColors.warning),
      RecoveryStatus.normal => ('NORMALE', PhoenixColors.success),
      RecoveryStatus.high => ('ALTO', PhoenixColors.success),
      RecoveryStatus.suspiciouslyHigh => (
        'SOSPETTO',
        const Color(0xFFFF8800),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: Borders.medium),
      ),
      child: Text(
        label,
        style: PhoenixTypography.micro.copyWith(color: color),
      ),
    );
  }

  // ── Chart placeholder ────────────────────────────────────────────

  Widget _buildChartPlaceholder(dynamic ph) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: ph.surface,
        border: Border.all(color: ph.border, width: Borders.thin),
      ),
      child: Center(
        child: Text(
          'Grafico 30 giorni — in arrivo',
          style: PhoenixTypography.bodyMedium.copyWith(
            color: ph.textTertiary,
          ),
        ),
      ),
    );
  }

  // ── Manual input ─────────────────────────────────────────────────

  Widget _buildInputSection(dynamic ph) {
    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: ph.surface,
        border: Border.all(color: ph.border, width: Borders.medium),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'NUOVA LETTURA',
              style: PhoenixTypography.h3.copyWith(color: ph.textPrimary),
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _rmssdController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              style: PhoenixTypography.bodyLarge.copyWith(
                color: ph.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'RMSSD (ms)',
                hintStyle: PhoenixTypography.bodyLarge.copyWith(
                  color: ph.textTertiary,
                ),
                filled: true,
                fillColor: ph.bg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.smMd,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: BorderSide(
                    color: ph.border,
                    width: Borders.thin,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: BorderSide(
                    color: ph.borderHeavy,
                    width: Borders.medium,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: const BorderSide(
                    color: PhoenixColors.error,
                    width: Borders.thin,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: const BorderSide(
                    color: PhoenixColors.error,
                    width: Borders.medium,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Inserisci il valore RMSSD';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null) {
                  return 'Valore non valido';
                }
                if (parsed < 10 || parsed > 200) {
                  return 'RMSSD deve essere tra 10 e 200 ms';
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<String>(
              value: _selectedSource,
              dropdownColor: ph.elevated,
              style: PhoenixTypography.bodyLarge.copyWith(
                color: ph.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: ph.bg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.smMd,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: BorderSide(
                    color: ph.border,
                    width: Borders.thin,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                  borderSide: BorderSide(
                    color: ph.borderHeavy,
                    width: Borders.medium,
                  ),
                ),
              ),
              items: _sources.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedSource = v);
              },
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: TouchTargets.buttonHeight,
              child: OutlinedButton(
                onPressed: _addReading,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ph.textPrimary,
                  side: BorderSide(
                    color: ph.borderHeavy,
                    width: Borders.heavy,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  'AGGIUNGI LETTURA',
                  style: PhoenixTypography.button.copyWith(
                    color: ph.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Baseline info ────────────────────────────────────────────────

  Widget _buildBaselineInfoCard(dynamic ph, HrvBaseline baseline) {
    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: ph.surface,
        border: Border.all(color: ph.border, width: Borders.thin),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BASELINE',
            style: PhoenixTypography.h3.copyWith(color: ph.textPrimary),
          ),
          const SizedBox(height: Spacing.sm),
          _buildStatRow(
            ph,
            'Media 14gg',
            baseline.readingsCount >= 14
                ? baseline.mean14Day.toStringAsFixed(2)
                : '—',
          ),
          _buildStatRow(
            ph,
            'SD 14gg',
            baseline.readingsCount >= 14
                ? baseline.sd14Day.toStringAsFixed(2)
                : '—',
          ),
          _buildStatRow(
            ph,
            'SWC',
            baseline.isEstablished
                ? baseline.swc.toStringAsFixed(2)
                : '—',
          ),
          _buildStatRow(
            ph,
            'Letture',
            '${baseline.readingsCount}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(dynamic ph, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: PhoenixTypography.bodyMedium.copyWith(
              color: ph.textSecondary,
            ),
          ),
          Text(
            value,
            style: PhoenixTypography.bodyMedium.copyWith(
              color: ph.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Recovery legend ──────────────────────────────────────────────

  Widget _buildRecoveryLegendCard(dynamic ph) {
    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: ph.surface,
        border: Border.all(color: ph.border, width: Borders.thin),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATI DI RECUPERO',
            style: PhoenixTypography.h3.copyWith(color: ph.textPrimary),
          ),
          const SizedBox(height: Spacing.sm),
          _buildLegendRow(
            ph,
            PhoenixColors.error,
            'Molto basso',
            'Deload o riposo attivo. Volume -50%.',
          ),
          _buildLegendRow(
            ph,
            PhoenixColors.warning,
            'Basso',
            'Volume ridotto del 20%. 3+ giorni → deload.',
          ),
          _buildLegendRow(
            ph,
            PhoenixColors.warning,
            'Prenosologico',
            'Indice di stress alto, HRV nella norma. Monitorare.',
          ),
          _buildLegendRow(
            ph,
            PhoenixColors.success,
            'Normale',
            'Allenamento come da programma.',
          ),
          _buildLegendRow(
            ph,
            PhoenixColors.success,
            'Alto',
            'Ottimo recupero. Il corpo risponde bene.',
          ),
          _buildLegendRow(
            ph,
            const Color(0xFFFF8800),
            'Sospettosamente alto',
            'Possibile disregolazione autonomica. Cautela.',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(
    dynamic ph,
    Color color,
    String label,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: color, width: Borders.thin),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: ph.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: ph.textSecondary,
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
