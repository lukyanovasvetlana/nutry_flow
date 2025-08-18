import '../entities/user.dart';

/// Интерфейс репозитория для аутентификации пользователей
abstract class AuthRepository {
  /// Получает текущего аутентифицированного пользователя
  /// Возвращает пользователя или null, если не аутентифицирован
  Future<User?> getCurrentUser();

  /// Регистрирует нового пользователя
  /// [email] - email пользователя
  /// [password] - пароль пользователя
  /// Возвращает зарегистрированного пользователя
  Future<User> signUp(String email, String password);

  /// Выполняет вход пользователя
  /// [email] - email пользователя
  /// [password] - пароль пользователя
  /// Возвращает аутентифицированного пользователя
  Future<User> signIn(String email, String password);

  /// Выполняет выход пользователя
  Future<void> signOut();

  /// Отправляет письмо для сброса пароля
  /// [email] - email пользователя
  Future<void> resetPassword(String email);
}
