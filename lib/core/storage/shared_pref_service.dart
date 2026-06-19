import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Placeholder provider — **overridden in `main.dart`** with the resolved
/// [SharedPreferences] instance (composition root, see ABOUT-ARCHI §3/§4).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

final sharedPrefServiceProvider = Provider<SharedPrefService>((ref) {
  return SharedPrefService(ref.watch(sharedPreferencesProvider));
});

/// Typed wrapper over [SharedPreferences] for app-level preferences.
class SharedPrefService {
  const SharedPrefService(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'theme_mode';
  static const _kLocale = 'locale';

  // Theme: stored as ThemeMode.index.
  int? get themeModeIndex => _prefs.getInt(_kThemeMode);
  Future<void> setThemeModeIndex(int index) => _prefs.setInt(_kThemeMode, index);

  // Locale.
  String? get localeCode => _prefs.getString(_kLocale);
  Future<void> setLocaleCode(String code) => _prefs.setString(_kLocale, code);

  Future<void> clear() => _prefs.clear();
}
