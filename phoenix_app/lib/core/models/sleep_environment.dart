import 'package:flutter/material.dart';

import 'sleep_score.dart';

/// Sleep environment configuration and coaching logic.
///
/// Evidence base (three traditions):
/// Western: Okamoto-Mizuno 2012, Chang 2015, Drake 2013, Irish 2015, Harding 2019
/// Chinese: Zi Wu Liu Zhu organ clock, Zi Wu Jiao napping, Pao Jiao foot bath, SZRT herbal
/// Russian: Putilov 6 chronotypes, ADAPT-232, GOST/SanPiN sleep standards
class SleepEnvironment {
  final TimeOfDay targetBedtime;
  final TimeOfDay targetWakeTime;
  final bool blueLightReminder;
  final bool caffeineReminder;
  final bool temperatureReminder;
  final int blueLightCutoffHours; // default 2
  final int caffeineCutoffHours; // default 10

  const SleepEnvironment({
    this.targetBedtime = const TimeOfDay(hour: 23, minute: 0),
    this.targetWakeTime = const TimeOfDay(hour: 7, minute: 0),
    this.blueLightReminder = false,
    this.caffeineReminder = false,
    this.temperatureReminder = false,
    this.blueLightCutoffHours = 2,
    this.caffeineCutoffHours = 10,
  });

  TimeOfDay get blueLightCutoff =>
      _subtractHours(targetBedtime, blueLightCutoffHours);

  TimeOfDay get caffeineCutoff =>
      _subtractHours(targetBedtime, caffeineCutoffHours);

  TimeOfDay get temperatureReminderTime =>
      _subtractMinutes(targetBedtime, 30);

  /// Wind-down start time (Triple Warmer window — TCM 21:00-23:00).
  /// We use bedtime - 2h as practical wind-down start.
  TimeOfDay get windDownStart =>
      _subtractHours(targetBedtime, 2);

  /// Pao Jiao (foot bath) optimal time: ~1h before bedtime.
  TimeOfDay get paoJiaoTime =>
      _subtractHours(targetBedtime, 1);

  /// Target bedtime as "HH:mm" string.
  String get targetBedtimeStr => _formatTime(targetBedtime);

  /// Target wake time as "HH:mm" string.
  String get targetWakeTimeStr => _formatTime(targetWakeTime);

  static TimeOfDay _subtractHours(TimeOfDay time, int hours) {
    final totalMinutes = time.hour * 60 + time.minute - hours * 60;
    final wrapped = totalMinutes < 0 ? totalMinutes + 1440 : totalMinutes;
    return TimeOfDay(hour: wrapped ~/ 60, minute: wrapped % 60);
  }

  static TimeOfDay _subtractMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute - minutes;
    final wrapped = totalMinutes < 0 ? totalMinutes + 1440 : totalMinutes;
    return TimeOfDay(hour: wrapped ~/ 60, minute: wrapped % 60);
  }

  static String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  SleepEnvironment copyWith({
    TimeOfDay? targetBedtime,
    TimeOfDay? targetWakeTime,
    bool? blueLightReminder,
    bool? caffeineReminder,
    bool? temperatureReminder,
    int? blueLightCutoffHours,
    int? caffeineCutoffHours,
  }) {
    return SleepEnvironment(
      targetBedtime: targetBedtime ?? this.targetBedtime,
      targetWakeTime: targetWakeTime ?? this.targetWakeTime,
      blueLightReminder: blueLightReminder ?? this.blueLightReminder,
      caffeineReminder: caffeineReminder ?? this.caffeineReminder,
      temperatureReminder: temperatureReminder ?? this.temperatureReminder,
      blueLightCutoffHours: blueLightCutoffHours ?? this.blueLightCutoffHours,
      caffeineCutoffHours: caffeineCutoffHours ?? this.caffeineCutoffHours,
    );
  }

  Map<String, dynamic> toJson() => {
        'targetBedtimeH': targetBedtime.hour,
        'targetBedtimeM': targetBedtime.minute,
        'targetWakeH': targetWakeTime.hour,
        'targetWakeM': targetWakeTime.minute,
        'blueLightReminder': blueLightReminder,
        'caffeineReminder': caffeineReminder,
        'temperatureReminder': temperatureReminder,
        'blueLightCutoffHours': blueLightCutoffHours,
        'caffeineCutoffHours': caffeineCutoffHours,
      };

  factory SleepEnvironment.fromJson(Map<String, dynamic> json) {
    return SleepEnvironment(
      targetBedtime: TimeOfDay(
        hour: json['targetBedtimeH'] as int? ?? 23,
        minute: json['targetBedtimeM'] as int? ?? 0,
      ),
      targetWakeTime: TimeOfDay(
        hour: json['targetWakeH'] as int? ?? 7,
        minute: json['targetWakeM'] as int? ?? 0,
      ),
      blueLightReminder: json['blueLightReminder'] as bool? ?? false,
      caffeineReminder: json['caffeineReminder'] as bool? ?? false,
      temperatureReminder: json['temperatureReminder'] as bool? ?? false,
      blueLightCutoffHours: json['blueLightCutoffHours'] as int? ?? 2,
      caffeineCutoffHours: json['caffeineCutoffHours'] as int? ?? 10,
    );
  }
}

/// Evidence-based sleep coaching tips from three traditions.
class SleepCoach {
  const SleepCoach._();

  /// Generate evening coaching tips based on settings and recent sleep history.
  /// Includes Western, Chinese (TCM), and Russian sleep science.
  static List<SleepTip> eveningTips(
    SleepEnvironment env,
    List<SleepEntry> recentEntries,
  ) {
    final tips = <SleepTip>[];

    // ── Data-driven tips (from sleep history) ──

    if (recentEntries.length >= 3) {
      final last7 = recentEntries.length > 7
          ? recentEntries.sublist(recentEntries.length - 7)
          : recentEntries;

      final avgQuality =
          last7.fold<int>(0, (sum, e) => sum + e.quality) / last7.length;

      if (avgQuality < 3.0) {
        tips.add(const SleepTip(
          icon: Icons.trending_down,
          message:
              'Qualit\u00e0 del sonno in calo. Prova a mantenere orari pi\u00f9 regolari.',
          priority: SleepTipPriority.high,
        ));
      }

      final regularity = SleepScore.regularity(last7);
      if (regularity.level == RegularityLevel.low) {
        tips.add(const SleepTip(
          icon: Icons.schedule,
          message:
              'Variazione orari >60min negli ultimi 7gg. La regolarit\u00e0 \u00e8 il fattore #1.',
          citation: 'Irish 2015',
          priority: SleepTipPriority.high,
        ));
      }

      final avgDuration = SleepScore.averageDuration(last7);
      if (avgDuration.inMinutes < 420) {
        tips.add(SleepTip(
          icon: Icons.nightlight,
          message:
              'Media ${avgDuration.inHours}h ${avgDuration.inMinutes % 60}m \u2014 sotto le 7h raccomandate. Atleti: 8h minimo (rischio infortunio 1.7\u00d7 se <8h).',
          citation: 'SPbNIIFK / Med sportiva russa',
          priority: SleepTipPriority.high,
        ));
      }
    }

    // ── Western science tips ──

    if (env.temperatureReminder) {
      tips.add(const SleepTip(
        icon: Icons.thermostat,
        message: 'Camera a 18-19\u00b0C per sonno ottimale (>24\u00b0C riduce REM del 30%)',
        citation: 'Okamoto-Mizuno 2012, Harding 2019',
        priority: SleepTipPriority.medium,
      ));
    }

    if (env.blueLightReminder) {
      tips.add(SleepTip(
        icon: Icons.phone_android,
        message:
            'Spegni schermi entro le ${SleepEnvironment._formatTime(env.blueLightCutoff)} \u2014 la luce blu riduce la melatonina del 55%',
        citation: 'Chang 2015 (PNAS)',
        priority: SleepTipPriority.medium,
      ));
    }

    if (env.caffeineReminder) {
      tips.add(SleepTip(
        icon: Icons.coffee,
        message:
            'Ultimo caff\u00e8 entro le ${SleepEnvironment._formatTime(env.caffeineCutoff)} \u2014 effetti misurabili fino a 8-10h',
        citation: 'Drake 2013 (JCSM)',
        priority: SleepTipPriority.low,
      ));
    }

    // ── Chinese tradition tips (TCM) ──

    // Zi Wu Liu Zhu — organ clock
    tips.add(const SleepTip(
      icon: Icons.access_time,
      message:
          'Sonno profondo entro le 23:00 \u2014 finestra Cistifellea (23-01): metabolismo biliare e regolazione emotiva. Svegliarsi tra 01-03 = stress non processato.',
      citation: 'Zi Wu Liu Zhu (\u5b50\u5348\u6d41\u6ce8)',
      priority: SleepTipPriority.medium,
    ));

    // Pao Jiao — hot foot bath
    tips.add(SleepTip(
      icon: Icons.spa,
      message:
          'Pao Jiao: piedi in acqua 40-50\u00b0C per 20 min, ~1h prima di dormire (${SleepEnvironment._formatTime(env.paoJiaoTime)}). Vasodilatazione periferica \u2192 calo temperatura core \u2192 addormentamento pi\u00f9 rapido.',
      citation: 'Huangdi Neijing / PMC 7373592',
      priority: SleepTipPriority.low,
    ));

    // SZRT — herbal alternative
    tips.add(const SleepTip(
      icon: Icons.local_florist,
      message:
          'Suan Zao Ren Tang (giuggiola acida + poria): alternativa naturale alla melatonina. Modulazione GABAergica, superiore a placebo in 13 RCT (1.454 pazienti).',
      citation: 'SZRT meta-analysis, Frontiers Pharmacology',
      priority: SleepTipPriority.low,
    ));

    // ── Russian tradition tips ──

    // ADAPT-232 paradox
    tips.add(const SleepTip(
      icon: Icons.science,
      message:
          'Adattogeni AL MATTINO migliorano il sonno NOTTURNO: Rhodiola + Schisandra + Eleuthero (ADAPT-232) modulano l\'asse HPA, riducono cortisolo diurno \u2192 miglior declino serale.',
      citation: 'ADAPT-232 / Ricerca sovietica declassificata',
      priority: SleepTipPriority.low,
    ));

    // Sort by priority (high first)
    tips.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return tips;
  }

  /// Static protocol tips shown always (not dependent on user data).
  /// Includes all three traditions.
  static const protocolTips = <SleepTip>[
    // Western
    SleepTip(
      icon: Icons.thermostat,
      message: 'Stanza a 18-19\u00b0C',
      citation: 'Okamoto-Mizuno 2012',
    ),
    SleepTip(
      icon: Icons.shower,
      message: 'Doccia calda 1-2h prima',
    ),
    SleepTip(
      icon: Icons.wb_sunny,
      message: 'Luce solare al mattino',
    ),
    SleepTip(
      icon: Icons.coffee,
      message: 'No caffeina 8-12h prima',
      citation: 'Drake 2013',
    ),
    SleepTip(
      icon: Icons.phone_android,
      message: 'No schermo blu 2h prima',
      citation: 'Chang 2015',
    ),
    SleepTip(
      icon: Icons.self_improvement,
      message: 'Routine serale consistente (\u221220-30min latenza)',
      citation: 'Irish 2015',
    ),
    // Chinese
    SleepTip(
      icon: Icons.access_time,
      message: 'Addormentarsi entro le 23:00 (non solo "a letto")',
      citation: 'Zi Wu Liu Zhu',
    ),
    SleepTip(
      icon: Icons.spa,
      message: 'Pao Jiao: piedi in acqua calda 20 min, 1h prima',
      citation: 'PMC 7373592',
    ),
    SleepTip(
      icon: Icons.single_bed,
      message: 'Nap 11-13: max 30 min (>60 min = rischio cognitivo)',
      citation: 'Zi Wu Jiao / PMC 7839842',
    ),
    // Russian
    SleepTip(
      icon: Icons.fitness_center,
      message: 'Atleti: 8h minimo, 9-10h in blocchi pesanti',
      citation: 'SPbNIIFK',
    ),
    SleepTip(
      icon: Icons.science,
      message: 'Adattogeni (Rhodiola) AL MATTINO, mai prima di dormire',
      citation: 'ADAPT-232',
    ),
  ];

  /// Napping tips based on Zi Wu Jiao protocol.
  static const nappingTips = <SleepTip>[
    SleepTip(
      icon: Icons.snooze,
      message: 'Finestra ottimale nap: 11:00-13:00 (Wu, \u5348)',
      citation: 'Zi Wu Jiao',
    ),
    SleepTip(
      icon: Icons.timer,
      message: '15-30 minuti MASSIMO. Nap >60min aumenta declino cognitivo.',
      citation: 'PMC 7839842',
    ),
    SleepTip(
      icon: Icons.favorite,
      message: 'Sonno insufficiente + nap moderato NON aumenta rischio CVD.',
      citation: 'Chinese cohort studies',
    ),
  ];
}

enum SleepTipPriority { high, medium, low }

class SleepTip {
  final IconData icon;
  final String message;
  final String? citation;
  final SleepTipPriority priority;

  const SleepTip({
    this.icon = Icons.info_outline,
    required this.message,
    this.citation,
    this.priority = SleepTipPriority.medium,
  });
}
