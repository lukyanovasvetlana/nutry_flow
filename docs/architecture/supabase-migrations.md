# Supabase Migrations Documentation

## Обзор

Этот документ описывает миграции базы данных Supabase для приложения NutryFlow.

## Структура миграций

### 1. Начальная схема (20240320000000_initial_schema.sql)
- **Таблица**: `profiles`
- **Описание**: Профили пользователей с основной информацией
- **RLS**: Включен с политиками для пользователей

### 2. Пользовательские данные (20241201000000_user_data_tables.sql)
- **Таблицы**: 10 основных таблиц для всех функций приложения
- **RLS**: Включен для всех таблиц
- **Индексы**: Оптимизированы для производительности

## Таблицы базы данных

### 1. user_goals
**Цели пользователя**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- fitness_goals: text[]
- target_calories: integer (800-5000)
- target_protein: integer (0-500)
- dietary_preferences: text[]
- allergens: text[]
- workout_types: text[]
- workout_frequency: integer (0-7)
- created_at: timestamp
- updated_at: timestamp
```

### 2. meal_plans
**Планы питания**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- name: text
- description: text
- start_date: date
- end_date: date
- total_calories: integer
- total_protein: integer
- total_fat: integer
- total_carbs: integer
- is_active: boolean
- created_at: timestamp
- updated_at: timestamp
```

### 3. meal_plan_meals
**Блюда плана питания**
```sql
- id: uuid (PK)
- meal_plan_id: uuid (FK -> meal_plans)
- meal_id: text
- day_of_week: integer (1-7)
- meal_type: text (breakfast/lunch/dinner/snack)
- calories: integer
- protein: integer
- fat: integer
- carbs: integer
- order: integer
- created_at: timestamp
```

### 4. exercises
**Упражнения**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- name: text
- description: text
- category: text (strength/cardio/flexibility/balance/sports)
- muscle_groups: text[]
- equipment: text (bodyweight/dumbbells/barbell/machine/cable/resistance_bands/other)
- difficulty: text (beginner/intermediate/advanced)
- instructions: text
- video_url: text
- image_url: text
- created_at: timestamp
- updated_at: timestamp
```

### 5. workouts
**Тренировки**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- name: text
- description: text
- category: text (strength/cardio/flexibility/balance/sports)
- difficulty: text (beginner/intermediate/advanced)
- estimated_duration: integer
- calories_burned: integer
- is_favorite: boolean
- created_at: timestamp
- updated_at: timestamp
```

### 6. workout_exercises
**Упражнения в тренировке**
```sql
- id: uuid (PK)
- workout_id: uuid (FK -> workouts)
- exercise_id: uuid (FK -> exercises)
- sets: integer
- reps: integer
- duration: integer
- rest_time: integer
- order: integer
- created_at: timestamp
```

### 7. workout_sessions
**Сессии тренировок**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- workout_id: uuid (FK -> workouts)
- started_at: timestamp
- completed_at: timestamp
- duration_minutes: integer
- calories_burned: integer
- status: text (in_progress/completed/cancelled)
- notes: text
- created_at: timestamp
```

### 8. nutrition_tracking
**Отслеживание питания**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- date: date
- calories_consumed: integer
- protein_consumed: integer
- fat_consumed: integer
- carbs_consumed: integer
- fiber_consumed: integer
- water_consumed: integer
- meals_count: integer
- notes: text
- created_at: timestamp
- UNIQUE(user_id, date)
```

### 9. weight_tracking
**Отслеживание веса**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- date: date
- weight: numeric(5,2)
- body_fat_percentage: numeric(4,2)
- muscle_mass: numeric(5,2)
- bmi: numeric(4,2)
- notes: text
- created_at: timestamp
- UNIQUE(user_id, date)
```

### 10. activity_tracking
**Отслеживание активности**
```sql
- id: uuid (PK)
- user_id: uuid (FK -> auth.users)
- date: date
- steps_count: integer
- distance_km: numeric(6,2)
- calories_burned: integer
- active_minutes: integer
- workout_duration: integer
- workout_type: text
- notes: text
- created_at: timestamp
- UNIQUE(user_id, date)
```

## Row Level Security (RLS)

Все таблицы имеют включенный RLS с политиками:

### Базовые политики для каждой таблицы:
1. **SELECT**: Пользователи могут просматривать только свои данные
2. **INSERT**: Пользователи могут создавать только свои данные
3. **UPDATE**: Пользователи могут обновлять только свои данные
4. **DELETE**: Пользователи могут удалять только свои данные

### Специальные политики:
- **meal_plan_meals**: Доступ через связь с meal_plans
- **workout_exercises**: Доступ через связь с workouts

## Индексы

### Основные индексы:
- `user_id` для всех таблиц
- `created_at` для сортировки
- `date` для таблиц отслеживания

### Составные индексы:
- `(user_id, is_active, start_date)` для meal_plans
- `(user_id, started_at, completed_at)` для workout_sessions
- `(user_id, date)` для всех таблиц отслеживания

### Специальные индексы:
- `muscle_groups` с GIN для массивов
- `name` с полнотекстовым поиском

## Ограничения (Constraints)

### Проверки значений:
- `target_calories`: 800-5000
- `target_protein`: 0-500
- `workout_frequency`: 0-7
- `day_of_week`: 1-7
- `body_fat_percentage`: 0-100
- `weight`, `muscle_mass`, `bmi`: >= 0

### Уникальные ограничения:
- `(user_id, date)` для таблиц отслеживания

## Триггеры

### Автоматическое обновление timestamps:
- `handle_updated_at()` функция
- Триггеры для всех таблиц с `updated_at`

## Применение миграций

### Локально:
```bash
supabase db reset
```

### В продакшене:
```bash
supabase db push
```

## Мониторинг

### Проверка RLS:
```sql
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

### Проверка индексов:
```sql
SELECT tablename, indexname, indexdef 
FROM pg_indexes 
WHERE schemaname = 'public';
```

### Проверка политик:
```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
```

## Безопасность

1. **RLS включен** для всех таблиц
2. **Политики безопасности** настроены правильно
3. **Каскадное удаление** настроено для связанных таблиц
4. **Проверки значений** предотвращают некорректные данные
5. **Уникальные ограничения** предотвращают дублирование

## Производительность

1. **Индексы** оптимизированы для частых запросов
2. **Составные индексы** для сложных фильтров
3. **GIN индексы** для массивов
4. **Полнотекстовый поиск** для названий

## Резервное копирование

Рекомендуется настроить автоматическое резервное копирование:

```sql
-- Создание резервной копии
pg_dump -h your-supabase-host -U postgres -d postgres > backup.sql

-- Восстановление
psql -h your-supabase-host -U postgres -d postgres < backup.sql
``` 