import 'package:flutter/material.dart';

import '../../core/utils/extensions/context_extension.dart';

enum _ToastKind { info, success, error }

/// App-wide toast helper built on [ScaffoldMessenger].
class AppToast {
  const AppToast._();

  static void show(BuildContext context, String message) =>
      _show(context, message, _ToastKind.info);

  static void success(BuildContext context, String message) =>
      _show(context, message, _ToastKind.success);

  static void error(BuildContext context, String message) =>
      _show(context, message, _ToastKind.error);

  /// Standard "something went wrong on our end" toast for 5xx errors.
  static void serverError(BuildContext context) => _show(
        context,
        'Server error. Please try again later.',
        _ToastKind.error,
      );

  static void _show(BuildContext context, String message, _ToastKind kind) {
    final scheme = context.colorScheme;
    final (bg, fg) = switch (kind) {
      _ToastKind.info => (scheme.inverseSurface, scheme.onInverseSurface),
      _ToastKind.success => (context.colors.success, Colors.white),
      _ToastKind.error => (scheme.error, scheme.onError),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: fg)),
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
