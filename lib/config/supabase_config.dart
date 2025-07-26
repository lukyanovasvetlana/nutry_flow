import 'package:flutter_dotenv/flutter_dotenv.dart';
 
class SupabaseConfig {
  // Временные значения для разработки
  // В продакшене используйте реальные значения из .env файла
  static String get url => dotenv.env['SUPABASE_URL'] ?? 'https://demo-project.supabase.co';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'demo-anon-key';
  
  // Для тестирования без реального Supabase
  // Демо-режим активен, если нет .env файла или URL не настроен
  static bool get isDemo {
    try {
      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
      
      print('🟪 SupabaseConfig: url = "$url"');
      print('🟪 SupabaseConfig: anonKey = "${anonKey?.substring(0, 10) ?? 'null'}..."');
      
      // Если нет переменных окружения или они пустые/демо-значения
      final isDemoMode = url == null || 
             url.isEmpty || 
             url.trim().isEmpty ||
             url.contains('demo-project') ||
             anonKey == null || 
             anonKey.isEmpty || 
             anonKey.trim().isEmpty ||
             anonKey.contains('demo-anon-key');
             
      print('🟪 SupabaseConfig: isDemo = $isDemoMode');
      return isDemoMode;
    } catch (e) {
      print('🟪 SupabaseConfig: Exception in isDemo: $e');
      // Если .env файл не загружен, используем демо-режим
      return true;
    }
  }
} 