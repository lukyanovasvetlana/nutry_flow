# Настройка Git Hooks для автоматической очистки кода

## 🎯 Обзор

Этот документ описывает настройку Git hooks для автоматической очистки и проверки качества кода в проекте NutryFlow.

## 🔧 Установленные хуки

### 1. **pre-commit** - Проверка перед коммитом
- Автоматическое исправление форматирования
- Автоматическое исправление импортов
- Анализ кода на наличие проблем
- Запуск тестов
- Проверка сборки

### 2. **pre-push** - Проверка перед отправкой
- Финальная проверка качества кода
- Запуск всех тестов
- Блокировка push при наличии критических проблем

### 3. **commit-msg** - Проверка сообщений коммитов
- Проверка длины сообщения
- Проверка формата (conventional commits)
- Рекомендации по улучшению

### 4. **post-merge** - Очистка после слияния
- Обновление зависимостей
- Анализ кода после слияния

## 🚀 Установка

### Автоматическая установка
```bash
# Запустите скрипт настройки
chmod +x scripts/setup_git_hooks.sh
./scripts/setup_git_hooks.sh
```

### Ручная установка
```bash
# Скопируйте хуки в .git/hooks/
cp scripts/pre-commit .git/hooks/
cp scripts/pre-commit .git/hooks/pre-push
chmod +x .git/hooks/*
```

## ⚙️ Конфигурация

Настройки хуков находятся в файле `.git-hooks-config`:

```yaml
# Включенные хуки
ENABLED_HOOKS=(
    "pre-commit"
    "pre-push"
    "commit-msg"
    "post-merge"
)

# Настройки анализа
ANALYSIS_SETTINGS=(
    "unused_import: error"
    "unused_element: error"
    "unused_field: error"
)
```

## 🔍 Использование

### Обычная работа
Хуки работают автоматически при выполнении Git команд:

```bash
git add .
git commit -m "feat: add new feature"  # Запускает pre-commit
git push origin main                    # Запускает pre-push
```

### Пропуск хуков (не рекомендуется)
```bash
git commit --no-verify -m "skip hooks"
git push --no-verify
```

## 🛠️ Настройка IDE

### VS Code
Добавьте в `settings.json`:

```json
{
    "dart.analysisServerFolding": true,
    "dart.analysisServerFoldingOutline": true,
    "dart.lineLength": 80,
    "dart.enableSdkFormatter": true,
    "dart.enableSdkFormatter": true
}
```

### Android Studio / IntelliJ
1. Включите Dart Analysis
2. Настройте Code Style
3. Включите Auto Import

## 📊 Мониторинг

### Отчеты о качестве
```bash
# Анализ кода
flutter analyze

# Запуск тестов
flutter test

# Проверка покрытия
flutter test --coverage
```

### Логи хуков
Хуки выводят информацию в консоль:
- ✅ Успешные операции
- ⚠️ Предупреждения
- ❌ Ошибки

## 🚨 Устранение проблем

### Хук не работает
1. Проверьте права доступа: `chmod +x .git/hooks/*`
2. Убедитесь, что файл существует: `ls -la .git/hooks/`
3. Проверьте синтаксис: `bash -n .git/hooks/pre-commit`

### Ложные срабатывания
1. Настройте исключения в `analysis_options.yaml`
2. Используйте `// ignore: rule_name` для конкретных случаев
3. Отключите правило в конфигурации

### Производительность
1. Исключите генерируемые файлы
2. Настройте кэширование анализа
3. Используйте параллельные тесты

## 🔄 Обновление

Для обновления хуков:

```bash
# Обновите скрипты
git pull origin main

# Переустановите хуки
./scripts/setup_git_hooks.sh
```

## 📚 Дополнительные ресурсы

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Flutter Lints](https://dart.dev/tools/linter-rules)
- [Dart Analysis](https://dart.dev/guides/language/analysis-options)

## 🤝 Поддержка

При возникновении проблем:

1. Проверьте логи хуков
2. Убедитесь в корректности конфигурации
3. Обратитесь к команде разработки
4. Создайте issue в репозитории

---

*Документ обновлен: $(date)*
