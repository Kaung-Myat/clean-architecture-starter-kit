import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final model = await _remoteDataSource.signInWithEmail(
      email: email,
      password: password,
    );
    await _persistTokens(model.accessToken, model.refreshToken);
    return model.toEntity();
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final model = await _remoteDataSource.signInWithGoogle();
    await _persistTokens(model.accessToken, model.refreshToken);
    return model.toEntity();
  }

  @override
  Future<void> signOut() => _secureStorage.clearTokens();

  Future<void> _persistTokens(String? accessToken, String? refreshToken) async {
    if (accessToken == null || accessToken.isEmpty) return;
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
