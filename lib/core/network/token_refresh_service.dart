import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import '../utils/logger/app_logger.dart';
import 'api_routes.dart';

/// Calls `/auth/refresh` on a bare [Dio] (no auth interceptor) to avoid loops.
class TokenRefreshService {
  TokenRefreshService({
    required Dio bareDio,
    required SecureStorage secureStorage,
  })  : _dio = bareDio,
        _secureStorage = secureStorage;

  final Dio _dio;
  final SecureStorage _secureStorage;

  /// Returns `true` when new tokens were persisted.
  Future<bool> refresh() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      AppLogger.w('Token refresh skipped — no refresh token.');
      return false;
    }

    try {
      final response = await _dio.post<dynamic>(
        ApiRoutes.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) return false;

      final access = (data['access_token'] ?? data['accessToken'])?.toString();
      final refresh = (data['refresh_token'] ?? data['refreshToken'])?.toString();
      if (access == null || access.isEmpty) return false;

      await _secureStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh,
      );
      AppLogger.i('Access token refreshed.');
      return true;
    } on DioException catch (e) {
      AppLogger.e('Token refresh failed', error: e);
      return false;
    } catch (e, st) {
      AppLogger.e('Token refresh failed', error: e, stackTrace: st);
      return false;
    }
  }
}
