import 'package:flutter/material.dart';

/// A user-selectable sheet for a single [Task]. `null` on [Task.color] means
/// "no override, use the desk paper".
///
/// The names are the persisted values (`color.name` in the task JSON).
/// Renaming them would make existing tasks fail to load, including on an
/// older install that syncs with this one. The swatches are the same
/// stained-glass sheets Echoes uses for the shared names.
enum TaskColor { yellow, red, purple, blue, green, orange, white }

extension TaskColorSwatch on TaskColor {
  /// Saturated enough to read as a color, still light enough that
  /// [onBackground] clears WCAG AA. Names stay the stored enum values.
  Color get background => switch (this) {
    TaskColor.white => const Color(0xFFFFF4E8),
    TaskColor.yellow => const Color(0xFFFFC44D),
    TaskColor.green => const Color(0xFF8BE3A8),
    TaskColor.orange => const Color(0xFFFF8F6B),
    TaskColor.purple => const Color(0xFFD4B0FF),
    TaskColor.blue => const Color(0xFF8EB0FF),
    TaskColor.red => const Color(0xFFFF8FA3),
  };

  /// The color to render text in on top of [background].
  Color get onBackground => readableTextColorOn(background);
}

/// Picks whichever of black or white gives the higher contrast ratio against
/// [background], per WCAG 2.x: relative luminance via [Color.computeLuminance],
/// then `(lighter + 0.05) / (darker + 0.05)`.
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

/// Body and metadata ink on a colored task. As soft as it can be while still
/// clearing WCAG AA (4.5:1) against [background]. A fixed blend looked pale
/// on gold, coral and lilac and disappeared into the sheet.
Color mutedTextColorOn(Color background) {
  final ink = readableTextColorOn(background);
  var lo = 0.0;
  var hi = 1.0;
  var best = ink;
  for (var i = 0; i < 10; i++) {
    final mid = (lo + hi) / 2;
    final candidate = Color.alphaBlend(ink.withValues(alpha: mid), background);
    final ratio = _contrastRatio(
      candidate.computeLuminance(),
      background.computeLuminance(),
    );
    if (ratio >= 4.5) {
      best = candidate;
      hi = mid;
    } else {
      lo = mid;
    }
  }
  return best;
}
