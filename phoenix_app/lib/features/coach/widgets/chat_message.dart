import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';

/// A single chat message bubble (user or coach).
/// Stitch pattern 3.1: Chat Bubbles.
class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isStreaming;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md, vertical: Spacing.xs),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Label above bubble (pattern 3.1)
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 0 : 48,
              right: isUser ? Spacing.sm : 0,
              bottom: Spacing.xxs,
            ),
            child: Text(
              isUser ? 'TU' : 'PHOENIX COACH',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? PhoenixColors.darkTextTertiary
                    : PhoenixColors.lightTextQuaternary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                // Bot avatar — brutalist B/W
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  child: Icon(Icons.smart_toy, size: 20,
                      color: isDark ? Colors.black : Colors.white),
                ),
                const SizedBox(width: Spacing.sm),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    // User: inverted (white on dark, black on light)
                    // Coach: surface with border
                    color: isUser
                        ? (isDark ? Colors.white : Colors.black)
                        : isDark
                            ? PhoenixColors.darkElevated
                            : PhoenixColors.lightBg,
                    border: Border.all(
                      color: isUser
                          ? (isDark ? Colors.white : Colors.black)
                          : isDark
                              ? PhoenixColors.darkBorder
                              : PhoenixColors.lightBorder,
                      width: isUser ? Borders.medium : Borders.thin,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: isUser
                                ? (isDark ? Colors.black : Colors.white)
                                : isDark
                                    ? PhoenixColors.darkTextPrimary
                                    : PhoenixColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      if (isStreaming) ...[
                        const SizedBox(width: 4),
                        _BlinkingCursor(
                          color: isUser
                              ? (isDark ? Colors.black54 : Colors.white54)
                              : isDark
                                  ? PhoenixColors.darkTextSecondary
                                  : PhoenixColors.lightTextSecondary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: Spacing.sm),
            ],
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final Color color;
  const _BlinkingCursor({required this.color});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 16,
        color: widget.color,
      ),
    );
  }
}
