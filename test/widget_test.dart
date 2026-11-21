import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_frame_starter/app/app.dart';
import 'package:clean_frame_starter/app/config/localization/generated/translations.g.dart';
import 'package:clean_frame_starter/core/auth/session_controller.dart';
import 'package:clean_frame_starter/core/storage/shared_pref_service.dart';

class _LoggedOutSession extends SessionController {
  @override
  Future<bool> build() async => false;
}

void main() {
  testWidgets('App renders AuthPage login form with autofill fields', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          sessionControllerProvider.overrideWith(_LoggedOutSession.new),
        ],
        child: TranslationProvider(
          child: const MyApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(AutofillGroup), findsOneWidget);
  });
}
