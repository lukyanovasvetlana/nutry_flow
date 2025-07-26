-- Схема для Epic 4: Activity
-- Таблицы для упражнений, тренировок и сессий

-- Таблица упражнений
CREATE TABLE IF NOT EXISTS public.exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(50) NOT NULL CHECK (category IN ('strength', 'cardio', 'flexibility', 'balance', 'sports', 'yoga', 'pilates', 'hiit', 'other')),
  difficulty VARCHAR(50) NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced', 'expert')),
  target_muscles TEXT[] NOT NULL,
  required_equipment TEXT[] NOT NULL,
  instructions TEXT,
  video_url VARCHAR(500),
  image_url VARCHAR(500),
  default_sets INTEGER,
  default_reps INTEGER,
  default_duration INTEGER, -- в секундах
  default_rest_time INTEGER, -- в секундах
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Таблица избранных упражнений пользователей
CREATE TABLE IF NOT EXISTS public.user_favorite_exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(user_id, exercise_id)
);

-- Таблица тренировок
CREATE TABLE IF NOT EXISTS public.workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  type VARCHAR(50) NOT NULL CHECK (type IN ('strength', 'cardio', 'flexibility', 'mixed', 'custom')),
  status VARCHAR(50) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'completed', 'cancelled')),
  estimated_duration INTEGER NOT NULL, -- в минутах
  difficulty INTEGER CHECK (difficulty >= 1 AND difficulty <= 10),
  is_template BOOLEAN DEFAULT false,
  is_favorite BOOLEAN DEFAULT false,
  scheduled_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Таблица упражнений в тренировке
CREATE TABLE IF NOT EXISTS public.workout_exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  workout_id UUID REFERENCES public.workouts(id) ON DELETE CASCADE NOT NULL,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE NOT NULL,
  sets INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  duration INTEGER, -- в секундах для кардио
  rest_time INTEGER NOT NULL, -- в секундах
  weight NUMERIC, -- в кг
  notes TEXT,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Таблица сессий тренировок
CREATE TABLE IF NOT EXISTS public.activity_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  workout_id UUID REFERENCES public.workouts(id) ON DELETE SET NULL,
  workout_name VARCHAR(255) NOT NULL,
  workout_type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'paused', 'cancelled')),
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE,
  total_duration INTEGER, -- в секундах
  total_calories INTEGER,
  notes TEXT,
  metadata JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Таблица результатов упражнений в сессии
CREATE TABLE IF NOT EXISTS public.exercise_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID REFERENCES public.activity_sessions(id) ON DELETE CASCADE NOT NULL,
  exercise_id UUID NOT NULL,
  exercise_name VARCHAR(255) NOT NULL,
  sets INTEGER NOT NULL,
  duration INTEGER, -- в секундах для кардио
  weight NUMERIC, -- в кг
  notes TEXT,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Таблица результатов подходов
CREATE TABLE IF NOT EXISTS public.set_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  exercise_result_id UUID REFERENCES public.exercise_results(id) ON DELETE CASCADE NOT NULL,
  set_number INTEGER NOT NULL,
  reps INTEGER,
  duration INTEGER, -- в секундах
  weight NUMERIC, -- в кг
  rest_time INTEGER, -- в секундах
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Включаем RLS для всех таблиц
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_favorite_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.set_results ENABLE ROW LEVEL SECURITY;

-- Политики безопасности для exercises (публичный доступ для чтения)
CREATE POLICY "Anyone can view exercises"
  ON public.exercises FOR SELECT
  USING (true);

-- Политики безопасности для user_favorite_exercises
CREATE POLICY "Users can view their favorite exercises"
  ON public.user_favorite_exercises FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can add favorite exercises"
  ON public.user_favorite_exercises FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove favorite exercises"
  ON public.user_favorite_exercises FOR DELETE
  USING (auth.uid() = user_id);

-- Политики безопасности для workouts
CREATE POLICY "Users can view their own workouts"
  ON public.workouts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own workouts"
  ON public.workouts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workouts"
  ON public.workouts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workouts"
  ON public.workouts FOR DELETE
  USING (auth.uid() = user_id);

-- Политики безопасности для workout_exercises
CREATE POLICY "Users can view workout exercises"
  ON public.workout_exercises FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.workouts 
    WHERE workouts.id = workout_exercises.workout_id 
    AND workouts.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage workout exercises"
  ON public.workout_exercises FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.workouts 
    WHERE workouts.id = workout_exercises.workout_id 
    AND workouts.user_id = auth.uid()
  ));

-- Политики безопасности для activity_sessions
CREATE POLICY "Users can view their own sessions"
  ON public.activity_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own sessions"
  ON public.activity_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own sessions"
  ON public.activity_sessions FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own sessions"
  ON public.activity_sessions FOR DELETE
  USING (auth.uid() = user_id);

-- Политики безопасности для exercise_results
CREATE POLICY "Users can view exercise results"
  ON public.exercise_results FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.activity_sessions 
    WHERE activity_sessions.id = exercise_results.session_id 
    AND activity_sessions.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage exercise results"
  ON public.exercise_results FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.activity_sessions 
    WHERE activity_sessions.id = exercise_results.session_id 
    AND activity_sessions.user_id = auth.uid()
  ));

-- Политики безопасности для set_results
CREATE POLICY "Users can view set results"
  ON public.set_results FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.exercise_results 
    JOIN public.activity_sessions ON activity_sessions.id = exercise_results.session_id
    WHERE exercise_results.id = set_results.exercise_result_id 
    AND activity_sessions.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage set results"
  ON public.set_results FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.exercise_results 
    JOIN public.activity_sessions ON activity_sessions.id = exercise_results.session_id
    WHERE exercise_results.id = set_results.exercise_result_id 
    AND activity_sessions.user_id = auth.uid()
  ));

-- Создаем индексы для оптимизации
CREATE INDEX IF NOT EXISTS idx_exercises_category ON public.exercises(category);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON public.exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_exercises_target_muscles ON public.exercises USING GIN(target_muscles);
CREATE INDEX IF NOT EXISTS idx_exercises_equipment ON public.exercises USING GIN(required_equipment);

CREATE INDEX IF NOT EXISTS idx_user_favorite_exercises_user_id ON public.user_favorite_exercises(user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorite_exercises_exercise_id ON public.user_favorite_exercises(exercise_id);

CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON public.workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_workouts_type ON public.workouts(type);
CREATE INDEX IF NOT EXISTS idx_workouts_status ON public.workouts(status);
CREATE INDEX IF NOT EXISTS idx_workouts_scheduled_date ON public.workouts(scheduled_date);

CREATE INDEX IF NOT EXISTS idx_workout_exercises_workout_id ON public.workout_exercises(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_exercises_exercise_id ON public.workout_exercises(exercise_id);
CREATE INDEX IF NOT EXISTS idx_workout_exercises_order ON public.workout_exercises(order_index);

CREATE INDEX IF NOT EXISTS idx_activity_sessions_user_id ON public.activity_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_sessions_workout_id ON public.activity_sessions(workout_id);
CREATE INDEX IF NOT EXISTS idx_activity_sessions_start_time ON public.activity_sessions(start_time);
CREATE INDEX IF NOT EXISTS idx_activity_sessions_status ON public.activity_sessions(status);

CREATE INDEX IF NOT EXISTS idx_exercise_results_session_id ON public.exercise_results(session_id);
CREATE INDEX IF NOT EXISTS idx_exercise_results_exercise_id ON public.exercise_results(exercise_id);

CREATE INDEX IF NOT EXISTS idx_set_results_exercise_result_id ON public.set_results(exercise_result_id);
CREATE INDEX IF NOT EXISTS idx_set_results_set_number ON public.set_results(set_number);

-- Создаем триггеры для автоматического обновления updated_at
CREATE TRIGGER update_exercises_updated_at
  BEFORE UPDATE ON public.exercises
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at
  BEFORE UPDATE ON public.workouts
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_activity_sessions_updated_at
  BEFORE UPDATE ON public.activity_sessions
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column(); 