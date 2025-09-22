# 🍽️ Meal Plan Feature

## Обзор

Meal Plan - это система планирования питания в приложении NutryFlow, позволяющая пользователям создавать, управлять и отслеживать свои планы питания.

## Архитектура

### Структура папок
```
lib/features/meal_plan/
├── data/
│   ├── models/
│   │   └── meal_plan.dart              # Модель плана питания
│   ├── repositories/
│   │   └── meal_plan_repository_impl.dart # Реализация репозитория
│   └── services/
│       └── meal_plan_service.dart      # Сервис планов питания
├── domain/
│   ├── entities/
│   │   └── meal_plan_entity.dart       # Сущность плана питания
│   ├── repositories/
│   │   └── meal_plan_repository.dart   # Интерфейс репозитория
│   └── usecases/
│       ├── create_meal_plan_usecase.dart    # Создание плана
│       ├── get_meal_plans_usecase.dart      # Получение планов
│       └── update_meal_plan_usecase.dart    # Обновление плана
├── presentation/
│   ├── screens/
│   │   ├── meal_plan_screen.dart       # Главный экран планов
│   │   └── meal_details_screen.dart    # Детали блюда
│   └── widgets/
│       └── meal_plan_card.dart         # Карточка плана
└── di/
    └── meal_plan_dependencies.dart     # Dependency Injection
```

## Основные компоненты

### 1. MealPlan Entity
Модель плана питания с полями:
- `id` - уникальный идентификатор
- `name` - название плана
- `description` - описание
- `meals` - список блюд
- `createdAt` - дата создания
- `updatedAt` - дата обновления
- `isActive` - активен ли план

### 2. MealPlanService
Сервис для работы с планами питания:
- Создание планов
- Получение списка планов
- Обновление планов
- Удаление планов
- Активация/деактивация планов

### 3. Meal Details
Детальная информация о блюде:
- Название и описание
- Ингредиенты
- Пищевая ценность
- Время приготовления
- Категория блюда

## Использование

### Создание плана питания
```dart
final mealPlanService = MealPlanService();
try {
  final mealPlan = await mealPlanService.createMealPlan(
    name: 'Здоровый завтрак',
    description: 'Сбалансированный завтрак',
    meals: [breakfastMeal, lunchMeal, dinnerMeal],
  );
} catch (e) {
  // Обработка ошибки
}
```

### Получение планов питания
```dart
try {
  final mealPlans = await mealPlanService.getMealPlans();
  // Использование планов
} catch (e) {
  // Обработка ошибки
}
```

### Обновление плана
```dart
try {
  await mealPlanService.updateMealPlan(
    mealPlan.copyWith(
      name: 'Обновленное название',
      isActive: true,
    ),
  );
} catch (e) {
  // Обработка ошибки
}
```

## Навигация

### Маршруты
- `/meal-plan` - главный экран планов питания
- `/meal-details` - детали блюда

### Пример навигации
```dart
// Переход к планам питания
Navigator.pushNamed(context, '/meal-plan');

// Переход к деталям блюда
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MealDetailsScreen(mealName: 'Салат Цезарь'),
  ),
);
```

## Валидация

### Валидация названия плана
```dart
bool isValidPlanName(String name) {
  return name.isNotEmpty && name.length >= 3;
}
```

### Валидация блюд
```dart
bool isValidMeal(Meal meal) {
  return meal.name.isNotEmpty && 
         meal.ingredients.isNotEmpty &&
         meal.nutritionalValue.calories > 0;
}
```

## Тестирование

### Unit тесты
```bash
flutter test test/features/meal_plan/
```

### Покрытие тестами
- ✅ MealPlanService - 2 теста
- ❌ Widgets - требуются тесты
- ❌ Use cases - требуются тесты

### Тестовые данные
```dart
const testMealPlan = MealPlan(
  id: 'test-plan-id',
  name: 'Тестовый план',
  description: 'Описание тестового плана',
  meals: [testMeal1, testMeal2],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isActive: true,
);
```

## Обработка ошибок

### Типы ошибок
- `MealPlanNotFoundException` - план не найден
- `ValidationException` - ошибка валидации
- `NetworkException` - ошибка сети
- `DuplicateMealPlanException` - дублирующийся план

### Пример обработки
```dart
try {
  await mealPlanService.createMealPlan(mealPlan);
} on ValidationException catch (e) {
  showError('Ошибка валидации: ${e.message}');
} on DuplicateMealPlanException {
  showError('План с таким названием уже существует');
} catch (e) {
  showError('Произошла неизвестная ошибка');
}
```

## Локальное хранение

### SharedPreferences
```dart
// Сохранение плана
await prefs.setString('meal_plan_$id', jsonEncode(mealPlan.toJson()));

// Загрузка плана
final planJson = prefs.getString('meal_plan_$id');
if (planJson != null) {
  final mealPlan = MealPlan.fromJson(jsonDecode(planJson));
}
```

### Кэширование
- Планы кэшируются локально
- Автоматическая синхронизация с сервером
- Офлайн поддержка

## Зависимости

- `shared_preferences` - локальное хранение
- `supabase` - Backend as a Service
- `dio` - HTTP клиент
- `flutter/material.dart` - UI компоненты

## Конфигурация

### Supabase настройка
```dart
// В main.dart
Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

## Известные проблемы

1. **Data sync** - нет автоматической синхронизации
2. **Offline support** - ограниченная поддержка офлайн
3. **Image upload** - нет загрузки изображений блюд

## Планы развития

- [ ] Добавить загрузку изображений блюд
- [ ] Реализовать синхронизацию данных
- [ ] Улучшить offline support
- [ ] Добавить шаблоны планов
- [ ] Реализовать sharing планов

## Связанные фичи

- **Dashboard** - отображение планов
- **Nutrition** - пищевая ценность
- **Menu** - рецепты блюд
- **Analytics** - аналитика питания
