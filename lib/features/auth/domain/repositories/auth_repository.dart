import '../entities/user.dart';

abstract class AuthRepository {
  /// Вход пользователя с email и паролем
  Future<User> signIn(String email, String password);
  
  /// Регистрация нового пользователя
  Future<User> signUp(String email, String password);
  
  /// Выход пользователя
  Future<void> signOut();
  
  /// Сброс пароля
  Future<void> resetPassword(String email);
  
  /// Проверка, авторизован ли пользователь
  Future<bool> isUserLoggedIn();
  
  /// Получение текущего пользователя
  Future<User?> getCurrentUser();
  
  /// Поток изменений состояния авторизации
  Stream<User?> get authStateChanges;
}
