import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/activity/domain/entities/exercise.dart';
import 'package:nutry_flow/features/activity/domain/entities/workout.dart';
import 'package:nutry_flow/features/activity/domain/entities/activity_session.dart';
import 'dart:developer' as developer;

class ExerciseRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Сохранение упражнения
  Future<void> saveExercise(Exercise exercise) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Saving exercise via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        await _supabaseService.saveUserData('exercises', {
          'user_id': user.id,
          'id': exercise.id,
          'name': exercise.name,
          'description': exercise.description,
          'category': exercise.category.name,
          'muscle_groups': exercise.targetMuscles,
          'equipment': exercise.equipment.join(', '),
          'difficulty': exercise.difficulty.name,
          'video_url': exercise.videoUrl,
          'image_url': exercise.imageUrl,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

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

  /// Получение всех упражнений
  Future<List<Exercise>> getAllExercises() async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Getting exercises via Supabase',
            name: 'ExerciseRepository');

        final exercisesData = await _supabaseService.getUserData('exercises');

        final exercises = exercisesData
            .map((data) => Exercise(
                  id: data['id'],
                  name: data['name'] ?? 'Упражнение',
                  description: data['description'] ?? '',
                  category: ExerciseCategory.values.firstWhere(
                    (e) => e.name == (data['category'] ?? 'legs'),
                    orElse: () => ExerciseCategory.legs,
                  ),
                  difficulty: ExerciseDifficulty.values.firstWhere(
                    (e) => e.name == (data['difficulty'] ?? 'beginner'),
                    orElse: () => ExerciseDifficulty.beginner,
                  ),
                  iconName: 'exercise_icon',
                  targetMuscles: List<String>.from(data['muscle_groups'] ?? []),
                  equipment: (data['equipment'] ?? 'bodyweight').split(', '),
                  videoUrl: data['video_url'],
                  imageUrl: data['image_url'],
                ))
            .toList();

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

  /// Получение упражнений по категории
  Future<List<Exercise>> getExercisesByCategory(String category) async {
    try {
      final allExercises = await getAllExercises();
      return allExercises
          .where((exercise) => exercise.category == category)
          .toList();
    } catch (e) {
      developer.log(
          '💪 ExerciseRepository: Get exercises by category failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  /// Сохранение тренировки
  Future<void> saveWorkout(Workout workout) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Saving workout via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        await _supabaseService.saveUserData('workouts', {
          'user_id': user.id,
          'id': workout.id,
          'name': workout.name,
          'description': workout.description,
          'difficulty': workout.difficulty.name,
          'estimated_duration': workout.estimatedDurationMinutes,
          'is_favorite': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Сохраняем упражнения тренировки
        for (final exercise in workout.exercises) {
          await _supabaseService.saveUserData('workout_exercises', {
            'workout_id': workout.id,
            'exercise_id': exercise.exercise.id,
            'sets': exercise.sets,
            'reps': exercise.reps,
            'duration': exercise.duration,
            'rest_time': exercise.restSeconds,
            'order': exercise.orderIndex,
            'created_at': DateTime.now().toIso8601String(),
          });
        }

        developer.log('💪 ExerciseRepository: Workout saved successfully',
            name: 'ExerciseRepository');
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        await _saveWorkoutLocally(workout);
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Save workout failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  /// Получение тренировок пользователя
  Future<List<Workout>> getUserWorkouts() async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('💪 ExerciseRepository: Getting workouts via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('💪 ExerciseRepository: User not authenticated',
              name: 'ExerciseRepository');
          return [];
        }

        final workoutsData =
            await _supabaseService.getUserData('workouts', userId: user.id);

        final List<Workout> workouts = [];

        for (final workoutData in workoutsData) {
          // Получаем упражнения для этой тренировки
          final exercisesData = await _supabaseService
              .getUserData('workout_exercises', userId: user.id);
          final workoutExercises = exercisesData
              .where((exercise) => exercise['workout_id'] == workoutData['id'])
              .toList();

          final exercises = workoutExercises
              .map((exerciseData) => WorkoutExercise(
                    id: exerciseData['id'] ?? '',
                    exercise: Exercise(
                      id: exerciseData['exercise_id'],
                      name: exerciseData['name'] ?? 'Упражнение',
                      description: exerciseData['description'] ?? '',
                      category: ExerciseCategory.values.firstWhere(
                        (e) => e.name == (exerciseData['category'] ?? 'legs'),
                        orElse: () => ExerciseCategory.legs,
                      ),
                      difficulty: ExerciseDifficulty.values.firstWhere(
                        (e) =>
                            e.name ==
                            (exerciseData['difficulty'] ?? 'beginner'),
                        orElse: () => ExerciseDifficulty.beginner,
                      ),
                      iconName: 'exercise_icon',
                      targetMuscles: List<String>.from(
                          exerciseData['muscle_groups'] ?? []),
                      equipment: (exerciseData['equipment'] ?? 'bodyweight')
                          .split(', '),
                      videoUrl: exerciseData['video_url'],
                      imageUrl: exerciseData['image_url'],
                    ),
                    orderIndex: exerciseData['order'] ?? 0,
                    sets: exerciseData['sets'] ?? 3,
                    reps: exerciseData['reps'] ?? 10,
                    duration: exerciseData['duration'],
                    restSeconds: exerciseData['rest_time'] ?? 60,
                  ))
              .toList();

          final workout = Workout(
            id: workoutData['id'],
            userId: workoutData['user_id'] ?? '',
            name: workoutData['name'] ?? 'Тренировка',
            description: workoutData['description'] ?? '',
            difficulty: WorkoutDifficulty.values.firstWhere(
              (e) => e.name == (workoutData['difficulty'] ?? 'beginner'),
              orElse: () => WorkoutDifficulty.beginner,
            ),
            estimatedDurationMinutes: workoutData['estimated_duration'] ?? 30,
            exercises: exercises,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          workouts.add(workout);
        }

        developer.log('💪 ExerciseRepository: Workouts retrieved successfully',
            name: 'ExerciseRepository');
        return workouts;
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        return await _getWorkoutsLocally();
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Get workouts failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  /// Сохранение сессии тренировки
  Future<void> saveWorkoutSession(ActivitySession session) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log(
            '💪 ExerciseRepository: Saving workout session via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        await _supabaseService.saveUserData('workout_sessions', {
          'user_id': user.id,
          'id': session.id,
          'workout_id': session.workoutId,
          'started_at': session.startedAt.toIso8601String(),
          'completed_at': session.completedAt?.toIso8601String(),
          'duration_minutes': session.durationMinutes,
          'calories_burned': session.caloriesBurned,
          'status': session.status,
          'notes': session.notes,
          'created_at': DateTime.now().toIso8601String(),
        });

        developer.log(
            '💪 ExerciseRepository: Workout session saved successfully',
            name: 'ExerciseRepository');
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        await _saveWorkoutSessionLocally(session);
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Save workout session failed: $e',
          name: 'ExerciseRepository');
      rethrow;
    }
  }

  /// Получение истории тренировок
  Future<List<ActivitySession>> getWorkoutHistory() async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log(
            '💪 ExerciseRepository: Getting workout history via Supabase',
            name: 'ExerciseRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('💪 ExerciseRepository: User not authenticated',
              name: 'ExerciseRepository');
          return [];
        }

        final sessionsData = await _supabaseService
            .getUserData('workout_sessions', userId: user.id);

        final sessions = sessionsData
            .map((data) => ActivitySession(
                  id: data['id'],
                  userId: data['user_id'] ?? '',
                  workoutId: data['workout_id'],
                  status: ActivitySessionStatus.values.firstWhere(
                    (e) => e.name == (data['status'] ?? 'completed'),
                    orElse: () => ActivitySessionStatus.completed,
                  ),
                  startedAt: DateTime.parse(data['started_at']),
                  completedAt: data['completed_at'] != null
                      ? DateTime.parse(data['completed_at'])
                      : null,
                  durationMinutes: data['duration_minutes'] ?? 0,
                  caloriesBurned: data['calories_burned'] ?? 0,
                  notes: data['notes'],
                  createdAt:
                      DateTime.parse(data['created_at'] ?? data['started_at']),
                ))
            .toList();

        developer.log(
            '💪 ExerciseRepository: Workout history retrieved successfully',
            name: 'ExerciseRepository');
        return sessions;
      } else {
        developer.log(
            '💪 ExerciseRepository: Supabase not available, using mock',
            name: 'ExerciseRepository');
        return await _getWorkoutHistoryLocally();
      }
    } catch (e) {
      developer.log('💪 ExerciseRepository: Get workout history failed: $e',
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
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock get exercises',
        name: 'ExerciseRepository');
    return [];
  }

  Future<void> _saveWorkoutLocally(Workout workout) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock save workout',
        name: 'ExerciseRepository');
  }

  Future<List<Workout>> _getWorkoutsLocally() async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock get workouts',
        name: 'ExerciseRepository');
    return [];
  }

  Future<void> _saveWorkoutSessionLocally(ActivitySession session) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock save workout session',
        name: 'ExerciseRepository');
  }

  Future<List<ActivitySession>> _getWorkoutHistoryLocally() async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('💪 ExerciseRepository: Mock get workout history',
        name: 'ExerciseRepository');
    return [];
  }
}
