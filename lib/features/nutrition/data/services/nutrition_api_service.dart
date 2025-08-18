import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_item_model.dart';
import '../models/food_entry_model.dart';
import '../models/nutrition_summary_model.dart';
import '../../domain/entities/food_entry.dart';

class NutritionApiService {
  final SupabaseClient _supabase;

  NutritionApiService(this._supabase);

  // Food Items API methods
  Future<List<FoodItemModel>> searchFoodItems(String query,
      {int limit = 20}) async {
    try {
      final response = await _supabase
          .from('food_items')
          .select('*')
          .or('name.ilike.%$query%,brand.ilike.%$query%')
          .limit(limit);

      return (response as List)
          .map((json) => FoodItemModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search food items: $e');
    }
  }

  Future<FoodItemModel?> getFoodItemById(String id) async {
    try {
      final response = await _supabase
          .from('food_items')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return FoodItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get food item: $e');
    }
  }

  Future<FoodItemModel?> getFoodItemByBarcode(String barcode) async {
    try {
      final response = await _supabase
          .from('food_items')
          .select('*')
          .eq('barcode', barcode)
          .maybeSingle();

      if (response == null) return null;
      return FoodItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get food item by barcode: $e');
    }
  }

  Future<List<String>> getFoodCategories() async {
    try {
      final response = await _supabase
          .from('food_items')
          .select('category')
          .not('category', 'is', null)
          .order('category');

      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();

      return categories;
    } catch (e) {
      throw Exception('Failed to get food categories: $e');
    }
  }

  Future<List<FoodItemModel>> getFoodItemsByCategory(String category,
      {int limit = 20}) async {
    try {
      final response = await _supabase
          .from('food_items')
          .select('*')
          .eq('category', category)
          .limit(limit);

      return (response as List)
          .map((json) => FoodItemModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get food items by category: $e');
    }
  }

  Future<List<FoodItemModel>> getPopularFoodItems({int limit = 20}) async {
    try {
      // Get most frequently used food items
      final response = await _supabase
          .rpc('get_popular_food_items', params: {'limit_count': limit});

      return (response as List)
          .map((json) => FoodItemModel.fromJson(json))
          .toList();
    } catch (e) {
      // Fallback to verified items if RPC fails
      final response = await _supabase
          .from('food_items')
          .select('*')
          .eq('is_verified', true)
          .limit(limit);

      return (response as List)
          .map((json) => FoodItemModel.fromJson(json))
          .toList();
    }
  }

  Future<FoodItemModel> createFoodItem(FoodItemModel foodItem) async {
    try {
      final response = await _supabase
          .from('food_items')
          .insert(foodItem.toJson())
          .select()
          .single();

      return FoodItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create food item: $e');
    }
  }

  Future<FoodItemModel> updateFoodItem(FoodItemModel foodItem) async {
    try {
      final response = await _supabase
          .from('food_items')
          .update(foodItem.toJson())
          .eq('id', foodItem.id)
          .select()
          .single();

      return FoodItemModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update food item: $e');
    }
  }

  Future<void> deleteFoodItem(String id) async {
    try {
      await _supabase.from('food_items').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete food item: $e');
    }
  }

  // Food Entries API methods
  Future<FoodEntryModel> createFoodEntry(FoodEntryModel entry) async {
    try {
      final response = await _supabase
          .from('food_entries')
          .insert(entry.toJson())
          .select('*, food_items(*)')
          .single();

      return FoodEntryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create food entry: $e');
    }
  }

  Future<FoodEntryModel> updateFoodEntry(FoodEntryModel entry) async {
    try {
      final response = await _supabase
          .from('food_entries')
          .update(entry.toJson())
          .eq('id', entry.id)
          .select('*, food_items(*)')
          .single();

      return FoodEntryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update food entry: $e');
    }
  }

  Future<void> deleteFoodEntry(String id) async {
    try {
      await _supabase.from('food_entries').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete food entry: $e');
    }
  }

  Future<List<FoodEntryModel>> getFoodEntriesByDate(
      String userId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('food_entries')
          .select('*, food_items(*)')
          .eq('user_id', userId)
          .gte('consumed_at', startOfDay.toIso8601String())
          .lt('consumed_at', endOfDay.toIso8601String())
          .order('consumed_at', ascending: false);

      return (response as List)
          .map((json) => FoodEntryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get food entries by date: $e');
    }
  }

  Future<List<FoodEntryModel>> getRecentFoodEntries(String userId,
      {int limit = 10}) async {
    try {
      final response = await _supabase
          .from('food_entries')
          .select('*, food_items(*)')
          .eq('user_id', userId)
          .order('consumed_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => FoodEntryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent food entries: $e');
    }
  }

  Future<List<FoodEntryModel>> getFoodEntriesByDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      final response = await _supabase
          .from('food_entries')
          .select('*, food_items(*)')
          .eq('user_id', userId)
          .gte('consumed_at', startDate.toIso8601String())
          .lte('consumed_at', endDate.toIso8601String())
          .order('consumed_at');

      return (response as List)
          .map((json) => FoodEntryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get food entries by date range: $e');
    }
  }

  Future<List<FoodEntryModel>> getFoodEntriesByMealType(
      String userId, DateTime date, MealType mealType) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('food_entries')
          .select('*, food_items(*)')
          .eq('user_id', userId)
          .eq('meal_type', mealType.toString().split('.').last)
          .gte('consumed_at', startOfDay.toIso8601String())
          .lt('consumed_at', endOfDay.toIso8601String())
          .order('consumed_at');

      return (response as List)
          .map((json) => FoodEntryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get food entries by meal type: $e');
    }
  }

  // Nutrition Summary API methods
  Future<NutritionSummaryModel?> getNutritionSummary(
      String userId, DateTime date) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];

      final response = await _supabase
          .from('nutrition_summaries')
          .select('*')
          .eq('user_id', userId)
          .eq('date', dateString)
          .maybeSingle();

      if (response == null) return null;
      return NutritionSummaryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get nutrition summary: $e');
    }
  }

  Future<List<NutritionSummaryModel>> getNutritionSummariesByDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      final startDateString = startDate.toIso8601String().split('T')[0];
      final endDateString = endDate.toIso8601String().split('T')[0];

      final response = await _supabase
          .from('nutrition_summaries')
          .select('*')
          .eq('user_id', userId)
          .gte('date', startDateString)
          .lte('date', endDateString)
          .order('date');

      return (response as List)
          .map((json) => NutritionSummaryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get nutrition summaries by date range: $e');
    }
  }

  Future<NutritionSummaryModel> createOrUpdateNutritionSummary(
      String userId, NutritionSummaryModel summary) async {
    try {
      final summaryData = summary.toJson();
      summaryData['user_id'] = userId;

      final response = await _supabase
          .from('nutrition_summaries')
          .upsert(summaryData)
          .select()
          .single();

      return NutritionSummaryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create or update nutrition summary: $e');
    }
  }

  // User favorites and recommendations
  Future<List<FoodItemModel>> getUserFavoriteFoodItems(String userId) async {
    try {
      final response = await _supabase
          .from('user_favorite_foods')
          .select('food_items(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => FoodItemModel.fromJson(item['food_items']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user favorite food items: $e');
    }
  }

  Future<void> addFoodItemToFavorites(String userId, String foodItemId) async {
    try {
      await _supabase.from('user_favorite_foods').insert({
        'user_id': userId,
        'food_item_id': foodItemId,
      });
    } catch (e) {
      throw Exception('Failed to add food item to favorites: $e');
    }
  }

  Future<void> removeFoodItemFromFavorites(
      String userId, String foodItemId) async {
    try {
      await _supabase
          .from('user_favorite_foods')
          .delete()
          .eq('user_id', userId)
          .eq('food_item_id', foodItemId);
    } catch (e) {
      throw Exception('Failed to remove food item from favorites: $e');
    }
  }

  Future<List<FoodItemModel>> getRecommendedFoodItems(String userId) async {
    try {
      // Get recommendations based on user's eating patterns
      final response = await _supabase
          .rpc('get_recommended_food_items', params: {'user_uuid': userId});

      return (response as List)
          .map((json) => FoodItemModel.fromJson(json))
          .toList();
    } catch (e) {
      // Fallback to popular items if RPC fails
      return getPopularFoodItems(limit: 10);
    }
  }
}
