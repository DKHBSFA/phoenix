import 'package:home_widget/home_widget.dart';

import '../../core/models/daily_protocol.dart';

/// Updates home screen widget data from DB.
///
/// Called after sync, after protocol completion, and periodically via WorkManager.
class PhoenixHomeWidget {
  static const _appGroupId = 'group.phoenix.widget';
  static const _androidWidgetName = 'PhoenixWidgetProvider';
  static const _iosWidgetName = 'PhoenixWidget';

  /// Update all widget data from current DB state.
  static Future<void> update({
    required DailyProtocol protocol,
    int? steps,
    int? calories,
    String? sleepSummary,
    double? hrvMs,
    String? recovery,
    int? hrRest,
    double? temp,
    String? nextStep,
    String? levelName,
    int? levelNumber,
  }) async {
    await HomeWidget.setAppGroupId(_appGroupId);

    // Protocol elements
    await HomeWidget.saveWidgetData('phoenix_protocol_done', protocol.completedCount);
    await HomeWidget.saveWidgetData('phoenix_protocol_total', 6);

    await HomeWidget.saveWidgetData('phoenix_sleep_done', protocol.sleepLogged);
    await HomeWidget.saveWidgetData(
      'phoenix_fasting_done',
      protocol.fastingStatus.status != ActivityStatus.notStarted,
    );
    await HomeWidget.saveWidgetData('phoenix_training_done', protocol.workoutCompleted);
    await HomeWidget.saveWidgetData('phoenix_cold_done', protocol.coldDone);
    await HomeWidget.saveWidgetData('phoenix_meditation_done', protocol.meditationDone);
    await HomeWidget.saveWidgetData('phoenix_nutrition_done', protocol.nutritionProgress.mealsLogged >= 3);

    // Ring data
    if (steps != null) await HomeWidget.saveWidgetData('phoenix_steps', steps);
    if (calories != null) await HomeWidget.saveWidgetData('phoenix_calories', calories);
    if (sleepSummary != null) await HomeWidget.saveWidgetData('phoenix_sleep_summary', sleepSummary);
    if (hrvMs != null) await HomeWidget.saveWidgetData('phoenix_hrv_ms', hrvMs);
    if (recovery != null) await HomeWidget.saveWidgetData('phoenix_recovery', recovery);
    if (hrRest != null) await HomeWidget.saveWidgetData('phoenix_hr_rest', hrRest);
    if (temp != null) await HomeWidget.saveWidgetData('phoenix_temp', temp);
    if (nextStep != null) await HomeWidget.saveWidgetData('phoenix_next_step', nextStep);
    if (levelName != null) await HomeWidget.saveWidgetData('phoenix_level_name', levelName);
    if (levelNumber != null) await HomeWidget.saveWidgetData('phoenix_level_number', levelNumber);

    // Trigger widget update on both platforms
    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      iOSName: _iosWidgetName,
    );
  }
}
