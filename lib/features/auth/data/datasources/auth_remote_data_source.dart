import '../models/user_model.dart';

/// Remote auth contract — only data sources talk to the network / demo backend.
abstract interface class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();
}
