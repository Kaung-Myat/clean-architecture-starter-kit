import 'dart:io';

import 'package:dio/dio.dart';

/// Thrown when there was **no** server response — timeout, connection error,
/// or a raw [SocketException]. Map this to an offline UI in the presentation
/// layer (`NetworkException → OfflineScreen`).
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection.']);

  final String message;

  factory NetworkException.fromDio(DioException e) {
    final msg = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'The connection timed out.',
      DioExceptionType.connectionError => 'Could not reach the server.',
      _ => e.error is SocketException
          ? 'No internet connection.'
          : 'Network error. Please check your connection.',
    };
    return NetworkException(msg);
  }

  @override
  String toString() => 'NetworkException: $message';
}
