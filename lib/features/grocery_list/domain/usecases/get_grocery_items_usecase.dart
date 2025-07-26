import '../entities/grocery_item.dart';
import '../repositories/grocery_repository.dart';

/// Результат получения товаров
class GetGroceryItemsResult {
  final List<GroceryItem> items;
  final String? error;
  final bool isSuccess;
  
  const GetGroceryItemsResult.success(this.items) 
      : error = null, isSuccess = true;
  
  const GetGroceryItemsResult.failure(this.error) 
      : items = const [], isSuccess = false;
}

/// Use case для получения списка покупок
class GetGroceryItemsUseCase {
  final GroceryRepository _repository;
  
  const GetGroceryItemsUseCase(this._repository);
  
  /// Получает все товары в списке покупок
  Future<GetGroceryItemsResult> execute() async {
    try {
      final items = await _repository.getAllGroceryItems();
      return GetGroceryItemsResult.success(items);
    } catch (e) {
      return GetGroceryItemsResult.failure(
        'Ошибка при получении списка покупок: ${e.toString()}'
      );
    }
  }
} 