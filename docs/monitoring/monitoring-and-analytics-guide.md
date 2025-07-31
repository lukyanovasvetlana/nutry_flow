# Мониторинг и аналитика в NutryFlow

## Обзор

NutryFlow использует комплексную систему мониторинга и аналитики на основе Firebase для отслеживания производительности, ошибок и пользовательского поведения.

## Архитектура мониторинга

### 1. Компоненты системы
- **AnalyticsService** - сервис для Firebase Analytics
- **PerformanceService** - сервис для Firebase Performance
- **CrashlyticsService** - сервис для Firebase Crashlytics
- **MonitoringService** - общий сервис координации

### 2. Типы отслеживания
- **События** - пользовательские действия и системные события
- **Экраны** - просмотры экранов с метриками производительности
- **Ошибки** - crash-отчеты и исключения
- **Производительность** - время загрузки, API запросы, использование памяти

## Настройка Firebase

### 1. Добавление зависимостей
```yaml
dependencies:
  firebase_analytics: ^10.8.0
  firebase_crashlytics: ^3.4.8
  firebase_performance: ^0.9.3+8
```

### 2. Инициализация в main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация всех сервисов мониторинга
  await MonitoringService.instance.initialize();
  
  runApp(const MyApp());
}
```

## Использование сервисов

### 1. AnalyticsService
```dart
// Отслеживание события
await AnalyticsService.instance.logEvent(
  name: 'user_action',
  parameters: {
    'action_type': 'button_click',
    'screen_name': 'home_screen',
  },
);

// Отслеживание экрана
await AnalyticsService.instance.logScreenView(
  screenName: 'home_screen',
  screenClass: 'HomeScreen',
);

// Установка пользовательского свойства
await AnalyticsService.instance.setUserProperty(
  name: 'user_level',
  value: 'premium',
);
```

### 2. PerformanceService
```dart
// Отслеживание времени загрузки экрана
await PerformanceService.instance.trackScreenLoadTime(
  'home_screen',
  () async {
    // Код загрузки экрана
    await loadHomeData();
  },
);

// Отслеживание API запроса
await PerformanceService.instance.trackApiRequest(
  'api/users',
  () async {
    // API запрос
    await fetchUserData();
  },
);

// Создание пользовательского трейса
final trace = PerformanceService.instance.createTrace('custom_operation');
await trace.start();
// Выполнение операции
await trace.stop();
```

### 3. CrashlyticsService
```dart
// Логирование ошибки
await CrashlyticsService.instance.logError(
  error,
  stackTrace,
  reason: 'API request failed',
  additionalData: {
    'endpoint': '/api/users',
    'user_id': '123',
  },
);

// Логирование исключения
await CrashlyticsService.instance.logException(
  exception,
  stackTrace,
  reason: 'Database operation failed',
);

// Установка пользовательского ключа
await CrashlyticsService.instance.setCustomKey(
  'feature_enabled',
  true,
);
```

### 4. MonitoringService (общий сервис)
```dart
// Отслеживание события с полным мониторингом
await MonitoringService.instance.trackEvent(
  eventName: 'user_action',
  parameters: {
    'action_type': 'button_click',
  },
  screenName: 'home_screen',
);

// Отслеживание экрана с производительностью
await MonitoringService.instance.trackScreen(
  screenName: 'home_screen',
  screenLoadFunction: () async {
    await loadHomeData();
  },
);

// Отслеживание API запроса с мониторингом
await MonitoringService.instance.trackApiRequest(
  endpoint: '/api/users',
  method: 'GET',
  apiCall: () async {
    await fetchUserData();
  },
  requestData: {
    'user_id': '123',
  },
);

// Отслеживание ошибки
await MonitoringService.instance.trackError(
  error: error,
  stackTrace: stackTrace,
  screenName: 'home_screen',
  actionName: 'load_data',
);
```

## Специализированные методы отслеживания

### 1. Отслеживание целей
```dart
await MonitoringService.instance.trackGoalAchievement(
  goalName: 'Похудеть на 5 кг',
  goalType: 'weight_loss',
  progress: 75.0,
  additionalData: {
    'current_weight': 70.0,
    'target_weight': 65.0,
  },
);
```

### 2. Отслеживание тренировок
```dart
await MonitoringService.instance.trackWorkout(
  workoutType: 'cardio',
  durationMinutes: 30,
  caloriesBurned: 250,
  workoutName: 'Бег в парке',
  additionalData: {
    'distance_km': 5.0,
    'avg_heart_rate': 140,
  },
);
```

### 3. Отслеживание приема пищи
```dart
await MonitoringService.instance.trackMeal(
  mealType: 'breakfast',
  calories: 350,
  protein: 15.0,
  fat: 12.0,
  carbs: 45.0,
  mealName: 'Овсянка с фруктами',
  additionalData: {
    'ingredients': ['oats', 'banana', 'honey'],
  },
);
```

## Метрики производительности

### 1. Время запуска приложения
```dart
await PerformanceService.instance.trackAppStartTime();
```

### 2. Время загрузки экрана
```dart
await PerformanceService.instance.trackScreenLoadTime(
  'home_screen',
  () async {
    await loadHomeData();
  },
);
```

### 3. Время API запроса
```dart
await PerformanceService.instance.trackApiRequest(
  'api/users',
  () async {
    await fetchUserData();
  },
);
```

### 4. Использование памяти
```dart
await PerformanceService.instance.trackMemoryUsage();
```

### 5. Время отклика UI
```dart
await PerformanceService.instance.trackUIResponseTime(
  'button_click',
  () async {
    await handleButtonClick();
  },
);
```

## Типы ошибок

### 1. API ошибки
```dart
await CrashlyticsService.instance.logApiError(
  endpoint: '/api/users',
  method: 'GET',
  statusCode: 500,
  errorMessage: 'Internal server error',
  requestData: {
    'user_id': '123',
  },
  responseData: {
    'error': 'Database connection failed',
  },
);
```

### 2. Ошибки базы данных
```dart
await CrashlyticsService.instance.logDatabaseError(
  operation: 'SELECT',
  table: 'users',
  errorMessage: 'Table not found',
  queryData: {
    'query': 'SELECT * FROM users WHERE id = ?',
    'parameters': ['123'],
  },
);
```

### 3. Ошибки аутентификации
```dart
await CrashlyticsService.instance.logAuthError(
  operation: 'login',
  errorMessage: 'Invalid credentials',
  userId: 'user@example.com',
);
```

### 4. UI ошибки
```dart
await CrashlyticsService.instance.logUIError(
  screenName: 'home_screen',
  widgetName: 'UserProfileWidget',
  errorMessage: 'Widget build failed',
  additionalData: {
    'user_id': '123',
  },
);
```

### 5. Сетевые ошибки
```dart
await CrashlyticsService.instance.logNetworkError(
  url: 'https://api.example.com/users',
  method: 'GET',
  errorMessage: 'Connection timeout',
  statusCode: 408,
);
```

## Пользовательские события

### 1. События входа/регистрации
```dart
// Вход пользователя
await AnalyticsService.instance.logLogin(
  method: 'email',
  userId: 'user@example.com',
);

// Регистрация пользователя
await AnalyticsService.instance.logSignUp(
  method: 'email',
  userId: 'user@example.com',
);
```

### 2. События покупок
```dart
// Добавление в корзину
await AnalyticsService.instance.logAddToCart(
  itemId: 'premium_subscription',
  itemName: 'Premium Subscription',
  itemCategory: 'subscription',
  price: 9.99,
  currency: 'USD',
  quantity: 1,
);

// Покупка
await AnalyticsService.instance.logPurchase(
  transactionId: 'txn_123',
  value: 9.99,
  currency: 'USD',
  items: [
    AnalyticsEventItem(
      itemId: 'premium_subscription',
      itemName: 'Premium Subscription',
      itemCategory: 'subscription',
      price: 9.99,
      quantity: 1,
    ),
  ],
);
```

### 3. События поиска
```dart
await AnalyticsService.instance.logSearch(
  searchTerm: 'healthy recipes',
);
```

### 4. События выбора контента
```dart
await AnalyticsService.instance.logSelectContent(
  contentType: 'recipe',
  itemId: 'recipe_123',
);
```

## Настройка в Firebase Console

### 1. Analytics
1. Перейдите в Firebase Console
2. Выберите проект
3. Перейдите в Analytics
4. Настройте события и параметры

### 2. Performance
1. Перейдите в Performance
2. Настройте трейсы и метрики
3. Установите пороги производительности

### 3. Crashlytics
1. Перейдите в Crashlytics
2. Настройте фильтры и алерты
3. Настройте группировку ошибок

## Лучшие практики

### 1. Оптимизация производительности
- Отслеживайте критические пути
- Устанавливайте пороги производительности
- Мониторьте использование памяти

### 2. Обработка ошибок
- Логируйте все ошибки с контекстом
- Группируйте похожие ошибки
- Настройте алерты для критических ошибок

### 3. Аналитика пользователей
- Отслеживайте ключевые события
- Анализируйте пользовательские пути
- Оптимизируйте на основе данных

### 4. Безопасность
- Не логируйте чувствительные данные
- Используйте анонимизацию
- Соблюдайте GDPR и другие законы

## Отладка и тестирование

### 1. Тестирование аналитики
```dart
test('should track user action', () async {
  await MonitoringService.instance.trackEvent(
    eventName: 'test_event',
    parameters: {
      'test_parameter': 'test_value',
    },
  );
  
  // Проверяем, что событие отправлено
  // (в реальном приложении проверяйте через Firebase Console)
});
```

### 2. Тестирование производительности
```dart
test('should track screen load time', () async {
  await PerformanceService.instance.trackScreenLoadTime(
    'test_screen',
    () async {
      await Future.delayed(Duration(milliseconds: 100));
    },
  );
  
  // Проверяем, что трейс создан
});
```

### 3. Тестирование ошибок
```dart
test('should log error', () async {
  final error = Exception('Test error');
  
  await CrashlyticsService.instance.logError(
    error,
    StackTrace.current,
    reason: 'Test error logging',
  );
  
  // Проверяем, что ошибка отправлена
});
```

## Мониторинг в продакшене

### 1. Дашборды
- Создайте дашборды в Firebase Console
- Настройте алерты для критических метрик
- Регулярно анализируйте данные

### 2. Алерты
- Настройте алерты для высокого количества ошибок
- Мониторьте производительность API
- Отслеживайте аномалии в пользовательском поведении

### 3. Отчеты
- Генерируйте еженедельные отчеты
- Анализируйте тренды
- Оптимизируйте на основе данных

## Будущие улучшения

### 1. Расширенная аналитика
- Машинное обучение для предсказания поведения
- Персонализированные рекомендации
- A/B тестирование

### 2. Улучшенный мониторинг
- Real-time мониторинг
- Автоматическое исправление ошибок
- Прогнозирование проблем

### 3. Интеграции
- Интеграция с внешними инструментами
- Экспорт данных
- Автоматизация процессов 