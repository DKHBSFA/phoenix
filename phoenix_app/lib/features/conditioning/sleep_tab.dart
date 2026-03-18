import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/models/sleep_score.dart';
import '../../core/models/sleep_environment.dart';
import '../../core/notifications/notification_scheduler.dart';
import '../../core/ring/sleep_parser.dart';
import '../../shared/widgets/phoenix_switch_tile.dart';
import 'widgets/sleep_hypnogram.dart';

class SleepTab extends ConsumerStatefulWidget {
  const SleepTab({super.key});

  @override
  ConsumerState<SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends ConsumerState<SleepTab> {
  List<SleepEntry> _entries = [];
  bool _loading = true;
  List<SleepPeriod>? _ringStages;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dao = ref.read(conditioningDaoProvider);
    final sessions = await dao.getRecentByType(ConditioningType.sleep, days: 14);

    final entries = <SleepEntry>[];
    for (final s in sessions) {
      final entry = SleepScore.fromNotesJson(s.notes, s.date);
      if (entry != null) entries.add(entry);
    }

    // Load ring sleep stages for hypnogram
    final ringDataDao = ref.read(ringDataDaoProvider);
    final hasRingSleep = await ringDataDao.hasLastNightSleep();
    List<SleepPeriod>? ringStages;
    if (hasRingSleep) {
      final now = DateTime.now();
      final nightDate = now.hour < 12
          ? DateTime(now.year, now.month, now.day - 1)
          : DateTime(now.year, now.month, now.day);
      final dbStages = await ringDataDao.getSleepStages(nightDate);
      if (dbStages.isNotEmpty) {
        ringStages = dbStages
            .map((s) => SleepPeriod(
                  stage: SleepStage.fromLabel(s.stage),
                  start: s.startTime,
                  end: s.endTime,
                ))
            .toList();
      }
    }

    if (mounted) {
      setState(() {
        _entries = entries;
        _ringStages = ringStages;
        _loading = false;
      });
    }
  }

  SleepEnvironment _getSleepEnv() {
    final settings = ref.read(settingsProvider);
    if (settings.sleepEnvironmentJson != null) {
      try {
        final json = jsonDecode(settings.sleepEnvironmentJson!) as Map<String, dynamic>;
        return SleepEnvironment.fromJson(json);
      } catch (e) { debugPrint('Sleep save error: $e'); }
    }
    return const SleepEnvironment();
  }

  Future<void> _updateSleepEnv(SleepEnvironment env) async {
    final jsonStr = jsonEncode(env.toJson());
    await ref.read(settingsProvider.notifier).setSleepEnvironmentJson(jsonStr);

    // Reschedule notifications
    final scheduler = NotificationScheduler(
      ref.read(notificationServiceProvider),
      ref.read(workoutDaoProvider),
      ref.read(conditioningDaoProvider),
    );

    if (env.blueLightReminder || env.caffeineReminder || env.temperatureReminder) {
      await scheduler.scheduleSleepEnvironmentReminders(env);
    } else {
      await scheduler.cancelSleepEnvironmentReminders();
    }
  }

  Future<void> _pickBedtime() async {
    final env = _getSleepEnv();
    final picked = await showTimePicker(
      context: context,
      initialTime: env.targetBedtime,
    );
    if (picked != null) {
      await _updateSleepEnv(env.copyWith(targetBedtime: picked));
      setState(() {});
    }
  }

  Future<void> _pickWakeTime() async {
    final env = _getSleepEnv();
    final picked = await showTimePicker(
      context: context,
      initialTime: env.targetWakeTime,
    );
    if (picked != null) {
      await _updateSleepEnv(env.copyWith(targetWakeTime: picked));
      setState(() {});
    }
  }

  Future<void> _addSleepEntry() async {
    final now = DateTime.now();
    TimeOfDay bedtime = const TimeOfDay(hour: 23, minute: 0);
    TimeOfDay wakeTime = const TimeOfDay(hour: 7, minute: 0);
    int quality = 3;
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final bedDt = DateTime(now.year, now.month, now.day,
                bedtime.hour, bedtime.minute);
            final wakeDt = DateTime(now.year, now.month, now.day,
                wakeTime.hour, wakeTime.minute);
            final duration = SleepScore.sleepDuration(bedDt, wakeDt);
            final hours = duration.inMinutes ~/ 60;
            final mins = duration.inMinutes % 60;

            return AlertDialog(
              title: const Text('Registra sonno'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bedtime
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ora addormentamento'),
                      trailing: TDButton(
                        text: bedtime.format(ctx),
                        type: TDButtonType.text,
                        theme: TDButtonTheme.defaultTheme,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: bedtime,
                          );
                          if (picked != null) {
                            setDialogState(() => bedtime = picked);
                          }
                        },
                      ),
                    ),
                    // Wake time
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ora risveglio'),
                      trailing: TDButton(
                        text: wakeTime.format(ctx),
                        type: TDButtonType.text,
                        theme: TDButtonTheme.defaultTheme,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: wakeTime,
                          );
                          if (picked != null) {
                            setDialogState(() => wakeTime = picked);
                          }
                        },
                      ),
                    ),
                    // Duration display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                      child: Text(
                        'Durata: ${hours}h ${mins}m',
                        style: Theme.of(ctx).textTheme.titleMedium,
                      ),
                    ),
                    // Quality
                    const SizedBox(height: Spacing.sm),
                    const Text('Qualità'),
                    TDRate(
                      value: quality.toDouble(),
                      count: 5,
                      size: 32.0,
                      color: [PhoenixColors.conditioningAccent, Colors.grey.shade300],
                      onChange: (v) => setDialogState(() => quality = v.toInt()),
                    ),
                    // Notes
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Note (opzionale)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TDButton(
                  text: 'Annulla',
                  type: TDButtonType.text,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: () => Navigator.pop(ctx, false),
                ),
                TDButton(
                  text: 'Salva',
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () => Navigator.pop(ctx, true),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) return;

    final bedDt = DateTime(now.year, now.month, now.day,
        bedtime.hour, bedtime.minute);
    final wakeDt = DateTime(now.year, now.month, now.day,
        wakeTime.hour, wakeTime.minute);
    final duration = SleepScore.sleepDuration(bedDt, wakeDt);

    final entry = SleepEntry(
      date: now,
      bedtime: bedDt,
      wakeTime: wakeDt,
      quality: quality,
      notes: notesController.text,
    );

    final dao = ref.read(conditioningDaoProvider);
    await dao.addSession(ConditioningSessionsCompanion.insert(
      date: now,
      type: ConditioningType.sleep,
      durationSeconds: duration.inSeconds,
      notes: drift.Value(SleepScore.toNotesJson(entry)),
    ));

    notesController.dispose();
    _loadData();

    if (mounted) {
      TDToast.showText('Sonno registrato', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Center(child: TDLoading(size: TDLoadingSize.medium));
    }

    final env = _getSleepEnv();
    final last7 = _entries.length > 7 ? _entries.sublist(_entries.length - 7) : _entries;
    final avg = SleepScore.averageDuration(last7);
    final regularity = SleepScore.regularity(last7);
    final onTarget = SleepScore.daysOnTarget(last7);
    final tips = SleepCoach.eveningTips(env, _entries);

    return ListView(
      padding: const EdgeInsets.all(Spacing.screenH),
      children: [
        const SizedBox(height: Spacing.sm),

        // Ring hypnogram (if ring data available)
        if (_ringStages != null && _ringStages!.isNotEmpty) ...[
          _buildSectionHeader(Icons.show_chart, 'Ipnogramma stanotte'),
          const SizedBox(height: Spacing.sm),
          _buildCard(
            isDark: isDark,
            child: SleepHypnogram(stages: _ringStages!),
          ),
          const SizedBox(height: Spacing.xl),
        ],

        // Summary card
        _buildCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riepilogo sonno',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PhoenixColors.conditioningAccent,
                    ),
              ),
              const SizedBox(height: Spacing.sm),
              _SleepStatRow(
                label: 'Media ultimi 7 giorni',
                value: last7.isEmpty
                    ? '—'
                    : '${avg.inHours}h ${avg.inMinutes % 60}m',
              ),
              _SleepStatRow(
                label: 'Regolarità',
                value: regularity.label,
                valueColor: switch (regularity.level) {
                  RegularityLevel.high => PhoenixColors.success,
                  RegularityLevel.medium => PhoenixColors.warning,
                  RegularityLevel.low => PhoenixColors.error,
                  RegularityLevel.unknown => context.phoenix.textTertiary,
                },
              ),
              _SleepStatRow(
                label: 'Target 7h+ raggiunto',
                value: last7.isEmpty ? '—' : '$onTarget/${last7.length} giorni',
              ),
            ],
          ),
        ),

        const SizedBox(height: Spacing.xl),

        // Environment settings
        _buildSectionHeader(Icons.settings, 'Ambiente sonno'),
        const SizedBox(height: Spacing.sm),
        _buildCard(
          isDark: isDark,
          child: Column(
            children: [
              // Target bedtime
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Bedtime target'),
                trailing: TDButton(
                  text: env.targetBedtime.format(context),
                  type: TDButtonType.text,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: _pickBedtime,
                ),
              ),
              // Target wake time
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sveglia target'),
                trailing: TDButton(
                  text: env.targetWakeTime.format(context),
                  type: TDButtonType.text,
                  theme: TDButtonTheme.defaultTheme,
                  onTap: _pickWakeTime,
                ),
              ),
              const Divider(height: 1),
              // Temperature reminder
              PhoenixSwitchTile(
                title: 'Temperatura',
                subtitle: '30 min prima — "Camera a 18-19°C"',
                value: env.temperatureReminder,
                onChanged: (v) async {
                  await _updateSleepEnv(env.copyWith(temperatureReminder: v));
                  setState(() {});
                },
              ),
              // Blue light reminder
              PhoenixSwitchTile(
                title: 'Luce blu',
                subtitle: 'Alle ${_formatTime(env.blueLightCutoff)} — "${env.blueLightCutoffHours}h prima"',
                value: env.blueLightReminder,
                onChanged: (v) async {
                  await _updateSleepEnv(env.copyWith(blueLightReminder: v));
                  setState(() {});
                },
              ),
              // Caffeine reminder
              PhoenixSwitchTile(
                title: 'Caffeina',
                subtitle: 'Alle ${_formatTime(env.caffeineCutoff)} — "${env.caffeineCutoffHours}h prima"',
                value: env.caffeineReminder,
                onChanged: (v) async {
                  await _updateSleepEnv(env.copyWith(caffeineReminder: v));
                  setState(() {});
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: Spacing.xl),

        // Dynamic coaching tips
        if (tips.isNotEmpty) ...[
          _buildSectionHeader(Icons.lightbulb_outline, 'Coaching'),
          const SizedBox(height: Spacing.sm),
          _buildCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final tip in tips)
                  _CoachTip(tip: tip),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xl),
        ],

        // Chart (last 14 days)
        if (_entries.isNotEmpty) ...[
          _buildSectionHeader(Icons.bar_chart, 'Ultimi 14 giorni'),
          const SizedBox(height: Spacing.sm),
          SizedBox(
            height: 200,
            child: _SleepChart(entries: _entries),
          ),
          const SizedBox(height: Spacing.xl),
        ],

        // Add button
        Center(
          child: SizedBox(
            width: 220,
            height: 56,
            child: TDButton(
              text: 'Registra sonno',
              icon: Icons.add,
              type: TDButtonType.fill,
              theme: TDButtonTheme.primary,
              size: TDButtonSize.large,
              onTap: _addSleepEntry,
            ),
          ),
        ),

        const SizedBox(height: Spacing.xl),

        // Static protocol tips
        _buildSectionHeader(Icons.menu_book, 'Consigli dal protocollo'),
        const SizedBox(height: Spacing.sm),
        _buildCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Tip(icon: Icons.thermostat, text: 'Stanza a 18-19°C', citation: 'Okamoto-Mizuno 2012'),
              _Tip(icon: Icons.shower, text: 'Doccia calda 1-2h prima'),
              _Tip(icon: Icons.wb_sunny, text: 'Luce solare al mattino'),
              _Tip(icon: Icons.coffee, text: 'No caffeina 8-12h prima', citation: 'Drake 2013'),
              _Tip(icon: Icons.phone_android, text: 'No schermo blu 2h prima', citation: 'Chang 2015'),
              _Tip(icon: Icons.self_improvement, text: 'Routine serale consistente', citation: 'Irish 2015'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: context.phoenix.textPrimary, size: 20),
        const SizedBox(width: Spacing.sm),
        Text(title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
      ],
    );
  }

  Widget _buildCard({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: context.phoenix.border),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: child,
    );
  }

  static String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _SleepStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SleepStatRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                color: context.phoenix.textSecondary,
              )),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: valueColor ?? context.phoenix.textPrimary,
              )),
        ],
      ),
    );
  }
}

class _CoachTip extends StatelessWidget {
  final SleepTip tip;

  const _CoachTip({required this.tip});

  @override
  Widget build(BuildContext context) {
    final priorityColor = switch (tip.priority) {
      SleepTipPriority.high => PhoenixColors.error,
      SleepTipPriority.medium => PhoenixColors.conditioningAccent,
      SleepTipPriority.low => context.phoenix.textTertiary,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tip.icon, size: 18, color: priorityColor),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.message,
                    style: TextStyle(
                      color: context.phoenix.textPrimary,
                    )),
                if (tip.citation != null)
                  Text(tip.citation!,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.phoenix.textTertiary,
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? citation;

  const _Tip({required this.icon, required this.text, this.citation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.phoenix.textTertiary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: TextStyle(
                      color: context.phoenix.textSecondary,
                    )),
                if (citation != null)
                  Text(citation!,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.phoenix.textTertiary,
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepChart extends StatelessWidget {
  final List<SleepEntry> entries;

  const _SleepChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    final barGroups = <BarChartGroupData>[];

    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final hours = e.duration.inMinutes / 60.0;
      final qualityColor = _qualityColor(e.quality);

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: hours,
              color: qualityColor,
              width: 16,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 12,
        minY: 0,
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            // Show target lines at 7h and 8h
            if (value == 7 || value == 8) {
              return FlLine(
                color: PhoenixColors.success.withAlpha(102),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            }
            return FlLine(color: Colors.transparent);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= entries.length) return const SizedBox();
                final d = entries[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${d.day}/${d.month}',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.phoenix.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}h',
                  style: TextStyle(
                    fontSize: 10,
                    color: context.phoenix.textTertiary,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }

  Color _qualityColor(int quality) {
    return switch (quality) {
      1 => PhoenixColors.error,
      2 => PhoenixColors.warning,
      3 => PhoenixColors.conditioningAccent,
      4 => PhoenixColors.success.withAlpha(200),
      _ => PhoenixColors.success,
    };
  }
}
