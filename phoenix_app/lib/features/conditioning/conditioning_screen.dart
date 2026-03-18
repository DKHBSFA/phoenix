import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../shared/widgets/phoenix_pill_tabs.dart';
import 'cold_tab.dart';
import 'heat_tab.dart';
import 'meditation_tab.dart';
import 'sleep_tab.dart';

class ConditioningScreen extends ConsumerStatefulWidget {
  const ConditioningScreen({super.key});

  @override
  ConsumerState<ConditioningScreen> createState() => _ConditioningScreenState();
}

class _ConditioningScreenState extends ConsumerState<ConditioningScreen> {
  int _selectedIndex = 0;

  static const _tabs = [
    PhoenixPillTab(label: 'Freddo', icon: Icons.ac_unit),
    PhoenixPillTab(label: 'Caldo', icon: Icons.whatshot),
    PhoenixPillTab(label: 'Medita', icon: Icons.self_improvement),
    PhoenixPillTab(label: 'Sonno', icon: Icons.bedtime),
  ];

  static const _bodies = [
    ColdTab(),
    HeatTab(),
    MeditationTab(),
    SleepTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TDNavBar(title: 'Condizionamento', useDefaultBack: false),
      body: Column(
        children: [
          const SizedBox(height: Spacing.sm),
          PhoenixPillTabs(
            tabs: _tabs,
            selectedIndex: _selectedIndex,
            onChanged: (i) => setState(() => _selectedIndex = i),
          ),
          const SizedBox(height: Spacing.sm),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _bodies,
            ),
          ),
        ],
      ),
    );
  }
}
