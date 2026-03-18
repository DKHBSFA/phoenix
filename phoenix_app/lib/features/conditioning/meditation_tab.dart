import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/models/breathing_controller.dart';
import '../../shared/widgets/phoenix_control_buttons.dart';
import 'conditioning_history.dart';

class MeditationTab extends ConsumerStatefulWidget {
  const MeditationTab({super.key});

  @override
  ConsumerState<MeditationTab> createState() => _MeditationTabState();
}

class _MeditationTabState extends ConsumerState<MeditationTab>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _running = false;
  int _totalSeconds = 0; // Total session duration chosen
  int _remainingSeconds = 0;

  BreathingPreset _preset = BreathingPreset.boxBreathing;
  BreathingConfig _config = BreathingConfig.box;
  BreathingState _breathState = const BreathingState();

  // Custom sliders
  int _customInhale = 4;
  int _customHoldIn = 4;
  int _customExhale = 4;
  int _customHoldOut = 4;

  // Duration selection
  int _selectedMinutes = 10;
  static const _durationOptions = [5, 10, 15, 20];

  // Animation
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  void _selectPreset(BreathingPreset preset) {
    setState(() {
      _preset = preset;
      _config = switch (preset) {
        BreathingPreset.boxBreathing => BreathingConfig.box,
        BreathingPreset.relaxation => BreathingConfig.relaxation,
        BreathingPreset.custom => BreathingConfig(
            inhaleSeconds: _customInhale,
            holdInSeconds: _customHoldIn,
            exhaleSeconds: _customExhale,
            holdOutSeconds: _customHoldOut,
          ),
      };
    });
  }

  void _start() {
    setState(() {
      _running = true;
      _totalSeconds = _selectedMinutes * 60;
      _remainingSeconds = _totalSeconds;
      _breathState = const BreathingState();
      if (_preset == BreathingPreset.custom) {
        _config = BreathingConfig(
          inhaleSeconds: _customInhale,
          holdInSeconds: _customHoldIn,
          exhaleSeconds: _customExhale,
          holdOutSeconds: _customHoldOut,
        );
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
        _breathState = _breathState.tick(_config);
        if (_remainingSeconds <= 0) {
          _finish();
        }
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  Future<void> _finish() async {
    _timer?.cancel();
    final elapsed = _totalSeconds - _remainingSeconds;
    setState(() {
      _running = false;
      _remainingSeconds = 0;
    });

    if (elapsed < 10) return; // Don't save very short sessions

    final dao = ref.read(conditioningDaoProvider);
    await dao.addSession(ConditioningSessionsCompanion.insert(
      date: DateTime.now(),
      type: ConditioningType.meditation,
      durationSeconds: elapsed,
    ));

    if (mounted) {
      TDToast.showText('Meditazione completata — ${_breathState.cyclesCompleted} cicli', context: context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_running) {
      return _buildRunningView();
    }
    return _buildSetupView();
  }

  Widget _buildSetupView() {
    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      children: [
        const SizedBox(height: Spacing.sm),
        Text(
          'Meditazione',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          'Respirazione guidata',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.phoenix.textSecondary,
          ),
        ),
        const SizedBox(height: Spacing.xl),

        // Technique selector
        Text(
          'Tecnica',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: Spacing.sm),
        SegmentedButton<BreathingPreset>(
          segments: const [
            ButtonSegment(
              value: BreathingPreset.boxBreathing,
              label: Text('Box\n4-4-4-4', textAlign: TextAlign.center),
            ),
            ButtonSegment(
              value: BreathingPreset.relaxation,
              label: Text('Rilassamento\n4-6', textAlign: TextAlign.center),
            ),
            ButtonSegment(
              value: BreathingPreset.custom,
              label: Text('Personalizzato', textAlign: TextAlign.center),
            ),
          ],
          selected: {_preset},
          onSelectionChanged: (s) => _selectPreset(s.first),
        ),

        // Custom sliders
        if (_preset == BreathingPreset.custom) ...[
          const SizedBox(height: Spacing.md),
          _PhaseSlider(
            label: 'Inspira',
            value: _customInhale,
            onChanged: (v) => setState(() => _customInhale = v),
          ),
          _PhaseSlider(
            label: 'Trattieni (in)',
            value: _customHoldIn,
            onChanged: (v) => setState(() => _customHoldIn = v),
          ),
          _PhaseSlider(
            label: 'Espira',
            value: _customExhale,
            onChanged: (v) => setState(() => _customExhale = v),
          ),
          _PhaseSlider(
            label: 'Trattieni (out)',
            value: _customHoldOut,
            onChanged: (v) => setState(() => _customHoldOut = v),
          ),
        ],

        const SizedBox(height: Spacing.xl),

        // Duration selector
        Text('Durata', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Spacing.sm),
        SegmentedButton<int>(
          segments: _durationOptions
              .map((m) => ButtonSegment(value: m, label: Text('${m}min')))
              .toList(),
          selected: {_selectedMinutes},
          onSelectionChanged: (s) =>
              setState(() => _selectedMinutes = s.first),
        ),

        const SizedBox(height: Spacing.xxl),

        // Start button
        Center(
          child: SizedBox(
            width: 200,
            height: 56,
            child: TDButton(
              text: 'Inizia',
              type: TDButtonType.fill,
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              onTap: _start,
            ),
          ),
        ),

        const SizedBox(height: Spacing.xl),
        ConditioningHistory(type: ConditioningType.meditation),
      ],
    );
  }

  Widget _buildRunningView() {
    final progress = _breathState.progress(_config);
    final phase = _breathState.phase;
    final remainMins = _remainingSeconds ~/ 60;
    final remainSecs = _remainingSeconds % 60;

    // Circle size based on phase
    final isExpanding =
        phase == BreathingPhase.inhale;
    final isContracting = phase == BreathingPhase.exhale;
    final baseSize = 120.0;
    final maxSize = 200.0;

    double circleSize;
    if (isExpanding) {
      circleSize = baseSize + (maxSize - baseSize) * progress;
    } else if (isContracting) {
      circleSize = maxSize - (maxSize - baseSize) * progress;
    } else {
      // Hold phases: maintain current size
      final wasExpanded = phase == BreathingPhase.holdIn;
      circleSize = wasExpanded ? maxSize : baseSize;
    }

    return Column(
      children: [
        const Spacer(),

        // Breathing circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PhoenixColors.conditioningAccent.withAlpha(51),
            border: Border.all(
              color: PhoenixColors.conditioningAccent,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              _breathState.phaseLabel,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: PhoenixColors.conditioningAccent,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),

        const SizedBox(height: Spacing.xl),

        // Phase counter
        Text(
          '${_config.durationOf(phase) - _breathState.secondsInPhase}',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: PhoenixColors.conditioningAccent,
              ),
        ),

        const SizedBox(height: Spacing.md),

        // Cycles completed
        Text(
          'Cicli: ${_breathState.cyclesCompleted}',
          style: TextStyle(
            color: context.phoenix.textSecondary,
          ),
        ),

        const SizedBox(height: Spacing.sm),

        // Remaining time
        Text(
          '${remainMins.toString().padLeft(2, '0')}:${remainSecs.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: context.phoenix.textSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),

        const Spacer(),

        // Stop control — Stitch pattern 3.7
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.xxl),
          child: PhoenixControlButtons(
            onPrimaryAction: _stop,
            isPaused: false,
            primaryIcon: Icons.stop_rounded,
          ),
        ),
      ],
    );
  }
}

class _PhaseSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _PhaseSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label),
          ),
          Expanded(
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: '${value}s',
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text('${value}s', textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
