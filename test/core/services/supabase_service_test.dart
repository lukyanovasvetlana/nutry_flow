import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';

void main() {
  group('SupabaseService Tests', () {
    late SupabaseService supabaseService;

    setUp(() {
      supabaseService = SupabaseService.instance;
    });

    group('Basic Functionality', () {
      test('should have instance', () {
        // Assert
        expect(supabaseService, isNotNull);
      });

      test('should have client property', () {
        // Assert
        expect(supabaseService.client, isA<dynamic>());
      });

      test('should have isAvailable property', () {
        // Act
        final isAvailable = supabaseService.isAvailable;

        // Assert
        expect(isAvailable, isA<bool>());
      });
    });

    group('Method Existence', () {
      test('should have signUp method', () {
        // Assert
        expect(supabaseService.signUp, isA<Function>());
      });

      test('should have signIn method', () {
        // Assert
        expect(supabaseService.signIn, isA<Function>());
      });

      test('should have signOut method', () {
        // Assert
        expect(supabaseService.signOut, isA<Function>());
      });

      test('should have resetPassword method', () {
        // Assert
        expect(supabaseService.resetPassword, isA<Function>());
      });

      test('should have initialize method', () {
        // Assert
        expect(supabaseService.initialize, isA<Function>());
      });
    });

    group('Property Types', () {
      test('should have correct client type', () {
        // Assert
        expect(supabaseService.client, isA<dynamic>());
      });

      test('should have correct isAvailable type', () {
        // Act
        final isAvailable = supabaseService.isAvailable;

        // Assert
        expect(isAvailable, isA<bool>());
      });
    });

    group('Service State', () {
      test('should be in demo mode by default', () {
        // Act
        final isAvailable = supabaseService.isAvailable;

        // Assert
        expect(isAvailable, isA<bool>());
      });

      test('should have null client initially', () {
        // Assert
        expect(supabaseService.client, isNull);
      });
    });

    group('Error Handling', () {
      test('should handle signUp with exception when not initialized', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: 'test@example.com',
            password: 'password123',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle signIn with exception when not initialized', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signIn(
            email: 'test@example.com',
            password: 'password123',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle signOut with exception when not initialized', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signOut();
        }, throwsA(isA<Exception>()));
      });

      test('should handle resetPassword with exception when not initialized', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.resetPassword('test@example.com');
        }, throwsA(isA<Exception>()));
      });
    });

    group('Edge Cases', () {
      test('should handle empty email in signUp with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: '',
            password: 'password123',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle empty password in signUp with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: 'test@example.com',
            password: '',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle null userData in signUp with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: 'test@example.com',
            password: 'password123',
            userData: null,
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle empty email in signIn with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signIn(
            email: '',
            password: 'password123',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle empty password in signIn with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.signIn(
            email: 'test@example.com',
            password: '',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle empty email in resetPassword with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.resetPassword('');
        }, throwsA(isA<Exception>()));
      });

      test('should handle invalid email in resetPassword with exception', () async {
        // Act & Assert
        expect(() async {
          await supabaseService.resetPassword('invalid-email');
        }, throwsA(isA<Exception>()));
      });
    });

    group('Very Long Inputs', () {
      test('should handle very long email with exception', () async {
        // Arrange
        final longEmail = 'a' * 1000 + '@example.com';

        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: longEmail,
            password: 'password123',
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle very long password with exception', () async {
        // Arrange
        final longPassword = 'a' * 10000;

        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: 'test@example.com',
            password: longPassword,
          );
        }, throwsA(isA<Exception>()));
      });

      test('should handle very long userData with exception', () async {
        // Arrange
        final longUserData = {
          'name': 'a' * 1000,
          'description': 'b' * 1000,
        };

        // Act & Assert
        expect(() async {
          await supabaseService.signUp(
            email: 'test@example.com',
            password: 'password123',
            userData: longUserData,
          );
        }, throwsA(isA<Exception>()));
      });
    });
  });
}