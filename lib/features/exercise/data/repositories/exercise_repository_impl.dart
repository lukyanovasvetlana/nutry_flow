import 'package:nutry_flow/core/services/supabase_service.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../models/exercise_model.dart';
import '../services/exercise_service.dart';
import 'dart:developer' as developer;

/// Реализация репозитория для работы с упражнениями
class ExerciseRepositoryImpl implements ExerciseRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  @override
  Future<void> saveExercise(Exercise exercise) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Saving exercise via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final model = ExerciseModel.fromEntity(exercise);
        await _supabaseService.saveUserData('exercises', model.toJson());

        developer.log('💪 ExerciseRepository: Exercise saved successfully',
            name: 'ExerciseRepository');
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        await _saveExerciseLocally(exercise);
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Save exercise failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  @override
  Future<List<Exercise>> getAllExercises() async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Getting exercises via Supabase',
            name: 'ExerciseRepository');

        final exercisesData = await _supabaseService.getUserData('exercises');

        final exercises = exercisesData.map(ExerciseModel.fromJson).toList();

        developer.log('💪 ExerciseRepository: Exercises retrieved successfully',
            name: 'ExerciseRepository');
        return exercises;
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        return await _getExercisesLocally();
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Get exercises failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  @override
  Future<List<Exercise>> getExercisesByCategory(String category) async {
    try {
      final allExercises = await getAllExercises();
      // Поддерживаем как enum name, так и строковое значение
      return allExercises.where((exercise) {
        final categoryName = exercise.category.name.toLowerCase();
        final searchCategory = category.toLowerCase();
        return categoryName == searchCategory ||
            categoryName.contains(searchCategory) ||
            searchCategory.contains(categoryName);
      }).toList();
    } catch (e) {
      developer.log(
          '💪 ExerciseRepository: Get exercises by category failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    try {
      final allExercises = await getAllExercises();
      try {
        return allExercises.firstWhere((exercise) => exercise.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Get exercise by id failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  @override
  Future<void> deleteExercise(String exerciseId) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Deleting exercise via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        // TODO: Реализовать удаление через Supabase
        await _supabaseService.deleteUserData('exercises', exerciseId);

        developer.log('💪 ExerciseRepository: Exercise deleted successfully',
            name: 'ExerciseRepository');
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        await _deleteExerciseLocally(exerciseId);
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Delete exercise failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  // Mock методы для fallback
  Future<void> _saveExerciseLocally(Exercise exercise) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock save exercise',
        name: 'ExerciseRepository');
  }

  Future<List<Exercise>> _getExercisesLocally() async {
    // Используем локальный сервис для получения упражнений
    final exercises = ExerciseService.getAllExercises();
    // Преобразуем старую модель в новую entity
    return exercises.map((e) {
      // Маппинг из старой модели в новую entity
      ExerciseCategory category;
      try {
        category = ExerciseCategory.values.firstWhere(
          (c) => c.name.toLowerCase() == e.category.toLowerCase(),
          orElse: () => ExerciseCategory.legs,
        );
      } catch (_) {
        category = ExerciseCategory.legs;
      }

      ExerciseDifficulty difficulty;
      try {
        difficulty = ExerciseDifficulty.values.firstWhere(
          (d) => d.name.toLowerCase() == e.difficulty.toLowerCase(),
          orElse: () => ExerciseDifficulty.beginner,
        );
      } catch (_) {
        difficulty = ExerciseDifficulty.beginner;
      }

      return Exercise(
        id: e.id,
        name: e.name,
        category: category,
        difficulty: difficulty,
        sets: e.sets,
        reps: e.reps,
        restSeconds: e.restSeconds,
        duration: e.duration,
        iconName: e.iconName,
        description: e.description,
        targetMuscles: e.targetMuscles,
        equipment: e.equipment,
        isFavorite: false,
      );
    }).toList();
  }

  Future<void> _deleteExerciseLocally(String exerciseId) async {
    // TODO: Реализовать локальное удаление через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock delete exercise',
        name: 'ExerciseRepository');
  }
}
