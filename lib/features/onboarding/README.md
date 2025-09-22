# 🚀 Onboarding Feature

## Обзор

Onboarding - это система первичной настройки приложения NutryFlow, которая помогает новым пользователям познакомиться с функционалом и настроить свои цели.

## Архитектура

### Структура папок
```
lib/features/onboarding/
├── data/
│   ├── models/
│   │   └── onboarding_data.dart        # Модель данных онбординга
│   ├── repositories/
│   │   └── onboarding_repository_impl.dart # Реализация репозитория
│   └── services/
│       ├── onboarding_service.dart     # Сервис онбординга
│       └── local_storage_service.dart  # Локальное хранение
├── domain/
│   ├── entities/
│   │   └── onboarding_entity.dart      # Сущность онбординга
│   ├── repositories/
│   │   └── onboarding_repository.dart  # Интерфейс репозитория
│   └── usecases/
│       ├── save_onboarding_data_usecase.dart # Сохранение данных
│       └── get_onboarding_data_usecase.dart  # Получение данных
├── presentation/
│   ├── screens/
│   │   ├── welcome_screen.dart         # Экран приветствия
│   │   ├── profile_info_screen.dart    # Информация о профиле
│   │   └── goals_setup_screen.dart     # Настройка целей
│   └── widgets/
│       └── onboarding_progress.dart    # Прогресс онбординга
└── di/
    └── onboarding_dependencies.dart    # Dependency Injection
```

## Основные компоненты

### 1. OnboardingData Entity
Модель данных онбординга с полями:
- `userId` - идентификатор пользователя
- `step` - текущий шаг
- `profileData` - данные профиля
- `goalsData` - данные целей
- `preferencesData` - предпочтения
- `isCompleted` - завершен ли онбординг

### 2. OnboardingService
Сервис для управления онбордингом:
- Сохранение прогресса
- Получение текущего шага
- Завершение онбординга
- Сброс прогресса

### 3. LocalStorageService
Сервис локального хранения:
- Сохранение данных пользователя
- Загрузка сохраненных данных
- Очистка данных

## Использование

### Инициализация онбординга
```dart
final onboardingService = OnboardingService();
await onboardingService.initialize();
```

### Сохранение прогресса
```dart
try {
  await onboardingService.saveProgress(
    step: OnboardingStep.profileInfo,
    data: profileData,
  );
} catch (e) {
  // Обработка ошибки
}
```

### Завершение онбординга
```dart
try {
  await onboardingService.completeOnboarding();
  // Переход к главному экрану
} catch (e) {
  // Обработка ошибки
}
```

## Экраны онбординга

### 1. Welcome Screen
- Приветствие пользователя
- Обзор функций приложения
- Кнопка "Начать"

### 2. Profile Info Screen
- Сбор базовой информации
- Имя, возраст, пол
- Рост и вес
- Уровень активности

### 3. Goals Setup Screen
- Выбор целей
- Целевой вес
- Предпочтения в питании
- Аллергии и ограничения

## Навигация

### Маршруты
- `/welcome` - экран приветствия
- `/profile-info` - информация о профиле
- `/goals-setup` - настройка целей

### Пример навигации
```dart
// Переход к следующему шагу
Navigator.pushNamed(context, '/profile-info');

// Завершение онбординга
Navigator.pushReplacementNamed(context, '/dashboard');
```

## Валидация

### Валидация профиля
```dart
bool isValidProfile(ProfileData profile) {
  return profile.firstName.isNotEmpty &&
         profile.age > 0 &&
         profile.height > 0 &&
         profile.weight > 0;
}
```

### Валидация целей
```dart
bool isValidGoals(GoalsData goals) {
  return goals.targetWeight > 0 &&
         goals.activityLevel != null &&
         goals.dietaryPreferences.isNotEmpty;
}
```

## Тестирование

### Unit тесты
```bash
flutter test test/features/onboarding/
```

### Покрытие тестами
- ❌ OnboardingService - требуются тесты
- ❌ Widgets - требуются тесты
- ❌ Use cases - требуются тесты

### Тестовые данные
```dart
const testOnboardingData = OnboardingData(
  userId: 'test-user-id',
  step: OnboardingStep.profileInfo,
  profileData: testProfileData,
  goalsData: testGoalsData,
  isCompleted: false,
);
```

## Обработка ошибок

### Типы ошибок
- `OnboardingDataNotFoundException` - данные не найдены
- `ValidationException` - ошибка валидации
- `StorageException` - ошибка хранения
- `NetworkException` - ошибка сети

### Пример обработки
```dart
try {
  await onboardingService.saveProgress(data);
} on ValidationException catch (e) {
  showError('Ошибка валидации: ${e.message}');
} on StorageException {
  showError('Ошибка сохранения данных');
} catch (e) {
  showError('Произошла неизвестная ошибка');
}
```

## Локальное хранение

### SharedPreferences
```dart
// Сохранение данных онбординга
await prefs.setString('onboarding_data', jsonEncode(data.toJson()));

// Загрузка данных
final dataJson = prefs.getString('onboarding_data');
if (dataJson != null) {
  final data = OnboardingData.fromJson(jsonDecode(dataJson));
}
```

### Кэширование
- Данные кэшируются локально
- Автоматическое сохранение прогресса
- Восстановление при перезапуске

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

1. **Data persistence** - нет автоматического сохранения
2. **Offline support** - ограниченная поддержка офлайн
3. **Progress tracking** - нет детального отслеживания

## Планы развития

- [ ] Добавить анимации переходов
- [ ] Реализовать skip функциональность
- [ ] Улучшить offline support
- [ ] Добавить персонализацию
- [ ] Реализовать A/B тестирование

## Связанные фичи

- **Auth** - аутентификация пользователя
- **Profile** - профиль пользователя
- **Dashboard** - главный экран после завершения
