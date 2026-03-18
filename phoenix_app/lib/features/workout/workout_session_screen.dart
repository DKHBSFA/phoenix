import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:drift/drift.dart' as drift;

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/audio/audio_engine.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/llm/prompt_templates.dart';
import '../../core/ring/workout_bio_tracker.dart';
import '../../core/llm/template_chat.dart';
import '../../core/models/coach_prompts.dart';
import '../../core/models/duration_score.dart';
import '../../core/models/progression_check.dart';
import '../../core/models/workout_plan.dart';
import '../../core/notifications/notification_scheduler.dart';
import '../../core/tts/coach_voice.dart';
import '../../shared/widgets/phoenix_control_buttons.dart';
import '../../shared/widgets/phoenix_timer_display.dart';
import '../exercise/exercise_detail_sheet.dart';
import '../exercise/widgets/exercise_hero.dart';
import '../exercise/widgets/muscle_badge.dart';
import '../exercise/widgets/numbered_steps.dart';
import '../exercise/widgets/stats_grid.dart';
import 'widgets/bio_overlay.dart';

/// Session phases.
enum _Phase { warmup, preview, countdown, tracking, coachChat, resting, stability, cooldown, complete }

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen>
    with TickerProviderStateMixin {
  WorkoutPlan? _plan;
  int? _sessionId;
  DateTime? _startedAt;
  Timer? _durationTimer;
  Duration _elapsed = Duration.zero;

  // Current position
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  _Phase _phase = _Phase.preview;

  // Countdown
  int _countdownValue = 3;
  Timer? _countdownTimer;

  // Rest
  int _restSecondsRemaining = 0;
  Timer? _restTimer;

  // Tempo bar state (replaces breathing circle)
  TempoPhase _currentTempoPhase = TempoPhase.eccentric;
  AnimationController? _tempoBarController;

  // Auto-counting reps
  int _repsRemaining = 0;

  // Coach chat state
  final TextEditingController _chatInputController = TextEditingController();
  final List<_ChatBubble> _chatMessages = [];
  bool _isCoachTyping = false;
  bool _coachChatDone = false;
  int _chatRepsCompleted = 0;
  int _chatRpe = 7;
  bool _chatPainDetected = false;

  // Set history for current exercise
  final List<_SetRecord> _setHistory = [];

  // RPE explanation shown flag
  bool _rpeDialogShownThisSession = false;

  // Coach cue for rest phase
  String _coachCue = '';

  // Bio tracker (nullable — only active when ring is connected)
  WorkoutBioTracker? _bioTracker;
  SetBioStats? _lastSetBioStats;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_plan == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is WorkoutPlan) {
        _plan = args;
      }
      if (_plan == null || _plan!.exercises.isEmpty) return;
      _startSession();
    }
  }

  Future<void> _startSession() async {
    _startedAt = DateTime.now();
    final dao = ref.read(workoutDaoProvider);
    _sessionId = await dao.createSession(
      startedAt: _startedAt!,
      type: _plan!.type,
    );

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(_startedAt!);
        });
      }
    });

    // Start bio tracking if ring is available (best-effort, no error on failure)
    final tracker = ref.read(workoutBioTrackerProvider);
    final started = await tracker.start();
    if (started) {
      _bioTracker = tracker;
    }

    setState(() => _phase = _Phase.warmup);
  }

  PlannedExercise get _currentPlanned {
    final plan = _plan;
    if (plan == null) {
      throw StateError('_currentPlanned accessed before _plan was initialised');
    }
    return plan.exercises[_currentExerciseIndex];
  }

  // ─── Phase transitions ──────────────────────────────────────────

  void _startCountdown() {
    setState(() {
      _phase = _Phase.countdown;
      _countdownValue = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdownValue--;
        if (_countdownValue <= 0) {
          timer.cancel();
          ref.read(audioEngineProvider).playRestEnd();
          _startTracking();
        }
      });
      if (_countdownValue > 0) {
        ref.read(audioEngineProvider).playRestStart();
      }
    });
  }

  void _startTracking() {
    final exercise = _currentPlanned;

    // Notify bio tracker that a new set is starting
    _bioTracker?.onSetStart();

    // Initialize tempo bar controller
    final totalCycleMs =
        (exercise.tempoEcc + 1 + exercise.tempoCon) * 1000;
    _tempoBarController?.dispose();
    _tempoBarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalCycleMs),
    )..repeat();

    // Initialize auto-counting reps
    _repsRemaining = exercise.repsMax;

    setState(() {
      _phase = _Phase.tracking;
      _currentTempoPhase = TempoPhase.eccentric;
    });

    // Start metronome with callbacks
    ref.read(audioEngineProvider).startMetronome(
      eccentricSeconds: exercise.tempoEcc,
      concentricSeconds: exercise.tempoCon,
      onPhaseChange: (phase) {
        if (mounted) {
          setState(() => _currentTempoPhase = phase);
        }
      },
      onCycleComplete: () {
        if (mounted && _phase == _Phase.tracking) {
          setState(() {
            _repsRemaining--;
            if (_repsRemaining <= 0) {
              _autoCompleteSet();
            }
          });
        }
      },
    );
  }

  void _stopTracking() {
    _tempoBarController?.stop();
    ref.read(audioEngineProvider).stopMetronome();
  }

  void _autoCompleteSet() {
    HapticFeedback.heavyImpact();
    _stopTracking();
    _goToCoachChat(false);
  }

  void _manualCompleteSet() {
    HapticFeedback.mediumImpact();
    _stopTracking();
    _goToCoachChat(true);
  }

  void _goToCoachChat(bool wasManualStop) {
    final exercise = _currentPlanned;
    _chatRepsCompleted = exercise.repsMax - _repsRemaining;

    // Estimate RPE for template fallback
    _chatRpe = _estimateRpe(
      repsCompleted: _chatRepsCompleted,
      repsMin: exercise.repsMin,
      repsMax: exercise.repsMax,
      wasManualStop: wasManualStop,
    );
    _chatPainDetected = false;
    _coachChatDone = false;

    // Clear previous chat
    _chatMessages.clear();
    _chatInputController.clear();

    // Coach asks the opening question
    final question = CoachPrompts.postSetQuestion(
      exerciseName: exercise.exercise.name,
      setNumber: _currentSetIndex + 1,
      totalSets: exercise.sets,
      repsTarget: exercise.repsMax,
    );
    _chatMessages.add(_ChatBubble(text: question, isUser: false));

    final llm = ref.read(llmEngineProvider);
    if (!llm.isLlmAvailable) {
      // Template mode: show structured form instead of free text
      _coachChatDone = true;
    }

    setState(() => _phase = _Phase.coachChat);
  }

  int _estimateRpe({
    required int repsCompleted,
    required int repsMin,
    required int repsMax,
    required bool wasManualStop,
  }) {
    if (wasManualStop && repsCompleted < repsMin) return 9;
    if (repsCompleted < repsMin) return 9;
    if (repsCompleted == repsMin) return 8;
    if (repsCompleted < repsMax) return 7;
    if (repsCompleted >= repsMax) return 6;
    return 7;
  }

  Future<void> _sendChatMessage() async {
    final text = _chatInputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add(_ChatBubble(text: text, isUser: true));
      _chatInputController.clear();
      _isCoachTyping = true;
    });

    final llm = ref.read(llmEngineProvider);
    final exercise = _currentPlanned;

    // Build set history string
    final historyStr = _setHistory.isEmpty
        ? 'Nessuna'
        : _setHistory
            .map((s) => 'Set ${s.setNumber}: ${s.reps} reps RPE ${s.rpe.toStringAsFixed(0)}')
            .join(', ');

    try {
      final template = PostSetCoachTemplate();
      final response = await llm.generate(
        template: template,
        context: {
          'exercise_name': exercise.exercise.name,
          'set_number': _currentSetIndex + 1,
          'total_sets': exercise.sets,
          'reps_target': exercise.repsMax,
          'tempo_ecc': exercise.tempoEcc,
          'tempo_con': exercise.tempoCon,
          'set_history': historyStr,
          'user_message': text,
        },
        maxTokens: 200,
      );

      // Parse structured data from response
      final data = TemplateChat.parseCoachData(response);
      final displayText = TemplateChat.stripCoachData(response);

      if (data['reps'] != null) _chatRepsCompleted = data['reps'] as int;
      if (data['rpe'] != null) _chatRpe = data['rpe'] as int;
      if (data['pain'] == true) _chatPainDetected = true;

      if (mounted) {
        setState(() {
          _chatMessages.add(_ChatBubble(text: displayText, isUser: false));
          _isCoachTyping = false;
          _coachChatDone = true;
        });
      }
    } catch (_) {
      // Fallback to template
      final feedback = TemplateChat.postSetFeedback(
        repsCompleted: _chatRepsCompleted,
        repsTarget: exercise.repsMax,
        rpe: _chatRpe,
        setNumber: _currentSetIndex + 1,
        totalSets: exercise.sets,
        exerciseName: exercise.exercise.name,
        category: exercise.exercise.category,
      );
      if (mounted) {
        setState(() {
          _chatMessages.add(_ChatBubble(text: feedback, isUser: false));
          _isCoachTyping = false;
          _coachChatDone = true;
        });
      }
    }
  }

  Future<void> _confirmCoachChat() async {
    final exercise = _currentPlanned;

    // Capture bio stats for this set (null when ring not connected)
    final bioStats = _bioTracker?.onSetEnd();
    _lastSetBioStats = bioStats;

    final dao = ref.read(workoutDaoProvider);
    await dao.addSet(WorkoutSetsCompanion.insert(
      sessionId: _sessionId!,
      exerciseId: exercise.exercise.id,
      setNumber: _currentSetIndex + 1,
      repsTarget: drift.Value(exercise.repsMax),
      repsCompleted: drift.Value(_chatRepsCompleted),
      rpe: drift.Value(_chatRpe.toDouble()),
      tempoEccentric: drift.Value(exercise.tempoEcc),
      tempoConcentric: drift.Value(exercise.tempoCon),
      restSecondsAfter: drift.Value(exercise.restSeconds),
      avgHr: drift.Value(bioStats?.avgHr),
      maxHr: drift.Value(bioStats?.maxHr),
      spo2: drift.Value(bioStats?.spo2),
      rmssd: drift.Value(bioStats?.rmssd),
      stressIndex: drift.Value(bioStats?.stressIndex),
      hrRecoveryBpm: drift.Value(bioStats?.hrRecoveryBpm),
      skinTemp: drift.Value(bioStats?.skinTemp),
    ));

    _setHistory.add(_SetRecord(
      setNumber: _currentSetIndex + 1,
      reps: _chatRepsCompleted,
      rpe: _chatRpe.toDouble(),
    ));

    _startRest();
  }

  void _startRest() {
    final restSeconds = _currentPlanned.restSeconds;

    // Build cue — if bio data is available, check for a bio-based cue first
    final bio = _lastSetBioStats;
    final bioCueText = CoachPrompts.bioCue(
      currentHr: _bioTracker?.currentHr.value,
      spo2: bio?.spo2,
      rmssd: bio?.rmssd,
      stressIndex: bio?.stressIndex,
      hrRecoveryBpm: bio?.hrRecoveryBpm,
      skinTemp: bio?.skinTemp,
    );
    final cue = bioCueText ?? CoachPrompts.interSetCue(
      exerciseName: _currentPlanned.exercise.name,
      setNumber: _currentSetIndex + 1,
      totalSets: _currentPlanned.sets,
      rpe: _chatRpe,
      category: _currentPlanned.exercise.category,
    );

    // Enable SpO2 streaming during rest
    _bioTracker?.onRestStart();

    setState(() {
      _phase = _Phase.resting;
      _restSecondsRemaining = restSeconds;
      _coachCue = cue;
    });

    ref.read(audioEngineProvider).playRestStart();
    ref.read(coachVoiceProvider).speak(CoachTrigger.duringWorkout);

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _restSecondsRemaining--;
        if (_restSecondsRemaining <= 0) {
          timer.cancel();
          ref.read(audioEngineProvider).playRestEnd();
          _advanceAfterRest();
        }
      });
    });
  }

  void _advanceAfterRest() {
    // Stop SpO2 streaming, revert to HR-only
    _bioTracker?.onRestEnd();

    final totalSets = _currentPlanned.sets;
    if (_currentSetIndex + 1 >= totalSets) {
      if (_currentExerciseIndex + 1 >= _plan!.exercises.length) {
        // All exercises done → stability → cooldown → end
        setState(() => _phase = _Phase.stability);
        return;
      }
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
        _setHistory.clear();
        _phase = _Phase.preview;
      });
    } else {
      setState(() {
        _currentSetIndex++;
        _phase = _Phase.preview;
      });
      // Skip preview for subsequent sets — go straight to countdown
      _startCountdown();
    }
  }

  Future<void> _endSession() async {
    _durationTimer?.cancel();
    _restTimer?.cancel();
    _countdownTimer?.cancel();
    _tempoBarController?.dispose();
    _tempoBarController = null;
    ref.read(audioEngineProvider).stopMetronome();

    // Stop bio tracker and collect session-level stats
    SessionBioStats? sessionBio;
    if (_bioTracker != null) {
      sessionBio = await _bioTracker!.stop();
      _bioTracker = null;
    }

    final endedAt = DateTime.now();
    final durationMinutes = _elapsed.inSeconds / 60.0;

    final dao = ref.read(workoutDaoProvider);
    await dao.endSession(_sessionId!, endedAt);

    final previousSessions =
        await dao.getSessionsByType(_plan!.type, limit: 8);
    final previousDurations = previousSessions
        .where((s) => s.durationMinutes != null)
        .map((s) => s.durationMinutes!)
        .toList();

    final scoreResult = DurationScoreCalculator.calculate(
      currentDurationMinutes: durationMinutes,
      workoutType: _plan!.type,
      previousDurations: previousDurations,
    );

    await dao.updateSessionSummary(
      _sessionId!,
      durationMinutes: durationMinutes,
      durationScore: scoreResult?.score,
    );

    // Save session-level bio stats if available
    if (sessionBio != null && _sessionId != null && (sessionBio.avgHr > 0 || sessionBio.maxHr > 0)) {
      await dao.updateSessionBio(
        _sessionId!,
        avgHr: sessionBio.avgHr,
        maxHr: sessionBio.maxHr,
      );
    }

    await ref.read(audioEngineProvider).playSessionComplete();
    ref.read(coachVoiceProvider).speak(CoachTrigger.postWorkout);

    // Check exercise progressions
    final progressionDao = ref.read(progressionDaoProvider);
    final exerciseDao = ref.read(exerciseDaoProvider);
    final advancements = <ProgressionCheckResult>[];

    for (final planned in _plan!.exercises) {
      final nextId = await progressionDao.checkProgressionCriteria(
        exerciseId: planned.exercise.id,
        sessionId: _sessionId!,
      );
      if (nextId != null) {
        final nextExercise = await exerciseDao.getById(nextId);
        advancements.add(ProgressionCheckResult(
          currentExerciseId: planned.exercise.id,
          currentExerciseName: planned.exercise.name,
          nextExerciseId: nextExercise.id,
          nextExerciseName: nextExercise.name,
          currentLevel: planned.exercise.phoenixLevel,
          nextLevel: nextExercise.phoenixLevel,
        ));
      }
    }

    // Reschedule workout reminder for tomorrow
    final settings = ref.read(settingsProvider);
    if (settings.workoutReminderEnabled) {
      final scheduler = NotificationScheduler(
        ref.read(notificationServiceProvider),
        ref.read(workoutDaoProvider),
        ref.read(conditioningDaoProvider),
      );
      await scheduler.scheduleWorkoutReminder(settings.workoutReminderTime);
    }

    if (mounted) {
      if (advancements.isNotEmpty) {
        await _showProgressionDialog(advancements);
      }
      setState(() => _phase = _Phase.complete);
      _showSummaryDialog(durationMinutes, scoreResult);
    }
  }

  // ─── RPE Explanation Dialog ──────────────────────────────────────

  Future<void> _maybeShowRpeExplanation() async {
    final settings = ref.read(settingsProvider);
    if (settings.rpeExplained || _rpeDialogShownThisSession) {
      _startCountdown();
      return;
    }
    _rpeDialogShownThisSession = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('RPE — Rate of Perceived Exertion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Misura quanto ti senti affaticato dopo ogni serie (1-10)',
            ),
            const SizedBox(height: Spacing.md),
            _rpeScaleRow('1-3', 'Facile', PhoenixColors.success),
            _rpeScaleRow('4-6', 'Moderato', PhoenixColors.warning),
            _rpeScaleRow('7-8', 'Difficile', PhoenixColors.error),
            _rpeScaleRow('9-10', 'Massimale', PhoenixColors.error),
          ],
        ),
        actions: [
          TDButton(
            text: 'Ho capito',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () {
              ref
                  .read(settingsProvider.notifier)
                  .setRpeExplained(true);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );

    if (mounted) _startCountdown();
  }

  Widget _rpeScaleRow(String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        children: [
          Container(
            width: 44,
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm, vertical: Spacing.xxs),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Text(range,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color, fontSize: 14)),
          ),
          const SizedBox(width: Spacing.sm),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // ─── Navigation guards ──────────────────────────────────────────

  Future<bool> _onWillPop() async {
    if (_sessionId == null) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Uscire dalla sessione?'),
        content: const Text(
          'La sessione è ancora in corso. Se esci, i dati verranno salvati fino a qui.',
        ),
        actions: [
          TDButton(
            text: 'Continua',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx, false),
          ),
          TDButton(
            text: 'Esci',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSummaryDialog(
      double duration, DurationScoreResult? scoreResult) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Sessione completata'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Durata: ${duration.toStringAsFixed(0)} minuti'),
            if (scoreResult != null) ...[
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _scoreColor(scoreResult.score),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'Score: ${scoreResult.score.toUpperCase()}',
                    style: TextStyle(color: _scoreColor(scoreResult.score)),
                  ),
                ],
              ),
              Text(
                'Target: ${scoreResult.targetMinutes.toStringAsFixed(0)} min',
                style: TextStyle(
                    color: context.phoenix.textSecondary,
                    fontSize: 13),
              ),
            ] else
              Text(
                'Raccogliendo dati per il punteggio durata...',
                style: TextStyle(
                    color: context.phoenix.textSecondary,
                    fontSize: 13),
              ),
          ],
        ),
        actions: [
          TDButton(
            text: 'Chiudi',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showProgressionDialog(
      List<ProgressionCheckResult> advancements) async {
    for (final adv in advancements) {
      if (!mounted) break;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Progressione disponibile!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${adv.currentExerciseName} (Lv. ${adv.currentLevel})'),
              const Icon(Icons.arrow_downward),
              Text(
                '${adv.nextExerciseName} (Lv. ${adv.nextLevel})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Hai completato 2 sessioni consecutive al massimo '
                'delle reps con RPE <=8. Vuoi avanzare?',
              ),
            ],
          ),
          actions: [
            TDButton(
              text: 'Non ora',
              type: TDButtonType.text,
              theme: TDButtonTheme.defaultTheme,
              onTap: () => Navigator.pop(ctx, false),
            ),
            TDButton(
              text: 'Avanza',
              type: TDButtonType.fill,
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              onTap: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final progressionDao = ref.read(progressionDaoProvider);
        await progressionDao.recordAdvancement(
          exerciseId: adv.currentExerciseId,
          fromLevel: adv.currentLevel,
          toLevel: adv.nextLevel,
          criteriaMet: {
            'sessions': 2,
            'criteria': 'all_sets_max_reps_rpe_le_8',
            'date': DateTime.now().toIso8601String(),
          },
        );
      }
    }
  }

  Color _scoreColor(String score) {
    switch (score) {
      case DurationScore.green:
        return PhoenixColors.success;
      case DurationScore.yellow:
        return PhoenixColors.warning;
      case DurationScore.red:
        return PhoenixColors.error;
      default:
        return PhoenixColors.darkTextSecondary;
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _restTimer?.cancel();
    _countdownTimer?.cancel();
    _tempoBarController?.dispose();
    _chatInputController.dispose();
    // Stop bio tracking if still active (e.g., app killed mid-session)
    _bioTracker?.stop();
    super.dispose();
  }

  // ─── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_plan == null || _plan!.exercises.isEmpty) {
      return Scaffold(
        appBar: const TDNavBar(title: 'Sessione'),
        body: const Center(child: Text('Nessun esercizio disponibile.')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: TDNavBar(
          titleWidget: Text(
            '${_elapsed.inMinutes}:${(_elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
            style: PhoenixTypography.h2.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          useDefaultBack: false,
          rightBarItems: [
            // "i" button only during tracking/resting phases
            if (_phase == _Phase.tracking || _phase == _Phase.resting)
              TDNavBarItem(
                icon: Icons.info_outline,
                action: () {
                  final ex = _currentPlanned;
                  ExerciseDetailSheet.show(
                    context,
                    exercise: ex.exercise,
                    sets: ex.sets,
                    repsMin: ex.repsMin,
                    repsMax: ex.repsMax,
                    tempoEcc: ex.tempoEcc,
                    tempoCon: ex.tempoCon,
                  );
                },
              ),
            TDNavBarItem(
              customWidget: GestureDetector(
                onTap: _endSession,
                child: Text(
                  'FINE',
                  style: PhoenixTypography.caption.copyWith(
                    color: context.phoenix.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_phase) {
      case _Phase.warmup:
        return _buildMovementPhase(context, 'RISCALDAMENTO', 'Warmup dinamico — prepara il corpo');
      case _Phase.preview:
        return _buildPreview(context);
      case _Phase.countdown:
        return _buildCountdown(context);
      case _Phase.tracking:
        return _buildTracking(context);
      case _Phase.coachChat:
        return _buildCoachChat(context);
      case _Phase.resting:
        return _buildResting(context);
      case _Phase.stability:
        return _buildMovementPhase(context, 'STABILITÀ', 'Equilibrio e controllo');
      case _Phase.cooldown:
        return _buildMovementPhase(context, 'DEFATICAMENTO', 'Stretching e recupero');
      case _Phase.complete:
        return Center(child: TDLoading(size: TDLoadingSize.medium));
    }
  }

  /// Generic movement phase (warmup/stability/cooldown) with skip option.
  Widget _buildMovementPhase(BuildContext context, String title, String subtitle) {
    final p = context.phoenix;
    return Padding(
      padding: const EdgeInsets.all(Spacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.self_improvement, size: 64, color: p.textSecondary),
          const SizedBox(height: Spacing.lg),
          Text(title, style: PhoenixTypography.displayLarge.copyWith(color: p.textPrimary)),
          const SizedBox(height: Spacing.sm),
          Text(subtitle, style: PhoenixTypography.bodyLarge.copyWith(color: p.textSecondary)),
          const SizedBox(height: Spacing.xl),
          Text(
            _phase == _Phase.warmup
                ? '5-10 min di mobilità dinamica prima di iniziare'
                : _phase == _Phase.stability
                    ? '5-10 min di lavoro di equilibrio e propriocezione'
                    : '5-10 min di stretching statico o PNF',
            style: PhoenixTypography.bodyLarge.copyWith(color: p.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _skipMovementPhase();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: p.textSecondary,
                    side: BorderSide(color: p.border),
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                  ),
                  child: const Text('Salta'),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _completeMovementPhase();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: p.textPrimary,
                    foregroundColor: p.bg,
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                  ),
                  child: const Text('Completato'),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  void _skipMovementPhase() {
    setState(() {
      if (_phase == _Phase.warmup) {
        _phase = _Phase.preview;
      } else if (_phase == _Phase.stability) {
        _phase = _Phase.cooldown;
      } else if (_phase == _Phase.cooldown) {
        _endSession();
      }
    });
  }

  void _completeMovementPhase() async {
    if (_sessionId != null) {
      final dao = ref.read(workoutDaoProvider);
      if (_phase == _Phase.warmup) {
        await dao.markWarmupCompleted(_sessionId!);
      } else if (_phase == _Phase.stability) {
        await dao.markStabilityCompleted(_sessionId!);
      } else if (_phase == _Phase.cooldown) {
        await dao.markCooldownCompleted(_sessionId!);
      }
    }
    setState(() {
      if (_phase == _Phase.warmup) {
        _phase = _Phase.preview;
      } else if (_phase == _Phase.stability) {
        _phase = _Phase.cooldown;
      } else if (_phase == _Phase.cooldown) {
        _endSession();
      }
    });
  }

  // ─── Preview phase (INLINE EXERCISE DETAIL) ─────────────────────

  Widget _buildPreview(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = context.phoenix.textSecondary;
    final ex = _currentPlanned.exercise;

    final primaryMuscles = MuscleBadge.parse(ex.musclesPrimary);
    final secondaryMuscles = MuscleBadge.parse(ex.musclesSecondary);
    final steps = NumberedSteps.parseSteps(ex.executionCues);
    final repsLabel = _currentPlanned.repsMin == _currentPlanned.repsMax
        ? '${_currentPlanned.repsMin}'
        : '${_currentPlanned.repsMin}-${_currentPlanned.repsMax}';

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.md),
            children: [
              // Hero
              ExerciseHero(category: ex.category),

              const SizedBox(height: Spacing.lg),

              // Exercise name
              Text(
                ex.name,
                style: PhoenixTypography.h1.copyWith(
                  color: context.phoenix.textPrimary,
                ),
              ),

              const SizedBox(height: Spacing.sm),

              // Badges: category, type, level
              Wrap(
                spacing: Spacing.sm,
                runSpacing: Spacing.xs,
                children: [
                  _InlineBadge(
                    label: ex.category.toUpperCase(),
                    color: ExerciseHero.categoryColor(ex.category, isDark: isDark),
                  ),
                  _InlineBadge(
                    label: ex.exerciseType.toUpperCase(),
                    color: subtitleColor,
                  ),
                  _InlineBadge(
                    label: 'LV. ${ex.phoenixLevel}',
                    color: subtitleColor,
                  ),
                ],
              ),

              const SizedBox(height: Spacing.lg),

              // Stats grid
              StatsGrid(
                sets: _currentPlanned.sets,
                repsLabel: repsLabel,
                tempoEcc: _currentPlanned.tempoEcc,
                tempoCon: _currentPlanned.tempoCon,
                equipment: ex.equipment,
              ),

              // Description
              if (ex.executionCues.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                _SectionLabel(text: 'DESCRIZIONE'),
                const SizedBox(height: Spacing.sm),
                Text(
                  ex.executionCues,
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
              ],

              // Numbered steps
              if (steps.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                _SectionLabel(text: 'ESECUZIONE'),
                const SizedBox(height: Spacing.sm),
                NumberedSteps(steps: steps),
              ],

              // Instructions (rich content)
              if (ex.instructions.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                _SectionLabel(text: 'ISTRUZIONI'),
                const SizedBox(height: Spacing.sm),
                Text(
                  ex.instructions,
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: subtitleColor,
                    height: 1.5,
                  ),
                ),
              ],

              // Muscles
              if (primaryMuscles.isNotEmpty || secondaryMuscles.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                _SectionLabel(text: 'MUSCOLI'),
                const SizedBox(height: Spacing.sm),
                if (primaryMuscles.isNotEmpty) ...[
                  Text(
                    'Primari',
                    style: PhoenixTypography.micro.copyWith(color: subtitleColor),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.xs,
                    children: primaryMuscles
                        .map((m) => MuscleBadge(muscle: m, isPrimary: true))
                        .toList(),
                  ),
                ],
                if (secondaryMuscles.isNotEmpty) ...[
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Secondari',
                    style: PhoenixTypography.micro.copyWith(color: subtitleColor),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.xs,
                    children: secondaryMuscles
                        .map((m) => MuscleBadge(muscle: m, isPrimary: false))
                        .toList(),
                  ),
                ],
              ],

              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),

        // Pinned "Pronto" button
        Container(
          padding: const EdgeInsets.fromLTRB(
              Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.lg),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: context.phoenix.border,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: TDButton(
              text: 'PRONTO',
              type: TDButtonType.fill,
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              isBlock: true,
              onTap: () {
                HapticFeedback.mediumImpact();
                _maybeShowRpeExplanation();
              },
            ),
          ),
        ),
      ],
    );
  }

  // ─── Countdown phase ───────────────────────────────────────────

  Widget _buildCountdown(BuildContext context) {
    return Center(
      child: Text(
        '$_countdownValue',
        style: PhoenixTypography.hero.copyWith(
          fontSize: 120,
          color: context.phoenix.textPrimary,
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(
            begin: 0.8, end: 1.1,
            duration: const Duration(milliseconds: 800),
          ),
    );
  }

  // ─── Tracking phase (BRUTALIST TEMPO BAR) ───────────────────────

  Widget _buildTracking(BuildContext context) {
    final subtitleColor = context.phoenix.textSecondary;
    final exercise = _currentPlanned;
    final totalSets = exercise.sets;

    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bio overlay (visible only when ring is active)
          if (_bioTracker != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: BioOverlay(tracker: _bioTracker!, isResting: false),
            ),
            const SizedBox(height: Spacing.xs),
          ],

          Text(
            exercise.exercise.name,
            style: PhoenixTypography.h2.copyWith(
              color: context.phoenix.textPrimary,
            ),
          ).animate().fadeIn(duration: AnimDurations.fast),

          const SizedBox(height: Spacing.sm),

          // Set pill
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md, vertical: Spacing.xs),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.phoenix.borderStrong,
                width: Borders.medium,
              ),
            ),
            child: Text(
              'SERIE ${_currentSetIndex + 1} / $totalSets',
              style: PhoenixTypography.caption.copyWith(
                color: context.phoenix.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: Spacing.xl),

          // Large reps counter
          Text(
            '$_repsRemaining',
            style: PhoenixTypography.numericLarge.copyWith(
              color: context.phoenix.textPrimary,
            ),
          ),

          const SizedBox(height: Spacing.sm),

          // Phase label
          Text(
            _phaseLabel(_currentTempoPhase),
            style: PhoenixTypography.h3.copyWith(
              color: _phaseColor(_currentTempoPhase),
            ),
          ),

          const SizedBox(height: Spacing.md),

          // Brutalist tempo bar
          if (_tempoBarController != null)
            AnimatedBuilder(
              animation: _tempoBarController!,
              builder: (context, _) {
                return _BrutalistTempoBar(
                  progress: _tempoBarController!.value,
                  tempoEcc: exercise.tempoEcc,
                  tempoPause: 1,
                  tempoCon: exercise.tempoCon,
                  currentPhase: _currentTempoPhase,
                );
              },
            ),

          const SizedBox(height: Spacing.lg),

          // Execution cues + muscle chips
          if (exercise.exercise.executionCues.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.phoenix.border,
                ),
              ),
              child: Text(
                exercise.exercise.executionCues,
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: subtitleColor,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          if (exercise.exercise.musclesPrimary.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.xs,
              alignment: WrapAlignment.center,
              children: _muscleChips(exercise.exercise.musclesPrimary, Theme.of(context)),
            ),
          ],

          const SizedBox(height: Spacing.md),

          // Set history inline
          if (_setHistory.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.phoenix.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _setHistory.map((s) => Text(
                      'Set ${s.setNumber}: ${s.reps} reps @ RPE ${s.rpe.toStringAsFixed(0)}',
                      style: PhoenixTypography.bodyMedium.copyWith(
                        color: subtitleColor,
                        fontSize: 12,
                      ),
                    )).toList(),
              ),
            ),

          const Spacer(),

          // Control buttons
          PhoenixControlButtons(
            onPrevious: null,
            onPrimaryAction: _manualCompleteSet,
            onNext: null,
            isPaused: false,
            primaryIcon: Icons.check_rounded,
            previousIcon: Icons.replay_rounded,
            nextIcon: Icons.skip_next_rounded,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            _currentSetIndex + 1 >= totalSets &&
                    _currentExerciseIndex + 1 >= _plan!.exercises.length
                ? 'Fine sessione'
                : 'Serie completata',
            style: PhoenixTypography.micro.copyWith(
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  String _phaseLabel(TempoPhase phase) {
    return switch (phase) {
      TempoPhase.eccentric => 'ECCENTRICA \u2193',
      TempoPhase.pause => 'PAUSA',
      TempoPhase.concentric => 'CONCENTRICA \u2191',
    };
  }

  Color _phaseColor(TempoPhase phase) {
    return switch (phase) {
      TempoPhase.eccentric => PhoenixColors.warning,
      TempoPhase.pause => PhoenixColors.darkTextPrimary,
      TempoPhase.concentric => PhoenixColors.success,
    };
  }

  /// Stitch pattern 3.11: Exercise badges.
  List<Widget> _muscleChips(String muscles, ThemeData theme) {
    if (muscles.isEmpty) return [];
    final list = muscles.split(', ');
    return list.asMap().entries.map((e) {
      final isPrimary = e.key == 0;
      return Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isPrimary
                ? context.phoenix.borderHeavy
                : context.phoenix.border,
            width: isPrimary ? Borders.medium : Borders.thin,
          ),
        ),
        child: Center(
          child: Text(
            e.value.toUpperCase(),
            style: PhoenixTypography.micro.copyWith(
              color: isPrimary
                  ? context.phoenix.textPrimary
                  : context.phoenix.textSecondary,
            ),
          ),
        ),
      );
    }).toList();
  }

  // ─── Coach Chat phase (REPLACES RPE CONFIRM) ─────────────────

  Widget _buildCoachChat(BuildContext context) {
    final exercise = _currentPlanned;
    final llm = ref.read(llmEngineProvider);
    final isLlmMode = llm.isLlmAvailable;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(
              Spacing.screenH, Spacing.sm, Spacing.screenH, 0),
          child: Row(
            children: [
              Text(
                'SERIE ${_currentSetIndex + 1}/${exercise.sets}',
                style: PhoenixTypography.caption.copyWith(
                  color: context.phoenix.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${_chatRepsCompleted} REP',
                style: PhoenixTypography.caption.copyWith(
                  color: context.phoenix.textPrimary,
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Chat area or template form
        Expanded(
          child: isLlmMode ? _buildChatArea() : _buildTemplateForm(),
        ),

        // Confirm button (visible when chat done or template mode)
        if (_coachChatDone)
          Container(
            padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.lg),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: context.phoenix.border,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: TDButton(
                text: 'CONFERMA',
                type: TDButtonType.fill,
                theme: TDButtonTheme.primary,
                size: TDButtonSize.large,
                isBlock: true,
                onTap: _confirmCoachChat,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: [
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(Spacing.screenH),
            itemCount: _chatMessages.length + (_isCoachTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _chatMessages.length && _isCoachTyping) {
                return _buildTypingIndicator();
              }
              final msg = _chatMessages[index];
              return _buildChatBubble(msg);
            },
          ),
        ),

        // Input area (only if not done)
        if (!_coachChatDone)
          Container(
            padding: const EdgeInsets.fromLTRB(
                Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.sm),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: context.phoenix.border,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatInputController,
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: context.phoenix.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Come è andata?',
                      hintStyle: PhoenixTypography.bodyMedium.copyWith(
                        color: context.phoenix.textTertiary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Radii.input),
                        borderSide: BorderSide(
                          color: context.phoenix.borderStrong,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md, vertical: Spacing.sm),
                    ),
                    onSubmitted: (_) => _sendChatMessage(),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                GestureDetector(
                  onTap: _sendChatMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.phoenix.textPrimary,
                      borderRadius: BorderRadius.circular(Radii.input),
                    ),
                    child: Icon(
                      Icons.send,
                      color: context.phoenix.bg,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildChatBubble(_ChatBubble msg) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Align(
        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(Spacing.smMd),
          decoration: BoxDecoration(
            color: msg.isUser
                ? (isDark ? PhoenixColors.darkOverlay : PhoenixColors.lightElevated)
                : (isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface),
            border: Border.all(
              color: context.phoenix.border,
              width: msg.isUser ? Borders.thin : Borders.medium,
            ),
          ),
          child: Text(
            msg.text,
            style: PhoenixTypography.bodyMedium.copyWith(
              color: context.phoenix.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(Spacing.smMd),
        decoration: BoxDecoration(
          color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
          border: Border.all(
            color: context.phoenix.border,
            width: Borders.medium,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TypingDot(delay: 0),
            const SizedBox(width: 4),
            _TypingDot(delay: 200),
            const SizedBox(width: 4),
            _TypingDot(delay: 400),
          ],
        ),
      ),
    );
  }

  /// Template fallback form: structured input when LLM unavailable.
  Widget _buildTemplateForm() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = context.phoenix;
    return Padding(
      padding: const EdgeInsets.all(Spacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach question
          if (_chatMessages.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(Spacing.smMd),
              decoration: BoxDecoration(
                color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
                border: Border.all(
                  color: context.phoenix.border,
                  width: Borders.medium,
                ),
              ),
              child: Text(
                _chatMessages.first.text,
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: context.phoenix.textPrimary,
                  height: 1.4,
                ),
              ),
            ),

          const SizedBox(height: Spacing.lg),

          // Reps stepper
          _SectionLabel(text: 'REP COMPLETATE'),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StepperButton(
                icon: Icons.remove,
                onTap: _chatRepsCompleted > 0
                    ? () => setState(() => _chatRepsCompleted--)
                    : null,
              ),
              const SizedBox(width: Spacing.lg),
              Text(
                '$_chatRepsCompleted',
                style: PhoenixTypography.numeric.copyWith(
                  color: context.phoenix.textPrimary,
                ),
              ),
              const SizedBox(width: Spacing.lg),
              _StepperButton(
                icon: Icons.add,
                onTap: () => setState(() => _chatRepsCompleted++),
              ),
            ],
          ),

          const SizedBox(height: Spacing.lg),

          // RPE stepper
          _SectionLabel(text: 'RPE'),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StepperButton(
                icon: Icons.remove,
                onTap: _chatRpe > 1
                    ? () => setState(() => _chatRpe--)
                    : null,
              ),
              const SizedBox(width: Spacing.lg),
              Column(
                children: [
                  Text(
                    '$_chatRpe',
                    style: PhoenixTypography.numeric.copyWith(
                      color: context.phoenix.textPrimary,
                    ),
                  ),
                  Text(
                    _rpeLabel(_chatRpe),
                    style: PhoenixTypography.micro.copyWith(
                      color: context.phoenix.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.lg),
              _StepperButton(
                icon: Icons.add,
                onTap: _chatRpe < 10
                    ? () => setState(() => _chatRpe++)
                    : null,
              ),
            ],
          ),

          const SizedBox(height: Spacing.lg),

          // Pain toggle
          GestureDetector(
            onTap: () => setState(() => _chatPainDetected = !_chatPainDetected),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _chatPainDetected
                      ? PhoenixColors.error
                      : context.phoenix.border,
                  width: _chatPainDetected ? Borders.heavy : Borders.thin,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _chatPainDetected ? Icons.warning_amber_rounded : Icons.health_and_safety_outlined,
                    color: _chatPainDetected ? PhoenixColors.error : context.phoenix.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    _chatPainDetected ? 'Dolore segnalato' : 'Nessun dolore',
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: _chatPainDetected
                          ? PhoenixColors.error
                          : context.phoenix.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Template coach feedback
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.smMd),
            decoration: BoxDecoration(
              color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
              border: Border.all(
                color: p.border,
                width: Borders.medium,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.record_voice_over,
                  size: 16,
                  color: context.phoenix.textTertiary,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    CoachPrompts.postSetTemplateFeedback(
                      repsCompleted: _chatRepsCompleted,
                      repsTarget: _currentPlanned.repsMax,
                      rpe: _chatRpe,
                      setNumber: _currentSetIndex + 1,
                      totalSets: _currentPlanned.sets,
                      exerciseName: _currentPlanned.exercise.name,
                      category: _currentPlanned.exercise.category,
                    ),
                    style: PhoenixTypography.bodyMedium.copyWith(
                      color: context.phoenix.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _rpeLabel(int rpe) {
    switch (rpe) {
      case 1: return 'Nessuno sforzo';
      case 2: return 'Molto facile';
      case 3: return 'Facile';
      case 4: return 'Moderato';
      case 5: return 'Impegnativo';
      case 6: return 'Difficile';
      case 7: return 'Molto difficile';
      case 8: return 'Quasi massimale';
      case 9: return 'Quasi impossibile';
      case 10: return 'Massimale';
      default: return '';
    }
  }

  // ─── Rest phase ────────────────────────────────────────────────

  Widget _buildResting(BuildContext context) {
    final sub = context.phoenix.textSecondary;

    final totalSets = _currentPlanned.sets;
    String nextLabel;
    if (_currentSetIndex + 1 < totalSets) {
      nextLabel = 'Prossimo: Serie ${_currentSetIndex + 2}/$totalSets';
    } else if (_currentExerciseIndex + 1 < _plan!.exercises.length) {
      nextLabel =
          'Prossimo: ${_plan!.exercises[_currentExerciseIndex + 1].exercise.name}';
    } else {
      nextLabel = 'Ultimo set completato!';
    }

    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bio overlay (shows HR + SpO2/HRV/stress during rest)
          if (_bioTracker != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: BioOverlay(tracker: _bioTracker!, isResting: true),
            ),
            const SizedBox(height: Spacing.xs),
          ],

          const Spacer(),
          Text(
            'RIPOSO',
            style: PhoenixTypography.h2.copyWith(color: sub),
          ),
          const SizedBox(height: Spacing.lg),
          PhoenixTimerDisplay(
            minutes: _restSecondsRemaining ~/ 60,
            seconds: _restSecondsRemaining % 60,
            label: nextLabel,
          ),
          if (_coachCue.isNotEmpty) ...[
            const SizedBox(height: Spacing.lg),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.phoenix.border,
                  width: Borders.medium,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.record_voice_over,
                    size: 18,
                    color: sub,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      _coachCue,
                      style: PhoenixTypography.bodyMedium.copyWith(
                        color: sub,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: AnimDurations.normal),
          ],
          const Spacer(),
          // Footer actions
          Row(
            children: [
              // Info button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  final ex = _currentPlanned;
                  ExerciseDetailSheet.show(
                    context,
                    exercise: ex.exercise,
                    sets: ex.sets,
                    repsMin: ex.repsMin,
                    repsMax: ex.repsMax,
                    tempoEcc: ex.tempoEcc,
                    tempoCon: ex.tempoCon,
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.phoenix.borderHeavy,
                      width: Borders.medium,
                    ),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: context.phoenix.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              // Skip rest
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _restTimer?.cancel();
                    _advanceAfterRest();
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.phoenix.textPrimary,
                    ),
                    child: Center(
                      child: Text(
                        'SALTA RIPOSO',
                        style: PhoenixTypography.button.copyWith(
                          color: context.phoenix.bg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Private widgets
// ═══════════════════════════════════════════════════════════════════

/// Brutalist horizontal tempo bar — replaces breathing circle.
class _BrutalistTempoBar extends StatelessWidget {
  final double progress;
  final int tempoEcc;
  final int tempoPause;
  final int tempoCon;
  final TempoPhase currentPhase;

  const _BrutalistTempoBar({
    required this.progress,
    required this.tempoEcc,
    required this.tempoPause,
    required this.tempoCon,
    required this.currentPhase,
  });

  @override
  Widget build(BuildContext context) {
    final total = tempoEcc + tempoPause + tempoCon;
    final eccFraction = tempoEcc / total;
    final pauseFraction = tempoPause / total;

    final borderColor = context.phoenix.borderHeavy;
    final fillColor = context.phoenix.textPrimary;
    final emptyColor = context.phoenix.surface;
    final dividerColor = context.phoenix.borderStrong;

    // Calculate fill per segment
    double eccFill = 0, pauseFill = 0, conFill = 0;
    if (progress < eccFraction) {
      eccFill = progress / eccFraction;
    } else if (progress < eccFraction + pauseFraction) {
      eccFill = 1.0;
      pauseFill = (progress - eccFraction) / pauseFraction;
    } else {
      eccFill = 1.0;
      pauseFill = 1.0;
      conFill = (progress - eccFraction - pauseFraction) / (1.0 - eccFraction - pauseFraction);
    }

    return Container(
      height: 12,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: Borders.medium),
      ),
      child: Row(
        children: [
          // Eccentric segment
          Expanded(
            flex: tempoEcc,
            child: _SegmentFill(fill: eccFill, fillColor: fillColor, emptyColor: emptyColor),
          ),
          Container(width: 1, color: dividerColor),
          // Pause segment
          Expanded(
            flex: tempoPause,
            child: _SegmentFill(fill: pauseFill, fillColor: fillColor, emptyColor: emptyColor),
          ),
          Container(width: 1, color: dividerColor),
          // Concentric segment
          Expanded(
            flex: tempoCon,
            child: _SegmentFill(fill: conFill, fillColor: fillColor, emptyColor: emptyColor),
          ),
        ],
      ),
    );
  }
}

class _SegmentFill extends StatelessWidget {
  final double fill;
  final Color fillColor;
  final Color emptyColor;

  const _SegmentFill({
    required this.fill,
    required this.fillColor,
    required this.emptyColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fillWidth = constraints.maxWidth * fill.clamp(0.0, 1.0);
        return Stack(
          children: [
            Container(color: emptyColor),
            Container(
              width: fillWidth,
              color: fillColor,
            ),
          ],
        );
      },
    );
  }
}

class _InlineBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _InlineBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: PhoenixTypography.micro.copyWith(
          color: color,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: PhoenixTypography.caption.copyWith(
        color: context.phoenix.textTertiary,
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.selectionClick();
          onTap!();
        }
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled
                ? context.phoenix.borderHeavy
                : context.phoenix.border,
            width: Borders.medium,
          ),
        ),
        child: Icon(
          icon,
          color: enabled
              ? context.phoenix.textPrimary
              : context.phoenix.textQuaternary,
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final int delay;
  const _TypingDot({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: context.phoenix.textTertiary,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(delay: Duration(milliseconds: delay), duration: const Duration(milliseconds: 400))
        .then()
        .fadeOut(duration: const Duration(milliseconds: 400));
  }
}

class _ChatBubble {
  final String text;
  final bool isUser;
  const _ChatBubble({required this.text, required this.isUser});
}

class _SetRecord {
  final int setNumber;
  final int reps;
  final double rpe;
  const _SetRecord({required this.setNumber, required this.reps, required this.rpe});
}
