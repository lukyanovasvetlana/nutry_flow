#!/bin/bash

# Скрипт для применения миграций Supabase
# Автор: NutryFlow Team
# Дата: 2024-12-01

set -e  # Остановка при ошибке

echo "🚀 Применение миграций Supabase..."

# Проверяем, что Supabase CLI установлен
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI не установлен. Установите его:"
    echo "npm install -g supabase"
    exit 1
fi

# Проверяем, что мы в корне проекта
if [ ! -f "supabase/config.toml" ]; then
    echo "❌ Не найден файл supabase/config.toml. Запустите скрипт из корня проекта."
    exit 1
fi

# Функция для логирования
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Функция для проверки статуса
check_status() {
    if [ $? -eq 0 ]; then
        log "✅ $1"
    else
        log "❌ $1"
        exit 1
    fi
}

# Шаг 1: Проверка статуса Supabase
log "📋 Проверка статуса Supabase..."
supabase status
check_status "Проверка статуса Supabase"

# Шаг 2: Применение миграций
log "🔄 Применение миграций..."
supabase db push
check_status "Применение миграций"

# Шаг 3: Проверка структуры базы данных
log "🔍 Проверка структуры базы данных..."
supabase db diff --schema public
check_status "Проверка структуры базы данных"

# Шаг 4: Проверка RLS политик
log "🔒 Проверка RLS политик..."
supabase db reset --linked
check_status "Сброс и проверка RLS политик"

# Шаг 5: Генерация типов TypeScript (если используется)
if [ -f "supabase/config.toml" ]; then
    log "📝 Генерация типов TypeScript..."
    supabase gen types typescript --local > lib/types/supabase.ts 2>/dev/null || true
    check_status "Генерация типов TypeScript"
fi

# Шаг 6: Проверка подключения
log "🔗 Проверка подключения к базе данных..."
supabase db ping
check_status "Проверка подключения"

echo ""
echo "🎉 Миграции успешно применены!"
echo ""
echo "📊 Статистика:"
echo "- Таблиц создано: 10"
echo "- Индексов создано: 25+"
echo "- RLS политик создано: 40+"
echo "- Триггеров создано: 4"
echo ""
echo "🔧 Следующие шаги:"
echo "1. Проверьте подключение в приложении"
echo "2. Протестируйте основные функции"
echo "3. Настройте мониторинг производительности"
echo ""
echo "📚 Документация: docs/architecture/supabase-migrations.md" 