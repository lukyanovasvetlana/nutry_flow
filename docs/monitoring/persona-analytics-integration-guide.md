# Интеграция персоны аналитика в NutryFlow

## Обзор

Система персоны аналитика в NutryFlow позволяет отслеживать пользовательское поведение с учетом индивидуальных характеристик пользователя, его целей, предпочтений и физических параметров.

## Архитектура

### 1. Компоненты системы
- **PersonaAnalyticsService** - основной сервис управления персонами
- **PersonaAnalyticsTracker** - утилита для отслеживания событий
- **PersonaAnalyticsMixin** - миксин для интеграции в виджеты

### 2. Типы персон
- **beginner_weight_loss** - начинающий пользователь с целью похудения
- **advanced_fitness** - продвинутый пользователь с целью набора мышечной массы
- **health_conscious** - пользователь, заботящийся о здоровье
- **health_management** - пользователь с медицинскими состояниями
- **athlete** - спортсмен
- **general_wellness** - общее оздоровление

## Настройка

### 1. Инициализация в main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация персоны аналитика
  await PersonaAnalyticsTracker.instance.initialize();
  
  runApp(const MyApp());
}
```

### 2. Установка профиля пользователя
```dart
// При входе пользователя
await PersonaAnalyticsTracker.instance.setUserProfile(userProfile);

// При обновлении профиля
await PersonaAnalyticsTracker.instance.setUserProfile(updatedProfile);
```

## Использование в виджетах

### 1. Использование миксина
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
    trackScreenView(
      screenName: 'my_screen',
      additionalData: {
        'user_id': currentUserProfile?.id,
      },
    );
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
            additionalData: {
              'user_id': currentUserProfile?.id,
            },
          ),
          
          // Поле поиска с отслеживанием
          createTrackedSearchField(
            searchCategory: 'recipes',
            controller: _searchController,
            onSearch: _handleSearch,
            hintText: 'Поиск рецептов...',
          ),
          
          // Список с отслеживанием выбора
          createTrackedListView(
            itemType: 'recipe',
            items: recipes,
            itemBuilder: (item, index) => RecipeCard(recipe: item),
            onItemTap: _selectRecipe,
          ),
        ],
      ),
    );
  }
}
```

### 2. Отслеживание событий
```dart
// Отслеживание нажатия кнопки
trackButtonClick(
  buttonName: 'start_workout',
  screenName: 'workout_screen',
  additionalData: {
    'workout_type': 'cardio',
    'duration': 30,
  },
);

// Отслеживание поиска
trackSearch(
  searchTerm: 'healthy breakfast',
  searchCategory: 'recipes',
  additionalData: {
    'filter_dietary': 'vegetarian',
  },
);

// Отслеживание выбора элемента
trackItemSelection(
  itemType: 'recipe',
  itemId: 'recipe_123',
  itemName: 'Овсянка с фруктами',
  additionalData: {
    'calories': 350,
    'protein': 12,
  },
);

// Отслеживание прогресса цели
trackGoalProgress(
  goalType: 'weight_loss',
  currentValue: 75.0,
  targetValue: 70.0,
);
```

## Отслеживание изменений профиля

### 1. Автоматическое отслеживание
```dart
// При обновлении профиля автоматически отслеживаются:
// - Изменение веса
// - Изменение уровня активности
// - Изменение диетических предпочтений
// - Изменение целей фитнеса
// - Изменение аллергий
// - Изменение состояний здоровья

await PersonaAnalyticsTracker.instance.setUserProfile(updatedProfile);
```

### 2. Ручное отслеживание изменений
```dart
// Отслеживание изменения веса
await PersonaAnalyticsService.instance.trackWeightChange(
  oldWeight: 80.0,
  newWeight: 78.5,
  targetWeight: 70.0,
);

// Отслеживание изменения уровня активности
await PersonaAnalyticsService.instance.trackActivityLevelChange(
  oldLevel: ActivityLevel.low,
  newLevel: ActivityLevel.medium,
);

// Отслеживание изменения диетических предпочтений
await PersonaAnalyticsService.instance.trackDietaryPreferenceChange(
  oldPreferences: [DietaryPreference.vegetarian],
  newPreferences: [DietaryPreference.vegetarian, DietaryPreference.glutenFree],
);
```

## Пользовательские свойства

### 1. Базовые свойства
- `user_id` - идентификатор пользователя
- `user_email` - email пользователя
- `user_name` - полное имя пользователя
- `user_gender` - пол пользователя
- `user_age` - возраст пользователя

### 2. Свойства персоны
- `user_persona` - тип персоны
- `activity_level` - уровень активности
- `user_height_cm` - рост в сантиметрах
- `user_weight_kg` - вес в килограммах
- `user_bmi` - индекс массы тела

### 3. Свойства целей
- `fitness_goals` - цели фитнеса
- `target_weight_kg` - целевой вес
- `target_calories` - целевые калории
- `target_protein_g` - целевой белок
- `target_carbs_g` - целевые углеводы
- `target_fat_g` - целевой жир

### 4. Свойства предпочтений
- `dietary_preferences` - диетические предпочтения
- `allergies` - аллергии
- `health_conditions` - состояния здоровья
- `food_restrictions` - ограничения в питании

## События аналитики

### 1. События профиля
```dart
// Обновление профиля
{
  "event_name": "profile_updated",
  "field_name": "weight",
  "old_value": "80.0",
  "new_value": "78.5"
}

// Изменение веса
{
  "event_name": "weight_changed",
  "old_weight_kg": 80.0,
  "new_weight_kg": 78.5,
  "weight_change_kg": -1.5,
  "target_weight_kg": 70.0,
  "progress_to_target_percent": 75.0
}

// Изменение уровня активности
{
  "event_name": "activity_level_changed",
  "old_activity_level": "low",
  "new_activity_level": "medium"
}
```

### 2. События целей
```dart
// Прогресс цели
{
  "event_name": "goal_progress",
  "goal_type": "weight_loss",
  "current_value": 75.0,
  "target_value": 70.0,
  "progress_percentage": 75.0
}
```

### 3. События сессий
```dart
// Сессия пользователя
{
  "event_name": "user_session",
  "session_type": "workout",
  "duration_minutes": 45,
  "user_persona": "beginner_weight_loss"
}
```

### 4. События функций
```dart
// Использование функции
{
  "event_name": "feature_usage",
  "feature_name": "recipe_search",
  "action": "search",
  "user_persona": "health_conscious",
  "search_term": "vegetarian",
  "search_category": "recipes"
}
```

## Интеграция с существующими экранами

### 1. Добавление миксина
```dart
// Добавьте миксин к существующему State
class _ExistingScreenState extends State<ExistingScreen> 
    with PersonaAnalyticsMixin {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Отслеживание просмотра экрана
    trackScreenView(screenName: 'existing_screen');
  }
}
```

### 2. Замена обычных кнопок на отслеживаемые
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

### 3. Добавление отслеживания к существующим виджетам
```dart
// Оборачивание существующего виджета
createTrackedCard(
  itemType: 'recipe',
  itemId: recipe.id,
  itemName: recipe.name,
  child: ExistingRecipeCard(recipe: recipe),
  onTap: () => _selectRecipe(recipe),
)
```

## Лучшие практики

### 1. Именование событий
- Используйте понятные имена для кнопок и элементов
- Группируйте связанные события по категориям
- Используйте консистентную терминологию

### 2. Структурирование данных
- Всегда включайте `user_id` в дополнительные данные
- Группируйте связанные параметры
- Используйте типизированные значения

### 3. Производительность
- Не блокируйте UI отслеживанием событий
- Используйте асинхронные вызовы
- Обрабатывайте ошибки gracefully

### 4. Конфиденциальность
- Не отслеживайте чувствительные данные
- Анонимизируйте данные при необходимости
- Соблюдайте GDPR и другие законы

## Отладка и тестирование

### 1. Проверка инициализации
```dart
if (isAnalyticsInitialized) {
  print('Analytics initialized successfully');
} else {
  print('Analytics not initialized');
}
```

### 2. Проверка профиля пользователя
```dart
final profile = currentUserProfile;
if (profile != null) {
  print('Current user: ${profile.fullName}');
  print('User persona: ${_getUserPersona()}');
}
```

### 3. Тестирование событий
```dart
// В тестах
test('should track button click', () async {
  await trackButtonClick(
    buttonName: 'test_button',
    screenName: 'test_screen',
  );
  
  // Проверяем, что событие отправлено
  // (в реальном приложении проверяйте через Firebase Console)
});
```

## Мониторинг в Firebase Console

### 1. Пользовательские свойства
- Перейдите в Firebase Console > Analytics > User Properties
- Найдите свойства с префиксом `user_`
- Анализируйте распределение по персонам

### 2. События
- Перейдите в Firebase Console > Analytics > Events
- Найдите события с префиксом `profile_`, `goal_`, `feature_`
- Анализируйте конверсии и воронки

### 3. Аудитории
- Создайте аудитории на основе персон
- Настройте сегментацию по целям
- Анализируйте поведение разных групп

## Будущие улучшения

### 1. Машинное обучение
- Автоматическое определение персон
- Предсказание поведения пользователей
- Персонализированные рекомендации

### 2. Расширенная аналитика
- Когортный анализ
- Анализ жизненного цикла
- A/B тестирование по персонам

### 3. Интеграции
- Интеграция с CRM системами
- Экспорт данных в BI инструменты
- Автоматизация маркетинга 