import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:gotrue/src/types/user.dart' as gotrue;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../services/supabase_service.dart';

/// Реализация репозитория для аутентификации
/// Использует Supabase Auth для управления пользователями
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseService _supabaseService;
  
  AuthRepositoryImpl(this._supabaseService);
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      final supabaseUser = _supabaseService.getCurrentUser();
      
      if (supabaseUser == null) return null;
      
      return User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        firstName: supabaseUser.userMetadata?['first_name'] as String?,
        lastName: supabaseUser.userMetadata?['last_name'] as String?,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User> signUp(String email, String password) async {
    print('🔥 AuthRepositoryImpl: signUp called - THIS SHOULD NOT HAPPEN IN DEMO MODE!');
    try {
      final response = await _supabaseService.signUp(email, password);
      
      if (response.user == null) {
        throw Exception('Не удалось создать пользователя');
      }
      
      return User(
        id: response.user!.id,
        email: response.user!.email ?? email,
        firstName: response.user!.userMetadata?['first_name'] as String?,
        lastName: response.user!.userMetadata?['last_name'] as String?,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('🔥 AuthRepositoryImpl: signUp error: $e');
      throw Exception('Ошибка регистрации: ${e.toString()}');
    }
  }
  
  @override
  Future<User> signIn(String email, String password) async {
    print('🔥 AuthRepositoryImpl: signIn called - THIS SHOULD NOT HAPPEN IN DEMO MODE!');
    try {
      final response = await _supabaseService.signIn(email, password);
      
      if (response.user == null) {
        throw Exception('Не удалось войти в систему');
      }
      
      return User(
        id: response.user!.id,
        email: response.user!.email ?? email,
        firstName: response.user!.userMetadata?['first_name'] as String?,
        lastName: response.user!.userMetadata?['last_name'] as String?,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      print('🔥 AuthRepositoryImpl: signIn error: $e');
      throw Exception('Ошибка входа: ${e.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
    } catch (e) {
      throw Exception('Ошибка выхода: ${e.toString()}');
    }
  }
  
  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.resetPassword(email);
    } catch (e) {
      throw Exception('Ошибка сброса пароля: ${e.toString()}');
    }
  }
} 