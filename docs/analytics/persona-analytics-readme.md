# Персона аналитика в NutryFlow

## 🎯 Обзор

Система персоны аналитика в NutryFlow позволяет отслеживать пользовательское поведение с учетом индивидуальных характеристик пользователя. Это помогает создавать персонализированный опыт и улучшать продукт на основе данных.

## 🏗️ Архитектура

### Основные компоненты:

1. **PersonaAnalyticsService** (`lib/core/services/persona_analytics_service.dart`)
   - Основной сервис управления персонами
   - Устанавливает пользовательские свойства в Firebase Analytics
   - Определяет тип персоны на основе профиля

2. **PersonaAnalyticsTracker** (`lib/features/analytics/presentation/utils/persona_analytics_tracker.dart`)
   - Утилита для отслеживания событий
   - Автоматически отслеживает изменения в профиле
   - Предоставляет удобные методы для трекинга

3. **PersonaAnalyticsMixin** (`lib/features/analytics/presentation/mixins/persona_analytics_mixin.dart`)
   - Миксин для интеграции в виджеты Flutter
   - Предоставляет готовые виджеты с отслеживанием
   - Упрощает добавление аналитики в существующие экраны

## 🚀 Быстрый старт

### 1. Инициализация

Система уже инициализирована в `main.dart`:

```dart
// Инициализация персоны аналитика
await PersonaAnalyticsTracker.instance.initialize();
```

### 2. Установка профиля пользователя

```dart
// При входе пользователя
await PersonaAnalyticsTracker.instance.setUserProfile(userProfile);

// При обновлении профиля
await PersonaAnalyticsTracker.instance.setUserProfile(updatedProfile);
```

### 3. Использование в виджетах

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with PersonaAnalyticsMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Отслеживание просмотра экрана
    trackScreenView(screenName: 'my_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Кнопка с отслеживанием
          createTrackedElevatedButton(
            buttonName: 'save_data',
            text: 'Сохранить',
            onPressed: _saveData,
          ),
          
          // Поле поиска с отслеживанием
          createTrackedSearchField(
            searchCategory: 'recipes',
            controller: _searchController,
            onSearch: _handleSearch,
          ),
        ],
      ),
    );
  }
}
```

## 👥 Типы персон

Система автоматически определяет тип персоны на основе профиля пользователя:

- **beginner_weight_loss** - начинающий пользователь с целью похудения
- **advanced_fitness** - продвинутый пользователь с целью набора мышечной массы
- **health_conscious** - пользователь, заботящийся о здоровье
- **health_management** - пользователь с медицинскими состояниями
- **athlete** - спортсмен
- **general_wellness** - общее оздоровление

## 📊 Отслеживаемые события

### Автоматически отслеживаемые изменения:
- Изменение веса
- Изменение уровня активности
- Изменение диетических предпочтений
- Изменение целей фитнеса
- Изменение аллергий
- Изменение состояний здоровья

### Ручное отслеживание:

```dart
// Отслеживание нажатия кнопки
trackButtonClick(
  buttonName: 'start_workout',
  screenName: 'workout_screen',
);

// Отслеживание поиска
trackSearch(
  searchTerm: 'healthy breakfast',
  searchCategory: 'recipes',
);

// Отслеживание выбора элемента
trackItemSelection(
  itemType: 'recipe',
  itemId: 'recipe_123',
  itemName: 'Овсянка с фруктами',
);

// Отслеживание прогресса цели
trackGoalProgress(
  goalType: 'weight_loss',
  currentValue: 75.0,
  targetValue: 70.0,
);
```

## 🎨 Готовые виджеты

### Кнопки с отслеживанием:
```dart
// Обычная кнопка
createTrackedElevatedButton(
  buttonName: 'save_profile',
  text: 'Сохранить профиль',
  onPressed: _saveProfile,
);

// Текстовая кнопка
createTrackedTextButton(
  buttonName: 'edit_profile',
  text: 'Редактировать',
  onPressed: _editProfile,
);

// Иконка
createTrackedIconButton(
  buttonName: 'delete_item',
  icon: Icon(Icons.delete),
  onPressed: _deleteItem,
);
```

### Поле поиска:
```dart
createTrackedSearchField(
  searchCategory: 'recipes',
  controller: _searchController,
  onSearch: _handleSearch,
  hintText: 'Поиск рецептов...',
);
```

### Списки и гриды:
```dart
// Список с отслеживанием выбора
createTrackedListView(
  itemType: 'recipe',
  items: recipes,
  itemBuilder: (item, index) => RecipeCard(recipe: item),
  onItemTap: _selectRecipe,
);

// Грид с отслеживанием выбора
createTrackedGridView(
  itemType: 'workout',
  items: workouts,
  itemBuilder: (item, index) => WorkoutCard(workout: item),
  onItemTap: _selectWorkout,
  crossAxisCount: 2,
);
```

### Карточки:
```dart
createTrackedCard(
  itemType: 'meal',
  itemId: meal.id,
  itemName: meal.name,
  child: MealCard(meal: meal),
  onTap: () => _selectMeal(meal),
);
```

## 🔧 Интеграция с существующими экранами

### 1. Добавление миксина:
```dart
class _ExistingScreenState extends State<ExistingScreen> 
    with PersonaAnalyticsMixin {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trackScreenView(screenName: 'existing_screen');
  }
}
```

### 2. Замена обычных кнопок:
```dart
// Было
ElevatedButton(
  onPressed: _handleClick,
  child: Text('Кнопка'),
)

// Стало
createTrackedElevatedButton(
  buttonName: 'my_button',
  text: 'Кнопка',
  onPressed: _handleClick,
)
```

### 3. Оборачивание существующих виджетов:
```dart
createTrackedCard(
  itemType: 'recipe',
  itemId: recipe.id,
  itemName: recipe.name,
  child: ExistingRecipeCard(recipe: recipe),
  onTap: () => _selectRecipe(recipe),
)
```

## 📈 Пользовательские свойства

Система автоматически устанавливает следующие свойства в Firebase Analytics:

### Базовые свойства:
- `user_id` - идентификатор пользователя
- `user_email` - email пользователя
- `user_name` - полное имя пользователя
- `user_gender` - пол пользователя
- `user_age` - возраст пользователя

### Свойства персоны:
- `user_persona` - тип персоны
- `activity_level` - уровень активности
- `user_height_cm` - рост в сантиметрах
- `user_weight_kg` - вес в килограммах
- `user_bmi` - индекс массы тела

### Свойства целей:
- `fitness_goals` - цели фитнеса
- `target_weight_kg` - целевой вес
- `target_calories` - целевые калории
- `target_protein_g` - целевой белок
- `target_carbs_g` - целевые углеводы
- `target_fat_g` - целевой жир

### Свойства предпочтений:
- `dietary_preferences` - диетические предпочтения
- `allergies` - аллергии
- `health_conditions` - состояния здоровья
- `food_restrictions` - ограничения в питании

## 🧪 Тестирование

### Запуск тестов:
```bash
flutter test test/features/analytics/persona_analytics_test.dart
```

### Проверка инициализации:
```dart
if (isAnalyticsInitialized) {
  print('Analytics initialized successfully');
} else {
  print('Analytics not initialized');
}
```

### Проверка профиля пользователя:
```dart
final profile = currentUserProfile;
if (profile != null) {
  print('Current user: ${profile.fullName}');
}
```

## 📊 Мониторинг в Firebase Console

### 1. Пользовательские свойства:
- Перейдите в Firebase Console > Analytics > User Properties
- Найдите свойства с префиксом `user_`
- Анализируйте распределение по персонам

### 2. События:
- Перейдите в Firebase Console > Analytics > Events
- Найдите события с префиксом `profile_`, `goal_`, `feature_`
- Анализируйте конверсии и воронки

### 3. Аудитории:
- Создайте аудитории на основе персон
- Настройте сегментацию по целям
- Анализируйте поведение разных групп

## 🔒 Безопасность и конфиденциальность

### Лучшие практики:
- Не отслеживайте чувствительные данные
- Анонимизируйте данные при необходимости
- Соблюдайте GDPR и другие законы
- Используйте асинхронные вызовы для неблокирующего трекинга

### Обработка ошибок:
```dart
try {
  await trackButtonClick(buttonName: 'my_button');
} catch (e) {
  print('Failed to track button click: $e');
  // Продолжаем работу приложения
}
```

## 📚 Примеры использования

### Полный пример экрана:
См. `lib/features/profile/presentation/screens/profile_screen_with_analytics.dart`

### Документация:
См. `docs/monitoring/persona-analytics-integration-guide.md`

## 🚀 Будущие улучшения

### Планируемые функции:
- Машинное обучение для автоматического определения персон
- Предсказание поведения пользователей
- Персонализированные рекомендации
- Когортный анализ
- A/B тестирование по персонам

### Интеграции:
- Интеграция с CRM системами
- Экспорт данных в BI инструменты
- Автоматизация маркетинга

## 🤝 Поддержка

Если у вас есть вопросы или предложения по улучшению системы персоны аналитика, создайте issue в репозитории проекта.

---

**Примечание**: Система персоны аналитика интегрирована с существующей архитектурой NutryFlow и использует Firebase Analytics для отправки данных. Убедитесь, что Firebase правильно настроен в проекте. 