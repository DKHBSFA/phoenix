import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'design_tokens.dart';

// ─── Phoenix Pillar Extension ────────────────────────────────────
// Kept for backward compat — in B/W all pillars map to white.

class PhoenixPillarColors extends ThemeExtension<PhoenixPillarColors> {
  const PhoenixPillarColors({
    required this.training,
    required this.fasting,
    required this.conditioning,
    required this.biomarkers,
    required this.coach,
    required this.trainingSurface,
    required this.fastingSurface,
    required this.conditioningSurface,
    required this.biomarkersSurface,
    required this.coachSurface,
  });

  final Color training;
  final Color fasting;
  final Color conditioning;
  final Color biomarkers;
  final Color coach;
  final Color trainingSurface;
  final Color fastingSurface;
  final Color conditioningSurface;
  final Color biomarkersSurface;
  final Color coachSurface;

  static const light = PhoenixPillarColors(
    training: PhoenixColors.lightTextPrimary,
    fasting: PhoenixColors.lightTextPrimary,
    conditioning: PhoenixColors.lightTextPrimary,
    biomarkers: PhoenixColors.lightTextPrimary,
    coach: PhoenixColors.lightTextPrimary,
    trainingSurface: Color(0x0A000000),
    fastingSurface: Color(0x0A000000),
    conditioningSurface: Color(0x0A000000),
    biomarkersSurface: Color(0x0A000000),
    coachSurface: Color(0x0A000000),
  );

  static const dark = PhoenixPillarColors(
    training: PhoenixColors.darkTextPrimary,
    fasting: PhoenixColors.darkTextPrimary,
    conditioning: PhoenixColors.darkTextPrimary,
    biomarkers: PhoenixColors.darkTextPrimary,
    coach: PhoenixColors.darkTextPrimary,
    trainingSurface: Color(0x14FFFFFF),
    fastingSurface: Color(0x14FFFFFF),
    conditioningSurface: Color(0x14FFFFFF),
    biomarkersSurface: Color(0x14FFFFFF),
    coachSurface: Color(0x14FFFFFF),
  );

  @override
  PhoenixPillarColors copyWith({
    Color? training,
    Color? fasting,
    Color? conditioning,
    Color? biomarkers,
    Color? coach,
    Color? trainingSurface,
    Color? fastingSurface,
    Color? conditioningSurface,
    Color? biomarkersSurface,
    Color? coachSurface,
  }) {
    return PhoenixPillarColors(
      training: training ?? this.training,
      fasting: fasting ?? this.fasting,
      conditioning: conditioning ?? this.conditioning,
      biomarkers: biomarkers ?? this.biomarkers,
      coach: coach ?? this.coach,
      trainingSurface: trainingSurface ?? this.trainingSurface,
      fastingSurface: fastingSurface ?? this.fastingSurface,
      conditioningSurface: conditioningSurface ?? this.conditioningSurface,
      biomarkersSurface: biomarkersSurface ?? this.biomarkersSurface,
      coachSurface: coachSurface ?? this.coachSurface,
    );
  }

  @override
  PhoenixPillarColors lerp(ThemeExtension<PhoenixPillarColors>? other, double t) {
    if (other is! PhoenixPillarColors) return this;
    return PhoenixPillarColors(
      training: Color.lerp(training, other.training, t)!,
      fasting: Color.lerp(fasting, other.fasting, t)!,
      conditioning: Color.lerp(conditioning, other.conditioning, t)!,
      biomarkers: Color.lerp(biomarkers, other.biomarkers, t)!,
      coach: Color.lerp(coach, other.coach, t)!,
      trainingSurface: Color.lerp(trainingSurface, other.trainingSurface, t)!,
      fastingSurface: Color.lerp(fastingSurface, other.fastingSurface, t)!,
      conditioningSurface: Color.lerp(conditioningSurface, other.conditioningSurface, t)!,
      biomarkersSurface: Color.lerp(biomarkersSurface, other.biomarkersSurface, t)!,
      coachSurface: Color.lerp(coachSurface, other.coachSurface, t)!,
    );
  }
}

// ─── Convenience accessor ────────────────────────────────────────

extension PhoenixPillarColorsExt on BuildContext {
  PhoenixPillarColors get pillar =>
      Theme.of(this).extension<PhoenixPillarColors>() ??
      PhoenixPillarColors.light;
}

// ─── TDesign Theme Data — Brutalist B/W ──────────────────────────

class PhoenixTDTheme {
  PhoenixTDTheme._();

  static TDThemeData get lightData {
    final base = TDThemeData.defaultData();
    return base.copyWithTDThemeData(
      'phoenixLight',
      colorMap: {
        // Brand — black on white (brutalist gray scale)
        'brandColor1': const Color(0xFFF7F7F7),
        'brandColor2': const Color(0xFFEFEFEF),
        'brandColor3': const Color(0xFFDFDFDF),
        'brandColor4': const Color(0xFFC8C8C8),
        'brandColor5': const Color(0xFFA0A0A0),
        'brandColor6': const Color(0xFF585858),
        'brandColor7': const Color(0xFF000000),
        'brandColor8': const Color(0xFF181818),
        'brandColor9': const Color(0xFF0C0C0C),
        'brandColor10': const Color(0xFF000000),

        // Explicit brand state colors — pure B/W brutalist
        'brandNormalColor': const Color(0xFF000000),
        'brandActiveColor': const Color(0xFF181818),
        'brandDisabledColor': const Color(0xFFC8C8C8),

        // Background
        'bgColorPage': PhoenixColors.lightBg,
        'bgColorContainer': PhoenixColors.lightSurface,
        'bgColorSecondaryContainer': PhoenixColors.lightElevated,
        'bgColorComponent': PhoenixColors.lightElevated,

        // Text
        'textColorPrimary': PhoenixColors.lightTextPrimary,
        'textColorSecondary': PhoenixColors.lightTextSecondary,
        'textColorPlaceholder': PhoenixColors.lightTextTertiary,
        'textColorDisabled': PhoenixColors.lightTextQuaternary,

        // Borders
        'componentStrokeColor': PhoenixColors.lightBorder,
        'componentBorderColor': PhoenixColors.lightBorderStrong,

        // Semantic
        'successNormalColor': PhoenixColors.success,
        'warningNormalColor': PhoenixColors.warning,
        'errorNormalColor': PhoenixColors.error,
      },
    );
  }

  static TDThemeData get darkData {
    final defaultLight = TDThemeData.defaultData();
    final baseDark = defaultLight.dark ?? defaultLight;
    return baseDark.copyWithTDThemeData(
      'phoenixDark',
      colorMap: {
        // Brand — white on black (brutalist gray scale)
        'brandColor1': const Color(0xFF0C0C0C),
        'brandColor2': const Color(0xFF181818),
        'brandColor3': const Color(0xFF282828),
        'brandColor4': const Color(0xFF383838),
        'brandColor5': const Color(0xFF585858),
        'brandColor6': const Color(0xFFA0A0A0),
        'brandColor7': const Color(0xFFFFFFFF),
        'brandColor8': const Color(0xFFDFDFDF),
        'brandColor9': const Color(0xFFC8C8C8),
        'brandColor10': const Color(0xFFA0A0A0),

        // Explicit brand state colors — dark default maps
        // brandNormalColor→brandColor8 (gray), we need pure white.
        'brandNormalColor': const Color(0xFFFFFFFF),
        'brandActiveColor': const Color(0xFFDFDFDF),
        'brandDisabledColor': const Color(0xFF383838),

        // Background
        'bgColorPage': PhoenixColors.darkBg,
        'bgColorContainer': PhoenixColors.darkSurface,
        'bgColorSecondaryContainer': PhoenixColors.darkElevated,
        'bgColorComponent': PhoenixColors.darkElevated,

        // Text
        'textColorPrimary': PhoenixColors.darkTextPrimary,
        'textColorSecondary': PhoenixColors.darkTextSecondary,
        'textColorPlaceholder': PhoenixColors.darkTextTertiary,
        'textColorDisabled': PhoenixColors.darkTextQuaternary,

        // Borders
        'componentStrokeColor': PhoenixColors.darkBorder,
        'componentBorderColor': PhoenixColors.darkBorderStrong,

        // Semantic
        'successNormalColor': PhoenixColors.success,
        'warningNormalColor': PhoenixColors.warning,
        'errorNormalColor': PhoenixColors.error,
      },
    );
  }
}

// ─── Italian resource delegate ───────────────────────────────────

class PhoenixResourceDelegate extends TDResourceDelegate {
  @override String get open => 'Apri';
  @override String get close => 'Chiudi';
  @override String get badgeZero => '0';
  @override String get cancel => 'Annulla';
  @override String get confirm => 'Conferma';
  @override String get other => 'Altro';
  @override String get reset => 'Ripristina';
  @override String get loading => 'Caricamento';
  @override String get loadingWithPoint => 'Caricamento...';
  @override String get knew => 'OK';
  @override String get refreshing => 'Aggiornamento';
  @override String get releaseRefresh => 'Rilascia per aggiornare';
  @override String get pullToRefresh => 'Trascina per aggiornare';
  @override String get completeRefresh => 'Aggiornamento completato';
  @override String get days => 'g';
  @override String get hours => 'h';
  @override String get minutes => 'min';
  @override String get seconds => 's';
  @override String get milliseconds => 'ms';
  @override String get yearLabel => 'Anno';
  @override String get monthLabel => 'Mese';
  @override String get dateLabel => 'Giorno';
  @override String get weeksLabel => 'Settimana';
  @override String get sunday => 'Dom';
  @override String get monday => 'Lun';
  @override String get tuesday => 'Mar';
  @override String get wednesday => 'Mer';
  @override String get thursday => 'Gio';
  @override String get friday => 'Ven';
  @override String get saturday => 'Sab';
  @override String get year => ' ';
  @override String get january => 'Gennaio';
  @override String get february => 'Febbraio';
  @override String get march => 'Marzo';
  @override String get april => 'Aprile';
  @override String get may => 'Maggio';
  @override String get june => 'Giugno';
  @override String get july => 'Luglio';
  @override String get august => 'Agosto';
  @override String get september => 'Settembre';
  @override String get october => 'Ottobre';
  @override String get november => 'Novembre';
  @override String get december => 'Dicembre';
  @override String get time => 'Ora';
  @override String get start => 'Inizio';
  @override String get end => 'Fine';
  @override String get notRated => 'Non valutato';
  @override String get cascadeLabel => 'Seleziona';
  @override String get back => 'Indietro';
  @override String get top => 'In alto';
  @override String get emptyData => 'Nessun dato';
}
