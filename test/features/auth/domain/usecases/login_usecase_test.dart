import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:nutry_flow/features/auth/domain/entities/user.dart';
import 'package:nutry_flow/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutry_flow/features/auth/domain/usecases/login_usecase.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testUser = User(
      id: '1',
      email: testEmail,
    );

    test('should return user when login is successful', () async {
      // arrange
      when(mockAuthRepository.signIn(testEmail, testPassword))
          .thenAnswer((_) async => testUser);

      // act
      final result = await loginUseCase(testEmail, testPassword);

      // assert
      expect(result, equals(testUser));
      verify(mockAuthRepository.signIn(testEmail, testPassword)).called(1);
    });

    test('should throw exception when email is empty', () async {
      // act & assert
      expect(
        () => loginUseCase('', testPassword),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when password is empty', () async {
      // act & assert
      expect(
        () => loginUseCase(testEmail, ''),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when email format is invalid', () async {
      // act & assert
      expect(
        () => loginUseCase('invalid-email', testPassword),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when password is too short', () async {
      // act & assert
      expect(
        () => loginUseCase(testEmail, '123'),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when repository throws', () async {
      // arrange
      when(mockAuthRepository.signIn(testEmail, testPassword))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () => loginUseCase(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
    });
  });
} 