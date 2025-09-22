# 🍽️ Menu Feature

## 📋 Обзор

Модуль Menu отвечает за управление рецептами, создание здорового меню и планирование питания.

## 🏗️ Архитектура

### Domain Layer
- **Entities**: `Recipe`, `Ingredient`, `MenuItem`, `NutritionFacts`, `RecipeStep`
- **Repositories**: `RecipeRepository`
- **Use Cases**: `GetAllRecipesUsecase`, `SaveRecipeUsecase`, `DeleteRecipeUsecase`

### Data Layer
- **Models**: `RecipeModel`, `IngredientModel`, `MenuItemModel`, `NutritionFactsModel`
- **Services**: `RecipeService`, `MockRecipeService`
- **Repositories**: `RecipeRepositoryImpl`

### Presentation Layer
- **Screens**: `HealthyMenuScreen`, `RecipeDetailsScreen`, `AddEditRecipeScreen`
- **Widgets**: `MenuItemCard`, `IngredientDialog`, `PhotosCarousel`, `PreviewRecipeModal`

## 🚀 Основные функции

### 1. Управление рецептами
- Создание и редактирование рецептов
- Добавление ингредиентов и шагов
- Загрузка фотографий блюд
- Категоризация рецептов

### 2. Здоровое меню
- Рекомендации рецептов
- Фильтрация по диетам
- Поиск по ингредиентам
- Популярные рецепты

### 3. Планирование питания
- Создание меню на неделю
- Расчет калорий и макронутриентов
- Список покупок
- Планирование порций

### 4. Аналитика питания
- Анализ питательной ценности
- Сравнение рецептов
- Тренды в питании
- Рекомендации по улучшению

## 📱 Экраны

### HealthyMenuScreen
Главный экран с каталогом рецептов и рекомендациями.

### RecipeDetailsScreen
Детальная информация о рецепте с ингредиентами и инструкциями.

### AddEditRecipeScreen
Создание и редактирование рецептов.

## 🧪 Тестирование

### Unit Tests
```bash
flutter test test/features/menu/data/services/recipe_service_test.dart
```

### Widget Tests
```bash
flutter test test/features/menu/presentation/screens/healthy_menu_screen_test.dart
```

### Integration Tests
```bash
flutter test integration_test/menu_integration_test.dart
```

## 🔧 Использование

### Создание рецепта
```dart
final recipeService = RecipeService();
final recipe = Recipe(
  name: 'Салат Цезарь',
  description: 'Классический салат с курицей',
  ingredients: [ingredient1, ingredient2],
  steps: [step1, step2],
  nutritionFacts: NutritionFacts(
    calories: 350,
    protein: 25,
    carbs: 15,
    fat: 20,
  ),
);
await recipeService.saveRecipe(recipe);
```

### Получение рецептов
```dart
final recipes = await recipeService.getAllRecipes();
```

### Поиск рецептов
```dart
final results = await recipeService.searchRecipes('салат');
```

## ⚠️ Обработка ошибок

- **Ошибки загрузки**: Retry механизм
- **Неверные данные**: Валидация рецептов
- **Дублирование**: Проверка существующих рецептов
- **Ошибки изображений**: Fallback изображения

## 🚀 Планы развития

- [ ] ИИ-рекомендации рецептов
- [ ] Интеграция с доставкой продуктов
- [ ] Социальные функции (обмен рецептами)
- [ ] Видео-инструкции
- [ ] Персональные диеты

## 🔗 Связанные фичи

- **Nutrition**: Анализ питательной ценности
- **Grocery List**: Список покупок
- **Profile**: Диетические предпочтения
- **Analytics**: Аналитика питания

---

**Версия**: 1.0.0  
**Последнее обновление**: $(date)  
**Статус**: ✅ Готово к использованию
