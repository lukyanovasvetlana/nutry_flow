import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_entry.dart';
import '../../domain/entities/nutrition_summary.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../models/food_item_model.dart';
import '../models/food_entry_model.dart';
import '../models/nutrition_summary_model.dart';
import '../services/nutrition_api_service.dart';
import '../services/nutrition_cache_service.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionApiService _apiService;
  final NutritionCacheService _cacheService;

  NutritionRepositoryImpl(this._apiService, this._cacheService);

  Future<List<FoodItem>> searchFoodItems(String query, {int limit = 20}) async {
    try {
      // Add to recent searches
      await _cacheService.addRecentSearch(query);
      
      // Try to get from API
      final models = await _apiService.searchFoodItems(query, limit: limit);
      final entities = models.map((model) => model.toEntity()).toList();
      
      // Cache individual items
      for (final model in models) {
        await _cacheService.cacheFoodItem(model);
      }
      
      return entities;
    } catch (e) {
      // Return empty list if API fails
      return [];
    }
  }

  Future<FoodItem?> getFoodItemById(String id) async {
    try {
      // Try cache first
      final cachedModel = await _cacheService.getCachedFoodItem(id);
      if (cachedModel != null) {
        return cachedModel.toEntity();
      }
      
      // Try API
      final model = await _apiService.getFoodItemById(id);
      if (model != null) {
        await _cacheService.cacheFoodItem(model);
        return model.toEntity();
      }
      
      return null;
    } catch (e) {
      // Try cache as fallback
      final cachedModel = await _cacheService.getCachedFoodItem(id);
      return cachedModel?.toEntity();
    }
  }

  Future<FoodItem?> getFoodItemByBarcode(String barcode) async {
    try {
      // Try cache first
      final cachedModel = await _cacheService.getCachedFoodItemByBarcode(barcode);
      if (cachedModel != null) {
        return cachedModel.toEntity();
      }
      
      // Try API
      final model = await _apiService.getFoodItemByBarcode(barcode);
      if (model != null) {
        await _cacheService.cacheFoodItem(model);
        await _cacheService.cacheFoodItemByBarcode(barcode, model);
        return model.toEntity();
      }
      
      return null;
    } catch (e) {
      // Try cache as fallback
      final cachedModel = await _cacheService.getCachedFoodItemByBarcode(barcode);
      return cachedModel?.toEntity();
    }
  }

  Future<List<String>> getFoodCategories() async {
    try {
      // Try cache first
      final cachedCategories = await _cacheService.getFoodCategories();
      if (cachedCategories != null && cachedCategories.isNotEmpty) {
        return cachedCategories;
      }
      
      // Try API
      final categories = await _apiService.getFoodCategories();
      await _cacheService.cacheFoodCategories(categories);
      return categories;
    } catch (e) {
      // Return cache as fallback
      final cachedCategories = await _cacheService.getFoodCategories();
      return cachedCategories ?? [];
    }
  }

  Future<List<FoodItem>> getFoodItemsByCategory(String category, {int limit = 20}) async {
    try {
      final models = await _apiService.getFoodItemsByCategory(category, limit: limit);
      final entities = models.map((model) => model.toEntity()).toList();
      
      // Cache individual items
      for (final model in models) {
        await _cacheService.cacheFoodItem(model);
      }
      
      return entities;
    } catch (e) {
      return [];
    }
  }

  Future<List<FoodItem>> getPopularFoodItems({int limit = 20}) async {
    try {
      // Try cache first
      final cachedModels = await _cacheService.getPopularFoodItems();
      if (cachedModels != null && cachedModels.isNotEmpty) {
        return cachedModels.map((model) => model.toEntity()).toList();
      }
      
      // Try API
      final models = await _apiService.getPopularFoodItems(limit: limit);
      await _cacheService.cachePopularFoodItems(models);
      
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Return cache as fallback
      final cachedModels = await _cacheService.getPopularFoodItems();
      return cachedModels?.map((model) => model.toEntity()).toList() ?? [];
    }
  }

  Future<FoodItem> createFoodItem(FoodItem foodItem) async {
    final model = FoodItemModel.fromEntity(foodItem);
    final createdModel = await _apiService.createFoodItem(model);
    
    // Cache the created item
    await _cacheService.cacheFoodItem(createdModel);
    
    return createdModel.toEntity();
  }

  Future<FoodItem> updateFoodItem(FoodItem foodItem) async {
    final model = FoodItemModel.fromEntity(foodItem);
    final updatedModel = await _apiService.updateFoodItem(model);
    
    // Update cache
    await _cacheService.cacheFoodItem(updatedModel);
    
    return updatedModel.toEntity();
  }

  Future<void> deleteFoodItem(String id) async {
    await _apiService.deleteFoodItem(id);
    
    // Remove from cache
    // Note: We can't directly remove from SharedPreferences by pattern,
    // so we'll let the cache naturally expire
  }

  Future<FoodEntry> addFoodEntry(FoodEntry entry) async {
    final model = FoodEntryModel.fromEntity(entry);
    final createdModel = await _apiService.createFoodEntry(model);
    
    // Update cache for the date
    await _updateFoodEntriesCache(entry.userId, entry.consumedAt ?? entry.date);
    
    return createdModel.toEntity();
  }

  Future<FoodEntry> updateFoodEntry(FoodEntry entry) async {
    final model = FoodEntryModel.fromEntity(entry);
    final updatedModel = await _apiService.updateFoodEntry(model);
    
    // Update cache for the date
    await _updateFoodEntriesCache(entry.userId, entry.consumedAt ?? entry.date);
    
    return updatedModel.toEntity();
  }

  Future<void> deleteFoodEntry(String entryId) async {
    await _apiService.deleteFoodEntry(entryId);
    
    // Note: We can't update cache here since we don't have userId and date
    // Cache will be updated when the user refreshes the data
  }

  Future<List<FoodEntry>> getFoodEntriesByDate(String userId, DateTime date) async {
    try {
      // Try cache first
      final cachedModels = await _cacheService.getCachedFoodEntries(userId, date);
      if (cachedModels != null) {
        return cachedModels.map((model) => model.toEntity()).toList();
      }
      
      // Try API
      final models = await _apiService.getFoodEntriesByDate(userId, date);
      await _cacheService.cacheFoodEntries(userId, date, models);
      
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Return cache as fallback
      final cachedModels = await _cacheService.getCachedFoodEntries(userId, date);
      return cachedModels?.map((model) => model.toEntity()).toList() ?? [];
    }
  }

  Future<List<FoodEntry>> getFoodEntriesByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      final models = await _apiService.getFoodEntriesByDateRange(userId, startDate, endDate);
      
      // Cache entries by date
      final entriesByDate = <DateTime, List<FoodEntryModel>>{};
      for (final model in models) {
        final date = DateTime(
          (model.consumedAt ?? model.date).year,
          (model.consumedAt ?? model.date).month,
          (model.consumedAt ?? model.date).day,
        );
        entriesByDate.putIfAbsent(date, () => []).add(model);
      }
      
      for (final entry in entriesByDate.entries) {
        await _cacheService.cacheFoodEntries(userId, entry.key, entry.value);
      }
      
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FoodEntry>> getFoodEntriesByMealType(
    String userId, 
    DateTime date, 
    MealType mealType
  ) async {
    try {
      final models = await _apiService.getFoodEntriesByMealType(userId, date, mealType);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Try to get from cached entries and filter
      final cachedModels = await _cacheService.getCachedFoodEntries(userId, date);
      if (cachedModels != null) {
        final filteredModels = cachedModels
            .where((model) => model.mealType == mealType)
            .toList();
        return filteredModels.map((model) => model.toEntity()).toList();
      }
      return [];
    }
  }

  Future<NutritionSummary?> getDailyNutritionSummary(String userId, DateTime date) async {
    try {
      // Try cache first
      final cachedModel = await _cacheService.getCachedNutritionSummary(userId, date);
      if (cachedModel != null) {
        return cachedModel.toEntity();
      }
      
      // Try API
      final model = await _apiService.getNutritionSummary(userId, date);
      if (model != null) {
        await _cacheService.cacheNutritionSummary(userId, model);
        return model.toEntity();
      }
      
      return null;
    } catch (e) {
      // Return cache as fallback
      final cachedModel = await _cacheService.getCachedNutritionSummary(userId, date);
      return cachedModel?.toEntity();
    }
  }

  Future<NutritionSummary> getNutritionSummaryByDate(String userId, DateTime date) async {
    try {
      // Try cache first
      final cachedModel = await _cacheService.getCachedNutritionSummary(userId, date);
      if (cachedModel != null) {
        return cachedModel.toEntity();
      }
      
      // Try API
      final model = await _apiService.getNutritionSummary(userId, date);
      if (model != null) {
        await _cacheService.cacheNutritionSummary(userId, model);
        return model.toEntity();
      }
      
      // Create empty summary if none exists
      return NutritionSummary.fromEntries(date, []);
    } catch (e) {
      // Return cache as fallback or empty summary
      final cachedModel = await _cacheService.getCachedNutritionSummary(userId, date);
      return cachedModel?.toEntity() ?? NutritionSummary.fromEntries(date, []);
    }
  }

  Future<List<NutritionSummary>> getWeeklyNutritionSummaries(
    String userId, 
    DateTime startDate
  ) async {
    final endDate = startDate.add(const Duration(days: 6));
    return getNutritionSummariesByDateRange(userId, startDate, endDate);
  }

  Future<List<NutritionSummary>> getMonthlyNutritionSummaries(
    String userId, 
    DateTime month
  ) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);
    return getNutritionSummariesByDateRange(userId, startDate, endDate);
  }

  Future<List<NutritionSummary>> getNutritionSummariesByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      final models = await _apiService.getNutritionSummariesByDateRange(
        userId, 
        startDate, 
        endDate
      );
      
      // Cache individual summaries
      for (final model in models) {
        await _cacheService.cacheNutritionSummary(userId, model);
      }
      
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FoodItem>> getUserFavoriteFoodItems(String userId, {int limit = 10}) async {
    try {
      // Try cache first
      final cachedModels = await _cacheService.getFavoriteFoodItems(userId);
      if (cachedModels != null && cachedModels.isNotEmpty) {
        return cachedModels.take(limit).map((model) => model.toEntity()).toList();
      }
      
      // Try API
      final models = await _apiService.getUserFavoriteFoodItems(userId);
      await _cacheService.cacheFavoriteFoodItems(userId, models);
      
      return models.take(limit).map((model) => model.toEntity()).toList();
    } catch (e) {
      // Return cache as fallback
      final cachedModels = await _cacheService.getFavoriteFoodItems(userId);
      return cachedModels?.take(limit).map((model) => model.toEntity()).toList() ?? [];
    }
  }

  Future<void> addFoodItemToFavorites(String userId, String foodItemId) async {
    await _apiService.addFoodItemToFavorites(userId, foodItemId);
    
    // Invalidate favorites cache
    await _cacheService.cacheFavoriteFoodItems(userId, []);
  }

  Future<void> removeFoodItemFromFavorites(String userId, String foodItemId) async {
    await _apiService.removeFoodItemFromFavorites(userId, foodItemId);
    
    // Invalidate favorites cache
    await _cacheService.cacheFavoriteFoodItems(userId, []);
  }

  Future<List<FoodItem>> getRecommendedFoodItems(String userId, {int limit = 10}) async {
    try {
      final models = await _apiService.getRecommendedFoodItems(userId);
      return models.take(limit).map((model) => model.toEntity()).toList();
    } catch (e) {
      // Fallback to popular items
      return getPopularFoodItems(limit: limit);
    }
  }

  Future<Map<String, bool>> checkDailyNutritionGoals(String userId, DateTime date) async {
    try {
      final summary = await getNutritionSummaryByDate(userId, date);
      // This is a simplified implementation - in real app you'd get user goals
      return {
        'calories': summary.totalCalories >= 1200 && summary.totalCalories <= 2500,
        'protein': summary.totalProtein >= 50,
        'fats': summary.totalFats >= 20 && summary.totalFats <= 80,
        'carbs': summary.totalCarbs >= 100 && summary.totalCarbs <= 300,
      };
    } catch (e) {
      return {
        'calories': false,
        'protein': false,
        'fats': false,
        'carbs': false,
      };
    }
  }

  Future<Map<String, double>> getNutritionTrends(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final summaries = await getNutritionSummariesByDateRange(userId, startDate, endDate);
      
      if (summaries.isEmpty) {
        return {
          'avg_calories': 0.0,
          'avg_protein': 0.0,
          'avg_fats': 0.0,
          'avg_carbs': 0.0,
        };
      }

      final avgCalories = summaries.map((s) => s.totalCalories).reduce((a, b) => a + b) / summaries.length;
      final avgProtein = summaries.map((s) => s.totalProtein).reduce((a, b) => a + b) / summaries.length;
      final avgFats = summaries.map((s) => s.totalFats).reduce((a, b) => a + b) / summaries.length;
      final avgCarbs = summaries.map((s) => s.totalCarbs).reduce((a, b) => a + b) / summaries.length;

      return {
        'avg_calories': avgCalories,
        'avg_protein': avgProtein,
        'avg_fats': avgFats,
        'avg_carbs': avgCarbs,
      };
    } catch (e) {
      return {
        'avg_calories': 0.0,
        'avg_protein': 0.0,
        'avg_fats': 0.0,
        'avg_carbs': 0.0,
      };
    }
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      // Try cache first
      final cachedSuggestions = await _cacheService.getSearchSuggestions(query);
      if (cachedSuggestions != null && cachedSuggestions.isNotEmpty) {
        return cachedSuggestions;
      }
      
      // Generate suggestions from search results
      final searchResults = await searchFoodItems(query, limit: 5);
      final suggestions = searchResults.map((item) => item.name).toList();
      
      // Cache suggestions
      await _cacheService.cacheSearchSuggestions(query, suggestions);
      
      return suggestions;
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getRecentSearches() async {
    return _cacheService.getRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    await _cacheService.clearRecentSearches();
  }

  Future<List<FoodEntry>> getRecentFoodEntries(String userId, {int limit = 10}) async {
    try {
      final models = await _apiService.getRecentFoodEntries(userId, limit: limit);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<DateTime, NutritionSummary>> getWeeklyNutritionStats(
    String userId,
    DateTime weekStart,
  ) async {
    try {
      final endDate = weekStart.add(const Duration(days: 6));
      final summaries = await getNutritionSummariesByDateRange(userId, weekStart, endDate);
      
      final stats = <DateTime, NutritionSummary>{};
      for (final summary in summaries) {
        stats[summary.date] = summary;
      }
      
      return stats;
    } catch (e) {
      return {};
    }
  }

  Future<Map<DateTime, NutritionSummary>> getMonthlyNutritionStats(
    String userId,
    DateTime monthStart,
  ) async {
    try {
      final startDate = DateTime(monthStart.year, monthStart.month, 1);
      final endDate = DateTime(monthStart.year, monthStart.month + 1, 0);
      final summaries = await getNutritionSummariesByDateRange(userId, startDate, endDate);
      
      final stats = <DateTime, NutritionSummary>{};
      for (final summary in summaries) {
        stats[summary.date] = summary;
      }
      
      return stats;
    } catch (e) {
      return {};
    }
  }

  // Helper method to update food entries cache
  Future<void> _updateFoodEntriesCache(String userId, DateTime date) async {
    try {
      final models = await _apiService.getFoodEntriesByDate(userId, date);
      await _cacheService.cacheFoodEntries(userId, date, models);
      
      // Also update nutrition summary cache
      final entries = models.map((model) => model.toEntity()).toList();
      final summary = NutritionSummary.fromEntries(date, entries);
      final summaryModel = NutritionSummaryModel.fromEntity(summary);
      await _cacheService.cacheNutritionSummary(userId, summaryModel);
      
      // Update API summary
      await _apiService.createOrUpdateNutritionSummary(userId, summaryModel);
    } catch (e) {
      // Ignore cache update errors
    }
  }
} 