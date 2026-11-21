import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/connectivity_service.dart';

/// Call from a [ConsumerState] / [ConsumerWidget] `build` to refresh a
/// notifier when connectivity flips `false → true`.
///
/// ```dart
/// ref.listenReconnectRefresh(myNotifierProvider.notifier.refresh);
/// ```
extension ReconnectRefreshX on WidgetRef {
  void listenReconnectRefresh(Future<void> Function() onReconnect) {
    listen<AsyncValue<bool>>(connectivityStreamProvider, (previous, next) {
      final wasOffline = previous?.asData?.value == false;
      final isOnline = next.asData?.value == true;
      if (wasOffline && isOnline) {
        onReconnect();
      }
    });
  }
}
