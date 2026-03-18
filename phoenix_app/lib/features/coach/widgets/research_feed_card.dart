import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/design_tokens.dart';
import '../../../app/providers.dart';
import '../../../core/database/database.dart';

/// Card showing recent research papers found by the nightly fetcher.
/// Appears in the Coach screen between report chips and chat.
class ResearchFeedCard extends ConsumerWidget {
  const ResearchFeedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final px = context.phoenix;
    final textColor = px.textPrimary;
    final subtitleColor = px.textSecondary;
    final surfaceColor = px.surface;
    final borderColor = px.border;

    final dao = ref.watch(researchFeedDaoProvider);

    return StreamBuilder<List<ResearchFeedData>>(
      stream: dao.watchUnread(),
      builder: (context, snapshot) {
        final unread = snapshot.data ?? [];
        if (unread.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.sm,
          ),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showResearchSheet(context, ref);
            },
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.all(Spacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PhoenixColors.darkTextSecondary.withAlpha(31),
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.science,
                        color: PhoenixColors.darkTextSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.smMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${unread.length} nuovi studi',
                          style: PhoenixTypography.bodyLarge.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Ricerca automatica — tap per leggere',
                          style: PhoenixTypography.bodyMedium
                              .copyWith(color: subtitleColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: PhoenixColors.darkTextSecondary,
                      borderRadius: BorderRadius.circular(Radii.full),
                    ),
                    child: Text(
                      '${unread.length}',
                      style: PhoenixTypography.caption.copyWith(
                        color: PhoenixColors.darkTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showResearchSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.phoenix.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return _ResearchFeedSheet(scrollController: scrollController);
        },
      ),
    );
  }
}

class _ResearchFeedSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const _ResearchFeedSheet({required this.scrollController});

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
        // Handle bar
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
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ricerca Scientifica',
                style: PhoenixTypography.titleLarge.copyWith(color: textColor),
              ),
              TextButton(
                onPressed: () async {
                  await dao.markAllRead();
                },
                child: Text(
                  'Segna letti',
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: subtitleColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          child: Text(
            'Studi trovati dalla ricerca notturna automatica. '
            'Informazioni a scopo educativo. Consulta il tuo medico.',
            style: PhoenixTypography.caption.copyWith(color: subtitleColor),
          ),
        ),

        const SizedBox(height: Spacing.sm),

        // Papers list
        Expanded(
          child: StreamBuilder<List<ResearchFeedData>>(
            stream: dao.watchAll(),
            builder: (context, snapshot) {
              final papers = snapshot.data ?? [];
              if (papers.isEmpty) {
                return Center(
                  child: Text(
                    'Nessuno studio ancora.',
                    style: PhoenixTypography.bodyLarge
                        .copyWith(color: subtitleColor),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                itemCount: papers.length,
                itemBuilder: (context, index) {
                  final paper = papers[index];
                  return _PaperTile(
                    paper: paper,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    onTap: () async {
                      if (!paper.userRead) {
                        await dao.markRead(paper.id);
                      }
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

class _PaperTile extends StatefulWidget {
  final ResearchFeedData paper;
  final Color textColor;
  final Color subtitleColor;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _PaperTile({
    required this.paper,
    required this.textColor,
    required this.subtitleColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  State<_PaperTile> createState() => _PaperTileState();
}

class _PaperTileState extends State<_PaperTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final paper = widget.paper;
    final isUnread = !paper.userRead;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          setState(() => _expanded = !_expanded);
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.surfaceColor,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: isUnread
                  ? PhoenixColors.darkTextSecondary.withAlpha(80)
                  : widget.borderColor,
            ),
          ),
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Impact badge + source + date
              Row(
                children: [
                  _ImpactBadge(impact: paper.impact),
                  const SizedBox(width: Spacing.sm),
                  _SourceBadge(
                    source: paper.source,
                    language: paper.language,
                    subtitleColor: widget.subtitleColor,
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('d MMM', 'it_IT').format(paper.foundDate),
                    style: PhoenixTypography.caption
                        .copyWith(color: widget.subtitleColor),
                  ),
                  if (isUnread) ...[
                    const SizedBox(width: Spacing.xs),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: PhoenixColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: Spacing.sm),

              // Title
              Text(
                paper.title,
                style: PhoenixTypography.bodyLarge.copyWith(
                  color: widget.textColor,
                  fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                ),
                maxLines: _expanded ? null : 2,
                overflow: _expanded ? null : TextOverflow.ellipsis,
              ),

              // Summary
              if (paper.keySummary.isNotEmpty) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  paper.keySummary,
                  style: PhoenixTypography.bodyMedium
                      .copyWith(color: widget.subtitleColor),
                  maxLines: _expanded ? null : 2,
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                ),
              ],

              // Expanded: abstract + update proposal
              if (_expanded) ...[
                const SizedBox(height: Spacing.smMd),
                Text(
                  paper.abstractText,
                  style: PhoenixTypography.bodyMedium.copyWith(
                    color: widget.subtitleColor,
                    height: 1.5,
                  ),
                ),
                if (paper.doi != null) ...[
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'DOI: ${paper.doi}',
                    style: PhoenixTypography.caption
                        .copyWith(color: PhoenixColors.darkTextSecondary),
                  ),
                ],
                if (paper.proposedUpdate && paper.updateProposal != null) ...[
                  const SizedBox(height: Spacing.smMd),
                  Container(
                    padding: const EdgeInsets.all(Spacing.smMd),
                    decoration: BoxDecoration(
                      color: PhoenixColors.warning.withAlpha(20),
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: PhoenixColors.warning.withAlpha(60),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 18,
                          color: PhoenixColors.warning,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            paper.updateProposal!,
                            style: PhoenixTypography.bodyMedium.copyWith(
                              color: widget.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactBadge extends StatelessWidget {
  final String impact;

  const _ImpactBadge({required this.impact});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (impact) {
      'high' => (PhoenixColors.error, 'Alto'),
      'medium' => (PhoenixColors.warning, 'Medio'),
      _ => (PhoenixColors.darkTextTertiary, 'Basso'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Text(
        label,
        style: PhoenixTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final String source;
  final String language;
  final Color subtitleColor;

  const _SourceBadge({
    required this.source,
    required this.language,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (source) {
      'pubmed' => 'PubMed',
      'cnki' => 'CNKI',
      'cyberleninka' => 'CyberLeninka',
      _ => source,
    };
    final flag = switch (language) {
      'zh' => '🇨🇳',
      'ru' => '🇷🇺',
      _ => '🇬🇧',
    };

    return Text(
      '$flag $label',
      style: PhoenixTypography.caption.copyWith(color: subtitleColor),
    );
  }
}
