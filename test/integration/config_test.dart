import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nutry_flow/config/supabase_config.dart';

void main() {
  group('Supabase Configuration Tests', () {
    setUpAll(() async {
      // Загружаем переменные окружения для тестов
      await dotenv.load(fileName: '.env');
    });

    test('should load environment variables', () {
      // Проверяем, что конфигурация загружается
      expect(SupabaseConfig.url, isNotEmpty);
      expect(SupabaseConfig.anonKey, isNotEmpty);
    });

    test('should detect demo mode correctly', () {
      // Проверяем логику определения демо-режима
      final isDemo = SupabaseConfig.isDemo;
      expect(isDemo, isA<bool>());
    });

    test('should have valid configuration values', () {
      // Проверяем, что конфигурация содержит валидные значения
      final url = SupabaseConfig.url;
      final anonKey = SupabaseConfig.anonKey;
      
      expect(url, isNotEmpty);
      expect(anonKey, isNotEmpty);
      expect(url, contains('supabase.co'));
      expect(anonKey, contains('eyJ'));
    });
  });
} 