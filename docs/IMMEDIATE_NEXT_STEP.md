# Следующий шаг - NutryFlow

## 🎯 Конкретный план действий

### Шаг 1: Настройка окружения (Сегодня - 30 минут)

#### 1.1 Установка зависимостей
```bash
# Установка Python зависимостей для Scrum автоматизации
pip install -r scripts/requirements.txt

# Проверка установки
python scripts/scrum_automation.py --help
```

#### 1.2 Настройка GitHub token
```bash
# Создание GitHub Personal Access Token
# 1. Перейти в GitHub Settings -> Developer settings -> Personal access tokens
# 2. Создать новый token с правами: repo, workflow
# 3. Скопировать token

# Настройка переменной окружения
export GITHUB_TOKEN=your_github_token_here

# Проверка подключения
python scripts/scrum_automation.py \
  --action daily-report \
  --github-token $GITHUB_TOKEN \
  --repo lukyanovasvetlana/nutry_flow
```

### Шаг 2: Создание GitHub Issues (Сегодня - 15 минут)

```bash
# Создание issues для Sprint 2
gh issue create --title "US-010: Implement user authentication" \
  --body "## User Story
Как пользователь, я хочу безопасно входить в приложение

## Acceptance Criteria
- [ ] Пользователь может зарегистрироваться с email и паролем
- [ ] Пользователь может войти с существующими учетными данными
- [ ] Пользователь может восстановить пароль
- [ ] Сессия сохраняется между запусками приложения
- [ ] Защищенные экраны недоступны без авторизации

## Technical Tasks
- [ ] Интеграция с Supabase Auth
- [ ] Создание экранов входа и регистрации
- [ ] Настройка защищенных маршрутов
- [ ] Обработка состояний авторизации
- [ ] Тестирование авторизации

## Story Points: 8" \
  --label "sprint-2" --label "story-points-8" --label "epic-auth" --label "high-priority"

gh issue create --title "US-007: Implement user profile" \
  --body "## User Story
Как пользователь, я хочу редактировать свои личные данные

## Acceptance Criteria
- [ ] Пользователь может просматривать свой профиль
- [ ] Пользователь может редактировать личные данные
- [ ] Данные сохраняются в Supabase
- [ ] Валидация форм работает корректно
- [ ] Изменения отображаются сразу

## Technical Tasks
- [ ] Создание экрана профиля
- [ ] Форма редактирования данных
- [ ] Интеграция с Supabase для хранения
- [ ] Валидация форм
- [ ] Тестирование профиля

## Story Points: 8" \
  --label "sprint-2" --label "story-points-8" --label "epic-profile" --label "high-priority"

gh issue create --title "US-008: Implement recipes menu" \
  --body "## User Story
Как пользователь, я хочу просматривать рецепты с фотографиями и описаниями

## Acceptance Criteria
- [ ] Отображается список рецептов с изображениями
- [ ] Каждый рецепт содержит название, описание, время приготовления
- [ ] Рецепты загружаются быстро
- [ ] Изображения кэшируются
- [ ] Есть индикатор загрузки

## Technical Tasks
- [ ] Создание экрана меню
- [ ] Интеграция с API рецептов
- [ ] Настройка кэширования изображений
- [ ] Создание виджетов для отображения рецептов
- [ ] Тестирование загрузки рецептов

## Story Points: 5" \
  --label "sprint-2" --label "story-points-5" --label "epic-menu" --label "high-priority"
```

### Шаг 3: Настройка базы данных (Сегодня - 20 минут)

#### 3.1 Подключение к Supabase
1. Перейти в [Supabase Dashboard](https://supabase.com/dashboard)
2. Выбрать проект NutryFlow
3. Перейти в SQL Editor

#### 3.2 Выполнение SQL скриптов
```sql
-- Создание таблиц для пользователей
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание таблиц для профилей
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES users(id),
  first_name TEXT,
  last_name TEXT,
  age INTEGER,
  weight DECIMAL,
  height DECIMAL,
  activity_level TEXT,
  dietary_preferences TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Создание таблиц для избранного
CREATE TABLE IF NOT EXISTS favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  recipe_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);

-- Создание индексов для производительности
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_recipe_id ON favorites(recipe_id);
```

### Шаг 4: Начало разработки (Сегодня - 2 часа)

#### 4.1 Создание структуры для авторизации
```bash
# Создание директорий для auth feature
mkdir -p lib/features/auth/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}

# Создание базовых файлов
touch lib/features/auth/data/datasources/auth_remote_data_source.dart
touch lib/features/auth/data/models/user_model.dart
touch lib/features/auth/data/repositories/auth_repository_impl.dart
touch lib/features/auth/domain/entities/user.dart
touch lib/features/auth/domain/repositories/auth_repository.dart
touch lib/features/auth/domain/usecases/login_usecase.dart
touch lib/features/auth/domain/usecases/register_usecase.dart
touch lib/features/auth/domain/usecases/logout_usecase.dart
touch lib/features/auth/presentation/bloc/auth_bloc.dart
touch lib/features/auth/presentation/pages/login_page.dart
touch lib/features/auth/presentation/pages/register_page.dart
touch lib/features/auth/presentation/widgets/auth_widgets.dart
```

#### 4.2 Создание базового AuthService
```dart
// lib/core/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response.user;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Stream<User?> get authStateChanges => _supabase.auth.onAuthStateChange
      .map((event) => event.session?.user);
}
```

#### 4.3 Создание User entity
```dart
// lib/features/auth/domain/entities/user.dart
class User {
  final String id;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
```

### Шаг 5: Тестирование (Сегодня - 30 минут)

#### 5.1 Создание тестов
```bash
# Создание тестов для auth
mkdir -p test/features/auth/{domain,data,presentation}
touch test/features/auth/domain/usecases/login_usecase_test.dart
touch test/features/auth/domain/usecases/register_usecase_test.dart
touch test/features/auth/data/repositories/auth_repository_test.dart
touch test/features/auth/presentation/bloc/auth_bloc_test.dart
```

#### 5.2 Запуск тестов
```bash
# Запуск всех тестов
flutter test

# Запуск тестов только для auth
flutter test test/features/auth/
```

## 🎯 Ожидаемые результаты сегодня

### ✅ К концу дня:
- [ ] Scrum автоматизация настроена и работает
- [ ] GitHub Issues созданы для Sprint 2
- [ ] База данных настроена в Supabase
- [ ] Базовая структура auth feature создана
- [ ] AuthService интегрирован с Supabase
- [ ] Первые тесты написаны и проходят

### 📊 Метрики:
- **Время на настройку**: < 3 часа
- **Количество созданных файлов**: ~20
- **Code coverage**: > 70% для auth
- **Готовность к завтрашнему дню**: 100%

## 🚨 Возможные проблемы и решения

### Проблема: Не удается подключиться к Supabase
**Решение**: Проверить URL и API ключи в конфигурации

### Проблема: GitHub token не работает
**Решение**: Создать новый token с правильными правами

### Проблема: Тесты не проходят
**Решение**: Проверить зависимости в pubspec.yaml

## 📞 Поддержка

Если возникнут проблемы:
1. Проверить документацию в `docs/scrum/scrum-master-setup-guide.md`
2. Запустить `python scripts/scrum_automation.py --help` для справки
3. Создать issue в GitHub для отслеживания проблем

---

**Создан**: [CURRENT_DATE]  
**Следующий обзор**: Завтра в 9:00 UTC  
**Статус**: ✅ Готов к выполнению 