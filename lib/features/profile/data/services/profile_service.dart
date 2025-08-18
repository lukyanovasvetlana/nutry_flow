import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';

/// Exception thrown when profile operations fail
class ProfileServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const ProfileServiceException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'ProfileServiceException: $message';
}

/// Abstract service for profile operations
abstract class ProfileService {
  /// Get current user's profile
  Future<UserProfileModel?> getCurrentUserProfile();

  /// Get user profile by ID
  Future<UserProfileModel?> getUserProfile(String userId);

  /// Create a new user profile
  Future<UserProfileModel> createUserProfile(UserProfileModel profile);

  /// Update user profile
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);

  /// Delete user profile
  Future<void> deleteUserProfile(String userId);

  /// Upload avatar and return the URL
  Future<String> uploadAvatar(String userId, File imageFile);

  /// Delete avatar
  Future<void> deleteAvatar(String userId);

  /// Check if email is available
  Future<bool> isEmailAvailable(String email, {String? excludeUserId});

  /// Get profile statistics
  Future<Map<String, dynamic>> getProfileStatistics(String userId);

  /// Export profile data
  Future<Map<String, dynamic>> exportProfileData(String userId);
}

/// Mock implementation of ProfileService for demo mode
class MockProfileService implements ProfileService {
  final Map<String, UserProfileModel> _profiles = {};
  final Map<String, String> _avatars = {};

  // Demo user profile
  static final _demoProfile = UserProfileModel(
    id: 'demo-user-id',
    firstName: 'Анна',
    lastName: 'Иванова',
    email: 'anna.ivanova@example.com',
    phone: '+7 (999) 123-45-67',
    dateOfBirth: DateTime(1990, 5, 15),
    gender: Gender.female,
    height: 165.0,
    weight: 62.0,
    activityLevel: ActivityLevel.moderatelyActive,
    avatarUrl: null,
    dietaryPreferences: [DietaryPreference.vegetarian],
    allergies: ['Орехи', 'Молочные продукты'],
    healthConditions: [],
    fitnessGoals: ['Поддержание веса', 'Улучшение выносливости'],
    targetWeight: 60.0,
    targetCalories: 1800,
    targetProtein: 90.0,
    targetCarbs: 180.0,
    targetFat: 60.0,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  MockProfileService() {
    // Initialize with demo profile
    _profiles[_demoProfile.id] = _demoProfile;
  }

  @override
  Future<UserProfileModel?> getCurrentUserProfile() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return _demoProfile;
  }

  @override
  Future<UserProfileModel?> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profiles[userId];
  }

  @override
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_profiles.containsKey(profile.id)) {
      throw const ProfileServiceException(
        'Profile already exists',
        code: 'PROFILE_EXISTS',
      );
    }

    final newProfile = profile.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _profiles[profile.id] = newProfile;
    return newProfile;
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_profiles.containsKey(profile.id)) {
      throw const ProfileServiceException(
        'Profile not found',
        code: 'PROFILE_NOT_FOUND',
      );
    }

    final updatedProfile = profile.copyWith(
      updatedAt: DateTime.now(),
    );

    _profiles[profile.id] = updatedProfile;
    return updatedProfile;
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (!_profiles.containsKey(userId)) {
      throw const ProfileServiceException(
        'Profile not found',
        code: 'PROFILE_NOT_FOUND',
      );
    }

    _profiles.remove(userId);
    _avatars.remove(userId);
  }

  @override
  Future<String> uploadAvatar(String userId, File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!_profiles.containsKey(userId)) {
      throw const ProfileServiceException(
        'Profile not found',
        code: 'PROFILE_NOT_FOUND',
      );
    }

    // Simulate avatar upload
    final avatarUrl = 'https://example.com/avatars/$userId.jpg';
    _avatars[userId] = avatarUrl;

    // Update profile with new avatar URL
    final profile = _profiles[userId]!;
    _profiles[userId] = profile.copyWith(
      avatarUrl: avatarUrl,
      updatedAt: DateTime.now(),
    );

    return avatarUrl;
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!_profiles.containsKey(userId)) {
      throw const ProfileServiceException(
        'Profile not found',
        code: 'PROFILE_NOT_FOUND',
      );
    }

    _avatars.remove(userId);

    // Update profile to remove avatar URL
    final profile = _profiles[userId]!;
    _profiles[userId] = profile.copyWith(
      avatarUrl: null,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<bool> isEmailAvailable(String email, {String? excludeUserId}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return !_profiles.values.any(
        (profile) => profile.email == email && profile.id != excludeUserId);
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (!_profiles.containsKey(userId)) {
      throw const ProfileServiceException(
        'Profile not found',
        code: 'PROFILE_NOT_FOUND',
      );
    }

    final profile = _profiles[userId]!;
    return {
      'profile_completeness': profile.profileCompleteness,
      'days_since_created':
          DateTime.now().difference(profile.createdAt!).inDays,
      'last_updated': profile.updatedAt,
      'has_avatar': profile.avatarUrl != null,
      'goals_count': profile.fitnessGoals.length,
      'dietary_preferences_count': profile.dietaryPreferences.length,
      'allergies_count': profile.allergies.length,
      'health_conditions_count': profile.healthConditions.length,
    };
  }

  @override
  Future<Map<String, dynamic>> exportProfileData(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!_profiles.containsKey(userId)) {
      throw const ProfileServiceException(
        'Profile not found',
        code: 'PROFILE_NOT_FOUND',
      );
    }

    final profile = _profiles[userId]!;
    final statistics = await getProfileStatistics(userId);

    return {
      'profile': profile.toJson(),
      'statistics': statistics,
      'exported_at': DateTime.now().toIso8601String(),
      'export_version': '1.0',
    };
  }
}

/// Supabase implementation of ProfileService
class SupabaseProfileService implements ProfileService {
  final SupabaseClient _supabase;

  SupabaseProfileService(this._supabase);

  @override
  Future<UserProfileModel?> getCurrentUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw ProfileServiceException('User not authenticated');
      }

      return await getUserProfile(user.id);
    } catch (e) {
      if (e is ProfileServiceException) rethrow;
      throw ProfileServiceException('Failed to get current user profile: $e');
    }
  }

  @override
  Future<UserProfileModel?> getUserProfile(String userId) async {
    try {
      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();

      return _mapToUserProfileModel(response);
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        // No rows returned
        return null;
      }
      throw ProfileServiceException('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    try {
      final data = _mapToSupabaseData(profile);

      final response =
          await _supabase.from('profiles').insert(data).select().single();

      return _mapToUserProfileModel(response);
    } catch (e) {
      throw ProfileServiceException('Failed to create user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      final data = _mapToSupabaseData(profile);
      data['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('profiles')
          .update(data)
          .eq('id', profile.id)
          .select()
          .single();

      return _mapToUserProfileModel(response);
    } catch (e) {
      throw ProfileServiceException('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _supabase.from('profiles').delete().eq('id', userId);
    } catch (e) {
      throw ProfileServiceException('Failed to delete user profile: $e');
    }
  }

  @override
  Future<String> uploadAvatar(String userId, File imageFile) async {
    try {
      final fileName = 'avatar_$userId.jpg';
      final filePath = 'avatars/$fileName';

      await _supabase.storage.from('avatars').upload(filePath, imageFile);

      final url = _supabase.storage.from('avatars').getPublicUrl(filePath);

      // Update profile with new avatar URL
      await _supabase
          .from('profiles')
          .update({'avatar_url': url}).eq('id', userId);

      return url;
    } catch (e) {
      throw ProfileServiceException('Failed to upload avatar: $e');
    }
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    try {
      // Get current avatar URL
      final profile = await getUserProfile(userId);
      if (profile?.avatarUrl != null) {
        // Extract file path from URL
        final urlParts = profile!.avatarUrl!.split('/');
        final fileName = urlParts.last;
        final filePath = 'avatars/$fileName';

        // Delete from storage
        await _supabase.storage.from('avatars').remove([filePath]);
      }

      // Update profile to remove avatar URL
      await _supabase
          .from('profiles')
          .update({'avatar_url': null}).eq('id', userId);
    } catch (e) {
      throw ProfileServiceException('Failed to delete avatar: $e');
    }
  }

  @override
  Future<bool> isEmailAvailable(String email, {String? excludeUserId}) async {
    try {
      var query = _supabase.from('profiles').select('id').eq('email', email);

      if (excludeUserId != null) {
        query = query.neq('id', excludeUserId);
      }

      final response = await query;
      return response.isEmpty;
    } catch (e) {
      throw ProfileServiceException('Failed to check email availability: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics(String userId) async {
    try {
      // Get goals count
      final goalsResponse = await _supabase
          .from('user_goals')
          .select('type, status')
          .eq('user_id', userId);

      // Get progress entries count
      final progressResponse = await _supabase
          .from('progress_entries')
          .select('type')
          .eq('user_id', userId);

      // Calculate statistics
      final totalGoals = goalsResponse.length;
      final activeGoals =
          goalsResponse.where((g) => g['status'] == 'active').length;
      final completedGoals =
          goalsResponse.where((g) => g['status'] == 'completed').length;
      final totalProgressEntries = progressResponse.length;

      return {
        'total_goals': totalGoals,
        'active_goals': activeGoals,
        'completed_goals': completedGoals,
        'total_progress_entries': totalProgressEntries,
        'completion_rate': totalGoals > 0 ? (completedGoals / totalGoals) : 0.0,
      };
    } catch (e) {
      throw ProfileServiceException('Failed to get profile statistics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportProfileData(String userId) async {
    try {
      final profile = await getUserProfile(userId);
      if (profile == null) {
        throw ProfileServiceException('Profile not found');
      }

      // Get goals
      final goalsResponse =
          await _supabase.from('user_goals').select().eq('user_id', userId);

      // Get progress entries
      final progressResponse = await _supabase
          .from('progress_entries')
          .select()
          .eq('user_id', userId);

      return {
        'profile': _mapToSupabaseData(profile),
        'goals': goalsResponse,
        'progress_entries': progressResponse,
        'exported_at': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw ProfileServiceException('Failed to export profile data: $e');
    }
  }

  // Helper methods for data mapping
  Map<String, dynamic> _mapToSupabaseData(UserProfileModel profile) {
    return {
      'id': profile.id,
      'email': profile.email,
      'first_name': profile.firstName,
      'last_name': profile.lastName,
      'phone': profile.phone,
      'birth_date': profile.dateOfBirth?.toIso8601String(),
      'gender': profile.gender?.name,
      'height': profile.height,
      'weight': profile.weight,
      'activity_level': profile.activityLevel?.name,
      'avatar_url': profile.avatarUrl,
      'target_weight': profile.targetWeight,
      'target_calories': profile.targetCalories,
      'target_protein': profile.targetProtein,
      'target_carbs': profile.targetCarbs,
      'target_fat': profile.targetFat,
      'dietary_preferences':
          profile.dietaryPreferences.map((p) => p.name).toList(),
      'allergies': profile.allergies,
      'health_conditions': profile.healthConditions,
      'fitness_goals': profile.fitnessGoals,
      'food_restrictions': profile.foodRestrictions,
      'push_notifications_enabled': profile.pushNotificationsEnabled,
      'email_notifications_enabled': profile.emailNotificationsEnabled,
    };
  }

  UserProfileModel _mapToUserProfileModel(Map<String, dynamic> data) {
    return UserProfileModel(
      id: data['id'],
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      dateOfBirth: data['birth_date'] != null
          ? DateTime.parse(data['birth_date'])
          : null,
      gender: data['gender'] != null
          ? Gender.values.firstWhere(
              (g) => g.name == data['gender'],
              orElse: () => Gender.other,
            )
          : null,
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      activityLevel: data['activity_level'] != null
          ? ActivityLevel.values.firstWhere(
              (a) => a.name == data['activity_level'],
              orElse: () => ActivityLevel.sedentary,
            )
          : null,
      avatarUrl: data['avatar_url'],
      targetWeight: data['target_weight']?.toDouble(),
      targetCalories: data['target_calories']?.toInt(),
      targetProtein: data['target_protein']?.toDouble(),
      targetCarbs: data['target_carbs']?.toDouble(),
      targetFat: data['target_fat']?.toDouble(),
      dietaryPreferences: (data['dietary_preferences'] as List<dynamic>?)
              ?.map((p) => DietaryPreference.values.firstWhere(
                    (d) => d.name == p,
                    orElse: () => DietaryPreference.none,
                  ))
              .toList() ??
          [],
      allergies: (data['allergies'] as List<dynamic>?)?.cast<String>() ?? [],
      healthConditions:
          (data['health_conditions'] as List<dynamic>?)?.cast<String>() ?? [],
      fitnessGoals:
          (data['fitness_goals'] as List<dynamic>?)?.cast<String>() ?? [],
      foodRestrictions: data['food_restrictions'],
      pushNotificationsEnabled: data['push_notifications_enabled'] ?? true,
      emailNotificationsEnabled: data['email_notifications_enabled'] ?? true,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'])
          : DateTime.now(),
    );
  }
}
