import 'package:dio/dio.dart';

import '../../utils/logger/app_logger.dart';

/// Logs requests, responses, and errors via [AppLogger] (no-op in release).
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.i('→ ${options.method} ${options.uri}');
    if (options.data != null) AppLogger.d('  body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.w(
      '✗ ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.uri}',
    );
    handler.next(err);
  }
}
