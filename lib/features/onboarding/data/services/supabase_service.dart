import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config/supabase_config.dart';

/// Сервис для работы с Supabase
/// Инкапсулирует всю логику взаимодействия с базой данных
class SupabaseService {
  final SupabaseClient? _client;
  
  SupabaseService(this._client);
  
  /// Получает экземпляр клиента Supabase
  /// В демо-режиме возвращает null
  static SupabaseService get instance {
    if (SupabaseConfig.isDemo) {
      return SupabaseService(null);
    }
    return SupabaseService(Supabase.instance.client);
  }
  
  /// Проверяет, доступен ли Supabase
  bool get isAvailable => _client != null;
  
  // === Методы для работы с аутентификацией ===
  
  /// Получает текущего пользователя
  User? getCurrentUser() {
    if (!isAvailable) return null;
    return _client!.auth.currentUser;
  }
  
  /// Регистрирует нового пользователя
  Future<AuthResponse> signUp(String email, String password) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    return await _client!.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  /// Выполняет вход пользователя
  Future<AuthResponse> signIn(String email, String password) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    return await _client!.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Выполняет выход пользователя
  Future<void> signOut() async {
    if (!isAvailable) return;
    await _client!.auth.signOut();
  }
  
  /// Отправляет письмо для сброса пароля
  Future<void> resetPassword(String email) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    await _client!.auth.resetPasswordForEmail(email);
  }
  
  // === Методы для работы с данными ===
  
  /// Сохраняет данные в таблицу
  Future<List<Map<String, dynamic>>> insertData(
    String table, 
    Map<String, dynamic> data
  ) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    try {
      final response = await _client!.from(table).insert(data).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Ошибка при сохранении данных: $e');
    }
  }
  
  /// Обновляет данные в таблице
  Future<List<Map<String, dynamic>>> updateData(
    String table,
    Map<String, dynamic> data,
    String column,
    dynamic value,
  ) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    try {
      final response = await _client!
          .from(table)
          .update(data)
          .eq(column, value)
          .select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Ошибка при обновлении данных: $e');
    }
  }
  
  /// Получает данные из таблицы
  Future<List<Map<String, dynamic>>> selectData(
    String table, {
    String? column,
    dynamic value,
    String? selectColumns,
  }) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    try {
      var query = _client!.from(table).select(selectColumns ?? '*');
      
      if (column != null && value != null) {
        query = query.eq(column, value);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Ошибка при получении данных: $e');
    }
  }
  
  /// Удаляет данные из таблицы
  Future<List<Map<String, dynamic>>> deleteData(
    String table,
    String column,
    dynamic value,
  ) async {
    if (!isAvailable) {
      throw Exception('Supabase недоступен в демо-режиме');
    }
    try {
      final response = await _client!.from(table).delete().eq(column, value).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Ошибка при удалении данных: $e');
    }
  }
} 