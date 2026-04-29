import 'package:riverpod_di_test/features/auth/data/models/user_model.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_source.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteSource remoteSource;

  AuthRepositoryImpl({required this.remoteSource});

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final data = await remoteSource.emailSignInAPI(email, password);
    return UserModel.fromJson(data).toEntity();
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final data = await remoteSource.googleSignInAPI();
    return UserModel.fromJson(data).toEntity();
  }
}
