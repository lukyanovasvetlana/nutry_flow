import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/exercise.dart';
import '../models/exercise_model.dart';

class SupabaseExerciseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Получить все упражнения
  Future<List<Exercise>> getAllExercises() async {
    try {
      final response = await _supabase.from('exercises').select().order('name');

      return response
          .map((json) => ExerciseModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при получении упражнений: $e');
    }
  }

  // Получить упражнение по ID
  Future<Exercise?> getExerciseById(String id) async {
    try {
      final response =
          await _supabase.from('exercises').select().eq('id', id).single();

      return ExerciseModel.fromJson(response).toEntity();
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        return null; // Упражнение не найдено
      }
      throw Exception('Ошибка при получении упражнения: $e');
    }
  }

  // Поиск упражнений
  Future<List<Exercise>> searchExercises(String query) async {
    try {
      final response = await _supabase
          .from('exercises')
          .select()
          .or('name.ilike.%$query%,category.ilike.%$query%')
          .order('name');

      return response
          .map((json) => ExerciseModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при поиске упражнений: $e');
    }
  }

  // Фильтрация по категории
  Future<List<Exercise>> filterByCategory(String category) async {
    try {
      final response = await _supabase
          .from('exercises')
          .select()
          .eq('category', category)
          .order('name');

      return response
          .map((json) => ExerciseModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при фильтрации по категории: $e');
    }
  }

  // Фильтрация по сложности
  Future<List<Exercise>> filterByDifficulty(String difficulty) async {
    try {
      final response = await _supabase
          .from('exercises')
          .select()
          .eq('difficulty', difficulty)
          .order('name');

      return response
          .map((json) => ExerciseModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при фильтрации по сложности: $e');
    }
  }

  // Получить избранные упражнения пользователя
  Future<List<Exercise>> getFavoriteExercises(String userId) async {
    try {
      final response =
          await _supabase.from('user_favorite_exercises').select('''
            exercise_id,
            exercises (*)
          ''').eq('user_id', userId).order('created_at', ascending: false);

      return response
          .map((json) => ExerciseModel.fromJson(json['exercises']).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при получении избранных упражнений: $e');
    }
  }

  // Переключить избранное упражнение
  Future<void> toggleFavorite(String userId, String exerciseId) async {
    try {
      // Проверяем, есть ли уже в избранном
      final existing = await _supabase
          .from('user_favorite_exercises')
          .select()
          .eq('user_id', userId)
          .eq('exercise_id', exerciseId)
          .maybeSingle();

      if (existing != null) {
        // Удаляем из избранного
        await _supabase
            .from('user_favorite_exercises')
            .delete()
            .eq('user_id', userId)
            .eq('exercise_id', exerciseId);
      } else {
        // Добавляем в избранное
        await _supabase.from('user_favorite_exercises').insert({
          'user_id': userId,
          'exercise_id': exerciseId,
        });
      }
    } catch (e) {
      throw Exception('Ошибка при изменении избранного: $e');
    }
  }

  // Получить категории упражнений
  Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('exercises')
          .select('category')
          .order('category');

      final categories =
          response.map((json) => json['category'] as String).toSet().toList();

      return ['All', ...categories];
    } catch (e) {
      throw Exception('Ошибка при получении категорий: $e');
    }
  }

  // Получить уровни сложности
  Future<List<String>> getDifficulties() async {
    try {
      final response = await _supabase
          .from('exercises')
          .select('difficulty')
          .order('difficulty');

      final difficulties =
          response.map((json) => json['difficulty'] as String).toSet().toList();

      return ['All', ...difficulties];
    } catch (e) {
      throw Exception('Ошибка при получении уровней сложности: $e');
    }
  }

  // Проверить, является ли упражнение избранным
  Future<bool> isFavorite(String userId, String exerciseId) async {
    try {
      final response = await _supabase
          .from('user_favorite_exercises')
          .select()
          .eq('user_id', userId)
          .eq('exercise_id', exerciseId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
