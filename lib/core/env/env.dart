/// Environment configuration via `--dart-define` / `--dart-define-from-file`.
///
/// ```
/// flutter run \
///   --dart-define=API_URL=https://api.example.com \
///   --dart-define=ENV=dev \
///   --dart-define=DEMO_MODE=false
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

  /// When `true` (default), auth uses [DemoAuthRemoteDataSource] so the kit
  /// runs without a backend. Set `DEMO_MODE=false` for real API calls.
  static const bool demoMode = bool.fromEnvironment(
    'DEMO_MODE',
    defaultValue: true,
  );

  static bool get isConfigured => baseUrl.isNotEmpty;

  static bool get isProd => env == 'prod';
}
