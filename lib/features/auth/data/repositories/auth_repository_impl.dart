import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  const AuthRepositoryImpl({required AuthRemoteSource remoteSource}) : _remoteSource = remoteSource;
  final AuthRemoteSource _remoteSource;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final data = await _remoteSource.emailSignInAPI(email, password);
    return UserModel.fromJson(data).toEntity();
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final data = await _remoteSource.googleSignInAPI();
    return UserModel.fromJson(data).toEntity();
  }
}
