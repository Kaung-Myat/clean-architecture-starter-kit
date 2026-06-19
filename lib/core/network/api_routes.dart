import '../env/env.dart';

/// All endpoint path constants live here — never inline a path at a call site.
class ApiRoutes {
  const ApiRoutes._();

  // Auth
  static const String login = '/login';
  static const String logout = '/logout';
  static const String refreshToken = '/auth/refresh';

  // Example resource
  static const String posts = '/posts';

  /// Builds an absolute URL for a stored asset (e.g. images served by the API).
  static String storageUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = Env.baseUrl.endsWith('/')
        ? Env.baseUrl.substring(0, Env.baseUrl.length - 1)
        : Env.baseUrl;
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return '$base/$clean';
  }
}
