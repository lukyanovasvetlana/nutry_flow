class Exercise {
  final String id;
  final String name;
  final String category;
  final String difficulty;
  final int sets;
  final int reps;
  final int restSeconds;
  final String? duration; // For cardio exercises
  final String iconName;
  final String description;
  final List<String> targetMuscles;
  final List<String> equipment;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.duration,
    required this.iconName,
    required this.description,
    required this.targetMuscles,
    required this.equipment,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      difficulty: json['difficulty'],
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['restSeconds'],
      duration: json['duration'],
      iconName: json['iconName'],
      description: json['description'],
      targetMuscles: List<String>.from(json['targetMuscles']),
      equipment: List<String>.from(json['equipment']),
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
      'restSeconds': restSeconds,
      'duration': duration,
      'iconName': iconName,
      'description': description,
      'targetMuscles': targetMuscles,
      'equipment': equipment,
    };
  }
}
