import '../../domain/entities/grocery_item.dart';
import '../../domain/repositories/grocery_repository.dart';
import '../../../onboarding/data/services/supabase_service.dart';

/// Реализация репозитория для работы со списком покупок
class GroceryRepositoryImpl implements GroceryRepository {
  final SupabaseService _supabaseService;

  static const String _tableName = 'grocery_items';

  GroceryRepositoryImpl(
    this._supabaseService,
  );

  @override
  Future<List<GroceryItem>> getAllGroceryItems() async {
    try {
      final response = await _supabaseService.selectData(_tableName);
      return response.map(GroceryItem.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to get grocery items: $e');
    }
  }

  @override
  Future<GroceryItem> addGroceryItem(GroceryItem item) async {
    try {
      final data = item.toJson();
      final response = await _supabaseService.insertData(_tableName, data);

      if (response.isEmpty) {
        throw Exception('Failed to add grocery item');
      }

      return GroceryItem.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to add grocery item: $e');
    }
  }

  @override
  Future<GroceryItem> updateGroceryItem(GroceryItem item) async {
    try {
      final data = item.toJson();
      final response = await _supabaseService.updateData(
        _tableName,
        data,
        'id',
        item.id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to update grocery item');
      }

      return GroceryItem.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to update grocery item: $e');
    }
  }

  @override
  Future<bool> deleteGroceryItem(String id) async {
    try {
      final response = await _supabaseService.deleteData(
        _tableName,
        'id',
        id,
      );

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to delete grocery item: $e');
    }
  }

  @override
  Future<GroceryItem> markItemAsPurchased(String id, bool isPurchased) async {
    try {
      final response = await _supabaseService.updateData(
        _tableName,
        {
          'is_purchased': isPurchased,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'id',
        id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to mark item as purchased');
      }

      return GroceryItem.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to mark item as purchased: $e');
    }
  }
}
