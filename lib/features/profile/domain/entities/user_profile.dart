/// Сущность профиля пользователя
/// 
/// Содержит всю информацию о пользователе, включая персональные данные,
/// физические параметры, цели, предпочтения и настройки уведомлений.
/// 
/// Пример использования:
/// ```dart
/// final profile = UserProfile(
///   id: 'user123',
///   firstName: 'Иван',
///   lastName: 'Петров',
///   email: 'ivan.petrov@example.com',
///   height: 180.0,
///   weight: 75.0,
///   fitnessGoals: ['Похудение', 'Набор мышечной массы'],
/// );
/// 
/// // Получение вычисляемых свойств
/// print(profile.fullName); // "Иван Петров"
/// print(profile.bmi); // 23.15
/// print(profile.bmiCategory); // BMICategory.normal
/// print(profile.profileCompleteness); // 0.75
/// ```
class UserProfile {
  /// Уникальный идентификатор пользователя
  final String id;
  
  /// Имя пользователя
  final String firstName;
  
  /// Фамилия пользователя
  final String lastName;
  
  /// Email адрес пользователя
  final String email;
  
  /// Номер телефона (опционально)
  final String? phone;
  
  /// Дата рождения (опционально)
  final DateTime? dateOfBirth;
  
  /// Пол пользователя (опционально)
  final Gender? gender;
  
  /// Рост в сантиметрах (опционально)
  final double? height;
  
  /// Вес в килограммах (опционально)
  final double? weight;
  
  /// Уровень физической активности (опционально)
  final ActivityLevel? activityLevel;
  
  /// URL аватара пользователя (опционально)
  final String? avatarUrl;
  
  /// Диетические предпочтения
  final List<DietaryPreference> dietaryPreferences;
  
  /// Аллергии и непереносимости
  final List<String> allergies;
  
  /// Состояния здоровья
  final List<String> healthConditions;
  
  /// Фитнес цели
  final List<String> fitnessGoals;
  
  /// Целевой вес в килограммах (опционально)
  final double? targetWeight;
  
  /// Целевые калории в день (опционально)
  final int? targetCalories;
  
  /// Целевой белок в граммах (опционально)
  final double? targetProtein;
  
  /// Целевые углеводы в граммах (опционально)
  final double? targetCarbs;
  
  /// Целевые жиры в граммах (опционально)
  final double? targetFat;
  
  /// Ограничения в питании (опционально)
  final String? foodRestrictions;
  
  /// Включены ли push-уведомления
  final bool pushNotificationsEnabled;
  
  /// Включены ли email-уведомления
  final bool emailNotificationsEnabled;
  
  /// Дата создания профиля
  final DateTime? createdAt;
  
  /// Дата последнего обновления профиля
  final DateTime? updatedAt;

  /// Создает экземпляр профиля пользователя
  /// 
  /// [id] - уникальный идентификатор (обязательный)
  /// [firstName] - имя (обязательное)
  /// [lastName] - фамилия (обязательная)
  /// [email] - email адрес (обязательный)
  /// [phone] - номер телефона (опционально)
  /// [dateOfBirth] - дата рождения (опционально)
  /// [gender] - пол (опционально)
  /// [height] - рост в см (опционально)
  /// [weight] - вес в кг (опционально)
  /// [activityLevel] - уровень активности (опционально)
  /// [avatarUrl] - URL аватара (опционально)
  /// [dietaryPreferences] - диетические предпочтения
  /// [allergies] - аллергии
  /// [healthConditions] - состояния здоровья
  /// [fitnessGoals] - фитнес цели
  /// [targetWeight] - целевой вес (опционально)
  /// [targetCalories] - целевые калории (опционально)
  /// [targetProtein] - целевой белок (опционально)
  /// [targetCarbs] - целевые углеводы (опционально)
  /// [targetFat] - целевые жиры (опционально)
  /// [foodRestrictions] - ограничения в питании (опционально)
  /// [pushNotificationsEnabled] - включены ли push-уведомления
  /// [emailNotificationsEnabled] - включены ли email-уведомления
  /// [createdAt] - дата создания (опционально)
  /// [updatedAt] - дата обновления (опционально)
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
  
  /// Полное имя пользователя
  /// 
  /// Возвращает полное имя в формате "Имя Фамилия".
  /// Если имя и фамилия не указаны, возвращает "Не указано".
  /// 
  /// Example:
  /// ```dart
  /// final profile = UserProfile(firstName: 'Иван', lastName: 'Петров');
  /// print(profile.fullName); // "Иван Петров"
  /// ```
  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) return 'Не указано';
    return '${firstName.isEmpty ? '' : firstName} ${lastName.isEmpty ? '' : lastName}'
        .trim();
  }

  /// Инициалы пользователя
  /// 
  /// Возвращает инициалы в верхнем регистре.
  /// Если имя или фамилия не указаны, возвращает пустую строку.
  /// 
  /// Example:
  /// ```dart
  /// final profile = UserProfile(firstName: 'Иван', lastName: 'Петров');
  /// print(profile.initials); // "ИП"
  /// ```
  String get initials {
    if (firstName.isEmpty && lastName.isEmpty) return '';
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  /// Возраст пользователя
  /// 
  /// Вычисляет возраст на основе даты рождения.
  /// Учитывает месяц и день для точного расчета.
  /// 
  /// Returns возраст в годах или null если дата рождения не указана
  /// 
  /// Example:
  /// ```dart
  /// final profile = UserProfile(dateOfBirth: DateTime(1990, 5, 15));
  /// print(profile.age); // 33 (в 2023 году)
  /// ```
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

  /// Индекс массы тела (BMI)
  /// 
  /// Вычисляет BMI по формуле: вес (кг) / рост (м)²
  /// 
  /// Returns значение BMI или null если рост или вес не указаны
  /// 
  /// Example:
  /// ```dart
  /// final profile = UserProfile(height: 180.0, weight: 75.0);
  /// print(profile.bmi); // 23.15
  /// ```
  double? get bmi {
    if (height == null || weight == null) return null;
    if (height! <= 0 || weight! <= 0) return null; // Проверяем на нулевые и отрицательные значения
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Категория BMI
  /// 
  /// Определяет категорию BMI на основе вычисленного значения:
  /// - underweight: < 18.5
  /// - normal: 18.5 - 24.9
  /// - overweight: 25.0 - 29.9
  /// - obese: ≥ 30.0
  /// 
  /// Returns категорию BMI или null если BMI не может быть вычислен
  /// 
  /// Example:
  /// ```dart
  /// final profile = UserProfile(height: 180.0, weight: 75.0);
  /// print(profile.bmiCategory); // BMICategory.normal
  /// ```
  BMICategory? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;

    if (bmiValue < 18.5) return BMICategory.underweight;
    if (bmiValue < 25) return BMICategory.normal;
    if (bmiValue < 30) return BMICategory.overweight;
    return BMICategory.obese;
  }

  /// Полнота профиля
  /// 
  /// Вычисляет процент заполненности профиля на основе 12 ключевых полей.
  /// Возвращает значение от 0.0 до 1.0, где 1.0 = 100% заполненности.
  /// 
  /// Учитываемые поля:
  /// - firstName, lastName, phone, dateOfBirth, gender
  /// - height, weight, activityLevel, avatarUrl
  /// - dietaryPreferences, allergies, foodRestrictions
  /// 
  /// Returns значение от 0.0 до 1.0
  /// 
  /// Example:
  /// ```dart
  /// final profile = UserProfile(firstName: 'Иван', lastName: 'Петров');
  /// print(profile.profileCompleteness); // 0.17 (2 из 12 полей)
  /// ```
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
