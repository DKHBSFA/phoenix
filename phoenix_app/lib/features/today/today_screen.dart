import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import 'widgets/assessment_banner.dart';
import 'widgets/reassessment_banner.dart';
import 'widgets/protocol_progress_bar.dart';
import 'widgets/training_card.dart';
import 'widgets/nutrition_card.dart';
import 'widgets/fasting_card.dart';
import 'widgets/cold_card.dart';
import 'widgets/meditation_card.dart';
import 'widgets/sleep_card.dart';
import 'widgets/coach_message.dart';
import 'widgets/week0_banner.dart';
import 'widgets/hrv_morning_card.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocolAsync = ref.watch(dailyProtocolProvider);
    final p = context.phoenix;
    final textColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return SafeArea(
      child: RefreshIndicator(
        color: textColor,
        onRefresh: () async {
          ref.invalidate(dailyProtocolProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.screenH, Spacing.screenTop, Spacing.screenH, 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phoenix',
                          style: PhoenixTypography.displayLarge.copyWith(
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          DateFormat('EEEE d MMMM', 'it_IT').format(DateTime.now()),
                          style: PhoenixTypography.bodyLarge.copyWith(
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, size: 24, color: subtitleColor),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, PhoenixRouter.settings);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Protocol progress
            SliverToBoxAdapter(
              child: protocolAsync.when(
                data: (protocol) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.screenH, Spacing.lg, Spacing.screenH, Spacing.sm,
                  ),
                  child: ProtocolProgressBar(
                    completed: protocol.completedCount,
                    total: protocol.totalCount,
                  ),
                ),
                loading: () => const SizedBox(height: 48),
                error: (_, __) => const SizedBox(height: 48),
              ),
            ),

            // Protocol cards
            protocolAsync.when(
              data: (protocol) {
                final ringSummaryAsync = ref.watch(ringLastNightSleepProvider);
                final ringSummary = ringSummaryAsync.valueOrNull;
                return SliverList(
                  delegate: SliverChildListDelegate([
                    const Week0Banner(),
                    TrainingCard(
                      workout: protocol.todayWorkout,
                      completed: protocol.workoutCompleted,
                    ),
                    NutritionCard(progress: protocol.nutritionProgress),
                    FastingCard(status: protocol.fastingStatus),
                    ColdCard(
                      stats: protocol.coldStats,
                      completed: protocol.coldDone,
                    ),
                    MeditationCard(completed: protocol.meditationDone),
                    SleepCard(
                      data: protocol.lastNightSleep,
                      logged: protocol.sleepLogged,
                      ringSummary: ringSummary,
                    ),
                    // HRV morning card: only shown when ring is paired and HRV pending
                    if (ref.watch(pairedRingProvider).valueOrNull != null)
                      const HrvMorningCard(),
                    CoachMessage(message: protocol.coachMessage),
                    const AssessmentBanner(),
                    const ReassessmentBanner(),
                    const SizedBox(height: Spacing.xxl),
                  ]),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: PhoenixColors.darkTextPrimary),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.screenH),
                  child: Text(
                    'Errore nel caricamento del protocollo',
                    style: PhoenixTypography.bodyLarge.copyWith(
                      color: PhoenixColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
