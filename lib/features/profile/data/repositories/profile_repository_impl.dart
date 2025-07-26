import 'dart:io';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';
import '../services/profile_service.dart';

/// Implementation of ProfileRepository using ProfileService
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileService;

  const ProfileRepositoryImpl(this._profileService);

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      print('🟪 ProfileRepositoryImpl: getCurrentUserProfile called');
      final profileModel = await _profileService.getCurrentUserProfile();
      
      if (profileModel == null) {
        return null;
      }
      
      // Convert model to entity
      return _convertModelToEntity(profileModel);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to get current user profile: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to get current user profile: $e');
    }
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      print('🟪 ProfileRepositoryImpl: getUserProfile called - userId: $userId');
      
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      final profileModel = await _profileService.getUserProfile(userId);
      
      if (profileModel == null) {
        return null;
      }
      
      // Convert model to entity
      return _convertModelToEntity(profileModel);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to get user profile: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfile> createUserProfile(UserProfile profile) async {
    try {
      print('🟪 ProfileRepositoryImpl: createUserProfile called - ${profile.fullName}');
      
      // Convert entity to model
      final profileModel = UserProfileModel.fromEntity(profile);
      
      final createdModel = await _profileService.createUserProfile(profileModel);
      
      // Convert model back to entity
      return _convertModelToEntity(createdModel);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to create user profile: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to create user profile: $e');
    }
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      print('🟪 ProfileRepositoryImpl: updateUserProfile called - ${profile.fullName}');
      
      // Convert entity to model
      final profileModel = UserProfileModel.fromEntity(profile);
      
      final updatedModel = await _profileService.updateUserProfile(profileModel);
      
      // Convert model back to entity
      return _convertModelToEntity(updatedModel);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to update user profile: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      print('🟪 ProfileRepositoryImpl: deleteUserProfile called - userId: $userId');
      
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      await _profileService.deleteUserProfile(userId);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to delete user profile: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to delete user profile: $e');
    }
  }

  @override
  Future<String> uploadAvatar(String userId, String imagePath) async {
    try {
      print('🟪 ProfileRepositoryImpl: uploadAvatar called - userId: $userId');
      
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw ArgumentError('Image file does not exist');
      }
      
      return await _profileService.uploadAvatar(userId, imageFile);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to upload avatar: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to upload avatar: $e');
    }
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    try {
      print('🟪 ProfileRepositoryImpl: deleteAvatar called - userId: $userId');
      
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      await _profileService.deleteAvatar(userId);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to delete avatar: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to delete avatar: $e');
    }
  }

  @override
  Future<bool> isEmailAvailable(String email, {String? excludeUserId}) async {
    try {
      print('🟪 ProfileRepositoryImpl: isEmailAvailable called - email: $email');
      
      if (email.isEmpty) {
        throw ArgumentError('Email cannot be empty');
      }
      
      return await _profileService.isEmailAvailable(
        email,
        excludeUserId: excludeUserId,
      );
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to check email availability: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to check email availability: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics(String userId) async {
    try {
      print('🟪 ProfileRepositoryImpl: getProfileStatistics called - userId: $userId');
      
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      return await _profileService.getProfileStatistics(userId);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to get profile statistics: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
      throw Exception('Failed to get profile statistics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportProfileData(String userId) async {
    try {
      print('🟪 ProfileRepositoryImpl: exportProfileData called - userId: $userId');
      
      if (userId.isEmpty) {
        throw ArgumentError('User ID cannot be empty');
      }
      
      return await _profileService.exportProfileData(userId);
    } on ProfileServiceException catch (e) {
      print('🔴 ProfileRepositoryImpl: Service error - ${e.message}');
      throw Exception('Failed to export profile data: ${e.message}');
    } catch (e) {
      print('🔴 ProfileRepositoryImpl: Unexpected error - $e');
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