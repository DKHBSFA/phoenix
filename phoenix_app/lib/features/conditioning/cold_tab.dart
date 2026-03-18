import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:drift/drift.dart' as drift;

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/models/cold_progression.dart';
import '../../core/ring/workout_bio_tracker.dart';
import '../../shared/widgets/phoenix_control_buttons.dart';
import '../../shared/widgets/phoenix_timer_display.dart';
import '../workout/widgets/bio_overlay.dart';
import 'conditioning_history.dart';

class ColdTab extends ConsumerStatefulWidget {
  const ColdTab({super.key});

  @override
  ConsumerState<ColdTab> createState() => _ColdTabState();
}

class _ColdTabState extends ConsumerState<ColdTab> {
  Timer? _timer;
  int _seconds = 0;
  bool _running = false;
  bool _targetReached = false;
  final _tempController = TextEditingController();

  // Bio tracker for cold exposure HR monitoring
  WorkoutBioTracker? _bioTracker;

  // Loaded data
  int _week = 1;
  ColdWeekStats? _weekStats;
  double? _hoursSinceStrength;
  bool _showSobergReminder = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final condDao = ref.read(conditioningDaoProvider);
    final workoutDao = ref.read(workoutDaoProvider);

    final firstDate = await condDao.getFirstSessionDate(ConditioningType.cold);
    final week = ColdProgression.currentWeek(firstDate);

    // Get sessions this week
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final sessionsThisWeek = await condDao.getByTypeInRange(
      ConditioningType.cold,
      weekStartDate,
      now,
    );

    final stats = ColdProgression.weekStats(
      sessionsThisWeek: sessionsThisWeek
          .map((s) => ColdSessionData(
                durationSeconds: s.durationSeconds,
                temperature: s.temperature,
                date: s.date,
              ))
          .toList(),
      week: week,
    );

    // Check strength training constraint
    final lastStrength = await workoutDao.lastStrengthEndTime();
    final hours = ColdProgression.hoursSinceStrength(lastStrength);

    if (mounted) {
      setState(() {
        _week = week;
        _weekStats = stats;
        _hoursSinceStrength = hours;
      });
    }
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      // Stop bio tracking when timer paused/stopped
      _bioTracker?.stop();
      _bioTracker = null;
      setState(() => _running = false);
    } else {
      setState(() {
        _running = true;
        _targetReached = false;
      });
      // Start bio tracking for cold exposure HR monitoring (best-effort)
      _startBioTracking();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _seconds++;
          // Check if target reached (countdown mode: count up to target)
          final target = ColdProgression.targetSeconds(_week);
          if (_seconds >= target && !_targetReached) {
            _targetReached = true;
          }
        });
      });
    }
  }

  Future<void> _startBioTracking() async {
    final tracker = ref.read(workoutBioTrackerProvider);
    final started = await tracker.start();
    if (started && mounted) {
      setState(() => _bioTracker = tracker);
    }
  }

  Future<void> _save() async {
    _timer?.cancel();
    _bioTracker?.stop();
    _bioTracker = null;
    setState(() => _running = false);

    if (_seconds == 0) return;

    final dao = ref.read(conditioningDaoProvider);
    final temp = double.tryParse(_tempController.text);

    await dao.addSession(ConditioningSessionsCompanion.insert(
      date: DateTime.now(),
      type: ConditioningType.cold,
      durationSeconds: _seconds,
      temperature: drift.Value(temp),
    ));

    setState(() {
      _seconds = 0;
      _targetReached = false;
      _showSobergReminder = true;
    });
    _tempController.clear();
    _loadData();

    if (mounted) {
      TDToast.showText('Sessione salvata', context: context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bioTracker?.stop();
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = ColdProgression.targetSeconds(_week);
    final remaining = (target - _seconds).clamp(0, target);
    final remainingMins = remaining ~/ 60;
    final remainingSecs = remaining % 60;
    final elapsed = _seconds;
    final elapsedMins = elapsed ~/ 60;
    final elapsedSecs = elapsed % 60;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      children: [
        const SizedBox(height: Spacing.sm),

        // Strength training alert
        if (_hoursSinceStrength != null) ...[
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: PhoenixColors.warningSurface,
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(color: PhoenixColors.warning.withAlpha(77)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: PhoenixColors.warning),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    'Allenamento di forza ${_hoursSinceStrength!.toStringAsFixed(1)}h fa. '
                    'Il freddo entro 6h può ridurre l\'adattamento ipertrofico '
                    '(Roberts et al. 2015). Consigliato attendere.',
                    style: TextStyle(
                      color: context.phoenix.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
        ],

        // Søberg reminder
        if (_showSobergReminder) ...[
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: PhoenixColors.darkOverlay.withAlpha(31),
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(color: PhoenixColors.darkTextSecondary.withAlpha(77)),
            ),
            child: Row(
              children: [
                const Icon(Icons.ac_unit, color: PhoenixColors.darkTextSecondary),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    'Termina sul freddo — non riscaldarti attivamente (Principio Søberg)',
                    style: TextStyle(
                      color: context.phoenix.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _showSobergReminder = false),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
        ],

        // Progression card
        if (_weekStats != null) ...[
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settimana $_week',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PhoenixColors.conditioningAccent,
                      ),
                ),
                const SizedBox(height: Spacing.sm),
                _StatRow(
                  label: 'Target attuale',
                  value: ColdProgression.targetFormatted(_week),
                ),
                _StatRow(
                  label: 'Sessioni questa settimana',
                  value:
                      '${_weekStats!.sessionsCompleted}/${ColdProgression.sessionsPerWeekTarget}',
                ),
                const SizedBox(height: Spacing.xs),
                // Stitch pattern 3.6 progress bar
                TDProgress(
                  type: TDProgressType.linear,
                  value: _weekStats!.sessionProgress,
                  color: PhoenixColors.conditioningAccent,
                  backgroundColor: context.phoenix.textPrimary.withAlpha(51),
                  strokeWidth: 12,
                  showLabel: false,
                ),
                const SizedBox(height: Spacing.sm),
                _StatRow(
                  label: 'Dose settimanale',
                  value:
                      '${_weekStats!.doseMinutes.toStringAsFixed(1)}/${_weekStats!.doseTargetMinutes.toStringAsFixed(0)} min',
                ),
                const SizedBox(height: Spacing.xs),
                TDProgress(
                  type: TDProgressType.linear,
                  value: _weekStats!.doseProgress,
                  color: PhoenixColors.conditioningAccent,
                  backgroundColor: context.phoenix.textPrimary.withAlpha(51),
                  strokeWidth: 12,
                  showLabel: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xl),
        ],

        // Timer display — Stitch pattern 3.5
        Center(
          child: Column(
            children: [
              if (!_targetReached)
                PhoenixTimerDisplay(
                  minutes: remainingMins,
                  seconds: remainingSecs,
                  accentColor: PhoenixColors.conditioningAccent,
                  label: _running ? 'Totale: ${elapsedMins}m ${elapsedSecs}s' : null,
                )
              else
                Column(
                  children: [
                    PhoenixTimerDisplay(
                      minutes: elapsedMins,
                      seconds: elapsedSecs,
                      accentColor: PhoenixColors.success,
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'Obiettivo raggiunto! Continua se vuoi.',
                      style: TextStyle(
                        color: PhoenixColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.xl),

        // Bio overlay: live HR during cold exposure (visible only when ring active)
        if (_bioTracker != null && _running) ...[
          BioOverlay(tracker: _bioTracker!, isResting: false),
          const SizedBox(height: Spacing.md),
        ],

        // Control buttons (pattern 3.7)
        PhoenixControlButtons(
          onPrimaryAction: _toggle,
          isPaused: !_running,
          primaryIcon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onNext: (!_running && _seconds > 0) ? _save : null,
          nextIcon: Icons.save_rounded,
          previousIcon: Icons.refresh_rounded,
          onPrevious: (!_running && _seconds > 0)
              ? () => setState(() {
                    _seconds = 0;
                    _targetReached = false;
                  })
              : null,
        ),

        const SizedBox(height: Spacing.lg),

        // Temperature input
        Center(
          child: SizedBox(
            width: 200,
            child: TextField(
              controller: _tempController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Temperatura (°C)',
                border: OutlineInputBorder(),
                suffixText: '°C',
              ),
            ),
          ),
        ),

        const SizedBox(height: Spacing.xl),

        // History with chart
        ConditioningHistory(type: ConditioningType.cold),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.phoenix.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.phoenix.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
