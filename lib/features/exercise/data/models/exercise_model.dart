import '../../domain/entities/exercise.dart';

/// Модель данных для упражнения (DTO)
class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.category,
    required super.difficulty,
    super.sets,
    super.reps,
    super.restSeconds,
    super.duration,
    required super.iconName,
    required super.description,
    required super.targetMuscles,
    required super.equipment,
    super.videoUrl,
    super.imageUrl,
    super.isFavorite,
  });

  /// Создание модели из JSON
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Упражнение',
      category: ExerciseCategory.values.firstWhere(
        (e) => e.name == (json['category'] as String? ?? 'legs'),
        orElse: () => ExerciseCategory.legs,
      ),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (e) => e.name == (json['difficulty'] as String? ?? 'beginner'),
        orElse: () => ExerciseDifficulty.beginner,
      ),
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      restSeconds: json['restSeconds'] as int? ?? json['rest_time'] as int?,
      duration: json['duration'] as String?,
      iconName: json['iconName'] as String? ?? 'exercise_icon',
      description: json['description'] as String? ?? '',
      targetMuscles: (json['targetMuscles'] as List<dynamic>? ??
                  json['muscle_groups'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      equipment: (json['equipment'] as String? ?? 'bodyweight')
          .split(', ')
          .where((e) => e.isNotEmpty)
          .toList(),
      videoUrl: json['video_url'] as String? ?? json['videoUrl'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      isFavorite:
          json['isFavorite'] as bool? ?? json['is_favorite'] as bool? ?? false,
    );
  }

  /// Преобразование модели в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'difficulty': difficulty.name,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
      'rest_time': restSeconds,
      'duration': duration,
      'iconName': iconName,
      'description': description,
      'targetMuscles': targetMuscles,
      'muscle_groups': targetMuscles,
      'equipment': equipment.join(', '),
      'video_url': videoUrl,
      'videoUrl': videoUrl,
      'image_url': imageUrl,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'is_favorite': isFavorite,
    };
  }

  /// Преобразование entity в модель
  factory ExerciseModel.fromEntity(Exercise exercise) {
    return ExerciseModel(
      id: exercise.id,
      name: exercise.name,
      category: exercise.category,
      difficulty: exercise.difficulty,
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
      isFavorite: exercise.isFavorite,
    );
  }
}
