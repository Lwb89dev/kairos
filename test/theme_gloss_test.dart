import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/screens/widgets/kairos_glass.dart';
import 'package:kairos/utils/kairos_theme.dart';
import 'package:kairos/utils/task_colors.dart';

void main() {
  test('a sheet gloss is a vertical gradient, not a flat fill', () {
    const tints = [
      KairosPalette.accent,
      KairosPalette.coral,
      Color(0xFF2196F3),
    ];
    for (final tint in tints) {
      final gradient = kairosSheetGradient(tint);
      expect(gradient.begin, Alignment.topCenter);
      expect(gradient.end, Alignment.bottomCenter);
      expect(gradient.colors.last, tint);
      expect(gradient.colors.first, isNot(tint));
    }
  });

  test('a bright blue deepens on the night desk until white type fits', () {
    const blue = Color(0xFF2196F3);
    final paint = kairosDarkTint(blue);
    final gradient = kairosSheetGradient(paint);
    expect(readableTextColorOn(paint), Colors.white);
    expect(
      _ratio(gradient.colors.first, Colors.white),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _ratio(gradient.colors.last, Colors.white),
      greaterThanOrEqualTo(4.5),
    );
    expect(kairosDarkTint(KairosPalette.accent), KairosPalette.accent);
  });

  test('a light stained-glass sheet stays its own color at night', () {
    final paint = kairosSheetTint(TaskColor.yellow.background, dark: true);
    expect(paint, TaskColor.yellow.background);
    expect(readableTextColorOn(paint), Colors.black);
  });

  test('iris takes light ink and coral takes dark ink', () {
    expect(readableTextColorOn(KairosPalette.accent), Colors.white);
    expect(readableTextColorOn(KairosPalette.coral), Colors.black);
    expect(
      _ratio(KairosPalette.accent, Colors.white),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _ratio(KairosPalette.coral, Colors.black),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('every task color keeps readable text on both ends of the gloss', () {
    for (final color in TaskColor.values) {
      final background = color.background;
      final ink = color.onBackground;
      final gradient = kairosSheetGradient(background);
      expect(
        _ratio(gradient.colors.first, ink),
        greaterThanOrEqualTo(4.5),
        reason: '${color.name} gloss',
      );
      expect(
        _ratio(gradient.colors.last, ink),
        greaterThanOrEqualTo(4.5),
        reason: color.name,
      );
      final muted = mutedTextColorOn(kairosHardestStop(background, ink));
      expect(
        _ratio(kairosHardestStop(background, ink), muted),
        greaterThanOrEqualTo(4.5),
        reason: '${color.name} muted',
      );
    }
  });

  test('desk ink stays readable on the paper and on the aurora', () {
    void check(KairosPalette palette) {
      final inks = [
        palette.textPrimary,
        palette.textSecondary,
        palette.textMuted,
      ];
      final grounds = [palette.surfacePaper, ...palette.glow];
      for (final ground in grounds) {
        for (final ink in inks) {
          expect(
            _ratio(ground, ink),
            greaterThanOrEqualTo(4.5),
            reason:
                '${ink.toARGB32().toRadixString(16)} on ${ground.toARGB32().toRadixString(16)}',
          );
        }
      }
    }

    check(KairosPalette.light);
    check(KairosPalette.dark);
  });

  testWidgets('opening a sheet uses the card gloss, and only frost blurs', (
    tester,
  ) async {
    const tint = KairosPalette.accent;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKairosTheme(Brightness.light),
        home: const Scaffold(
          body: Stack(
            children: [
              KairosBackdrop(),
              Column(
                children: [
                  KairosGlassSurface(frosted: true, child: Text('Today')),
                  KairosGlassSurface(
                    key: Key('card'),
                    tint: tint,
                    shadow: false,
                    child: Text('Standup'),
                  ),
                  KairosSheet(
                    key: Key('sheet'),
                    tint: tint,
                    child: SizedBox(height: 40, width: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(
      _gradient(tester, find.byKey(const Key('card'))),
      kairosSheetGradient(tint),
    );
    expect(
      _gradient(tester, find.byKey(const Key('sheet'))),
      kairosSheetGradient(tint),
    );
    final backdrop = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(KairosBackdrop),
        matching: find.byType(DecoratedBox),
      ),
    );
    final painted = backdrop.decoration as BoxDecoration;
    expect(painted.gradient, isA<LinearGradient>());
    expect(
      (painted.gradient! as LinearGradient).colors,
      KairosPalette.light.glow,
    );
  });

  testWidgets('an iris sheet in the dark theme writes in light ink', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKairosTheme(Brightness.dark),
        home: Scaffold(
          body: KairosSheet(
            tint: KairosPalette.accent,
            child: Scaffold(
              body: Builder(
                builder: (context) => Text(
                  'Descrizione',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final element = tester.element(find.text('Descrizione'));
    final painted = (element.widget as Text).style?.color;
    final gradient = _gradient(tester, find.byType(KairosSheet));
    expect(painted, isNotNull);
    expect(painted!.computeLuminance(), greaterThan(0.5));
    expect(_ratio(gradient.colors.first, painted), greaterThanOrEqualTo(4.5));
    expect(_ratio(gradient.colors.last, painted), greaterThanOrEqualTo(4.5));
  });
}

Gradient _gradient(WidgetTester tester, Finder host) {
  final box = tester.widget<DecoratedBox>(
    find.descendant(of: host, matching: find.byType(DecoratedBox)).first,
  );
  final decoration = box.decoration as BoxDecoration;
  return decoration.gradient!;
}

double _ratio(Color background, Color ink) {
  final lighter = background.computeLuminance() > ink.computeLuminance()
      ? background.computeLuminance()
      : ink.computeLuminance();
  final darker = background.computeLuminance() > ink.computeLuminance()
      ? ink.computeLuminance()
      : background.computeLuminance();
  return (lighter + 0.05) / (darker + 0.05);
}
