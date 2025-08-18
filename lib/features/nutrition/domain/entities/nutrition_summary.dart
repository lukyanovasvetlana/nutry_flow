import 'package:equatable/equatable.dart';
import 'food_entry.dart';

/// Сущность суммарной информации о питании за день
class NutritionSummary extends Equatable {
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalFats;
  final double totalCarbs;
  final double totalFiber;
  final double totalSugar;
  final double totalSodium;
  final int totalEntries;
  final Map<MealType, double> caloriesByMeal;
  final Map<MealType, int> entriesByMeal;

  const NutritionSummary({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFats,
    required this.totalCarbs,
    required this.totalFiber,
    required this.totalSugar,
    required this.totalSodium,
    required this.totalEntries,
    required this.caloriesByMeal,
    required this.entriesByMeal,
  });

  /// Создает суммарную информацию из списка записей о приеме пищи
  factory NutritionSummary.fromEntries(DateTime date, List<FoodEntry> entries) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalFats = 0;
    double totalCarbs = 0;
    double totalFiber = 0;
    double totalSugar = 0;
    double totalSodium = 0;

    final Map<MealType, double> caloriesByMeal = {};
    final Map<MealType, int> entriesByMeal = {};

    // Инициализируем карты для всех типов приемов пищи
    for (final mealType in MealType.values) {
      caloriesByMeal[mealType] = 0;
      entriesByMeal[mealType] = 0;
    }

    for (final entry in entries) {
      // Суммируем общие показатели
      totalCalories += entry.totalCalories;
      totalProtein += entry.totalProtein;
      totalFats += entry.totalFats;
      totalCarbs += entry.totalCarbs;
      totalFiber += entry.totalFiber;
      totalSugar += entry.totalSugar;
      totalSodium += entry.totalSodium;

      // Группируем по типам приемов пищи
      caloriesByMeal[entry.mealType] =
          (caloriesByMeal[entry.mealType] ?? 0) + entry.totalCalories;
      entriesByMeal[entry.mealType] = (entriesByMeal[entry.mealType] ?? 0) + 1;
    }

    return NutritionSummary(
      date: date,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalFats: totalFats,
      totalCarbs: totalCarbs,
      totalFiber: totalFiber,
      totalSugar: totalSugar,
      totalSodium: totalSodium,
      totalEntries: entries.length,
      caloriesByMeal: caloriesByMeal,
      entriesByMeal: entriesByMeal,
    );
  }

  /// Возвращает процент калорий от заданной цели
  double getCaloriesPercentage(double goalCalories) {
    if (goalCalories <= 0) return 0;
    return (totalCalories / goalCalories) * 100;
  }

  /// Возвращает процент белков от заданной цели
  double getProteinPercentage(double goalProtein) {
    if (goalProtein <= 0) return 0;
    return (totalProtein / goalProtein) * 100;
  }

  /// Возвращает процент жиров от заданной цели
  double getFatsPercentage(double goalFats) {
    if (goalFats <= 0) return 0;
    return (totalFats / goalFats) * 100;
  }

  /// Возвращает процент углеводов от заданной цели
  double getCarbsPercentage(double goalCarbs) {
    if (goalCarbs <= 0) return 0;
    return (totalCarbs / goalCarbs) * 100;
  }

  /// Проверяет, превышены ли дневные цели по калориям
  bool isCaloriesExceeded(double goalCalories) {
    return totalCalories > goalCalories;
  }

  /// Возвращает оставшиеся калории до цели
  double getRemainingCalories(double goalCalories) {
    return goalCalories - totalCalories;
  }

  /// Геттеры для калорий по приемам пищи
  double get breakfastCalories => caloriesByMeal[MealType.breakfast] ?? 0;
  double get lunchCalories => caloriesByMeal[MealType.lunch] ?? 0;
  double get dinnerCalories => caloriesByMeal[MealType.dinner] ?? 0;
  double get snackCalories => caloriesByMeal[MealType.snack] ?? 0;

  @override
  List<Object?> get props => [
        date,
        totalCalories,
        totalProtein,
        totalFats,
        totalCarbs,
        totalFiber,
        totalSugar,
        totalSodium,
        totalEntries,
        caloriesByMeal,
        entriesByMeal,
      ];

  @override
  String toString() {
    return 'NutritionSummary(date: $date, calories: $totalCalories, entries: $totalEntries)';
  }
}
