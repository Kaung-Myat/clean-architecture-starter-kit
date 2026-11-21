import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/env/env.dart';

part 'home_controller.g.dart';

/// Sample home state — demonstrates offline/error UI + reconnect refresh.
@riverpod
class HomeController extends _$HomeController {
  @override
  Future<String> build() async {
    // Simulated load. Replace with a real usecase.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return 'Welcome to ${Env.appName} (${Env.activeFlavor.name})';
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
