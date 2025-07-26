import '../../../menu/domain/entities/recipe.dart';

/// Тип приема пищи
enum MealType {
  breakfast('Завтрак'),
  lunch('Обед'),
  dinner('Ужин'),
  snack('Перекус');

  const MealType(this.displayName);
  final String displayName;
}

/// Модель запланированного приема пищи
class PlannedMeal {
  final String id;
  final String userId;
  final DateTime date;
  final MealType mealType;
  final Recipe? recipe;
  final String? customMealName;
  final String? notes;
  final int? servings;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlannedMeal({
    required this.id,
    required this.userId,
    required this.date,
    required this.mealType,
    this.recipe,
    this.customMealName,
    this.notes,
    this.servings,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  PlannedMeal copyWith({
    DateTime? date,
    MealType? mealType,
    Recipe? recipe,
    String? customMealName,
    String? notes,
    int? servings,
    bool? isCompleted,
  }) {
    return PlannedMeal(
      id: id,
      userId: userId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      recipe: recipe ?? this.recipe,
      customMealName: customMealName ?? this.customMealName,
      notes: notes ?? this.notes,
      servings: servings ?? this.servings,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  factory PlannedMeal.fromJson(Map<String, dynamic> json) {
    return PlannedMeal(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      mealType: MealType.values.firstWhere(
        (type) => type.name == json['meal_type'],
        orElse: () => MealType.breakfast,
      ),
      recipe: json['recipe'] != null ? Recipe.fromJson(json['recipe']) : null,
      customMealName: json['custom_meal_name'] as String?,
      notes: json['notes'] as String?,
      servings: json['servings'] as int?,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'meal_type': mealType.name,
      'recipe': recipe?.toJson(),
      'custom_meal_name': customMealName,
      'notes': notes,
      'servings': servings,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Возвращает название приема пищи
  String get mealName {
    return customMealName ?? recipe?.title ?? mealType.displayName;
  }

  /// Проверяет, запланирован ли прием пищи на сегодня
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Проверяет, является ли прием пищи просроченным
  bool get isPastDue {
    return !isCompleted && date.isBefore(DateTime.now());
  }
}

/// Модель плана питания на неделю
class MealPlan {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final List<PlannedMeal> meals;
  final String? name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealPlan({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.meals,
    this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  MealPlan copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<PlannedMeal>? meals,
    String? name,
    String? description,
  }) {
    return MealPlan(
      id: id,
      userId: userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      meals: meals ?? this.meals,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      meals: (json['meals'] as List? ?? [])
          .map((meal) => PlannedMeal.fromJson(meal))
          .toList(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'meals': meals.map((meal) => meal.toJson()).toList(),
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Получает приемы пищи для конкретной даты
  List<PlannedMeal> getMealsForDate(DateTime date) {
    return meals.where((meal) =>
      meal.date.year == date.year &&
      meal.date.month == date.month &&
      meal.date.day == date.day
    ).toList();
  }

  /// Получает приемы пищи по типу
  List<PlannedMeal> getMealsByType(MealType type) {
    return meals.where((meal) => meal.mealType == type).toList();
  }

  /// Возвращает процент выполнения плана
  double get completionPercentage {
    if (meals.isEmpty) return 0.0;
    final completedMeals = meals.where((meal) => meal.isCompleted).length;
    return completedMeals / meals.length;
  }

  /// Проверяет, является ли план активным
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
} 