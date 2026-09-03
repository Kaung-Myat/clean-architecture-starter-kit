import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/env/env.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/auth_remote_data_source_impl.dart';
import '../data/datasources/demo_auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_with_email_usecase.dart';
import '../domain/usecases/login_with_google_usecase.dart';
import '../domain/usecases/logout_usecase.dart';

/// Feature-scoped DI (composition for auth).
///
/// Lives next to the feature so `core/` never imports `features/`.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (Env.demoMode) {
    return DemoAuthRemoteDataSource();
  }
  return AuthRemoteDataSourceImpl(
    apiService: ref.watch(apiServiceProvider),
  );
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogleUseCase>((ref) {
  return LoginWithGoogleUseCase(
    repository: ref.watch(authRepositoryProvider),
  );
});

final loginWithEmailUseCaseProvider = Provider<LoginWithEmailUseCase>((ref) {
  return LoginWithEmailUseCase(
    repository: ref.watch(authRepositoryProvider),
  );
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(repository: ref.watch(authRepositoryProvider));
});
