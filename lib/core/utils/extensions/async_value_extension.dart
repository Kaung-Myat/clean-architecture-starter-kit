import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../network/exceptions/api_exception.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  bool get isServerError {
    final err = error;
    return err is ApiException && err.isServerError;
  }
}

extension RefToastExtension on WidgetRef {
  /// Fires a toast once per *new* 5xx error emitted by [provider].
  ///
  /// Call inside `build`:
  /// ```dart
  /// ref.listenServerErrorToast(myAsyncProvider, context);
  /// ```
  ///
  /// `provider` is taken as [Object] because Riverpod 3 does not export the
  /// `ProviderListenable` type; pass any provider whose value is an
  /// `AsyncValue<...>`.
  void listenServerErrorToast(Object provider, BuildContext context) {
    listen<AsyncValue<Object?>>(
      provider as dynamic,
      (previous, next) {
        if (next.isServerError && previous?.error != next.error) {
          AppToast.serverError(context);
        }
      },
    );
  }
}
