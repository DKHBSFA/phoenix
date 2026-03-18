import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════
// Phoenix Design Tokens — BRUTALIST B/W
// ═══════════════════════════════════════════════════════════════════
// Font: Bebas Neue (display/titles) + Space Mono (body/data)
// Grid: 4px base, 8px primary
// Radii: 0px — Borders: 1-4px — Shadows: none
// Color: B/W + red/green/yellow functional only
// Reference: .seurat/tokens.css
// ═══════════════════════════════════════════════════════════════════

// ─── Spacing (4px base, 8px primary grid) ─────────────────────────

class Spacing {
  Spacing._();
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const smMd = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  /// Screen horizontal padding (tighter — brutalist wastes no space)
  static const screenH = 16.0;
  /// Screen top padding (below safe area)
  static const screenTop = 16.0;
  /// Gap between cards (tighter rhythm)
  static const cardGap = 8.0;
}

// ─── Radii — BRUTALIST: ZERO ─────────────────────────────────────

class Radii {
  Radii._();
  static const none = 0.0;
  static const sm = 0.0;       // was 8 — now square
  static const md = 0.0;       // was 12 — now square
  static const lg = 0.0;       // was 16 — now square
  static const xl = 0.0;       // was 24 — now square
  static const input = 2.0;    // only for input fields (usability)
  static const full = 999.0;   // only for circular elements (rings, avatars)
}

// ─── Borders — THE primary design element ────────────────────────

class Borders {
  Borders._();
  static const thin = 1.0;     // subtle structure
  static const medium = 2.0;   // standard card/section border
  static const heavy = 3.0;    // emphasis, active states
  static const ultra = 4.0;    // hero elements, primary CTA
}

// ─── Animation ────────────────────────────────────────────────────

class AnimDurations {
  AnimDurations._();
  static const feedback = Duration(milliseconds: 120);
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 350);
  static const ringFill = Duration(milliseconds: 800);
  static const breathing = Duration(milliseconds: 4000);
  static const stagger = Duration(milliseconds: 40);
}

class AnimCurves {
  AnimCurves._();
  /// Snappy enter — sharp, not springy
  static const enter = Cubic(0.2, 0, 0, 1);
  /// Smooth exit
  static const exit = Cubic(0.0, 0, 0.2, 1);
  /// Standard — linear for timers/progress
  static const standard = Curves.linear;
  /// NO spring curves — brutalist rejects playfulness
  @Deprecated('Use enter instead — spring curves removed in brutalist redesign')
  static const spring = Cubic(0.2, 0, 0, 1);
}

// ─── Colors — Pure B/W + Functional Only ─────────────────────────

class PhoenixColors {
  PhoenixColors._();

  // ── Brand ──
  @Deprecated('Use context.phoenix.textPrimary instead — primary is always white and breaks in light mode')
  static const primary = Color(0xFFFFFFFF);

  // ── Pillar accents — all white/gray (B/W, no chromatic differentiation) ──
  static const trainingAccent = Color(0xFFFFFFFF);
  static const fastingAccent = Color(0xFFFFFFFF);
  static const conditioningAccent = Color(0xFFFFFFFF);
  static const biomarkersAccent = Color(0xFFFFFFFF);

  // ── Pillar surfaces (subtle white @ 8% on dark bg) ──
  static Color get trainingSurface => const Color(0x14FFFFFF);
  static Color get fastingSurface => const Color(0x14FFFFFF);
  static Color get conditioningSurface => const Color(0x14FFFFFF);
  static Color get biomarkersSurface => const Color(0x14FFFFFF);
  static Color get coachSurface => const Color(0x14FFFFFF);

  // ── Dark theme surfaces (pure black scale from tokens.css) ──
  static const darkBg = Color(0xFF000000);
  static const darkSurface = Color(0xFF0C0C0C);
  static const darkElevated = Color(0xFF181818);
  static const darkOverlay = Color(0xFF282828);

  // ── Dark borders ──
  static const darkBorder = Color(0xFF282828);
  static const darkBorderStrong = Color(0xFF585858);
  static const darkBorderHeavy = Color(0xFFFFFFFF); // brutalist: white on black

  // ── Dark text ──
  static const darkTextPrimary = Color(0xFFFFFFFF);    // 21:1 vs black
  static const darkTextSecondary = Color(0xFFA0A0A0);  // 10.4:1 vs black
  static const darkTextTertiary = Color(0xFF585858);    // 4.2:1 vs black
  static const darkTextQuaternary = Color(0xFF383838);  // structural only

  // ── Light theme surfaces ──
  static const lightBg = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF7F7F7);
  static const lightElevated = Color(0xFFEFEFEF);
  static const lightOverlay = Color(0xFFDFDFDF);

  // ── Light borders ──
  static const lightBorder = Color(0xFFDFDFDF);
  static const lightBorderStrong = Color(0xFFA0A0A0);
  static const lightBorderHeavy = Color(0xFF000000); // brutalist: black on white

  // ── Light text ──
  static const lightTextPrimary = Color(0xFF000000);    // 21:1 vs white
  static const lightTextSecondary = Color(0xFF585858);   // 7.0:1 vs white
  static const lightTextTertiary = Color(0xFFA0A0A0);    // 3.9:1 vs white
  static const lightTextQuaternary = Color(0xFFC8C8C8);  // structural only

  // ── Functional (the ONLY colors in the system) ──
  static const success = Color(0xFF00CC44);
  static const warning = Color(0xFFFFAA00);
  static const error = Color(0xFFFF0000);
  // info removed — brutalist has no blue

  // ── State colors for protocol cards ──
  static const completed = Color(0xFF00CC44);
  static const alert = Color(0xFFFF0000);
  static const inProgress = Color(0xFFFFFFFF); // maximum visibility
  static const pending = Color(0xFF383838);    // dormant = recedes

  // Semantic surfaces
  static Color get successSurface => const Color(0x1F00CC44); // 12% opacity
  static Color get warningSurface => const Color(0x1AFFAA00); // 10% opacity
  static Color get errorSurface => const Color(0x1AFF0000);   // 10% opacity

  // ── Status zones (RPE / Duration Score) ──
  static const zoneGreen = Color(0xFF00CC44);
  static const zoneYellow = Color(0xFFFFAA00);
  static const zoneRed = Color(0xFFFF0000);

  // ── Chart colors ──
  static const chartArea = Color(0x0FFFFFFF); // 6% white
  static const chartGrid = Color(0xFF181818);
  static const chartSuccess = Color(0xFF00CC44);
  static const chartDanger = Color(0xFFFF0000);

  // ── Opacity constants ──
  static const opacityDisabled = 0.32;
  static const opacityHover = 0.06;
  static const opacityPressed = 0.12;
  static const opacitySurface = 0.08;

}

// ─── Typography — Bebas Neue + Space Mono ─────────────────────────

class PhoenixTypography {
  PhoenixTypography._();

  static TextStyle _display(double size, FontWeight weight) =>
      GoogleFonts.bebasNeue(fontSize: size, fontWeight: weight);

  static TextStyle _mono(double size, FontWeight weight) =>
      GoogleFonts.spaceMono(fontSize: size, fontWeight: weight);

  // ── Display font (Bebas Neue) — titles, headings, buttons ──
  static TextStyle get hero => _display(72, FontWeight.w400);
  static TextStyle get displayLarge => _display(48, FontWeight.w400);
  static TextStyle get h1 => _display(36, FontWeight.w400);
  static TextStyle get h2 => _display(28, FontWeight.w400);
  static TextStyle get h3 => _display(20, FontWeight.w400);
  static TextStyle get button => _display(20, FontWeight.w400).copyWith(
    letterSpacing: 0.08 * 20, // tracking-wide
  );

  // ── Mono font (Space Mono) — body, data, captions ──
  static TextStyle get bodyLarge => _mono(16, FontWeight.w400);
  static TextStyle get bodyMedium => _mono(14, FontWeight.w400);
  static TextStyle get caption => _mono(12, FontWeight.w700).copyWith(
    letterSpacing: 0.16 * 12, // tracking-ultra
  );
  static TextStyle get micro => _mono(10, FontWeight.w700).copyWith(
    letterSpacing: 0.08 * 10, // tracking-wide
  );

  // ── Numeric (Space Mono bold for data) ──
  static TextStyle get numeric => _mono(28, FontWeight.w700);
  static TextStyle get numericLarge => _mono(48, FontWeight.w700);

  // ── Backward compat aliases ──
  static TextStyle get titleLarge => h1;
  static TextStyle get titleMedium => h2;

  // ── Tracking constants (for manual application) ──
  static const trackingCompressed = -0.03;
  static const trackingNormal = 0.0;
  static const trackingWide = 0.08;
  static const trackingUltra = 0.16;
}

// ─── Card tokens ──────────────────────────────────────────────────

class CardTokens {
  CardTokens._();

  static const borderRadius = 0.0;   // BRUTALIST: square
  static const padding = 16.0;       // tighter than before
  static const gap = 8.0;            // tighter rhythm
  static const accentBorderWidth = Borders.heavy; // 3px

  // ── BRUTALIST: no shadows — depth through borders ──
  static const shadowDark = <BoxShadow>[];  // empty
  static const shadowLight = <BoxShadow>[]; // empty

  // ── Float shadow (exception: dialogs, bottom sheets) ──
  static const shadowFloat = [
    BoxShadow(
      color: Color(0x1AFFFFFF), // subtle white outline
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 48,
      offset: Offset(0, 16),
    ),
  ];
}

// ─── Touch targets ────────────────────────────────────────────────

class TouchTargets {
  TouchTargets._();
  static const min = 44.0;
  static const buttonHeight = 48.0;     // denser
  static const buttonHeightSm = 36.0;
  static const iconNav = 24.0;
  static const iconInline = 20.0;
  static const iconSm = 16.0;
}

// ─── Theme-aware color resolution ────────────────────────────────
// Eliminates isDark ? PhoenixColors.dark* : PhoenixColors.light* boilerplate.
// Usage: context.phoenix.textPrimary, context.phoenix.border, etc.

extension PhoenixThemeContext on BuildContext {
  _PhoenixResolvedColors get phoenix {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return _PhoenixResolvedColors(isDark);
  }
}

class _PhoenixResolvedColors {
  final bool isDark;
  const _PhoenixResolvedColors(this.isDark);

  // Text
  Color get textPrimary => isDark ? PhoenixColors.darkTextPrimary : PhoenixColors.lightTextPrimary;
  Color get textSecondary => isDark ? PhoenixColors.darkTextSecondary : PhoenixColors.lightTextSecondary;
  Color get textTertiary => isDark ? PhoenixColors.darkTextTertiary : PhoenixColors.lightTextTertiary;
  Color get textQuaternary => isDark ? PhoenixColors.darkTextQuaternary : PhoenixColors.lightTextQuaternary;

  // Surfaces
  Color get bg => isDark ? PhoenixColors.darkBg : PhoenixColors.lightBg;
  Color get surface => isDark ? PhoenixColors.darkSurface : PhoenixColors.lightSurface;
  Color get elevated => isDark ? PhoenixColors.darkElevated : PhoenixColors.lightElevated;
  Color get overlay => isDark ? PhoenixColors.darkOverlay : PhoenixColors.lightOverlay;

  // Borders
  Color get border => isDark ? PhoenixColors.darkBorder : PhoenixColors.lightBorder;
  Color get borderStrong => isDark ? PhoenixColors.darkBorderStrong : PhoenixColors.lightBorderStrong;
  Color get borderHeavy => isDark ? PhoenixColors.darkBorderHeavy : PhoenixColors.lightBorderHeavy;
}
