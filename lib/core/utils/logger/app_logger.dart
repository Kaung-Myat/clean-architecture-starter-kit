import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// App-wide logger. **Use `AppLogger.d/i/w/e` instead of `print`/`debugPrint`.**
///
/// Logging is suppressed in release builds.
class AppLogger {
  const AppLogger._();

  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(dynamic message) => _logger.d(message);
  static void i(dynamic message) => _logger.i(message);
  static void w(dynamic message) => _logger.w(message);
  static void e(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
