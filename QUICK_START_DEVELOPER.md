# 🚀 Быстрое Подключение Разработчика - NutryFlow

## ⚡ Экспресс-настройка (5 минут)

### 1. Клонирование и настройка

```bash
# Клонируйте репозиторий
git clone https://github.com/your-org/nutry_flow.git
cd nutry_flow

# Запустите автоматическую настройку
./scripts/setup_developer_environment.sh
```

### 2. Заполните переменные окружения

Отредактируйте файл `.env`:

```bash
# Получите эти значения у Tech Lead или в документации проекта
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
FIREBASE_PROJECT_ID=your_firebase_project
MIXPANEL_TOKEN=your_mixpanel_token
```

### 3. Настройте сервисы

```bash
# Supabase
supabase login
supabase link --project-ref your_project_ref

# Firebase
firebase login
firebase use your_project_id
```

### 4. Запустите приложение

```bash
# Запуск на эмуляторе/устройстве
flutter run

# Или запуск в режиме профилирования
flutter run --profile
```

## 📋 Чек-лист готовности

- [ ] Репозиторий склонирован
- [ ] Скрипт настройки выполнен успешно
- [ ] `.env` файл заполнен
- [ ] Supabase подключен
- [ ] Firebase настроен
- [ ] Приложение запускается без ошибок
- [ ] Тесты проходят: `flutter test`

## 🛠️ Основные команды

```bash
# Разработка
flutter run                    # Запуск приложения
flutter run --hot             # Горячая перезагрузка
flutter run --profile         # Режим профилирования

# Тестирование
flutter test                  # Все тесты
flutter test --coverage       # С покрытием
flutter test test/features/   # Конкретная папка

# Анализ кода
flutter analyze               # Анализ кода
flutter format lib/           # Форматирование
dart fix --apply              # Автоисправления

# Сборка
flutter build apk             # Android APK
flutter build appbundle       # Android Bundle
flutter build ios             # iOS (только macOS)

# Генерация кода
flutter packages pub run build_runner build
flutter packages pub run build_runner watch
```

## 📚 Документация

- **Полное руководство**: `docs/developer-onboarding-guide.md`
- **Стандарты кодирования**: `docs/development-guidelines.md`
- **Архитектура**: `docs/architecture.md`
- **Scrum процессы**: `docs/scrum/`

## 🆘 Получение помощи

### Внутренние ресурсы
- **Slack**: #nutryflow-dev
- **Discord**: #development
- **Email**: dev-team@company.com

### Контакты команды
- **Tech Lead**: [tech.lead@company.com]
- **Scrum Master**: [scrum.master@company.com]

## 🎯 Первые задачи

1. **Изучите архитектуру**: Прочитайте `docs/development-guidelines.md`
2. **Запустите приложение**: Убедитесь, что все работает
3. **Напишите тест**: Создайте простой unit test
4. **Создайте ветку**: `git checkout -b feature/your-first-task`
5. **Начните работу**: Выберите задачу из GitHub Issues

## 🚨 Частые проблемы

### Проблема: Flutter не найден
```bash
# Решение для macOS
brew install --cask flutter

# Решение для Linux
# Следуйте инструкциям на flutter.dev
```

### Проблема: iOS зависимости не устанавливаются
```bash
# Обновите CocoaPods
sudo gem install cocoapods
cd ios && pod install && cd ..
```

### Проблема: Android licenses
```bash
flutter doctor --android-licenses
```

### Проблема: Supabase не подключается
```bash
# Проверьте .env файл
# Убедитесь, что supabase login выполнен
supabase status
```

---

**Время настройки**: ~5 минут  
**Версия**: 1.0  
**Поддержка**: dev-team@company.com
