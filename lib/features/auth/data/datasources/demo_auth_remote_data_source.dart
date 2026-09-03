import '../../../../core/network/exceptions/api_exception.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Offline demo auth — no network. Selected when [Env.demoMode] is true.
///
/// Keeps the same contract as [AuthRemoteDataSourceImpl] so DI can swap them
/// without touching domain or presentation.
class DemoAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (password != '123456') {
      throw const ApiException(
        statusCode: 401,
        message: 'Invalid email or password.',
      );
    }
    return UserModel(
      id: 'e-456',
      email: email,
      authType: 'Traditional',
      name: 'Demo User',
      accessToken: 'demo-access-token',
      refreshToken: 'demo-refresh-token',
    );
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const UserModel(
      id: 'g-123',
      email: 'dev@google.com',
      authType: 'Google',
      name: 'Demo Google User',
      accessToken: 'demo-google-access-token',
      refreshToken: 'demo-google-refresh-token',
    );
  }
}
