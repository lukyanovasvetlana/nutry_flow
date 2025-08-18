# Руководство по Подключению Разработчика - NutryFlow

## 🚀 Быстрый старт для разработчика

### Предварительные требования

1. **Flutter SDK** (версия 3.16.0 или выше)
2. **Dart SDK** (версия 3.2.0 или выше)
3. **Android Studio** или **VS Code** с Flutter extension
4. **Git** (версия 2.30.0 или выше)
5. **Node.js** (версия 18.0.0 или выше) - для Supabase CLI

### Шаг 1: Клонирование репозитория

```bash
# Клонируйте репозиторий
git clone https://github.com/your-org/nutry_flow.git
cd nutry_flow

# Переключитесь на основную ветку
git checkout main
```

### Шаг 2: Настройка Flutter

```bash
# Проверьте версию Flutter
flutter --version

# Убедитесь, что все зависимости установлены
flutter doctor

# Если есть проблемы, выполните:
flutter doctor --android-licenses
```

### Шаг 3: Установка зависимостей

```bash
# Установите зависимости Flutter
flutter pub get

# Установите зависимости для iOS (если работаете на macOS)
cd ios && pod install && cd ..

# Установите Supabase CLI
npm install -g supabase
```

### Шаг 4: Настройка переменных окружения

Создайте файл `.env` в корне проекта:

```bash
# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key

# Firebase Configuration (для аналитики и push-уведомлений)
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_ANDROID_APP_ID=your_firebase_android_app_id
FIREBASE_IOS_APP_ID=your_firebase_ios_app_id

# Analytics Configuration
MIXPANEL_TOKEN=your_mixpanel_token
```

### Шаг 5: Настройка Supabase

```bash
# Войдите в Supabase
supabase login

# Свяжите проект с локальной разработкой
supabase link --project-ref your_project_ref

# Примените миграции
supabase db push
```

### Шаг 6: Настройка Firebase

```bash
# Установите Firebase CLI
npm install -g firebase-tools

# Войдите в Firebase
firebase login

# Инициализируйте проект
firebase init
```

## 🛠️ Настройка среды разработки

### VS Code (Рекомендуется)

Установите следующие расширения:

```json
{
  "extensions": [
    "Dart-Code.dart-code",
    "Dart-Code.flutter",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-typescript-next",
    "GitHub.copilot",
    "GitHub.copilot-chat"
  ]
}
```

### Android Studio

1. Установите Flutter и Dart plugins
2. Настройте Android SDK
3. Создайте Android Virtual Device (AVD)

### Настройка эмуляторов

```bash
# Список доступных эмуляторов
flutter emulators

# Запуск эмулятора
flutter emulators --launch <emulator_id>

# Или для iOS (только на macOS)
open -a Simulator
```

## 🏗️ Архитектура проекта

### Структура папок

```
lib/
├── app.dart                 # Главный файл приложения
├── main.dart               # Точка входа
├── config/                 # Конфигурация
├── core/                   # Общие компоненты
│   ├── error/             # Обработка ошибок
│   └── services/          # Общие сервисы
├── features/              # Функциональные модули
│   ├── auth/             # Аутентификация
│   ├── onboarding/       # Онбординг
│   ├── dashboard/        # Дашборд
│   ├── nutrition/        # Питание
│   ├── activity/         # Активность
│   └── profile/          # Профиль
├── shared/               # Общие компоненты
│   ├── design/           # Дизайн-система
│   ├── theme/            # Темы
│   └── widgets/          # Общие виджеты
└── screens/              # Дополнительные экраны
```

### Принципы архитектуры

1. **Clean Architecture**: Разделение на слои (presentation, domain, data)
2. **Feature-First**: Организация по функциональным возможностям
3. **BLoC Pattern**: Управление состоянием
4. **Dependency Injection**: Использование GetIt

## 🧪 Тестирование

### Запуск тестов

```bash
# Все тесты
flutter test

# Конкретный тест
flutter test test/features/auth/auth_bloc_test.dart

# Тесты с покрытием
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Типы тестов

1. **Unit Tests**: Тестирование отдельных компонентов
2. **Widget Tests**: Тестирование UI компонентов
3. **Integration Tests**: Тестирование полных сценариев
4. **Golden Tests**: Тестирование визуальных изменений

## 📱 Запуск приложения

### Режим разработки

```bash
# Запуск на подключенном устройстве
flutter run

# Запуск с горячей перезагрузкой
flutter run --hot

# Запуск в режиме профилирования
flutter run --profile
```

### Сборка для продакшена

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔧 Инструменты разработки

### Линтинг и форматирование

```bash
# Форматирование кода
flutter format lib/

# Анализ кода
flutter analyze

# Исправление проблем
dart fix --apply
```

### Генерация кода

```bash
# Генерация кода для BLoC
flutter packages pub run build_runner build

# Генерация с удалением старых файлов
flutter packages pub run build_runner build --delete-conflicting-outputs

# Генерация в режиме наблюдения
flutter packages pub run build_runner watch
```

## 📋 Рабочий процесс Git

### Создание новой ветки

```bash
# Создание feature ветки
git checkout -b feature/nutrition-tracking

# Создание bugfix ветки
git checkout -b bugfix/calorie-calculation

# Создание hotfix ветки
git checkout -b hotfix/critical-auth-issue
```

### Commit сообщения

```bash
# Новый функционал
git commit -m "feat: добавить отслеживание воды"

# Исправление бага
git commit -m "fix: исправить расчет калорий"

# Документация
git commit -m "docs: обновить README"

# Рефакторинг
git commit -m "refactor: улучшить архитектуру BLoC"

# Тесты
git commit -m "test: добавить тесты для NutritionBloc"
```

### Pull Request процесс

1. Создайте ветку для новой функциональности
2. Внесите изменения и закоммитьте
3. Отправьте ветку в репозиторий
4. Создайте Pull Request
5. Пройдите code review
6. После одобрения выполните merge

## 🚨 Отладка

### Логи Flutter

```bash
# Подробные логи
flutter run --verbose

# Логи только ошибок
flutter run --verbose --no-sound-null-safety
```

### Отладка в VS Code

1. Откройте файл для отладки
2. Установите breakpoints
3. Нажмите F5 для запуска отладки
4. Используйте Debug Console для инспекции переменных

### Отладка сетевых запросов

```bash
# Charles Proxy (для macOS)
# Fiddler (для Windows)
# Burp Suite (кроссплатформенный)
```

## 📚 Полезные ресурсы

### Документация

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [BLoC Documentation](https://bloclibrary.dev/)
- [GetIt Documentation](https://pub.dev/packages/get_it)

### Инструменты

- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector)
- [Flutter Performance](https://docs.flutter.dev/development/tools/devtools/performance)
- [Flutter Memory](https://docs.flutter.dev/development/tools/devtools/memory)

### Сообщество

- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

## 🆘 Получение помощи

### Внутренние ресурсы

1. **Документация проекта**: `/docs/`
2. **Руководство по разработке**: `/docs/development-guidelines.md`
3. **Scrum Master Guide**: `/docs/scrum/scrum-master-setup-guide.md`

### Контакты команды

- **Tech Lead**: [tech.lead@company.com]
- **Scrum Master**: [scrum.master@company.com]
- **Product Owner**: [product.owner@company.com]

### Каналы коммуникации

- **Slack**: #nutryflow-dev
- **Discord**: #development
- **Email**: dev-team@company.com

## ✅ Чек-лист готовности

Перед началом работы убедитесь, что:

- [ ] Flutter SDK установлен и настроен
- [ ] Все зависимости установлены (`flutter pub get`)
- [ ] Переменные окружения настроены
- [ ] Supabase подключен и миграции применены
- [ ] Firebase настроен
- [ ] Эмулятор/устройство готово
- [ ] Приложение запускается без ошибок
- [ ] Тесты проходят успешно
- [ ] Линтинг не показывает ошибок
- [ ] Git настроен и работает
- [ ] Доступ к репозиторию получен

## 🎯 Следующие шаги

1. **Изучите архитектуру**: Прочитайте `/docs/development-guidelines.md`
2. **Познакомьтесь с кодом**: Изучите основные файлы в `/lib/`
3. **Запустите приложение**: Убедитесь, что все работает
4. **Напишите первый тест**: Создайте простой unit test
5. **Создайте первую ветку**: Начните работу над задачей

---

**Версия**: 1.0  
**Последнее обновление**: [DATE]  
**Следующий обзор**: [NEXT_REVIEW_DATE]
