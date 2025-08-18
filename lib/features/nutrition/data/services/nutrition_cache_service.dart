import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item_model.dart';
import '../models/food_entry_model.dart';
import '../models/nutrition_summary_model.dart';

class NutritionCacheService {
  final SharedPreferences _prefs;

  NutritionCacheService(this._prefs);

  // Cache keys
  static const String _recentSearchesKey = 'nutrition_recent_searches';
  static const String _popularFoodItemsKey = 'nutrition_popular_food_items';
  static const String _favoriteFoodItemsKey = 'nutrition_favorite_food_items';
  static const String _foodCategoriesKey = 'nutrition_food_categories';
  static const String _lastSyncKey = 'nutrition_last_sync';

  // Recent searches
  Future<List<String>> getRecentSearches() async {
    try {
      final searches = _prefs.getStringList(_recentSearchesKey) ?? [];
      return searches;
    } catch (e) {
      return [];
    }
  }

  Future<void> addRecentSearch(String query) async {
    try {
      final searches = await getRecentSearches();

      // Remove if already exists
      searches.remove(query);

      // Add to beginning
      searches.insert(0, query);

      // Keep only last 10 searches
      if (searches.length > 10) {
        searches.removeRange(10, searches.length);
      }

      await _prefs.setStringList(_recentSearchesKey, searches);
    } catch (e) {
      // Ignore cache errors
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      await _prefs.remove(_recentSearchesKey);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Popular food items cache
  Future<List<FoodItemModel>?> getPopularFoodItems() async {
    try {
      final jsonString = _prefs.getString(_popularFoodItemsKey);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => FoodItemModel.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> cachePopularFoodItems(List<FoodItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(_popularFoodItemsKey, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Favorite food items cache
  Future<List<FoodItemModel>?> getFavoriteFoodItems(String userId) async {
    try {
      final key = '${_favoriteFoodItemsKey}_$userId';
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => FoodItemModel.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheFavoriteFoodItems(
      String userId, List<FoodItemModel> items) async {
    try {
      final key = '${_favoriteFoodItemsKey}_$userId';
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Food categories cache
  Future<List<String>?> getFoodCategories() async {
    try {
      return _prefs.getStringList(_foodCategoriesKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheFoodCategories(List<String> categories) async {
    try {
      await _prefs.setStringList(_foodCategoriesKey, categories);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Food entries cache (for offline support)
  Future<List<FoodEntryModel>?> getCachedFoodEntries(
      String userId, DateTime date) async {
    try {
      final key =
          'food_entries_${userId}_${date.toIso8601String().split('T')[0]}';
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => FoodEntryModel.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheFoodEntries(
      String userId, DateTime date, List<FoodEntryModel> entries) async {
    try {
      final key =
          'food_entries_${userId}_${date.toIso8601String().split('T')[0]}';
      final jsonList = entries.map((entry) => entry.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Nutrition summary cache
  Future<NutritionSummaryModel?> getCachedNutritionSummary(
      String userId, DateTime date) async {
    try {
      final key =
          'nutrition_summary_${userId}_${date.toIso8601String().split('T')[0]}';
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return NutritionSummaryModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheNutritionSummary(
      String userId, NutritionSummaryModel summary) async {
    try {
      final key =
          'nutrition_summary_${userId}_${summary.date.toIso8601String().split('T')[0]}';
      final jsonString = jsonEncode(summary.toJson());
      await _prefs.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Sync management
  Future<DateTime?> getLastSyncTime() async {
    try {
      final timestamp = _prefs.getInt(_lastSyncKey);
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }

  Future<void> setLastSyncTime(DateTime time) async {
    try {
      await _prefs.setInt(_lastSyncKey, time.millisecondsSinceEpoch);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Cache invalidation
  Future<void> invalidateCache() async {
    try {
      final keys = [
        _popularFoodItemsKey,
        _foodCategoriesKey,
        _lastSyncKey,
      ];

      for (final key in keys) {
        await _prefs.remove(key);
      }

      // Remove user-specific caches
      final allKeys = _prefs.getKeys();
      for (final key in allKeys) {
        if (key.startsWith('food_entries_') ||
            key.startsWith('nutrition_summary_') ||
            key.startsWith('${_favoriteFoodItemsKey}_')) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      // Ignore cache errors
    }
  }

  Future<void> invalidateUserCache(String userId) async {
    try {
      final allKeys = _prefs.getKeys();
      for (final key in allKeys) {
        if (key.contains(userId)) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Search suggestions cache
  Future<List<String>?> getSearchSuggestions(String query) async {
    try {
      final key = 'search_suggestions_${query.toLowerCase()}';
      return _prefs.getStringList(key);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheSearchSuggestions(
      String query, List<String> suggestions) async {
    try {
      final key = 'search_suggestions_${query.toLowerCase()}';
      await _prefs.setStringList(key, suggestions);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Food item details cache
  Future<FoodItemModel?> getCachedFoodItem(String id) async {
    try {
      final key = 'food_item_$id';
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return FoodItemModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheFoodItem(FoodItemModel item) async {
    try {
      final key = 'food_item_${item.id}';
      final jsonString = jsonEncode(item.toJson());
      await _prefs.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Barcode cache
  Future<FoodItemModel?> getCachedFoodItemByBarcode(String barcode) async {
    try {
      final key = 'barcode_$barcode';
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return FoodItemModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheFoodItemByBarcode(
      String barcode, FoodItemModel item) async {
    try {
      final key = 'barcode_$barcode';
      final jsonString = jsonEncode(item.toJson());
      await _prefs.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final allKeys = _prefs.getKeys();
      final stats = <String, dynamic>{};

      stats['total_keys'] = allKeys.length;
      stats['recent_searches'] = (await getRecentSearches()).length;
      stats['last_sync'] = await getLastSyncTime();

      // Count different types of cached items
      int foodItemsCount = 0;
      int foodEntriesCount = 0;
      int summariesCount = 0;
      int searchSuggestionsCount = 0;

      for (final key in allKeys) {
        if (key.startsWith('food_item_')) {
          foodItemsCount++;
        } else if (key.startsWith('food_entries_'))
          foodEntriesCount++;
        else if (key.startsWith('nutrition_summary_'))
          summariesCount++;
        else if (key.startsWith('search_suggestions_'))
          searchSuggestionsCount++;
      }

      stats['cached_food_items'] = foodItemsCount;
      stats['cached_food_entries'] = foodEntriesCount;
      stats['cached_summaries'] = summariesCount;
      stats['cached_search_suggestions'] = searchSuggestionsCount;

      return stats;
    } catch (e) {
      return {};
    }
  }
}
