import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nutry_flow/config/supabase_config.dart';
import 'dart:developer' as developer;

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  SupabaseClient? _client;
  
  /// Инициализация Supabase клиента
  Future<void> initialize() async {
    try {
      if (SupabaseConfig.isDemo) {
        developer.log('🟪 SupabaseService: Running in demo mode', name: 'SupabaseService');
        return;
      }
      
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      
      _client = Supabase.instance.client;
      developer.log('🟪 SupabaseService: Initialized successfully', name: 'SupabaseService');
    } catch (e) {
      developer.log('🟪 SupabaseService: Initialization failed: $e', name: 'SupabaseService');
    }
  }
  
  /// Получение клиента Supabase
  SupabaseClient? get client => _client;
  
  /// Проверка, работает ли Supabase
  bool get isAvailable => _client != null && !SupabaseConfig.isDemo;
  
  /// Регистрация пользователя
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      final response = await _client!.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );
      
      developer.log('🟪 SupabaseService: User signed up successfully', name: 'SupabaseService');
      return response;
    } catch (e) {
      developer.log('🟪 SupabaseService: Sign up failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
  
  /// Вход пользователя
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      final response = await _client!.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      developer.log('🟪 SupabaseService: User signed in successfully', name: 'SupabaseService');
      return response;
    } catch (e) {
      developer.log('🟪 SupabaseService: Sign in failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
  
  /// Выход пользователя
  Future<void> signOut() async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      await _client!.auth.signOut();
      developer.log('🟪 SupabaseService: User signed out successfully', name: 'SupabaseService');
    } catch (e) {
      developer.log('🟪 SupabaseService: Sign out failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
  
  /// Сброс пароля
  Future<void> resetPassword(String email) async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      await _client!.auth.resetPasswordForEmail(email);
      developer.log('🟪 SupabaseService: Password reset email sent', name: 'SupabaseService');
    } catch (e) {
      developer.log('🟪 SupabaseService: Password reset failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
  
  /// Получение текущего пользователя
  User? get currentUser => _client?.auth.currentUser;
  
  /// Проверка авторизации
  bool get isAuthenticated => currentUser != null;
  
  /// Слушатель изменений авторизации
  Stream<AuthState> get authStateChanges => 
    _client?.auth.onAuthStateChange ?? const Stream.empty();
  
  /// Сохранение данных пользователя
  Future<void> saveUserData(String table, Map<String, dynamic> data) async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      await _client!.from(table).upsert(data);
      developer.log('🟪 SupabaseService: Data saved to $table', name: 'SupabaseService');
    } catch (e) {
      developer.log('🟪 SupabaseService: Save data failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
  
  /// Получение данных пользователя
  Future<List<Map<String, dynamic>>> getUserData(String table, {String? userId}) async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      final query = _client!.from(table).select();
      if (userId != null) {
        query.eq('user_id', userId);
      }
      
      final response = await query;
      developer.log('🟪 SupabaseService: Data retrieved from $table', name: 'SupabaseService');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      developer.log('🟪 SupabaseService: Get data failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
  
  /// Удаление данных пользователя
  Future<void> deleteUserData(String table, String id) async {
    if (!isAvailable) {
      throw Exception('Supabase not available');
    }
    
    try {
      await _client!.from(table).delete().eq('id', id);
      developer.log('🟪 SupabaseService: Data deleted from $table', name: 'SupabaseService');
    } catch (e) {
      developer.log('🟪 SupabaseService: Delete data failed: $e', name: 'SupabaseService');
      rethrow;
    }
  }
} 