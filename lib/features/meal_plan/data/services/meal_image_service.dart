import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

/// Сервис для автоматической генерации/получения изображений блюд
class MealImageService {
  static MealImageService? _instance;
  static MealImageService get instance => _instance ??= MealImageService._();

  MealImageService._();

  // Unsplash API (можно заменить на другой сервис)
  // Для демо используем публичный API без ключа
  static const String _unsplashBaseUrl = 'https://source.unsplash.com';
  
  // Альтернативный вариант - использовать Foodish API (бесплатный, без ключа)
  static const String _foodishBaseUrl = 'https://foodish-api.herokuapp.com';

  /// Получить URL изображения для блюда по его названию
  /// 
  /// Использует несколько стратегий:
  /// 1. Пытается найти изображение по названию блюда
  /// 2. Если не найдено, использует категорию блюда (завтрак, обед, ужин)
  /// 3. Если и это не работает, возвращает placeholder
  Future<String?> getMealImageUrl({
    required String mealName,
    String? mealType,
  }) async {
    try {
      // Очищаем название от лишних символов
      final cleanName = _cleanMealName(mealName);
      
      // Пробуем получить изображение через Unsplash
      final unsplashUrl = _getUnsplashUrl(cleanName);
      
      // Проверяем доступность изображения
      final isAvailable = await _checkImageAvailability(unsplashUrl);
      if (isAvailable) {
        developer.log(
          '✅ MealImageService: Found image for "$mealName"',
          name: 'MealImageService',
        );
        return unsplashUrl;
      }

      // Если не получилось, пробуем по типу блюда
      if (mealType != null) {
        final typeUrl = _getUnsplashUrl(_getMealTypeKeyword(mealType));
        final typeAvailable = await _checkImageAvailability(typeUrl);
        if (typeAvailable) {
          developer.log(
            '✅ MealImageService: Found image by type "$mealType" for "$mealName"',
            name: 'MealImageService',
          );
          return typeUrl;
        }
      }

      // В крайнем случае используем общее изображение еды
      developer.log(
        '⚠️ MealImageService: Using fallback image for "$mealName"',
        name: 'MealImageService',
      );
      return _getFallbackImageUrl();
    } catch (e) {
      developer.log(
        '❌ MealImageService: Error getting image for "$mealName": $e',
        name: 'MealImageService',
      );
      return _getFallbackImageUrl();
    }
  }

  /// Получить URL изображения для категории блюда
  String? getMealTypeImageUrl(String mealType) {
    final keyword = _getMealTypeKeyword(mealType);
    return _getUnsplashUrl(keyword);
  }

  /// Очистка названия блюда для поиска
  String _cleanMealName(String name) {
    // Убираем лишние символы, оставляем только буквы и пробелы
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '+');
  }

  /// Получить ключевое слово для типа блюда
  String _getMealTypeKeyword(String mealType) {
    final type = mealType.toLowerCase();
    if (type.contains('завтрак') || type.contains('breakfast')) {
      return 'breakfast+food';
    } else if (type.contains('обед') || type.contains('lunch')) {
      return 'lunch+food';
    } else if (type.contains('ужин') || type.contains('dinner')) {
      return 'dinner+food';
    } else if (type.contains('перекус') || type.contains('snack')) {
      return 'snack+food';
    }
    return 'food';
  }

  /// Получить URL изображения из Unsplash
  String _getUnsplashUrl(String query) {
    // Unsplash Source API - бесплатный, не требует ключа
    // Формат: https://source.unsplash.com/400x300/?{query}
    return '$_unsplashBaseUrl/400x300/?$query';
  }

  /// Получить fallback изображение
  String _getFallbackImageUrl() {
    // Используем общее изображение еды
    return '$_unsplashBaseUrl/400x300/?food';
  }

  /// Проверить доступность изображения
  Future<bool> _checkImageAvailability(String url) async {
    try {
      final response = await http.head(Uri.parse(url)).timeout(
        const Duration(seconds: 3),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Генерировать URL изображения на основе хеша названия
  /// Это гарантирует, что для одного и того же блюда будет одно и то же изображение
  String? getConsistentImageUrl({
    required String mealName,
    String? mealType,
    int width = 400,
    int height = 300,
  }) {
    // Создаем хеш из названия для консистентности
    final hash = mealName.hashCode.abs();
    
    // Используем хеш для выбора изображения из определенного набора
    // Это гарантирует, что одно и то же блюдо всегда будет иметь одно изображение
    final seed = hash % 1000; // Ограничиваем диапазон
    
    // Используем seed для получения консистентного изображения
    return '$_unsplashBaseUrl/${width}x$height/?food&sig=$seed';
  }

  /// Получить изображение через Foodish API (альтернативный вариант)
  /// Этот API возвращает случайные изображения еды
  Future<String?> getRandomFoodImage() async {
    try {
      final response = await http.get(
        Uri.parse('$_foodishBaseUrl/images/random'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['image'] as String?;
      }
    } catch (e) {
      developer.log(
        '❌ MealImageService: Error getting random food image: $e',
        name: 'MealImageService',
      );
    }
    return null;
  }
}

