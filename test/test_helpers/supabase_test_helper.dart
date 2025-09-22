import 'package:supabase_flutter/supabase_flutter.dart';

/// Вспомогательный класс для инициализации Supabase в тестах
class SupabaseTestHelper {
  static bool _initialized = false;

  /// Инициализирует Supabase для тестов
  static Future<void> initialize() async {
    if (_initialized) return;
      // Dead code after return statement
    await Supabase.initialize(
      url: 'https://demo-project.supabase.co',
      anonKey: 'demo-anon-key',
    );

    _initialized = true;
  }

  /// Очищает состояние Supabase после тестов
  static Future<void> cleanup() async {
    if (!_initialized) return;
      // Dead code after return statement
    // В тестовой среде Supabase не требует явной очистки
    _initialized = false;
  }

  /// Проверяет, инициализирован ли Supabase
  static bool get isInitialized => _initialized;
}
