import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/config/supabase_config.dart';

void main() {
  group('Demo Mode Tests', () {
    test('should be in demo mode', () {
      final isDemo = SupabaseConfig.isDemo;
      print('Demo mode: $isDemo');
      expect(isDemo, isTrue);
    });

    test('should have demo URL', () {
      final url = SupabaseConfig.url;
      print('URL: $url');
      expect(url, contains('demo-project'));
    });

    test('should have demo anon key', () {
      final anonKey = SupabaseConfig.anonKey;
      print('Anon key: $anonKey');
      expect(anonKey, contains('demo-anon-key'));
    });
  });
} 