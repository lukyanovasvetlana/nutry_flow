import '../entities/food_item.dart';
import '../repositories/nutrition_repository.dart';

/// Результат поиска продуктов питания
class SearchFoodItemsResult {
  final List<FoodItem> items;
  final String query;
  final int totalFound;
  final bool hasMore;

  const SearchFoodItemsResult({
    required this.items,
    required this.query,
    required this.totalFound,
    required this.hasMore,
  });
}

/// Use Case для поиска продуктов питания
class SearchFoodItemsUseCase {
  final NutritionRepository _repository;

  const SearchFoodItemsUseCase(this._repository);

  /// Выполняет поиск продуктов питания
  Future<SearchFoodItemsResult> execute(String query) async {
    // Валидация поискового запроса
    final cleanQuery = _validateAndCleanQuery(query);
    
    if (cleanQuery.isEmpty) {
      return const SearchFoodItemsResult(
        items: [],
        query: '',
        totalFound: 0,
        hasMore: false,
      );
    }

    // Выполнение поиска
    final items = await _repository.searchFoodItems(cleanQuery);

    // Сортировка результатов по релевантности
    final sortedItems = _sortByRelevance(items, cleanQuery);

    return SearchFoodItemsResult(
      items: sortedItems,
      query: cleanQuery,
      totalFound: sortedItems.length,
      hasMore: false, // Для простоты, в реальном приложении может быть пагинация
    );
  }

  /// Поиск продуктов по запросу (алиас для execute)
  Future<SearchFoodItemsResult> searchByQuery(String query) async {
    return execute(query);
  }

  /// Поиск продукта по штрихкоду
  Future<FoodItem?> searchByBarcode(String barcode) async {
    return findByBarcode(barcode);
  }

  /// Получает часто используемые продукты пользователя
  Future<List<FoodItem>> getFavoriteItems(String userId, {int limit = 10}) async {
    return getUserFavoriteItems(userId, limit: limit);
  }

  /// Получает предложения для поиска
  Future<List<String>> getSearchSuggestions(String query) async {
    final cleanQuery = _validateAndCleanQuery(query);
    
    if (cleanQuery.isEmpty) {
      return [];
    }

    // В реальном приложении здесь был бы запрос к базе данных
    // для получения популярных поисковых запросов
    return getSuggestedQueries(cleanQuery);
  }

  /// Получает популярные продукты
  Future<List<FoodItem>> getPopularItems({int limit = 20}) async {
    return await _repository.getPopularFoodItems(limit: limit);
  }

  /// Получает продукты по категории
  Future<List<FoodItem>> getItemsByCategory(String category) async {
    if (category.trim().isEmpty) {
      throw ArgumentError('Категория не может быть пустой');
    }

    return await _repository.getFoodItemsByCategory(category);
  }

  /// Получает часто используемые продукты пользователя
  Future<List<FoodItem>> getUserFavoriteItems(String userId, {int limit = 10}) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    return await _repository.getUserFavoriteFoodItems(userId, limit: limit);
  }

  /// Получает рекомендуемые продукты для пользователя
  Future<List<FoodItem>> getRecommendedItems(String userId, {int limit = 10}) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    return await _repository.getRecommendedFoodItems(userId, limit: limit);
  }

  /// Поиск продукта по штрихкоду
  Future<FoodItem?> findByBarcode(String barcode) async {
    final cleanBarcode = _validateAndCleanBarcode(barcode);
    
    if (cleanBarcode.isEmpty) {
      return null;
    }

    return await _repository.getFoodItemByBarcode(cleanBarcode);
  }

  /// Валидирует и очищает поисковый запрос
  String _validateAndCleanQuery(String query) {
    // Убираем лишние пробелы и приводим к нижнему регистру
    final cleaned = query.trim().toLowerCase();
    
    // Минимальная длина запроса
    if (cleaned.length < 2) {
      return '';
    }

    // Максимальная длина запроса
    if (cleaned.length > 100) {
      return cleaned.substring(0, 100);
    }

    // Убираем специальные символы, оставляем только буквы, цифры и пробелы
    final regex = RegExp(r'[^a-zA-Zа-яА-Я0-9\s]');
    return cleaned.replaceAll(regex, '').trim();
  }

  /// Валидирует и очищает штрихкод
  String _validateAndCleanBarcode(String barcode) {
    // Убираем все символы кроме цифр
    final cleaned = barcode.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Проверяем длину штрихкода (обычно 8, 12, 13 или 14 цифр)
    if (cleaned.length < 8 || cleaned.length > 14) {
      return '';
    }

    return cleaned;
  }

  /// Сортирует результаты поиска по релевантности
  List<FoodItem> _sortByRelevance(List<FoodItem> items, String query) {
    final sortedItems = List<FoodItem>.from(items);
    
    sortedItems.sort((a, b) {
      final scoreA = _calculateRelevanceScore(a, query);
      final scoreB = _calculateRelevanceScore(b, query);
      return scoreB.compareTo(scoreA); // Сортировка по убыванию
    });

    return sortedItems;
  }

  /// Рассчитывает оценку релевантности продукта для поискового запроса
  int _calculateRelevanceScore(FoodItem item, String query) {
    int score = 0;
    final itemName = item.name.toLowerCase();
    final itemBrand = item.brand?.toLowerCase() ?? '';
    final itemCategory = item.category?.toLowerCase() ?? '';

    // Точное совпадение названия дает максимальный балл
    if (itemName == query) {
      score += 100;
    }
    // Название начинается с запроса
    else if (itemName.startsWith(query)) {
      score += 80;
    }
    // Название содержит запрос
    else if (itemName.contains(query)) {
      score += 60;
    }

    // Бонусы за совпадения в бренде
    if (itemBrand.isNotEmpty) {
      if (itemBrand == query) {
        score += 50;
      } else if (itemBrand.startsWith(query)) {
        score += 30;
      } else if (itemBrand.contains(query)) {
        score += 20;
      }
    }

    // Бонусы за совпадения в категории
    if (itemCategory.isNotEmpty) {
      if (itemCategory == query) {
        score += 40;
      } else if (itemCategory.startsWith(query)) {
        score += 25;
      } else if (itemCategory.contains(query)) {
        score += 15;
      }
    }

    // Штраф за слишком длинные названия (менее релевантные)
    if (itemName.length > query.length * 3) {
      score -= 10;
    }

    return score;
  }

  /// Предлагает альтернативные варианты поиска при отсутствии результатов
  List<String> getSuggestedQueries(String originalQuery) {
    final suggestions = <String>[];
    final query = originalQuery.toLowerCase().trim();

    // Базовые предложения для распространенных продуктов
    final commonSuggestions = {
      'молок': ['молоко', 'молочные продукты', 'кефир', 'йогурт'],
      'хлеб': ['хлеб', 'булочка', 'батон', 'выпечка'],
      'мяс': ['мясо', 'говядина', 'свинина', 'курица'],
      'рыб': ['рыба', 'лосось', 'треска', 'тунец'],
      'овощ': ['овощи', 'помидор', 'огурец', 'морковь'],
      'фрукт': ['фрукты', 'яблоко', 'банан', 'апельсин'],
    };

    // Ищем частичные совпадения
    for (final entry in commonSuggestions.entries) {
      if (query.contains(entry.key) || entry.key.contains(query)) {
        suggestions.addAll(entry.value);
      }
    }

    // Убираем дубликаты и исходный запрос
    return suggestions.toSet().where((s) => s != query).take(5).toList();
  }

  /// Группирует продукты по категориям
  Map<String, List<FoodItem>> groupByCategory(List<FoodItem> items) {
    final grouped = <String, List<FoodItem>>{};

    for (final item in items) {
      final category = item.category ?? 'Без категории';
      grouped.putIfAbsent(category, () => []).add(item);
    }

    // Сортируем категории по количеству продуктов
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Map.fromEntries(sortedEntries);
  }
} 