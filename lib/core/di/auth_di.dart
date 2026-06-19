import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/datasources/auth_remote_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_with_email_usecase.dart';
import '../../features/auth/domain/usecases/login_with_google_usecase.dart';

// Datasource
final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSource();
});

// Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remoteSource = ref.watch(authRemoteSourceProvider);
  return AuthRepositoryImpl(remoteSource: remoteSource);
});

// Usecases
final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogleUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginWithGoogleUseCase(repository: repository);
});

final loginWithEmailUseCaseProvider = Provider<LoginWithEmailUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginWithEmailUseCase(repository: repository);
});
