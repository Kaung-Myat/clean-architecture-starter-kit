import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_frame_starter/core/network/exceptions/api_exception.dart';
import 'package:clean_frame_starter/core/storage/secure_storage.dart';
import 'package:clean_frame_starter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clean_frame_starter/features/auth/data/models/user_model.dart';
import 'package:clean_frame_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clean_frame_starter/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource remote;
  late MockSecureStorage secureStorage;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    secureStorage = MockSecureStorage();
    repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      secureStorage: secureStorage,
    );
  });

  const model = UserModel(
    id: 'e-1',
    email: 'a@b.com',
    authType: 'Traditional',
    name: 'Ann',
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  test('maps model to entity and persists tokens on email sign-in', () async {
    when(
      () => remote.signInWithEmail(email: any(named: 'email'), password: any(named: 'password')),
    ).thenAnswer((_) async => model);
    when(
      () => secureStorage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});

    final entity = await repository.signInWithEmail('a@b.com', '123456');

    expect(
      entity,
      const UserEntity(
        id: 'e-1',
        email: 'a@b.com',
        authType: 'Traditional',
        name: 'Ann',
      ),
    );
    verify(
      () => secureStorage.saveTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      ),
    ).called(1);
  });

  test('propagates ApiException from remote', () async {
    when(
      () => remote.signInWithEmail(email: any(named: 'email'), password: any(named: 'password')),
    ).thenThrow(const ApiException(statusCode: 401, message: 'Invalid'));

    expect(
      () => repository.signInWithEmail('a@b.com', 'bad'),
      throwsA(isA<ApiException>()),
    );
    verifyNever(
      () => secureStorage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    );
  });
}
