import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../env/env.dart';
import '../storage/secure_storage.dart';
import '../utils/logger/app_logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';

/// A single [Dio] with tight timeouts and the interceptor chain.
///
/// Interceptor **order matters**: LoggerInterceptor → AuthInterceptor.
/// (No pre-flight connectivity gate and no retry interceptor by design — see
/// ABOUT-ARCHI §5. Offline state is driven by the actual request failing.)
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  final secureStorage = ref.watch(secureStorageProvider);

  dio.interceptors.addAll([
    LoggerInterceptor(),
    AuthInterceptor(
      secureStorage: secureStorage,
      onSessionExpired: () async {
        // Clear credentials. Navigation to the login screen is a presentation
        // concern — wire it via a listener or NavigationService if desired.
        await secureStorage.clearTokens();
        AppLogger.w('Session expired — tokens cleared.');
      },
    ),
  ]);

  return dio;
});
