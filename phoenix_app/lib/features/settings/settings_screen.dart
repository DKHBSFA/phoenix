import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/notifications/notification_scheduler.dart';
import '../../shared/widgets/phoenix_switch_tile.dart';
import '../coach/widgets/model_download_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final profileAsync = ref.watch(userProfileProvider);
    final subtitleColor = context.phoenix.textSecondary;

    return Scaffold(
      appBar: const TDNavBar(title: 'Impostazioni'),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
        children: [
          // ── Profilo ──
          _SectionHeader('Profilo'),
          profileAsync.when(
            data: (profile) {
              if (profile == null) {
                return const Padding(
                  padding: EdgeInsets.all(Spacing.screenH),
                  child: Text('Nessun profilo'),
                );
              }
              final age = DateTime.now().year - profile.birthYear;
              final tierLabel = switch (profile.trainingTier) {
                'beginner' => 'Principiante',
                'intermediate' => 'Intermedio',
                'advanced' => 'Avanzato',
                _ => profile.trainingTier,
              };
              final eqLabel = switch (profile.equipment) {
                'gym' => 'Palestra',
                'home' => 'Casa',
                'bodyweight' => 'Corpo libero',
                _ => profile.equipment,
              };

              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH, vertical: Spacing.sm),
                padding: const EdgeInsets.all(CardTokens.padding),
                decoration: BoxDecoration(
                  color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
                  borderRadius: BorderRadius.circular(CardTokens.borderRadius),
                  border: Border.all(
                    color: context.phoenix.border,
                  ),
                  boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
                ),
                child: Column(
                  children: [
                    _InfoRow('Livello', tierLabel),
                    _InfoRow('Attrezzatura', eqLabel),
                    _InfoRow('Peso', '${profile.weightKg.toStringAsFixed(1)} kg'),
                    _InfoRow('Età', '$age anni'),
                  ],
                ),
              );
            },
            loading: () => Center(child: TDLoading(size: TDLoadingSize.medium)),
            error: (_, __) => const Padding(
              padding: EdgeInsets.all(Spacing.screenH),
              child: Text('Errore nel caricamento profilo'),
            ),
          ),

          // ── Allenamento ──
          _SectionHeader('Allenamento'),
          PhoenixSwitchTile(
            title: 'Spiegazione coach prima dell\'esercizio',
            subtitle: settings.coachExplanation
                ? 'Coach legge istruzioni + countdown 5s'
                : 'Parte subito con countdown 3s',
            value: settings.coachExplanation,
            onChanged: (v) => settingsNotifier.setCoachExplanation(v),
          ),
          PhoenixSwitchTile(
            title: 'Metronomo durante le serie',
            value: settings.metronome,
            onChanged: (v) => settingsNotifier.setMetronome(v),
          ),
          PhoenixSwitchTile(
            title: 'Vibrazione haptic completamento serie',
            value: settings.hapticFeedback,
            onChanged: (v) => settingsNotifier.setHapticFeedback(v),
          ),

          // ── Aspetto ──
          _SectionHeader('Aspetto'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'system', label: Text('Sistema')),
                ButtonSegment(value: 'light', label: Text('Chiaro')),
                ButtonSegment(value: 'dark', label: Text('Scuro')),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) {
                HapticFeedback.lightImpact();
                settingsNotifier.setThemeMode(s.first);
              },
            ),
          ),
          const SizedBox(height: Spacing.md),

          // ── Coach ──
          _SectionHeader('Coach'),
          PhoenixSwitchTile(
            title: 'Coach vocale attivo',
            value: settings.coachVoiceEnabled,
            onChanged: (v) => settingsNotifier.setCoachVoiceEnabled(v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: Row(
              children: [
                Text('Volume coach', style: TextStyle(color: subtitleColor)),
                Expanded(
                  child: Slider(
                    value: settings.coachVolume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: '${(settings.coachVolume * 100).round()}%',
                    onChanged: settings.coachVoiceEnabled
                        ? (v) => settingsNotifier.setCoachVolume(v)
                        : null,
                  ),
                ),
              ],
            ),
          ),

          // ── AI Coach ──
          _SectionHeader('AI Coach'),
          PhoenixSwitchTile(
            title: 'Coach AI attivo',
            subtitle: settings.aiCoachEnabled
                ? settings.lastBenchmarkTokS != null
                    ? '${settings.lastBenchmarkTokS!.toStringAsFixed(1)} tok/s'
                    : 'Abilitato'
                : 'Disattivato — usa report template',
            value: settings.aiCoachEnabled,
            onChanged: (v) => settingsNotifier.setAiCoachEnabled(v),
          ),
          if (settings.aiCoachEnabled) const ModelDownloadCard(),

          // ── Notifiche ──
          _SectionHeader('Notifiche'),
          PhoenixSwitchTile(
            title: 'Promemoria allenamento',
            subtitle: settings.workoutReminderEnabled
                ? 'Ogni giorno alle ${settings.workoutReminderTime}'
                : 'Disattivato',
            value: settings.workoutReminderEnabled,
            onChanged: (v) {
              settingsNotifier.setWorkoutReminderEnabled(v);
              final scheduler = NotificationScheduler(
                ref.read(notificationServiceProvider),
                ref.read(workoutDaoProvider),
                ref.read(conditioningDaoProvider),
              );
              if (v) {
                scheduler.scheduleWorkoutReminder(settings.workoutReminderTime);
              } else {
                scheduler.cancelWorkoutReminder();
              }
            },
          ),
          if (settings.workoutReminderEnabled)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Orario promemoria'),
              trailing: Text(settings.workoutReminderTime),
              onTap: () async {
                final parts = settings.workoutReminderTime.split(':');
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(parts[0]),
                    minute: int.parse(parts[1]),
                  ),
                );
                if (picked != null) {
                  final time =
                      '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                  settingsNotifier.setWorkoutReminderTime(time);
                  final scheduler = NotificationScheduler(
                    ref.read(notificationServiceProvider),
                    ref.read(workoutDaoProvider),
                    ref.read(conditioningDaoProvider),
                  );
                  scheduler.scheduleWorkoutReminder(time);
                }
              },
            ),
          PhoenixSwitchTile(
            title: 'Promemoria condizionamento serale',
            subtitle: settings.conditioningReminderEnabled
                ? 'Alle ${settings.conditioningReminderTime} se non hai fatto sessioni'
                : 'Disattivato',
            value: settings.conditioningReminderEnabled,
            onChanged: (v) => settingsNotifier.setConditioningReminderEnabled(v),
          ),
          PhoenixSwitchTile(
            title: 'Avviso inattivita (2+ giorni)',
            value: settings.inactivityReminderEnabled,
            onChanged: (v) => settingsNotifier.setInactivityReminderEnabled(v),
          ),

          // ── Smart Ring ──
          _SectionHeader('Smart Ring'),
          _StitchListTile(
            icon: Icons.bluetooth,
            iconBgColor: const Color(0xFF1565C0).withAlpha(30),
            iconColor: const Color(0xFF1565C0),
            title: 'Colmi R10',
            subtitle: 'Connetti anello per dati automatici',
            onTap: () {
              Navigator.pushNamed(context, '/ring-settings');
            },
          ),

          // ── Protocollo ──
          _SectionHeader('Protocollo'),
          _StitchListTile(
            icon: Icons.menu_book,
            iconBgColor: PhoenixColors.darkOverlay,
            iconColor: PhoenixColors.darkTextSecondary,
            title: 'Leggi il Protocollo Phoenix',
            subtitle: '120+ studi · 6 capitoli',
            onTap: () {
              Navigator.pushNamed(context, '/protocol-paper');
            },
          ),

          // ── Dati ──
          _SectionHeader('Dati'),
          _StitchListTile(
            icon: Icons.file_download_outlined,
            iconBgColor: PhoenixColors.darkOverlay,
            iconColor: PhoenixColors.darkTextSecondary,
            title: 'Esporta dati',
            onTap: () {
              TDToast.showText('Funzione in arrivo', context: context);
            },
          ),
          _StitchListTile(
            icon: Icons.restart_alt,
            iconBgColor: PhoenixColors.errorSurface,
            iconColor: PhoenixColors.error,
            title: 'Ripristina onboarding',
            subtitle: 'Debug',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Ripristina onboarding?'),
                  content: const Text(
                      'Il profilo verrà mantenuto ma l\'onboarding si riaprirà al prossimo avvio.'),
                  actions: [
                    TDButton(
                      text: 'Annulla',
                      type: TDButtonType.text,
                      theme: TDButtonTheme.defaultTheme,
                      onTap: () => Navigator.pop(ctx, false),
                    ),
                    TDButton(
                      text: 'Ripristina',
                      type: TDButtonType.fill,
                      theme: TDButtonTheme.primary,
                      size: TDButtonSize.large,
                      onTap: () => Navigator.pop(ctx, true),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                final dao = ref.read(userProfileDaoProvider);
                final profile = await dao.getProfile();
                if (profile != null) {
                  await dao.saveProfile(
                    const UserProfilesCompanion(
                      onboardingComplete: Value(false),
                    ),
                  );
                }
                if (context.mounted) {
                  TDToast.showText('Onboarding ripristinato', context: context);
                }
              }
            },
          ),

          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }
}

/// Stitch pattern 3.20: Section header — uppercase, tracking-wider, slate-400.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Spacing.lg, Spacing.lg, Spacing.lg, Spacing.sm),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.phoenix.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.phoenix.textSecondary,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Stitch pattern 3.20: Settings list item with colored icon background.
class _StitchListTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _StitchListTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: context.phoenix.textSecondary,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: context.phoenix.textTertiary,
      ),
      onTap: onTap,
    );
  }
}
