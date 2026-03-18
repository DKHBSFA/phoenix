import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/models/cardio_plan.dart';
import '../../core/ring/workout_bio_tracker.dart';
import '../../core/tts/coach_voice.dart';
import '../workout/widgets/bio_overlay.dart';

/// Fasi della sessione cardio.
enum _CardioPhase { warmup, work, rest, zone2, cooldown, done }

/// Risultato restituito al pop della schermata.
class CardioSessionResult {
  final String protocolName;
  final int roundsCompleted;
  final int totalRounds;
  final Duration totalDuration;

  const CardioSessionResult({
    required this.protocolName,
    required this.roundsCompleted,
    required this.totalRounds,
    required this.totalDuration,
  });
}

class CardioSessionScreen extends ConsumerStatefulWidget {
  const CardioSessionScreen({super.key});

  @override
  ConsumerState<CardioSessionScreen> createState() =>
      _CardioSessionScreenState();
}

class _CardioSessionScreenState extends ConsumerState<CardioSessionScreen> {
  CardioPlan? _plan;
  Timer? _timer;
  DateTime? _sessionStart;

  _CardioPhase _phase = _CardioPhase.warmup;
  int _secondsRemaining = 0;
  int _currentRound = 0;
  bool _paused = false;

  // Totals for progress tracking
  int _totalSessionSeconds = 0;
  int _elapsedSessionSeconds = 0;

  // Bio tracker (nullable — only active when ring is connected)
  WorkoutBioTracker? _bioTracker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_plan != null) return;

    final args = ModalRoute.of(context)!.settings.arguments as CardioPlan?;
    if (args == null) {
      Navigator.of(context).pop();
      return;
    }

    _plan = args;
    _totalSessionSeconds = _computeTotalSeconds(args);
    _startPhase(_CardioPhase.warmup);
    _sessionStart = DateTime.now();

    // Start bio tracking (best-effort, no error when ring unavailable)
    _startBioTracking();
  }

  Future<void> _startBioTracking() async {
    final tracker = ref.read(workoutBioTrackerProvider);
    final started = await tracker.start();
    if (started && mounted) {
      setState(() => _bioTracker = tracker);
    }
  }

  int _computeTotalSeconds(CardioPlan plan) {
    var total = plan.warmupMinutes * 60;
    total += plan.hiitTotalSeconds;
    total += plan.zone2Minutes * 60;
    total += plan.cooldownMinutes * 60;
    return total;
  }

  CoachTrigger _triggerForPhase(_CardioPhase phase) {
    switch (phase) {
      case _CardioPhase.warmup:
        return CoachTrigger.cardioWarmup;
      case _CardioPhase.work:
        return CoachTrigger.cardioWork;
      case _CardioPhase.rest:
        return CoachTrigger.cardioRest;
      case _CardioPhase.zone2:
        return CoachTrigger.cardioZone2;
      case _CardioPhase.cooldown:
        return CoachTrigger.cardioCooldown;
      case _CardioPhase.done:
        return CoachTrigger.cardioDone;
    }
  }

  void _startPhase(_CardioPhase phase) {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    // Coach voice
    ref.read(coachVoiceProvider).speak(_triggerForPhase(phase));

    setState(() {
      _phase = phase;
      switch (phase) {
        case _CardioPhase.warmup:
          _secondsRemaining = _plan!.warmupMinutes * 60;
        case _CardioPhase.work:
          _secondsRemaining = _plan!.rounds[_currentRound].workSeconds;
        case _CardioPhase.rest:
          _secondsRemaining = _plan!.rounds[_currentRound].restSeconds;
        case _CardioPhase.zone2:
          _secondsRemaining = _plan!.zone2Minutes * 60;
        case _CardioPhase.cooldown:
          _secondsRemaining = _plan!.cooldownMinutes * 60;
        case _CardioPhase.done:
          _secondsRemaining = 0;
          return;
      }
    });

    if (phase == _CardioPhase.done) {
      // Stop bio tracking when session completes naturally
      _bioTracker?.stop();
      _bioTracker = null;
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;

      setState(() {
        _elapsedSessionSeconds++;
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        }
        if (_secondsRemaining == 0) {
          _advancePhase();
        }
      });
    });
  }

  void _advancePhase() {
    _timer?.cancel();
    final plan = _plan!;

    switch (_phase) {
      case _CardioPhase.warmup:
        if (plan.isHiit) {
          _currentRound = 0;
          _startPhase(_CardioPhase.work);
        } else if (plan.zone2Minutes > 0) {
          _startPhase(_CardioPhase.zone2);
        } else {
          _startPhase(_CardioPhase.cooldown);
        }

      case _CardioPhase.work:
        if (plan.rounds[_currentRound].restSeconds > 0) {
          _startPhase(_CardioPhase.rest);
        } else {
          _finishRound();
        }

      case _CardioPhase.rest:
        _finishRound();

      case _CardioPhase.zone2:
        if (plan.cooldownMinutes > 0) {
          _startPhase(_CardioPhase.cooldown);
        } else {
          _startPhase(_CardioPhase.done);
        }

      case _CardioPhase.cooldown:
        _startPhase(_CardioPhase.done);

      case _CardioPhase.done:
        break;
    }
  }


  void _finishRound() {
    final plan = _plan!;
    _currentRound++;
    if (_currentRound < plan.rounds.length) {
      _startPhase(_CardioPhase.work);
    } else if (plan.zone2Minutes > 0) {
      _startPhase(_CardioPhase.zone2);
    } else if (plan.cooldownMinutes > 0) {
      _startPhase(_CardioPhase.cooldown);
    } else {
      _startPhase(_CardioPhase.done);
    }
  }

  void _togglePause() {
    HapticFeedback.mediumImpact();
    setState(() => _paused = !_paused);
  }

  Future<void> _stopSession() async {
    _timer?.cancel();
    // Stop bio tracking
    _bioTracker?.stop();
    _bioTracker = null;
    final result = CardioSessionResult(
      protocolName: _plan!.protocolName,
      roundsCompleted: _currentRound.clamp(0, _plan!.rounds.length),
      totalRounds: _plan!.rounds.length,
      totalDuration: DateTime.now().difference(_sessionStart!),
    );
    Navigator.of(context).pop(result);
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _phaseLabel() {
    switch (_phase) {
      case _CardioPhase.warmup:
        return 'RISCALDAMENTO';
      case _CardioPhase.work:
        return 'LAVORO';
      case _CardioPhase.rest:
        return 'RECUPERO';
      case _CardioPhase.zone2:
        return 'ZONA 2';
      case _CardioPhase.cooldown:
        return 'DEFATICAMENTO';
      case _CardioPhase.done:
        return 'COMPLETATO';
    }
  }

  Color _phaseColor() {
    switch (_phase) {
      case _CardioPhase.work:
        return PhoenixColors.error;
      case _CardioPhase.rest:
        return PhoenixColors.success;
      case _CardioPhase.done:
        return PhoenixColors.completed;
      default:
        return context.phoenix.textPrimary;
    }
  }

  IconData _phaseIcon() {
    switch (_phase) {
      case _CardioPhase.warmup:
        return Icons.whatshot_outlined;
      case _CardioPhase.work:
        return Icons.flash_on;
      case _CardioPhase.rest:
        return Icons.air;
      case _CardioPhase.zone2:
        return Icons.favorite_border;
      case _CardioPhase.cooldown:
        return Icons.self_improvement;
      case _CardioPhase.done:
        return Icons.check;
    }
  }

  double _overallProgress() {
    if (_totalSessionSeconds == 0) return 0;
    return (_elapsedSessionSeconds / _totalSessionSeconds).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bioTracker?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    if (plan == null) return const SizedBox.shrink();

    final colors = context.phoenix;

    if (_phase == _CardioPhase.done) {
      return _buildSummary(context, plan);
    }

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'CARDIO',
              style: PhoenixTypography.h3.copyWith(color: colors.textPrimary),
            ),
            Text(
              plan.protocolName.toUpperCase(),
              style: PhoenixTypography.micro.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Phase label badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _phaseColor(),
                    width: Borders.medium,
                  ),
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_phaseIcon(), size: 16, color: _phaseColor()),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      _phaseLabel(),
                      style: PhoenixTypography.caption.copyWith(
                        color: _phaseColor(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Spacing.lg),

              // Timer display
              Text(
                _formatTime(_secondsRemaining),
                style: PhoenixTypography.numericLarge.copyWith(
                  color: colors.textPrimary,
                  fontSize: 72,
                ),
              ),

              const SizedBox(height: Spacing.md),

              // Round counter (HIIT only)
              if (plan.isHiit &&
                  (_phase == _CardioPhase.work ||
                      _phase == _CardioPhase.rest)) ...[
                Text(
                  'Round ${_currentRound + 1}/${plan.rounds.length}',
                  style: PhoenixTypography.h2.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
              ],

              // Exercise suggestion during work phase
              if (plan.isHiit &&
                  _phase == _CardioPhase.work &&
                  _currentRound < plan.rounds.length &&
                  plan.rounds[_currentRound].exerciseSuggestion != null) ...[
                Text(
                  plan.rounds[_currentRound].exerciseSuggestion!,
                  style: PhoenixTypography.bodyLarge.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.sm),
              ],

              // Paused indicator
              if (_paused)
                Text(
                  'IN PAUSA',
                  style: PhoenixTypography.caption.copyWith(
                    color: PhoenixColors.warning,
                  ),
                ),

              const SizedBox(height: Spacing.lg),

              // ── Phase info panel ─────────────────────────────────
              _PhaseInfoPanel(
                phase: _phase,
                plan: plan,
                currentRound: _currentRound,
              ),

              // Bio overlay (visible only when ring is active)
              if (_bioTracker != null) ...[
                const SizedBox(height: Spacing.sm),
                BioOverlay(
                  tracker: _bioTracker!,
                  isResting: _phase == _CardioPhase.rest,
                ),
              ],

              const Spacer(flex: 1),

              // Progress bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _overallProgress(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.textPrimary,
                        borderRadius: BorderRadius.circular(Radii.sm),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Spacing.xl),

              // Control buttons
              Row(
                children: [
                  Expanded(
                    child: _BrutalistButton(
                      label: _paused ? 'RIPRENDI' : 'PAUSA',
                      onPressed: _togglePause,
                      borderColor: colors.borderStrong,
                      textColor: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: _BrutalistButton(
                      label: 'FERMA',
                      onPressed: _stopSession,
                      borderColor: PhoenixColors.error,
                      textColor: PhoenixColors.error,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CardioPlan plan) {
    final colors = context.phoenix;
    final duration = DateTime.now().difference(_sessionStart!);
    final result = CardioSessionResult(
      protocolName: plan.protocolName,
      roundsCompleted: _currentRound.clamp(0, plan.rounds.length),
      totalRounds: plan.rounds.length,
      totalDuration: duration,
    );

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'COMPLETATO',
          style: PhoenixTypography.h3.copyWith(color: colors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Column(
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PhoenixColors.completed,
                    width: Borders.heavy,
                  ),
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: const Icon(
                  Icons.check,
                  color: PhoenixColors.completed,
                  size: 32,
                ),
              ),

              const SizedBox(height: Spacing.lg),

              Text(
                'Sessione completata!',
                style: PhoenixTypography.h1.copyWith(
                  color: colors.textPrimary,
                ),
              ),

              const SizedBox(height: Spacing.xl),

              // Stats
              _StatRow(
                label: 'PROTOCOLLO',
                value: plan.protocolName.toUpperCase(),
              ),
              if (plan.isHiit)
                _StatRow(
                  label: 'ROUND',
                  value: '${result.roundsCompleted}/${result.totalRounds}',
                ),
              _StatRow(
                label: 'DURATA',
                value: _formatTime(duration.inSeconds),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: _BrutalistButton(
                  label: 'CHIUDI',
                  onPressed: () => Navigator.of(context).pop(result),
                  borderColor: colors.textPrimary,
                  textColor: colors.textPrimary,
                ),
              ),

              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Phase info panel ─────────────────────────────────────────────

class _PhaseInfoPanel extends StatelessWidget {
  final _CardioPhase phase;
  final CardioPlan plan;
  final int currentRound;

  const _PhaseInfoPanel({
    required this.phase,
    required this.plan,
    required this.currentRound,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.phoenix;
    final (title, subtitle, hint) = _content();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: Borders.thin),
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PhoenixTypography.bodyLarge.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            subtitle,
            style: PhoenixTypography.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: Spacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xxs,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border, width: Borders.thin),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Text(
                hint,
                style: PhoenixTypography.micro.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  (String title, String subtitle, String? hint) _content() {
    switch (phase) {
      case _CardioPhase.warmup:
        return (
          'Mobilità leggera e attivazione',
          'Movimenti ampi a bassa intensità per preparare muscoli e articolazioni.',
          'Intensità: 50-60% HR max',
        );

      case _CardioPhase.work:
        final exercise = (currentRound < plan.rounds.length)
            ? plan.rounds[currentRound].exerciseSuggestion
            : null;
        return (
          exercise ?? 'Massima intensità!',
          'Dai tutto in ogni secondo. Recupererai dopo.',
          'Intensità: 85-100% HR max',
        );

      case _CardioPhase.rest:
        final nextRound = currentRound + 1;
        final nextExercise = (nextRound < plan.rounds.length)
            ? plan.rounds[nextRound].exerciseSuggestion
            : null;
        final nextHint = nextExercise != null
            ? 'Prossimo: $nextExercise'
            : null;
        return (
          'Recupero attivo',
          'Cammina o marcia leggera. Respira profondamente dal naso.',
          nextHint,
        );

      case _CardioPhase.zone2:
        return (
          'Corsa o camminata a ritmo parlabile',
          'Dovresti riuscire a tenere una conversazione. Se non riesci, rallenta.',
          'Intensità: 60-70% HR max',
        );

      case _CardioPhase.cooldown:
        return (
          'Stretching e respirazione',
          'Rallenta gradualmente. Stretching statico e respirazione profonda.',
          'Lascia scendere il battito naturalmente',
        );

      case _CardioPhase.done:
        return ('Completato', '', null);
    }
  }
}

// ─── Stat row for summary ──────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.phoenix;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.smMd,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.border, width: Borders.thin),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: PhoenixTypography.caption.copyWith(
              color: colors.textSecondary,
            ),
          ),
          Text(
            value,
            style: PhoenixTypography.bodyLarge.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Brutalist button ──────────────────────────────────────────────

class _BrutalistButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;

  const _BrutalistButton({
    required this.label,
    required this.onPressed,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: TouchTargets.buttonHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: Borders.medium,
          ),
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: PhoenixTypography.button.copyWith(color: textColor),
        ),
      ),
    );
  }
}
