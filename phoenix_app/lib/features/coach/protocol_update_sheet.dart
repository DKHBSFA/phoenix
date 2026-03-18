import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/database/database.dart';
import '../../core/research/protocol_updater.dart';

/// Bottom sheet for reviewing and approving/rejecting protocol update proposals.
class ProtocolUpdateSheet extends ConsumerWidget {
  const ProtocolUpdateSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.phoenix.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return _UpdatesList(scrollController: scrollController);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }
}

class _UpdatesList extends ConsumerWidget {
  final ScrollController scrollController;

  const _UpdatesList({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final px = context.phoenix;
    final textColor = px.textPrimary;
    final subtitleColor = px.textSecondary;
    final surfaceColor = px.surface;
    final borderColor = px.border;

    final dao = ref.watch(researchFeedDaoProvider);

    return Column(
      children: [
        // Handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aggiornamenti Protocollo',
                style: PhoenixTypography.titleLarge.copyWith(color: textColor),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'Il protocollo non cambia mai automaticamente. '
                'Approva o rifiuta ogni proposta basata sulla ricerca.',
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'Consulta il tuo medico prima di modificare il protocollo.',
                style: PhoenixTypography.caption.copyWith(
                  color: PhoenixColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // Proposals list
        Expanded(
          child: StreamBuilder<List<ResearchFeedData>>(
            stream: dao.watchPendingUpdates(),
            builder: (context, snapshot) {
              final proposals = snapshot.data ?? [];

              if (proposals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: subtitleColor,
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        'Nessuna proposta in sospeso',
                        style: PhoenixTypography.bodyLarge
                            .copyWith(color: textColor),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        'Il protocollo è aggiornato.',
                        style: PhoenixTypography.bodyMedium
                            .copyWith(color: subtitleColor),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                itemCount: proposals.length,
                itemBuilder: (context, index) {
                  final proposal = proposals[index];
                  return _ProposalCard(
                    proposal: proposal,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    onApprove: () async {
                      HapticFeedback.mediumImpact();
                      final updater = ProtocolUpdater(dao);
                      await updater.approveUpdate(proposal.id);
                    },
                    onReject: () async {
                      HapticFeedback.lightImpact();
                      final updater = ProtocolUpdater(dao);
                      await updater.rejectUpdate(proposal.id);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final ResearchFeedData proposal;
  final Color textColor;
  final Color subtitleColor;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ProposalCard({
    required this.proposal,
    required this.textColor,
    required this.subtitleColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: PhoenixColors.warning.withAlpha(60)),
        ),
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Proposal text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: PhoenixColors.warning,
                  size: 20,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    proposal.updateProposal ?? 'Proposta non specificata',
                    style: PhoenixTypography.bodyLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Spacing.smMd),

            // Source paper
            Text(
              'Basato su: ${proposal.title}',
              style: PhoenixTypography.bodyMedium.copyWith(
                color: subtitleColor,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (proposal.keySummary.isNotEmpty) ...[
              const SizedBox(height: Spacing.xs),
              Text(
                proposal.keySummary,
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: subtitleColor,
                ),
              ),
            ],

            const SizedBox(height: Spacing.md),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Rifiuta'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PhoenixColors.error,
                    side: const BorderSide(color: PhoenixColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.smMd),
                FilledButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Approva'),
                  style: FilledButton.styleFrom(
                    backgroundColor: PhoenixColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
