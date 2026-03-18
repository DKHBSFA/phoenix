import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/tables.dart';

/// Unified history timeline showing all past sessions (workout, fasting, conditioning).
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = context.phoenix.textPrimary;
    final subtitleColor = context.phoenix.textSecondary;
    final borderColor = context.phoenix.border;
    final surfaceColor = context.phoenix.surface;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.screenH, Spacing.screenTop, Spacing.screenH, Spacing.md,
            ),
            child: Text(
              'Storico',
              style: PhoenixTypography.displayLarge.copyWith(color: textColor),
            ),
          ),
          Expanded(
            child: _HistoryTimeline(
              textColor: textColor,
              subtitleColor: subtitleColor,
              borderColor: borderColor,
              surfaceColor: surfaceColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTimeline extends ConsumerWidget {
  final Color textColor;
  final Color subtitleColor;
  final Color borderColor;
  final Color surfaceColor;

  const _HistoryTimeline({
    required this.textColor,
    required this.subtitleColor,
    required this.borderColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(_historyProvider);

    return historyAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 48, color: subtitleColor),
                const SizedBox(height: Spacing.md),
                Text(
                  'Nessuna sessione ancora',
                  style: PhoenixTypography.bodyLarge.copyWith(color: subtitleColor),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _HistoryItem(
              item: item,
              textColor: textColor,
              subtitleColor: subtitleColor,
              borderColor: borderColor,
              surfaceColor: surfaceColor,
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: PhoenixColors.darkTextPrimary),
      ),
      error: (_, __) => Center(
        child: Text(
          'Errore nel caricamento',
          style: PhoenixTypography.bodyLarge.copyWith(color: PhoenixColors.error),
        ),
      ),
    );
  }
}

/// A unified history item (workout, fasting, or conditioning).
class _HistoryEntry {
  final DateTime date;
  final String type; // 'workout', 'fasting', 'cold', 'heat', 'meditation', 'sleep'
  final String title;
  final String subtitle;
  final IconData icon;

  _HistoryEntry({
    required this.date,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _HistoryItem extends StatelessWidget {
  final _HistoryEntry item;
  final Color textColor;
  final Color subtitleColor;
  final Color borderColor;
  final Color surfaceColor;

  const _HistoryItem({
    required this.item,
    required this.textColor,
    required this.subtitleColor,
    required this.borderColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM HH:mm', 'it_IT').format(item.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: textColor),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: PhoenixTypography.bodyLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    item.subtitle,
                    style: PhoenixTypography.bodyMedium.copyWith(color: subtitleColor),
                  ),
                ],
              ),
            ),
            Text(
              dateStr,
              style: PhoenixTypography.caption.copyWith(color: subtitleColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider that combines all session types into a unified timeline.
final _historyProvider = FutureProvider<List<_HistoryEntry>>((ref) async {
  final workoutDao = ref.watch(workoutDaoProvider);
  final fastingDao = ref.watch(fastingDaoProvider);
  final conditioningDao = ref.watch(conditioningDaoProvider);

  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));

  final entries = <_HistoryEntry>[];

  // Workouts
  final workouts = await workoutDao.getSessionsInRange(thirtyDaysAgo, now);
  for (final w in workouts) {
    final duration = w.endedAt != null
        ? w.endedAt!.difference(w.startedAt).inMinutes
        : 0;
    entries.add(_HistoryEntry(
      date: w.startedAt,
      type: 'workout',
      title: w.type,
      subtitle: '${duration}min',
      icon: Icons.fitness_center,
    ));
  }

  // Fasting
  final fasts = await fastingDao.getSessionsInRange(thirtyDaysAgo, now);
  for (final f in fasts) {
    final hours = f.actualHours?.toStringAsFixed(1) ?? '?';
    entries.add(_HistoryEntry(
      date: f.startedAt,
      type: 'fasting',
      title: 'Digiuno L${f.level}',
      subtitle: '${hours}h',
      icon: Icons.timer,
    ));
  }

  // Conditioning
  final condTypes = [
    ConditioningType.cold,
    ConditioningType.heat,
    ConditioningType.meditation,
    ConditioningType.sleep,
  ];
  for (final type in condTypes) {
    final sessions = await conditioningDao.getRecentByType(type, days: 30);
    for (final s in sessions) {
      if (s.date.isBefore(thirtyDaysAgo)) continue;
      final (title, icon) = switch (type) {
        ConditioningType.cold => ('Freddo', Icons.ac_unit),
        ConditioningType.heat => ('Caldo', Icons.whatshot),
        ConditioningType.meditation => ('Meditazione', Icons.self_improvement),
        _ => ('Sonno', Icons.bedtime),
      };
      final durMin = s.durationSeconds ~/ 60;
      entries.add(_HistoryEntry(
        date: s.date,
        type: type,
        title: title,
        subtitle: durMin > 0 ? '${durMin}min' : '${s.durationSeconds}s',
        icon: icon,
      ));
    }
  }

  // Sort by date descending
  entries.sort((a, b) => b.date.compareTo(a.date));
  return entries;
});
