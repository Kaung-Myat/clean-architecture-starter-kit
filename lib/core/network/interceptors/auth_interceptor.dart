import 'package:dio/dio.dart';

import '../../storage/secure_storage.dart';
import '../../utils/logger/app_logger.dart';

/// `Options.extra` flag: skip attaching `Authorization` (e.g. on `/login`).
const String kSkipAuthExtra = 'skip_auth';

/// `Options.extra` flag: a 401 here means "wrong credentials", not "session
/// expired" — don't fire [onSessionExpired].
const String kSkip401Redirect = 'skip_401_redirect';

/// Attaches the bearer token and reacts to session-expiry 401s.
///
/// This kit ships bearer-token auth only. Cookie auth (`CookieManager` +
/// `cookie_jar`) can be layered in front of this interceptor if needed.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureStorage secureStorage,
    required Future<void> Function() onSessionExpired,
  })  : _secureStorage = secureStorage,
        _onSessionExpired = onSessionExpired;

  final SecureStorage _secureStorage;
  final Future<void> Function() _onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[kSkipAuthExtra] != true) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final skipRedirect = err.requestOptions.extra[kSkip401Redirect] == true;

    if (isUnauthorized && !skipRedirect) {
      AppLogger.w('401 → session expired, clearing tokens');
      await _onSessionExpired();
    }
    handler.next(err);
  }
}
