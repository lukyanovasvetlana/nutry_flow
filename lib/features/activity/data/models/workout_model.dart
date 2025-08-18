import '../../domain/entities/workout.dart';
import '../../domain/entities/exercise.dart';
import 'exercise_model.dart';

class WorkoutExerciseModel {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int orderIndex;
  final int? sets;
  final int? reps;
  final int? restSeconds;
  final String? duration;
  final String? notes;
  final ExerciseModel? exercise;
  final DateTime createdAt;

  WorkoutExerciseModel({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orderIndex,
    this.sets,
    this.reps,
    this.restSeconds,
    this.duration,
    this.notes,
    this.exercise,
    required this.createdAt,
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      id: json['id'],
      workoutId: json['workout_id'],
      exerciseId: json['exercise_id'],
      orderIndex: json['order_index'],
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['rest_seconds'],
      duration: json['duration'],
      notes: json['notes'],
      exercise: json['exercises'] != null
          ? ExerciseModel.fromJson(json['exercises'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'order_index': orderIndex,
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
      'duration': duration,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  WorkoutExercise toEntity() {
    return WorkoutExercise(
      id: id,
      exercise: exercise?.toEntity() ??
          Exercise(
            id: exerciseId,
            name: 'Unknown Exercise',
            category: ExerciseCategory.legs,
            difficulty: ExerciseDifficulty.beginner,
            iconName: 'fitness_center',
            description: '',
            targetMuscles: [],
            equipment: [],
          ),
      orderIndex: orderIndex,
      sets: sets,
      reps: reps,
      restSeconds: restSeconds,
      duration: duration,
      notes: notes,
    );
  }

  static WorkoutExerciseModel fromEntity(WorkoutExercise exercise) {
    return WorkoutExerciseModel(
      id: exercise.id,
      workoutId: '', // Will be set when creating
      exerciseId: exercise.exercise.id,
      orderIndex: exercise.orderIndex,
      sets: exercise.sets,
      reps: exercise.reps,
      restSeconds: exercise.restSeconds,
      duration: exercise.duration,
      notes: exercise.notes,
      exercise: ExerciseModel.fromEntity(exercise.exercise),
      createdAt: DateTime.now(),
    );
  }
}

class WorkoutModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final int? estimatedDurationMinutes;
  final String difficulty;
  final bool isTemplate;
  final List<WorkoutExerciseModel> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.estimatedDurationMinutes,
    required this.difficulty,
    this.isTemplate = false,
    required this.exercises,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      estimatedDurationMinutes: json['estimated_duration_minutes'],
      difficulty: json['difficulty'],
      isTemplate: json['is_template'] ?? false,
      exercises: json['workout_exercises'] != null
          ? (json['workout_exercises'] as List)
              .map((e) => WorkoutExerciseModel.fromJson(e))
              .toList()
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'difficulty': difficulty,
      'is_template': isTemplate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Workout toEntity() {
    return Workout(
      id: id,
      userId: userId,
      name: name,
      description: description,
      estimatedDurationMinutes: estimatedDurationMinutes,
      difficulty: _parseDifficulty(difficulty),
      isTemplate: isTemplate,
      exercises: exercises.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static WorkoutModel fromEntity(Workout workout) {
    return WorkoutModel(
      id: workout.id,
      userId: workout.userId,
      name: workout.name,
      description: workout.description,
      estimatedDurationMinutes: workout.estimatedDurationMinutes,
      difficulty: _difficultyToString(workout.difficulty),
      isTemplate: workout.isTemplate,
      exercises:
          workout.exercises.map(WorkoutExerciseModel.fromEntity).toList(),
      createdAt: workout.createdAt,
      updatedAt: workout.updatedAt,
    );
  }

  static WorkoutDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return WorkoutDifficulty.beginner;
      case 'intermediate':
        return WorkoutDifficulty.intermediate;
      case 'advanced':
        return WorkoutDifficulty.advanced;
      default:
        return WorkoutDifficulty.beginner;
    }
  }

  static String _difficultyToString(WorkoutDifficulty difficulty) {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return 'beginner';
      case WorkoutDifficulty.intermediate:
        return 'intermediate';
      case WorkoutDifficulty.advanced:
        return 'advanced';
    }
  }
}
