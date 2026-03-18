import 'package:flutter/material.dart';

import '../../app/design_tokens.dart';

/// Stitch-style circular control buttons (prev / primary / next).
/// Pattern 3.7 from stitch-redesign spec.
class PhoenixControlButtons extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onNext;
  final bool isPaused;
  final IconData? primaryIcon;
  final IconData previousIcon;
  final IconData nextIcon;

  const PhoenixControlButtons({
    super.key,
    this.onPrevious,
    required this.onPrimaryAction,
    this.onNext,
    this.isPaused = false,
    this.primaryIcon,
    this.previousIcon = Icons.skip_previous_rounded,
    this.nextIcon = Icons.skip_next_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous
        _SecondaryButton(
          icon: previousIcon,
          onTap: onPrevious,
        ),
        const SizedBox(width: Spacing.md),
        // Primary
        _PrimaryButton(
          icon: primaryIcon ??
              (isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
          onTap: onPrimaryAction,
        ),
        const SizedBox(width: Spacing.md),
        // Next
        _SecondaryButton(
          icon: nextIcon,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.phoenix.textPrimary,
          boxShadow: const [],
        ),
        child: Icon(icon, color: context.phoenix.bg, size: 36),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SecondaryButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.phoenix.elevated,
        ),
        child: Icon(
          icon,
          color: onTap != null
              ? context.phoenix.textSecondary
              : context.phoenix.textQuaternary,
          size: 30,
        ),
      ),
    );
  }
}
