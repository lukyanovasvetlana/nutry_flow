import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/workout.dart';
import '../models/workout_model.dart';

class SupabaseWorkoutService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Получить тренировки пользователя
  Future<List<Workout>> getUserWorkouts(String userId) async {
    try {
      final response = await _supabase
          .from('workouts')
          .select('''
            *,
            workout_exercises (
              *,
              exercises (*)
            )
          ''')
          .eq('user_id', userId)
          .eq('is_template', false)
          .order('created_at', ascending: false);

      return response
          .map((json) => WorkoutModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при получении тренировок: $e');
    }
  }

  // Получить тренировку по ID
  Future<Workout?> getWorkoutById(String id) async {
    try {
      final response = await _supabase.from('workouts').select('''
            *,
            workout_exercises (
              *,
              exercises (*)
            )
          ''').eq('id', id).single();

      return WorkoutModel.fromJson(response).toEntity();
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        return null; // Тренировка не найдена
      }
      throw Exception('Ошибка при получении тренировки: $e');
    }
  }

  // Получить шаблоны тренировок
  Future<List<Workout>> getWorkoutTemplates(String userId) async {
    try {
      final response = await _supabase
          .from('workouts')
          .select('''
            *,
            workout_exercises (
              *,
              exercises (*)
            )
          ''')
          .eq('user_id', userId)
          .eq('is_template', true)
          .order('created_at', ascending: false);

      return response
          .map((json) => WorkoutModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при получении шаблонов: $e');
    }
  }

  // Создать тренировку
  Future<Workout> createWorkout(Workout workout) async {
    try {
      // Создаем тренировку
      final workoutResponse = await _supabase
          .from('workouts')
          .insert(WorkoutModel.fromEntity(workout).toJson())
          .select()
          .single();

      final createdWorkout = WorkoutModel.fromJson(workoutResponse);

      // Добавляем упражнения к тренировке
      if (workout.exercises.isNotEmpty) {
        final workoutExercises = workout.exercises.map((exercise) {
          return {
            'workout_id': createdWorkout.id,
            'exercise_id': exercise.exercise.id,
            'order_index': exercise.orderIndex,
            'sets': exercise.sets,
            'reps': exercise.reps,
            'rest_seconds': exercise.restSeconds,
            'duration': exercise.duration,
            'notes': exercise.notes,
          };
        }).toList();

        await _supabase.from('workout_exercises').insert(workoutExercises);
      }

      // Получаем полную тренировку с упражнениями
      return await getWorkoutById(createdWorkout.id) ?? workout;
    } catch (e) {
      throw Exception('Ошибка при создании тренировки: $e');
    }
  }

  // Обновить тренировку
  Future<Workout> updateWorkout(Workout workout) async {
    try {
      // Обновляем тренировку
      await _supabase
          .from('workouts')
          .update(WorkoutModel.fromEntity(workout).toJson())
          .eq('id', workout.id);

      // Удаляем старые упражнения
      await _supabase
          .from('workout_exercises')
          .delete()
          .eq('workout_id', workout.id);

      // Добавляем новые упражнения
      if (workout.exercises.isNotEmpty) {
        final workoutExercises = workout.exercises.map((exercise) {
          return {
            'workout_id': workout.id,
            'exercise_id': exercise.exercise.id,
            'order_index': exercise.orderIndex,
            'sets': exercise.sets,
            'reps': exercise.reps,
            'rest_seconds': exercise.restSeconds,
            'duration': exercise.duration,
            'notes': exercise.notes,
          };
        }).toList();

        await _supabase.from('workout_exercises').insert(workoutExercises);
      }

      // Получаем обновленную тренировку
      return await getWorkoutById(workout.id) ?? workout;
    } catch (e) {
      throw Exception('Ошибка при обновлении тренировки: $e');
    }
  }

  // Удалить тренировку
  Future<void> deleteWorkout(String id) async {
    try {
      await _supabase.from('workouts').delete().eq('id', id);
    } catch (e) {
      throw Exception('Ошибка при удалении тренировки: $e');
    }
  }

  // Сохранить как шаблон
  Future<void> saveAsTemplate(String workoutId) async {
    try {
      await _supabase
          .from('workouts')
          .update({'is_template': true}).eq('id', workoutId);
    } catch (e) {
      throw Exception('Ошибка при сохранении шаблона: $e');
    }
  }

  // Поиск тренировок
  Future<List<Workout>> searchWorkouts(String userId, String query) async {
    try {
      final response = await _supabase
          .from('workouts')
          .select('''
            *,
            workout_exercises (
              *,
              exercises (*)
            )
          ''')
          .eq('user_id', userId)
          .eq('is_template', false)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return response
          .map((json) => WorkoutModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при поиске тренировок: $e');
    }
  }

  // Фильтрация по сложности
  Future<List<Workout>> filterWorkoutsByDifficulty(
      String userId, String difficulty) async {
    try {
      final response = await _supabase
          .from('workouts')
          .select('''
            *,
            workout_exercises (
              *,
              exercises (*)
            )
          ''')
          .eq('user_id', userId)
          .eq('is_template', false)
          .eq('difficulty', difficulty)
          .order('created_at', ascending: false);

      return response
          .map((json) => WorkoutModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Ошибка при фильтрации тренировок: $e');
    }
  }
}
