import 'dart:async';

import 'package:dio/dio.dart';

import '../../storage/secure_storage.dart';
import '../../utils/logger/app_logger.dart';

/// `Options.extra` flag: skip attaching `Authorization` (e.g. on `/login`).
const String kSkipAuthExtra = 'skip_auth';

/// `Options.extra` flag: a 401 here means "wrong credentials", not "session
/// expired" — don't refresh / redirect.
const String kSkip401Redirect = 'skip_401_redirect';

/// Internal: request already retried once after a refresh.
const String kRetriedAfterRefresh = 'retried_after_refresh';

/// Attaches the bearer token; on 401 tries refresh → retry once, else session expired.
///
/// This kit ships bearer-token auth only. Cookie auth (`CookieManager` +
/// `cookie_jar`) can be layered in front of this interceptor if needed.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required SecureStorage secureStorage,
    required Future<bool> Function() refreshTokens,
    required Future<void> Function() onSessionExpired,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _refreshTokens = refreshTokens,
        _onSessionExpired = onSessionExpired;

  final Dio _dio;
  final SecureStorage _secureStorage;
  final Future<bool> Function() _refreshTokens;
  final Future<void> Function() _onSessionExpired;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pending = [];

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
    final alreadyRetried =
        err.requestOptions.extra[kRetriedAfterRefresh] == true;

    if (!isUnauthorized || skipRedirect || alreadyRetried) {
      handler.next(err);
      return;
    }

    final request = err.requestOptions;

    if (_isRefreshing) {
      try {
        final response = await _enqueue(request);
        handler.resolve(response);
      } on DioException catch (e) {
        handler.next(e);
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    _isRefreshing = true;
    AppLogger.w('401 → attempting token refresh…');

    final refreshed = await _refreshTokens();
    _isRefreshing = false;

    if (!refreshed) {
      AppLogger.w('401 → refresh failed, clearing session');
      await _onSessionExpired();
      _rejectPending(err);
      handler.next(err);
      return;
    }

    try {
      final response = await _retry(request);
      _resolvePending();
      handler.resolve(response);
    } on DioException catch (e) {
      _rejectPending(e);
      handler.next(e);
    }
  }

  Future<Response<dynamic>> _enqueue(RequestOptions request) {
    final completer = Completer<Response<dynamic>>();
    _pending.add(_PendingRequest(request, completer));
    return completer.future;
  }

  void _resolvePending() {
    final queued = List<_PendingRequest>.from(_pending);
    _pending.clear();
    for (final item in queued) {
      _retry(item.request).then(item.completer.complete).catchError((Object e) {
        item.completer.completeError(e);
      });
    }
  }

  void _rejectPending(DioException err) {
    final queued = List<_PendingRequest>.from(_pending);
    _pending.clear();
    for (final item in queued) {
      item.completer.completeError(err);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions request) async {
    final token = await _secureStorage.getAccessToken();
    final headers = Map<String, dynamic>.from(request.headers);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final options = Options(
      method: request.method,
      headers: headers,
      responseType: request.responseType,
      contentType: request.contentType,
      extra: {
        ...request.extra,
        kRetriedAfterRefresh: true,
      },
    );

    return _dio.request<dynamic>(
      request.path,
      data: request.data,
      queryParameters: request.queryParameters,
      options: options,
    );
  }
}

class _PendingRequest {
  _PendingRequest(this.request, this.completer);

  final RequestOptions request;
  final Completer<Response<dynamic>> completer;
}
