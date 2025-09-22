import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import '../../../../config/supabase_config.dart';

/// Сервис аутентификации пользователей
///
/// Предоставляет методы для регистрации, входа и управления сессиями пользователей.
/// Поддерживает как реальную аутентификацию через Supabase, так и демо-режим
/// для разработки и тестирования.
///
/// Пример использования:
/// ```dart
/// final authService = AuthService();
///
/// // Регистрация нового пользователя
/// final response = await authService.signUp(
///   email: 'user@example.com',
///   password: 'secure_password',
/// );
///
/// // Вход существующего пользователя
/// final loginResponse = await authService.signIn(
///   email: 'user@example.com',
///   password: 'secure_password',
/// );
/// ```
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Регистрирует нового пользователя в системе
  ///
  /// [email] - email адрес пользователя (должен быть валидным)
  /// [password] - пароль пользователя (минимум 6 символов)
  ///
  /// Returns [AuthResponse] с данными пользователя и сессии
  ///
  /// Throws [AuthException] при ошибках валидации или сети
  /// Throws [NetworkException] при проблемах с подключением
  ///
  /// В демо-режиме симулирует успешную регистрацию без реального API вызова.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 AuthService: Attempting signup for $email');
      developer.log('🔐 AuthService: Attempting signup for $email',
          name: 'AuthService');

      // Проверяем, находимся ли мы в демо-режиме
      final isDemo = SupabaseConfig.isDemo;
      print('🔐 AuthService: Demo mode = $isDemo');
      developer.log('🔐 AuthService: Demo mode = $isDemo', name: 'AuthService');

      print('🔐 AuthService: Supabase URL = ${SupabaseConfig.url}');
      print('🔐 AuthService: Supabase Anon Key = ${SupabaseConfig.anonKey}');

      if (isDemo) {
        developer.log(
            '🔐 AuthService: Demo mode detected, simulating successful registration',
            name: 'AuthService');

        // Симулируем успешную регистрацию в демо-режиме
        await Future.delayed(
            const Duration(seconds: 1)); // Имитируем задержку сети

        // Создаем демо-пользователя
        final demoUser = User(
          id: 'demo-user-id-${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          role: 'authenticated',
        );

        developer.log('🔐 AuthService: Demo registration successful for $email',
            name: 'AuthService');
        return AuthResponse(session: null, user: demoUser);
      }

      // Реальная регистрация через Supabase
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      developer.log('🔐 AuthService: Signup successful for $email',
          name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('🔐 AuthService: Signup failed for $email: $e',
          name: 'AuthService');
      rethrow;
    }
  }

  /// Выполняет вход пользователя в систему
  ///
  /// [email] - email адрес пользователя
  /// [password] - пароль пользователя
  ///
  /// Returns [AuthResponse] с данными пользователя и сессии
  ///
  /// Throws [AuthException] при ошибках валидации или сети
  /// Throws [NetworkException] при проблемах с подключением
  ///
  /// В демо-режиме симулирует успешный вход без реального API вызова.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('🔐 AuthService: Attempting signin for $email',
          name: 'AuthService');

      // Проверяем демо-режим
      final isDemo = SupabaseConfig.isDemo;
      developer.log('🔐 AuthService: Demo mode = $isDemo', name: 'AuthService');

      if (isDemo) {
        developer.log(
            '🔐 AuthService: Demo mode detected, simulating successful login',
            name: 'AuthService');

        await Future.delayed(const Duration(seconds: 1));

        // Создаем демо-пользователя
        final demoUser = User(
          id: 'demo-user-id-${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          role: 'authenticated',
        );

        developer.log('🔐 AuthService: Demo login successful for $email',
            name: 'AuthService');
        return AuthResponse(session: null, user: demoUser);
      }

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      developer.log('🔐 AuthService: Signin successful for $email',
          name: 'AuthService');
      return response;
    } catch (e) {
      developer.log('🔐 AuthService: Signin failed for $email: $e',
          name: 'AuthService');
      rethrow;
    }
  }

  /// Выполняет выход пользователя из системы
  ///
  /// Throws [NetworkException] при проблемах с подключением
  Future<void> signOut() async {
    try {
      developer.log('🔐 AuthService: Attempting signout', name: 'AuthService');
      await _client.auth.signOut();
      developer.log('🔐 AuthService: Signout successful', name: 'AuthService');
    } catch (e) {
      developer.log('🔐 AuthService: Signout failed: $e', name: 'AuthService');
      rethrow;
    }
  }

  /// Отправляет ссылку для сброса пароля на указанный email
  ///
  /// [email] - email адрес пользователя, для которого нужно сбросить пароль
  ///
  /// Throws [NetworkException] при проблемах с подключением
  Future<void> resetPassword(String email) async {
    try {
      developer.log('🔐 AuthService: Attempting password reset for $email',
          name: 'AuthService');
      await _client.auth.resetPasswordForEmail(email);
      developer.log('🔐 AuthService: Password reset successful for $email',
          name: 'AuthService');
    } catch (e) {
      developer.log('🔐 AuthService: Password reset failed for $email: $e',
          name: 'AuthService');
      rethrow;
    }
  }

  /// Возвращает текущего пользователя, если он авторизован
  User? get currentUser => _client.auth.currentUser;

  /// Возвращает поток событий, которые указывают на изменения состояния аутентификации
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
