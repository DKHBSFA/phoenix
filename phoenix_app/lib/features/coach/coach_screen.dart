import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../core/llm/llm_engine.dart';
import '../../core/llm/model_manager.dart';
import '../../core/llm/prompt_templates.dart';
import 'widgets/chat_message.dart';
import 'widgets/research_feed_card.dart';
import 'protocol_update_sheet.dart';

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

enum _ReportType { lastWorkout, weekly, fasting }

class _ChatEntry {
  final String text;
  final bool isUser;
  final bool isStreaming;

  const _ChatEntry({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
  });

  _ChatEntry copyWith({String? text, bool? isStreaming}) => _ChatEntry(
        text: text ?? this.text,
        isUser: isUser,
        isStreaming: isStreaming ?? this.isStreaming,
      );
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  String? _reportContent;
  _ReportType? _activeReport;
  bool _generating = false;
  DateTime? _generatedAt;

  // Chat state
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();
  final _inputFocusNode = FocusNode();
  final _chatMessages = <_ChatEntry>[];
  bool _chatMode = false;
  StreamSubscription<String>? _streamSub;

  static const _maxChatMessages = 10;

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    _streamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(llmEngineProvider);
    final modelManager = ref.watch(modelManagerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final px = context.phoenix;

    // Chat is always enabled when engine is ready (template or LLM)
    final chatEnabled = engine.isReady;

    return Scaffold(
      body: SafeArea(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg, Spacing.screenTop, Spacing.lg, 0,
            ),
            child: Text(
              'Coach',
              style: PhoenixTypography.displayLarge.copyWith(
                color: px.textPrimary,
              ),
            ),
          ),

          // Status badge
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg, vertical: Spacing.sm),
            child: _StatusBadge(
              engine: engine,
              modelManager: modelManager,
            ),
          ),

          // Report chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: Row(
              children: [
                _ReportChip(
                  label: 'Ultimo allenamento',
                  icon: Icons.fitness_center,
                  isActive: _activeReport == _ReportType.lastWorkout,
                  onTap: () => _generateReport(_ReportType.lastWorkout),
                ),
                const SizedBox(width: Spacing.sm),
                _ReportChip(
                  label: 'Questa settimana',
                  icon: Icons.calendar_today,
                  isActive: _activeReport == _ReportType.weekly,
                  onTap: () => _generateReport(_ReportType.weekly),
                ),
                const SizedBox(width: Spacing.sm),
                _ReportChip(
                  label: 'Digiuno',
                  icon: Icons.timer,
                  isActive: _activeReport == _ReportType.fasting,
                  onTap: () => _generateReport(_ReportType.fasting),
                ),
                const SizedBox(width: Spacing.sm),
                _ReportChip(
                  label: 'Aggiornamenti',
                  icon: Icons.science,
                  isActive: false,
                  onTap: () => ProtocolUpdateSheet.show(context),
                ),
              ],
            ),
          ),

          // Research feed card (shows when there are unread papers)
          const ResearchFeedCard(),

          const SizedBox(height: Spacing.md),

          // Content area
          Expanded(
            child: _chatMode
                ? _buildChatList()
                : _generating
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TDLoading(size: TDLoadingSize.medium),
                            const SizedBox(height: Spacing.md),
                            const Text('Generando report...'),
                          ],
                        ),
                      )
                    : _reportContent != null
                        ? _ReportCard(
                            content: _reportContent!,
                            generatedAt: _generatedAt,
                            onRegenerate: () {
                              if (_activeReport != null) {
                                _generateReport(_activeReport!);
                              }
                            },
                          ).animate().fadeIn(duration: AnimDurations.normal)
                        : _WelcomeCoachState(
                            isDark: isDark,
                            onSuggestionTap: _sendSuggestion,
                          ),
          ),

          // Chat input (pattern 3.3) — focus ring
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: AnimatedBuilder(
              animation: _inputFocusNode,
              builder: (context, child) {
                final focused = _inputFocusNode.hasFocus;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md, vertical: Spacing.sm),
                  decoration: BoxDecoration(
                    color: isDark
                        ? PhoenixColors.darkElevated
                        : PhoenixColors.lightBg,
                    borderRadius: BorderRadius.circular(Radii.lg),
                    border: Border.all(
                      color: focused
                          ? px.textPrimary
                          : px.border,
                      width: focused ? 2 : 1,
                    ),
                    boxShadow: CardTokens.shadowLight,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          focusNode: _inputFocusNode,
                          enabled: chatEnabled,
                          onSubmitted: chatEnabled ? (_) => _sendChat() : null,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Chiedi al coach...',
                            hintStyle: TextStyle(
                              color: px.textQuaternary,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      GestureDetector(
                        onTap: chatEnabled ? _sendChat : null,
                        child: Container(
                          padding: const EdgeInsets.all(Spacing.sm),
                          decoration: BoxDecoration(
                            color: chatEnabled
                                ? (isDark ? Colors.white : Colors.black)
                                : (isDark
                                    ? PhoenixColors.darkOverlay
                                    : PhoenixColors.lightElevated),
                          ),
                          child: Icon(
                            Icons.send,
                            size: 18,
                            color: chatEnabled
                                ? (isDark ? Colors.black : Colors.white)
                                : px.textQuaternary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      itemCount: _chatMessages.length,
      itemBuilder: (context, index) {
        final msg = _chatMessages[index];
        return ChatMessage(
          text: msg.text,
          isUser: msg.isUser,
          isStreaming: msg.isStreaming,
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendSuggestion(String text) {
    _chatController.text = text;
    _sendChat();
  }

  Future<void> _sendChat() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    // Check message limit
    final userMessages =
        _chatMessages.where((m) => m.isUser).length;
    if (userMessages >= _maxChatMessages) {
      TDToast.showText('Limite raggiunto. Vuoi un report completo?', context: context);
      return;
    }

    _chatController.clear();
    HapticFeedback.lightImpact();

    setState(() {
      _chatMode = true;
      _chatMessages.add(_ChatEntry(text: text, isUser: true));
      // Add placeholder for coach response
      _chatMessages.add(
          const _ChatEntry(text: '', isUser: false, isStreaming: true));
    });
    _scrollToBottom();

    // Build chat history string
    final history = _chatMessages
        .where((m) => m.text.isNotEmpty)
        .map((m) => m.isUser ? 'Utente: ${m.text}' : 'Coach: ${m.text}')
        .join('\n');

    final engine = ref.read(llmEngineProvider);
    final coachIndex = _chatMessages.length - 1;
    final buffer = StringBuffer();

    try {
      await for (final token in engine.generateStream(
        template: ChatTemplate(),
        context: {
          'user_message': text,
          'chat_history': history,
          'user_data_summary': '',
        },
        maxTokens: 256,
      )) {
        buffer.write(token);
        if (mounted) {
          setState(() {
            _chatMessages[coachIndex] = _chatMessages[coachIndex]
                .copyWith(text: buffer.toString());
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      buffer.write('[Errore: $e]');
    }

    if (mounted) {
      setState(() {
        _chatMessages[coachIndex] = _chatMessages[coachIndex]
            .copyWith(text: buffer.toString(), isStreaming: false);
      });
    }
  }

  Future<void> _generateReport(_ReportType type) async {
    HapticFeedback.lightImpact();
    setState(() {
      _generating = true;
      _activeReport = type;
      _reportContent = null;
      _chatMode = false;
    });

    try {
      final generator = ref.read(reportGeneratorProvider);
      final content = switch (type) {
        _ReportType.lastWorkout => await generator.generateLastWorkout(),
        _ReportType.weekly => await generator.generateWeekly(),
        _ReportType.fasting => await generator.generateFasting(),
      };
      if (mounted) {
        setState(() {
          _reportContent = content;
          _generatedAt = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _reportContent = 'Errore: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _generating = false);
      }
    }
  }
}

// ─── Status Badge ────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final LlmEngine engine;
  final ModelManager modelManager;

  const _StatusBadge({required this.engine, required this.modelManager});

  @override
  Widget build(BuildContext context) {
    final subtitleColor = context.phoenix.textSecondary;

    final Color dotColor;
    final String label;

    if (engine.isLlmAvailable && engine.isReady) {
      dotColor = PhoenixColors.success;
      final tps = engine.tokPerSec;
      label = 'Coach AI (${tps.toStringAsFixed(1)} tok/s)';
    } else if (modelManager.state.status == ModelDownloadStatus.downloading) {
      dotColor = PhoenixColors.warning;
      final pct = (modelManager.state.progress * 100).toStringAsFixed(0);
      label = 'Scaricamento modello... $pct%';
    } else {
      // Template mode — coach is active
      dotColor = PhoenixColors.success;
      label = 'Coach Attivo';
    }

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            boxShadow: const [],
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          label,
          style: TextStyle(color: subtitleColor, fontSize: 13),
        ),
      ],
    );
  }
}

// ─── Report Chip ─────────────────────────────────────────────────

class _ReportChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ReportChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final px = context.phoenix;

    // Stitch pattern 3.2: Quick Reply Pills
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.full),
          border: Border.all(
            color: isActive
                ? px.textPrimary
                : px.border,
          ),
          color: isActive ? px.textPrimary.withAlpha(13) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? px.textPrimary
                  : px.textSecondary,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? px.textPrimary
                    : px.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Report Card ─────────────────────────────────────────────────

class _ReportCard extends StatelessWidget {
  final String content;
  final DateTime? generatedAt;
  final VoidCallback onRegenerate;

  const _ReportCard({
    required this.content,
    this.generatedAt,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final px = context.phoenix;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(CardTokens.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._renderMarkdown(content, theme, px.textPrimary),

              if (generatedAt != null) ...[
                const SizedBox(height: Spacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Generato: ${_formatTime(generatedAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: px.textTertiary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onRegenerate,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Rigenera'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _renderMarkdown(String text, ThemeData theme, Color accent) {
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.xs),
          child: Text(
            line.substring(3),
            style: theme.textTheme.titleLarge,
          ),
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.xs),
          child: Text(
            line.substring(4),
            style: theme.textTheme.titleMedium,
          ),
        ));
      } else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: Spacing.sm, bottom: Spacing.xxs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  \u2022  ', style: TextStyle(fontSize: 14)),
              Expanded(
                child: _RichLine(text: line.substring(2)),
              ),
            ],
          ),
        ));
      } else if (line.startsWith('> ')) {
        widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: Spacing.xs),
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: accent,
                width: 3,
              ),
            ),
            color: accent.withAlpha(15),
          ),
          child: _RichLine(text: line.substring(2)),
        ));
      } else if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: Spacing.xs));
      } else {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: Spacing.xxs),
          child: _RichLine(text: line),
        ));
      }
    }
    return widgets;
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

/// Renders a line with **bold** spans.
class _RichLine extends StatelessWidget {
  final String text;

  const _RichLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: context.phoenix.textPrimary,
        ),
        children: spans,
      ),
    );
  }
}

// ─── Welcome State with Suggestions ──────────────────────────────

class _WelcomeCoachState extends StatelessWidget {
  final bool isDark;
  final void Function(String text) onSuggestionTap;

  const _WelcomeCoachState({
    required this.isDark,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final px = context.phoenix;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: px.textPrimary.withAlpha(26),
              ),
              child: Icon(
                Icons.local_fire_department,
                size: 32,
                color: px.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Phoenix Coach',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Analizza i tuoi dati e ti guida nel protocollo.\nChiedi quello che vuoi o prova un suggerimento.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.phoenix.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.lg),

            // Suggestion chips
            _SuggestionTile(
              icon: Icons.fitness_center,
              text: 'Come va il mio allenamento?',
              isDark: isDark,
              onTap: () => onSuggestionTap('Come va il mio allenamento?'),
            ),
            const SizedBox(height: Spacing.sm),
            _SuggestionTile(
              icon: Icons.calendar_today,
              text: 'Riepilogo della mia settimana',
              isDark: isDark,
              onTap: () => onSuggestionTap('Riepilogo della mia settimana'),
            ),
            const SizedBox(height: Spacing.sm),
            _SuggestionTile(
              icon: Icons.local_fire_department,
              text: 'Dammi motivazione!',
              isDark: isDark,
              onTap: () => onSuggestionTap('Dammi motivazione!'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.icon,
    required this.text,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: Spacing.md, horizontal: Spacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(
            color: context.phoenix.border,
          ),
          color: isDark ? PhoenixColors.darkElevated : PhoenixColors.lightBg,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: context.phoenix.textPrimary,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: context.phoenix.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: context.phoenix.textQuaternary,
            ),
          ],
        ),
      ),
    );
  }
}
