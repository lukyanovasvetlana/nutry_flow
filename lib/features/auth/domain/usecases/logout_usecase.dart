import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> call() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
