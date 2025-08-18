class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final double? height; // в сантиметрах
  final double? weight; // в килограммах
  final ActivityLevel? activityLevel;
  final String? avatarUrl;
  final List<DietaryPreference> dietaryPreferences;
  final List<String> allergies;
  final List<String> healthConditions;
  final List<String> fitnessGoals;
  final double? targetWeight;
  final int? targetCalories;
  final double? targetProtein;
  final double? targetCarbs;
  final double? targetFat;
  final String? foodRestrictions;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.weight,
    this.activityLevel,
    this.avatarUrl,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.healthConditions = const [],
    this.fitnessGoals = const [],
    this.targetWeight,
    this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFat,
    this.foodRestrictions,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.createdAt,
    this.updatedAt,
  });

  // Вычисляемые свойства
  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) return 'Не указано';
    return '${firstName.isEmpty ? '' : firstName} ${lastName.isEmpty ? '' : lastName}'
        .trim();
  }

  String get initials {
    if (firstName.isEmpty && lastName.isEmpty) return '';
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  double? get bmi {
    if (height == null || weight == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  BMICategory? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;

    if (bmiValue < 18.5) return BMICategory.underweight;
    if (bmiValue < 25) return BMICategory.normal;
    if (bmiValue < 30) return BMICategory.overweight;
    return BMICategory.obese;
  }

  double get profileCompleteness {
    final int totalFields = 12;
    int filledFields = 0;

    if (firstName.isNotEmpty) filledFields++;
    if (lastName.isNotEmpty) filledFields++;
    if (phone?.isNotEmpty == true) filledFields++;
    if (dateOfBirth != null) filledFields++;
    if (gender != null) filledFields++;
    if (height != null) filledFields++;
    if (weight != null) filledFields++;
    if (activityLevel != null) filledFields++;
    if (avatarUrl?.isNotEmpty == true) filledFields++;
    if (dietaryPreferences.isNotEmpty) filledFields++;
    if (allergies.isNotEmpty) filledFields++;
    if (foodRestrictions?.isNotEmpty == true) filledFields++;

    return filledFields / totalFields;
  }

  UserProfile copyWith({
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
    return UserProfile(
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
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phone == phone &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.height == height &&
        other.weight == weight &&
        other.activityLevel == activityLevel &&
        other.avatarUrl == avatarUrl &&
        other.pushNotificationsEnabled == pushNotificationsEnabled &&
        other.emailNotificationsEnabled == emailNotificationsEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      firstName,
      lastName,
      phone,
      dateOfBirth,
      gender,
      height,
      weight,
      activityLevel,
      avatarUrl,
      pushNotificationsEnabled,
      emailNotificationsEnabled,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, fullName: $fullName, bmi: $bmi)';
  }
}

enum Gender {
  male,
  female,
  other,
  notSpecified;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Мужской';
      case Gender.female:
        return 'Женский';
      case Gender.other:
        return 'Другой';
      case Gender.notSpecified:
        return 'Не указан';
    }
  }
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive;

  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Сидячий образ жизни';
      case ActivityLevel.lightlyActive:
        return 'Легкая активность (1-3 раза в неделю)';
      case ActivityLevel.moderatelyActive:
        return 'Умеренная активность (3-5 раз в неделю)';
      case ActivityLevel.veryActive:
        return 'Высокая активность (6-7 раз в неделю)';
      case ActivityLevel.extremelyActive:
        return 'Очень высокая активность';
    }
  }

  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extremelyActive:
        return 1.9;
    }
  }
}

enum DietaryPreference {
  none,
  regular,
  vegetarian,
  vegan,
  keto,
  paleo,
  glutenFree,
  other;

  String get displayName {
    switch (this) {
      case DietaryPreference.none:
        return 'Не выбрано';
      case DietaryPreference.regular:
        return 'Обычное питание';
      case DietaryPreference.vegetarian:
        return 'Вегетарианство';
      case DietaryPreference.vegan:
        return 'Веганство';
      case DietaryPreference.keto:
        return 'Кето-диета';
      case DietaryPreference.paleo:
        return 'Палео-диета';
      case DietaryPreference.glutenFree:
        return 'Безглютеновая диета';
      case DietaryPreference.other:
        return 'Другое';
    }
  }
}

enum BMICategory {
  underweight,
  normal,
  overweight,
  obese;

  String get displayName {
    switch (this) {
      case BMICategory.underweight:
        return 'Недостаточный вес';
      case BMICategory.normal:
        return 'Нормальный вес';
      case BMICategory.overweight:
        return 'Избыточный вес';
      case BMICategory.obese:
        return 'Ожирение';
    }
  }

  String get description {
    switch (this) {
      case BMICategory.underweight:
        return 'ИМТ менее 18.5';
      case BMICategory.normal:
        return 'ИМТ 18.5-24.9';
      case BMICategory.overweight:
        return 'ИМТ 25.0-29.9';
      case BMICategory.obese:
        return 'ИМТ 30 и выше';
    }
  }
}
