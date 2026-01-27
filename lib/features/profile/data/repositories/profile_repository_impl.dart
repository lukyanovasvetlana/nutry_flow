import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';
import '../services/profile_service.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'dart:developer' as developer;

/// Implementation of ProfileRepository using ProfileService
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileService;

  const ProfileRepositoryImpl(this._profileService);

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final profileModel = await _profileService.getCurrentUserProfile();

      if (profileModel != null) {
        // Convert model to entity
        return _convertModelToEntity(profileModel);
      }

      // Если профиль не найден, проверяем SharedPreferences как fallback
      developer.log(
          '🔵 ProfileRepositoryImpl: Current profile not found in service, checking SharedPreferences',
          name: 'ProfileRepositoryImpl');
      final currentUser = SupabaseService.instance.currentUser;
      if (currentUser == null) {
        developer.log('🔴 ProfileRepositoryImpl: No current user found',
            name: 'ProfileRepositoryImpl');
        return null;
      }

      return await getUserProfile(currentUser.id);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to get current user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get current user profile: $e');
    }
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      // Сначала проверяем SharedPreferences - приоритет реальным данным пользователя
      developer.log(
          '🔵 ProfileRepositoryImpl: Checking SharedPreferences first',
          name: 'ProfileRepositoryImpl');
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      final userLastName = prefs.getString('userLastName');
      final userEmail = prefs.getString('userEmail');

      if (userName != null && userName.isNotEmpty) {
        developer.log(
            '🔵 ProfileRepositoryImpl: Found profile data in SharedPreferences: $userName $userLastName',
            name: 'ProfileRepositoryImpl');

        // Получаем email из SupabaseService если он не сохранен в SharedPreferences
        String email = userEmail ?? '';
        if (email.isEmpty) {
          final currentUser = SupabaseService.instance.currentUser;
          email = currentUser?.email ?? '';
        }

        // Создаем профиль из данных SharedPreferences
        final localProfile = UserProfile(
          id: userId,
          firstName: userName,
          lastName: userLastName ?? '',
          email: email.isNotEmpty ? email : 'user@example.com',
          phone: prefs.getString('userPhone'),
          dateOfBirth: prefs.getString('userBirthDate') != null
              ? DateTime.parse(prefs.getString('userBirthDate')!)
              : null,
          gender: prefs.getString('userGender') != null
              ? _parseGender(prefs.getString('userGender')!)
              : null,
          height: prefs.getDouble('userHeight'),
          weight: prefs.getDouble('userWeight'),
          activityLevel: null,
          avatarUrl: null,
          dietaryPreferences: const [],
          allergies: const [],
          healthConditions: const [],
          fitnessGoals: const [],
          targetWeight: null,
          targetCalories: null,
          targetProtein: null,
          targetCarbs: null,
          targetFat: null,
          foodRestrictions: null,
          pushNotificationsEnabled: true,
          emailNotificationsEnabled: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        developer.log(
            '🔵 ProfileRepositoryImpl: Created profile from SharedPreferences',
            name: 'ProfileRepositoryImpl');
        return localProfile;
      }

      // Если данных в SharedPreferences нет, используем данные из сервиса
      developer.log(
          '🔵 ProfileRepositoryImpl: No data in SharedPreferences, checking service',
          name: 'ProfileRepositoryImpl');
      final profileModel = await _profileService.getUserProfile(userId);

      if (profileModel != null) {
        // Convert model to entity
        developer.log('🔵 ProfileRepositoryImpl: Found profile in service',
            name: 'ProfileRepositoryImpl');
        return _convertModelToEntity(profileModel);
      }

      developer.log('🔴 ProfileRepositoryImpl: No profile data found anywhere',
          name: 'ProfileRepositoryImpl');
      return null;
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to get user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Парсит пол из строки
  Gender? _parseGender(String genderString) {
    switch (genderString.toLowerCase()) {
      case 'мужской':
      case 'male':
        return Gender.male;
      case 'женский':
      case 'female':
        return Gender.female;
      case 'другой':
      case 'other':
        return Gender.other;
      default:
        return null;
    }
  }

  @override
  Future<UserProfile> createUserProfile(UserProfile profile) async {
    try {
      // Convert entity to model
      final profileModel = UserProfileModel.fromEntity(profile);

      final createdModel =
          await _profileService.createUserProfile(profileModel);

      // Convert model back to entity
      return _convertModelToEntity(createdModel);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to create user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      // Convert entity to model
      final profileModel = UserProfileModel.fromEntity(profile);

      final updatedModel =
          await _profileService.updateUserProfile(profileModel);

      // Convert model back to entity
      return _convertModelToEntity(updatedModel);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to update user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      await _profileService.deleteUserProfile(userId);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to delete user profile: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  Future<String> uploadAvatar(String userId, String imagePath) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw ArgumentError('Image file does not exist');
      }

      return await _profileService.uploadAvatar(userId, imageFile);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to upload avatar: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  Future<void> deleteAvatar(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      await _profileService.deleteAvatar(userId);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to delete avatar: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete avatar: $e');
    }
  }

  @override
  Future<bool> isEmailAvailable(String email, {String? excludeUserId}) async {
    try {
      if (email.isEmpty) {
        throw ArgumentError('Email cannot be empty');
      }

      return await _profileService.isEmailAvailable(
        email,
        excludeUserId: excludeUserId,
      );
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to check email availability: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check email availability: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      return await _profileService.getProfileStatistics(userId);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to get profile statistics: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get profile statistics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportProfileData(String userId) async {
    try {
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }

      return await _profileService.exportProfileData(userId);
    } on ProfileServiceException catch (e) {
      throw Exception('Failed to export profile data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to export profile data: $e');
    }
  }

  /// Helper method to convert UserProfileModel to UserProfile entity
  UserProfile _convertModelToEntity(UserProfileModel model) {
    return UserProfile(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      phone: model.phone,
      dateOfBirth: model.dateOfBirth,
      gender: model.gender,
      height: model.height,
      weight: model.weight,
      activityLevel: model.activityLevel,
      avatarUrl: model.avatarUrl,
      dietaryPreferences: model.dietaryPreferences,
      allergies: model.allergies,
      healthConditions: model.healthConditions,
      fitnessGoals: model.fitnessGoals,
      targetWeight: model.targetWeight,
      targetCalories: model.targetCalories,
      targetProtein: model.targetProtein,
      targetCarbs: model.targetCarbs,
      targetFat: model.targetFat,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
