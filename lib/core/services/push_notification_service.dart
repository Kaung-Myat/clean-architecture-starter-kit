import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger/app_logger.dart';

/// Foreground / background push wiring.
///
/// **Boilerplate only** — [init] is a no-op until Firebase is enabled.
/// See [docs/ENABLE_FCM.md] for the real `FirebaseMessaging` steps
/// (permission, foreground display, background handler).
final pushNotificationProvider = Provider<PushNotificationService>((ref) {
  final service = PushNotificationService();
  service.init();
  return service;
});

class PushNotificationService {
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    AppLogger.d(
      'PushNotificationService boilerplate init (no-op). '
      'Enable Firebase — see docs/ENABLE_FCM.md',
    );
  }
}

/// Placeholder for the top-level background handler you register in `main()`
/// after adding `firebase_messaging`.
///
/// ```dart
/// @pragma('vm:entry-point')
/// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
///   // log / handle data payload
/// }
/// ```
Future<void> firebaseMessagingBackgroundHandlerPlaceholder() async {
  AppLogger.d(
    'Background FCM handler placeholder — replace after enabling Firebase',
  );
}
