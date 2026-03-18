import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../app/design_tokens.dart';
import '../../../core/llm/llm_engine.dart';
import '../../../core/llm/prompt_templates.dart';

/// A card that shows an AI-generated insight.
/// If the LLM is unavailable, the card is hidden.
class AiInsightCard extends StatefulWidget {
  final LlmEngine engine;
  final PromptTemplate template;
  final Map<String, dynamic> context;
  final IconData icon;
  final String title;
  final Color? accentColor;

  const AiInsightCard({
    super.key,
    required this.engine,
    required this.template,
    required this.context,
    required this.icon,
    required this.title,
    this.accentColor,
  });

  @override
  State<AiInsightCard> createState() => _AiInsightCardState();
}

class _AiInsightCardState extends State<AiInsightCard> {
  String? _insight;
  bool _loading = false;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _generateInsight();
  }

  Future<void> _generateInsight() async {
    if (!widget.engine.isLlmAvailable) return;

    setState(() => _loading = true);
    try {
      final result = await widget.engine.generate(
        template: widget.template,
        context: widget.context,
        maxTokens: 200,
      );
      if (mounted) setState(() => _insight = result);
    } catch (_) {
      // Silently fail — AI insight is optional
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hide entirely if LLM not available
    if (!widget.engine.isLlmAvailable) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = widget.accentColor ?? context.phoenix.textPrimary;
    final subtitleColor =
        isDark ? PhoenixColors.darkTextSecondary : PhoenixColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.screenH, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: isDark ? PhoenixColors.darkBorder : PhoenixColors.lightBorder,
        ),
        boxShadow: isDark ? CardTokens.shadowDark : CardTokens.shadowLight,
      ),
      child: InkWell(
        onTap: _insight != null ? () => setState(() => _expanded = !_expanded) : null,
        borderRadius: BorderRadius.circular(Radii.lg),
        child: Padding(
          padding: const EdgeInsets.all(CardTokens.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.icon, size: 18, color: accent),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    widget.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: accent,
                    ),
                  ),
                  const Spacer(),
                  if (_loading)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: TDLoading(size: TDLoadingSize.small),
                    )
                  else if (_insight != null)
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: subtitleColor,
                    ),
                ],
              ),
              if (_insight != null && !_expanded) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  _insight!.length > 80
                      ? '${_insight!.substring(0, 80)}...'
                      : _insight!,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (_insight != null && _expanded) ...[
                const SizedBox(height: Spacing.sm),
                Text(
                  _insight!,
                  style: TextStyle(
                    color: isDark
                        ? PhoenixColors.darkTextPrimary
                        : PhoenixColors.lightTextPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: AnimDurations.normal);
  }
}
