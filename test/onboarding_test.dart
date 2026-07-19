import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/l10n/app_localizations.dart';
import 'package:kairos/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('first launch presents Kairos and no relay is preselected', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Kairos'), findsOneWidget);

    final pages = find.byType(PageView);
    await tester.drag(pages, const Offset(-700, 0));
    await tester.pumpAndSettle();
    await tester.drag(pages, const Offset(-700, 0));
    await tester.pumpAndSettle();

    expect(find.text('Choose your relays'), findsOneWidget);
    expect(find.text('wss://nos.lol'), findsWidgets);
    expect(find.text('No relays configured.'), findsOneWidget);
  });
}
