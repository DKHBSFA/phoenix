import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import 'app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final PhoenixDatabase _db;

  SettingsNotifier(this._db) : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final row = await (_db.select(_db.userSettings)..limit(1)).getSingleOrNull();
    if (row != null) {
      state = AppSettings.fromJsonString(row.settingsJson);
    }
  }

  Future<void> _save() async {
    final jsonStr = state.toJsonString();
    final existing =
        await (_db.select(_db.userSettings)..limit(1)).getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.userSettings)
            ..where((s) => s.id.equals(existing.id)))
          .write(UserSettingsCompanion(settingsJson: Value(jsonStr)));
    } else {
      await _db.into(_db.userSettings).insert(UserSettingsCompanion.insert(
            createdAt: DateTime.now(),
            settingsJson: Value(jsonStr),
          ));
    }
  }

  Future<void> update(AppSettings Function(AppSettings) updater) async {
    state = updater(state);
    await _save();
  }

  Future<void> setThemeMode(String mode) => update((s) => s.copyWith(themeMode: mode));
  Future<void> setCoachExplanation(bool v) => update((s) => s.copyWith(coachExplanation: v));
  Future<void> setMetronome(bool v) => update((s) => s.copyWith(metronome: v));
  Future<void> setHapticFeedback(bool v) => update((s) => s.copyWith(hapticFeedback: v));
  Future<void> setCoachVoiceEnabled(bool v) => update((s) => s.copyWith(coachVoiceEnabled: v));
  Future<void> setCoachVolume(double v) => update((s) => s.copyWith(coachVolume: v));
  Future<void> setRpeExplained(bool v) => update((s) => s.copyWith(rpeExplained: v));
  Future<void> setWorkoutReminderEnabled(bool v) => update((s) => s.copyWith(workoutReminderEnabled: v));
  Future<void> setWorkoutReminderTime(String v) {
    if (!_isValidTimeFormat(v)) return Future.value();
    return update((s) => s.copyWith(workoutReminderTime: v));
  }
  Future<void> setConditioningReminderEnabled(bool v) => update((s) => s.copyWith(conditioningReminderEnabled: v));
  Future<void> setConditioningReminderTime(String v) {
    if (!_isValidTimeFormat(v)) return Future.value();
    return update((s) => s.copyWith(conditioningReminderTime: v));
  }

  static final _timeRegex = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
  static bool _isValidTimeFormat(String v) => _timeRegex.hasMatch(v);
  Future<void> setInactivityReminderEnabled(bool v) => update((s) => s.copyWith(inactivityReminderEnabled: v));
  Future<void> setDisclaimerAccepted() => update((s) => s.copyWith(disclaimerAcceptedAt: DateTime.now().toIso8601String()));
  Future<void> setAiCoachEnabled(bool v) => update((s) => s.copyWith(aiCoachEnabled: v));
  Future<void> setModelVersion(String? v) => update((s) => s.copyWith(modelVersion: v));
  Future<void> setLastBenchmarkTokS(double? v) => update((s) => s.copyWith(lastBenchmarkTokS: v));

  Future<void> setSleepEnvironmentJson(String? v) => update((s) => s.copyWith(sleepEnvironmentJson: v));

  // Week 0 familiarization
  Future<void> setWeek0Active(bool v) => update((s) => s.copyWith(week0Active: v));
  Future<void> setWeek0Completed() => update((s) => s.copyWith(
        week0Active: false,
        week0CompletedAt: DateTime.now().toIso8601String(),
      ));
  Future<void> setWeek0Skipped() => update((s) => s.copyWith(
        week0Active: false,
        week0Skipped: true,
      ));

  Future<void> setPhysicalLimitations({
    required String? limitationsJson,
    required List<int> excludedIds,
    required String? modifiedJson,
  }) =>
      update((s) => s.copyWith(
            physicalLimitationsJson: limitationsJson,
            excludedExerciseIds: excludedIds,
            modifiedExercisesJson: modifiedJson,
            assessmentDate: DateTime.now().toIso8601String(),
          ));

  /// Save full onboarding assessment: limitations, chat, training program, reassessment date.
  Future<void> saveOnboardingAssessment({
    required String? limitationsJson,
    required List<int> excludedIds,
    required String? chatTranscriptJson,
    required String? levelOverridesJson,
    required String? trainingProgramNotes,
    required String generatedBy,
  }) {
    final now = DateTime.now();
    final nextReassessment = DateTime(now.year, now.month + 3, now.day);
    return update((s) => s.copyWith(
          physicalLimitationsJson: limitationsJson,
          excludedExerciseIds: excludedIds,
          assessmentDate: now.toIso8601String(),
          chatTranscriptJson: chatTranscriptJson,
          nextReassessmentDate: nextReassessment.toIso8601String(),
          levelOverridesJson: levelOverridesJson,
          trainingProgramNotes: trainingProgramNotes,
          trainingProgramGeneratedBy: generatedBy,
        ));
  }
}
