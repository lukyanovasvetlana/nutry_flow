import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/core/services/local_cache_service.dart';
import 'package:nutry_flow/core/services/sync_service.dart';
import 'package:nutry_flow/features/onboarding/domain/entities/user_goals.dart';
import 'dart:developer' as developer;

class UserDataRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final LocalCacheService _localCache = LocalCacheService.instance;
  final SyncService _syncService = SyncService.instance;
  
    /// Сохранение целей пользователя
  Future<void> saveUserGoals(UserGoals goals) async {
    try {
      developer.log('🟪 UserDataRepository: Saving goals with sync', name: 'UserDataRepository');

      final goalsData = {
        'fitness_goals': goals.fitnessGoals,
        'target_calories': goals.targetCalories,
        'target_protein': goals.targetProtein,
        'dietary_preferences': goals.dietaryPreferences,
        'allergens': goals.allergens,
        'workout_types': goals.workoutTypes,
        'workout_frequency': goals.workoutFrequency,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Сохраняем с синхронизацией
      await _syncService.saveWithSync(
        tableName: 'user_goals',
        cacheKey: 'user_goals_cache',
        data: goalsData,
        toJson: (data) => data,
      );

      developer.log('🟪 UserDataRepository: Goals saved successfully', name: 'UserDataRepository');
    } catch (e) {
      developer.log('🟪 UserDataRepository: Save goals failed: $e', name: 'UserDataRepository');
      rethrow;
    }
  }
  
    /// Получение целей пользователя
  Future<UserGoals?> getUserGoals() async {
    try {
      developer.log('🟪 UserDataRepository: Getting goals with sync', name: 'UserDataRepository');

      final syncResult = await _syncService.syncData<Map<String, dynamic>>(
        tableName: 'user_goals',
        cacheKey: 'user_goals_cache',
        fromJson: (data) => data,
        toJson: (data) => data,
        strategy: ConflictResolutionStrategy.serverWins,
      );

      if (syncResult.data.isNotEmpty) {
        final goalsData = syncResult.data.first;
        final goals = UserGoals(
          fitnessGoals: List<String>.from(goalsData['fitness_goals'] ?? []),
          targetCalories: goalsData['target_calories'] ?? 2000,
          targetProtein: goalsData['target_protein'] ?? 150,
          dietaryPreferences: List<String>.from(goalsData['dietary_preferences'] ?? []),
          allergens: List<String>.from(goalsData['allergens'] ?? []),
          workoutTypes: List<String>.from(goalsData['workout_types'] ?? []),
          workoutFrequency: goalsData['workout_frequency'],
        );

        developer.log('🟪 UserDataRepository: Goals retrieved successfully from ${syncResult.source}', name: 'UserDataRepository');
        return goals;
      }

      developer.log('🟪 UserDataRepository: No goals found', name: 'UserDataRepository');
      return null;
    } catch (e) {
      developer.log('🟪 UserDataRepository: Get goals failed: $e', name: 'UserDataRepository');
      rethrow;
    }
  }
  
  /// Сохранение профиля пользователя
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('🟪 UserDataRepository: Saving profile via Supabase', name: 'UserDataRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }
        
        await _supabaseService.saveUserData('user_profiles', {
          'user_id': user.id,
          ...profile,
          'updated_at': DateTime.now().toIso8601String(),
        });
        
        developer.log('🟪 UserDataRepository: Profile saved successfully', name: 'UserDataRepository');
      } else {
        developer.log('🟪 UserDataRepository: Supabase not available, using mock', name: 'UserDataRepository');
        // Fallback к mock сохранению
        await _saveProfileLocally(profile);
      }
    } catch (e) {
      developer.log('🟪 UserDataRepository: Save profile failed: $e', name: 'UserDataRepository');
      rethrow;
    }
  }
  
  /// Получение профиля пользователя
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('🟪 UserDataRepository: Getting profile via Supabase', name: 'UserDataRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('🟪 UserDataRepository: User not authenticated', name: 'UserDataRepository');
          return null;
        }
        
        final data = await _supabaseService.getUserData('user_profiles', userId: user.id);
        
        if (data.isNotEmpty) {
          developer.log('🟪 UserDataRepository: Profile retrieved successfully', name: 'UserDataRepository');
          return data.first;
        }
        
        developer.log('🟪 UserDataRepository: No profile found', name: 'UserDataRepository');
        return null;
      } else {
        developer.log('🟪 UserDataRepository: Supabase not available, using mock', name: 'UserDataRepository');
        // Fallback к mock получению
        return await _getProfileLocally();
      }
    } catch (e) {
      developer.log('🟪 UserDataRepository: Get profile failed: $e', name: 'UserDataRepository');
      rethrow;
    }
  }
  
  // Mock методы для fallback
  Future<void> _saveGoalsLocally(UserGoals goals) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('🟪 UserDataRepository: Mock save goals', name: 'UserDataRepository');
  }
  
  Future<UserGoals?> _getGoalsLocally() async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('🟪 UserDataRepository: Mock get goals', name: 'UserDataRepository');
    return null;
  }
  
  Future<void> _saveProfileLocally(Map<String, dynamic> profile) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('🟪 UserDataRepository: Mock save profile', name: 'UserDataRepository');
  }
  
  Future<Map<String, dynamic>?> _getProfileLocally() async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('🟪 UserDataRepository: Mock get profile', name: 'UserDataRepository');
    return null;
  }
} 