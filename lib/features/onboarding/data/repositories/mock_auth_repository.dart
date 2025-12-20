import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

/// Мок-реализация репозитория аутентификации для разработки
/// Имитирует работу с Supabase без реального подключения
class MockAuthRepository implements AuthRepository {
  static User? _currentUser;
  static final Map<String, String> _users = {}; // email -> password
  static const _uuid = Uuid();

  /// Создает тестового пользователя для демонстрации
  static void createTestUser() {
    _users['test@example.com'] = 'password123';
  }

  @override
  Future<User?> getCurrentUser() async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<User> signUp(String email, String password) async {
    developer.log('🔵 MockAuthRepository: signUp called for \$email', name: 'mock_auth_repository');
    developer.log('🔵 MockAuthRepository: signUp called for $email',
        name: 'MockAuthRepository');

    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 1000));

    // Проверяем, не существует ли уже пользователь
    if (_users.containsKey(email)) {
      developer.log('🔵 MockAuthRepository: User already exists', name: 'mock_auth_repository');
      developer.log('🔵 MockAuthRepository: User already exists',
          name: 'MockAuthRepository');
      throw Exception('Пользователь с таким email уже существует');
    }

    // Создаем нового пользователя
    _users[email] = password;
    final user = User(
      id: _uuid.v4(),
      email: email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _currentUser = user;
    developer.log('🔵 MockAuthRepository: signUp successful for \$email', name: 'mock_auth_repository');
    developer.log('🔵 MockAuthRepository: signUp successful for $email',
        name: 'MockAuthRepository');
    return user;
  }

  @override
  Future<User> signIn(String email, String password) async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 800));

    // Проверяем учетные данные
    if (!_users.containsKey(email) || _users[email] != password) {
      throw Exception('Неверный email или пароль');
    }

    final user = User(
      id: _uuid.v4(),
      email: email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  @override
  Future<void> resetPassword(String email) async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!_users.containsKey(email)) {
      throw Exception('Пользователь с таким email не найден');
    }

    // В реальном приложении здесь была бы отправка email
    // Для демо просто имитируем успешную отправку
  }
}
