import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/auth_providers.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserEntity?> build() async => null;

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    final googleLogin = ref.read(loginWithGoogleUseCaseProvider);
    state = await AsyncValue.guard(googleLogin.call);
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();
    final emailLogin = ref.read(loginWithEmailUseCaseProvider);
    state = await AsyncValue.guard(() => emailLogin(email, password));
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call();
    state = const AsyncData(null);
  }

  void updateName(String newName) {
    final user = state.asData?.value;
    if (user == null) return;
    state = AsyncData(user.copyWith(name: newName));
  }
}
