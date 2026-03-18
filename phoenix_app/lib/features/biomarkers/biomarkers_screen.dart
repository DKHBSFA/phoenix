import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../shared/widgets/phoenix_pill_tabs.dart';
import 'biomarker_dashboard_tab.dart';
import 'blood_panel_form.dart';
import 'phenoage_tab.dart';
import 'weight_tab.dart';

class BiomarkersScreen extends ConsumerStatefulWidget {
  const BiomarkersScreen({super.key});

  @override
  ConsumerState<BiomarkersScreen> createState() => _BiomarkersScreenState();
}

class _BiomarkersScreenState extends ConsumerState<BiomarkersScreen> {
  int _selectedIndex = 0;

  static const _tabs = [
    PhoenixPillTab(label: 'Home', icon: Icons.dashboard),
    PhoenixPillTab(label: 'Sangue', icon: Icons.bloodtype),
    PhoenixPillTab(label: 'Peso', icon: Icons.monitor_weight_outlined),
    PhoenixPillTab(label: 'PhenoAge', icon: Icons.biotech),
  ];

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(biomarkerDaoProvider);

    final profile = ref.watch(userProfileProvider).valueOrNull;
    final userAge = profile != null
        ? DateTime.now().year - profile.birthYear
        : null;

    final bodies = [
      BiomarkerDashboardTab(
        dao: dao,
        llmEngine: ref.watch(llmEngineProvider),
        userAge: userAge,
        userSex: profile?.sex ?? 'male',
      ),
      _BloodPanelList(dao: dao),
      WeightTab(dao: dao),
      PhenoAgeTab(dao: dao),
    ];

    return Scaffold(
      appBar: const TDNavBar(title: 'Biomarker', useDefaultBack: false),
      body: Column(
        children: [
          const SizedBox(height: Spacing.sm),
          PhoenixPillTabs(
            tabs: _tabs,
            selectedIndex: _selectedIndex,
            onChanged: (i) => setState(() => _selectedIndex = i),
          ),
          const SizedBox(height: Spacing.sm),
          Expanded(child: bodies[_selectedIndex]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BloodPanelForm()),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bloodtype),
              title: const Text('Analisi del sangue'),
              subtitle: const Text('Panel completo con alert automatici'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BloodPanelForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: const Text('Peso'),
              subtitle: const Text('Registra peso rapido'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() => _selectedIndex = 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodPanelList extends StatelessWidget {
  final dynamic dao;
  const _BloodPanelList({required this.dao});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dao.watchByType('blood_panel'),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bloodtype,
                    size: 64,
                    color: context.phoenix.textQuaternary),
                const SizedBox(height: 16),
                Text('Nessun esame del sangue',
                    style: TextStyle(
                      color: context.phoenix.textSecondary,
                    )),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BloodPanelForm()),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Inserisci analisi'),
                ),
              ],
            ),
          );
        }

        final entries = snapshot.data as List;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final entry = entries[i];
            final date = entry.date as DateTime;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.bloodtype),
                title: Text(
                    'Panel del ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      },
    );
  }
}
