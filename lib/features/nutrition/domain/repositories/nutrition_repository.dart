import '../entities/food_item.dart';
import '../entities/food_entry.dart';
import '../entities/nutrition_summary.dart';

/// Интерфейс репозитория для работы с данными о питании
abstract class NutritionRepository {
  // === Работа с продуктами питания ===

  /// Поиск продуктов питания по названию
  Future<List<FoodItem>> searchFoodItems(String query);

  /// Получение продукта по ID
  Future<FoodItem?> getFoodItemById(String id);

  /// Получение продукта по штрихкоду
  Future<FoodItem?> getFoodItemByBarcode(String barcode);

  /// Создание нового продукта
  Future<FoodItem> createFoodItem(FoodItem foodItem);

  /// Обновление информации о продукте
  Future<FoodItem> updateFoodItem(FoodItem foodItem);

  /// Получение популярных продуктов
  Future<List<FoodItem>> getPopularFoodItems({int limit = 20});

  /// Получение продуктов по категории
  Future<List<FoodItem>> getFoodItemsByCategory(String category);

  // === Работа с записями о приеме пищи ===

  /// Добавление записи о приеме пищи
  Future<FoodEntry> addFoodEntry(FoodEntry entry);

  /// Обновление записи о приеме пищи
  Future<FoodEntry> updateFoodEntry(FoodEntry entry);

  /// Удаление записи о приеме пищи
  Future<void> deleteFoodEntry(String entryId);

  /// Получение записей о приеме пищи за определенную дату
  Future<List<FoodEntry>> getFoodEntriesByDate(String userId, DateTime date);

  /// Получение записей о приеме пищи за период
  Future<List<FoodEntry>> getFoodEntriesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Получение записей о приеме пищи по типу приема пищи
  Future<List<FoodEntry>> getFoodEntriesByMealType(
    String userId,
    DateTime date,
    MealType mealType,
  );

  /// Получение последних записей пользователя
  Future<List<FoodEntry>> getRecentFoodEntries(String userId, {int limit = 10});

  // === Работа с суммарной информацией ===

  /// Получение суммарной информации о питании за день
  Future<NutritionSummary> getNutritionSummaryByDate(String userId, DateTime date);

  /// Получение суммарной информации о питании за период
  Future<List<NutritionSummary>> getNutritionSummariesByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Получение статистики питания за неделю
  Future<Map<DateTime, NutritionSummary>> getWeeklyNutritionStats(
    String userId,
    DateTime weekStart,
  );

  /// Получение статистики питания за месяц
  Future<Map<DateTime, NutritionSummary>> getMonthlyNutritionStats(
    String userId,
    DateTime monthStart,
  );

  // === Дополнительные методы ===

  /// Получение часто используемых продуктов пользователя
  Future<List<FoodItem>> getUserFavoriteFoodItems(String userId, {int limit = 10});

  /// Получение рекомендуемых продуктов на основе целей пользователя
  Future<List<FoodItem>> getRecommendedFoodItems(String userId, {int limit = 10});

  /// Проверка достижения дневных целей по питанию
  Future<Map<String, bool>> checkDailyNutritionGoals(String userId, DateTime date);

  /// Получение тенденций питания пользователя
  Future<Map<String, double>> getNutritionTrends(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
} 