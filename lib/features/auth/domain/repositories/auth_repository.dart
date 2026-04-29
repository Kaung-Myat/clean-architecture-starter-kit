import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithEmail(String email, String password);
}
