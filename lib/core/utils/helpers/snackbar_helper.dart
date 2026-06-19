import 'package:flutter/material.dart';

/// Thin wrapper over [ScaffoldMessenger] for one-off messages.
/// For richer toasts use `AppToast` (shared/widgets).
class SnackbarHelper {
  const SnackbarHelper._();

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static void error(BuildContext context, String message) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: scheme.onError)),
          backgroundColor: scheme.error,
        ),
      );
  }
}
