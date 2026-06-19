import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  const LoginWithGoogleUseCase({required IAuthRepository repository}) : _repository = repository;
  final IAuthRepository _repository;

  Future<UserEntity> call() {
    return _repository.signInWithGoogle();
  }
}
