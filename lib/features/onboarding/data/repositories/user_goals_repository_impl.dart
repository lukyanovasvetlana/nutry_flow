import '../../domain/entities/user_goals.dart';
import '../../domain/repositories/user_goals_repository.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';

/// Реализация репозитория для работы с целями пользователя
/// Использует Supabase для основного хранения и локальное хранилище для кэширования
class UserGoalsRepositoryImpl implements UserGoalsRepository {
  final SupabaseService _supabaseService;
  final LocalStorageService _localStorageService;

  static const String _tableName = 'user_goals';

  UserGoalsRepositoryImpl(
    this._supabaseService,
    this._localStorageService,
  );

  @override
  Future<UserGoals> saveUserGoals(UserGoals goals, String userId) async {
    try {
      // Подготовка данных для сохранения
      final data = {
        'id': goals.id,
        'user_id': goals.userId,
        'fitness_goals': goals.fitnessGoals,
        'dietary_preferences': goals.dietaryPreferences,
        'health_conditions': goals.healthConditions,
        'workout_types': goals.workoutTypes,
        'target_weight': goals.targetWeight,
        'target_calories': goals.targetCalories,
        'target_protein': goals.targetProtein,
        'target_carbs': goals.targetCarbs,
        'target_fat': goals.targetFat,
        'created_at': goals.createdAt.toIso8601String(),
        'updated_at': goals.updatedAt.toIso8601String(),
      };

      // Сохранение в Supabase
      final response = await _supabaseService.insertData(_tableName, data);

      if (response.isEmpty) {
        throw Exception('Ошибка сохранения в базу данных: пустой ответ');
      }

      // Кэширование в локальном хранилище
      await _localStorageService.saveUserGoals(goals.toJson(), userId);

      return goals;
    } catch (e) {
      // Если не удалось сохранить в Supabase, попытаемся сохранить локально
      await _localStorageService.saveUserGoals(goals.toJson(), userId);
      rethrow;
    }
  }

  @override
  Future<UserGoals?> getUserGoals(String userId) async {
    try {
      // Сначала пытаемся получить из Supabase
      final response = await _supabaseService.selectData(
        _tableName,
        column: 'user_id',
        value: userId,
      );

      if (response.isNotEmpty) {
        final data = response.first;
        final goals = _mapToUserGoals(data);

        // Кэшируем полученные данные
        await _localStorageService.saveUserGoals(goals.toJson(), userId);

        return goals;
      }

      // Если не удалось получить из Supabase, пытаемся получить из кэша
      final cachedData = _localStorageService.getUserGoals(userId);
      if (cachedData != null) {
        return UserGoals.fromJson(cachedData);
      }

      return null;
    } catch (e) {
      // В случае ошибки пытаемся получить из локального кэша
      final cachedData = _localStorageService.getUserGoals(userId);
      if (cachedData != null) {
        return UserGoals.fromJson(cachedData);
      }

      rethrow;
    }
  }

  @override
  Future<UserGoals> updateUserGoals(UserGoals goals, String userId) async {
    try {
      // Подготовка данных для обновления
      final data = {
        'fitness_goals': goals.fitnessGoals,
        'dietary_preferences': goals.dietaryPreferences,
        'health_conditions': goals.healthConditions,
        'workout_types': goals.workoutTypes,
        'target_weight': goals.targetWeight,
        'target_calories': goals.targetCalories,
        'target_protein': goals.targetProtein,
        'target_carbs': goals.targetCarbs,
        'target_fat': goals.targetFat,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Обновление в Supabase
      final response = await _supabaseService.updateData(
        _tableName,
        data,
        'user_id',
        userId,
      );

      if (response.isEmpty) {
        throw Exception('Ошибка обновления в базе данных: пустой ответ');
      }

      // Обновление кэша
      await _localStorageService.saveUserGoals(goals.toJson(), userId);

      return goals;
    } catch (e) {
      // Если не удалось обновить в Supabase, обновляем локально
      await _localStorageService.saveUserGoals(goals.toJson(), userId);
      rethrow;
    }
  }

  @override
  Future<bool> deleteUserGoals(String userId) async {
    try {
      // Удаление из Supabase
      final response = await _supabaseService.deleteData(
        _tableName,
        'user_id',
        userId,
      );

      if (response.isEmpty) {
        throw Exception('Ошибка удаления из базы данных: пустой ответ');
      }

      // Удаление из локального кэша
      await _localStorageService.deleteUserGoals(userId);

      return true;
    } catch (e) {
      // Удаляем из локального кэша в любом случае
      await _localStorageService.deleteUserGoals(userId);
      rethrow;
    }
  }

  /// Преобразует данные из базы в модель UserGoals
  UserGoals _mapToUserGoals(Map<String, dynamic> data) {
    return UserGoals(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      fitnessGoals: List<String>.from(data['fitness_goals'] ?? []),
      dietaryPreferences: List<String>.from(data['dietary_preferences'] ?? []),
      healthConditions: List<String>.from(data['health_conditions'] ?? []),
      allergens: List<String>.from(data['allergens'] ?? []),
      workoutTypes: List<String>.from(data['workout_types'] ?? []),
      targetWeight: data['target_weight']?.toDouble(),
      targetCalories: data['target_calories'] as int?,
      targetProtein: data['target_protein']?.toDouble(),
      targetCarbs: data['target_carbs']?.toDouble(),
      targetFat: data['target_fat']?.toDouble(),
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}
