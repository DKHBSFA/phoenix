import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:drift/drift.dart' as drift;

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../shared/widgets/phoenix_control_buttons.dart';
import '../../shared/widgets/phoenix_timer_display.dart';
import 'conditioning_history.dart';

class HeatTab extends ConsumerStatefulWidget {
  const HeatTab({super.key});

  @override
  ConsumerState<HeatTab> createState() => _HeatTabState();
}

class _HeatTabState extends ConsumerState<HeatTab> {
  Timer? _timer;
  int _seconds = 0;
  bool _running = false;
  final _tempController = TextEditingController();

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      setState(() => _running = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
    }
  }

  Future<void> _save() async {
    _timer?.cancel();
    setState(() => _running = false);

    if (_seconds == 0) return;

    final dao = ref.read(conditioningDaoProvider);
    final temp = double.tryParse(_tempController.text);

    await dao.addSession(ConditioningSessionsCompanion.insert(
      date: DateTime.now(),
      type: ConditioningType.heat,
      durationSeconds: _seconds,
      temperature: drift.Value(temp),
    ));

    setState(() => _seconds = 0);
    _tempController.clear();

    if (mounted) {
      TDToast.showText('Sessione salvata', context: context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mins = _seconds ~/ 60;
    final secs = _seconds % 60;

    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      children: [
        const SizedBox(height: Spacing.screenH),
        Text('Sauna / Bagno caldo',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center),
        const SizedBox(height: Spacing.xs),
        Text(
          'Registra temperatura e durata',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.phoenix.textSecondary,
          ),
        ),
        const SizedBox(height: Spacing.xxl),

        // Timer display — Stitch pattern 3.5
        Center(
          child: PhoenixTimerDisplay(
            minutes: mins,
            seconds: secs,
          ),
        ),
        const SizedBox(height: Spacing.xl),

        // Control buttons (pattern 3.7)
        PhoenixControlButtons(
          onPrimaryAction: _toggle,
          isPaused: !_running,
          primaryIcon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onNext: (!_running && _seconds > 0) ? _save : null,
          nextIcon: Icons.save_rounded,
          previousIcon: Icons.refresh_rounded,
          onPrevious: (!_running && _seconds > 0)
              ? () => setState(() => _seconds = 0)
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
        ConditioningHistory(type: ConditioningType.heat),
      ],
    );
  }
}
