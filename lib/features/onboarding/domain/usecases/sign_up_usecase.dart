import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'dart:developer' as developer;

/// Результат выполнения SignUpUseCase
class SignUpResult {
  final User? user;
  final String? error;
  final bool isSuccess;

  SignUpResult._({
    this.user,
    this.error,
    required this.isSuccess,
  });

  factory SignUpResult.success(User user) {
    return SignUpResult._(
      user: user,
      isSuccess: true,
    );
  }

  factory SignUpResult.failure(String error) {
    return SignUpResult._(
      error: error,
      isSuccess: false,
    );
  }
}

/// Use case для регистрации пользователя
class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  /// Выполняет регистрацию пользователя
  Future<SignUpResult> execute(String email, String password) async {
    developer.log('🔵 SignUpUseCase: execute called for $email',
        name: 'SignUpUseCase');

    try {
      // Валидация входных данных
      if (email.isEmpty || password.isEmpty) {
        developer.log('🔵 SignUpUseCase: validation failed - empty fields',
            name: 'SignUpUseCase');
        return SignUpResult.failure('Email and password are required');
      }

      // Валидация формата email
      if (!_isValidEmail(email)) {
        developer.log(
            '🔵 SignUpUseCase: validation failed - invalid email format',
            name: 'SignUpUseCase');
        return SignUpResult.failure('Invalid email format');
      }

      // Валидация пароля
      if (password.length < 6) {
        developer.log('🔵 SignUpUseCase: validation failed - password too short',
            name: 'SignUpUseCase');
        return SignUpResult.failure('Password must be at least 6 characters');
      }

      developer.log(
          '🔵 SignUpUseCase: validation passed, calling authRepository.signUp',
          name: 'SignUpUseCase');
      // Выполняем регистрацию
      final user = await _authRepository.signUp(email, password);

      developer.log('🔵 SignUpUseCase: signUp successful',
          name: 'SignUpUseCase');
      return SignUpResult.success(user);
    } catch (e) {
      developer.log('🔵 SignUpUseCase: signUp failed: $e',
          name: 'SignUpUseCase');
      return SignUpResult.failure('Sign up failed: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
