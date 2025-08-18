import '../entities/grocery_item.dart';

/// Интерфейс репозитория для работы со списком покупок
abstract class GroceryRepository {
  /// Получает все товары в списке покупок
  Future<List<GroceryItem>> getAllGroceryItems();

  /// Добавляет товар в список покупок
  Future<GroceryItem> addGroceryItem(GroceryItem item);

  /// Обновляет товар в списке покупок
  Future<GroceryItem> updateGroceryItem(GroceryItem item);

  /// Удаляет товар из списка покупок
  Future<bool> deleteGroceryItem(String id);

  /// Отмечает товар как купленный
  Future<GroceryItem> markItemAsPurchased(String id, bool isPurchased);
}
