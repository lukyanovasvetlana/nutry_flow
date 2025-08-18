#!/bin/bash

# Скрипт настройки Git hooks для автоматической очистки кода
# Автор: AI Assistant
# Дата: $(date)

echo "🔧 Настройка Git hooks для автоматической очистки кода..."
echo "=========================================================="

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для логирования
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверяем, что мы в корневой директории проекта
if [ ! -f "pubspec.yaml" ]; then
    error "Скрипт должен быть запущен из корневой директории проекта"
    exit 1
fi

# Проверяем, что это Git репозиторий
if [ ! -d ".git" ]; then
    error "Git репозиторий не найден. Сначала инициализируйте Git:"
    echo "  git init"
    echo "  git add ."
    echo "  git commit -m 'Initial commit'"
    exit 1
fi

# Создаем директорию для hooks если её нет
HOOKS_DIR=".git/hooks"
if [ ! -d "$HOOKS_DIR" ]; then
    mkdir -p "$HOOKS_DIR"
    log "Создана директория $HOOKS_DIR"
fi

# Шаг 1: Настройка pre-commit хука
log "Шаг 1: Настройка pre-commit хука..."
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"

if [ -f "scripts/pre-commit" ]; then
    cp "scripts/pre-commit" "$PRE_COMMIT_HOOK"
    chmod +x "$PRE_COMMIT_HOOK"
    log "Pre-commit хук установлен"
else
    error "Файл scripts/pre-commit не найден"
    exit 1
fi

# Шаг 2: Настройка pre-push хука
log "Шаг 2: Настройка pre-push хука..."
PRE_PUSH_HOOK="$HOOKS_DIR/pre-push"

cat > "$PRE_PUSH_HOOK" << 'EOF'
#!/bin/bash

# Pre-push хук для проверки качества кода перед отправкой
# Автор: AI Assistant

echo "🔍 Pre-push: Финальная проверка качества кода..."

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[PRE-PUSH]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[PRE-PUSH]${NC} $1"
}

error() {
    echo -e "${RED}[PRE-PUSH]${NC} $1"
}

# Проверяем, что мы в корневой директории проекта
if [ ! -f "pubspec.yaml" ]; then
    error "Pre-push хук должен быть запущен из корневой директории проекта"
    exit 1
fi

# Анализ кода
log "Анализ кода..."
ANALYSIS_OUTPUT=$(flutter analyze --no-fatal-infos 2>&1)
ISSUES_COUNT=$(echo "$ANALYSIS_OUTPUT" | grep -c "issues found" || echo "0")

if [ "$ISSUES_COUNT" -gt 0 ]; then
    warn "Найдено $ISSUES_COUNT проблем в коде"
    
    # Показываем критические проблемы
    CRITICAL_ISSUES=$(echo "$ANALYSIS_OUTPUT" | grep -E "(error|unused_import|unused_element|unused_field)" | head -10)
    if [ ! -z "$CRITICAL_ISSUES" ]; then
        echo ""
        warn "Критические проблемы:"
        echo "$CRITICAL_ISSUES"
        echo ""
        
        # Спрашиваем пользователя, хочет ли он продолжить
        read -p "Найдены критические проблемы. Продолжить push? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            error "Push отменен. Исправьте проблемы и попробуйте снова."
            exit 1
        fi
    fi
else
    log "Проблем в коде не найдено"
fi

# Запуск тестов
log "Запуск тестов..."
flutter test --no-pub --reporter=compact
if [ $? -ne 0 ]; then
    error "Тесты не прошли. Push отменен."
    exit 1
fi

log "Pre-push проверка завершена успешно! ✅"
exit 0
EOF

chmod +x "$PRE_PUSH_HOOK"
log "Pre-push хук установлен"

# Шаг 3: Настройка commit-msg хука
log "Шаг 3: Настройка commit-msg хука..."
COMMIT_MSG_HOOK="$HOOKS_DIR/commit-msg"

cat > "$COMMIT_MSG_HOOK" << 'EOF'
#!/bin/bash

# Commit-msg хук для проверки сообщений коммитов
# Автор: AI Assistant

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[COMMIT-MSG]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[COMMIT-MSG]${NC} $1"
}

error() {
    echo -e "${RED}[COMMIT-MSG]${NC} $1"
}

# Проверяем длину сообщения
if [ ${#COMMIT_MSG} -gt 72 ]; then
    warn "Сообщение коммита слишком длинное (${#COMMIT_MSG} символов)"
    warn "Рекомендуется не более 72 символов"
fi

# Проверяем формат сообщения
if [[ ! "$COMMIT_MSG" =~ ^(feat|fix|docs|style|refactor|test|chore|ci|build|perf|revert)(\(.+\))?: ]]; then
    warn "Сообщение коммита не соответствует conventional commits формату"
    warn "Примеры: feat: add new feature, fix: resolve bug, docs: update documentation"
fi

# Проверяем наличие описания
if [[ ! "$COMMIT_MSG" =~ $'\n' ]]; then
    warn "Рекомендуется добавить описание коммита после пустой строки"
fi

log "Commit-msg проверка завершена"
exit 0
EOF

chmod +x "$COMMIT_MSG_HOOK"
log "Commit-msg хук установлен"

# Шаг 4: Настройка post-merge хука
log "Шаг 4: Настройка post-merge хука..."
POST_MERGE_HOOK="$HOOKS_DIR/post-merge"

cat > "$POST_MERGE_HOOK" << 'EOF'
#!/bin/bash

# Post-merge хук для автоматической очистки после слияния
# Автор: AI Assistant

echo "🔄 Post-merge: Автоматическая очистка после слияния..."

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[POST-MERGE]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[POST-MERGE]${NC} $1"
}

# Проверяем, что мы в корневой директории проекта
if [ ! -f "pubspec.yaml" ]; then
    warn "Post-merge хук должен быть запущен из корневой директории проекта"
    exit 0
fi

# Обновляем зависимости
log "Обновление зависимостей..."
flutter pub get

# Анализируем код
log "Анализ кода после слияния..."
flutter analyze --no-fatal-infos | head -10

log "Post-merge очистка завершена"
exit 0
EOF

chmod +x "$POST_MERGE_HOOK"
log "Post-merge хук установлен"

# Шаг 5: Создание конфигурационного файла
log "Шаг 5: Создание конфигурационного файла..."
CONFIG_FILE=".git-hooks-config"

cat > "$CONFIG_FILE" << 'EOF'
# Конфигурация Git hooks для NutryFlow
# Автор: AI Assistant

# Включенные хуки
ENABLED_HOOKS=(
    "pre-commit"    # Проверка качества кода перед коммитом
    "pre-push"      # Финальная проверка перед отправкой
    "commit-msg"    # Проверка сообщений коммитов
    "post-merge"    # Автоматическая очистка после слияния
)

# Настройки анализа кода
ANALYSIS_SETTINGS=(
    "unused_import: error"      # Ошибка для неиспользуемых импортов
    "unused_element: error"     # Ошибка для неиспользуемых элементов
    "unused_field: error"       # Ошибка для неиспользуемых полей
    "unused_local_variable: error" # Ошибка для неиспользуемых переменных
)

# Настройки тестирования
TEST_SETTINGS=(
    "run_tests: true"           # Запускать тесты
    "test_coverage: false"      # Проверять покрытие тестами
    "fail_on_test_failure: true" # Отменять коммит при неудаче тестов
)

# Настройки сборки
BUILD_SETTINGS=(
    "check_build: true"         # Проверять сборку
    "fail_on_build_failure: false" # Не отменять коммит при неудаче сборки
)

# Автоматические исправления
AUTO_FIXES=(
    "format_code: true"         # Автоматически форматировать код
    "fix_imports: true"         # Автоматически исправлять импорты
    "add_fixed_files: true"     # Добавлять исправленные файлы в коммит
)
EOF

log "Конфигурационный файл создан: $CONFIG_FILE"

# Шаг 6: Создание README для hooks
log "Шаг 6: Создание README для hooks..."
README_FILE="docs/git-hooks-setup.md"

mkdir -p "docs"

cat > "$README_FILE" << 'EOF'
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
EOF

log "README создан: $README_FILE"

# Шаг 7: Проверка установки
log "Шаг 7: Проверка установки..."
echo ""
echo "Установленные хуки:"
ls -la "$HOOKS_DIR" | grep -E "(pre-commit|pre-push|commit-msg|post-merge)"

# Финальное сообщение
echo ""
echo "=========================================================="
echo "🎉 Git hooks успешно настроены!"
echo "=========================================================="
echo ""
echo "📋 Установленные хуки:"
echo "  ✅ pre-commit    - Проверка перед коммитом"
echo "  ✅ pre-push      - Проверка перед отправкой"
echo "  ✅ commit-msg    - Проверка сообщений коммитов"
echo "  ✅ post-merge    - Очистка после слияния"
echo ""
echo "📁 Файлы:"
echo "  📄 .git-hooks-config    - Конфигурация хуков"
echo "  📄 docs/git-hooks-setup.md - Документация"
echo "  📄 scripts/pre-commit   - Pre-commit хук"
echo ""
echo "🚀 Теперь при каждом коммите код будет автоматически:"
echo "  • Форматироваться"
echo "  • Проверяться на качество"
echo "  • Очищаться от неиспользуемого кода"
echo "  • Тестироваться"
echo ""
echo "💡 Следующие шаги:"
echo "  1. Сделайте тестовый коммит: git commit -m 'test: test hooks'"
echo "  2. Проверьте работу хуков"
echo "  3. Настройте CI/CD pipeline"
echo "  4. Интегрируйте с IDE"
echo ""
echo "Спасибо за использование автоматической очистки кода! 🧹✨"
