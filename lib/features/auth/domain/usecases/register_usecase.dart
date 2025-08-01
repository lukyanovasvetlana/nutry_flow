import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<User> call(String email, String password, String confirmPassword) async {
    // Валидация входных данных
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    if (!_isStrongPassword(password)) {
      throw Exception('Password must contain at least one uppercase letter, one lowercase letter, and one number');
    }

    try {
      return await _authRepository.signUp(email, password);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    
    return hasUppercase && hasLowercase && hasNumbers;
  }
}
