import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/kairos_theme.dart';

/// A quiet atmospheric environment behind content. It has no animation and
/// keeps all blur bounded to the surfaces that explicitly opt into it.
class KairosAtmosphere extends StatelessWidget {
  const KairosAtmosphere({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = kairosTokensOf(context);
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: tokens.environment),
        IgnorePointer(
          child: RepaintBoundary(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -1.0),
                  radius: 1.25,
                  colors: [
                    primary.withValues(alpha: 0.13),
                    primary.withValues(alpha: 0.025),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.42, 1],
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: RepaintBoundary(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(1.0, 0.75),
                  radius: 1.15,
                  colors: [
                    secondary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Bounded glass surface. Do not wrap long scrolling content in this widget:
/// the blur is deliberately local to keep scrolling inexpensive.
class KairosGlassSurface extends StatelessWidget {
  const KairosGlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.strong = false,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool strong;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = kairosTokensOf(context);
    final radius = borderRadius ?? BorderRadius.circular(KairosRadii.md);
    final fill = color ?? (strong ? tokens.strongSurface : tokens.surface);
    return RepaintBoundary(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: strong
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: Theme.of(context).brightness == Brightness.dark
                          ? 0.18
                          : 0.06,
                    ),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: tokens.blurSigma,
              sigmaY: tokens.blurSigma,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: radius,
                border: Border.all(color: tokens.border),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tokens.highlight.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
            ),
          ),
        ),
      ),
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
                letterSpacing: 0.4,
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
    return Semantics(
      button: true,
      toggled: value,
      label: semanticLabel,
      child: InkResponse(
        radius: 26,
        onTap: () => onChanged(!value),
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: AnimatedContainer(
              duration: KairosMotion.quick,
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
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.28),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedSwitcher(
                duration: KairosMotion.quick,
                child: value
                    ? Icon(
                        Icons.check,
                        key: const ValueKey('done'),
                        size: 16,
                        color: scheme.onPrimary,
                      )
                    : const SizedBox(key: ValueKey('pending')),
              ),
            ),
          ),
        ),
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
    final tokens = kairosTokensOf(context);
    return Semantics(
      button: true,
      label: tooltip,
      child: RepaintBoundary(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: tokens.accentGlow,
                blurRadius: 22,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            tooltip: tooltip,
            onPressed: onPressed,
            elevation: 0,
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        ),
      ),
    );
  }
}
