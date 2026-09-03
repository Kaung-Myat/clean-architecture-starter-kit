import '../repositories/auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase({required IAuthRepository repository})
      : _repository = repository;

  final IAuthRepository _repository;

  Future<void> call() => _repository.signOut();
}
