import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/models/nutrition_calculator.dart';

class NutritionTab extends ConsumerWidget {
  const NutritionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return profile.when(
      loading: () => Center(child: TDLoading(size: TDLoadingSize.medium)),
      error: (e, _) => Center(child: Text('Errore: $e')),
      data: (p) {
        if (p == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: Text(
                'Completa il profilo per vedere i target nutrizionali.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final calc = NutritionCalculator(
          weightKg: p.weightKg,
          tier: p.trainingTier,
        );

        return ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            _MacroTargetCard(calc: calc),
            const SizedBox(height: Spacing.cardGap),
            _EatingWindowCard(calc: calc),
            const SizedBox(height: Spacing.cardGap),
            _MealDiaryCard(),
          ],
        );
      },
    );
  }
}

// ─── Macro Target Card ──────────────────────────────────────────

class _MacroTargetCard extends StatelessWidget {
  final NutritionCalculator calc;
  const _MacroTargetCard({required this.calc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(
          color: context.phoenix.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes,
                  color: PhoenixColors.fastingAccent, size: 20),
              const SizedBox(width: Spacing.sm),
              Text('Target giornaliero',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _StatRow(
            label: 'Proteine target',
            value: '${calc.dailyProteinGrams.round()}g',
            color: PhoenixColors.fastingAccent,
          ),
          const SizedBox(height: Spacing.sm),
          _StatRow(
            label: 'Distribuzione',
            value:
                '${calc.recommendedMeals} pasti × ~${calc.proteinPerMeal.round()}g',
          ),
          const SizedBox(height: Spacing.sm),
          _StatRow(
            label: 'Per pasto (min)',
            value: '${calc.perMealProteinMin.round()}g',
          ),
        ],
      ),
    ).animate().fadeIn(duration: AnimDurations.normal);
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: context.phoenix.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─── Eating Window Card ─────────────────────────────────────────

class _EatingWindowCard extends ConsumerWidget {
  final NutritionCalculator calc;
  const _EatingWindowCard({required this.calc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fastingDao = ref.watch(fastingDaoProvider);

    return FutureBuilder<FastingSession?>(
      future: fastingDao.getLastCompleted(),
      builder: (context, snapshot) {
        final currentLevel = snapshot.data?.level ?? 1;
        return _buildCard(context, theme, isDark, currentLevel);
      },
    );
  }

  Widget _buildCard(BuildContext context, ThemeData theme, bool isDark, int level) {
    // Eating window adapts to fasting level:
    // L1: 10:00-18:00, L2: 12:00-18:00, L3: 14:00-18:00
    final startHour = switch (level) {
      2 => 12,
      3 => 14,
      _ => 10,
    };
    final windowHours = NutritionCalculator.eatingWindowHours(level);
    final endHour = startHour + windowHours;

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(
          color: context.phoenix.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule,
                  color: PhoenixColors.fastingAccent, size: 20),
              const SizedBox(width: Spacing.sm),
              Text('Finestra alimentare',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // 24h bar
          _TimeBar(startHour: startHour, endHour: endHour),
          const SizedBox(height: Spacing.md),

          _StatRow(
            label: 'Primo pasto',
            value: '${startHour.toString().padLeft(2, '0')}:00',
          ),
          const SizedBox(height: Spacing.xs),
          _StatRow(
            label: 'Ultimo pasto',
            value: '${endHour.toString().padLeft(2, '0')}:00',
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            'Primo pasto entro 2h post-allenamento',
            style: TextStyle(
              fontSize: 12,
              color: context.phoenix.textTertiary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
        duration: AnimDurations.normal, delay: AnimDurations.stagger);
  }
}

class _TimeBar extends StatelessWidget {
  final int startHour;
  final int endHour;

  const _TimeBar({required this.startHour, required this.endHour});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.sm),
          child: SizedBox(
            height: 24,
            child: Row(
              children: List.generate(24, (h) {
                final isEating = h >= startHour && h < endHour;
                return Expanded(
                  child: Container(
                    color: isEating
                        ? PhoenixColors.fastingAccent.withAlpha(180)
                        : (isDark
                            ? PhoenixColors.darkOverlay
                            : PhoenixColors.lightElevated),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('00',
                style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary)),
            Text('06',
                style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary)),
            Text('12',
                style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary)),
            Text('18',
                style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary)),
            Text('24',
                style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary)),
          ],
        ),
      ],
    );
  }
}

// ─── Meal Diary Card ────────────────────────────────────────────

class _MealDiaryCard extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MealDiaryCard> createState() => _MealDiaryCardState();
}

class _MealDiaryCardState extends ConsumerState<_MealDiaryCard> {
  // Soft-delete: hide meal immediately, delete after 5s unless undone
  final Map<int, Timer> _pendingDeletes = {};
  final Set<int> _hiddenMealIds = {};

  @override
  void dispose() {
    for (final timer in _pendingDeletes.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _softDeleteMeal(int mealId) {
    setState(() => _hiddenMealIds.add(mealId));

    final timer = Timer(const Duration(seconds: 5), () {
      // Actually delete after timeout
      ref.read(mealLogDaoProvider).deleteMeal(mealId);
      _pendingDeletes.remove(mealId);
      if (mounted) setState(() => _hiddenMealIds.remove(mealId));
    });
    _pendingDeletes[mealId] = timer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pasto eliminato'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'ANNULLA',
          onPressed: () => _undoDelete(mealId),
        ),
      ),
    );
  }

  void _undoDelete(int mealId) {
    _pendingDeletes[mealId]?.cancel();
    _pendingDeletes.remove(mealId);
    setState(() => _hiddenMealIds.remove(mealId));
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mealLogDao = ref.watch(mealLogDaoProvider);
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(CardTokens.padding),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(CardTokens.borderRadius),
        border: Border.all(
          color: context.phoenix.border,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu,
                  color: PhoenixColors.fastingAccent, size: 20),
              const SizedBox(width: Spacing.sm),
              Text('Diario pasti',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                onPressed: () => _showAddMealSheet(context, ref),
                icon: const Icon(Icons.add_circle_outline),
                color: PhoenixColors.fastingAccent,
                tooltip: 'Aggiungi pasto',
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),

          StreamBuilder<List<MealLog>>(
            stream: mealLogDao.watchMealsForDay(today),
            builder: (context, snapshot) {
              final allMeals = snapshot.data ?? [];
              final meals = allMeals.where((m) => !_hiddenMealIds.contains(m.id)).toList();

              if (meals.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
                  child: Center(
                    child: Text(
                      'Nessun pasto registrato oggi.\nTocca + per aggiungere.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: context.phoenix.textSecondary),
                    ),
                  ),
                );
              }

              return Column(
                children: meals.map((meal) {
                  final time = TimeOfDay.fromDateTime(meal.mealTime);
                  final protLabel = _proteinLabel(meal.proteinEstimate);
                  return TDSwipeCell(
                    slidableKey: ValueKey(meal.id),
                    groupTag: 'meals',
                    right: TDSwipeCellPanel(
                      extentRatio: 0.25,
                      children: [
                        TDSwipeCellAction(
                          icon: Icons.delete,
                          label: 'Elimina',
                          backgroundColor: PhoenixColors.error,
                          direction: Axis.vertical,
                          onPressed: (_) => _softDeleteMeal(meal.id),
                        ),
                      ],
                    ),
                    cell: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: Spacing.xs),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? PhoenixColors.darkSurface
                              : PhoenixColors.lightElevated,
                          borderRadius: BorderRadius.circular(Radii.md),
                          border: Border.all(
                            color: context.phoenix.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Color accent bar
                            Container(
                              width: 4,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _mealAccentColor(time),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(Radii.md),
                                  bottomLeft: Radius.circular(Radii.md),
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.smMd),
                            Text(
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFeatures: [FontFeature.tabularFigures()],
                                color: context.phoenix.textSecondary,
                              ),
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(meal.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text(
                                      'Proteine: $protLabel${meal.feeling.isNotEmpty ? '  ${meal.feeling}' : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.phoenix.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(
        duration: AnimDurations.normal,
        delay: AnimDurations.stagger * 2);
  }

  Color _mealAccentColor(TimeOfDay time) {
    if (time.hour < 11) return PhoenixColors.warning; // breakfast
    if (time.hour < 15) return PhoenixColors.darkTextPrimary; // lunch
    if (time.hour < 20) return PhoenixColors.darkTextSecondary; // dinner
    return PhoenixColors.darkTextTertiary; // snacks
  }

  String _proteinLabel(String estimate) {
    return switch (estimate) {
      ProteinEstimate.low => 'Bassa (<15g)',
      ProteinEstimate.medium => 'Media (15-30g)',
      ProteinEstimate.high => 'Alta (30-45g)',
      ProteinEstimate.veryHigh => 'Molto alta (>45g)',
      _ => estimate,
    };
  }

  void _showAddMealSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddMealSheet(
        onSave: (description, proteinEstimate, feeling) async {
          final now = DateTime.now();
          await ref.read(mealLogDaoProvider).addMeal(
                MealLogsCompanion.insert(
                  date: DateTime(now.year, now.month, now.day),
                  mealTime: now,
                  description: description,
                  proteinEstimate: proteinEstimate,
                  feeling: Value(feeling),
                ),
              );
        },
      ),
    );
  }
}

// ─── Add Meal Sheet ─────────────────────────────────────────────

class _AddMealSheet extends StatefulWidget {
  final Future<void> Function(
      String description, String proteinEstimate, String feeling) onSave;

  const _AddMealSheet({required this.onSave});

  @override
  State<_AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends State<_AddMealSheet> {
  final _descController = TextEditingController();
  String _proteinEstimate = ProteinEstimate.medium;
  String _feeling = '';

  static const _feelings = ['', '\u{1F60A}', '\u{1F610}', '\u{1F634}', '\u{1F922}'];
  static const _feelingLabels = ['—', 'Bene', 'Così così', 'Stanco', 'Male'];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg,
          Spacing.lg + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aggiungi pasto',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: Spacing.md),

          // Description
          TextField(
            controller: _descController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Es. Pollo grigliato con riso e verdure',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: Spacing.md),

          // Protein estimate
          Text('Stima proteine',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.phoenix.textSecondary)),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.sm,
            children: [
              _proteinChip(ProteinEstimate.low, 'Bassa\n<15g'),
              _proteinChip(ProteinEstimate.medium, 'Media\n15-30g'),
              _proteinChip(ProteinEstimate.high, 'Alta\n30-45g'),
              _proteinChip(ProteinEstimate.veryHigh, 'Molto alta\n>45g'),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // Feeling
          Text('Come ti senti?',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: context.phoenix.textSecondary)),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_feelings.length, (i) {
              final selected = _feeling == _feelings[i];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _feeling = _feelings[i]);
                },
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? PhoenixColors.fastingAccent.withAlpha(40)
                            : null,
                        border: selected
                            ? Border.all(
                                color: PhoenixColors.fastingAccent, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _feelings[i].isEmpty ? '—' : _feelings[i],
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(_feelingLabels[i],
                        style: TextStyle(
                            fontSize: 10,
                            color: context.phoenix.textTertiary)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: Spacing.lg),

          // Save button
          TDButton(
            text: 'Salva',
            type: TDButtonType.fill,
            theme: TDButtonTheme.primary,
            size: TDButtonSize.large,
            isBlock: true,
            disabled: _descController.text.trim().isEmpty,
            onTap: () async {
              await widget.onSave(
                _descController.text.trim(),
                _proteinEstimate,
                _feeling,
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _proteinChip(String value, String label) {
    final selected = _proteinEstimate == value;
    return ChoiceChip(
      label: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (s) {
        HapticFeedback.selectionClick();
        setState(() => _proteinEstimate = value);
      },
      selectedColor: PhoenixColors.fastingAccent.withAlpha(40),
    );
  }
}
