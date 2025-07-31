# Sprint 2 Planning - NutryFlow

## 🎯 Sprint Goal
Реализовать авторизацию, профиль пользователя и базовый функционал меню с рецептами для создания полноценного MVP.

## 📊 Sprint Information
- **Sprint Number**: 2
- **Duration**: 2 недели (14 дней)
- **Start Date**: [START_DATE]
- **End Date**: [END_DATE]
- **Team Velocity**: 37 story points
- **Available Hours**: 80 часов

## 📋 Selected User Stories

### Epic 1: Авторизация и Профиль (16 points)

#### US-010: Авторизация (8 points)
**Как пользователь, я хочу безопасно входить в приложение**

**Acceptance Criteria:**
- [ ] Пользователь может зарегистрироваться с email и паролем
- [ ] Пользователь может войти с существующими учетными данными
- [ ] Пользователь может восстановить пароль
- [ ] Сессия сохраняется между запусками приложения
- [ ] Защищенные экраны недоступны без авторизации

**Technical Tasks:**
- [ ] Интеграция с Supabase Auth
- [ ] Создание экранов входа и регистрации
- [ ] Настройка защищенных маршрутов
- [ ] Обработка состояний авторизации
- [ ] Тестирование авторизации

#### US-007: Профиль пользователя (8 points)
**Как пользователь, я хочу редактировать свои личные данные**

**Acceptance Criteria:**
- [ ] Пользователь может просматривать свой профиль
- [ ] Пользователь может редактировать личные данные
- [ ] Данные сохраняются в Supabase
- [ ] Валидация форм работает корректно
- [ ] Изменения отображаются сразу

**Technical Tasks:**
- [ ] Создание экрана профиля
- [ ] Форма редактирования данных
- [ ] Интеграция с Supabase для хранения
- [ ] Валидация форм
- [ ] Тестирование профиля

### Epic 5: Меню и Рецепты (21 points)

#### US-008: Просмотр рецептов (5 points)
**Как пользователь, я хочу просматривать рецепты с фотографиями и описаниями**

**Acceptance Criteria:**
- [ ] Отображается список рецептов с изображениями
- [ ] Каждый рецепт содержит название, описание, время приготовления
- [ ] Рецепты загружаются быстро
- [ ] Изображения кэшируются
- [ ] Есть индикатор загрузки

**Technical Tasks:**
- [ ] Создание экрана меню
- [ ] Интеграция с API рецептов
- [ ] Настройка кэширования изображений
- [ ] Создание виджетов для отображения рецептов
- [ ] Тестирование загрузки рецептов

#### US-015: Поиск рецептов (8 points)
**Как пользователь, я хочу искать рецепты по ингредиентам**

**Acceptance Criteria:**
- [ ] Пользователь может ввести ингредиент для поиска
- [ ] Результаты поиска отображаются в реальном времени
- [ ] Поиск работает по названию и ингредиентам
- [ ] Есть возможность очистить поиск
- [ ] Пустые результаты обрабатываются корректно

**Technical Tasks:**
- [ ] Создание поискового интерфейса
- [ ] Интеграция поиска с API
- [ ] Реализация поиска в реальном времени
- [ ] Обработка пустых результатов
- [ ] Тестирование поиска

#### US-016: Избранное (3 points)
**Как пользователь, я хочу сохранять понравившиеся рецепты**

**Acceptance Criteria:**
- [ ] Пользователь может добавить рецепт в избранное
- [ ] Избранные рецепты отображаются в отдельном разделе
- [ ] Пользователь может удалить рецепт из избранного
- [ ] Избранное синхронизируется между устройствами

**Technical Tasks:**
- [ ] Создание системы избранного
- [ ] Интеграция с Supabase для хранения
- [ ] Создание экрана избранного
- [ ] Тестирование избранного

#### US-017: Фильтры (5 points)
**Как пользователь, я хочу фильтровать рецепты по диетическим предпочтениям**

**Acceptance Criteria:**
- [ ] Пользователь может выбрать диетические предпочтения
- [ ] Фильтры применяются к результатам поиска
- [ ] Можно комбинировать несколько фильтров
- [ ] Фильтры сохраняются между сессиями
- [ ] Есть возможность сбросить фильтры

**Technical Tasks:**
- [ ] Создание системы фильтров
- [ ] Интеграция фильтров с API
- [ ] Сохранение настроек фильтров
- [ ] Тестирование фильтров

## 🔧 Technical Implementation

### Архитектура

#### 1. Авторизация
```dart
// lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_data_source.dart
│   │   └── auth_local_data_source.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── logout_usecase.dart
└── presentation/
    ├── bloc/
    │   └── auth_bloc.dart
    ├── pages/
    │   ├── login_page.dart
    │   └── register_page.dart
    └── widgets/
        └── auth_widgets.dart
```

#### 2. Профиль
```dart
// lib/features/profile/
├── data/
│   ├── datasources/
│   │   └── profile_remote_data_source.dart
│   ├── models/
│   │   └── profile_model.dart
│   └── repositories/
│       └── profile_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── profile.dart
│   ├── repositories/
│   │   └── profile_repository.dart
│   └── usecases/
│       ├── get_profile_usecase.dart
│       └── update_profile_usecase.dart
└── presentation/
    ├── bloc/
    │   └── profile_bloc.dart
    ├── pages/
    │   └── profile_page.dart
    └── widgets/
        └── profile_widgets.dart
```

#### 3. Меню и рецепты
```dart
// lib/features/menu/
├── data/
│   ├── datasources/
│   │   └── recipes_remote_data_source.dart
│   ├── models/
│   │   └── recipe_model.dart
│   └── repositories/
│       └── recipes_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── recipe.dart
│   ├── repositories/
│   │   └── recipes_repository.dart
│   └── usecases/
│       ├── get_recipes_usecase.dart
│       ├── search_recipes_usecase.dart
│       └── toggle_favorite_usecase.dart
└── presentation/
    ├── bloc/
    │   └── menu_bloc.dart
    ├── pages/
    │   ├── menu_page.dart
    │   ├── recipe_detail_page.dart
    │   └── favorites_page.dart
    └── widgets/
        ├── recipe_card.dart
        ├── search_bar.dart
        └── filters_widget.dart
```

### API Integration

#### 1. Supabase Auth
```dart
// lib/core/services/auth_service.dart
class AuthService {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> get authStateChanges;
}
```

#### 2. Recipes API
```dart
// lib/core/services/recipes_service.dart
class RecipesService {
  Future<List<Recipe>> getRecipes();
  Future<List<Recipe>> searchRecipes(String query);
  Future<List<Recipe>> getRecipesByFilters(List<String> filters);
  Future<Recipe> getRecipeById(String id);
}
```

### Database Schema

#### 1. Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 2. Profiles Table
```sql
CREATE TABLE profiles (
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
```

#### 3. Favorites Table
```sql
CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  recipe_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, recipe_id)
);
```

## 📊 Sprint Backlog

### Неделя 1: Авторизация и профиль

#### День 1-2: Настройка авторизации
- [ ] Интеграция с Supabase Auth
- [ ] Создание экранов входа и регистрации
- [ ] Настройка защищенных маршрутов

#### День 3-4: Тестирование авторизации
- [ ] Обработка состояний авторизации
- [ ] Тестирование авторизации
- [ ] Исправление багов

#### День 5-7: Профиль пользователя
- [ ] Создание экрана профиля
- [ ] Форма редактирования данных
- [ ] Интеграция с Supabase для хранения

### Неделя 2: Меню и рецепты

#### День 8-10: Базовый функционал меню
- [ ] Создание экрана меню
- [ ] Интеграция с API рецептов
- [ ] Настройка кэширования изображений

#### День 11-12: Поиск и фильтры
- [ ] Создание поискового интерфейса
- [ ] Реализация поиска в реальном времени
- [ ] Создание системы фильтров

#### День 13-14: Избранное и тестирование
- [ ] Создание системы избранного
- [ ] Тестирование всего функционала
- [ ] Исправление багов

## 🎯 Definition of Done

### Для каждой User Story:
- [ ] Код написан и протестирован
- [ ] Unit тесты покрывают новый функционал (>80%)
- [ ] Код прошел code review
- [ ] Документация обновлена
- [ ] Функция протестирована на устройстве
- [ ] Нет критических дефектов
- [ ] Соответствует требованиям UX/UI

### Для Sprint:
- [ ] Все задачи Sprint Backlog выполнены
- [ ] Sprint Goal достигнута
- [ ] Демо подготовлено
- [ ] Документация актуальна
- [ ] Нет блокирующих дефектов

## 📈 Sprint Metrics Tracking

### Планируемые метрики:
- **Velocity**: 37 story points
- **Sprint Goal Achievement**: 100%
- **Defect Rate**: < 10%
- **Code Coverage**: > 80%

### Burndown Chart:
- **Total Points**: 37
- **Daily Target**: 2.6 points/day
- **Risk Level**: Medium

## 🚨 Риски и митигация

### Высокие риски:
1. **Сложность интеграции с API рецептов**
   - Митигация: Исследование API заранее, создание mock данных

2. **Производительность с большими списками**
   - Митигация: Lazy loading, пагинация, кэширование

### Средние риски:
1. **Сложность авторизации**
   - Митигация: Использование готовых решений Supabase

2. **Валидация форм**
   - Митигация: Использование проверенных библиотек

## 📞 Команда и контакты

### Роли в Sprint 2:
- **Scrum Master**: [ВАШ_ИМЯ] - управление процессами
- **Developer Agent**: AI Assistant - разработка
- **Product Owner**: [PO_ИМЯ] - приоритизация

### Каналы коммуникации:
- **Daily Standup**: Ежедневно в 9:00 UTC
- **Sprint Review**: [END_DATE] в 15:00 UTC
- **Sprint Retrospective**: [END_DATE] в 16:00 UTC

---

**Версия**: 1.0  
**Создан**: [CURRENT_DATE]  
**Следующий обзор**: [END_DATE] 