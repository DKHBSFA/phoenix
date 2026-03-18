import 'package:flutter/material.dart';

import '../features/workout/workout_session_screen.dart';
import '../features/fasting/fasting_screen.dart';
import '../features/biomarkers/biomarkers_screen.dart';
import '../features/conditioning/conditioning_screen.dart';
import '../features/coach/coach_screen.dart';
import '../features/progressions/progressions_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/workout/home_screen.dart';
import '../features/assessment/assessment_screen.dart';
import '../features/cardio/cardio_session_screen.dart';
import '../features/hrv/hrv_detail_screen.dart';
import '../features/protocol/protocol_paper_screen.dart';
import '../features/settings/ring_data_screen.dart';
import '../features/settings/ring_settings_screen.dart';

class PhoenixRouter {
  static const home = '/';
  static const workout = '/workout';
  static const training = '/training';
  static const fasting = '/fasting';
  static const biomarkers = '/biomarkers';
  static const conditioning = '/conditioning';
  static const coach = '/coach';
  static const progressions = '/progressions';
  static const onboarding = '/onboarding';
  static const settings = '/settings';
  static const assessment = '/assessment';
  static const cardioSession = '/cardio-session';
  static const hrvDetail = '/hrv-detail';
  static const protocolPaper = '/protocol-paper';
  static const ringSettings = '/ring-settings';
  static const ringData = '/ring-data';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomeScreen());
      case workout:
        return _buildRoute(const WorkoutSessionScreen(), settings: settings);
      case fasting:
        return _buildRoute(const FastingScreen());
      case biomarkers:
        return _buildRoute(const BiomarkersScreen());
      case conditioning:
        return _buildRoute(const ConditioningScreen());
      case coach:
        return _buildRoute(const CoachScreen());
      case progressions:
        return _buildRoute(const ProgressionsScreen());
      case onboarding:
        return _buildRoute(const OnboardingScreen());
      case PhoenixRouter.settings:
        return _buildRoute(const SettingsScreen());
      case assessment:
        return _buildRoute(const AssessmentScreen());
      case cardioSession:
        return _buildRoute(const CardioSessionScreen(), settings: settings);
      case hrvDetail:
        return _buildRoute(const HrvDetailScreen());
      case protocolPaper:
        return _buildRoute(const ProtocolPaperScreen());
      case ringSettings:
        return _buildRoute(const RingSettingsScreen());
      case ringData:
        return _buildRoute(const RingDataScreen());
      default:
        return _buildRoute(const HomeScreen());
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, {RouteSettings? settings}) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
