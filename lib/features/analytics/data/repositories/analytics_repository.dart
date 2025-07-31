import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/analytics/domain/entities/analytics_data.dart';
import 'package:nutry_flow/features/analytics/domain/entities/nutrition_tracking.dart';
import 'package:nutry_flow/features/analytics/domain/entities/weight_tracking.dart';
import 'package:nutry_flow/features/analytics/domain/entities/activity_tracking.dart';
import 'package:nutry_flow/features/analytics/domain/entities/analytics_event.dart' as domain;
import 'dart:developer' as developer;

class AnalyticsRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  
  /// Отслеживание аналитического события
  Future<void> trackEvent(domain.AnalyticsEvent event) async {
    try {
      developer.log('📊 AnalyticsRepository: Tracking event: ${event.name}', name: 'AnalyticsRepository');
      
      if (_supabaseService.isAvailable) {
        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('📊 AnalyticsRepository: User not authenticated for tracking', name: 'AnalyticsRepository');
          return;
        }
        
        await _supabaseService.saveUserData('analytics_events', {
          'user_id': user.id,
          'event_name': event.name,
          'parameters': event.parameters,
          'session_id': event.sessionId,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        developer.log('📊 AnalyticsRepository: Event tracked successfully', name: 'AnalyticsRepository');
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, event tracking skipped', name: 'AnalyticsRepository');
        // В демо-режиме просто логируем событие
        developer.log('📊 AnalyticsRepository: Demo mode - Event: ${event.name}, Parameters: ${event.parameters}', name: 'AnalyticsRepository');
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Track event failed: $e', name: 'AnalyticsRepository');
      // Не выбрасываем исключение, чтобы не прерывать работу приложения
    }
  }
  
  /// Сохранение данных о питании
  Future<void> saveNutritionTracking(NutritionTracking tracking) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('📊 AnalyticsRepository: Saving nutrition tracking via Supabase', name: 'AnalyticsRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }
        
        await _supabaseService.saveUserData('nutrition_tracking', {
          'user_id': user.id,
          'id': tracking.id,
          'date': tracking.date.toIso8601String(),
          'calories_consumed': tracking.caloriesConsumed,
          'protein_consumed': tracking.proteinConsumed,
          'fat_consumed': tracking.fatConsumed,
          'carbs_consumed': tracking.carbsConsumed,
          'fiber_consumed': tracking.fiberConsumed,
          'water_consumed': tracking.waterConsumed,
          'meals_count': tracking.mealsCount,
          'notes': tracking.notes,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        developer.log('📊 AnalyticsRepository: Nutrition tracking saved successfully', name: 'AnalyticsRepository');
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, using mock', name: 'AnalyticsRepository');
        await _saveNutritionTrackingLocally(tracking);
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Save nutrition tracking failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  /// Получение данных о питании за период
  Future<List<NutritionTracking>> getNutritionTracking(DateTime startDate, DateTime endDate) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('📊 AnalyticsRepository: Getting nutrition tracking via Supabase', name: 'AnalyticsRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('📊 AnalyticsRepository: User not authenticated', name: 'AnalyticsRepository');
          return [];
        }
        
        final data = await _supabaseService.getUserData('nutrition_tracking', userId: user.id);
        
        final tracking = data.map((item) => NutritionTracking(
          id: item['id'],
          userId: user.id,
          date: DateTime.parse(item['date']),
          caloriesConsumed: item['calories_consumed'] ?? 0,
          proteinConsumed: item['protein_consumed'] ?? 0,
          fatConsumed: item['fat_consumed'] ?? 0,
          carbsConsumed: item['carbs_consumed'] ?? 0,
          fiberConsumed: item['fiber_consumed'] ?? 0,
          sugarConsumed: item['sugar_consumed'] ?? 0,
          sodiumConsumed: item['sodium_consumed'] ?? 0,
          waterConsumed: item['water_consumed'] ?? 0,
          mealsCount: item['meals_count'] ?? 0,
          notes: item['notes'],
          mealType: item['meal_type'] ?? 'general',
          foodItems: List<String>.from(item['food_items'] ?? []),
          createdAt: DateTime.parse(item['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(item['updated_at'] ?? DateTime.now().toIso8601String()),
        )).toList();
        
        // Фильтруем по датам
        final filteredTracking = tracking.where((item) => 
          item.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          item.date.isBefore(endDate.add(const Duration(days: 1)))
        ).toList();
        
        developer.log('📊 AnalyticsRepository: Nutrition tracking retrieved successfully', name: 'AnalyticsRepository');
        return filteredTracking;
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, using mock', name: 'AnalyticsRepository');
        return await _getNutritionTrackingLocally(startDate, endDate);
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Get nutrition tracking failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  /// Сохранение данных о весе
  Future<void> saveWeightTracking(WeightTracking tracking) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('📊 AnalyticsRepository: Saving weight tracking via Supabase', name: 'AnalyticsRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }
        
        await _supabaseService.saveUserData('weight_tracking', {
          'user_id': user.id,
          'id': tracking.id,
          'date': tracking.date.toIso8601String(),
          'weight': tracking.weight,
          'body_fat_percentage': tracking.bodyFatPercentage,
          'muscle_mass': tracking.muscleMass,
          'bmi': tracking.bmi,
          'notes': tracking.notes,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        developer.log('📊 AnalyticsRepository: Weight tracking saved successfully', name: 'AnalyticsRepository');
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, using mock', name: 'AnalyticsRepository');
        await _saveWeightTrackingLocally(tracking);
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Save weight tracking failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  /// Получение данных о весе за период
  Future<List<WeightTracking>> getWeightTracking(DateTime startDate, DateTime endDate) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('📊 AnalyticsRepository: Getting weight tracking via Supabase', name: 'AnalyticsRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('📊 AnalyticsRepository: User not authenticated', name: 'AnalyticsRepository');
          return [];
        }
        
        final data = await _supabaseService.getUserData('weight_tracking', userId: user.id);
        
        final tracking = data.map((item) => WeightTracking(
          id: item['id'],
          userId: user.id,
          date: DateTime.parse(item['date']),
          weight: item['weight'] ?? 0.0,
          bodyFatPercentage: item['body_fat_percentage'],
          muscleMass: item['muscle_mass'],
          waterPercentage: item['water_percentage'],
          bmi: item['bmi'],
          notes: item['notes'],
          createdAt: DateTime.parse(item['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(item['updated_at'] ?? DateTime.now().toIso8601String()),
        )).toList();
        
        // Фильтруем по датам
        final filteredTracking = tracking.where((item) => 
          item.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          item.date.isBefore(endDate.add(const Duration(days: 1)))
        ).toList();
        
        developer.log('📊 AnalyticsRepository: Weight tracking retrieved successfully', name: 'AnalyticsRepository');
        return filteredTracking;
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, using mock', name: 'AnalyticsRepository');
        return await _getWeightTrackingLocally(startDate, endDate);
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Get weight tracking failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  /// Сохранение данных об активности
  Future<void> saveActivityTracking(ActivityTracking tracking) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('📊 AnalyticsRepository: Saving activity tracking via Supabase', name: 'AnalyticsRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }
        
        await _supabaseService.saveUserData('activity_tracking', {
          'user_id': user.id,
          'id': tracking.id,
          'date': tracking.date.toIso8601String(),
          'steps_count': tracking.stepsCount,
          'distance_km': tracking.distance,
          'calories_burned': tracking.caloriesBurned,
          'active_minutes': tracking.workoutDuration,
          'workout_duration': tracking.workoutDuration,
          'workout_type': tracking.workoutType,
          'notes': tracking.notes,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        developer.log('📊 AnalyticsRepository: Activity tracking saved successfully', name: 'AnalyticsRepository');
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, using mock', name: 'AnalyticsRepository');
        await _saveActivityTrackingLocally(tracking);
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Save activity tracking failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  /// Получение данных об активности за период
  Future<List<ActivityTracking>> getActivityTracking(DateTime startDate, DateTime endDate) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('📊 AnalyticsRepository: Getting activity tracking via Supabase', name: 'AnalyticsRepository');
        
        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('📊 AnalyticsRepository: User not authenticated', name: 'AnalyticsRepository');
          return [];
        }
        
        final data = await _supabaseService.getUserData('activity_tracking', userId: user.id);
        
        final tracking = data.map((item) => ActivityTracking(
          id: item['id'],
          userId: user.id,
          date: DateTime.parse(item['date']),
          stepsCount: item['steps_count'] ?? 0,
          caloriesBurned: item['calories_burned'] ?? 0,
          workoutDuration: item['workout_duration'] ?? 0,
          distance: item['distance_km'] ?? 0.0,
          workoutType: item['workout_type'],
          averageHeartRate: item['average_heart_rate'],
          maxHeartRate: item['max_heart_rate'],
          notes: item['notes'],
          createdAt: DateTime.parse(item['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(item['updated_at'] ?? DateTime.now().toIso8601String()),
        )).toList();
        
        // Фильтруем по датам
        final filteredTracking = tracking.where((item) => 
          item.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          item.date.isBefore(endDate.add(const Duration(days: 1)))
        ).toList();
        
        developer.log('📊 AnalyticsRepository: Activity tracking retrieved successfully', name: 'AnalyticsRepository');
        return filteredTracking;
      } else {
        developer.log('📊 AnalyticsRepository: Supabase not available, using mock', name: 'AnalyticsRepository');
        return await _getActivityTrackingLocally(startDate, endDate);
      }
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Get activity tracking failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  /// Получение агрегированных данных аналитики
  Future<AnalyticsData> getAnalyticsData(DateTime startDate, DateTime endDate) async {
    try {
      developer.log('📊 AnalyticsRepository: Getting analytics data', name: 'AnalyticsRepository');
      
      final nutritionData = await getNutritionTracking(startDate, endDate);
      final weightData = await getWeightTracking(startDate, endDate);
      final activityData = await getActivityTracking(startDate, endDate);
      
      final user = _supabaseService.currentUser;
      final analyticsData = AnalyticsData(
        userId: user?.id ?? 'unknown',
        date: DateTime.now(),
        nutritionTracking: nutritionData,
        weightTracking: weightData,
        activityTracking: activityData,
        period: '${startDate.day}/${startDate.month} - ${endDate.day}/${endDate.month}',
      );
      
      developer.log('📊 AnalyticsRepository: Analytics data retrieved successfully', name: 'AnalyticsRepository');
      return analyticsData;
    } catch (e) {
      developer.log('📊 AnalyticsRepository: Get analytics data failed: $e', name: 'AnalyticsRepository');
      rethrow;
    }
  }
  
  // Mock методы для fallback
  Future<void> _saveNutritionTrackingLocally(NutritionTracking tracking) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('📊 AnalyticsRepository: Mock save nutrition tracking', name: 'AnalyticsRepository');
  }
  
  Future<List<NutritionTracking>> _getNutritionTrackingLocally(DateTime startDate, DateTime endDate) async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('📊 AnalyticsRepository: Mock get nutrition tracking', name: 'AnalyticsRepository');
    return [];
  }
  
  Future<void> _saveWeightTrackingLocally(WeightTracking tracking) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('📊 AnalyticsRepository: Mock save weight tracking', name: 'AnalyticsRepository');
  }
  
  Future<List<WeightTracking>> _getWeightTrackingLocally(DateTime startDate, DateTime endDate) async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('📊 AnalyticsRepository: Mock get weight tracking', name: 'AnalyticsRepository');
    return [];
  }
  
  Future<void> _saveActivityTrackingLocally(ActivityTracking tracking) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('📊 AnalyticsRepository: Mock save activity tracking', name: 'AnalyticsRepository');
  }
  
  Future<List<ActivityTracking>> _getActivityTrackingLocally(DateTime startDate, DateTime endDate) async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('📊 AnalyticsRepository: Mock get activity tracking', name: 'AnalyticsRepository');
    return [];
  }
} 