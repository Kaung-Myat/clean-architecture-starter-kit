import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailUseCase {
  const LoginWithEmailUseCase({required IAuthRepository repository}) : _repository = repository;
  final IAuthRepository _repository;

  Future<UserEntity> call(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }
}
