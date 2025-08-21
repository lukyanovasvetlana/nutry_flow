# Руководство по архитектуре NutryFlow

## Обзор

NutryFlow использует модульную архитектуру с четким разделением ответственности и централизованным управлением зависимостями. Архитектура построена на принципах Clean Architecture и SOLID.

## Основные компоненты

### 1. AppArchitecture

Главный архитектурный класс, который управляет всем приложением.

**Основные функции:**
- Инициализация всех компонентов
- Управление жизненным циклом приложения
- Регистрация сервисов в GetIt
- Создание главного виджета приложения

**Использование:**
```dart
// Инициализация
await AppArchitecture().initialize();

// Создание приложения
runApp(AppArchitecture().createApp());
```

### 2. AppInitializer

Отвечает за инициализацию всех зависимостей фич в правильном порядке.

**Порядок инициализации:**
1. Onboarding (базовая фича)
2. Auth (аутентификация)
3. Profile (профиль пользователя)
4. Nutrition (питание)
5. Menu (меню)
6. MealPlan (план питания)
7. GroceryList (список покупок)
8. Calendar (календарь)
9. Exercise (упражнения)
10. Analytics (аналитика)

**Использование:**
```dart
final initializer = AppArchitecture().initializer;

// Проверка статуса фичи
if (initializer.isFeatureInitialized('Onboarding')) {
  // Фича готова к использованию
}

// Получение статуса всех фич
final status = initializer.getFeaturesStatus();
```

### 3. AppRouter

Управляет навигацией и роутингом в приложении с использованием GoRouter.

**Основные возможности:**
- Автоматические редиректы на основе аутентификации
- Обработка ошибок навигации
- Централизованное управление маршрутами

**Маршруты:**
- `/` - Splash Screen
- `/welcome` - Приветственный экран
- `/registration` - Регистрация
- `/login` - Вход
- `/profile-info` - Информация профиля
- `/goals-setup` - Настройка целей
- `/dashboard` - Главная панель
- `/analytics` - Аналитика
- И другие...

**Использование:**
```dart
final router = AppArchitecture().router;

// Навигация
router.navigateTo('/dashboard');

// Замена маршрута
router.replaceRoute('/profile-settings');

// Возврат назад
router.goBack();
```

### 4. AppState

Управляет глобальным состоянием приложения и BLoC провайдерами.

**Основные возможности:**
- Глобальные BLoC провайдеры
- Ключ-значение хранилище
- Экспорт/импорт состояния
- Статистика состояния

**Использование:**
```dart
final state = AppArchitecture().state;

// Установка значения
state.setValue('user_id', '12345');

// Получение значения
final userId = state.getValue<String>('user_id');

// Обновление значения
state.updateValue('counter', (current) => current + 1);

// Проверка существования ключа
if (state.hasKey('user_preferences')) {
  // Ключ существует
}
```

## Структура файлов

```
lib/core/architecture/
├── app_architecture.dart      # Главный архитектурный класс
├── app_initializer.dart       # Инициализатор зависимостей
├── app_router.dart           # Роутер приложения
├── app_state.dart            # Управление состоянием
└── architecture.dart         # Экспорт всех компонентов
```

## Жизненный цикл приложения

### 1. Инициализация
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await AppArchitecture().initialize();
    runApp(AppArchitecture().createApp());
  } catch (e) {
    runApp(const _ErrorApp());
  }
}
```

### 2. Создание приложения
```dart
Widget createApp() {
  return MultiBlocProvider(
    providers: _state.globalBlocProviders,
    child: _router.createApp(),
  );
}
```

### 3. Очистка ресурсов
```dart
// При завершении работы приложения
await AppArchitecture().dispose();
```

## Преимущества новой архитектуры

### 1. Централизованное управление
- Все компоненты управляются из одного места
- Единая точка входа для инициализации
- Консистентное поведение во всем приложении

### 2. Модульность
- Каждая фича инициализируется независимо
- Легко добавлять/убирать фичи
- Четкое разделение ответственности

### 3. Надежность
- Обработка ошибок на всех уровнях
- Fallback приложения при ошибках
- Логирование всех операций

### 4. Масштабируемость
- Легко добавлять новые фичи
- Гибкая система зависимостей
- Поддержка hot reload

### 5. Тестируемость
- Каждый компонент можно тестировать отдельно
- Mock объекты для зависимостей
- Изолированное тестирование

## Миграция с старой архитектуры

### Что изменилось:
1. **main.dart** - теперь использует AppArchitecture
2. **Роутинг** - перешел с обычных routes на GoRouter
3. **Инициализация** - централизована в AppInitializer
4. **Состояние** - управляется через AppState

### Что осталось:
1. **BLoC паттерн** - продолжает использоваться
2. **Dependency Injection** - GetIt остается
3. **Feature структура** - не изменилась
4. **Сервисы** - остались на своих местах

## Рекомендации по использованию

### 1. Добавление новых фич
```dart
// В AppInitializer._initializeFeatureDependencies()
await _initializeFeature('NewFeature', () async {
  await NewFeatureDependencies.instance.initialize();
});
```

### 2. Добавление новых маршрутов
```dart
// В AppRouter._buildRoutes()
GoRoute(
  path: '/new-route',
  name: 'new-route',
  builder: (context, state) => const NewScreen(),
),
```

### 3. Добавление глобальных BLoC провайдеров
```dart
// В AppState._initializeGlobalProviders()
_globalProviders.add(
  BlocProvider<NewBloc>(
    create: (context) => NewBloc(),
  ),
);
```

### 4. Обработка ошибок
```dart
try {
  await AppArchitecture().initialize();
} catch (e) {
  // Логирование ошибки
  print('Initialization failed: $e');
  
  // Fallback
  runApp(const _ErrorApp());
}
```

## Отладка и мониторинг

### Логирование
Архитектура предоставляет детальное логирование всех операций:
- 🏗️ - Архитектурные операции
- 🚀 - Инициализация
- 📊 - Состояние
- 🗺️ - Роутинг
- ✅ - Успешные операции
- ❌ - Ошибки
- ⚠️ - Предупреждения
- 🔄 - Повторные операции
- 🧹 - Очистка

### Статистика
```dart
// Статистика состояния
final stats = AppArchitecture().state.getStateStatistics();

// Статус фич
final featuresStatus = AppArchitecture().initializer.getFeaturesStatus();
```

## Заключение

Новая архитектура NutryFlow обеспечивает:
- **Надежность** - обработка ошибок на всех уровнях
- **Масштабируемость** - легко добавлять новые фичи
- **Поддерживаемость** - четкая структура и документация
- **Тестируемость** - изолированные компоненты
- **Производительность** - оптимизированная инициализация

Архитектура готова к использованию в продакшене и может быть легко расширена для новых требований.
