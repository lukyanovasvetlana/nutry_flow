# 📊 Analytics Feature

## Обзор

Analytics - это система аналитики и A/B тестирования для приложения NutryFlow, которая отслеживает пользовательские действия и предоставляет данные для принятия решений.

## Архитектура

### Структура папок
```
lib/features/analytics/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── screens/
│   │   ├── analytics_screen.dart           # Главный экран аналитики
│   │   ├── developer_analytics_screen.dart # Экран для разработчиков
│   │   ├── health_articles_screen.dart     # Статьи о здоровье
│   │   └── ab_testing_screen.dart          # A/B тестирование
│   ├── widgets/
│   └── mixins/
│       └── analytics_mixin.dart            # Миксин для аналитики
└── di/
    └── analytics_dependencies.dart         # Dependency Injection
```

## Основные компоненты

### 1. AnalyticsService
Центральный сервис для отслеживания событий:
- Отслеживание экранов
- Отслеживание действий пользователя
- Отслеживание ошибок
- Отслеживание навигации

### 2. ABTestingService
Сервис для A/B тестирования:
- Управление экспериментами
- Флаги функций
- Отслеживание конверсий

### 3. AnalyticsMixin
Миксин для удобного использования аналитики в виджетах:
```dart
class MyWidget extends StatefulWidget with AnalyticsMixin {
  @override
  void initState() {
    super.initState();
    trackScreenView('my_screen');
  }
}
```

## Использование

### Отслеживание экрана
```dart
// В initState виджета
trackScreenView(AnalyticsUtils.screenDashboard);
```

### Отслеживание действий
```dart
trackUIInteraction(
  elementType: AnalyticsUtils.elementTypeButton,
  elementName: 'login_button',
  action: AnalyticsUtils.actionTap,
);
```

### Отслеживание навигации
```dart
trackNavigation(
  fromScreen: AnalyticsUtils.screenLogin,
  toScreen: AnalyticsUtils.screenDashboard,
  navigationMethod: 'push',
);
```

### Отслеживание ошибок
```dart
trackError(
  errorType: 'network_error',
  errorMessage: 'Failed to load data',
  additionalData: {'endpoint': '/api/data'},
);
```

## A/B Тестирование

### Создание эксперимента
```dart
await ABTestingService.instance.trackExperimentExposure(
  experimentName: 'button_color',
  variant: 'blue',
  parameters: {'screen': 'login'},
);
```

### Проверка флага функции
```dart
final isEnabled = ABTestingService.instance.isFeatureEnabled('premium_features');
```

### Отслеживание конверсии
```dart
await ABTestingService.instance.trackExperimentConversion(
  experimentName: 'button_color',
  variant: 'blue',
  conversionType: 'signup',
  parameters: {'value': 100.0},
);
```

## Конфигурация

### Firebase Analytics
```dart
// В main.dart
await Firebase.initializeApp();
await AnalyticsService.instance.initialize();
```

### A/B Testing
```dart
// Настройка экспериментов
await ABTestingService.instance.initialize();
```

## Тестирование

### Unit тесты
```bash
flutter test test/features/analytics/
```

### Покрытие тестами
- ❌ AnalyticsService - требуются тесты
- ❌ ABTestingService - требуются тесты
- ❌ Widgets - требуются тесты

## Метрики

### Отслеживаемые события
- **Screen Views** - просмотры экранов
- **User Interactions** - действия пользователя
- **Navigation** - навигация между экранами
- **Errors** - ошибки приложения
- **Conversions** - конверсии A/B тестов

### KPI
- **Retention Rate** - удержание пользователей
- **Conversion Rate** - конверсия в целевые действия
- **Error Rate** - частота ошибок
- **Session Duration** - длительность сессий

## Зависимости

- `firebase_analytics` - Firebase Analytics
- `firebase_remote_config` - Remote Config для A/B тестов
- `shared_preferences` - локальное хранение
- `dio` - HTTP клиент

## Известные проблемы

1. **Memory leaks** - требуется оптимизация для больших объемов данных
2. **Network errors** - нет retry механизма
3. **Data privacy** - требуется GDPR compliance

## Планы развития

- [ ] Добавить real-time аналитику
- [ ] Реализовать custom events
- [ ] Добавить cohort analysis
- [ ] Улучшить A/B testing UI
- [ ] Добавить data export

## Связанные фичи

- **Dashboard** - отображение аналитики
- **Profile** - пользовательские данные
- **Auth** - аутентификация для аналитики
