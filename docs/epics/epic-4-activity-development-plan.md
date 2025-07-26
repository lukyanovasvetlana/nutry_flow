# Epic 4: Activity - План разработки

## 🎯 Обзор

**Epic 4: Activity** - это модуль для управления физической активностью, включающий:
- Каталог упражнений с фильтрацией и поиском
- Создание и управление тренировками
- Отслеживание выполнения тренировок
- Статистика и аналитика активности

## 📊 Текущий статус

**Прогресс**: 25%  
**Дата начала**: 19 декабря 2024  
**Ожидаемое завершение**: 15 января 2025

### ✅ Завершено
- [x] Domain Layer архитектура
  - [x] Entity: Exercise (с enum'ами)
  - [x] Entity: Workout (с WorkoutExercise)
  - [x] Entity: ActivitySession (с ExerciseResult, SetResult)
  - [x] Repository интерфейсы
  - [x] Базовые Use Cases
- [x] База данных схема (миграция)
- [x] Базовые экраны упражнений (из старого кода)

### 🔄 В процессе
- [ ] Data Layer реализация
- [ ] Presentation Layer (BLoC/Cubit)
- [ ] UI компоненты

### ⏳ Планируется
- [ ] Интеграция с Supabase
- [ ] Тестирование
- [ ] UI/UX полировка

## 🏗️ Архитектура

### Domain Layer
```
lib/features/activity/domain/
├── entities/
│   ├── exercise.dart          ✅
│   ├── workout.dart           ✅
│   └── activity_session.dart  ✅
├── repositories/
│   ├── exercise_repository.dart       ✅
│   ├── workout_repository.dart        ✅
│   └── activity_session_repository.dart ✅
└── usecases/
    ├── get_all_exercises_usecase.dart ✅
    ├── search_exercises_usecase.dart  ✅
    └── get_user_workouts_usecase.dart ✅
```

### Data Layer (планируется)
```
lib/features/activity/data/
├── models/
│   ├── exercise_model.dart
│   ├── workout_model.dart
│   └── activity_session_model.dart
├── repositories/
│   ├── exercise_repository_impl.dart
│   ├── workout_repository_impl.dart
│   └── activity_session_repository_impl.dart
└── services/
    ├── exercise_service.dart
    ├── workout_service.dart
    └── activity_session_service.dart
```

### Presentation Layer (планируется)
```
lib/features/activity/presentation/
├── blocs/
│   ├── exercise_bloc.dart
│   ├── workout_bloc.dart
│   └── activity_session_bloc.dart
├── screens/
│   ├── exercise_catalog_screen.dart
│   ├── exercise_detail_screen.dart
│   ├── workout_list_screen.dart
│   ├── workout_create_screen.dart
│   ├── workout_detail_screen.dart
│   ├── workout_session_screen.dart
│   └── activity_stats_screen.dart
└── widgets/
    ├── exercise_card.dart
    ├── workout_card.dart
    ├── exercise_filter.dart
    └── workout_timer.dart
```

## 📋 Детальный план задач

### Этап 1: Data Layer (3-4 дня)

#### Задача 1.1: Модели данных
- [ ] **ExerciseModel** - маппинг между domain и data
- [ ] **WorkoutModel** - маппинг тренировок
- [ ] **ActivitySessionModel** - маппинг сессий
- [ ] **Mock данные** - демо-данные для разработки

#### Задача 1.2: Сервисы
- [ ] **ExerciseService** - работа с упражнениями
- [ ] **WorkoutService** - работа с тренировками
- [ ] **ActivitySessionService** - работа с сессиями
- [ ] **Supabase интеграция** - реальные API

#### Задача 1.3: Репозитории
- [ ] **ExerciseRepositoryImpl** - реализация репозитория
- [ ] **WorkoutRepositoryImpl** - реализация репозитория
- [ ] **ActivitySessionRepositoryImpl** - реализация репозитория

### Этап 2: Presentation Layer (4-5 дней)

#### Задача 2.1: BLoC/Cubit
- [ ] **ExerciseBloc** - управление состоянием упражнений
- [ ] **WorkoutBloc** - управление состоянием тренировок
- [ ] **ActivitySessionBloc** - управление состоянием сессий

#### Задача 2.2: Экраны
- [ ] **ExerciseCatalogScreen** - каталог упражнений
- [ ] **ExerciseDetailScreen** - детали упражнения
- [ ] **WorkoutListScreen** - список тренировок
- [ ] **WorkoutCreateScreen** - создание тренировки
- [ ] **WorkoutDetailScreen** - детали тренировки
- [ ] **WorkoutSessionScreen** - выполнение тренировки

#### Задача 2.3: Виджеты
- [ ] **ExerciseCard** - карточка упражнения
- [ ] **WorkoutCard** - карточка тренировки
- [ ] **ExerciseFilter** - фильтры упражнений
- [ ] **WorkoutTimer** - таймер тренировки

### Этап 3: Интеграция и тестирование (2-3 дня)

#### Задача 3.1: Интеграция
- [ ] **Dependency Injection** - настройка зависимостей
- [ ] **Навигация** - интеграция с основным приложением
- [ ] **Supabase** - подключение к реальной БД

#### Задача 3.2: Тестирование
- [ ] **Unit тесты** - тесты use cases и репозиториев
- [ ] **Widget тесты** - тесты UI компонентов
- [ ] **Integration тесты** - тесты полного flow

### Этап 4: UI/UX полировка (2-3 дня)

#### Задача 4.1: Дизайн
- [ ] **Консистентность** - соответствие дизайн-системе
- [ ] **Анимации** - плавные переходы и микроанимации
- [ ] **Responsive** - адаптивность для разных экранов

#### Задача 4.2: UX
- [ ] **Accessibility** - поддержка screen readers
- [ ] **Performance** - оптимизация производительности
- [ ] **Offline** - работа без интернета

## 🗓️ Временные рамки

### Неделя 1 (23-29 декабря)
- **Data Layer**: Модели и сервисы
- **Mock данные**: Демо-данные для разработки

### Неделя 2 (30 декабря - 5 января)
- **Data Layer**: Репозитории и DI
- **Presentation Layer**: BLoC/Cubit

### Неделя 3 (6-12 января)
- **Presentation Layer**: Экраны и виджеты
- **Интеграция**: Навигация и Supabase

### Неделя 4 (13-19 января)
- **Тестирование**: Unit, Widget, Integration тесты
- **UI/UX полировка**: Дизайн и производительность

## 🎯 Критерии успеха

### MVP (Минимально жизнеспособный продукт)
- [ ] Каталог из 50+ упражнений с фильтрацией
- [ ] Создание и редактирование тренировок
- [ ] Выполнение тренировок с таймером
- [ ] Базовая статистика активности
- [ ] Интеграция с профилем пользователя

### Полная версия
- [ ] 100+ упражнений с видео и инструкциями
- [ ] Шаблоны тренировок
- [ ] Детальная аналитика и прогресс
- [ ] Социальные функции (делиться результатами)
- [ ] Интеграция с фитнес-трекерами

## 🛠️ Технические требования

### Новые зависимости
```yaml
dependencies:
  # Для графиков и аналитики
  fl_chart: ^0.66.0
  
  # Для работы с видео
  video_player: ^2.8.1
  
  # Для таймера и уведомлений
  flutter_local_notifications: ^16.3.2
  
  # Для работы с камерой (фото упражнений)
  image_picker: ^1.0.7
  
  # Для health data (опционально)
  health: ^8.1.0
```

### База данных
```sql
-- Основные таблицы созданы в миграции
-- exercises, workouts, activity_sessions
-- user_favorite_exercises, workout_exercises
-- exercise_results, set_results
```

## 📝 Рекомендации

### Архитектурные принципы
1. **Clean Architecture** - четкое разделение слоев
2. **SOLID принципы** - единая ответственность, открытость/закрытость
3. **Dependency Injection** - инверсия зависимостей
4. **Repository Pattern** - абстракция доступа к данным

### Performance
1. **Lazy Loading** - загрузка данных по требованию
2. **Caching** - кэширование часто используемых данных
3. **Pagination** - пагинация для больших списков
4. **Image Optimization** - оптимизация изображений

### UX/UI
1. **Consistent Design** - единый стиль интерфейса
2. **Smooth Animations** - плавные переходы
3. **Accessibility** - доступность для всех пользователей
4. **Offline Support** - работа без интернета

## 🔄 Процесс разработки

### Ежедневные задачи
- [ ] Code review для изменений
- [ ] Обновление документации
- [ ] Тестирование новых функций

### Еженедельные задачи
- [ ] Ретроспектива прогресса
- [ ] Планирование следующей недели
- [ ] Обновление метрик

## 📞 Коммуникация

- **Ежедневные standup**: Краткий обзор прогресса
- **Еженедельные review**: Детальный обзор достижений
- **Code review**: Проверка качества кода
- **Ad-hoc**: При возникновении блокеров

## 🎯 Следующие шаги

1. **Создать Data Layer** - модели, сервисы, репозитории
2. **Реализовать Mock данные** - демо-данные для разработки
3. **Настроить Dependency Injection** - контейнер зависимостей
4. **Создать базовые экраны** - каталог упражнений и тренировок
5. **Интегрировать с Supabase** - подключение к реальной БД

---

**Примечание**: Этот план может корректироваться в процессе разработки в зависимости от приоритетов и ресурсов. 