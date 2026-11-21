import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_screen.dart';
import '../../../shared/widgets/offline_screen.dart';
import '../../network/exceptions/api_exception.dart';
import '../../network/exceptions/network_exception.dart';

/// Convention: map typed errors to shared offline / error UIs.
extension AsyncValueUiX<T> on AsyncValue<T> {
  Widget whenApp({
    required Widget Function(T data) data,
    required VoidCallback onRetry,
    Widget Function()? loading,
    String? offlineMessage,
    String? errorMessage,
  }) {
    return when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: data,
      loading: loading ??
          () => const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        if (error is NetworkException) {
          return OfflineScreen(
            onRetry: onRetry,
            message: offlineMessage ?? error.message,
          );
        }
        if (error is ApiException && error.isServerError) {
          return ErrorScreen(
            onRetry: onRetry,
            message: errorMessage ?? error.message,
          );
        }
        return ErrorScreen(
          onRetry: onRetry,
          message: errorMessage ?? error.toString(),
        );
      },
    );
  }
}
