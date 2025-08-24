# Руководство по интеграции аналитики в Nutry Flow

## Обзор

В проекте Nutry Flow реализована комплексная система аналитики на основе Firebase Analytics с дополнительными возможностями для отслеживания пользовательского поведения, производительности и бизнес-метрик.

## Архитектура

### Основные компоненты

1. **AnalyticsService** (`lib/core/services/analytics_service.dart`)
   - Основной сервис для работы с аналитикой
   - Управляет инициализацией и настройкой
   - Предоставляет методы для отслеживания событий

2. **FirebaseAnalyticsImpl** (`lib/core/services/firebase_analytics_impl.dart`)
   - Реальная реализация Firebase Analytics
   - Заменяет mock-версию для продакшена

3. **FirebaseService** (`lib/core/services/firebase_service.dart`)
   - Сервис инициализации Firebase
   - Управляет всеми Firebase сервисами

4. **AnalyticsMixin** (`lib/features/analytics/presentation/mixins/analytics_mixin.dart`)
   - Миксин для автоматического отслеживания в StatefulWidget
   - Предоставляет готовые методы для отслеживания

5. **AnalyticsWrapper** (`lib/features/analytics/presentation/widgets/analytics_wrapper.dart`)
   - Виджет-обертка для автоматического отслеживания экранов
   - Отслеживает жизненный цикл экранов

6. **AnalyticsUtils** (`lib/features/analytics/presentation/utils/analytics_utils.dart`)
   - Утилиты для работы с аналитикой
   - Константы и готовые методы

## Установка и настройка

### 1. Зависимости

Убедитесь, что в `pubspec.yaml` подключены необходимые пакеты:

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_analytics: ^10.8.0
  firebase_remote_config: ^4.3.8
  firebase_crashlytics: ^3.4.8
  firebase_performance: ^0.9.3+8
  firebase_messaging: ^14.7.10
```

### 2. Конфигурация Firebase

1. Создайте проект в [Firebase Console](https://console.firebase.google.com/)
2. Добавьте приложение для Android и iOS
3. Скачайте конфигурационные файлы:
   - `google-services.json` для Android
   - `GoogleService-Info.plist` для iOS
4. Разместите файлы в соответствующих директориях

### 3. Инициализация

Firebase автоматически инициализируется в `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await FirebaseService.instance.initialize();
  
  runApp(const MyApp());
}
```

## Использование

### Базовое отслеживание экранов

#### Вариант 1: Использование AnalyticsWrapper

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnalyticsWrapper(
      screenName: 'my_screen',
      child: Scaffold(
        // содержимое экрана
      ),
    );
  }
}
```

#### Вариант 2: Использование AnalyticsMixin

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with AnalyticsMixin {
  @override
  void initState() {
    super.initState();
    trackScreenView('my_screen');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // содержимое экрана
    );
  }
}
```

#### Вариант 3: Ручное отслеживание

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreenView(
      screenName: 'my_screen',
      screenClass: 'MyScreen',
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // содержимое экрана
    );
  }
}
```

### Отслеживание событий

#### Отслеживание нажатий на кнопки

```dart
ElevatedButton(
  onPressed: () {
    // Отслеживаем нажатие
    AnalyticsUtils.trackButtonTap(
      'login_button',
      parameters: {'screen': 'login_screen'},
    );
    
    // Логика кнопки
    _performLogin();
  },
  child: Text('Войти'),
)
```

#### Отслеживание навигации

```dart
Navigator.pushNamed(context, '/dashboard').then((_) {
  AnalyticsUtils.trackNavigation(
    fromScreen: 'login_screen',
    toScreen: 'dashboard_screen',
    navigationMethod: 'push_named',
  );
});
```

#### Отслеживание ошибок

```dart
try {
  // код, который может вызвать ошибку
} catch (e) {
  AnalyticsUtils.trackError(
    errorType: 'api_error',
    errorMessage: e.toString(),
    screenName: 'login_screen',
    additionalData: {'endpoint': '/auth/login'},
  );
}
```

#### Отслеживание производительности

```dart
final stopwatch = Stopwatch()..start();

// выполнение операции

stopwatch.stop();
AnalyticsUtils.trackPerformance(
  metricName: 'api_response_time',
  value: stopwatch.elapsedMilliseconds.toDouble(),
  unit: 'ms',
  additionalData: {'endpoint': '/api/data'},
);
```

### Отслеживание бизнес-событий

#### Достижение цели

```dart
AnalyticsUtils.trackGoalAchievement(
  goalName: 'weight_loss',
  goalType: 'fitness',
  progress: 75.0,
  additionalData: {
    'target_weight': 70.0,
    'current_weight': 72.5,
  },
);
```

#### Завершение тренировки

```dart
AnalyticsUtils.trackWorkout(
  workoutType: 'cardio',
  durationMinutes: 45,
  caloriesBurned: 350,
  workoutName: 'Morning Run',
  additionalData: {
    'distance_km': 5.2,
    'avg_heart_rate': 140,
  },
);
```

#### Прием пищи

```dart
AnalyticsUtils.trackMeal(
  mealType: 'breakfast',
  calories: 450,
  protein: 25.0,
  fat: 18.0,
  carbs: 45.0,
  mealName: 'Oatmeal with Berries',
  additionalData: {
    'meal_time': '08:30',
    'ingredients_count': 8,
  },
);
```

## Константы и стандарты

### Названия экранов

Используйте константы из `AnalyticsUtils`:

```dart
AnalyticsUtils.screenSplash      // 'splash'
AnalyticsUtils.screenWelcome     // 'welcome'
AnalyticsUtils.screenLogin       // 'login'
AnalyticsUtils.screenDashboard   // 'dashboard'
// и т.д.
```

### Типы элементов UI

```dart
AnalyticsUtils.elementTypeButton    // 'button'
AnalyticsUtils.elementTypeInput     // 'input'
AnalyticsUtils.elementTypeList      // 'list'
AnalyticsUtils.elementTypeCard      // 'card'
// и т.д.
```

### Действия

```dart
AnalyticsUtils.actionTap         // 'tap'
AnalyticsUtils.actionLongPress   // 'long_press'
AnalyticsUtils.actionSwipe       // 'swipe'
AnalyticsUtils.actionScroll      // 'scroll'
// и т.д.
```

## Лучшие практики

### 1. Именование событий

- Используйте snake_case для названий событий
- Будьте последовательны в именовании
- Используйте префиксы для группировки: `screen_view`, `button_tap`, `api_error`

### 2. Параметры событий

- Не отправляйте персональные данные пользователей
- Используйте типизированные значения (String, int, double, bool)
- Ограничивайте количество параметров (не более 25)

### 3. Частота событий

- Не отправляйте события слишком часто
- Группируйте связанные события
- Используйте дебаунсинг для частых действий

### 4. Обработка ошибок

- Всегда обрабатывайте ошибки в try-catch блоках
- Отслеживайте ошибки с контекстом
- Не блокируйте основной поток при отправке аналитики

## Тестирование

### Mock-версия

В тестах используется mock-версия Firebase Analytics:

```dart
// В тестах аналитика не будет отправляться на сервер
// но все события будут логироваться
```

### Отладка

Для отладки аналитики используйте Firebase Console:

1. Откройте [Firebase Console](https://console.firebase.google.com/)
2. Выберите ваш проект
3. Перейдите в Analytics > Events
4. Просматривайте события в реальном времени

## Мониторинг и отчеты

### Основные метрики

- **Пользователи**: DAU, MAU, удержание
- **Экраны**: популярность, время на экране
- **События**: конверсии, воронки
- **Производительность**: время загрузки, ошибки

### Настройка целей

В Firebase Console настройте цели для отслеживания:

1. Регистрация пользователя
2. Первая тренировка
3. Достижение цели
4. Покупка премиум-подписки

## Безопасность и приватность

### GDPR и CCPA

- Получайте согласие пользователей на сбор аналитики
- Предоставляйте возможность отключения
- Не собирайте персональные данные

### Конфиденциальность

- Не отправляйте пароли, токены, персональные данные
- Используйте хеширование для идентификаторов
- Соблюдайте принцип минимальной достаточности

## Примеры интеграции

### Экран входа

```dart
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AnalyticsMixin {
  @override
  void initState() {
    super.initState();
    trackScreenView('login_screen');
  }

  void _handleLogin() {
    trackButtonTap('login_button');
    
    try {
      // логика входа
      _performLogin();
    } catch (e) {
      trackError(
        errorType: 'login_failed',
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _handleLogin,
            child: Text('Войти'),
          ),
        ],
      ),
    );
  }
}
```

### Экран тренировки

```dart
class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with AnalyticsMixin {
  @override
  void initState() {
    super.initState();
    trackScreenView('workout_screen');
  }

  void _startWorkout() {
    trackButtonTap('start_workout_button');
    // логика начала тренировки
  }

  void _completeWorkout(WorkoutData workout) {
    trackWorkout(
      workoutType: workout.type,
      durationMinutes: workout.duration.inMinutes,
      caloriesBurned: workout.caloriesBurned,
      workoutName: workout.name,
      additionalData: {
        'workout_id': workout.id,
        'difficulty': workout.difficulty,
      },
    );
    // логика завершения тренировки
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _startWorkout,
            child: Text('Начать тренировку'),
          ),
          ElevatedButton(
            onPressed: () => _completeWorkout(_currentWorkout),
            child: Text('Завершить'),
          ),
        ],
      ),
    );
  }
}
```

## Заключение

Система аналитики в Nutry Flow предоставляет мощные инструменты для отслеживания пользовательского поведения и производительности приложения. Следуйте этим рекомендациям для эффективного использования аналитики и получения ценных insights о вашем приложении.

Для дополнительной информации обратитесь к:
- [Firebase Analytics Documentation](https://firebase.google.com/docs/analytics)
- [Flutter Firebase Documentation](https://firebase.flutter.dev/docs/analytics/overview/)
- Внутренней документации проекта
