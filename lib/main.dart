import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/config/localization/generated/translations.g.dart';
import 'core/storage/shared_pref_service.dart';

export 'app/app.dart' show MyApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Device locale first; LocaleController may override from SharedPreferences.
  LocaleSettings.useDeviceLocale();

  // Resolve runtime singletons, then inject them via ProviderScope overrides
  // (composition root — see ABOUT-ARCHI §3/§4).
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: TranslationProvider(
        child: const MyApp(),
      ),
    ),
  );
}
