# Epic 4 - Activity: План разработки

## Обзор
Epic 4 фокусируется на создании полноценной системы управления физической активностью, включая упражнения, тренировки, отслеживание активности и статистику.

## Текущее состояние
- ✅ Базовая модель Exercise
- ✅ ExerciseService с моковыми данными
- ✅ UI экраны для упражнений
- ❌ Отсутствует доменная архитектура
- ❌ Нет интеграции с Supabase
- ❌ Нет системы тренировок
- ❌ Нет отслеживания активности

## Архитектура Epic 4

### Доменная архитектура
```
lib/features/activity/
├── domain/
│   ├── entities/
│   │   ├── exercise.dart
│   │   ├── workout.dart
│   │   ├── activity_session.dart
│   │   └── activity_stats.dart
│   ├── repositories/
│   │   ├── exercise_repository.dart
│   │   ├── workout_repository.dart
│   │   └── activity_repository.dart
│   └── usecases/
│       ├── exercise_usecases.dart
│       ├── workout_usecases.dart
│       └── activity_usecases.dart
├── data/
│   ├── models/
│   │   ├── exercise_model.dart
│   │   ├── workout_model.dart
│   │   └── activity_session_model.dart
│   ├── repositories/
│   │   ├── exercise_repository_impl.dart
│   │   ├── workout_repository_impl.dart
│   │   └── activity_repository_impl.dart
│   └── services/
│       ├── supabase_exercise_service.dart
│       ├── supabase_workout_service.dart
│       └── activity_tracking_service.dart
├── di/
│   └── activity_dependencies.dart
└── presentation/
    ├── screens/
    │   ├── exercise_catalog_screen.dart
    │   ├── workout_creation_screen.dart
    │   ├── workout_session_screen.dart
    │   ├── activity_stats_screen.dart
    │   └── exercise_detail_screen.dart
    ├── widgets/
    │   ├── exercise_card.dart
    │   ├── workout_card.dart
    │   ├── activity_chart.dart
    │   └── workout_timer.dart
    └── bloc/
        ├── exercise_bloc.dart
        ├── workout_bloc.dart
        └── activity_bloc.dart
```

## Детальный план разработки

### Фаза 1: Доменная архитектура (2-3 дня)

#### 1.1 Создание доменных сущностей
- [ ] `Exercise` - упражнение с детальной информацией
- [ ] `Workout` - тренировка с набором упражнений
- [ ] `ActivitySession` - сессия активности
- [ ] `ActivityStats` - статистика активности

#### 1.2 Определение репозиториев
- [ ] `ExerciseRepository` - управление упражнениями
- [ ] `WorkoutRepository` - управление тренировками
- [ ] `ActivityRepository` - отслеживание активности

#### 1.3 Создание use cases
- [ ] `GetExercisesUseCase` - получение списка упражнений
- [ ] `GetExerciseByIdUseCase` - получение упражнения по ID
- [ ] `CreateWorkoutUseCase` - создание тренировки
- [ ] `StartWorkoutSessionUseCase` - начало тренировки
- [ ] `CompleteWorkoutSessionUseCase` - завершение тренировки
- [ ] `GetActivityStatsUseCase` - получение статистики

### Фаза 2: Data Layer (3-4 дня)

#### 2.1 Supabase интеграция
- [ ] Создание миграций для таблиц:
  - `exercises` - каталог упражнений
  - `workouts` - тренировки пользователей
  - `workout_exercises` - связь тренировок и упражнений
  - `activity_sessions` - сессии активности
  - `activity_stats` - статистика активности

#### 2.2 Реализация сервисов
- [ ] `SupabaseExerciseService` - CRUD для упражнений
- [ ] `SupabaseWorkoutService` - управление тренировками
- [ ] `ActivityTrackingService` - отслеживание активности

#### 2.3 Реализация репозиториев
- [ ] `ExerciseRepositoryImpl`
- [ ] `WorkoutRepositoryImpl`
- [ ] `ActivityRepositoryImpl`

### Фаза 3: Presentation Layer (4-5 дней)

#### 3.1 BLoC архитектура
- [ ] `ExerciseBloc` - управление состоянием упражнений
- [ ] `WorkoutBloc` - управление тренировками
- [ ] `ActivityBloc` - управление активностью

#### 3.2 Экраны
- [ ] `ExerciseCatalogScreen` - каталог упражнений
- [ ] `ExerciseDetailScreen` - детали упражнения
- [ ] `WorkoutCreationScreen` - создание тренировки
- [ ] `WorkoutSessionScreen` - выполнение тренировки
- [ ] `ActivityStatsScreen` - статистика активности

#### 3.3 Виджеты
- [ ] `ExerciseCard` - карточка упражнения
- [ ] `WorkoutCard` - карточка тренировки
- [ ] `ActivityChart` - графики активности
- [ ] `WorkoutTimer` - таймер тренировки

### Фаза 4: Интеграция и тестирование (2-3 дня)

#### 4.1 Dependency Injection
- [ ] Настройка DI для всех сервисов
- [ ] Интеграция с существующим кодом

#### 4.2 Тестирование
- [ ] Unit тесты для use cases
- [ ] Widget тесты для экранов
- [ ] Integration тесты для полного флоу

#### 4.3 Полировка UI/UX
- [ ] Анимации и переходы
- [ ] Адаптивность
- [ ] Accessibility

## Технические требования

### База данных (Supabase)
```sql
-- Таблица упражнений
CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  difficulty VARCHAR(50) NOT NULL,
  sets INTEGER,
  reps INTEGER,
  rest_seconds INTEGER,
  duration VARCHAR(50),
  icon_name VARCHAR(100),
  description TEXT,
  target_muscles TEXT[],
  equipment TEXT[],
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Таблица тренировок
CREATE TABLE workouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  duration_minutes INTEGER,
  difficulty VARCHAR(50),
  is_template BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Связь тренировок и упражнений
CREATE TABLE workout_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  order_index INTEGER NOT NULL,
  sets INTEGER,
  reps INTEGER,
  rest_seconds INTEGER,
  duration VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Сессии активности
CREATE TABLE activity_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  workout_id UUID REFERENCES workouts(id),
  started_at TIMESTAMP NOT NULL,
  completed_at TIMESTAMP,
  duration_minutes INTEGER,
  calories_burned INTEGER,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Статистика активности
CREATE TABLE activity_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  date DATE NOT NULL,
  total_workouts INTEGER DEFAULT 0,
  total_duration_minutes INTEGER DEFAULT 0,
  total_calories_burned INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, date)
);
```

### Ключевые функции

#### 1. Каталог упражнений
- Поиск и фильтрация
- Категории и сложность
- Детальная информация
- Избранные упражнения

#### 2. Создание тренировок
- Выбор упражнений
- Настройка подходов/повторений
- Сохранение как шаблон
- Предварительный просмотр

#### 3. Выполнение тренировок
- Таймер и счетчик
- Отслеживание прогресса
- Заметки и оценки
- Автосохранение

#### 4. Статистика активности
- Графики по дням/неделям
- Сравнение с целями
- История тренировок
- Достижения

## Временные рамки

### Неделя 1
- Доменная архитектура
- Supabase миграции
- Базовые сервисы

### Неделя 2
- BLoC архитектура
- Основные экраны
- Интеграция

### Неделя 3
- Тестирование
- Полировка UI/UX
- Документация

## Критерии готовности

### Функциональные
- [ ] Полный каталог упражнений
- [ ] Создание и выполнение тренировок
- [ ] Отслеживание активности
- [ ] Статистика и аналитика

### Технические
- [ ] 90%+ покрытие тестами
- [ ] Clean Architecture
- [ ] Supabase интеграция
- [ ] Responsive дизайн

### UX/UI
- [ ] Интуитивная навигация
- [ ] Плавные анимации
- [ ] Accessibility поддержка
- [ ] Темная/светлая тема

## Риски и митигация

### Риски
1. **Сложность интеграции с устройствами** - начнем с базового отслеживания
2. **Производительность с большими данными** - пагинация и кэширование
3. **Синхронизация данных** - оптимистичные обновления

### Митигация
- Поэтапная разработка
- Тестирование на реальных данных
- Мониторинг производительности
- Fallback механизмы

## Следующие шаги

1. Создание доменных сущностей
2. Настройка Supabase схемы
3. Реализация базовых сервисов
4. Разработка UI компонентов
5. Интеграция и тестирование 