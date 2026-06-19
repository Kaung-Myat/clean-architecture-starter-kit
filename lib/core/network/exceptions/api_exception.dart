import 'package:dio/dio.dart';

/// Thrown when the server responded (any non-2xx) — i.e. a [Response] exists.
///
/// Propagates up to the notifier where Riverpod captures it as `AsyncError`.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.errors = const {},
  });

  final int statusCode;
  final String message;

  /// Field-level validation errors, e.g. `{ "email": ["is required"] }`.
  final Map<String, List<String>> errors;

  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;
  bool get isUnauthorized => statusCode == 401;

  /// First validation message, if any — handy for inline form errors.
  String? get firstValidationError {
    for (final list in errors.values) {
      if (list.isNotEmpty) return list.first;
    }
    return null;
  }

  factory ApiException.fromResponse(Response response) {
    final data = response.data;
    final status = response.statusCode ?? 0;

    if (data is Map<String, dynamic>) {
      return ApiException(
        statusCode: status,
        message: (data['message'] ?? data['error'] ?? 'Something went wrong')
            .toString(),
        errors: _parseErrors(data['errors']),
      );
    }

    // Non-JSON body (e.g. an HTML 500 page).
    return ApiException.fromHtmlResponse(status, data?.toString());
  }

  factory ApiException.fromHtmlResponse(int statusCode, String? body) {
    return ApiException(
      statusCode: statusCode,
      message: statusCode >= 500
          ? 'Server error. Please try again later.'
          : 'Request failed (HTTP $statusCode).',
    );
  }

  static Map<String, List<String>> _parseErrors(dynamic raw) {
    if (raw is! Map) return const {};
    return raw.map(
      (key, value) => MapEntry(
        key.toString(),
        value is List
            ? value.map((e) => e.toString()).toList()
            : [value.toString()],
      ),
    );
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
