# 🏃‍♂️ Activity Feature

## 📋 Обзор

Модуль Activity отвечает за отслеживание физической активности пользователей, включая тренировки, упражнения и статистику активности.

## 🏗️ Архитектура

### Domain Layer
- **Entities**: `ActivitySession`, `ActivityStats`, `Exercise`, `Workout`
- **Repositories**: `ActivityRepository`, `ExerciseRepository`, `WorkoutRepository`
- **Use Cases**: `ActivityUsecases`, `ExerciseUsecases`, `WorkoutUsecases`

### Data Layer
- **Models**: `ActivitySessionModel`, `ActivityStatsModel`, `ExerciseModel`, `WorkoutModel`
- **Services**: `ActivityTrackingService`, `SupabaseExerciseService`, `SupabaseWorkoutService`
- **Repositories**: `ActivityRepositoryImpl`, `ExerciseRepositoryImpl`, `WorkoutRepositoryImpl`

### Presentation Layer
- **Screens**: `ActivityMainScreen`, `ActivityStatsScreen`, `ExerciseCatalogScreen`, `WorkoutCreationScreen`, `WorkoutSessionScreen`
- **Widgets**: `ActivityChart`, `ExerciseCard`, `StatsCard`, `WorkoutCard`, `WorkoutTimer`
- **Bloc**: `ActivityBloc`, `ExerciseBloc`, `WorkoutBloc`

## 🚀 Основные функции

### 1. Отслеживание активности
- Создание и управление сессиями активности
- Отслеживание времени тренировок
- Расчет статистики активности

### 2. Каталог упражнений
- Просмотр доступных упражнений
- Поиск по категориям и названиям
- Детальная информация об упражнениях

### 3. Управление тренировками
- Создание персональных тренировок
- Планирование тренировочных программ
- Отслеживание прогресса

### 4. Статистика и аналитика
- Графики активности
- Анализ прогресса
- Экспорт данных

## 📱 Экраны

### ActivityMainScreen
Главный экран активности с обзором статистики и быстрым доступом к функциям.

### ActivityStatsScreen
Детальная статистика активности с графиками и аналитикой.

### ExerciseCatalogScreen
Каталог упражнений с поиском и фильтрацией.

### WorkoutCreationScreen
Создание и редактирование тренировок.

### WorkoutSessionScreen
Экран активной тренировки с таймером и отслеживанием.

## 🧪 Тестирование

### Unit Tests
```bash
flutter test test/features/activity/data/services/activity_tracking_service_test.dart
```

### Widget Tests
```bash
flutter test test/features/activity/presentation/screens/activity_main_screen_test.dart
```

### Integration Tests
```bash
flutter test integration_test/activity_integration_test.dart
```

## 🔧 Использование

### Создание сессии активности
```dart
final activityService = ActivityTrackingService();
final session = await activityService.startSession('running', userId);
```

### Получение статистики
```dart
final stats = await activityService.getActivityStats(userId);
print('Total sessions: ${stats.totalSessions}');
```

### Создание тренировки
```dart
final workout = Workout(
  name: 'Утренняя пробежка',
  exercises: [exercise1, exercise2],
  duration: Duration(minutes: 30),
);
```

## ⚠️ Обработка ошибок

- **Нет подключения к интернету**: Кэширование данных локально
- **Ошибки сервера**: Retry механизм с экспоненциальной задержкой
- **Неверные данные**: Валидация на уровне модели

## 🚀 Планы развития

- [ ] Интеграция с фитнес-трекерами
- [ ] Социальные функции (соревнования)
- [ ] ИИ-рекомендации тренировок
- [ ] Видео-инструкции упражнений
- [ ] Групповые тренировки

## 🔗 Связанные фичи

- **Profile**: Управление профилем пользователя
- **Analytics**: Аналитика и отчеты
- **Notifications**: Напоминания о тренировках
- **Calendar**: Планирование тренировок

---

**Версия**: 1.0.0  
**Последнее обновление**: $(date)  
**Статус**: ✅ Готово к использованию
