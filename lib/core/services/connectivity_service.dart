import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/localization/generated/translations.g.dart';
import '../../app/router/app_router.dart';
import '../../shared/widgets/app_toast.dart';
import '../utils/logger/app_logger.dart';


/// Emits `true` when the device has any non-none connectivity.
final connectivityStreamProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  final initial = await connectivity.checkConnectivity();
  yield !initial.contains(ConnectivityResult.none);
  yield* connectivity.onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
});

/// Starts a global online/offline toast listener. Watch from [MyApp].
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  service.initialize();
  return service;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  bool? _wasConnected;
  bool _initialized = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = !results.contains(ConnectivityResult.none);
      AppLogger.d('Connectivity changed: $isConnected');

      if (_wasConnected != null && _wasConnected != isConnected) {
        final context = rootNavigatorKey.currentContext;
        if (context != null && context.mounted) {
          final t = context.t;
          if (isConnected) {
            AppToast.success(context, t.common.onlineRestored);
          } else {
            AppToast.error(context, t.common.offline);
          }
        }
      }
      _wasConnected = isConnected;
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
