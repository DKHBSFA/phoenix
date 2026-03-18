import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'app/phoenix_theme.dart';
import 'app/theme.dart';
import 'app/router.dart';
import 'app/providers.dart';
import 'core/background/background_tasks.dart';
import 'core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Italian date formatting
  await initializeDateFormatting('it_IT', null);

  // Set up TDesign with Italian resources and multi-theme support.
  // needMultiTheme = true makes TDTheme.of(context) read from
  // Theme.of(context).extensions[TDThemeData] instead of a global static,
  // so our brutalist B/W colors (set in phoenix_theme.dart) are picked up
  // by TDButton, TDLoading, etc.
  TDTheme.needMultiTheme();
  TDTheme.setResourceBuilder((_) => PhoenixResourceDelegate());

  final notifications = NotificationService();
  await notifications.init();
  await notifications.requestPermissions();

  if (Platform.isAndroid || Platform.isIOS) {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    await Workmanager().registerPeriodicTask(
      'phoenix-inactivity-check',
      kInactivityCheckTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(networkType: NetworkType.not_required),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );

    await Workmanager().registerPeriodicTask(
      'phoenix-conditioning-reminder',
      kConditioningReminderTask,
      frequency: const Duration(hours: 12),
      constraints: Constraints(networkType: NetworkType.not_required),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  runApp(
    const ProviderScope(
      child: PhoenixApp(),
    ),
  );
}

class PhoenixApp extends ConsumerStatefulWidget {
  const PhoenixApp({super.key});

  @override
  ConsumerState<PhoenixApp> createState() => _PhoenixAppState();
}

class _PhoenixAppState extends ConsumerState<PhoenixApp> {
  @override
  void initState() {
    super.initState();
    // Init TTS coach + Ring service after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coachVoiceProvider).init();
      // Initialize BLE callbacks for smart ring (lazy — no scan until user triggers)
      ref.read(ringServiceProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final profile = ref.watch(userProfileProvider);

    // Determine initial route based on onboarding state
    final initialRoute = profile.when(
      data: (p) => p?.onboardingComplete == true
          ? PhoenixRouter.home
          : PhoenixRouter.onboarding,
      loading: () => PhoenixRouter.home, // will redirect after load
      error: (_, __) => PhoenixRouter.onboarding,
    );

    return MaterialApp(
      title: 'Phoenix',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.lightTheme,
      darkTheme: PhoenixTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: initialRoute,
      onGenerateRoute: PhoenixRouter.generateRoute,
    );
  }
}
