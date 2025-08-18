import '../entities/food_entry.dart';
import '../entities/food_item.dart';
import '../repositories/nutrition_repository.dart';

/// Результат валидации добавления записи о приеме пищи
class AddFoodEntryValidationResult {
  final bool isValid;
  final String? errorMessage;

  const AddFoodEntryValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  factory AddFoodEntryValidationResult.valid() {
    return const AddFoodEntryValidationResult(isValid: true);
  }

  factory AddFoodEntryValidationResult.invalid(String message) {
    return AddFoodEntryValidationResult(isValid: false, errorMessage: message);
  }
}

/// Use Case для добавления записи о приеме пищи
class AddFoodEntryUseCase {
  final NutritionRepository _repository;

  const AddFoodEntryUseCase(this._repository);

  /// Добавляет запись о приеме пищи с валидацией
  Future<FoodEntry> execute({
    required String userId,
    required FoodItem foodItem,
    required double grams,
    required MealType mealType,
    required DateTime consumedAt,
    String? notes,
  }) async {
    // Валидация входных данных
    final validationResult = _validateInput(
      userId: userId,
      foodItem: foodItem,
      grams: grams,
      consumedAt: consumedAt,
    );

    if (!validationResult.isValid) {
      throw ArgumentError(validationResult.errorMessage);
    }

    // Создание записи о приеме пищи
    final entry = FoodEntry(
      id: _generateEntryId(),
      userId: userId,
      foodItemId: foodItem.id,
      foodName: foodItem.name,
      quantity:
          grams / 100.0, // Convert grams to standard quantity (100g = 1.0)
      unit: 'g',
      mealType: mealType,
      date: consumedAt,
      calories: foodItem.caloriesPer100g,
      protein: foodItem.proteinPer100g,
      carbs: foodItem.carbsPer100g,
      fat: foodItem.fatsPer100g,
      fiber: foodItem.fiberPer100g,
      sugar: foodItem.sugarPer100g,
      sodium: foodItem.sodiumPer100g,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      consumedAt: consumedAt,
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
      grams: grams,
    );

    // Сохранение в репозитории
    return _repository.addFoodEntry(entry);
  }

  /// Валидирует входные данные для добавления записи
  AddFoodEntryValidationResult _validateInput({
    required String userId,
    required FoodItem foodItem,
    required double grams,
    required DateTime consumedAt,
  }) {
    // Проверка ID пользователя
    if (userId.trim().isEmpty) {
      return AddFoodEntryValidationResult.invalid(
          'ID пользователя не может быть пустым');
    }

    // Проверка продукта питания
    if (foodItem.name.trim().isEmpty) {
      return AddFoodEntryValidationResult.invalid(
          'Название продукта не может быть пустым');
    }

    // Проверка количества в граммах
    if (grams <= 0) {
      return AddFoodEntryValidationResult.invalid(
          'Количество должно быть больше 0');
    }

    if (grams > 10000) {
      // Максимум 10 кг за один прием
      return AddFoodEntryValidationResult.invalid(
          'Количество не может превышать 10000 грамм');
    }

    // Проверка даты потребления
    final now = DateTime.now();
    final maxPastDate =
        now.subtract(const Duration(days: 365)); // Максимум год назад
    final maxFutureDate = now.add(const Duration(days: 1)); // Максимум завтра

    if (consumedAt.isBefore(maxPastDate)) {
      return AddFoodEntryValidationResult.invalid(
          'Дата потребления не может быть более года назад');
    }

    if (consumedAt.isAfter(maxFutureDate)) {
      return AddFoodEntryValidationResult.invalid(
          'Дата потребления не может быть в будущем');
    }

    return AddFoodEntryValidationResult.valid();
  }

  /// Генерирует уникальный ID для записи
  String _generateEntryId() {
    return 'entry_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  /// Проверяет, не превышает ли добавление записи дневные лимиты калорий
  Future<bool> wouldExceedDailyCalories({
    required String userId,
    required FoodItem foodItem,
    required double grams,
    required DateTime date,
    required double dailyCalorieGoal,
  }) async {
    try {
      // Получаем текущую суммарную информацию за день
      final currentSummary =
          await _repository.getNutritionSummaryByDate(userId, date);

      // Рассчитываем калории для добавляемой записи
      final additionalCalories = foodItem.calculateCalories(grams);

      // Проверяем, превысит ли общее количество калорий дневную цель
      final totalCalories = currentSummary.totalCalories + additionalCalories;

      return totalCalories > dailyCalorieGoal;
    } catch (e) {
      // Если не удалось получить данные, предполагаем, что лимит не будет превышен
      return false;
    }
  }

  /// Получает рекомендуемый размер порции для продукта
  double getRecommendedPortionSize(FoodItem foodItem, MealType mealType) {
    // Базовые рекомендации по размеру порции в граммах
    switch (mealType) {
      case MealType.breakfast:
        return _getBreakfastPortionSize(foodItem);
      case MealType.lunch:
        return _getLunchPortionSize(foodItem);
      case MealType.dinner:
        return _getDinnerPortionSize(foodItem);
      case MealType.snack:
        return _getSnackPortionSize(foodItem);
    }
  }

  double _getBreakfastPortionSize(FoodItem foodItem) {
    // Примерные размеры порций для завтрака
    final category = foodItem.category?.toLowerCase() ?? '';

    if (category.contains('крупа') || category.contains('каша')) {
      return 50.0; // Сухая крупа
    }
    if (category.contains('хлеб')) return 30.0;
    if (category.contains('молоко') || category.contains('йогурт')) {
      return 200.0;
    }
    if (category.contains('фрукт')) return 150.0;
    if (category.contains('яйцо')) return 60.0;

    return 100.0; // Стандартная порция
  }

  double _getLunchPortionSize(FoodItem foodItem) {
    // Примерные размеры порций для обеда
    final category = foodItem.category?.toLowerCase() ?? '';

    if (category.contains('мясо') || category.contains('рыба')) return 120.0;
    if (category.contains('гарнир') || category.contains('крупа')) return 150.0;
    if (category.contains('овощи')) return 200.0;
    if (category.contains('суп')) return 300.0;

    return 120.0; // Стандартная порция
  }

  double _getDinnerPortionSize(FoodItem foodItem) {
    // Примерные размеры порций для ужина (меньше, чем на обед)
    final category = foodItem.category?.toLowerCase() ?? '';

    if (category.contains('мясо') || category.contains('рыба')) return 100.0;
    if (category.contains('овощи')) return 200.0;
    if (category.contains('салат')) return 150.0;

    return 100.0; // Стандартная порция
  }

  double _getSnackPortionSize(FoodItem foodItem) {
    // Примерные размеры порций для перекуса
    final category = foodItem.category?.toLowerCase() ?? '';

    if (category.contains('орехи')) return 30.0;
    if (category.contains('фрукт')) return 100.0;
    if (category.contains('йогурт')) return 125.0;
    if (category.contains('печенье')) return 25.0;

    return 50.0; // Стандартная порция для перекуса
  }
}
