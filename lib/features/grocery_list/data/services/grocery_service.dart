import '../../domain/entities/grocery_item.dart';

/// Сервис для работы со списком покупок
/// Предоставляет вспомогательные функции и моковые данные
class GroceryService {
  /// Получает список категорий товаров
  static List<String> getCategories() {
    return [
      'Овощи и фрукты',
      'Молочные продукты',
      'Мясо и рыба',
      'Хлеб и выпечка',
      'Крупы и макароны',
      'Консервы',
      'Напитки',
      'Сладости',
      'Прочее',
    ];
  }

  /// Получает единицы измерения
  static List<String> getUnits() {
    return [
      'шт',
      'кг',
      'г',
      'л',
      'мл',
      'упак',
    ];
  }

  /// Получает моковые данные для тестирования
  static List<GroceryItem> getMockItems() {
    return [
      GroceryItem(
        id: '1',
        name: 'Молоко',
        category: 'Молочные продукты',
        quantity: 1,
        unit: 'л',
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      GroceryItem(
        id: '2',
        name: 'Хлеб',
        category: 'Хлеб и выпечка',
        quantity: 1,
        unit: 'шт',
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
