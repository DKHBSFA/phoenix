import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/design_tokens.dart';

/// Brutalist square tab selector.
/// Zero radii, border-based active state, Bebas Neue font.
class PhoenixPillTabs extends StatelessWidget {
  final List<PhoenixPillTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PhoenixPillTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(tabs.length, (i) {
            final isActive = i == selectedIndex;
            final tab = tabs[i];
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onChanged(i);
              },
              child: AnimatedContainer(
                duration: AnimDurations.fast,
                curve: AnimCurves.enter,
                height: TouchTargets.buttonHeightSm,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                decoration: BoxDecoration(
                  color: isActive
                      ? context.phoenix.textPrimary
                      : Colors.transparent,
                  border: Border.all(
                    color: isActive
                        ? context.phoenix.textPrimary
                        : context.phoenix.border,
                    width: isActive ? Borders.medium : Borders.thin,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: TouchTargets.iconSm,
                        color: isActive
                            ? (context.phoenix.bg)
                            : (context.phoenix.textSecondary),
                      ),
                      const SizedBox(width: Spacing.xs),
                    ],
                    Text(
                      tab.label.toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontSize: 16,
                        letterSpacing: 0.08 * 16,
                        color: isActive
                            ? (context.phoenix.bg)
                            : (context.phoenix.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PhoenixPillTab {
  final String label;
  final IconData? icon;

  const PhoenixPillTab({required this.label, this.icon});
}
