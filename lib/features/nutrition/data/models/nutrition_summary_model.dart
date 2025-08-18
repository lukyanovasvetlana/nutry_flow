import '../../domain/entities/nutrition_summary.dart';
import '../../domain/entities/food_entry.dart';

class NutritionSummaryModel extends NutritionSummary {
  const NutritionSummaryModel({
    required super.date,
    required super.totalCalories,
    required super.totalProtein,
    required super.totalFats,
    required super.totalCarbs,
    required super.totalFiber,
    required super.totalSugar,
    required super.totalSodium,
    required super.totalEntries,
    required super.caloriesByMeal,
    required super.entriesByMeal,
  });

  factory NutritionSummaryModel.fromJson(Map<String, dynamic> json) {
    final caloriesByMeal = <MealType, double>{};
    final entriesByMeal = <MealType, int>{};

    // Parse meal-specific data
    if (json['breakfast_calories'] != null) {
      caloriesByMeal[MealType.breakfast] =
          (json['breakfast_calories'] as num).toDouble();
      entriesByMeal[MealType.breakfast] =
          json['breakfast_entries'] as int? ?? 0;
    }
    if (json['lunch_calories'] != null) {
      caloriesByMeal[MealType.lunch] =
          (json['lunch_calories'] as num).toDouble();
      entriesByMeal[MealType.lunch] = json['lunch_entries'] as int? ?? 0;
    }
    if (json['dinner_calories'] != null) {
      caloriesByMeal[MealType.dinner] =
          (json['dinner_calories'] as num).toDouble();
      entriesByMeal[MealType.dinner] = json['dinner_entries'] as int? ?? 0;
    }
    if (json['snack_calories'] != null) {
      caloriesByMeal[MealType.snack] =
          (json['snack_calories'] as num).toDouble();
      entriesByMeal[MealType.snack] = json['snack_entries'] as int? ?? 0;
    }

    return NutritionSummaryModel(
      date: DateTime.parse(json['date'] as String),
      totalCalories: (json['total_calories'] as num).toDouble(),
      totalProtein: (json['total_protein'] as num).toDouble(),
      totalFats: (json['total_fats'] as num).toDouble(),
      totalCarbs: (json['total_carbs'] as num).toDouble(),
      totalFiber: (json['total_fiber'] as num?)?.toDouble() ?? 0.0,
      totalSugar: (json['total_sugar'] as num?)?.toDouble() ?? 0.0,
      totalSodium: (json['total_sodium'] as num?)?.toDouble() ?? 0.0,
      totalEntries: json['total_entries'] as int? ?? 0,
      caloriesByMeal: caloriesByMeal,
      entriesByMeal: entriesByMeal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0], // Only date part
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_fats': totalFats,
      'total_carbs': totalCarbs,
      'total_fiber': totalFiber,
      'total_sugar': totalSugar,
      'total_sodium': totalSodium,
      'total_entries': totalEntries,
      'breakfast_calories': caloriesByMeal[MealType.breakfast],
      'lunch_calories': caloriesByMeal[MealType.lunch],
      'dinner_calories': caloriesByMeal[MealType.dinner],
      'snack_calories': caloriesByMeal[MealType.snack],
      'breakfast_entries': entriesByMeal[MealType.breakfast],
      'lunch_entries': entriesByMeal[MealType.lunch],
      'dinner_entries': entriesByMeal[MealType.dinner],
      'snack_entries': entriesByMeal[MealType.snack],
    };
  }

  factory NutritionSummaryModel.fromEntity(NutritionSummary entity) {
    return NutritionSummaryModel(
      date: entity.date,
      totalCalories: entity.totalCalories,
      totalProtein: entity.totalProtein,
      totalFats: entity.totalFats,
      totalCarbs: entity.totalCarbs,
      totalFiber: entity.totalFiber,
      totalSugar: entity.totalSugar,
      totalSodium: entity.totalSodium,
      totalEntries: entity.totalEntries,
      caloriesByMeal: entity.caloriesByMeal,
      entriesByMeal: entity.entriesByMeal,
    );
  }

  NutritionSummary toEntity() {
    return NutritionSummary(
      date: date,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalFats: totalFats,
      totalCarbs: totalCarbs,
      totalFiber: totalFiber,
      totalSugar: totalSugar,
      totalSodium: totalSodium,
      totalEntries: totalEntries,
      caloriesByMeal: caloriesByMeal,
      entriesByMeal: entriesByMeal,
    );
  }

  factory NutritionSummaryModel.fromEntries(
      DateTime date, List<FoodEntry> entries) {
    final summary = NutritionSummary.fromEntries(date, entries);
    return NutritionSummaryModel.fromEntity(summary);
  }
}
