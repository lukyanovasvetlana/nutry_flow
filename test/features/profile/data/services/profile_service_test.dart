import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/profile/data/services/profile_service.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';
import 'package:nutry_flow/features/profile/data/models/user_profile_model.dart';

void main() {
  group('ProfileService Tests', () {
    late MockProfileService mockProfileService;

    setUp(() {
      mockProfileService = MockProfileService();
    });

    group('MockProfileService Tests', () {
      test('should return demo profile for getCurrentUserProfile', () async {
        final profile = await mockProfileService.getCurrentUserProfile();
        
        expect(profile, isNotNull);
        expect(profile!.id, equals('demo-user-id'));
        expect(profile.firstName, equals('Анна'));
        expect(profile.lastName, equals('Иванова'));
        expect(profile.email, equals('anna.ivanova@example.com'));
        expect(profile.phone, equals('+7 (999) 123-45-67'));
        expect(profile.gender, equals(Gender.female));
        expect(profile.height, equals(165.0));
        expect(profile.weight, equals(62.0));
        expect(profile.activityLevel, equals(ActivityLevel.moderatelyActive));
        expect(profile.dietaryPreferences, contains(DietaryPreference.vegetarian));
        expect(profile.allergies, containsAll(['Орехи', 'Молочные продукты']));
        expect(profile.fitnessGoals, containsAll(['Поддержание веса', 'Улучшение выносливости']));
      });

      test('should return demo profile for getUserProfile', () async {
        final profile = await mockProfileService.getUserProfile('demo-user-id');
        
        expect(profile, isNotNull);
        expect(profile!.id, equals('demo-user-id'));
        expect(profile.firstName, equals('Анна'));
      });

      test('should return null for non-existent user', () async {
        final profile = await mockProfileService.getUserProfile('non-existent-id');
        expect(profile, isNull);
      });

      test('should create new profile', () async {
        final newProfile = UserProfileModel(
          id: 'new-user',
          firstName: 'Новый',
          lastName: 'Пользователь',
          email: 'new@example.com',
        );

        final createdProfile = await mockProfileService.createUserProfile(newProfile);
        
        expect(createdProfile.id, equals('new-user'));
        expect(createdProfile.firstName, equals('Новый'));
        expect(createdProfile.lastName, equals('Пользователь'));
        expect(createdProfile.email, equals('new@example.com'));
      });

      test('should update existing profile', () async {
        final updatedProfile = UserProfileModel(
          id: 'demo-user-id',
          firstName: 'Анна-Мария',
          lastName: 'Иванова',
          email: 'anna.ivanova@example.com',
          phone: '+7 (999) 999-99-99',
        );

        final result = await mockProfileService.updateUserProfile(updatedProfile);
        
        expect(result.id, equals('demo-user-id'));
        expect(result.firstName, equals('Анна-Мария'));
        expect(result.phone, equals('+7 (999) 999-99-99'));
      });

      test('should delete profile', () async {
        // Сначала создаем профиль
        final newProfile = UserProfileModel(
          id: 'to-delete',
          firstName: 'Удалить',
          lastName: 'Пользователь',
          email: 'delete@example.com',
        );
        await mockProfileService.createUserProfile(newProfile);

        // Проверяем, что профиль создан
        final createdProfile = await mockProfileService.getUserProfile('to-delete');
        expect(createdProfile, isNotNull);

        // Удаляем профиль
        await mockProfileService.deleteUserProfile('to-delete');

        // Проверяем, что профиль удален
        final deletedProfile = await mockProfileService.getUserProfile('to-delete');
        expect(deletedProfile, isNull);
      });

      test('should check email availability', () async {
        // Существующий email
        final isAvailable = await mockProfileService.isEmailAvailable('anna.ivanova@example.com');
        expect(isAvailable, isFalse);

        // Новый email
        final isNewEmailAvailable = await mockProfileService.isEmailAvailable('new@example.com');
        expect(isNewEmailAvailable, isTrue);
      });

      test('should check email availability excluding current user', () async {
        // Проверяем email текущего пользователя, исключая его ID
        final isAvailable = await mockProfileService.isEmailAvailable(
          'anna.ivanova@example.com',
          excludeUserId: 'demo-user-id',
        );
        expect(isAvailable, isTrue);
      });

      test('should get profile statistics', () async {
        final stats = await mockProfileService.getProfileStatistics('demo-user-id');
        
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['profile_completeness'], isA<double>());
        expect(stats['days_since_created'], isA<int>());
        expect(stats['last_updated'], isA<DateTime>());
        expect(stats['has_avatar'], isA<bool>());
        expect(stats['goals_count'], isA<int>());
        expect(stats['dietary_preferences_count'], isA<int>());
        expect(stats['allergies_count'], isA<int>());
        expect(stats['health_conditions_count'], isA<int>());
      });

      test('should export profile data', () async {
        final exportedData = await mockProfileService.exportProfileData('demo-user-id');
        
        expect(exportedData, isA<Map<String, dynamic>>());
        expect(exportedData['profile'], isA<Map<String, dynamic>>());
        expect(exportedData['statistics'], isA<Map<String, dynamic>>());
        expect(exportedData['exported_at'], isA<String>());
        expect(exportedData['export_version'], isA<String>());
      });
    });

    group('ProfileServiceException Tests', () {
      test('should create exception with message', () {
        const exception = ProfileServiceException('Test error message');
        expect(exception.message, equals('Test error message'));
        expect(exception.code, isNull);
        expect(exception.originalError, isNull);
      });

      test('should create exception with all parameters', () {
        const exception = ProfileServiceException(
          'Test error message',
          code: 'TEST_ERROR',
          originalError: 'Original error details',
        );
        expect(exception.message, equals('Test error message'));
        expect(exception.code, equals('TEST_ERROR'));
        expect(exception.originalError, equals('Original error details'));
      });

      test('should convert to string correctly', () {
        const exception = ProfileServiceException('Test error message');
        final string = exception.toString();
        expect(string, equals('ProfileServiceException: Test error message'));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty user ID', () async {
        final profile = await mockProfileService.getUserProfile('');
        expect(profile, isNull);
      });

      test('should handle very long user ID', () async {
        final longId = 'A' * 1000;
        final profile = await mockProfileService.getUserProfile(longId);
        expect(profile, isNull);
      });

      test('should handle special characters in user ID', () async {
        final specialId = 'user-123_456@test';
        final profile = await mockProfileService.getUserProfile(specialId);
        expect(profile, isNull);
      });

      test('should handle unicode characters in user ID', () async {
        final unicodeId = 'пользователь-123';
        final profile = await mockProfileService.getUserProfile(unicodeId);
        expect(profile, isNull);
      });
    });

    group('Performance Tests', () {
      test('should handle multiple concurrent requests', () async {
        final futures = List.generate(10, (index) {
          return mockProfileService.getUserProfile('demo-user-id');
        });

        final results = await Future.wait(futures);
        
        expect(results.length, equals(10));
        for (final result in results) {
          expect(result, isNotNull);
          expect(result!.id, equals('demo-user-id'));
        }
      });

      test('should handle rapid profile updates', () async {
        final profile = UserProfileModel(
          id: 'rapid-update',
          firstName: 'Быстрое',
          lastName: 'Обновление',
          email: 'rapid@example.com',
        );

        // Создаем профиль
        final created = await mockProfileService.createUserProfile(profile);
        expect(created.firstName, equals('Быстрое'));

        // Быстро обновляем несколько раз
        for (int i = 1; i <= 5; i++) {
          final updated = await mockProfileService.updateUserProfile(
            created.copyWith(firstName: 'Обновление $i'),
          );
          expect(updated.firstName, equals('Обновление $i'));
        }
      });
    });

    group('Data Consistency Tests', () {
      test('should maintain data consistency across operations', () async {
        // Создаем профиль
        final originalProfile = UserProfileModel(
          id: 'consistency-test',
          firstName: 'Консистентность',
          lastName: 'Тест',
          email: 'consistency@example.com',
          phone: '+7 (999) 111-11-11',
        );

        final created = await mockProfileService.createUserProfile(originalProfile);
        expect(created.firstName, equals('Консистентность'));

        // Обновляем профиль
        final updated = await mockProfileService.updateUserProfile(
          created.copyWith(phone: '+7 (999) 222-22-22'),
        );
        expect(updated.phone, equals('+7 (999) 222-22-22'));

        // Проверяем, что данные сохранились
        final retrieved = await mockProfileService.getUserProfile('consistency-test');
        expect(retrieved, isNotNull);
        expect(retrieved!.firstName, equals('Консистентность'));
        expect(retrieved.phone, equals('+7 (999) 222-22-22'));

        // Удаляем профиль
        await mockProfileService.deleteUserProfile('consistency-test');

        // Проверяем, что профиль удален
        final deleted = await mockProfileService.getUserProfile('consistency-test');
        expect(deleted, isNull);
      });
    });
  });
}
