import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger/app_logger.dart';

/// Contract for resolving a push registration token.
///
/// **Boilerplate only** — default impl is [NoOpFcmService] (no Firebase deps).
/// To enable real FCM, see [docs/ENABLE_FCM.md].
abstract interface class FcmService {
  /// Returns a push token, or `null` if unavailable / not wired.
  Future<String?> getToken();
}

/// Default kit implementation — safe without `google-services` / Firebase.
class NoOpFcmService implements FcmService {
  @override
  Future<String?> getToken() async {
    AppLogger.d(
      'FcmService boilerplate: getToken() → null '
      '(wire Firebase — see docs/ENABLE_FCM.md)',
    );
    return null;
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) => NoOpFcmService());
