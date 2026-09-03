import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_frame_starter/features/auth/domain/entities/user_entity.dart';
import 'package:clean_frame_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_frame_starter/features/auth/domain/usecases/login_with_google_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginWithGoogleUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithGoogleUseCase(repository: mockRepository);
  });

  const tUser = UserEntity(
    id: 'g-123',
    email: 'test@google.com',
    authType: 'Google',
    name: 'Test User',
  );

  test('returns UserEntity when google sign in succeeds', () async {
    when(() => mockRepository.signInWithGoogle()).thenAnswer((_) async => tUser);

    final result = await useCase();

    expect(result, tUser);
    verify(() => mockRepository.signInWithGoogle()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
