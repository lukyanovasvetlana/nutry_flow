import 'package:equatable/equatable.dart';

enum ExerciseCategory {
  legs,
  back,
  chest,
  shoulders,
  arms,
  core,
  cardio,
  flexibility,
  yoga,
}

enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced,
}

class Exercise extends Equatable {
  final String id;
  final String name;
  final ExerciseCategory category;
  final ExerciseDifficulty difficulty;
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
  final bool isFavorite;

  const Exercise({
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
    this.isFavorite = false,
  });

  Exercise copyWith({
    String? id,
    String? name,
    ExerciseCategory? category,
    ExerciseDifficulty? difficulty,
    int? sets,
    int? reps,
    int? restSeconds,
    String? duration,
    String? iconName,
    String? description,
    List<String>? targetMuscles,
    List<String>? equipment,
    String? videoUrl,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      duration: duration ?? this.duration,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      equipment: equipment ?? this.equipment,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        difficulty,
        sets,
        reps,
        restSeconds,
        duration,
        iconName,
        description,
        targetMuscles,
        equipment,
        videoUrl,
        imageUrl,
        isFavorite,
      ];
}
