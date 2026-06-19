import '../entities/user_entity.dart';

abstract interface class IAuthRepository {
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithEmail(String email, String password);
}
