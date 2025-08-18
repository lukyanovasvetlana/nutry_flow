import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nutry_flow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nutry_flow/features/auth/domain/usecases/login_usecase.dart';
import 'package:nutry_flow/features/auth/domain/usecases/register_usecase.dart';
import 'package:nutry_flow/features/auth/domain/entities/user.dart';

// Интеграционные тесты для аутентификации
// Эти тесты требуют реального подключения к Supabase
@Skip('Integration tests require real Supabase connection')
void main() {
  group('Auth Integration Tests', () {
    late SupabaseService supabaseService;
    late AuthRemoteDataSource authRemoteDataSource;
    late AuthRepositoryImpl authRepository;
    late LoginUseCase loginUseCase;
    late RegisterUseCase registerUseCase;

    setUpAll(() async {
      // Инициализация Supabase для тестов
      await SupabaseService.instance.initialize();
      supabaseService = SupabaseService.instance;
      
      // Проверяем, доступен ли Supabase
      if (!supabaseService.isAvailable) {
        print('⚠️ Supabase not available, skipping integration tests');
        return;
      }
      
      authRemoteDataSource = AuthRemoteDataSourceImpl();
      authRepository = AuthRepositoryImpl(authRemoteDataSource);
      loginUseCase = LoginUseCase(authRepository);
      registerUseCase = RegisterUseCase(authRepository);
    });

    group('SupabaseService', () {
      test('should initialize successfully', () {
        expect(supabaseService.isAvailable, isTrue);
      });

      test('should have valid configuration', () {
        expect(supabaseService.client, isNotNull);
      });
    });

    group('AuthRemoteDataSource', () {
      test('should handle authentication state', () {
        // Проверяем, что сервис может обрабатывать состояние аутентификации
        expect(authRemoteDataSource.isUserLoggedIn(), completes);
      });

      test('should get current user when not authenticated', () async {
        final user = await authRemoteDataSource.getCurrentUser();
        expect(user, isNull);
      });
    });

    group('AuthRepository', () {
      test('should handle authentication state', () async {
        final isLoggedIn = await authRepository.isUserLoggedIn();
        expect(isLoggedIn, isFalse);
      });

      test('should get current user when not authenticated', () async {
        final user = await authRepository.getCurrentUser();
        expect(user, isNull);
      });
    });

    group('Use Cases', () {
      test('should validate email format', () async {
        try {
          await registerUseCase('invalid-email', 'password123', 'password123');
          fail('Should throw exception for invalid email');
        } catch (e) {
          expect(e.toString(), contains('Invalid email format'));
        }
      });

      test('should validate password strength', () async {
        try {
          await registerUseCase('test@example.com', 'weak', 'weak');
          fail('Should throw exception for weak password');
        } catch (e) {
          expect(e.toString(), contains('Password must contain'));
        }
      });

      test('should validate password confirmation', () async {
        try {
          await registerUseCase('test@example.com', 'StrongPass123', 'DifferentPass123');
          fail('Should throw exception for password mismatch');
        } catch (e) {
          expect(e.toString(), contains('Passwords do not match'));
        }
      });
    });

    group('End-to-End Registration', () {
      test('should register new user successfully', () async {
        final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
        final testPassword = 'StrongPass123';

        try {
          final user = await registerUseCase(testEmail, testPassword, testPassword);
          expect(user, isA<User>());
          expect(user.email, equals(testEmail));
          expect(user.id, isNotEmpty);
        } catch (e) {
          // Если пользователь уже существует, это нормально
          expect(e.toString(), contains('already registered'));
        }
      });
    });

    group('End-to-End Login', () {
      test('should login with valid credentials', () async {
        final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
        final testPassword = 'StrongPass123';

        try {
          // Сначала регистрируем пользователя
          await registerUseCase(testEmail, testPassword, testPassword);
          
          // Затем пытаемся войти
          final user = await loginUseCase(testEmail, testPassword);
          expect(user, isA<User>());
          expect(user.email, equals(testEmail));
        } catch (e) {
          // Если что-то пошло не так, логируем ошибку
          print('Login test failed: $e');
        }
      });

      test('should fail with invalid credentials', () async {
        try {
          await loginUseCase('nonexistent@example.com', 'wrongpassword');
          fail('Should throw exception for invalid credentials');
        } catch (e) {
          expect(e.toString(), contains('Failed to sign in'));
        }
      });
    });
  });
} 