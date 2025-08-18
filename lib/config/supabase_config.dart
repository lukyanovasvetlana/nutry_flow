import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class SupabaseConfig {
  // Временные значения для разработки
  // В продакшене используйте реальные значения из .env файла
  static String get url {
    try {
      return dotenv.env['SUPABASE_URL'] ?? 'https://demo-project.supabase.co';
    } catch (e) {
      return 'https://demo-project.supabase.co';
    }
  }

  static String get anonKey {
    try {
      return dotenv.env['SUPABASE_ANON_KEY'] ?? 'demo-anon-key';
    } catch (e) {
      return 'demo-anon-key';
    }
  }

  // Для тестирования без реального Supabase
  // Демо-режим активен, если нет .env файла или URL не настроен
  static bool get isDemo {
    try {
      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

      developer.log('🟪 SupabaseConfig: url = "$url"', name: 'SupabaseConfig');
      developer.log(
          '🟪 SupabaseConfig: anonKey = "${anonKey?.substring(0, 10) ?? 'null'}..."',
          name: 'SupabaseConfig');

      // Принудительно используем демо-режим для разработки
      final isDemoMode = true; // Принудительно демо-режим

      developer.log(
          '🟪 SupabaseConfig: isDemo = $isDemoMode (forced demo mode)',
          name: 'SupabaseConfig');
      return isDemoMode;
    } catch (e) {
      developer.log('🟪 SupabaseConfig: Exception in isDemo: $e',
          name: 'SupabaseConfig');
      // Если .env файл не загружен, используем демо-режим
      return true;
    }
  }
}
