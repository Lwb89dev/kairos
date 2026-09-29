import 'package:flutter/material.dart';

import 'task_colors.dart';

/// Spacing, radii and motion shared by every Kairos surface.
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
  static const lg = 24.0;
  static const pill = 999.0;
}

abstract final class KairosMotion {
  static const quick = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 280);
  static const curve = Curves.easeOutCubic;

  /// [Duration.zero] when the platform asks for reduced motion. The state
  /// change still happens; only the flourish is skipped.
  static Duration of(BuildContext context, Duration duration) {
    final media = MediaQuery.maybeOf(context);
    if (media?.disableAnimations == true) return Duration.zero;
    return duration;
  }
}

/// Desk colours shared with Echoes and Astraea. Dark is its own iris night,
/// not an inversion of the light paper. Screens read these instead of
/// inventing hex values.
class KairosPalette {
  const KairosPalette({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.surfacePaper,
    required this.surfaceElevated,
    required this.surfacePressed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.borderSubtle,
    required this.shadowSoft,
    required this.semanticError,
    required this.onAccent,
    required this.accentContainer,
    required this.onAccentContainer,
    required this.glow,
  });

  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color surfacePaper;
  final Color surfaceElevated;
  final Color surfacePressed;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color borderSubtle;
  final Color shadowSoft;
  final Color semanticError;
  final Color onAccent;
  final Color accentContainer;
  final Color onAccentContainer;
  final List<Color> glow;

  /// Iris. Kept as [accent] so a caller that only needs the seed still
  /// compiles.
  static const accent = Color(0xFF6A35F0);
  static const coral = Color(0xFFFF4F78);

  static const light = KairosPalette(
    backgroundPrimary: Color(0xFFF6EEFF),
    backgroundSecondary: Color(0xFFFFE4F1),
    surfacePaper: Color(0xFFF8F2FF),
    surfaceElevated: Color(0xFFFFF7FB),
    surfacePressed: Color(0xFFE7D8FF),
    textPrimary: Color(0xFF1C1233),
    textSecondary: Color(0xFF3A2A58),
    textMuted: Color(0xFF4A3868),
    accentPrimary: accent,
    accentSecondary: coral,
    borderSubtle: Color(0x66FFFFFF),
    shadowSoft: Color(0xFF3A1870),
    semanticError: Color(0xFFC6284A),
    onAccent: Color(0xFFFFFFFF),
    accentContainer: Color(0xFFE9DCFF),
    onAccentContainer: Color(0xFF2A1166),
    glow: lightGlow,
  );

  static const dark = KairosPalette(
    backgroundPrimary: Color(0xFF160C28),
    backgroundSecondary: Color(0xFF2A1244),
    surfacePaper: Color(0xFF241438),
    surfaceElevated: Color(0xFF321C4C),
    surfacePressed: Color(0xFF1C1030),
    textPrimary: Color(0xFFF8F2FF),
    textSecondary: Color(0xFFE4D8FF),
    textMuted: Color(0xFFD2C4F2),
    accentPrimary: Color(0xFFC4A6FF),
    accentSecondary: Color(0xFFFF8AA8),
    borderSubtle: Color(0x55FFFFFF),
    shadowSoft: Color(0xFF000000),
    semanticError: Color(0xFFFF8A9E),
    onAccent: Color(0xFF2A1160),
    accentContainer: Color(0xFF3A2270),
    onAccentContainer: Color(0xFFF3E9FF),
    glow: darkGlow,
  );

  /// Aurora behind the glass. Light stops stay pale so dark ink still reads;
  /// dark stops stay deep so light ink still reads.
  static const lightGlow = <Color>[
    Color(0xFFFFD0E6),
    Color(0xFFE4D0FF),
    Color(0xFFFFE0C4),
    Color(0xFFD4E2FF),
  ];

  static const darkGlow = <Color>[
    Color(0xFF2A0E44),
    Color(0xFF4A1868),
    Color(0xFF6A2458),
    Color(0xFF1A1860),
  ];

  static KairosPalette of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? KairosPalette.dark : KairosPalette.light;
  }
}

/// The wash every screen sits on. Scaffolds stay transparent so this shows
/// through frosted chrome.
class KairosBackdrop extends StatelessWidget {
  const KairosBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final glow = KairosPalette.of(context).glow;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: glow,
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Top-to-bottom gloss. A task card and an opened task both paint this, so
/// opening a task is the card at full size rather than a flat fill.
LinearGradient kairosSheetGradient(Color tint) {
  final lightInk = readableTextColorOn(tint) == Colors.white;
  final wash = lightInk ? 0.10 : 0.42;
  final top = Color.alphaBlend(Colors.white.withValues(alpha: wash), tint);
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, tint],
  );
}

/// Night desk keeps light type on a tint that already wants it. A bright
/// tint that would force black text is left alone — that is a stained-glass
/// sheet, and it stays that color in both themes. A tint that wants white
/// but fails it on the lighter end of the gloss is deepened until white
/// clears both ends.
Color kairosSheetTint(Color tint, {required bool dark}) {
  if (!dark) return tint;
  if (readableTextColorOn(tint) != Colors.white) return tint;
  return kairosDarkTint(tint);
}

Color kairosDarkTint(Color tint) {
  var current = tint;
  for (var step = 0; step < 16; step++) {
    if (_whiteClearsGloss(current)) return current;
    current = Color.alphaBlend(const Color(0x1F000000), current);
  }
  return current;
}

bool _whiteClearsGloss(Color tint) {
  // A little above 4.5: the ink that actually gets painted is not pure
  // white, and the lighter end of the gloss is the harder background.
  final top = kairosSheetGradient(tint).colors.first;
  final topClears = _contrast(top.computeLuminance(), 1) >= 4.8;
  final baseClears = _contrast(tint.computeLuminance(), 1) >= 4.8;
  return topClears && baseClears;
}

/// The gloss stop where [ink] has the weaker contrast.
Color kairosHardestStop(Color tint, Color ink) {
  final top = kairosSheetGradient(tint).colors.first;
  final topRatio = _contrast(top.computeLuminance(), ink.computeLuminance());
  final baseRatio = _contrast(tint.computeLuminance(), ink.computeLuminance());
  return topRatio < baseRatio ? top : tint;
}

double _contrast(double luminanceA, double luminanceB) {
  final lighter = luminanceA > luminanceB ? luminanceA : luminanceB;
  final darker = luminanceA > luminanceB ? luminanceB : luminanceA;
  return (lighter + 0.05) / (darker + 0.05);
}

BoxDecoration kairosGlossDecoration({
  required Color tint,
  required bool dark,
  BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(KairosRadii.md),
  ),
  bool border = true,
  List<BoxShadow>? shadow,
}) {
  final edge = dark ? const Color(0x66FFFFFF) : const Color(0xEEFFFFFF);
  return BoxDecoration(
    borderRadius: borderRadius,
    gradient: kairosSheetGradient(tint),
    border: border ? Border.all(color: edge) : null,
    boxShadow: shadow,
  );
}

ThemeData buildKairosTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final palette = dark ? KairosPalette.dark : KairosPalette.light;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: palette.accentPrimary,
        brightness: brightness,
      ).copyWith(
        primary: palette.accentPrimary,
        onPrimary: palette.onAccent,
        primaryContainer: palette.accentContainer,
        onPrimaryContainer: palette.onAccentContainer,
        secondary: palette.accentSecondary,
        onSecondary: dark ? const Color(0xFF3A1020) : Colors.white,
        secondaryContainer: dark
            ? const Color(0xFF4A2040)
            : const Color(0xFFFFD6E4),
        onSecondaryContainer: dark
            ? const Color(0xFFFFE4EE)
            : const Color(0xFF5A1830),
        error: palette.semanticError,
        onError: dark ? const Color(0xFF2C1210) : Colors.white,
        surface: palette.backgroundPrimary,
        onSurface: palette.textPrimary,
        onSurfaceVariant: palette.textSecondary,
        surfaceContainerLowest: palette.surfacePaper,
        surfaceContainerLow: palette.backgroundSecondary,
        surfaceContainer: dark ? palette.surfacePaper : palette.surfacePressed,
        surfaceContainerHigh: palette.surfaceElevated,
        surfaceContainerHighest: palette.surfacePressed,
        outline: palette.textMuted,
        outlineVariant: palette.borderSubtle,
        shadow: palette.shadowSoft,
      );
  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: Colors.transparent,
  );
  final text = base.textTheme.apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );
  final headline = text.headlineSmall?.copyWith(
    fontFamily: 'serif',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );
  final inputBorder = _inputBorder(
    scheme.outlineVariant.withValues(alpha: 0.7),
  );
  return base.copyWith(
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontFamily: 'serif',
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
      ),
      headlineSmall: headline,
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KairosRadii.md),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KairosRadii.lg),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.5),
      space: 1,
      thickness: 1,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KairosRadii.md),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      hintStyle: TextStyle(color: palette.textMuted),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: KairosSpacing.md,
        vertical: 15,
      ),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: _inputBorder(scheme.primary, width: 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: KairosSpacing.lg,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KairosRadii.sm),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(
          horizontal: KairosSpacing.lg,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KairosRadii.sm),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0,
      highlightElevation: 0,
      shape: const CircleBorder(),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KairosRadii.sm),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(KairosRadii.lg),
        ),
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );
}

OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(KairosRadii.md),
    borderSide: BorderSide(color: color, width: width),
  );
}
