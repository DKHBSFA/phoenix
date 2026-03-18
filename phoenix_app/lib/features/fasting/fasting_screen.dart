import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/llm/prompt_templates.dart';
import '../../core/models/nutrition_calculator.dart';
import '../../shared/widgets/phoenix_pill_tabs.dart';
import '../coach/widgets/ai_insight_card.dart';
import 'levels_tab.dart';
import 'nutrition_tab.dart';

class FastingScreen extends ConsumerStatefulWidget {
  const FastingScreen({super.key});

  @override
  ConsumerState<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends ConsumerState<FastingScreen> {
  Timer? _ticker;
  int _selectedIndex = 0;

  static const _tabs = [
    PhoenixPillTab(label: 'Timer', icon: Icons.timer_outlined),
    PhoenixPillTab(label: 'Nutrizione', icon: Icons.restaurant_outlined),
    PhoenixPillTab(label: 'Livelli', icon: Icons.trending_up),
  ];

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [
      _TimerTab(),
      const NutritionTab(),
      const LevelsTab(),
    ];

    return Scaffold(
      appBar: const TDNavBar(title: 'Digiuno', useDefaultBack: false),
      body: Column(
        children: [
          const SizedBox(height: Spacing.sm),
          PhoenixPillTabs(
            tabs: _tabs,
            selectedIndex: _selectedIndex,
            onChanged: (i) => setState(() => _selectedIndex = i),
          ),
          const SizedBox(height: Spacing.sm),
          Expanded(child: bodies[_selectedIndex]),
        ],
      ),
    );
  }
}

// ─── Timer Tab ──────────────────────────────────────────────────

class _TimerTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastingDao = ref.watch(fastingDaoProvider);
    final notifService = ref.watch(notificationServiceProvider);

    return StreamBuilder(
      stream: fastingDao.watchActiveFast(),
      builder: (context, snapshot) {
        final activeFast = snapshot.data;

        if (activeFast != null) {
          return _ActiveFastView(
            sessionId: activeFast.id,
            startedAt: activeFast.startedAt,
            targetHours: activeFast.targetHours,
            level: activeFast.level,
            waterCount: activeFast.waterCount,
            onEnd: () async {
              final now = DateTime.now();
              final hours =
                  now.difference(activeFast.startedAt).inMinutes / 60.0;
              // Show refeeding journal first
              if (context.mounted) {
                await _showRefeedingJournal(
                    context, ref, activeFast.id);
              }
              await fastingDao.endFast(activeFast.id, now, hours);
              await notifService.cancelFastingMilestones();
            },
            onWater: () => fastingDao.incrementWater(activeFast.id),
          );
        }

        return Column(
          children: [
            AiInsightCard(
              engine: ref.watch(llmEngineProvider),
              template: FastingAdvisorTemplate(),
              context: const {
                'recent_fasting_sessions': [],
                'tolerance_scores': [],
                'energy_scores': [],
                'day_of_week_patterns': '',
                'current_level': 1,
              },
              icon: Icons.psychology,
              title: 'Insight digiuno AI',
              accentColor: PhoenixColors.fastingAccent,
            ),
            Expanded(
              child: _StartFastView(
          onStart: (targetHours, level) async {
            final now = DateTime.now();
            await fastingDao.startFast(
              startedAt: now,
              targetHours: targetHours,
              level: level,
            );
            await notifService.scheduleFastingMilestones(now);
          },
        ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRefeedingJournal(
      BuildContext context, WidgetRef ref, int sessionId) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (ctx) => _RefeedingJournalSheet(
        onSave: (notes, tolerance, energy) async {
          await ref.read(fastingDaoProvider).updateRefeedingJournal(
                sessionId,
                notes: notes,
                tolerance: tolerance,
                energy: energy,
              );
        },
      ),
    );
  }
}

// ─── Active Fast View ───────────────────────────────────────────

class _ActiveFastView extends StatelessWidget {
  final int sessionId;
  final DateTime startedAt;
  final double targetHours;
  final int level;
  final int waterCount;
  final VoidCallback onEnd;
  final VoidCallback onWater;

  const _ActiveFastView({
    required this.sessionId,
    required this.startedAt,
    required this.targetHours,
    required this.level,
    required this.waterCount,
    required this.onEnd,
    required this.onWater,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elapsed = DateTime.now().difference(startedAt);
    final elapsedHours = elapsed.inMinutes / 60.0;
    final progress = (elapsedHours / targetHours).clamp(0.0, 1.0);
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes % 60;
    final seconds = elapsed.inSeconds % 60;

    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        children: [
          const SizedBox(height: Spacing.lg),

          // Circular timer with glow
          SizedBox(
            width: 240,
            height: 240,
            child: CustomPaint(
              painter: _CircularTimerPainter(
                progress: progress,
                color: PhoenixColors.fastingAccent,
                glowEnabled: true,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      '/ ${targetHours.toInt()}h',
                      style: TextStyle(
                          color: context.phoenix.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .custom(
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [],
                    ),
                    child: child,
                  );
                },
              ),

          const SizedBox(height: Spacing.md),

          // Level indicator
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md, vertical: Spacing.sm),
            decoration: BoxDecoration(
              color: context.phoenix.elevated,
              borderRadius: BorderRadius.circular(Radii.full),
            ),
            child: Text(
              'Livello $level — ${NutritionCalculator.levelTargetLabel(level)}',
              style: const TextStyle(fontSize: 14),
            ),
          ),

          const SizedBox(height: Spacing.md),

          // Milestones
          _MilestoneRow(elapsedHours: elapsedHours),

          const SizedBox(height: Spacing.md),

          // Water counter
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDButton(
                text: 'Acqua ($waterCount)',
                icon: Icons.water_drop_outlined,
                type: TDButtonType.outline,
                theme: TDButtonTheme.defaultTheme,
                size: TDButtonSize.large,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onWater();
                },
              ),
            ],
          ),

          const SizedBox(height: Spacing.xs),
          Text(
            'Acqua + elettroliti (Na, K, Mg) — niente calorie',
            style: TextStyle(
              fontSize: 11,
              color: context.phoenix.textTertiary,
            ),
          ),

          const Spacer(),

          // End fast button
          TDButton(
            text: 'Termina digiuno',
            type: TDButtonType.outline,
            theme: TDButtonTheme.danger,
            size: TDButtonSize.large,
            isBlock: true,
            onTap: () => _confirmEnd(context),
          ),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  void _confirmEnd(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminare il digiuno?'),
        content: const Text(
            'Verrai guidato nel refeeding journal prima di chiudere la sessione.'),
        actions: [
          TDButton(
            text: 'Annulla',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx),
          ),
          TDButton(
            text: 'Termina',
            type: TDButtonType.text,
            theme: TDButtonTheme.danger,
            onTap: () {
              Navigator.pop(ctx);
              onEnd();
            },
          ),
        ],
      ),
    );
  }
}

// ─── Milestones ─────────────────────────────────────────────────

class _MilestoneRow extends StatelessWidget {
  final double elapsedHours;

  const _MilestoneRow({required this.elapsedHours});

  @override
  Widget build(BuildContext context) {
    const milestones = [12, 14, 16, 18, 24];
    return Wrap(
      spacing: Spacing.sm,
      runSpacing: Spacing.sm,
      alignment: WrapAlignment.center,
      children: milestones.map((h) {
        final reached = elapsedHours >= h;
        return Chip(
          label: Text('${h}h'),
          backgroundColor: reached
              ? PhoenixColors.success
              : context.phoenix.elevated,
          labelStyle: TextStyle(
            color: reached
                ? PhoenixColors.darkTextPrimary
                : context.phoenix.textSecondary,
            fontWeight: reached ? FontWeight.bold : FontWeight.normal,
          ),
        )
            .animate(target: reached ? 1 : 0)
            .scaleXY(begin: 1, end: 1.1, duration: AnimDurations.fast)
            .then()
            .scaleXY(end: 1.0, duration: AnimDurations.fast);
      }).toList(),
    );
  }
}

// ─── Start Fast View ────────────────────────────────────────────

class _StartFastView extends StatefulWidget {
  final void Function(double targetHours, int level) onStart;

  const _StartFastView({required this.onStart});

  @override
  State<_StartFastView> createState() => _StartFastViewState();
}

class _StartFastViewState extends State<_StartFastView> {
  int _selectedLevel = 1;

  double get _targetHours => NutritionCalculator.targetHoursForLevel(_selectedLevel);

  void _confirmLevel3(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Avviso medico'),
        content: const Text(
          'Il digiuno prolungato (18-24h) richiede supervisione medica. '
          'Prosegui solo se il tuo medico lo ha approvato.',
        ),
        actions: [
          TDButton(
            text: 'Annulla',
            type: TDButtonType.text,
            theme: TDButtonTheme.defaultTheme,
            onTap: () => Navigator.pop(ctx),
          ),
          TDButton(
            text: 'Ho capito, prosegui',
            type: TDButtonType.text,
            theme: TDButtonTheme.primary,
            onTap: () {
              Navigator.pop(ctx);
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Spacing.xl),
          Text(
            'Inizia un digiuno',
            style: theme.textTheme.headlineMedium,
          ).animate().fadeIn(duration: AnimDurations.normal),
          const SizedBox(height: Spacing.xl),

          // Level selector
          ...List.generate(3, (i) {
            final level = i + 1;
            return Card(
              margin: const EdgeInsets.only(bottom: Spacing.md),
              color: _selectedLevel == level
                  ? PhoenixColors.fastingAccent.withAlpha(30)
                  : null,
              child: ListTile(
                leading: Radio<int>(
                  value: level,
                  groupValue: _selectedLevel,
                  onChanged: (v) {
                    HapticFeedback.selectionClick();
                    if (v == 3) {
                      _confirmLevel3(context, () => setState(() => _selectedLevel = 3));
                    } else {
                      setState(() => _selectedLevel = v!);
                    }
                  },
                ),
                title: Text(
                    'Livello $level — ${NutritionCalculator.levelTargetLabel(level)}'),
                subtitle: Text(
                  NutritionCalculator.levelDescription(level),
                  style: TextStyle(
                      color: context.phoenix.textSecondary),
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  if (level == 3) {
                    _confirmLevel3(context, () => setState(() => _selectedLevel = 3));
                  } else {
                    setState(() => _selectedLevel = level);
                  }
                },
              ),
            )
                .animate()
                .fadeIn(
                    duration: AnimDurations.normal,
                    delay: AnimDurations.stagger * (i + 1))
                .slideX(begin: 0.05, end: 0);
          }),

          const Spacer(),

          // Sticky footer CTA (pattern 3.15)
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: context.phoenix.bg.withAlpha(204),
              border: Border(
                top: BorderSide(
                  color: context.phoenix.border,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Secondary icon button
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: PhoenixColors.fastingAccent,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.info_outline),
                      color: PhoenixColors.fastingAccent,
                      onPressed: () {
                        // Show level info
                        TDToast.showText(NutritionCalculator.levelDescription(_selectedLevel), context: context);
                      },
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  // Primary button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        widget.onStart(_targetHours, _selectedLevel);
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: PhoenixColors.fastingAccent,
                          borderRadius: BorderRadius.circular(Radii.md),
                          boxShadow: const [],
                        ),
                        child: Center(
                          child: Text(
                            'Avvia digiuno (${_targetHours.toInt()}h)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: PhoenixColors.darkTextPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Refeeding Journal Sheet ────────────────────────────────────

class _RefeedingJournalSheet extends StatefulWidget {
  final Future<void> Function(String notes, double tolerance, int energy)
      onSave;

  const _RefeedingJournalSheet({required this.onSave});

  @override
  State<_RefeedingJournalSheet> createState() => _RefeedingJournalSheetState();
}

class _RefeedingJournalSheetState extends State<_RefeedingJournalSheet> {
  final _notesController = TextEditingController();
  double _tolerance = 3;
  int _energy = 3;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          Spacing.lg, Spacing.lg, Spacing.lg, Spacing.lg + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Come è andato il digiuno?',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: Spacing.lg),

          // Tolerance slider
          Text('Tolleranza',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.phoenix.textSecondary)),
          Row(
            children: [
              const Text('1'),
              Expanded(
                child: Slider(
                  value: _tolerance,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _tolerance.toInt().toString(),
                  activeColor: PhoenixColors.fastingAccent,
                  onChanged: (v) => setState(() => _tolerance = v),
                ),
              ),
              const Text('5'),
            ],
          ),
          const SizedBox(height: Spacing.sm),

          // Energy slider
          Text('Energia percepita',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.phoenix.textSecondary)),
          Row(
            children: [
              const Text('1'),
              Expanded(
                child: Slider(
                  value: _energy.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _energy.toString(),
                  activeColor: PhoenixColors.fastingAccent,
                  onChanged: (v) => setState(() => _energy = v.toInt()),
                ),
              ),
              const Text('5'),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Notes
          TextField(
            controller: _notesController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Cosa hai mangiato per primo? Note...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: Spacing.lg),

          TDButton(
            text: 'Salva e termina',
            type: TDButtonType.fill,
            theme: TDButtonTheme.primary,
            size: TDButtonSize.large,
            isBlock: true,
            onTap: () async {
              await widget.onSave(
                _notesController.text.trim(),
                _tolerance,
                _energy,
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Circular Timer Painter ─────────────────────────────────────

class _CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool glowEnabled;

  _CircularTimerPainter({
    required this.progress,
    required this.color,
    this.glowEnabled = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = PhoenixColors.darkBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Glow layer
    if (glowEnabled && progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = color.withAlpha(60)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularTimerPainter old) =>
      old.progress != progress;
}
