import 'package:dio/dio.dart';

import '../../../../core/network/api_routes.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Production auth remote — always goes through [ApiService].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      url: ApiRoutes.login,
      data: {'email': email, 'password': password},
      options: Options(
        extra: {
          kSkipAuthExtra: true,
          kSkip401Redirect: true,
        },
      ),
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final response = await _apiService.post(
      url: ApiRoutes.googleLogin,
      options: Options(
        extra: {
          kSkipAuthExtra: true,
          kSkip401Redirect: true,
        },
      ),
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
