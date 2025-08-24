import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';

void main() {
  group('UserProfile Entity Tests', () {
    late UserProfile basicProfile;
    late UserProfile fullProfile;

    setUp(() {
      basicProfile = UserProfile(
        id: 'user123',
        firstName: 'Иван',
        lastName: 'Петров',
        email: 'ivan.petrov@example.com',
      );

      fullProfile = UserProfile(
        id: 'user456',
        firstName: 'Анна',
        lastName: 'Иванова',
        email: 'anna.ivanova@example.com',
        phone: '+7 (999) 123-45-67',
        dateOfBirth: DateTime(1990, 5, 15),
        gender: Gender.female,
        height: 165.0,
        weight: 62.0,
        activityLevel: ActivityLevel.moderatelyActive,
        avatarUrl: 'https://example.com/avatar.jpg',
        dietaryPreferences: [DietaryPreference.vegetarian],
        allergies: ['Орехи', 'Молочные продукты'],
        healthConditions: ['Астма'],
        fitnessGoals: ['Похудение', 'Улучшение выносливости'],
        targetWeight: 60.0,
        targetCalories: 1800,
        targetProtein: 90.0,
        targetCarbs: 180.0,
        targetFat: 60.0,
        foodRestrictions: 'Без глютена',
        pushNotificationsEnabled: true,
        emailNotificationsEnabled: false,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 12, 1),
      );
    });

    group('Constructor Tests', () {
      test('should create basic profile with required fields', () {
        expect(basicProfile.id, equals('user123'));
        expect(basicProfile.firstName, equals('Иван'));
        expect(basicProfile.lastName, equals('Петров'));
        expect(basicProfile.email, equals('ivan.petrov@example.com'));
        expect(basicProfile.phone, isNull);
        expect(basicProfile.dateOfBirth, isNull);
        expect(basicProfile.gender, isNull);
        expect(basicProfile.height, isNull);
        expect(basicProfile.weight, isNull);
        expect(basicProfile.activityLevel, isNull);
        expect(basicProfile.avatarUrl, isNull);
        expect(basicProfile.dietaryPreferences, isEmpty);
        expect(basicProfile.allergies, isEmpty);
        expect(basicProfile.healthConditions, isEmpty);
        expect(basicProfile.fitnessGoals, isEmpty);
        expect(basicProfile.targetWeight, isNull);
        expect(basicProfile.targetCalories, isNull);
        expect(basicProfile.targetProtein, isNull);
        expect(basicProfile.targetCarbs, isNull);
        expect(basicProfile.targetFat, isNull);
        expect(basicProfile.foodRestrictions, isNull);
        expect(basicProfile.pushNotificationsEnabled, isTrue);
        expect(basicProfile.emailNotificationsEnabled, isTrue);
        expect(basicProfile.createdAt, isNull);
        expect(basicProfile.updatedAt, isNull);
      });

      test('should create full profile with all fields', () {
        expect(fullProfile.id, equals('user456'));
        expect(fullProfile.firstName, equals('Анна'));
        expect(fullProfile.lastName, equals('Иванова'));
        expect(fullProfile.email, equals('anna.ivanova@example.com'));
        expect(fullProfile.phone, equals('+7 (999) 123-45-67'));
        expect(fullProfile.dateOfBirth, equals(DateTime(1990, 5, 15)));
        expect(fullProfile.gender, equals(Gender.female));
        expect(fullProfile.height, equals(165.0));
        expect(fullProfile.weight, equals(62.0));
        expect(fullProfile.activityLevel, equals(ActivityLevel.moderatelyActive));
        expect(fullProfile.avatarUrl, equals('https://example.com/avatar.jpg'));
        expect(fullProfile.dietaryPreferences, contains(DietaryPreference.vegetarian));
        expect(fullProfile.allergies, containsAll(['Орехи', 'Молочные продукты']));
        expect(fullProfile.healthConditions, contains('Астма'));
        expect(fullProfile.fitnessGoals, containsAll(['Похудение', 'Улучшение выносливости']));
        expect(fullProfile.targetWeight, equals(60.0));
        expect(fullProfile.targetCalories, equals(1800));
        expect(fullProfile.targetProtein, equals(90.0));
        expect(fullProfile.targetCarbs, equals(180.0));
        expect(fullProfile.targetFat, equals(60.0));
        expect(fullProfile.foodRestrictions, equals('Без глютена'));
        expect(fullProfile.pushNotificationsEnabled, isTrue);
        expect(fullProfile.emailNotificationsEnabled, isFalse);
        expect(fullProfile.createdAt, equals(DateTime(2023, 1, 1)));
        expect(fullProfile.updatedAt, equals(DateTime(2023, 12, 1)));
      });
    });

    group('Computed Properties Tests', () {
      test('fullName should return full name when both names provided', () {
        expect(basicProfile.fullName, equals('Иван Петров'));
        expect(fullProfile.fullName, equals('Анна Иванова'));
      });

      test('fullName should handle empty names', () {
        final emptyProfile = UserProfile(
          id: 'empty',
          firstName: '',
          lastName: '',
          email: 'empty@example.com',
        );
        expect(emptyProfile.fullName, equals('Не указано'));
      });

      test('fullName should handle partial names', () {
        final partialProfile = UserProfile(
          id: 'partial',
          firstName: 'Иван',
          lastName: '',
          email: 'partial@example.com',
        );
        expect(partialProfile.fullName, equals('Иван'));
      });

      test('initials should return correct initials', () {
        expect(basicProfile.initials, equals('ИП'));
        expect(fullProfile.initials, equals('АИ'));
      });

      test('initials should handle empty names', () {
        final emptyProfile = UserProfile(
          id: 'empty',
          firstName: '',
          lastName: '',
          email: 'empty@example.com',
        );
        expect(emptyProfile.initials, equals(''));
      });

      test('age should calculate correct age', () {
        final now = DateTime.now();
        final birthYear = now.year - 25;
        final profile = UserProfile(
          id: 'age-test',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          dateOfBirth: DateTime(birthYear, now.month, now.day),
        );
        expect(profile.age, equals(25));
      });

      test('age should return null when dateOfBirth is null', () {
        expect(basicProfile.age, isNull);
      });

      test('bmi should calculate correct value', () {
        final profile = UserProfile(
          id: 'bmi-test',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 180.0, // 1.8 meters
          weight: 75.0,  // 75 kg
        );
        // BMI = 75 / (1.8 * 1.8) = 75 / 3.24 = 23.15
        expect(profile.bmi, closeTo(23.15, 0.01));
      });

      test('bmi should return null when height or weight is null', () {
        expect(basicProfile.bmi, isNull);
        
        final heightOnly = UserProfile(
          id: 'height-only',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 180.0,
        );
        expect(heightOnly.bmi, isNull);
        
        final weightOnly = UserProfile(
          id: 'weight-only',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          weight: 75.0,
        );
        expect(weightOnly.bmi, isNull);
      });

      test('bmiCategory should return correct category', () {
        final underweight = UserProfile(
          id: 'underweight',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 180.0,
          weight: 55.0, // BMI = 16.98
        );
        expect(underweight.bmiCategory, equals(BMICategory.underweight));

        final normal = UserProfile(
          id: 'normal',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 180.0,
          weight: 75.0, // BMI = 23.15
        );
        expect(normal.bmiCategory, equals(BMICategory.normal));

        final overweight = UserProfile(
          id: 'overweight',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 180.0,
          weight: 85.0, // BMI = 26.23
        );
        expect(overweight.bmiCategory, equals(BMICategory.overweight));

        final obese = UserProfile(
          id: 'obese',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 180.0,
          weight: 100.0, // BMI = 30.86
        );
        expect(obese.bmiCategory, equals(BMICategory.obese));
      });

      test('bmiCategory should return null when bmi cannot be calculated', () {
        expect(basicProfile.bmiCategory, isNull);
      });

      test('profileCompleteness should calculate correct percentage', () {
        // basicProfile has 2 fields filled: firstName, lastName
        // But completeness only counts specific 12 fields, so it should be 0.16666666666666666 (2/12)
        expect(basicProfile.profileCompleteness, equals(2/12));
        
        // fullProfile has most fields filled, should be close to 1.0
        expect(fullProfile.profileCompleteness, greaterThan(0.8));
      });

      test('profileCompleteness should handle edge cases', () {
        final emptyProfile = UserProfile(
          id: 'empty',
          firstName: '',
          lastName: '',
          email: 'empty@example.com',
        );
        expect(emptyProfile.profileCompleteness, equals(0.0));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long names', () {
        final longName = 'A' * 1000;
        final profile = UserProfile(
          id: 'long-name',
          firstName: longName,
          lastName: longName,
          email: 'test@example.com',
        );
        expect(profile.firstName, equals(longName));
        expect(profile.lastName, equals(longName));
        expect(profile.fullName, equals('$longName $longName'));
      });

      test('should handle special characters in names', () {
        final profile = UserProfile(
          id: 'special-chars',
          firstName: 'José-María',
          lastName: 'O\'Connor',
          email: 'test@example.com',
        );
        expect(profile.fullName, equals('José-María O\'Connor'));
        expect(profile.initials, equals('JO'));
      });

      test('should handle unicode characters', () {
        final profile = UserProfile(
          id: 'unicode',
          firstName: 'Анна-Мария',
          lastName: 'Иванова-Петрова',
          email: 'test@example.com',
        );
        expect(profile.fullName, equals('Анна-Мария Иванова-Петрова'));
        expect(profile.initials, equals('АИ'));
      });

      test('should handle extreme height and weight values', () {
        final profile = UserProfile(
          id: 'extreme',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 300.0, // 3 meters
          weight: 500.0, // 500 kg
        );
        expect(profile.bmi, isNotNull);
        expect(profile.bmiCategory, equals(BMICategory.obese));
      });
    });

    group('Validation Tests', () {
      test('should handle empty strings as valid values', () {
        final profile = UserProfile(
          id: 'empty-strings',
          firstName: '',
          lastName: '',
          email: 'test@example.com',
        );
        expect(profile.firstName, equals(''));
        expect(profile.lastName, equals(''));
        expect(profile.fullName, equals('Не указано'));
        expect(profile.initials, equals(''));
      });

      test('should handle zero values for height and weight', () {
        final profile = UserProfile(
          id: 'zero-values',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          height: 0.0,
          weight: 0.0,
        );
        expect(profile.height, equals(0.0));
        expect(profile.weight, equals(0.0));
        // BMI при нулевых значениях будет null
        expect(profile.bmi, isNull);
        // При нулевых значениях height и weight, BMI категория не может быть определена
        expect(profile.bmiCategory, isNull);
      });
    });
  });
}
