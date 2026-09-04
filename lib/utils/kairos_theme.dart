import 'package:flutter/material.dart';

/// Kairos' visual language. Keep these values in one place so a surface can
/// change without every screen inventing its own opacity or shadow.
abstract final class KairosPalette {
  static const accent = Color(0xFFAA8BFF);
  static const accentDark = Color(0xFF7B5CDB);
  static const darkEnvironment = Color(0xFF0D0B18);
  static const darkSurface = Color(0xFF171525);
  static const lightEnvironment = Color(0xFFF3F4F9);
  static const lightSurface = Color(0xFFFFFFFF);
}

abstract final class KairosSpacing {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class KairosRadii {
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 26.0;
  static const pill = 999.0;
}

abstract final class KairosMotion {
  static const quick = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 240);
  static const curve = Curves.easeOutCubic;
}

/// Theme-dependent tokens used by the glass primitives.
class KairosTokens extends ThemeExtension<KairosTokens> {
  const KairosTokens({
    required this.environment,
    required this.surface,
    required this.strongSurface,
    required this.border,
    required this.highlight,
    required this.accentGlow,
    required this.blurSigma,
  });

  final Color environment;
  final Color surface;
  final Color strongSurface;
  final Color border;
  final Color highlight;
  final Color accentGlow;
  final double blurSigma;

  static const dark = KairosTokens(
    environment: KairosPalette.darkEnvironment,
    surface: Color(0xB8171525),
    strongSurface: Color(0xE61C192D),
    border: Color(0x2FFFFFFF),
    highlight: Color(0x42FFFFFF),
    accentGlow: Color(0x337B5CDB),
    blurSigma: 16,
  );

  static const light = KairosTokens(
    environment: KairosPalette.lightEnvironment,
    surface: Color(0xCFFFFFFF),
    strongSurface: Color(0xF2FFFFFF),
    border: Color(0x260E1020),
    highlight: Color(0xB8FFFFFF),
    accentGlow: Color(0x267B5CDB),
    blurSigma: 14,
  );

  @override
  KairosTokens copyWith({
    Color? environment,
    Color? surface,
    Color? strongSurface,
    Color? border,
    Color? highlight,
    Color? accentGlow,
    double? blurSigma,
  }) {
    return KairosTokens(
      environment: environment ?? this.environment,
      surface: surface ?? this.surface,
      strongSurface: strongSurface ?? this.strongSurface,
      border: border ?? this.border,
      highlight: highlight ?? this.highlight,
      accentGlow: accentGlow ?? this.accentGlow,
      blurSigma: blurSigma ?? this.blurSigma,
    );
  }

  @override
  KairosTokens lerp(ThemeExtension<KairosTokens>? other, double t) {
    if (other is! KairosTokens) return this;
    return KairosTokens(
      environment: Color.lerp(environment, other.environment, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      strongSurface: Color.lerp(strongSurface, other.strongSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      blurSigma: blurSigma + (other.blurSigma - blurSigma) * t,
    );
  }
}

ThemeData buildKairosTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final tokens = dark ? KairosTokens.dark : KairosTokens.light;
  final seed = dark ? KairosPalette.accent : KairosPalette.accentDark;
  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
  );
  final scheme = base.colorScheme.copyWith(
    surface: tokens.environment,
    surfaceContainerLowest: tokens.environment,
    surfaceContainerLow: tokens.surface,
    surfaceContainer: tokens.surface,
    surfaceContainerHigh: tokens.strongSurface,
    surfaceContainerHighest: tokens.strongSurface,
    primary: seed,
    secondary: dark ? const Color(0xFF73D7C4) : const Color(0xFF237F72),
  );
  final foreground = dark ? const Color(0xFFF3F0FF) : const Color(0xFF171525);
  final muted = dark ? const Color(0xFFB5AEC8) : const Color(0xFF686578);

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: tokens.environment,
    extensions: [tokens],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: foreground,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
    ),
    textTheme: base.textTheme
        .apply(bodyColor: foreground, displayColor: foreground)
        .copyWith(
          headlineSmall: TextStyle(
            color: foreground,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
          titleLarge: TextStyle(
            color: foreground,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(
            color: foreground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: foreground, fontSize: 16, height: 1.45),
          bodyMedium: TextStyle(color: foreground, fontSize: 14, height: 1.35),
          bodySmall: TextStyle(color: muted, fontSize: 12, height: 1.35),
          labelLarge: TextStyle(color: foreground, fontWeight: FontWeight.w600),
        ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
        borderSide: BorderSide(color: tokens.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
        borderSide: BorderSide(color: tokens.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      hintStyle: TextStyle(color: muted),
    ),
    cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
    dividerTheme: DividerThemeData(
      color: tokens.border,
      space: 1,
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: tokens.strongSurface,
      contentTextStyle: TextStyle(color: foreground),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: tokens.strongSurface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(KairosRadii.lg),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: tokens.strongSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KairosRadii.md),
      ),
    ),
  );
}

KairosTokens kairosTokensOf(BuildContext context) {
  return Theme.of(context).extension<KairosTokens>() ??
      (Theme.of(context).brightness == Brightness.dark
          ? KairosTokens.dark
          : KairosTokens.light);
}
