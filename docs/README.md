# NutryFlow - Документация

## 📱 О проекте

NutryFlow - это комплексное мобильное приложение для управления питанием и здоровым образом жизни, предназначенное для спортсменов и людей, стремящихся вести здоровый образ жизни. Приложение объединяет контроль питания (ЖБУ, калории), водного баланса и физической активности в одном месте.

## 🏗️ Архитектура

Проект использует современную архитектуру:
- **Feature-First Architecture** - модульная структура по функциональным возможностям
- **Clean Architecture** - разделение на слои (presentation, domain, data)
- **BLoC Pattern** - для управления состоянием
- **Supabase** - для бэкенда и аутентификации
- **Firebase** - для аналитики и уведомлений

## 📚 Документация

### Основные документы
- [**Бриф проекта**](project-brief.md) - описание проблемы, целей и целевой аудитории
- [**PRD**](prd.md) - детальные требования к продукту
- [**Архитектурный план**](architecture.md) - общая архитектура системы
- [**Дизайн-система**](design-system.md) - UI/UX компоненты и стили

### Техническая документация
- [**Техническая спецификация**](technical-specification.md) - детальное описание технической реализации
- [**Руководство по разработке**](development-guidelines.md) - стандарты кодирования и лучшие практики
- [**Документация API**](api-documentation.md) - описание всех эндпоинтов и интеграций
- [**Руководство по развертыванию**](deployment-guide.md) - инструкции по деплою и CI/CD

### Пользовательские истории и эпики
- [**Пользовательские истории**](stories/) - детальные сценарии использования
- [**Эпики**](epics/) - группировка функциональности по эпикам

## 🚀 Быстрый старт

### Предварительные требования
- Flutter 3.2.3+
- Dart 3.0+
- Android Studio / VS Code
- Git

### Установка и запуск

1. **Клонирование репозитория**
```bash
git clone https://github.com/your-username/nutry_flow.git
cd nutry_flow
```

2. **Установка зависимостей**
```bash
flutter pub get
```

3. **Настройка переменных окружения**
```bash
# Скопируйте файл конфигурации
cp .env.example .env

# Отредактируйте .env файл с вашими настройками
# SUPABASE_URL=your-supabase-url
# SUPABASE_ANON_KEY=your-supabase-anon-key
```

4. **Запуск приложения**
```bash
# Для разработки
flutter run

# Для продакшена
flutter run --release
```

### Настройка Supabase

1. Создайте проект на [supabase.com](https://supabase.com)
2. Выполните SQL скрипты из [руководства по развертыванию](deployment-guide.md)
3. Настройте Row Level Security (RLS)
4. Разверните Edge Functions

### Настройка Firebase

1. Создайте проект на [firebase.google.com](https://firebase.google.com)
2. Добавьте приложения для iOS и Android
3. Скачайте конфигурационные файлы:
   - `google-services.json` для Android
   - `GoogleService-Info.plist` для iOS

## 🧪 Тестирование

### Запуск тестов
```bash
# Unit тесты
flutter test

# Widget тесты
flutter test test/widget_test.dart

# Интеграционные тесты
flutter test integration_test/
```

### Анализ кода
```bash
# Линтинг
flutter analyze

# Форматирование
flutter format lib/
```

## 📱 Сборка

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle для Play Store
flutter build appbundle --release
```

### iOS
```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

## 🏗️ Структура проекта

```
lib/
├── core/                    # Общие компоненты
│   ├── config/             # Конфигурация
│   ├── error/              # Обработка ошибок
│   ├── network/            # Сетевые запросы
│   ├── storage/            # Локальное хранилище
│   └── utils/              # Утилиты
├── features/               # Функциональные модули
│   ├── auth/              # Аутентификация
│   ├── nutrition/         # Управление питанием
│   ├── water/             # Водный баланс
│   ├── activity/          # Физическая активность
│   └── profile/           # Профиль пользователя
├── shared/                # Общие компоненты
│   ├── widgets/           # Общие виджеты
│   ├── models/            # Общие модели
│   └── services/          # Общие сервисы
└── main.dart              # Точка входа
```

## 🔧 Разработка

### Добавление новой функциональности

1. **Создайте feature модуль**
```bash
mkdir lib/features/new_feature
mkdir lib/features/new_feature/{data,domain,presentation}
```

2. **Следуйте Clean Architecture**
- `data/` - источники данных и репозитории
- `domain/` - бизнес-логика и use cases
- `presentation/` - UI и BLoC

3. **Добавьте тесты**
```bash
mkdir test/features/new_feature
touch test/features/new_feature/new_feature_test.dart
```

### Стандарты кодирования

- Следуйте [руководству по разработке](development-guidelines.md)
- Используйте BLoC для управления состоянием
- Пишите тесты для всех компонентов
- Документируйте публичные API

## 📊 Мониторинг и аналитика

### Firebase Analytics
- Отслеживание пользовательских событий
- Анализ производительности
- Отчеты о сбоях

### Supabase
- Мониторинг базы данных
- Логи Edge Functions
- Анализ производительности запросов

## 🔒 Безопасность

- JWT токены для аутентификации
- Row Level Security (RLS) в базе данных
- Шифрование локальных данных
- Безопасное хранение секретов

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте feature ветку
3. Внесите изменения
4. Добавьте тесты
5. Создайте Pull Request

### Чек-лист для PR
- [ ] Код соответствует стандартам
- [ ] Добавлены тесты
- [ ] Обновлена документация
- [ ] Все тесты проходят
- [ ] Код проанализирован линтером

## 📞 Поддержка

- **Issues**: [GitHub Issues](https://github.com/your-username/nutry_flow/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/nutry_flow/discussions)
- **Email**: support@nutryflow.com

## 📄 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для деталей.

## 🙏 Благодарности

- [Flutter](https://flutter.dev) - за отличный фреймворк
- [Supabase](https://supabase.com) - за бэкенд как сервис
- [Firebase](https://firebase.google.com) - за аналитику и уведомления
- [Material Design](https://material.io) - за дизайн-систему

---

**NutryFlow** - Ваш персональный помощник в достижении целей здорового образа жизни! 🏃‍♂️💪🥗 