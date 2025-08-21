# Архитектурный слой NutryFlow

Этот слой содержит основные архитектурные компоненты приложения, обеспечивающие централизованное управление, инициализацию и жизненный цикл.

## Быстрый старт

```dart
import 'package:nutry_flow/core/architecture/architecture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Инициализация архитектуры
    await AppArchitecture().initialize();
    
    // Запуск приложения
    runApp(AppArchitecture().createApp());
  } catch (e) {
    // Fallback при ошибке
    runApp(const _ErrorApp());
  }
}
```

## Компоненты

### AppArchitecture
Главный класс, управляющий всем приложением.

```dart
final architecture = AppArchitecture();

// Доступ к компонентам
final initializer = architecture.initializer;
final router = architecture.router;
final state = architecture.state;
final serviceLocator = architecture.serviceLocator;

// Проверка готовности
if (architecture.isInitialized) {
  // Архитектура готова
}
```

### AppInitializer
Управляет инициализацией зависимостей фич.

```dart
final initializer = AppArchitecture().initializer;

// Проверка статуса фичи
if (initializer.isFeatureInitialized('Onboarding')) {
  // Фича готова
}

// Статус всех фич
final status = initializer.getFeaturesStatus();
```

### AppRouter
Управляет навигацией и роутингом.

```dart
final router = AppArchitecture().router;

// Навигация
router.navigateTo('/dashboard');
router.replaceRoute('/profile');
router.goBack();
```

### AppState
Управляет глобальным состоянием и BLoC провайдерами.

```dart
final state = AppArchitecture().state;

// Работа с состоянием
state.setValue('user_id', '12345');
final userId = state.getValue<String>('user_id');
state.updateValue('counter', (current) => current + 1);

// Статистика
final stats = state.getStateStatistics();
```

## Структура файлов

```
lib/core/architecture/
├── app_architecture.dart      # Главный архитектурный класс
├── app_initializer.dart       # Инициализатор зависимостей
├── app_router.dart           # Роутер приложения
├── app_state.dart            # Управление состоянием
├── architecture.dart         # Экспорт всех компонентов
└── README.md                # Этот файл
```

## Тестирование

Запуск тестов архитектуры:

```bash
flutter test test/architecture/
```

## Документация

Подробная документация доступна в [docs/architecture/app-architecture-guide.md](../../docs/architecture/app-architecture-guide.md).

## Логирование

Архитектура использует эмодзи для удобного логирования:

- 🏗️ - Архитектурные операции
- 🚀 - Инициализация
- 📊 - Состояние
- 🗺️ - Роутинг
- ✅ - Успешные операции
- ❌ - Ошибки
- ⚠️ - Предупреждения
- 🔄 - Повторные операции
- 🧹 - Очистка

## Поддержка

При возникновении проблем с архитектурой:

1. Проверьте логи инициализации
2. Убедитесь, что все зависимости доступны
3. Проверьте статус фич через `AppInitializer`
4. Изучите статистику состояния через `AppState`
