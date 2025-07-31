import 'package:equatable/equatable.dart';

class NutritionTracking extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double caloriesConsumed;
  final double proteinConsumed;
  final double fatConsumed;
  final double carbsConsumed;
  final double fiberConsumed;
  final double sugarConsumed;
  final double sodiumConsumed;
  final double waterConsumed;
  final int mealsCount;
  final String? notes;
  final String mealType; // breakfast, lunch, dinner, snack
  final List<String> foodItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionTracking({
    required this.id,
    required this.userId,
    required this.date,
    required this.caloriesConsumed,
    required this.proteinConsumed,
    required this.fatConsumed,
    required this.carbsConsumed,
    required this.fiberConsumed,
    required this.sugarConsumed,
    required this.sodiumConsumed,
    required this.waterConsumed,
    required this.mealsCount,
    this.notes,
    required this.mealType,
    required this.foodItems,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        caloriesConsumed,
        proteinConsumed,
        fatConsumed,
        carbsConsumed,
        fiberConsumed,
        sugarConsumed,
        sodiumConsumed,
        waterConsumed,
        mealsCount,
        notes,
        mealType,
        foodItems,
        createdAt,
        updatedAt,
      ];

  NutritionTracking copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? caloriesConsumed,
    double? proteinConsumed,
    double? fatConsumed,
    double? carbsConsumed,
    double? fiberConsumed,
    double? sugarConsumed,
    double? sodiumConsumed,
    double? waterConsumed,
    int? mealsCount,
    String? notes,
    String? mealType,
    List<String>? foodItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionTracking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      proteinConsumed: proteinConsumed ?? this.proteinConsumed,
      fatConsumed: fatConsumed ?? this.fatConsumed,
      carbsConsumed: carbsConsumed ?? this.carbsConsumed,
      fiberConsumed: fiberConsumed ?? this.fiberConsumed,
      sugarConsumed: sugarConsumed ?? this.sugarConsumed,
      sodiumConsumed: sodiumConsumed ?? this.sodiumConsumed,
      waterConsumed: waterConsumed ?? this.waterConsumed,
      mealsCount: mealsCount ?? this.mealsCount,
      notes: notes ?? this.notes,
      mealType: mealType ?? this.mealType,
      foodItems: foodItems ?? this.foodItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'calories_consumed': caloriesConsumed,
      'protein_consumed': proteinConsumed,
      'fat_consumed': fatConsumed,
      'carbs_consumed': carbsConsumed,
      'fiber_consumed': fiberConsumed,
      'sugar_consumed': sugarConsumed,
      'sodium_consumed': sodiumConsumed,
      'water_consumed': waterConsumed,
      'meals_count': mealsCount,
      'notes': notes,
      'meal_type': mealType,
      'food_items': foodItems,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NutritionTracking.fromJson(Map<String, dynamic> json) {
    return NutritionTracking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      caloriesConsumed: (json['calories_consumed'] as num).toDouble(),
      proteinConsumed: (json['protein_consumed'] as num).toDouble(),
      fatConsumed: (json['fat_consumed'] as num).toDouble(),
      carbsConsumed: (json['carbs_consumed'] as num).toDouble(),
      fiberConsumed: (json['fiber_consumed'] as num).toDouble(),
      sugarConsumed: (json['sugar_consumed'] as num).toDouble(),
      sodiumConsumed: (json['sodium_consumed'] as num).toDouble(),
      waterConsumed: (json['water_consumed'] as num?)?.toDouble() ?? 0.0,
      mealsCount: json['meals_count'] as int? ?? 0,
      notes: json['notes'] as String?,
      mealType: json['meal_type'] as String,
      foodItems: List<String>.from(json['food_items'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
} 