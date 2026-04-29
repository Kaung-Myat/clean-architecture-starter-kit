import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailUseCase {
  final IAuthRepository repository;
  LoginWithEmailUseCase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.signInWithEmail(email, password);
  }
}
