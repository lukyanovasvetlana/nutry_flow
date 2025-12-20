import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../../../config/supabase_config.dart';
import 'dart:developer' as developer;

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<bool> isUserLoggedIn();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      developer.log('🔐 AuthRemoteDataSource: Starting signin for \$email', name: 'auth_remote_data_source');

      // Проверяем демо-режим
      final isDemo = SupabaseConfig.isDemo;
      developer.log('🔐 AuthRemoteDataSource: Demo mode = \$isDemo', name: 'auth_remote_data_source');

      if (isDemo) {
        developer.log('🔐 AuthRemoteDataSource: Demo mode detected, simulating signin', name: 'auth_remote_data_source');

        // Симулируем успешный вход в демо-режиме
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

        developer.log('🔐 AuthRemoteDataSource: Demo signin successful for \$email', name: 'auth_remote_data_source');
        return UserModel.fromSupabaseUser(demoUser);
      }

      // Реальный вход через Supabase
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to sign in: No user returned');
      }

      return UserModel.fromSupabaseUser(response.user);
    } catch (e) {
      developer.log('🔐 AuthRemoteDataSource: Signin failed: \$e', name: 'auth_remote_data_source');
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      developer.log('🔐 AuthRemoteDataSource: Starting signup for \$email', name: 'auth_remote_data_source');

      // Проверяем демо-режим
      final isDemo = SupabaseConfig.isDemo;
      developer.log('🔐 AuthRemoteDataSource: Demo mode = \$isDemo', name: 'auth_remote_data_source');

      if (isDemo) {
        developer.log('🔐 AuthRemoteDataSource: Demo mode detected, simulating signup', name: 'auth_remote_data_source');

        // Симулируем успешную регистрацию в демо-режиме
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

        developer.log('🔐 AuthRemoteDataSource: Demo signup successful for \$email', name: 'auth_remote_data_source');
        return UserModel.fromSupabaseUser(demoUser);
      }

      // Реальная регистрация через Supabase
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to sign up: No user returned');
      }

      return UserModel.fromSupabaseUser(response.user);
    } catch (e) {
      developer.log('🔐 AuthRemoteDataSource: Signup failed: \$e', name: 'auth_remote_data_source');
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final session = _supabase.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }
}
