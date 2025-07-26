/// Entity класс целей пользователя
import 'package:equatable/equatable.dart';

class UserGoals extends Equatable {
  final String id;
  final String userId;
  final List<String> fitnessGoals;
  final List<String> dietaryPreferences;
  final List<String> healthConditions;
  final List<String> workoutTypes;
  final double? targetWeight;
  final int? targetCalories;
  final double? targetProtein;
  final double? targetCarbs;
  final double? targetFat;
  final int? workoutFrequency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserGoals({
    required this.id,
    required this.userId,
    required this.fitnessGoals,
    required this.dietaryPreferences,
    required this.healthConditions,
    required this.workoutTypes,
    this.targetWeight,
    this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFat,
    this.workoutFrequency,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isValid {
    return id.isNotEmpty && 
           userId.isNotEmpty && 
           fitnessGoals.isNotEmpty;
  }

  UserGoals copyWith({
    String? id,
    String? userId,
    List<String>? fitnessGoals,
    List<String>? dietaryPreferences,
    List<String>? healthConditions,
    List<String>? workoutTypes,
    double? targetWeight,
    int? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFat,
    int? workoutFrequency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserGoals(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      healthConditions: healthConditions ?? this.healthConditions,
      workoutTypes: workoutTypes ?? this.workoutTypes,
      targetWeight: targetWeight ?? this.targetWeight,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFat: targetFat ?? this.targetFat,
      workoutFrequency: workoutFrequency ?? this.workoutFrequency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'fitness_goals': fitnessGoals,
      'dietary_preferences': dietaryPreferences,
      'health_conditions': healthConditions,
      'workout_types': workoutTypes,
      'target_weight': targetWeight,
      'target_calories': targetCalories,
      'target_protein': targetProtein,
      'target_carbs': targetCarbs,
      'target_fat': targetFat,
      'workout_frequency': workoutFrequency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserGoals.fromJson(Map<String, dynamic> json) {
    return UserGoals(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fitnessGoals: List<String>.from(json['fitness_goals'] as List),
      dietaryPreferences: List<String>.from(json['dietary_preferences'] as List),
      healthConditions: List<String>.from(json['health_conditions'] as List),
      workoutTypes: List<String>.from(json['workout_types'] ?? []),
      targetWeight: json['target_weight'] as double?,
      targetCalories: json['target_calories'] as int?,
      targetProtein: json['target_protein'] as double?,
      targetCarbs: json['target_carbs'] as double?,
      targetFat: json['target_fat'] as double?,
      workoutFrequency: json['workout_frequency'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    fitnessGoals,
    dietaryPreferences,
    healthConditions,
    workoutTypes,
    targetWeight,
    targetCalories,
    targetProtein,
    targetCarbs,
    targetFat,
    workoutFrequency,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'UserGoals(id: $id, userId: $userId, fitnessGoals: $fitnessGoals, workoutTypes: $workoutTypes, workoutFrequency: $workoutFrequency)';
  }
} 