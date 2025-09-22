# 🍎 Nutrition Feature

## 📋 Обзор

Модуль Nutrition отвечает за управление питанием, отслеживание калорий, макронутриентов и ведение дневника питания.

## 🏗️ Архитектура

### Domain Layer
- **Entities**: `FoodEntry`, `FoodItem`, `NutritionSummary`
- **Repositories**: `NutritionRepository`
- **Use Cases**: `AddFoodEntryUsecase`, `GetNutritionDiaryUsecase`, `SearchFoodItemsUsecase`

### Data Layer
- **Models**: `FoodEntryModel`, `FoodItemModel`, `NutritionSummaryModel`
- **Services**: `NutritionApiService`, `NutritionCacheService`
- **Repositories**: `NutritionRepositoryImpl`

### Presentation Layer
- **Screens**: `AddFoodEntryScreen`, `FoodSearchScreen`, `NutritionDiaryScreen`
- **Widgets**: `BarcodeScannerButton`, `DailyNutritionSummary`, `FoodEntryCard`, `NutritionCharts`
- **Bloc**: `FoodEntryCubit`, `NutritionDiaryCubit`, `NutritionSearchCubit`

## 🚀 Основные функции

### 1. Дневник питания
- Добавление продуктов и блюд
- Отслеживание калорий и макронутриентов
- Планирование приемов пищи
- История питания

### 2. Поиск продуктов
- Поиск по названию
- Сканирование штрих-кодов
- Категории продуктов
- Популярные продукты

### 3. Аналитика питания
- Графики потребления калорий
- Анализ макронутриентов
- Сравнение с целями
- Тренды питания

### 4. Управление порциями
- Настройка размера порций
- Расчет калорий на порцию
- Сохранение любимых порций

## 📱 Экраны

### NutritionDiaryScreen
Главный экран дневника питания с обзором дневной статистики.

### FoodSearchScreen
Поиск и добавление продуктов в дневник.

### AddFoodEntryScreen
Добавление нового продукта с детальной информацией.

## 🧪 Тестирование

### Unit Tests
```bash
flutter test test/features/nutrition/data/services/nutrition_api_service_test.dart
```

### Widget Tests
```bash
flutter test test/features/nutrition/presentation/screens/nutrition_diary_screen_test.dart
```

### Integration Tests
```bash
flutter test integration_test/nutrition_integration_test.dart
```

## 🔧 Использование

### Добавление продукта
```dart
final nutritionService = NutritionApiService();
final foodItem = FoodItem(
  name: 'Яблоко',
  calories: 52,
  protein: 0.3,
  carbs: 14,
  fat: 0.2,
);
await nutritionService.addFoodItem(foodItem);
```

### Получение дневника питания
```dart
final diary = await nutritionService.getNutritionDiary(DateTime.now());
print('Calories: ${diary.totalCalories}');
```

### Поиск продуктов
```dart
final results = await nutritionService.searchFoodItems('яблоко');
```

## ⚠️ Обработка ошибок

- **Ошибки API**: Retry механизм с экспоненциальной задержкой
- **Нет подключения**: Кэширование данных локально
- **Неверные данные**: Валидация на уровне модели
- **Дублирование**: Проверка существующих записей

## 🚀 Планы развития

- [ ] ИИ-анализ фотографий еды
- [ ] Интеграция с рецептами
- [ ] Социальные функции (обмен рецептами)
- [ ] Интеграция с фитнес-трекерами
- [ ] Персональные рекомендации

## 🔗 Связанные фичи

- **Meal Plan**: Планирование питания
- **Profile**: Цели и предпочтения
- **Analytics**: Аналитика питания
- **Grocery List**: Список покупок

---

**Версия**: 1.0.0  
**Последнее обновление**: $(date)  
**Статус**: ✅ Готово к использованию
