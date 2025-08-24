import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity Tests', () {
    test('should create user with required fields', () {
      const id = 'user123';
      const email = 'test@example.com';
      
      final user = User(id: id, email: email);
      
      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.createdAt, isNull);
      expect(user.updatedAt, isNull);
    });

    test('should create user with all fields', () {
      const id = 'user123';
      const email = 'test@example.com';
      final createdAt = DateTime(2024, 1, 1);
      final updatedAt = DateTime(2024, 1, 2);
      
      final user = User(
        id: id,
        email: email,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      
      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, equals(updatedAt));
    });

    test('should convert user to JSON', () {
      const id = 'user123';
      const email = 'test@example.com';
      final createdAt = DateTime(2024, 1, 1);
      final updatedAt = DateTime(2024, 1, 2);
      
      final user = User(
        id: id,
        email: email,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      
      final json = user.toJson();
      
      expect(json['id'], equals(id));
      expect(json['email'], equals(email));
      expect(json['created_at'], equals(createdAt.toIso8601String()));
      expect(json['updated_at'], equals(updatedAt.toIso8601String()));
    });

    test('should create user from JSON', () {
      const id = 'user123';
      const email = 'test@example.com';
      final createdAt = DateTime(2024, 1, 1);
      final updatedAt = DateTime(2024, 1, 2);
      
      final json = {
        'id': id,
        'email': email,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, equals(updatedAt));
    });

    test('should create user from JSON with null dates', () {
      const id = 'user123';
      const email = 'test@example.com';
      
      final json = {
        'id': id,
        'email': email,
        'created_at': null,
        'updated_at': null,
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.createdAt, isNull);
      expect(user.updatedAt, isNull);
    });

    test('should create user from JSON without date fields', () {
      const id = 'user123';
      const email = 'test@example.com';
      
      final json = {
        'id': id,
        'email': email,
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, equals(id));
      expect(user.email, equals(email));
      expect(user.createdAt, isNull);
      expect(user.updatedAt, isNull);
    });

    test('should handle equality correctly', () {
      final user1 = User(id: 'user123', email: 'test@example.com');
      final user2 = User(id: 'user123', email: 'test@example.com');
      final user3 = User(id: 'user456', email: 'test@example.com');
      
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1.hashCode, isNot(equals(user3.hashCode)));
    });

    test('should convert to string correctly', () {
      const id = 'user123';
      const email = 'test@example.com';
      
      final user = User(id: id, email: email);
      final string = user.toString();
      
      expect(string, contains('User('));
      expect(string, contains('id: $id'));
      expect(string, contains('email: $email'));
    });

    test('should handle empty string values', () {
      const id = '';
      const email = '';
      
      final user = User(id: id, email: email);
      
      expect(user.id, equals(''));
      expect(user.email, equals(''));
    });

    test('should handle special characters in email', () {
      const id = 'user123';
      const email = 'test+tag@example-domain.co.uk';
      
      final user = User(id: id, email: email);
      
      expect(user.id, equals(id));
      expect(user.email, equals(email));
    });
  });
}
