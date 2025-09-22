# 👤 Profile Feature

## Обзор

Profile - это система управления профилем пользователя в приложении NutryFlow, включающая настройки, цели, предпочтения и отслеживание прогресса.

## Архитектура

### Структура папок
```
lib/features/profile/
├── data/
│   ├── models/
│   │   └── user_profile.dart            # Модель профиля пользователя
│   ├── repositories/
│   │   └── profile_repository_impl.dart # Реализация репозитория
│   └── services/
│       └── profile_service.dart         # Сервис профиля
├── domain/
│   ├── entities/
│   │   └── user_profile_entity.dart     # Сущность профиля
│   ├── repositories/
│   │   └── profile_repository.dart      # Интерфейс репозитория
│   └── usecases/
│       ├── get_profile_usecase.dart     # Получение профиля
│       ├── update_profile_usecase.dart  # Обновление профиля
│       └── track_progress_usecase.dart  # Отслеживание прогресса
├── presentation/
│   ├── screens/
│   │   └── profile_screen.dart          # Экран профиля
│   └── widgets/
│       └── profile_form_widget.dart     # Форма профиля
└── di/
    └── profile_dependencies.dart        # Dependency Injection
```

## Основные компоненты

### 1. UserProfile Entity
Модель профиля пользователя с полями:
- `id` - уникальный идентификатор
- `firstName` - имя
- `lastName` - фамилия
- `email` - email адрес
- `dateOfBirth` - дата рождения
- `gender` - пол
- `height` - рост
- `weight` - вес
- `activityLevel` - уровень активности
- `fitnessGoals` - фитнес цели
- `dietaryPreferences` - диетические предпочтения
- `allergies` - аллергии
- `healthConditions` - состояния здоровья

### 2. ProfileService
Сервис для работы с профилем:
- Получение профиля пользователя
- Обновление профиля
- Отслеживание прогресса
- Валидация данных

### 3. Goals Management
Система управления целями:
- Установка целей по весу
- Цели по калориям
- Цели по макронутриентам
- Отслеживание прогресса

## Использование

### Получение профиля
```dart
final profileService = ProfileService();
try {
  final profile = await profileService.getCurrentUserProfile();
  // Использование профиля
} catch (e) {
  // Обработка ошибки
}
```

### Обновление профиля
```dart
try {
  await profileService.updateProfile(
    UserProfile(
      id: 'user-id',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      height: 180,
      weight: 75,
      activityLevel: ActivityLevel.moderate,
    ),
  );
} catch (e) {
  // Обработка ошибки
}
```

### Отслеживание прогресса
```dart
await profileService.trackProgress(
  weight: 74.5,
  bodyFat: 15.2,
  muscleMass: 60.0,
);
```

## Валидация данных

### Валидация роста
```dart
bool isValidHeight(double height) {
  return height >= 100 && height <= 250; // см
}
```

### Валидация веса
```dart
bool isValidWeight(double weight) {
  return weight >= 30 && weight <= 300; // кг
}
```

### Валидация возраста
```dart
bool isValidAge(DateTime dateOfBirth) {
  final age = DateTime.now().difference(dateOfBirth).inDays / 365;
  return age >= 13 && age <= 120;
}
```

## Цели и прогресс

### Типы целей
- **Weight Goal** - цель по весу
- **Calorie Goal** - цель по калориям
- **Protein Goal** - цель по белкам
- **Exercise Goal** - цель по упражнениям

### Отслеживание прогресса
```dart
final progress = await profileService.getProgress(
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
);
```

## Настройки

### Уведомления
```dart
await profileService.updateNotificationSettings(
  pushNotifications: true,
  emailNotifications: false,
  reminderTime: TimeOfDay(hour: 9, minute: 0),
);
```

### Предпочтения
```dart
await profileService.updatePreferences(
  dietaryPreferences: [DietaryPreference.vegetarian],
  allergies: [Allergy.nuts, Allergy.dairy],
  healthConditions: [HealthCondition.diabetes],
);
```

## Тестирование

### Unit тесты
```bash
flutter test test/features/profile/
```

### Покрытие тестами
- ✅ ProfileService - 2 теста
- ❌ Widgets - требуются тесты
- ❌ Use cases - требуются тесты

### Тестовые данные
```dart
const testProfile = UserProfile(
  id: 'test-id',
  firstName: 'Test',
  lastName: 'User',
  email: 'test@example.com',
  height: 175,
  weight: 70,
  activityLevel: ActivityLevel.moderate,
  fitnessGoals: [FitnessGoal.weightLoss],
);
```

## Обработка ошибок

### Типы ошибок
- `ProfileNotFoundException` - профиль не найден
- `ValidationException` - ошибка валидации
- `NetworkException` - ошибка сети
- `PermissionException` - нет прав доступа

### Пример обработки
```dart
try {
  await profileService.updateProfile(profile);
} on ValidationException catch (e) {
  showError('Ошибка валидации: ${e.message}');
} on NetworkException {
  showError('Ошибка сети. Проверьте подключение');
} catch (e) {
  showError('Произошла неизвестная ошибка');
}
```

## Локальное хранение

### SharedPreferences
```dart
// Сохранение профиля
await prefs.setString('user_profile', jsonEncode(profile.toJson()));

// Загрузка профиля
final profileJson = prefs.getString('user_profile');
if (profileJson != null) {
  final profile = UserProfile.fromJson(jsonDecode(profileJson));
}
```

### Кэширование
- Профиль кэшируется локально
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
3. **Image upload** - нет загрузки аватаров

## Планы развития

- [ ] Добавить загрузку аватаров
- [ ] Реализовать синхронизацию данных
- [ ] Улучшить offline support
- [ ] Добавить экспорт данных
- [ ] Реализовать backup/restore

## Связанные фичи

- **Auth** - аутентификация пользователя
- **Dashboard** - отображение данных профиля
- **Analytics** - аналитика прогресса
- **Nutrition** - отслеживание питания
