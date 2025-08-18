import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/config/supabase_config.dart';

void main() {
  group('Auth Demo Mode Tests', () {
    test('should detect demo mode correctly', () {
      // Проверяем, что демо-режим определяется правильно
      final isDemo = SupabaseConfig.isDemo;
      expect(isDemo, isTrue);
    });

    test('should have demo URL', () {
      final url = SupabaseConfig.url;
      expect(url, contains('demo-project'));
    });

    test('should have demo anon key', () {
      final anonKey = SupabaseConfig.anonKey;
      expect(anonKey, contains('demo-anon-key'));
    });
  });
} 