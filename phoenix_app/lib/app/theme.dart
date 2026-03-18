import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';
import 'phoenix_theme.dart';

class PhoenixTheme {
  // Duration score colors
  static const scoreGreen = PhoenixColors.zoneGreen;
  static const scoreYellow = PhoenixColors.zoneYellow;
  static const scoreRed = PhoenixColors.zoneRed;

  // ── Font constructors — Brutalist B/W ──

  /// Bebas Neue — display/titles/buttons (condensed, uppercase)
  static TextStyle displayFont({
    double fontSize = 48,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    double height = 1.0,
    Color? color,
  }) {
    return GoogleFonts.bebasNeue(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  /// Space Mono — body/data/inputs (monospace, raw)
  static TextStyle uiFont({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    double? letterSpacing,
    double height = 1.5,
    Color? color,
  }) {
    return GoogleFonts.spaceMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // Display — 72px Bebas Neue hero
      displayLarge: displayFont(fontSize: 72, height: 1.0),
      // Display md — 48px
      displayMedium: displayFont(fontSize: 48, height: 1.0),
      // Display sm — 36px
      displaySmall: displayFont(fontSize: 36, height: 1.0),
      // H1 — 36px Bebas Neue
      headlineLarge: displayFont(
        fontSize: 36,
        letterSpacing: 0.08 * 36,
        height: 1.15,
      ),
      // H2 — 28px Bebas Neue
      headlineMedium: displayFont(
        fontSize: 28,
        letterSpacing: 0.08 * 28,
        height: 1.15,
      ),
      // H3 — 20px Bebas Neue
      titleLarge: displayFont(
        fontSize: 20,
        letterSpacing: 0.08 * 20,
        height: 1.15,
      ),
      // Subtitle — 16px Space Mono
      titleMedium: uiFont(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      // Body — 16px Space Mono
      bodyLarge: uiFont(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      // Body sm — 14px Space Mono
      bodyMedium: uiFont(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      // Body xs — 12px Space Mono
      bodySmall: uiFont(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      // Caption — 12px Space Mono uppercase
      labelSmall: uiFont(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.16 * 12, // tracking-ultra
        height: 1.4,
      ),
      // Button text — 20px Bebas Neue
      labelLarge: displayFont(
        fontSize: 20,
        letterSpacing: 0.08 * 20,
        height: 1.15,
      ),
    );
  }

  // ─── Dark Theme — Brutalist B/W ────────────────────────────────

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: [
        PhoenixTDTheme.darkData,
        PhoenixPillarColors.dark,
      ],
      colorScheme: const ColorScheme.dark(
        primary: PhoenixColors.darkTextPrimary,
        secondary: PhoenixColors.darkTextSecondary,
        surface: PhoenixColors.darkSurface,
        surfaceContainerHighest: PhoenixColors.darkElevated,
        onPrimary: PhoenixColors.darkBg,
        onSecondary: PhoenixColors.darkBg,
        onSurface: PhoenixColors.darkTextPrimary,
        error: PhoenixColors.error,
      ),
      scaffoldBackgroundColor: PhoenixColors.darkBg,
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: PhoenixColors.darkBg,
        elevation: 0,
        centerTitle: true,
        foregroundColor: PhoenixColors.darkTextPrimary,
        titleTextStyle: displayFont(
          fontSize: 20,
          letterSpacing: 0.08 * 20,
          color: PhoenixColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: PhoenixColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CardTokens.borderRadius),
          side: BorderSide(
            color: PhoenixColors.darkBorder,
            width: Borders.medium,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PhoenixColors.darkTextPrimary,
          foregroundColor: PhoenixColors.darkBg,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 12,
          ),
          minimumSize: Size(0, TouchTargets.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: PhoenixColors.darkTextPrimary,
              width: Borders.medium,
            ),
          ),
          textStyle: displayFont(fontSize: 20, letterSpacing: 0.08 * 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PhoenixColors.darkTextPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 12,
          ),
          minimumSize: Size(0, TouchTargets.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          side: BorderSide(
            color: PhoenixColors.darkBorderStrong,
            width: Borders.medium,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PhoenixColors.darkTextPrimary,
        foregroundColor: PhoenixColors.darkBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PhoenixColors.darkSurface,
        selectedItemColor: PhoenixColors.darkTextPrimary,
        unselectedItemColor: PhoenixColors.darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: displayFont(
          fontSize: 12,
          letterSpacing: 0.08 * 12,
        ),
        unselectedLabelStyle: displayFont(
          fontSize: 12,
          letterSpacing: 0.08 * 12,
        ),
        showUnselectedLabels: true,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: PhoenixColors.darkTextPrimary,
        inactiveTrackColor: PhoenixColors.darkElevated,
        thumbColor: PhoenixColors.darkTextPrimary,
      ),
      dividerTheme: const DividerThemeData(
        color: PhoenixColors.darkBorder,
        thickness: Borders.thin,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PhoenixColors.darkSurface,
        hintStyle: uiFont(
          fontSize: 16,
          color: PhoenixColors.darkTextTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(
            color: PhoenixColors.darkBorder,
            width: Borders.medium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(
            color: PhoenixColors.darkBorder,
            width: Borders.medium,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(
            color: PhoenixColors.darkBorderHeavy,
            width: Borders.medium,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: PhoenixColors.darkBorder,
          width: Borders.thin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        labelStyle: displayFont(
          fontSize: 16,
          letterSpacing: 0.08 * 16,
          color: PhoenixColors.darkTextSecondary,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: PhoenixColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: PhoenixColors.darkBorderHeavy,
            width: Borders.heavy,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PhoenixColors.darkElevated,
        contentTextStyle: uiFont(
          fontSize: 14,
          color: PhoenixColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: PhoenixColors.darkBorderStrong,
            width: Borders.medium,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Light Theme — Brutalist B/W ───────────────────────────────

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: [
        PhoenixTDTheme.lightData,
        PhoenixPillarColors.light,
      ],
      colorScheme: const ColorScheme.light(
        primary: PhoenixColors.lightTextPrimary,
        secondary: PhoenixColors.lightTextSecondary,
        surface: PhoenixColors.lightSurface,
        surfaceContainerHighest: PhoenixColors.lightElevated,
        onPrimary: PhoenixColors.lightSurface,
        onSecondary: PhoenixColors.lightSurface,
        onSurface: PhoenixColors.lightTextPrimary,
        error: PhoenixColors.error,
      ),
      scaffoldBackgroundColor: PhoenixColors.lightBg,
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: PhoenixColors.lightBg,
        elevation: 0,
        centerTitle: true,
        foregroundColor: PhoenixColors.lightTextPrimary,
        titleTextStyle: displayFont(
          fontSize: 20,
          letterSpacing: 0.08 * 20,
          color: PhoenixColors.lightTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: PhoenixColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CardTokens.borderRadius),
          side: BorderSide(
            color: PhoenixColors.lightBorder,
            width: Borders.medium,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PhoenixColors.lightTextPrimary,
          foregroundColor: PhoenixColors.lightBg,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 12,
          ),
          minimumSize: Size(0, TouchTargets.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: PhoenixColors.lightTextPrimary,
              width: Borders.medium,
            ),
          ),
          textStyle: displayFont(fontSize: 20, letterSpacing: 0.08 * 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PhoenixColors.lightTextPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 12,
          ),
          minimumSize: Size(0, TouchTargets.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          side: BorderSide(
            color: PhoenixColors.lightBorderStrong,
            width: Borders.medium,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PhoenixColors.lightTextPrimary,
        foregroundColor: PhoenixColors.lightBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PhoenixColors.lightSurface,
        selectedItemColor: PhoenixColors.lightTextPrimary,
        unselectedItemColor: PhoenixColors.lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: displayFont(
          fontSize: 12,
          letterSpacing: 0.08 * 12,
        ),
        unselectedLabelStyle: displayFont(
          fontSize: 12,
          letterSpacing: 0.08 * 12,
        ),
        showUnselectedLabels: true,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: PhoenixColors.lightTextPrimary,
        inactiveTrackColor: PhoenixColors.lightElevated,
        thumbColor: PhoenixColors.lightTextPrimary,
      ),
      dividerTheme: const DividerThemeData(
        color: PhoenixColors.lightBorder,
        thickness: Borders.thin,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PhoenixColors.lightBg,
        hintStyle: uiFont(
          fontSize: 16,
          color: PhoenixColors.lightTextTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(
            color: PhoenixColors.lightBorder,
            width: Borders.medium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(
            color: PhoenixColors.lightBorder,
            width: Borders.medium,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(
            color: PhoenixColors.lightBorderHeavy,
            width: Borders.medium,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: PhoenixColors.lightBorder,
          width: Borders.thin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        labelStyle: displayFont(
          fontSize: 16,
          letterSpacing: 0.08 * 16,
          color: PhoenixColors.lightTextSecondary,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: PhoenixColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: PhoenixColors.lightBorderHeavy,
            width: Borders.heavy,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PhoenixColors.lightTextPrimary,
        contentTextStyle: uiFont(
          fontSize: 14,
          color: PhoenixColors.lightBg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: PhoenixColors.lightBorderStrong,
            width: Borders.medium,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
