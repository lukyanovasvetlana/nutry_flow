import 'package:equatable/equatable.dart';
import 'exercise.dart';

enum WorkoutDifficulty {
  beginner,
  intermediate,
  advanced,
}

class WorkoutExercise extends Equatable {
  final String id;
  final Exercise exercise;
  final int orderIndex;
  final int? sets;
  final int? reps;
  final int? restSeconds;
  final String? duration;
  final String? notes;

  const WorkoutExercise({
    required this.id,
    required this.exercise,
    required this.orderIndex,
    this.sets,
    this.reps,
    this.restSeconds,
    this.duration,
    this.notes,
  });

  WorkoutExercise copyWith({
    String? id,
    Exercise? exercise,
    int? orderIndex,
    int? sets,
    int? reps,
    int? restSeconds,
    String? duration,
    String? notes,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      orderIndex: orderIndex ?? this.orderIndex,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        exercise,
        orderIndex,
        sets,
        reps,
        restSeconds,
        duration,
        notes,
      ];
}

class Workout extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final int? estimatedDurationMinutes;
  final WorkoutDifficulty difficulty;
  final bool isTemplate;
  final List<WorkoutExercise> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Workout({
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

  int get totalExercises => exercises.length;

  int get totalEstimatedDuration {
    if (estimatedDurationMinutes != null) return estimatedDurationMinutes!;
    
    int total = 0;
    for (final exercise in exercises) {
      if (exercise.duration != null) {
        // Parse duration like "30 мин" to minutes
        final durationStr = exercise.duration!;
        if (durationStr.contains('мин')) {
          final minutes = int.tryParse(durationStr.replaceAll(' мин', ''));
          if (minutes != null) total += minutes;
        }
      } else if (exercise.sets != null && exercise.reps != null) {
        // Estimate time for strength exercises
        total += (exercise.sets! * 2); // 2 minutes per set
      }
    }
    return total;
  }

  Workout copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? estimatedDurationMinutes,
    WorkoutDifficulty? difficulty,
    bool? isTemplate,
    List<WorkoutExercise>? exercises,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      difficulty: difficulty ?? this.difficulty,
      isTemplate: isTemplate ?? this.isTemplate,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        estimatedDurationMinutes,
        difficulty,
        isTemplate,
        exercises,
        createdAt,
        updatedAt,
      ];
} 