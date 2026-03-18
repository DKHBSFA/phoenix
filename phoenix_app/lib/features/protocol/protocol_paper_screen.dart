import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../core/models/protocol_chapters.dart';

/// In-app scientific paper presenting the Phoenix Protocol.
///
/// Expandable chapter cards, formatted sections with DOI citations.
/// All text in Italian, brutalist style.
class ProtocolPaperScreen extends ConsumerStatefulWidget {
  const ProtocolPaperScreen({super.key});

  @override
  ConsumerState<ProtocolPaperScreen> createState() =>
      _ProtocolPaperScreenState();
}

class _ProtocolPaperScreenState extends ConsumerState<ProtocolPaperScreen> {
  final _expandedChapters = <int>{};

  void _toggleChapter(int number) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_expandedChapters.contains(number)) {
        _expandedChapters.remove(number);
      } else {
        _expandedChapters.add(number);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;

    return Scaffold(
      backgroundColor: px.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.md, Spacing.screenTop, Spacing.md, 0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: TouchTargets.min,
                      height: TouchTargets.min,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back,
                        color: px.textPrimary,
                        size: TouchTargets.iconNav,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      'PROTOCOLLO PHOENIX',
                      style: PhoenixTypography.h2.copyWith(
                        color: px.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Subtitle ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg, Spacing.sm, Spacing.lg, Spacing.md,
              ),
              child: Text(
                'Sistema integrato di allenamento, condizionamento '
                'e alimentazione — 120+ studi verificati',
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: px.textSecondary,
                ),
              ),
            ),

            // ── Chapters ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.md, 0, Spacing.md, Spacing.xxl,
                ),
                itemCount: protocolChapters.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: Spacing.cardGap),
                itemBuilder: (context, index) {
                  final chapter = protocolChapters[index];
                  final isExpanded =
                      _expandedChapters.contains(chapter.number);
                  return _ChapterCard(
                    chapter: chapter,
                    isExpanded: isExpanded,
                    onToggle: () => _toggleChapter(chapter.number),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// CHAPTER CARD
// ═══════════════════════════════════════════════════════════════════

class _ChapterCard extends StatelessWidget {
  final ProtocolChapter chapter;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ChapterCard({
    required this.chapter,
    required this.isExpanded,
    required this.onToggle,
  });

  IconData _iconForName(String name) {
    return switch (name) {
      'foundation' => Icons.foundation,
      'fitness_center' => Icons.fitness_center,
      'ac_unit' => Icons.ac_unit,
      'restaurant' => Icons.restaurant,
      'biotech' => Icons.biotech,
      'hub' => Icons.hub,
      _ => Icons.article,
    };
  }

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;

    return Container(
      decoration: BoxDecoration(
        color: px.surface,
        border: Border.all(
          color: isExpanded ? px.borderStrong : px.border,
          width: isExpanded ? Borders.medium : Borders.thin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (tap to toggle) ──
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(CardTokens.padding),
              child: Row(
                children: [
                  // Chapter number
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: px.borderHeavy,
                        width: Borders.medium,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chapter.number}',
                      style: PhoenixTypography.h3.copyWith(
                        color: px.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.smMd),
                  // Icon
                  Icon(
                    _iconForName(chapter.icon),
                    size: TouchTargets.iconInline,
                    color: px.textSecondary,
                  ),
                  const SizedBox(width: Spacing.sm),
                  // Title
                  Expanded(
                    child: Text(
                      chapter.titleIt.toUpperCase(),
                      style: PhoenixTypography.h3.copyWith(
                        color: px.textPrimary,
                      ),
                    ),
                  ),
                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: AnimDurations.normal,
                    curve: AnimCurves.enter,
                    child: Icon(
                      Icons.expand_more,
                      color: px.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Sections (visible when expanded) ──
          if (isExpanded) ...[
            Divider(
              height: 1,
              thickness: Borders.thin,
              color: px.border,
            ),
            for (int i = 0; i < chapter.sections.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  thickness: Borders.thin,
                  color: px.border,
                  indent: Spacing.md,
                  endIndent: Spacing.md,
                ),
              _SectionBlock(section: chapter.sections[i]),
            ],
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SECTION BLOCK
// ═══════════════════════════════════════════════════════════════════

class _SectionBlock extends StatelessWidget {
  final ProtocolSection section;

  const _SectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CardTokens.padding,
        Spacing.md,
        CardTokens.padding,
        CardTokens.padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            section.titleIt,
            style: PhoenixTypography.caption.copyWith(
              color: px.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.sm),

          // Body text (with bold rendering)
          _RichBody(text: section.bodyIt),

          // Citations
          if (section.citations.isNotEmpty) ...[
            const SizedBox(height: Spacing.smMd),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.xs,
              children: [
                for (final doi in section.citations)
                  _DoiChip(doi: doi),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// RICH BODY TEXT — renders **bold** spans and \n paragraphs
// ═══════════════════════════════════════════════════════════════════

class _RichBody extends StatelessWidget {
  final String text;

  const _RichBody({required this.text});

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;
    final defaultStyle = PhoenixTypography.bodyMedium.copyWith(
      color: px.textPrimary,
      height: 1.6,
    );

    final spans = <InlineSpan>[];
    final boldRegex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: spans,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// DOI CHIP — tappable citation
// ═══════════════════════════════════════════════════════════════════

class _DoiChip extends StatelessWidget {
  final String doi;

  const _DoiChip({required this.doi});

  String get _shortLabel {
    // Show abbreviated DOI for compact display
    final parts = doi.split('/');
    if (parts.length >= 2) {
      return 'DOI:${parts.last.length > 18 ? '${parts.last.substring(0, 18)}...' : parts.last}';
    }
    return 'DOI:$doi';
  }

  void _onTap(BuildContext context) {
    final url = 'https://doi.org/$doi';
    Clipboard.setData(ClipboardData(text: url));
    HapticFeedback.lightImpact();
    TDToast.showText(
      'Link copiato: $url',
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: px.border,
            width: Borders.thin,
          ),
        ),
        child: Text(
          _shortLabel,
          style: PhoenixTypography.micro.copyWith(
            color: px.textTertiary,
          ),
        ),
      ),
    );
  }
}
