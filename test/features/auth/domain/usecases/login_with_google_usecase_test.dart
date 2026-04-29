import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_di_test/features/auth/domain/entities/user_entity.dart';
import 'package:riverpod_di_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_di_test/features/auth/domain/usecases/login_with_google_usecase.dart';

// Building Mock Class

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginWithGoogleUseCase useCase;
  late MockAuthRepository mockRepository;

  // Before each test, this setUp function works first (same with init function)
  setUp(() {
    mockRepository = MockAuthRepository();
    // Injecting the mock repository to the use case
    useCase = LoginWithGoogleUseCase(mockRepository);
  });

  // Mock data for testing
  final tUser = UserEntity(id: 'g-123', email: 'test@google.com', authType: 'Google', name: 'Test User');

  test("should return UserEntity when google sign in is successful", () async {
    //A - Arrange
    //Setting up the mock repository to return the mock user when signInWithGoogle is called
    when(() => mockRepository.signInWithGoogle()).thenAnswer((_) async => tUser);

    //A - Act
    final result = await useCase();

    //A - Assert
    // Verifying that the result from the use case is the same as the mock user we set up earlier
    expect(result, tUser);

    // Verifying that the signInWithGoogle method of the repository was called exactly once during the test
    verify(() => mockRepository.signInWithGoogle()).called(1);

    // Verifying that there are no more interactions with the mock repository after the expected method calls have been verified (no need to call other methods or interactions with the mock repository that were not part of the test)
    verifyNoMoreInteractions(mockRepository);
  });
}
