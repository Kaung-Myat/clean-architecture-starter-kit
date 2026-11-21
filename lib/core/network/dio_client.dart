import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import '../env/env.dart';
import '../env/flavor_controller.dart';
import '../services/navigation_service.dart';
import '../storage/secure_storage.dart';
import '../utils/logger/app_logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'token_refresh_service.dart';

/// A single [Dio] with timeouts and the interceptor chain.
///
/// Interceptor **order matters**: LoggerInterceptor → AuthInterceptor.
final dioClientProvider = Provider<Dio>((ref) {
  // Rebuild Dio when flavor changes so [baseUrl] stays in sync.
  ref.watch(flavorControllerProvider);

  final baseOptions = BaseOptions(
    baseUrl: Env.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
  );

  final dio = Dio(baseOptions);
  final secureStorage = ref.watch(secureStorageProvider);

  // Bare client for refresh — no auth interceptor (avoids recursion).
  final refreshDio = Dio(baseOptions);
  final tokenRefresh = TokenRefreshService(
    bareDio: refreshDio,
    secureStorage: secureStorage,
  );

  dio.interceptors.addAll([
    LoggerInterceptor(),
    AuthInterceptor(
      dio: dio,
      secureStorage: secureStorage,
      refreshTokens: tokenRefresh.refresh,
      onSessionExpired: () async {
        await ref.read(sessionControllerProvider.notifier).signOut();
        AppLogger.w('Session expired — redirected to auth.');
        NavigationService.goAuth();
      },
    ),
  ]);

  return dio;
});
