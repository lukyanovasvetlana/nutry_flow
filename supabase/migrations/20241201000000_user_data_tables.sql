-- =====================================================
-- МИГРАЦИЯ: Таблицы пользовательских данных
-- Дата: 2024-12-01
-- Описание: Создание всех таблиц для хранения данных пользователей
-- =====================================================

-- =====================================================
-- 1. ЦЕЛИ ПОЛЬЗОВАТЕЛЯ (USER GOALS)
-- =====================================================

create table public.user_goals (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  fitness_goals text[] default '{}',
  target_calories integer check (target_calories >= 800 and target_calories <= 5000),
  target_protein integer check (target_protein >= 0 and target_protein <= 500),
  dietary_preferences text[] default '{}',
  allergens text[] default '{}',
  workout_types text[] default '{}',
  workout_frequency integer check (workout_frequency >= 0 and workout_frequency <= 7),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для user_goals
create index idx_user_goals_user_id on public.user_goals(user_id);
create index idx_user_goals_created_at on public.user_goals(created_at);

-- RLS для user_goals
alter table public.user_goals enable row level security;

create policy "Users can view their own goals"
  on public.user_goals for select
  using (auth.uid() = user_id);

create policy "Users can insert their own goals"
  on public.user_goals for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own goals"
  on public.user_goals for update
  using (auth.uid() = user_id);

create policy "Users can delete their own goals"
  on public.user_goals for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 2. ПЛАНЫ ПИТАНИЯ (MEAL PLANS)
-- =====================================================

create table public.meal_plans (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  description text,
  start_date date not null,
  end_date date not null,
  total_calories integer default 0,
  total_protein integer default 0,
  total_fat integer default 0,
  total_carbs integer default 0,
  is_active boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для meal_plans
create index idx_meal_plans_user_id on public.meal_plans(user_id);
create index idx_meal_plans_is_active on public.meal_plans(is_active);
create index idx_meal_plans_date_range on public.meal_plans(start_date, end_date);

-- RLS для meal_plans
alter table public.meal_plans enable row level security;

create policy "Users can view their own meal plans"
  on public.meal_plans for select
  using (auth.uid() = user_id);

create policy "Users can insert their own meal plans"
  on public.meal_plans for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own meal plans"
  on public.meal_plans for update
  using (auth.uid() = user_id);

create policy "Users can delete their own meal plans"
  on public.meal_plans for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 3. БЛЮДА ПЛАНА ПИТАНИЯ (MEAL PLAN MEALS)
-- =====================================================

create table public.meal_plan_meals (
  id uuid default gen_random_uuid() primary key,
  meal_plan_id uuid references public.meal_plans on delete cascade not null,
  meal_id text not null,
  day_of_week integer check (day_of_week >= 1 and day_of_week <= 7),
  meal_type text check (meal_type in ('breakfast', 'lunch', 'dinner', 'snack')),
  calories integer default 0,
  protein integer default 0,
  fat integer default 0,
  carbs integer default 0,
  "order" integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для meal_plan_meals
create index idx_meal_plan_meals_plan_id on public.meal_plan_meals(meal_plan_id);
create index idx_meal_plan_meals_day_type on public.meal_plan_meals(day_of_week, meal_type);

-- RLS для meal_plan_meals (через связь с meal_plans)
alter table public.meal_plan_meals enable row level security;

create policy "Users can view their own meal plan meals"
  on public.meal_plan_meals for select
  using (
    exists (
      select 1 from public.meal_plans
      where meal_plans.id = meal_plan_meals.meal_plan_id
      and meal_plans.user_id = auth.uid()
    )
  );

create policy "Users can insert their own meal plan meals"
  on public.meal_plan_meals for insert
  with check (
    exists (
      select 1 from public.meal_plans
      where meal_plans.id = meal_plan_meals.meal_plan_id
      and meal_plans.user_id = auth.uid()
    )
  );

create policy "Users can update their own meal plan meals"
  on public.meal_plan_meals for update
  using (
    exists (
      select 1 from public.meal_plans
      where meal_plans.id = meal_plan_meals.meal_plan_id
      and meal_plans.user_id = auth.uid()
    )
  );

create policy "Users can delete their own meal plan meals"
  on public.meal_plan_meals for delete
  using (
    exists (
      select 1 from public.meal_plans
      where meal_plans.id = meal_plan_meals.meal_plan_id
      and meal_plans.user_id = auth.uid()
    )
  );

-- =====================================================
-- 4. УПРАЖНЕНИЯ (EXERCISES)
-- =====================================================

create table public.exercises (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  description text,
  category text check (category in ('strength', 'cardio', 'flexibility', 'balance', 'sports')),
  muscle_groups text[] default '{}',
  equipment text check (equipment in ('bodyweight', 'dumbbells', 'barbell', 'machine', 'cable', 'resistance_bands', 'other')),
  difficulty text check (difficulty in ('beginner', 'intermediate', 'advanced')),
  instructions text,
  video_url text,
  image_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для exercises
create index idx_exercises_user_id on public.exercises(user_id);
create index idx_exercises_category on public.exercises(category);
create index idx_exercises_difficulty on public.exercises(difficulty);
create index idx_exercises_muscle_groups on public.exercises using gin(muscle_groups);

-- RLS для exercises
alter table public.exercises enable row level security;

create policy "Users can view their own exercises"
  on public.exercises for select
  using (auth.uid() = user_id);

create policy "Users can insert their own exercises"
  on public.exercises for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own exercises"
  on public.exercises for update
  using (auth.uid() = user_id);

create policy "Users can delete their own exercises"
  on public.exercises for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 5. ТРЕНИРОВКИ (WORKOUTS)
-- =====================================================

create table public.workouts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  description text,
  category text check (category in ('strength', 'cardio', 'flexibility', 'balance', 'sports')),
  difficulty text check (difficulty in ('beginner', 'intermediate', 'advanced')),
  estimated_duration integer check (estimated_duration >= 0),
  calories_burned integer default 0,
  is_favorite boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для workouts
create index idx_workouts_user_id on public.workouts(user_id);
create index idx_workouts_category on public.workouts(category);
create index idx_workouts_is_favorite on public.workouts(is_favorite);

-- RLS для workouts
alter table public.workouts enable row level security;

create policy "Users can view their own workouts"
  on public.workouts for select
  using (auth.uid() = user_id);

create policy "Users can insert their own workouts"
  on public.workouts for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own workouts"
  on public.workouts for update
  using (auth.uid() = user_id);

create policy "Users can delete their own workouts"
  on public.workouts for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 6. УПРАЖНЕНИЯ ТРЕНИРОВКИ (WORKOUT EXERCISES)
-- =====================================================

create table public.workout_exercises (
  id uuid default gen_random_uuid() primary key,
  workout_id uuid references public.workouts on delete cascade not null,
  exercise_id uuid references public.exercises on delete cascade not null,
  sets integer check (sets >= 0),
  reps integer check (reps >= 0),
  duration integer check (duration >= 0),
  rest_time integer check (rest_time >= 0),
  "order" integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для workout_exercises
create index idx_workout_exercises_workout_id on public.workout_exercises(workout_id);
create index idx_workout_exercises_exercise_id on public.workout_exercises(exercise_id);
create index idx_workout_exercises_order on public.workout_exercises("order");

-- RLS для workout_exercises (через связь с workouts)
alter table public.workout_exercises enable row level security;

create policy "Users can view their own workout exercises"
  on public.workout_exercises for select
  using (
    exists (
      select 1 from public.workouts
      where workouts.id = workout_exercises.workout_id
      and workouts.user_id = auth.uid()
    )
  );

create policy "Users can insert their own workout exercises"
  on public.workout_exercises for insert
  with check (
    exists (
      select 1 from public.workouts
      where workouts.id = workout_exercises.workout_id
      and workouts.user_id = auth.uid()
    )
  );

create policy "Users can update their own workout exercises"
  on public.workout_exercises for update
  using (
    exists (
      select 1 from public.workouts
      where workouts.id = workout_exercises.workout_id
      and workouts.user_id = auth.uid()
    )
  );

create policy "Users can delete their own workout exercises"
  on public.workout_exercises for delete
  using (
    exists (
      select 1 from public.workouts
      where workouts.id = workout_exercises.workout_id
      and workouts.user_id = auth.uid()
    )
  );

-- =====================================================
-- 7. СЕССИИ ТРЕНИРОВОК (WORKOUT SESSIONS)
-- =====================================================

create table public.workout_sessions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  workout_id uuid references public.workouts on delete cascade not null,
  started_at timestamp with time zone not null,
  completed_at timestamp with time zone,
  duration_minutes integer check (duration_minutes >= 0),
  calories_burned integer default 0,
  status text check (status in ('in_progress', 'completed', 'cancelled')) default 'in_progress',
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Индексы для workout_sessions
create index idx_workout_sessions_user_id on public.workout_sessions(user_id);
create index idx_workout_sessions_workout_id on public.workout_sessions(workout_id);
create index idx_workout_sessions_started_at on public.workout_sessions(started_at);
create index idx_workout_sessions_status on public.workout_sessions(status);

-- RLS для workout_sessions
alter table public.workout_sessions enable row level security;

create policy "Users can view their own workout sessions"
  on public.workout_sessions for select
  using (auth.uid() = user_id);

create policy "Users can insert their own workout sessions"
  on public.workout_sessions for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own workout sessions"
  on public.workout_sessions for update
  using (auth.uid() = user_id);

create policy "Users can delete their own workout sessions"
  on public.workout_sessions for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 8. ОТСЛЕЖИВАНИЕ ПИТАНИЯ (NUTRITION TRACKING)
-- =====================================================

create table public.nutrition_tracking (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  date date not null,
  calories_consumed integer default 0,
  protein_consumed integer default 0,
  fat_consumed integer default 0,
  carbs_consumed integer default 0,
  fiber_consumed integer default 0,
  water_consumed integer default 0,
  meals_count integer default 0,
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, date)
);

-- Индексы для nutrition_tracking
create index idx_nutrition_tracking_user_id on public.nutrition_tracking(user_id);
create index idx_nutrition_tracking_date on public.nutrition_tracking(date);
create index idx_nutrition_tracking_user_date on public.nutrition_tracking(user_id, date);

-- RLS для nutrition_tracking
alter table public.nutrition_tracking enable row level security;

create policy "Users can view their own nutrition tracking"
  on public.nutrition_tracking for select
  using (auth.uid() = user_id);

create policy "Users can insert their own nutrition tracking"
  on public.nutrition_tracking for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own nutrition tracking"
  on public.nutrition_tracking for update
  using (auth.uid() = user_id);

create policy "Users can delete their own nutrition tracking"
  on public.nutrition_tracking for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 9. ОТСЛЕЖИВАНИЕ ВЕСА (WEIGHT TRACKING)
-- =====================================================

create table public.weight_tracking (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  date date not null,
  weight numeric(5,2) check (weight >= 0),
  body_fat_percentage numeric(4,2) check (body_fat_percentage >= 0 and body_fat_percentage <= 100),
  muscle_mass numeric(5,2) check (muscle_mass >= 0),
  bmi numeric(4,2) check (bmi >= 0),
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, date)
);

-- Индексы для weight_tracking
create index idx_weight_tracking_user_id on public.weight_tracking(user_id);
create index idx_weight_tracking_date on public.weight_tracking(date);
create index idx_weight_tracking_user_date on public.weight_tracking(user_id, date);

-- RLS для weight_tracking
alter table public.weight_tracking enable row level security;

create policy "Users can view their own weight tracking"
  on public.weight_tracking for select
  using (auth.uid() = user_id);

create policy "Users can insert their own weight tracking"
  on public.weight_tracking for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own weight tracking"
  on public.weight_tracking for update
  using (auth.uid() = user_id);

create policy "Users can delete their own weight tracking"
  on public.weight_tracking for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 10. ОТСЛЕЖИВАНИЕ АКТИВНОСТИ (ACTIVITY TRACKING)
-- =====================================================

create table public.activity_tracking (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  date date not null,
  steps_count integer default 0,
  distance_km numeric(6,2) default 0,
  calories_burned integer default 0,
  active_minutes integer default 0,
  workout_duration integer default 0,
  workout_type text,
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, date)
);

-- Индексы для activity_tracking
create index idx_activity_tracking_user_id on public.activity_tracking(user_id);
create index idx_activity_tracking_date on public.activity_tracking(date);
create index idx_activity_tracking_user_date on public.activity_tracking(user_id, date);

-- RLS для activity_tracking
alter table public.activity_tracking enable row level security;

create policy "Users can view their own activity tracking"
  on public.activity_tracking for select
  using (auth.uid() = user_id);

create policy "Users can insert their own activity tracking"
  on public.activity_tracking for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own activity tracking"
  on public.activity_tracking for update
  using (auth.uid() = user_id);

create policy "Users can delete their own activity tracking"
  on public.activity_tracking for delete
  using (auth.uid() = user_id);

-- =====================================================
-- 11. ФУНКЦИИ ДЛЯ АВТОМАТИЧЕСКОГО ОБНОВЛЕНИЯ TIMESTAMPS
-- =====================================================

-- Функция для обновления updated_at
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

-- Триггеры для автоматического обновления updated_at
create trigger handle_user_goals_updated_at
  before update on public.user_goals
  for each row execute procedure public.handle_updated_at();

create trigger handle_meal_plans_updated_at
  before update on public.meal_plans
  for each row execute procedure public.handle_updated_at();

create trigger handle_exercises_updated_at
  before update on public.exercises
  for each row execute procedure public.handle_updated_at();

create trigger handle_workouts_updated_at
  before update on public.workouts
  for each row execute procedure public.handle_updated_at();

-- =====================================================
-- 12. ИНДЕКСЫ ДЛЯ ПОИСКА И ФИЛЬТРАЦИИ
-- =====================================================

-- Составные индексы для часто используемых запросов
create index idx_meal_plans_user_active_date on public.meal_plans(user_id, is_active, start_date);
create index idx_workout_sessions_user_date_range on public.workout_sessions(user_id, started_at, completed_at);
create index idx_nutrition_tracking_user_date_range on public.nutrition_tracking(user_id, date);
create index idx_weight_tracking_user_date_range on public.weight_tracking(user_id, date);
create index idx_activity_tracking_user_date_range on public.activity_tracking(user_id, date);

-- Индексы для полнотекстового поиска (если понадобится)
create index idx_exercises_name_gin on public.exercises using gin(to_tsvector('english', name));
create index idx_workouts_name_gin on public.workouts using gin(to_tsvector('english', name));

-- =====================================================
-- МИГРАЦИЯ ЗАВЕРШЕНА
-- ===================================================== 