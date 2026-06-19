// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/di/auth_providers.dart';
// import '../../domain/entities/user_entity.dart';

// class AuthController extends AsyncNotifier<UserEntity?> {
//   @override
//   Future<UserEntity?> build() async => null;

//   Future<void> loginWithGoogle() async {
//     state = const AsyncLoading();
//     final googleLogin = ref.read(loginWithGoogleUseCaseProvider);
//     state = await AsyncValue.guard(() => googleLogin());
//   }

//   Future<void> loginWithEmail(String email, String password) async {
//     state = const AsyncLoading();
//     final emailLogin = ref.read(loginWithEmailUseCaseProvider);
//     state = await AsyncValue.guard(() => emailLogin(email, password));
//   }

//   void logout() {
//     state = const AsyncData(null);
//   }

//   void updateName(String newName) {
//     // Check if the current state has a value and that the value is not null
//     if (state.hasValue && state.value != null) {
//       final updatedUser = state.value!.copyWith(name: newName);
//       // Update state
//       state = AsyncData(updatedUser);
//     }
//   }
// }

// final authControllerProvider = AsyncNotifierProvider.autoDispose<AuthController, UserEntity?>(() {
//   return AuthController();
// });

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/auth_di.dart';
import '../../domain/entities/user_entity.dart';

// ၁။ Generator က ထုတ်ပေးမည့် ဖိုင်ကို လှမ်းချိတ်ခြင်း
part 'auth_controller.g.dart';

// ၂။ @riverpod annotation တပ်ပေးခြင်း
@riverpod
class AuthController extends _$AuthController {
  // ၃။ build() method သည် ကနဦး State ကို သတ်မှတ်ပေးသည် (null အဖြစ် စတင်မည်)
  @override
  FutureOr<UserEntity?> build() async {
    return null;
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    final googleLogin = ref.read(loginWithGoogleUseCaseProvider);
    state = await AsyncValue.guard(() => googleLogin());
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();
    final emailLogin = ref.read(loginWithEmailUseCaseProvider);
    state = await AsyncValue.guard(() => emailLogin(email, password));
  }

  void logout() {
    state = const AsyncData(null);
  }

  void updateName(String newName) {
    if (state.hasValue && state.value != null) {
      final updatedUser = state.value!.copyWith(name: newName);
      state = AsyncData(updatedUser);
    }
  }
}
