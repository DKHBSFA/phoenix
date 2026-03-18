import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppSettings {
  final bool coachExplanation;
  final bool metronome;
  final bool hapticFeedback;
  final String themeMode; // 'system' / 'light' / 'dark'
  final bool coachVoiceEnabled;
  final double coachVolume;
  final bool rpeExplained;
  final bool workoutReminderEnabled;
  final String workoutReminderTime; // 'HH:mm' formato 24h
  final bool conditioningReminderEnabled;
  final String conditioningReminderTime; // 'HH:mm' formato 24h
  final bool inactivityReminderEnabled;

  // Medical disclaimer
  final String? disclaimerAcceptedAt; // ISO 8601 timestamp

  // AI Coach
  final bool aiCoachEnabled;
  final String? modelVersion;
  final double? lastBenchmarkTokS;

  // Physical limitations (from onboarding coach assessment)
  final String? physicalLimitationsJson; // JSON array of {area, type, severity}
  final List<int> excludedExerciseIds;
  final String? modifiedExercisesJson; // JSON array of {exercise_id, note, max_level}
  final String? assessmentDate; // ISO 8601
  final String? chatTranscriptJson; // JSON array of assessment chat messages
  final String? nextReassessmentDate; // ISO 8601 — 3 months after assessment

  // Training program (AI-generated)
  final String? levelOverridesJson; // JSON map: {"hinge": 1, "squat": 1}
  final String? trainingProgramNotes; // Free-text notes from AI
  final String? trainingProgramGeneratedBy; // "llm" or "template"

  // Sleep environment
  final String? sleepEnvironmentJson; // SleepEnvironment serialized

  // Week 0 familiarization
  final bool week0Active;
  final String? week0CompletedAt; // ISO 8601
  final bool week0Skipped;

  const AppSettings({
    this.coachExplanation = true,
    this.metronome = false,
    this.hapticFeedback = true,
    this.themeMode = 'system',
    this.coachVoiceEnabled = true,
    this.coachVolume = 0.8,
    this.rpeExplained = false,
    this.workoutReminderEnabled = false,
    this.workoutReminderTime = '07:00',
    this.conditioningReminderEnabled = false,
    this.conditioningReminderTime = '20:00',
    this.inactivityReminderEnabled = true,
    this.disclaimerAcceptedAt,
    this.aiCoachEnabled = true,
    this.modelVersion,
    this.lastBenchmarkTokS,
    this.physicalLimitationsJson,
    this.excludedExerciseIds = const [],
    this.modifiedExercisesJson,
    this.assessmentDate,
    this.chatTranscriptJson,
    this.nextReassessmentDate,
    this.levelOverridesJson,
    this.trainingProgramNotes,
    this.trainingProgramGeneratedBy,
    this.sleepEnvironmentJson,
    this.week0Active = false,
    this.week0CompletedAt,
    this.week0Skipped = false,
  });

  /// Whether the medical disclaimer is currently accepted (within 90 days).
  bool get isDisclaimerValid {
    if (disclaimerAcceptedAt == null) return false;
    final accepted = DateTime.tryParse(disclaimerAcceptedAt!);
    if (accepted == null) return false;
    return accepted.add(const Duration(days: 90)).isAfter(DateTime.now());
  }

  AppSettings copyWith({
    bool? coachExplanation,
    bool? metronome,
    bool? hapticFeedback,
    String? themeMode,
    bool? coachVoiceEnabled,
    double? coachVolume,
    bool? rpeExplained,
    bool? workoutReminderEnabled,
    String? workoutReminderTime,
    bool? conditioningReminderEnabled,
    String? conditioningReminderTime,
    bool? inactivityReminderEnabled,
    String? disclaimerAcceptedAt,
    bool? aiCoachEnabled,
    String? modelVersion,
    double? lastBenchmarkTokS,
    String? physicalLimitationsJson,
    List<int>? excludedExerciseIds,
    String? modifiedExercisesJson,
    String? assessmentDate,
    String? chatTranscriptJson,
    String? nextReassessmentDate,
    String? levelOverridesJson,
    String? trainingProgramNotes,
    String? trainingProgramGeneratedBy,
    String? sleepEnvironmentJson,
    bool? week0Active,
    String? week0CompletedAt,
    bool? week0Skipped,
  }) {
    return AppSettings(
      coachExplanation: coachExplanation ?? this.coachExplanation,
      metronome: metronome ?? this.metronome,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      themeMode: themeMode ?? this.themeMode,
      coachVoiceEnabled: coachVoiceEnabled ?? this.coachVoiceEnabled,
      coachVolume: coachVolume ?? this.coachVolume,
      rpeExplained: rpeExplained ?? this.rpeExplained,
      workoutReminderEnabled: workoutReminderEnabled ?? this.workoutReminderEnabled,
      workoutReminderTime: workoutReminderTime ?? this.workoutReminderTime,
      conditioningReminderEnabled: conditioningReminderEnabled ?? this.conditioningReminderEnabled,
      conditioningReminderTime: conditioningReminderTime ?? this.conditioningReminderTime,
      inactivityReminderEnabled: inactivityReminderEnabled ?? this.inactivityReminderEnabled,
      disclaimerAcceptedAt: disclaimerAcceptedAt ?? this.disclaimerAcceptedAt,
      aiCoachEnabled: aiCoachEnabled ?? this.aiCoachEnabled,
      modelVersion: modelVersion ?? this.modelVersion,
      lastBenchmarkTokS: lastBenchmarkTokS ?? this.lastBenchmarkTokS,
      physicalLimitationsJson: physicalLimitationsJson ?? this.physicalLimitationsJson,
      excludedExerciseIds: excludedExerciseIds ?? this.excludedExerciseIds,
      modifiedExercisesJson: modifiedExercisesJson ?? this.modifiedExercisesJson,
      assessmentDate: assessmentDate ?? this.assessmentDate,
      chatTranscriptJson: chatTranscriptJson ?? this.chatTranscriptJson,
      nextReassessmentDate: nextReassessmentDate ?? this.nextReassessmentDate,
      levelOverridesJson: levelOverridesJson ?? this.levelOverridesJson,
      trainingProgramNotes: trainingProgramNotes ?? this.trainingProgramNotes,
      trainingProgramGeneratedBy: trainingProgramGeneratedBy ?? this.trainingProgramGeneratedBy,
      sleepEnvironmentJson: sleepEnvironmentJson ?? this.sleepEnvironmentJson,
      week0Active: week0Active ?? this.week0Active,
      week0CompletedAt: week0CompletedAt ?? this.week0CompletedAt,
      week0Skipped: week0Skipped ?? this.week0Skipped,
    );
  }

  Map<String, dynamic> toJson() => {
        'coachExplanation': coachExplanation,
        'metronome': metronome,
        'hapticFeedback': hapticFeedback,
        'themeMode': themeMode,
        'coachVoiceEnabled': coachVoiceEnabled,
        'coachVolume': coachVolume,
        'rpeExplained': rpeExplained,
        'workoutReminderEnabled': workoutReminderEnabled,
        'workoutReminderTime': workoutReminderTime,
        'conditioningReminderEnabled': conditioningReminderEnabled,
        'conditioningReminderTime': conditioningReminderTime,
        'inactivityReminderEnabled': inactivityReminderEnabled,
        'disclaimerAcceptedAt': disclaimerAcceptedAt,
        'aiCoachEnabled': aiCoachEnabled,
        'modelVersion': modelVersion,
        'lastBenchmarkTokS': lastBenchmarkTokS,
        'physicalLimitationsJson': physicalLimitationsJson,
        'excludedExerciseIds': excludedExerciseIds,
        'modifiedExercisesJson': modifiedExercisesJson,
        'assessmentDate': assessmentDate,
        'chatTranscriptJson': chatTranscriptJson,
        'nextReassessmentDate': nextReassessmentDate,
        'levelOverridesJson': levelOverridesJson,
        'trainingProgramNotes': trainingProgramNotes,
        'trainingProgramGeneratedBy': trainingProgramGeneratedBy,
        'sleepEnvironmentJson': sleepEnvironmentJson,
        'week0Active': week0Active,
        'week0CompletedAt': week0CompletedAt,
        'week0Skipped': week0Skipped,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      coachExplanation: json['coachExplanation'] as bool? ?? true,
      metronome: json['metronome'] as bool? ?? false,
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      themeMode: json['themeMode'] as String? ?? 'system',
      coachVoiceEnabled: json['coachVoiceEnabled'] as bool? ?? true,
      coachVolume: (json['coachVolume'] as num?)?.toDouble() ?? 0.8,
      rpeExplained: json['rpeExplained'] as bool? ?? false,
      workoutReminderEnabled: json['workoutReminderEnabled'] as bool? ?? false,
      workoutReminderTime: json['workoutReminderTime'] as String? ?? '07:00',
      conditioningReminderEnabled: json['conditioningReminderEnabled'] as bool? ?? false,
      conditioningReminderTime: json['conditioningReminderTime'] as String? ?? '20:00',
      inactivityReminderEnabled: json['inactivityReminderEnabled'] as bool? ?? true,
      disclaimerAcceptedAt: json['disclaimerAcceptedAt'] as String?,
      aiCoachEnabled: json['aiCoachEnabled'] as bool? ?? true,
      modelVersion: json['modelVersion'] as String?,
      lastBenchmarkTokS: (json['lastBenchmarkTokS'] as num?)?.toDouble(),
      physicalLimitationsJson: json['physicalLimitationsJson'] as String?,
      excludedExerciseIds: (json['excludedExerciseIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      modifiedExercisesJson: json['modifiedExercisesJson'] as String?,
      assessmentDate: json['assessmentDate'] as String?,
      chatTranscriptJson: json['chatTranscriptJson'] as String?,
      nextReassessmentDate: json['nextReassessmentDate'] as String?,
      levelOverridesJson: json['levelOverridesJson'] as String?,
      trainingProgramNotes: json['trainingProgramNotes'] as String?,
      trainingProgramGeneratedBy: json['trainingProgramGeneratedBy'] as String?,
      sleepEnvironmentJson: json['sleepEnvironmentJson'] as String?,
      week0Active: json['week0Active'] as bool? ?? false,
      week0CompletedAt: json['week0CompletedAt'] as String?,
      week0Skipped: json['week0Skipped'] as bool? ?? false,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory AppSettings.fromJsonString(String jsonStr) {
    try {
      return AppSettings.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('AppSettings.fromJsonString parse error');
      return const AppSettings();
    }
  }
}
