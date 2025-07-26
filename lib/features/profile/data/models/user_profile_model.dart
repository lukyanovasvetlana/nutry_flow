import '../../domain/entities/user_profile.dart';

/// Data model for UserProfile with JSON serialization
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.phone,
    super.dateOfBirth,
    super.gender,
    super.height,
    super.weight,
    super.activityLevel,
    super.avatarUrl,
    super.dietaryPreferences = const [],
    super.allergies = const [],
    super.healthConditions = const [],
    super.fitnessGoals = const [],
    super.targetWeight,
    super.targetCalories,
    super.targetProtein,
    super.targetCarbs,
    super.targetFat,
    super.foodRestrictions,
    super.pushNotificationsEnabled = true,
    super.emailNotificationsEnabled = true,
    super.createdAt,
    super.updatedAt,
  });

  /// Create UserProfileModel from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      dateOfBirth: json['date_of_birth'] != null 
        ? DateTime.parse(json['date_of_birth'] as String)
        : null,
      gender: json['gender'] != null 
        ? Gender.values.firstWhere((g) => g.name == json['gender'])
        : null,
      height: json['height'] as double?,
      weight: json['weight'] as double?,
      activityLevel: json['activity_level'] != null
        ? ActivityLevel.values.firstWhere((a) => a.name == json['activity_level'])
        : null,
      avatarUrl: json['avatar_url'] as String?,
      dietaryPreferences: json['dietary_preferences'] != null
        ? (json['dietary_preferences'] as List<dynamic>)
            .map((e) => DietaryPreference.values.firstWhere((d) => d.name == e))
            .toList()
        : const [],
      allergies: json['allergies'] != null
        ? List<String>.from(json['allergies'] as List)
        : const [],
      healthConditions: json['health_conditions'] != null
        ? List<String>.from(json['health_conditions'] as List)
        : const [],
      fitnessGoals: json['fitness_goals'] != null
        ? List<String>.from(json['fitness_goals'] as List)
        : const [],
      targetWeight: json['target_weight'] as double?,
      targetCalories: json['target_calories'] as int?,
      targetProtein: json['target_protein'] as double?,
      targetCarbs: json['target_carbs'] as double?,
      targetFat: json['target_fat'] as double?,
      foodRestrictions: json['food_restrictions'] as String?,
      pushNotificationsEnabled: json['push_notifications_enabled'] as bool? ?? true,
      emailNotificationsEnabled: json['email_notifications_enabled'] as bool? ?? true,
      createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
      updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : null,
    );
  }

  /// Convert UserProfileModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender?.name,
      'height': height,
      'weight': weight,
      'activity_level': activityLevel?.name,
      'avatar_url': avatarUrl,
      'dietary_preferences': dietaryPreferences.map((e) => e.name).toList(),
      'allergies': allergies,
      'health_conditions': healthConditions,
      'fitness_goals': fitnessGoals,
      'target_weight': targetWeight,
      'target_calories': targetCalories,
      'target_protein': targetProtein,
      'target_carbs': targetCarbs,
      'target_fat': targetFat,
      'food_restrictions': foodRestrictions,
      'push_notifications_enabled': pushNotificationsEnabled,
      'email_notifications_enabled': emailNotificationsEnabled,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create UserProfileModel from UserProfile entity
  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      phone: profile.phone,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      height: profile.height,
      weight: profile.weight,
      activityLevel: profile.activityLevel,
      avatarUrl: profile.avatarUrl,
      dietaryPreferences: profile.dietaryPreferences,
      allergies: profile.allergies,
      healthConditions: profile.healthConditions,
      fitnessGoals: profile.fitnessGoals,
      targetWeight: profile.targetWeight,
      targetCalories: profile.targetCalories,
      targetProtein: profile.targetProtein,
      targetCarbs: profile.targetCarbs,
      targetFat: profile.targetFat,
      foodRestrictions: profile.foodRestrictions,
      pushNotificationsEnabled: profile.pushNotificationsEnabled,
      emailNotificationsEnabled: profile.emailNotificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  /// Create a copy with updated fields
  @override
  UserProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    Gender? gender,
    double? height,
    double? weight,
    ActivityLevel? activityLevel,
    String? avatarUrl,
    List<DietaryPreference>? dietaryPreferences,
    List<String>? allergies,
    List<String>? healthConditions,
    List<String>? fitnessGoals,
    double? targetWeight,
    int? targetCalories,
    double? targetProtein,
    double? targetCarbs,
    double? targetFat,
    String? foodRestrictions,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergies: allergies ?? this.allergies,
      healthConditions: healthConditions ?? this.healthConditions,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      targetWeight: targetWeight ?? this.targetWeight,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFat: targetFat ?? this.targetFat,
      foodRestrictions: foodRestrictions ?? this.foodRestrictions,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfileModel(id: $id, fullName: $fullName, email: $email, '
           'completeness: ${profileCompleteness.toStringAsFixed(1)}%)';
  }
} 