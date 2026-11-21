import 'app_flavor.dart';

/// Environment configuration via `--dart-define` / `--dart-define-from-file`.
///
/// ```bash
/// flutter run --dart-define-from-file=env/dev.json
/// flutter run --dart-define-from-file=env/uat.json
/// flutter run --dart-define-from-file=env/prod.json
/// ```
class Env {
  const Env._();

  static const String _flavorName = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static const String _apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Clean Architecture Starter',
  );

  static const String firebaseKey = String.fromEnvironment('FIREBASE_KEY');

  /// When `true` (default), auth uses demo datasource.
  static const bool demoMode = bool.fromEnvironment(
    'DEMO_MODE',
    defaultValue: true,
  );

  /// Compile-time flavor (from `FLAVOR` define).
  static AppFlavor get flavor => AppFlavor.fromName(_flavorName);

  /// Mutable override for runtime switches (e.g. debug UAT toggle).
  static AppFlavor _activeFlavor = flavor;

  static AppFlavor get activeFlavor => _activeFlavor;

  static void useFlavor(AppFlavor value) => _activeFlavor = value;

  /// Prefer per-flavor defaults when `API_URL` is left at the placeholder.
  static String baseUrlFor(AppFlavor flavor) {
    if (_apiUrl.isNotEmpty &&
        _apiUrl != 'https://jsonplaceholder.typicode.com') {
      return _apiUrl;
    }
    return switch (flavor) {
      AppFlavor.dev => 'https://api-dev.example.com',
      AppFlavor.uat => 'https://api-uat.example.com',
      AppFlavor.prod => 'https://api.example.com',
    };
  }

  static String get baseUrl => baseUrlFor(_activeFlavor);

  static String get env => activeFlavor.name;

  static bool get isConfigured => baseUrl.isNotEmpty;

  static bool get isDev => activeFlavor == AppFlavor.dev;
  static bool get isUat => activeFlavor == AppFlavor.uat;
  static bool get isProd => activeFlavor == AppFlavor.prod;
}
