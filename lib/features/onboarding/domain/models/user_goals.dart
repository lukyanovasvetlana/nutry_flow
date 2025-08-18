class UserGoals {
  final String? mainGoal;
  final int? height;
  final double? targetWeight;
  final int? timeframeMonths;
  final String? dietType;
  final List<String> allergens;
  final List<String> workoutTypes;
  final int workoutFrequency;
  final int workoutDuration;

  const UserGoals({
    this.mainGoal,
    this.height,
    this.targetWeight,
    this.timeframeMonths,
    this.dietType,
    this.allergens = const [],
    this.workoutTypes = const [],
    this.workoutFrequency = 3,
    this.workoutDuration = 45,
  });

  UserGoals copyWith({
    String? mainGoal,
    int? height,
    double? targetWeight,
    int? timeframeMonths,
    String? dietType,
    List<String>? allergens,
    List<String>? workoutTypes,
    int? workoutFrequency,
    int? workoutDuration,
  }) {
    return UserGoals(
      mainGoal: mainGoal ?? this.mainGoal,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      timeframeMonths: timeframeMonths ?? this.timeframeMonths,
      dietType: dietType ?? this.dietType,
      allergens: allergens ?? this.allergens,
      workoutTypes: workoutTypes ?? this.workoutTypes,
      workoutFrequency: workoutFrequency ?? this.workoutFrequency,
      workoutDuration: workoutDuration ?? this.workoutDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainGoal': mainGoal,
      'height': height,
      'targetWeight': targetWeight,
      'timeframeMonths': timeframeMonths,
      'dietType': dietType,
      'allergens': allergens,
      'workoutTypes': workoutTypes,
      'workoutFrequency': workoutFrequency,
      'workoutDuration': workoutDuration,
    };
  }

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    return UserGoals(
      mainGoal: json['mainGoal'] as String?,
      height: json['height'] as int?,
      targetWeight: json['targetWeight'] as double?,
      timeframeMonths: json['timeframeMonths'] as int?,
      dietType: json['dietType'] as String?,
      allergens: List<String>.from(json['allergens'] ?? []),
      workoutTypes: List<String>.from(json['workoutTypes'] ?? []),
      workoutFrequency: json['workoutFrequency'] as int? ?? 3,
      workoutDuration: json['workoutDuration'] as int? ?? 45,
    );
  }

  bool get isValid {
    return mainGoal != null &&
        height != null &&
        height! >= 100 &&
        height! <= 250 &&
        targetWeight != null &&
        targetWeight! >= 30 &&
        targetWeight! <= 300 &&
        timeframeMonths != null &&
        timeframeMonths! >= 1 &&
        timeframeMonths! <= 12;
  }

  String? get validationError {
    if (mainGoal == null) return 'Необходимо выбрать основную цель';
    if (height == null) return 'Необходимо указать рост';
    if (height! < 100 || height! > 250) {
      return 'Рост должен быть от 100 до 250 см';
    }
    if (targetWeight == null) return 'Необходимо указать вес';
    if (targetWeight! < 30 || targetWeight! > 300) {
      return 'Вес должен быть от 30 до 300 кг';
    }
    if (timeframeMonths == null) {
      return 'Необходимо указать период достижения цели';
    }
    if (timeframeMonths! < 1 || timeframeMonths! > 12) {
      return 'Период должен быть от 1 до 12 месяцев';
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserGoals &&
        other.mainGoal == mainGoal &&
        other.height == height &&
        other.targetWeight == targetWeight &&
        other.timeframeMonths == timeframeMonths &&
        other.dietType == dietType &&
        other.allergens.length == allergens.length &&
        other.allergens.every(allergens.contains) &&
        other.workoutTypes.length == workoutTypes.length &&
        other.workoutTypes.every(workoutTypes.contains) &&
        other.workoutFrequency == workoutFrequency &&
        other.workoutDuration == workoutDuration;
  }

  @override
  int get hashCode {
    return Object.hash(
      mainGoal,
      height,
      targetWeight,
      timeframeMonths,
      dietType,
      Object.hashAll(allergens),
      Object.hashAll(workoutTypes),
      workoutFrequency,
      workoutDuration,
    );
  }

  @override
  String toString() {
    return 'UserGoals(mainGoal: $mainGoal, height: $height, targetWeight: $targetWeight, timeframeMonths: $timeframeMonths, dietType: $dietType, allergens: $allergens, workoutTypes: $workoutTypes, workoutFrequency: $workoutFrequency, workoutDuration: $workoutDuration)';
  }
}

class GoalOption {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;

  const GoalOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }

  factory GoalOption.fromJson(Map<String, dynamic> json) {
    return GoalOption(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }
}
