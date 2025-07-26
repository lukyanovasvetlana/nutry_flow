import '../../domain/entities/exercise.dart';

class ExerciseModel {
  final String id;
  final String name;
  final String category;
  final String difficulty;
  final int? sets;
  final int? reps;
  final int? restSeconds;
  final String? duration;
  final String iconName;
  final String description;
  final List<String> targetMuscles;
  final List<String> equipment;
  final String? videoUrl;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    this.sets,
    this.reps,
    this.restSeconds,
    this.duration,
    required this.iconName,
    required this.description,
    required this.targetMuscles,
    required this.equipment,
    this.videoUrl,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      difficulty: json['difficulty'],
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['rest_seconds'],
      duration: json['duration'],
      iconName: json['icon_name'],
      description: json['description'],
      targetMuscles: List<String>.from(json['target_muscles'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
      videoUrl: json['video_url'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'difficulty': difficulty,
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
      'duration': duration,
      'icon_name': iconName,
      'description': description,
      'target_muscles': targetMuscles,
      'equipment': equipment,
      'video_url': videoUrl,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Exercise toEntity() {
    return Exercise(
      id: id,
      name: name,
      category: _parseCategory(category),
      difficulty: _parseDifficulty(difficulty),
      sets: sets,
      reps: reps,
      restSeconds: restSeconds,
      duration: duration,
      iconName: iconName,
      description: description,
      targetMuscles: targetMuscles,
      equipment: equipment,
      videoUrl: videoUrl,
      imageUrl: imageUrl,
    );
  }

  static ExerciseModel fromEntity(Exercise exercise) {
    return ExerciseModel(
      id: exercise.id,
      name: exercise.name,
      category: _categoryToString(exercise.category),
      difficulty: _difficultyToString(exercise.difficulty),
      sets: exercise.sets,
      reps: exercise.reps,
      restSeconds: exercise.restSeconds,
      duration: exercise.duration,
      iconName: exercise.iconName,
      description: exercise.description,
      targetMuscles: exercise.targetMuscles,
      equipment: exercise.equipment,
      videoUrl: exercise.videoUrl,
      imageUrl: exercise.imageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static ExerciseCategory _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'legs':
        return ExerciseCategory.legs;
      case 'back':
        return ExerciseCategory.back;
      case 'chest':
        return ExerciseCategory.chest;
      case 'shoulders':
        return ExerciseCategory.shoulders;
      case 'arms':
        return ExerciseCategory.arms;
      case 'core':
        return ExerciseCategory.core;
      case 'cardio':
        return ExerciseCategory.cardio;
      case 'flexibility':
        return ExerciseCategory.flexibility;
      case 'yoga':
        return ExerciseCategory.yoga;
      default:
        return ExerciseCategory.legs;
    }
  }

  static String _categoryToString(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.legs:
        return 'legs';
      case ExerciseCategory.back:
        return 'back';
      case ExerciseCategory.chest:
        return 'chest';
      case ExerciseCategory.shoulders:
        return 'shoulders';
      case ExerciseCategory.arms:
        return 'arms';
      case ExerciseCategory.core:
        return 'core';
      case ExerciseCategory.cardio:
        return 'cardio';
      case ExerciseCategory.flexibility:
        return 'flexibility';
      case ExerciseCategory.yoga:
        return 'yoga';
    }
  }

  static ExerciseDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return ExerciseDifficulty.beginner;
      case 'intermediate':
        return ExerciseDifficulty.intermediate;
      case 'advanced':
        return ExerciseDifficulty.advanced;
      default:
        return ExerciseDifficulty.beginner;
    }
  }

  static String _difficultyToString(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return 'beginner';
      case ExerciseDifficulty.intermediate:
        return 'intermediate';
      case ExerciseDifficulty.advanced:
        return 'advanced';
    }
  }
} 