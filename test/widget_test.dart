import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_di_test/app/app.dart';
import 'package:riverpod_di_test/core/storage/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App should render AuthPage with Sign In buttons', (tester) async {
    // sharedPreferencesProvider is overridden at the composition root, so the
    // widget test must supply a fake instance too.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Traditional Sign in (Correct)'), findsOneWidget);
  });
}
