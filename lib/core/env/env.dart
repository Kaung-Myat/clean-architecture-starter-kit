/// Environment configuration.
///
/// Values are supplied at build time via `--dart-define` (or
/// `--dart-define-from-file=.env`). This keeps the starter kit dependency-free;
/// swap in `flutter_dotenv` if you prefer a runtime `.env` file.
///
/// Example:
/// ```
/// flutter run --dart-define=API_URL=https://api.example.com --dart-define=ENV=dev
/// ```
class Env {
  const Env._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Clean Architecture Starter',
  );

  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static const String firebaseKey = String.fromEnvironment('FIREBASE_KEY');

  /// Whether a real API base URL has been configured (vs the fallback).
  static bool get isConfigured => baseUrl.isNotEmpty;

  static bool get isProd => env == 'prod';
}
