-- Epic 4 - Activity Schema Migration
-- Создание таблиц для системы управления физической активностью

-- Таблица упражнений
CREATE TABLE IF NOT EXISTS exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  difficulty VARCHAR(50) NOT NULL,
  sets INTEGER,
  reps INTEGER,
  rest_seconds INTEGER,
  duration VARCHAR(50),
  icon_name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  target_muscles TEXT[] NOT NULL,
  equipment TEXT[] NOT NULL,
  video_url VARCHAR(500),
  image_url VARCHAR(500),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица тренировок
CREATE TABLE IF NOT EXISTS workouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  estimated_duration_minutes INTEGER,
  difficulty VARCHAR(50) NOT NULL,
  is_template BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Связь тренировок и упражнений
CREATE TABLE IF NOT EXISTS workout_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL,
  sets INTEGER,
  reps INTEGER,
  rest_seconds INTEGER,
  duration VARCHAR(50),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Сессии активности
CREATE TABLE IF NOT EXISTS activity_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  workout_id UUID REFERENCES workouts(id) ON DELETE SET NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'in_progress',
  started_at TIMESTAMP WITH TIME ZONE NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE,
  duration_minutes INTEGER,
  calories_burned INTEGER,
  notes TEXT,
  exercise_data JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Статистика активности
CREATE TABLE IF NOT EXISTS activity_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  total_workouts INTEGER DEFAULT 0,
  total_duration_minutes INTEGER DEFAULT 0,
  total_calories_burned INTEGER DEFAULT 0,
  total_exercises INTEGER DEFAULT 0,
  category_breakdown JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, date)
);

-- Избранные упражнения пользователей
CREATE TABLE IF NOT EXISTS user_favorite_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, exercise_id)
);

-- Индексы для оптимизации запросов
CREATE INDEX IF NOT EXISTS idx_exercises_category ON exercises(category);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_workouts_is_template ON workouts(is_template);
CREATE INDEX IF NOT EXISTS idx_workout_exercises_workout_id ON workout_exercises(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_exercises_order ON workout_exercises(workout_id, order_index);
CREATE INDEX IF NOT EXISTS idx_activity_sessions_user_id ON activity_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_sessions_started_at ON activity_sessions(started_at);
CREATE INDEX IF NOT EXISTS idx_activity_stats_user_date ON activity_stats(user_id, date);
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON user_favorite_exercises(user_id);

-- RLS (Row Level Security) политики
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorite_exercises ENABLE ROW LEVEL SECURITY;

-- Политики для упражнений (публичный доступ для чтения)
CREATE POLICY "Exercises are viewable by everyone" ON exercises
  FOR SELECT USING (true);

-- Политики для тренировок
CREATE POLICY "Users can view their own workouts" ON workouts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own workouts" ON workouts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workouts" ON workouts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workouts" ON workouts
  FOR DELETE USING (auth.uid() = user_id);

-- Политики для связей тренировок и упражнений
CREATE POLICY "Users can view workout exercises for their workouts" ON workout_exercises
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM workouts 
      WHERE workouts.id = workout_exercises.workout_id 
      AND workouts.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert workout exercises for their workouts" ON workout_exercises
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM workouts 
      WHERE workouts.id = workout_exercises.workout_id 
      AND workouts.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update workout exercises for their workouts" ON workout_exercises
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM workouts 
      WHERE workouts.id = workout_exercises.workout_id 
      AND workouts.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete workout exercises for their workouts" ON workout_exercises
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM workouts 
      WHERE workouts.id = workout_exercises.workout_id 
      AND workouts.user_id = auth.uid()
    )
  );

-- Политики для сессий активности
CREATE POLICY "Users can view their own activity sessions" ON activity_sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own activity sessions" ON activity_sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own activity sessions" ON activity_sessions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own activity sessions" ON activity_sessions
  FOR DELETE USING (auth.uid() = user_id);

-- Политики для статистики активности
CREATE POLICY "Users can view their own activity stats" ON activity_stats
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own activity stats" ON activity_stats
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own activity stats" ON activity_stats
  FOR UPDATE USING (auth.uid() = user_id);

-- Политики для избранных упражнений
CREATE POLICY "Users can view their own favorite exercises" ON user_favorite_exercises
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own favorite exercises" ON user_favorite_exercises
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorite exercises" ON user_favorite_exercises
  FOR DELETE USING (auth.uid() = user_id);

-- Функции для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Триггеры для автоматического обновления updated_at
CREATE TRIGGER update_exercises_updated_at 
  BEFORE UPDATE ON exercises 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at 
  BEFORE UPDATE ON workouts 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_activity_stats_updated_at 
  BEFORE UPDATE ON activity_stats 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Вставка базовых упражнений
INSERT INTO exercises (name, category, difficulty, sets, reps, rest_seconds, icon_name, description, target_muscles, equipment) VALUES
('Приседания', 'legs', 'beginner', 4, 12, 60, 'fitness_center', 'Комплексное упражнение, которое задействует квадрицепсы, подколенные сухожилия и ягодицы.', ARRAY['Квадрицепсы', 'Подколенные сухожилия', 'Ягодицы'], ARRAY['Собственный вес']),
('Становая тяга', 'back', 'advanced', 3, 10, 90, 'fitness_center', 'Базовое комплексное упражнение, которое прорабатывает всю заднюю цепь мышц.', ARRAY['Подколенные сухожилия', 'Ягодицы', 'Поясница', 'Трапеции'], ARRAY['Штанга', 'Блины']),
('Жим лежа', 'chest', 'intermediate', 3, 8, 60, 'fitness_center', 'Классическое упражнение для верхней части тела, нацеленное на грудь, плечи и трицепсы.', ARRAY['Грудь', 'Плечи', 'Трицепсы'], ARRAY['Штанга', 'Скамья', 'Блины']),
('Подтягивания', 'back', 'intermediate', 4, 8, 90, 'fitness_center', 'Упражнение с собственным весом, которое прорабатывает спину и бицепсы.', ARRAY['Широчайшие', 'Ромбовидные', 'Бицепсы'], ARRAY['Турник']),
('Планка', 'core', 'beginner', 3, 60, 30, 'fitness_center', 'Изометрическое упражнение для кора, которое укрепляет всю среднюю часть тела.', ARRAY['Пресс', 'Плечи', 'Ягодицы'], ARRAY['Собственный вес']),
('Бег', 'cardio', 'beginner', 1, 1, 0, 'directions_run', 'Кардиоупражнение, которое улучшает выносливость и сжигает калории.', ARRAY['Ноги', 'Сердечно-сосудистая система'], ARRAY['Беговые кроссовки']),
('Выпады', 'legs', 'beginner', 3, 15, 60, 'fitness_center', 'Одностороннее упражнение для ног, которое улучшает баланс и силу.', ARRAY['Квадрицепсы', 'Подколенные сухожилия', 'Ягодицы'], ARRAY['Собственный вес']),
('Жим плечами', 'shoulders', 'intermediate', 3, 10, 60, 'fitness_center', 'Жимовое движение над головой, которое прорабатывает плечи.', ARRAY['Плечи', 'Трицепсы', 'Пресс'], ARRAY['Гантели']),
('Подъемы на бицепс', 'arms', 'beginner', 3, 12, 45, 'fitness_center', 'Изолирующее упражнение, которое прорабатывает бицепсы.', ARRAY['Бицепсы'], ARRAY['Гантели']),
('Велосипед', 'cardio', 'beginner', 1, 1, 0, 'directions_bike', 'Низкоударное кардиоупражнение, которое укрепляет мышцы ног.', ARRAY['Ноги', 'Сердечно-сосудистая система'], ARRAY['Велосипед']),
('Альпинист', 'core', 'intermediate', 4, 20, 30, 'fitness_center', 'Динамическое упражнение, которое сочетает кардио и укрепление кора.', ARRAY['Пресс', 'Плечи', 'Ноги'], ARRAY['Собственный вес']),
('Йога (Растяжка)', 'yoga', 'beginner', 1, 1, 0, 'self_improvement', 'Практика, которая сочетает физические позы, дыхание и медитацию.', ARRAY['Все тело'], ARRAY['Коврик для йоги'])
ON CONFLICT DO NOTHING; 