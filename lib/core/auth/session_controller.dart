import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/secure_storage.dart';

part 'session_controller.g.dart';

/// Tracks whether the user has a persisted access token.
@riverpod
class SessionController extends _$SessionController {
  @override
  Future<bool> build() async {
    final token = await ref.watch(secureStorageProvider).getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Call after a successful login (tokens already saved by the repository).
  void markAuthenticated() {
    state = const AsyncData(true);
  }

  /// Clears tokens and marks the session logged out.
  Future<void> signOut() async {
    await ref.read(secureStorageProvider).clearTokens();
    state = const AsyncData(false);
  }
}
