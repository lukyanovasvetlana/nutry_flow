# Фича Profile - Профиль пользователя

## 📋 Обзор

Фича Profile предоставляет комплексное управление профилем пользователя в приложении Nutry Flow, включая персональные данные, физические параметры, цели, предпочтения и настройки уведомлений.

## 🏗️ Архитектура

### Структура фичи

```
lib/features/profile/
├── domain/           # Бизнес-логика
│   ├── entities/     # Сущности (UserProfile, Goal, Achievement, ProgressEntry)
│   ├── usecases/     # Сценарии использования
│   └── repositories/ # Интерфейсы репозиториев
├── data/             # Реализация данных
│   ├── services/     # Сервисы (ProfileService, ImageProcessingService, AvatarPickerService)
│   ├── models/       # Модели данных
│   ├── repositories/ # Реализации репозиториев
│   └── datasources/  # Источники данных
├── presentation/      # UI слой
│   ├── screens/      # Экраны профиля
│   ├── widgets/      # Переиспользуемые виджеты
│   └── bloc/         # Управление состоянием
└── di/               # Dependency Injection
```

### Основные компоненты

1. **UserProfile Entity** - основная сущность профиля пользователя
2. **ProfileService** - сервис для работы с профилями
3. **ImageProcessingService** - обработка изображений и аватаров
4. **AvatarPickerService** - выбор и управление аватарами
5. **Goal & Achievement** - система целей и достижений
6. **ProgressEntry** - отслеживание прогресса

## 🚀 Использование

### Базовые операции с профилем

#### Получение профиля текущего пользователя

```dart
import 'package:nutry_flow/features/profile/data/services/profile_service.dart';

final profileService = MockProfileService(); // или реальная реализация

try {
  final profile = await profileService.getCurrentUserProfile();
  
  if (profile != null) {
    print('Имя: ${profile.fullName}');
    print('Email: ${profile.email}');
    print('Возраст: ${profile.age}');
    print('BMI: ${profile.bmi?.toStringAsFixed(2)}');
    print('Полнота профиля: ${(profile.profileCompleteness * 100).toStringAsFixed(0)}%');
  }
} catch (e) {
  print('Ошибка получения профиля: $e');
}
```

#### Создание нового профиля

```dart
final newProfile = UserProfileModel(
  id: 'user123',
  firstName: 'Иван',
  lastName: 'Петров',
  email: 'ivan.petrov@example.com',
  phone: '+7 (999) 123-45-67',
  dateOfBirth: DateTime(1990, 5, 15),
  gender: Gender.male,
  height: 180.0,
  weight: 75.0,
  activityLevel: ActivityLevel.moderatelyActive,
  dietaryPreferences: [DietaryPreference.vegetarian],
  fitnessGoals: ['Похудение', 'Набор мышечной массы'],
  targetWeight: 70.0,
  targetCalories: 2000,
);

try {
  final createdProfile = await profileService.createUserProfile(newProfile);
  print('Профиль создан: ${createdProfile.fullName}');
} catch (e) {
  print('Ошибка создания профиля: $e');
}
```

#### Обновление профиля

```dart
try {
  final updatedProfile = await profileService.updateUserProfile(
    existingProfile.copyWith(
      weight: 73.0,
      targetWeight: 70.0,
      fitnessGoals: ['Поддержание веса', 'Улучшение выносливости'],
    ),
  );
  
  print('Профиль обновлен');
  print('Новый вес: ${updatedProfile.weight} кг');
  print('Новые цели: ${updatedProfile.fitnessGoals.join(', ')}');
} catch (e) {
  print('Ошибка обновления профиля: $e');
}
```

### Работа с вычисляемыми свойствами

#### BMI и категории

```dart
final profile = await profileService.getCurrentUserProfile();

if (profile != null && profile.height != null && profile.weight != null) {
  final bmi = profile.bmi;
  final category = profile.bmiCategory;
  
  print('Ваш BMI: ${bmi?.toStringAsFixed(2)}');
  
  switch (category) {
    case BMICategory.underweight:
      print('Категория: Недостаточный вес');
      break;
    case BMICategory.normal:
      print('Категория: Нормальный вес');
      break;
    case BMICategory.overweight:
      print('Категория: Избыточный вес');
      break;
    case BMICategory.obese:
      print('Категория: Ожирение');
      break;
    default:
      print('Категория: Не определена');
  }
}
```

#### Полнота профиля

```dart
final completeness = profile.profileCompleteness;
final percentage = (completeness * 100).toStringAsFixed(0);

print('Полнота профиля: $percentage%');

if (completeness < 0.5) {
  print('Рекомендуем заполнить больше информации для лучших рекомендаций');
} else if (completeness < 0.8) {
  print('Профиль заполнен хорошо, но можно добавить детали');
} else {
  print('Отличный профиль! У нас есть вся необходимая информация');
}
```

### Работа с аватарами

#### Загрузка аватара

```dart
import 'dart:io';

try {
  final imageFile = File('/path/to/avatar.jpg');
  final avatarUrl = await profileService.uploadAvatar('user123', imageFile);
  
  print('Аватар загружен: $avatarUrl');
  
  // Обновляем профиль с новым аватаром
  await profileService.updateUserProfile(
    profile.copyWith(avatarUrl: avatarUrl),
  );
} catch (e) {
  print('Ошибка загрузки аватара: $e');
}
```

#### Удаление аватара

```dart
try {
  await profileService.deleteAvatar('user123');
  
  // Обновляем профиль без аватара
  await profileService.updateUserProfile(
    profile.copyWith(avatarUrl: null),
  );
  
  print('Аватар удален');
} catch (e) {
  print('Ошибка удаления аватара: $e');
}
```

### Проверка доступности email

```dart
try {
  final isAvailable = await profileService.isEmailAvailable('new@example.com');
  
  if (isAvailable) {
    print('Email доступен для использования');
  } else {
    print('Email уже используется');
  }
} catch (e) {
  print('Ошибка проверки email: $e');
}
```

### Экспорт данных профиля

```dart
try {
  final exportedData = await profileService.exportProfileData('user123');
  
  print('Данные экспортированы:');
  print('Дата экспорта: ${exportedData['exportDate']}');
  print('Версия: ${exportedData['version']}');
  
  // Можно сохранить в файл или отправить
  // final jsonString = jsonEncode(exportedData);
} catch (e) {
  print('Ошибка экспорта данных: $e');
}
```

## 🔧 Конфигурация

### Демо-режим

Фича поддерживает демо-режим для разработки и тестирования:

```dart
// В демо-режиме используется MockProfileService
final profileService = MockProfileService();

// Автоматически создается демо-профиль:
// - Имя: Анна Иванова
// - Email: anna.ivanova@example.com
// - Пол: Женский
// - Рост: 165 см
// - Вес: 62 кг
// - Уровень активности: Умеренно активный
// - Диетические предпочтения: Вегетарианство
// - Цели: Поддержание веса, Улучшение выносливости
```

### Supabase интеграция

Для продакшн использования настройте Supabase:

1. Создайте таблицы для профилей в Supabase
2. Настройте RLS (Row Level Security)
3. Создайте реальную реализацию ProfileService
4. Обновите dependency injection

## 🧪 Тестирование

### Unit тесты

```bash
# Запуск тестов для UserProfile entity
flutter test test/features/profile/domain/entities/user_profile_test.dart

# Запуск тестов для ProfileService
flutter test test/features/profile/data/services/profile_service_test.dart

# Запуск всех тестов фичи Profile
flutter test test/features/profile/
```

### Тестовые сценарии

- ✅ Создание профиля с валидными данными
- ✅ Обновление существующего профиля
- ✅ Удаление профиля
- ✅ Проверка email доступности
- ✅ Вычисление BMI и категорий
- ✅ Расчет полноты профиля
- ✅ Обработка edge cases
- ✅ Производительность и консистентность данных

## 📚 API Reference

### UserProfile Entity

```dart
class UserProfile {
  // Обязательные поля
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  
  // Опциональные поля
  final String? phone;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final double? height;
  final double? weight;
  final ActivityLevel? activityLevel;
  final String? avatarUrl;
  
  // Списки
  final List<DietaryPreference> dietaryPreferences;
  final List<String> allergies;
  final List<String> healthConditions;
  final List<String> fitnessGoals;
  
  // Цели
  final double? targetWeight;
  final int? targetCalories;
  final double? targetProtein;
  final double? targetCarbs;
  final double? targetFat;
  
  // Настройки
  final String? foodRestrictions;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  
  // Метаданные
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Вычисляемые свойства
  String get fullName;
  String get initials;
  int? get age;
  double? get bmi;
  BMICategory? get bmiCategory;
  double get profileCompleteness;
}
```

### ProfileService

```dart
abstract class ProfileService {
  // Основные операции
  Future<UserProfileModel?> getCurrentUserProfile();
  Future<UserProfileModel?> getUserProfile(String userId);
  Future<UserProfileModel> createUserProfile(UserProfileModel profile);
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile(String userId);
  
  // Аватары
  Future<String> uploadAvatar(String userId, File imageFile);
  Future<void> deleteAvatar(String userId);
  
  // Валидация
  Future<bool> isEmailAvailable(String email, {String? excludeUserId});
  
  // Аналитика
  Future<Map<String, dynamic>> getProfileStatistics(String userId);
  Future<Map<String, dynamic>> exportProfileData(String userId);
}
```

### Enums

```dart
enum Gender { male, female, other, preferNotToSay }
enum ActivityLevel { sedentary, lightlyActive, moderatelyActive, veryActive, extremelyActive }
enum BMICategory { underweight, normal, overweight, obese }
enum DietaryPreference { vegetarian, vegan, pescatarian, omnivore, keto, paleo }
```

## 🚨 Обработка ошибок

### ProfileServiceException

```dart
class ProfileServiceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
}

// Пример обработки
try {
  await profileService.createUserProfile(profile);
} on ProfileServiceException catch (e) {
  switch (e.code) {
    case 'EMAIL_EXISTS':
      showError('Email уже используется');
      break;
    case 'VALIDATION_ERROR':
      showError('Ошибка валидации: ${e.message}');
      break;
    case 'NETWORK_ERROR':
      showError('Проблемы с подключением');
      break;
    default:
      showError('Ошибка: ${e.message}');
  }
} catch (e) {
  showError('Неизвестная ошибка: $e');
}
```

## 🔒 Безопасность и приватность

### Рекомендации

1. **Валидация данных** - проверка всех входных данных
2. **RLS в Supabase** - ограничение доступа к данным
3. **Шифрование** - защита персональных данных
4. **GDPR compliance** - право на удаление данных
5. **Аудит** - логирование изменений профиля

### Персональные данные

- Не логируем пароли и персональную информацию
- Предоставляем возможность экспорта данных
- Поддерживаем анонимизацию для аналитики
- Соблюдаем принцип минимальной достаточности

## 📈 Мониторинг и аналитика

### Метрики для отслеживания

- Количество созданных профилей
- Полнота заполнения профилей
- Популярные диетические предпочтения
- Распределение по уровням активности
- Конверсия от регистрации до заполнения профиля

### Логирование

```dart
// Включение детального логирования
developer.log('📱 ProfileService: Creating profile for ${profile.email}', name: 'ProfileService');
```

## 🚀 Планы развития

### Краткосрочные (1-2 месяца)

- [ ] Добавить валидацию email и телефона
- [ ] Реализовать кэширование профилей
- [ ] Добавить поддержку нескольких языков
- [ ] Интеграция с камерой для аватаров

### Среднесрочные (3-6 месяцев)

- [ ] Система достижений и бейджей
- [ ] Социальные функции (друзья, группы)
- [ ] Аналитика прогресса
- [ ] Интеграция с фитнес-трекерами

### Долгосрочные (6+ месяцев)

- [ ] AI-рекомендации на основе профиля
- [ ] Интеграция с медицинскими системами
- [ ] Multi-tenant архитектура
- [ ] Advanced privacy controls

## 🤝 Вклад в разработку

### Code Review чеклист

- [ ] Документация для всех публичных методов
- [ ] Unit тесты с покрытием >80%
- [ ] Обработка ошибок и edge cases
- [ ] Валидация входных данных
- [ ] Performance оптимизация

### Стандарты кода

- Используйте `///` для документации
- Следуйте naming conventions
- Обрабатывайте все возможные ошибки
- Пишите тесты для новых фич
- Используйте computed properties для вычисляемых значений

## 📞 Поддержка

### Полезные ссылки

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

### Команда

- **Product Owner**: [Имя]
- **Tech Lead**: [Имя]
- **QA Engineer**: [Имя]

---

*Последнее обновление: ${new Date().toLocaleDateString()}*
