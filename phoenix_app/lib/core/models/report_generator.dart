import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../database/database.dart';
import '../database/daos/workout_dao.dart';
import '../database/daos/fasting_dao.dart';
import '../database/daos/conditioning_dao.dart';
import '../database/daos/biomarker_dao.dart';
import '../database/daos/exercise_dao.dart';
import '../database/daos/llm_report_dao.dart';
import '../database/tables.dart';
import 'supplement_engine.dart';

/// Template-based report generator.
/// When the LLM is available, these templates will be replaced by LLM generation.
class ReportGenerator {
  final WorkoutDao workoutDao;
  final FastingDao fastingDao;
  final ConditioningDao conditioningDao;
  final BiomarkerDao biomarkerDao;
  final ExerciseDao exerciseDao;
  final LlmReportDao llmReportDao;

  ReportGenerator({
    required this.workoutDao,
    required this.fastingDao,
    required this.conditioningDao,
    required this.biomarkerDao,
    required this.exerciseDao,
    required this.llmReportDao,
  });

  /// Report after a workout session.
  Future<String> generatePostWorkout(int sessionId) async {
    final session = await workoutDao.getSession(sessionId);
    if (session == null) return 'Sessione non trovata.';

    final sets = await workoutDao.getSetsForSession(sessionId);
    final duration = session.durationMinutes?.toStringAsFixed(0) ?? '?';
    final score = session.durationScore ?? 'N/A';
    final rpe = session.rpeAverage?.toStringAsFixed(1) ?? 'N/A';

    final buf = StringBuffer();
    buf.writeln('## Report Post-Allenamento');
    buf.writeln('');
    buf.writeln('**Tipo:** ${session.type}');
    buf.writeln('**Durata:** $duration min');
    buf.writeln('**Duration Score:** ${_scoreEmoji(score)} $score');
    buf.writeln('**RPE medio:** $rpe');
    buf.writeln('');

    // Group sets by exercise
    final exerciseSets = <int, List<WorkoutSet>>{};
    for (final s in sets) {
      exerciseSets.putIfAbsent(s.exerciseId, () => []).add(s);
    }

    // Resolve exercise names
    final exerciseNames = <int, String>{};
    for (final id in exerciseSets.keys) {
      try {
        final ex = await exerciseDao.getById(id);
        exerciseNames[id] = ex.name;
      } catch (_) {
        exerciseNames[id] = 'Esercizio #$id';
      }
    }

    buf.writeln('### Esercizi');
    for (final entry in exerciseSets.entries) {
      final name = exerciseNames[entry.key] ?? 'Esercizio #${entry.key}';
      final exSets = entry.value;
      final setCount = exSets.length;
      final reps = exSets.map((s) => s.repsCompleted).join(', ');
      final setRpes = exSets.where((s) => s.rpe != null).map((s) => s.rpe!);
      final rpeStr =
          setRpes.isNotEmpty ? ' — RPE ${(setRpes.reduce((a, b) => a + b) / setRpes.length).toStringAsFixed(1)}' : '';
      buf.writeln('- **$name:** $setCount set × [$reps] reps$rpeStr');
    }
    buf.writeln('');

    // Compare with previous session of same type
    final previous = await workoutDao.getSessionsByType(session.type, limit: 2);
    if (previous.length >= 2) {
      final prev = previous[1]; // [0] is current
      final prevDuration = prev.durationMinutes?.toStringAsFixed(0) ?? '?';
      final prevRpe = prev.rpeAverage?.toStringAsFixed(1) ?? 'N/A';
      buf.writeln('### Confronto');
      buf.writeln('- Sessione precedente: $prevDuration min, RPE $prevRpe');

      // Duration comparison
      if (session.durationMinutes != null && prev.durationMinutes != null) {
        final delta = session.durationMinutes! - prev.durationMinutes!;
        final sign = delta >= 0 ? '+' : '';
        buf.writeln('- Differenza durata: $sign${delta.toStringAsFixed(0)} min');
      }
    }
    buf.writeln('');

    buf.writeln(_postWorkoutSuggestion(session, sets));

    // Next session suggestion
    buf.writeln('');
    buf.writeln('### Prossima sessione');
    final nextDay = _nextTrainingDay(session.type);
    buf.writeln('- $nextDay');

    final report = buf.toString();
    await llmReportDao.saveReport(type: LlmReportType.postWorkout, outputText: report);
    return report;
  }

  /// Report for the last completed workout.
  Future<String> generateLastWorkout() async {
    final recent = await workoutDao.watchRecentSessions(limit: 1).first;
    if (recent.isEmpty) {
      return '## Nessuna sessione\n\n'
          'Non hai ancora completato un allenamento.\n'
          'Vai alla tab **Training** per iniziare la tua prima sessione.';
    }
    return generatePostWorkout(recent.first.id);
  }

  /// Weekly summary report.
  ///
  /// If [userAge] and [userSex] are provided, the report includes
  /// biomarker-driven supplement recommendations.
  Future<String> generateWeekly({int? userAge, String? userSex}) async {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 7));

    final sessions = await workoutDao.getSessionsInRange(weekStart, now);
    final fasts = await fastingDao.getSessionsInRange(weekStart, now);

    final buf = StringBuffer();
    buf.writeln('## Report Settimanale');
    buf.writeln('');

    // Workout summary
    final completedSessions =
        sessions.where((s) => s.endedAt != null).toList();
    const target = 7;
    buf.writeln('### Allenamento');
    buf.writeln(
        '- Sessioni: **${completedSessions.length}**/$target ${_progressBar(completedSessions.length, target)}');

    if (completedSessions.isNotEmpty) {
      final avgDuration = completedSessions
              .where((s) => s.durationMinutes != null)
              .fold<double>(0, (sum, s) => sum + s.durationMinutes!) /
          completedSessions.length;
      buf.writeln('- Durata media: ${avgDuration.toStringAsFixed(0)} min');

      // Top exercise (most sets)
      final allSets = <int, int>{};
      for (final s in completedSessions) {
        final sets = await workoutDao.getSetsForSession(s.id);
        for (final set in sets) {
          allSets[set.exerciseId] = (allSets[set.exerciseId] ?? 0) + 1;
        }
      }
      if (allSets.isNotEmpty) {
        final topId = allSets.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        try {
          final topEx = await exerciseDao.getById(topId);
          buf.writeln('- Top esercizio: **${topEx.name}** (${allSets[topId]} set)');
        } catch (e) { debugPrint('Report generation error: $e'); }
      }
    }

    final streak = await workoutDao.currentStreak();
    buf.writeln('- Streak: $streak giorni');
    buf.writeln('');

    // Fasting summary
    final completedFasts = fasts.where((f) => f.endedAt != null).toList();
    buf.writeln('### Digiuno');
    if (completedFasts.isNotEmpty) {
      buf.writeln('- Sessioni completate: **${completedFasts.length}**');
      final avgHours = completedFasts
              .where((f) => f.actualHours != null)
              .fold<double>(0, (sum, f) => sum + f.actualHours!) /
          completedFasts.length;
      buf.writeln('- Durata media: ${avgHours.toStringAsFixed(1)}h');
      buf.writeln('- Livello attuale: ${completedFasts.first.level}');
    } else {
      buf.writeln('- Nessuna sessione questa settimana');
    }
    buf.writeln('');

    // Conditioning
    buf.writeln('### Condizionamento');
    for (final type in [
      ConditioningType.cold,
      ConditioningType.heat,
      ConditioningType.meditation,
    ]) {
      final typeSessions =
          await conditioningDao.getByTypeInRange(type, weekStart, now);
      final typeStreak = await conditioningDao.currentStreak(type);
      final label = _conditioningLabel(type);
      buf.writeln(
          '- **$label:** ${typeSessions.length} sessioni (streak: $typeStreak gg)');
    }
    buf.writeln('');

    // Weight trend
    final weights =
        await biomarkerDao.getByType(BiomarkerType.weight, limit: 2);
    if (weights.isNotEmpty) {
      final v = _parseValuesJson(weights.first.valuesJson);
      final w = (v?['weight_kg'] as num?)?.toDouble();
      if (w != null) {
        buf.writeln('### Peso');
        buf.writeln('- Attuale: ${w.toStringAsFixed(1)} kg');
        if (weights.length >= 2) {
          final prev = _parseValuesJson(weights[1].valuesJson);
          final prevW = (prev?['weight_kg'] as num?)?.toDouble();
          if (prevW != null) {
            final delta = w - prevW;
            final sign = delta >= 0 ? '+' : '';
            buf.writeln('- Delta: $sign${delta.toStringAsFixed(1)} kg');
          }
        }
        buf.writeln('');
      }
    }

    // Supplement recommendations (biomarker-driven)
    if (userAge != null && userSex != null) {
      final bloodPanels =
          await biomarkerDao.getByType(BiomarkerType.bloodPanel, limit: 1);
      if (bloodPanels.isNotEmpty) {
        final panelValues = _parseValuesJson(bloodPanels.first.valuesJson);
        if (panelValues != null) {
          final biomarkerMap = <String, double>{};
          for (final entry in panelValues.entries) {
            final v = entry.value;
            if (v is num) biomarkerMap[entry.key] = v.toDouble();
          }
          const engine = SupplementEngine();
          final recs = engine.evaluate(
            biomarkers: biomarkerMap,
            age: userAge,
            sex: userSex,
          );
          final activeRecs = recs
              .where((r) => r.priority != SupplementPriority.informative)
              .toList();
          if (activeRecs.isNotEmpty) {
            buf.writeln('### Integratori');
            for (final rec in activeRecs) {
              final pLabel = switch (rec.priority) {
                SupplementPriority.high => '\u26a0\ufe0f',
                SupplementPriority.medium => '\u2139\ufe0f',
                _ => '',
              };
              buf.writeln(
                  '- $pLabel **${rec.name}** (${rec.traditionLabel}): ${rec.dose} \u2014 ${rec.timing}');
            }
            final missing = engine.missingBiomarkers(biomarkerMap);
            if (missing.isNotEmpty) {
              buf.writeln(
                  '- \u2753 Marker mancanti: ${missing.join(", ")} \u2014 inseriscili al prossimo esame');
            }
            buf.writeln('');
          }
        }
      }
    }

    // Strengths / areas for improvement
    buf.writeln('### Valutazione');
    final strengths = <String>[];
    final improvements = <String>[];

    if (completedSessions.length >= 5) {
      strengths.add('Ottima costanza negli allenamenti');
    } else if (completedSessions.length >= 3) {
      strengths.add('Buona frequenza di allenamento');
    } else if (completedSessions.length <= 1) {
      improvements.add('Aumentare la frequenza degli allenamenti');
    }
    if (completedFasts.isNotEmpty) {
      strengths.add('Digiuno praticato regolarmente');
    } else {
      improvements.add('Inserire sessioni di digiuno');
    }
    if (streak >= 3) {
      strengths.add('Streak allenamento attivo: $streak giorni');
    }

    if (strengths.isNotEmpty) {
      buf.writeln('**Punti di forza:**');
      for (final s in strengths) {
        buf.writeln('- $s');
      }
    }
    if (improvements.isNotEmpty) {
      buf.writeln('**Aree di miglioramento:**');
      for (final s in improvements) {
        buf.writeln('- $s');
      }
    }

    // Next week suggestion
    buf.writeln('');
    buf.writeln('### Prossima settimana');
    if (completedSessions.length < 3) {
      buf.writeln('> **Obiettivo:** raggiungere almeno 3 sessioni di allenamento.');
    } else if (completedFasts.isEmpty) {
      buf.writeln('> **Obiettivo:** inserire almeno 1 sessione di digiuno.');
    } else {
      buf.writeln('> **Obiettivo:** mantenere la costanza e cercare progressioni sugli esercizi.');
    }

    final weeklyReport = buf.toString();
    await llmReportDao.saveReport(type: LlmReportType.weekly, outputText: weeklyReport);
    return weeklyReport;
  }

  /// Post-fasting report.
  Future<String> generateFasting() async {
    final last = await fastingDao.getLastCompleted();
    if (last == null) {
      return '## Nessun digiuno\n\n'
          'Non hai ancora completato un digiuno.\n'
          'Vai alla tab **Fasting** per iniziare.';
    }

    final buf = StringBuffer();
    buf.writeln('## Report Digiuno');
    buf.writeln('');
    buf.writeln(
        '**Durata:** ${last.actualHours?.toStringAsFixed(1) ?? "?"}h / ${last.targetHours.toInt()}h');
    buf.writeln('**Livello:** ${last.level}');

    if (last.toleranceScore != null) {
      buf.writeln(
          '**Tolleranza:** ${last.toleranceScore!.toStringAsFixed(1)}/5');
    }
    if (last.waterCount > 0) {
      buf.writeln('**Acqua:** ${last.waterCount} bicchieri');
    }

    // Milestone
    final hours = last.actualHours ?? 0;
    final milestone = _fastingMilestone(hours);
    if (milestone != null) {
      buf.writeln('');
      buf.writeln('> **Milestone:** $milestone');
    }
    buf.writeln('');

    // Compare with previous fasting session
    final prevFasts = await fastingDao.getSessionsInRange(
      DateTime.now().subtract(const Duration(days: 30)),
      DateTime.now(),
    );
    final completedPrev = prevFasts.where((f) => f.endedAt != null && f.id != last.id).toList();
    if (completedPrev.isNotEmpty) {
      final prev = completedPrev.first;
      buf.writeln('### Confronto');
      buf.writeln('- Sessione precedente: ${prev.actualHours?.toStringAsFixed(1) ?? "?"}h');
      if (prev.toleranceScore != null && last.toleranceScore != null) {
        final delta = last.toleranceScore! - prev.toleranceScore!;
        final sign = delta >= 0 ? '+' : '';
        buf.writeln('- Tolleranza: $sign${delta.toStringAsFixed(1)}');
      }
      buf.writeln('');
    }

    // Level progression check
    final nextLevel = last.level + 1;
    if (nextLevel <= 3) {
      final canAdvance = await fastingDao.canAdvanceToLevel(nextLevel);
      final stats = await fastingDao.getLevelStats(last.level);
      final needed = nextLevel == 2 ? 7 : 14;
      final goodNeeded = nextLevel == 2 ? 5 : 10;
      buf.writeln('### Progressione');
      buf.writeln(
          '- Sessioni livello ${last.level}: ${stats.total}/$needed ${_progressBar(stats.total, needed)}');
      buf.writeln(
          '- Buona tolleranza: ${stats.goodTolerance}/$goodNeeded ${_progressBar(stats.goodTolerance, goodNeeded)}');

      if (canAdvance) {
        buf.writeln('');
        buf.writeln('> **Pronto per il livello $nextLevel!** Provalo nella prossima sessione.');
      } else {
        buf.writeln('');
        buf.writeln('> Continua a consolidare — la costanza costruisce la resilienza metabolica.');
      }
    }

    final fastingReport = buf.toString();
    await llmReportDao.saveReport(type: LlmReportType.fasting, outputText: fastingReport);
    return fastingReport;
  }

  // ─── Helpers ──────────────────────────────────────────────────────

  static Map<String, dynamic>? _parseValuesJson(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (e) {
      debugPrint('Report generation error: $e');
      return null;
    }
  }

  String _scoreEmoji(String score) {
    return switch (score) {
      DurationScore.green => '🟢',
      DurationScore.yellow => '🟡',
      DurationScore.red => '🔴',
      _ => '⚪',
    };
  }

  String _progressBar(int current, int total) {
    final filled = total > 0 ? (current / total * 8).round().clamp(0, 8) : 0;
    final empty = 8 - filled;
    return '${'█' * filled}${'░' * empty}';
  }

  String _conditioningLabel(String type) {
    return switch (type) {
      ConditioningType.cold => 'Freddo',
      ConditioningType.heat => 'Caldo',
      ConditioningType.meditation => 'Meditazione',
      _ => type,
    };
  }

  String? _fastingMilestone(double hours) {
    if (hours >= 72) return '72h+ — autofagia profonda e riciclo cellulare avanzato';
    if (hours >= 48) return '48h — picco di autofagia, produzione massima di chetoni';
    if (hours >= 36) return '36h — autofagia attiva, grasso come combustibile primario';
    if (hours >= 24) return '24h — autofagia iniziata, glicogeno esaurito';
    if (hours >= 18) return '18h — chetosi leggera, bruciatura grassi in crescita';
    if (hours >= 16) return '16h — flessibilità metabolica attivata';
    if (hours >= 12) return '12h — transizione metabolica iniziata';
    return null;
  }

  String _nextTrainingDay(String currentType) {
    // Simple day-type rotation suggestion
    return switch (currentType) {
      WorkoutType.strength => 'Suggerimento: giorno di recupero o cardio leggero domani',
      WorkoutType.cardio => 'Suggerimento: pronto per una sessione di forza',
      WorkoutType.power => 'Suggerimento: recupero consigliato — 48h prima della prossima sessione intensa',
      WorkoutType.deload => 'Suggerimento: deload completato — riprendere il volume normale',
      _ => 'Suggerimento: ascolta il tuo corpo per la prossima sessione',
    };
  }

  String _postWorkoutSuggestion(
      WorkoutSession session, List<WorkoutSet> sets) {
    if (sets.isEmpty) return '> Nessun set registrato.';

    final rpeValues = sets.where((s) => s.rpe != null);
    if (rpeValues.isEmpty) return '> Registra l\'RPE per suggerimenti mirati.';

    final avgRpe =
        rpeValues.fold<double>(0, (sum, s) => sum + s.rpe!) / rpeValues.length;

    if (avgRpe >= 9) {
      return '> **Suggerimento:** RPE molto alto (${ avgRpe.toStringAsFixed(1)}). Considera un deload nella prossima sessione.';
    } else if (avgRpe >= 7) {
      return '> **Suggerimento:** Volume in linea con il protocollo (RPE ${avgRpe.toStringAsFixed(1)}). Buon lavoro!';
    } else {
      return '> **Suggerimento:** RPE basso (${avgRpe.toStringAsFixed(1)}). Progressione possibile — considera di aumentare il carico.';
    }
  }
}
