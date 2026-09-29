import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/kairos_theme.dart';
import '../../utils/task_colors.dart';

/// Bounded glass. Frost is for chrome (the onboarding bar). A blur on every
/// task card is how a scrolling list gets sticky, so cards use a gloss.
class KairosGlassSurface extends StatelessWidget {
  const KairosGlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.radius = KairosRadii.md,
    this.tint,
    this.frosted = false,
    this.shadow = true,
    this.border = true,
    this.blur = 18,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double radius;
  final Color? tint;
  final bool frosted;
  final bool shadow;
  final bool border;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final shape = borderRadius ?? BorderRadius.circular(radius);
    final fill = tint ?? Theme.of(context).colorScheme.surfaceContainerLowest;
    final paint = tint == null ? fill : kairosSheetTint(fill, dark: dark);
    final face = frosted
        ? _frost(shape, dark)
        : _gloss(context, shape, paint, dark);
    return Container(
      margin: margin,
      decoration: shadow ? _shadow(shape, paint, dark) : null,
      child: face,
    );
  }

  Widget _frost(BorderRadius shape, bool dark) {
    final fill = dark ? const Color(0xCC241438) : const Color(0xBFFFFFFF);
    final edge = dark ? const Color(0x55FFFFFF) : const Color(0xEEFFFFFF);
    return ClipRRect(
      borderRadius: shape,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: shape,
            border: border ? Border.all(color: edge) : null,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: dark ? 0.16 : 0.55),
                fill,
              ],
            ),
          ),
          child: _padded(child),
        ),
      ),
    );
  }

  Widget _gloss(
    BuildContext context,
    BorderRadius shape,
    Color fill,
    bool dark,
  ) {
    final content = Material(
      type: MaterialType.transparency,
      child: _padded(child),
    );
    return ClipRRect(
      borderRadius: shape,
      child: DecoratedBox(
        decoration: kairosGlossDecoration(
          tint: fill,
          dark: dark,
          borderRadius: shape,
          border: border,
        ),
        child: tint == null ? content : _inkTheme(context, fill, content),
      ),
    );
  }

  Widget _padded(Widget content) {
    return Padding(padding: padding ?? EdgeInsets.zero, child: content);
  }

  Widget _inkTheme(BuildContext context, Color fill, Widget content) {
    final theme = Theme.of(context);
    final ink = readableTextColorOn(fill);
    final muted = mutedTextColorOn(kairosHardestStop(fill, ink));
    return _inkScope(
      theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          onSurface: ink,
          onSurfaceVariant: muted,
          outline: muted,
        ),
        textTheme: theme.textTheme.apply(bodyColor: ink, displayColor: ink),
        iconTheme: theme.iconTheme.copyWith(color: muted),
      ),
      content,
    );
  }

  BoxDecoration _shadow(BorderRadius shape, Color fill, bool dark) {
    final color = frosted
        ? Colors.black.withValues(alpha: dark ? 0.28 : 0.08)
        : fill.withValues(alpha: dark ? 0.36 : 0.16);
    return BoxDecoration(
      borderRadius: shape,
      boxShadow: [
        BoxShadow(color: color, blurRadius: 22, offset: const Offset(0, 10)),
      ],
    );
  }
}

/// Full-bleed gloss of [tint]. The child inherits ink that clears that tint,
/// so an opened task is the same sheet as its card.
class KairosSheet extends StatelessWidget {
  const KairosSheet({super.key, required this.tint, required this.child});

  final Color tint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final paint = kairosSheetTint(tint, dark: dark);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: kairosSheetGradient(paint)),
      child: _inkScope(_sheetTheme(Theme.of(context), paint), child),
    );
  }
}

ThemeData _sheetTheme(ThemeData theme, Color tint) {
  final ink = readableTextColorOn(tint);
  final muted = mutedTextColorOn(kairosHardestStop(tint, ink));
  final lightInk = ink == Colors.white;
  final lifted = Color.alphaBlend(
    Colors.white.withValues(alpha: lightInk ? 0.12 : 0.34),
    tint,
  );
  final colors = theme.colorScheme.copyWith(
    surface: tint,
    surfaceContainerLowest: lifted,
    surfaceContainerLow: lifted,
    surfaceContainer: lifted,
    onSurface: ink,
    onSurfaceVariant: muted,
    outline: muted,
  );
  return theme.copyWith(
    colorScheme: colors,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: theme.textTheme.apply(bodyColor: ink, displayColor: ink),
    iconTheme: theme.iconTheme.copyWith(color: ink),
    dividerTheme: theme.dividerTheme.copyWith(
      color: ink.withValues(alpha: 0.22),
    ),
    appBarTheme: theme.appBarTheme.copyWith(
      foregroundColor: ink,
      iconTheme: IconThemeData(color: ink),
      titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(color: ink),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: lightInk ? Brightness.light : Brightness.dark,
        statusBarBrightness: lightInk ? Brightness.dark : Brightness.light,
      ),
    ),
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      fillColor: Colors.white.withValues(alpha: lightInk ? 0.08 : 0.45),
      hintStyle: TextStyle(color: muted),
    ),
  );
}

/// [Theme] updates [Theme.of] but leaves the surrounding [DefaultTextStyle]
/// in place, so a plain [Text] kept the desk ink and disappeared on a
/// colored task. The scope paints that ink onto both.
Widget _inkScope(ThemeData data, Widget child) {
  final ink = data.colorScheme.onSurface;
  final icon = data.iconTheme.color ?? ink;
  return Theme(
    data: data,
    child: DefaultTextStyle.merge(
      style: TextStyle(color: ink),
      child: IconTheme.merge(
        data: IconThemeData(color: icon),
        child: child,
      ),
    ),
  );
}

class KairosFloatingBar extends StatelessWidget {
  const KairosFloatingBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(8, 6, 12, 6),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return KairosGlassSurface(
      radius: KairosRadii.lg,
      padding: padding,
      frosted: true,
      child: child,
    );
  }
}

class KairosSectionHeader extends StatelessWidget {
  const KairosSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KairosSpacing.md,
        KairosSpacing.lg,
        KairosSpacing.md,
        KairosSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class KairosCompletionControl extends StatelessWidget {
  const KairosCompletionControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final motion = KairosMotion.of(context, KairosMotion.quick);
    return Semantics(
      button: true,
      toggled: value,
      label: semanticLabel,
      child: InkResponse(
        radius: 26,
        onTap: () => onChanged(!value),
        child: SizedBox.square(
          dimension: 44,
          child: Center(child: _mark(scheme, motion)),
        ),
      ),
    );
  }

  Widget _mark(ColorScheme scheme, Duration motion) {
    return AnimatedContainer(
      duration: motion,
      curve: KairosMotion.curve,
      width: value ? 25 : 23,
      height: value ? 25 : 23,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value ? scheme.primary : Colors.transparent,
        border: Border.all(
          color: value ? scheme.primary : scheme.outline,
          width: 1.7,
        ),
      ),
      child: AnimatedSwitcher(
        duration: motion,
        child: value
            ? Icon(
                Icons.check,
                key: const ValueKey('done'),
                size: 16,
                color: scheme.onPrimary,
              )
            : const SizedBox(key: ValueKey('pending')),
      ),
    );
  }
}

class KairosFloatingActionButton extends StatelessWidget {
  const KairosFloatingActionButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.35),
              blurRadius: 22,
              spreadRadius: 1,
            ),
          ],
        ),
        child: FloatingActionButton(
          tooltip: tooltip,
          onPressed: onPressed,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }
}
