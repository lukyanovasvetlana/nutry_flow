import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Результат выполнения SignInUseCase
class SignInResult {
  final User? user;
  final String? error;
  final bool isSuccess;

  SignInResult._({
    this.user,
    this.error,
    required this.isSuccess,
  });

  factory SignInResult.success(User user) {
    return SignInResult._(
      user: user,
      isSuccess: true,
    );
  }

  factory SignInResult.failure(String error) {
    return SignInResult._(
      error: error,
      isSuccess: false,
    );
  }
}

/// Use case для входа пользователя
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  /// Выполняет вход пользователя
  Future<SignInResult> execute(String email, String password) async {
    try {
      // Валидация входных данных
      if (email.isEmpty || password.isEmpty) {
        return SignInResult.failure('Email and password are required');
      }

      // Валидация формата email
      if (!_isValidEmail(email)) {
        return SignInResult.failure('Invalid email format');
      }

      // Выполняем вход
      final user = await _authRepository.signIn(email, password);

      return SignInResult.success(user);
    } catch (e) {
      return SignInResult.failure('Sign in failed: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
