import 'package:flutter/material.dart';

/// A user-selectable pastel background for a single [Task] — the same
/// Google Keep-style color coding Echoes uses for notes (this file is its
/// note_colors.dart with Note→Task renamed), not a theme setting: each task
/// picks its own, independent of light/dark mode. `null` on [Task.color]
/// means "no override, use the app's normal surface color", which is why
/// this enum itself has no "none"/"default" member — that state is the
/// absence of a [TaskColor], not a member of it.
enum TaskColor { yellow, red, purple, blue, green, orange, white }

extension TaskColorSwatch on TaskColor {
  /// The Material Design "200"-weight swatches — one step more saturated
  /// than the initial "100" pick (too washed-out per user feedback), still
  /// squarely pastel rather than a highlighter/neon tone.
  Color get background => switch (this) {
    TaskColor.yellow => const Color(0xFFFFF59D),
    TaskColor.red => const Color(0xFFEF9A9A),
    TaskColor.purple => const Color(0xFFCE93D8),
    TaskColor.blue => const Color(0xFF90CAF9),
    TaskColor.green => const Color(0xFFA5D6A7),
    TaskColor.orange => const Color(0xFFFFCC80),
    TaskColor.white => const Color(0xFFFFFFFF),
  };

  /// The color to render *text* in in front of [background] — see
  /// [readableTextColorOn] for how this is decided.
  Color get onBackground => readableTextColorOn(background);
}

/// Picks whichever of pure black or pure white gives the higher contrast
/// ratio against [background], per the WCAG 2.x definitions: relative
/// luminance via [Color.computeLuminance] (Flutter's own implementation of
/// the WCAG relative-luminance formula), then contrast ratio
/// `(lighter + 0.05) / (darker + 0.05)`. Always picking the *better* of
/// the two — rather than a fixed luminance threshold — means this stays
/// correct even for a custom/future color this app didn't anticipate, not
/// just the seven built-in [TaskColor]s.
Color readableTextColorOn(Color background) {
  final bgLuminance = background.computeLuminance();
  final contrastWithBlack = _contrastRatio(bgLuminance, 0.0);
  final contrastWithWhite = _contrastRatio(bgLuminance, 1.0);
  return contrastWithBlack >= contrastWithWhite ? Colors.black : Colors.white;
}

double _contrastRatio(double luminanceA, double luminanceB) {
  final lighter = luminanceA > luminanceB ? luminanceA : luminanceB;
  final darker = luminanceA > luminanceB ? luminanceB : luminanceA;
  return (lighter + 0.05) / (darker + 0.05);
}

/// A muted counterpart of [TaskColor.onBackground] for de-emphasized text
/// on a colored task (due dates, tags) — same idea as
/// `colorScheme.onSurfaceVariant` next to `colorScheme.onSurface`, just
/// derived from the task's own color instead of the theme.
Color mutedTextColorOn(Color background) {
  final base = readableTextColorOn(background);
  return Color.alphaBlend(base.withValues(alpha: 0.6), background);
}
