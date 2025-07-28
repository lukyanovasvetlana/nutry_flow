#!/bin/bash

# Скрипт для запуска тестов NutryFlow
# Автор: NutryFlow Team
# Дата: 2024

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функции для вывода
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Проверка наличия Flutter
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter не найден. Установите Flutter и добавьте его в PATH."
        exit 1
    fi
    print_success "Flutter найден: $(flutter --version | head -n 1)"
}

# Проверка зависимостей
check_dependencies() {
    print_info "Проверка зависимостей..."
    flutter pub get
    print_success "Зависимости обновлены"
}

# Генерация mock файлов
generate_mocks() {
    print_info "Генерация mock файлов..."
    
    # Создаем директории если не существуют
    mkdir -p test/features/meal_plan/data/repositories
    mkdir -p test/features/meal_plan/presentation/bloc
    
    # Генерируем mock файлы
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    print_success "Mock файлы сгенерированы"
}

# Unit тесты
run_unit_tests() {
    print_header "Запуск Unit тестов"
    
    local test_files=(
        "test/features/meal_plan/data/repositories/meal_plan_repository_test.dart"
        "test/features/meal_plan/presentation/bloc/meal_plan_bloc_test.dart"
    )
    
    local failed_tests=0
    
    for test_file in "${test_files[@]}"; do
        if [ -f "$test_file" ]; then
            print_info "Запуск: $test_file"
            if flutter test "$test_file" --coverage; then
                print_success "Тест прошел: $test_file"
            else
                print_error "Тест провалился: $test_file"
                ((failed_tests++))
            fi
        else
            print_warning "Файл не найден: $test_file"
        fi
    done
    
    if [ $failed_tests -eq 0 ]; then
        print_success "Все unit тесты прошли успешно!"
    else
        print_error "$failed_tests unit тестов провалились"
        return 1
    fi
}

# Widget тесты
run_widget_tests() {
    print_header "Запуск Widget тестов"
    
    local widget_test_dir="test/widget_tests"
    
    if [ -d "$widget_test_dir" ]; then
        print_info "Запуск widget тестов..."
        if flutter test "$widget_test_dir" --coverage; then
            print_success "Все widget тесты прошли успешно!"
        else
            print_error "Некоторые widget тесты провалились"
            return 1
        fi
    else
        print_warning "Директория widget тестов не найдена: $widget_test_dir"
    fi
}

# Integration тесты (опционально)
run_integration_tests() {
    print_header "Запуск Integration тестов"
    
    local integration_test_file="test/integration/supabase_integration_test.dart"
    
    if [ -f "$integration_test_file" ]; then
        print_info "Запуск integration тестов (пропущены по умолчанию)..."
        print_warning "Для запуска integration тестов используйте: flutter test $integration_test_file"
    else
        print_warning "Файл integration тестов не найден: $integration_test_file"
    fi
}

# Performance тесты (опционально)
run_performance_tests() {
    print_header "Запуск Performance тестов"
    
    local performance_test_file="test/performance/database_performance_test.dart"
    
    if [ -f "$performance_test_file" ]; then
        print_info "Запуск performance тестов (пропущены по умолчанию)..."
        print_warning "Для запуска performance тестов используйте: flutter test $performance_test_file"
    else
        print_warning "Файл performance тестов не найден: $performance_test_file"
    fi
}

# Анализ покрытия кода
analyze_coverage() {
    print_header "Анализ покрытия кода"
    
    if [ -f "coverage/lcov.info" ]; then
        print_info "Генерация отчета о покрытии..."
        
        # Устанавливаем genhtml если не установлен
        if ! command -v genhtml &> /dev/null; then
            print_warning "genhtml не найден. Установите lcov для генерации HTML отчета."
        else
            genhtml coverage/lcov.info -o coverage/html
            print_success "HTML отчет сгенерирован: coverage/html/index.html"
        fi
        
        # Показываем краткую статистику
        print_info "Статистика покрытия:"
        tail -n 1 coverage/lcov.info | sed 's/.*lines......: \([0-9.]*\)%.*/\1/' | xargs -I {} echo "Общее покрытие: {}%"
    else
        print_warning "Файл покрытия не найден. Запустите тесты с флагом --coverage"
    fi
}

# Проверка качества кода
run_code_analysis() {
    print_header "Анализ качества кода"
    
    print_info "Запуск flutter analyze..."
    if flutter analyze; then
        print_success "Анализ кода прошел успешно!"
    else
        print_error "Анализ кода выявил проблемы"
        return 1
    fi
}

# Очистка
cleanup() {
    print_info "Очистка временных файлов..."
    flutter clean
    flutter pub get
    print_success "Очистка завершена"
}

# Основная функция
main() {
    print_header "🧪 Запуск тестов NutryFlow"
    
    # Проверки
    check_flutter
    check_dependencies
    generate_mocks
    
    # Запуск тестов
    local exit_code=0
    
    run_unit_tests || exit_code=1
    run_widget_tests || exit_code=1
    run_integration_tests
    run_performance_tests
    
    # Анализ
    analyze_coverage
    run_code_analysis || exit_code=1
    
    # Результат
    if [ $exit_code -eq 0 ]; then
        print_header "🎉 Все тесты прошли успешно!"
        print_success "Качество кода соответствует стандартам"
    else
        print_header "⚠️  Некоторые тесты провалились"
        print_error "Проверьте ошибки выше и исправьте их"
    fi
    
    return $exit_code
}

# Обработка аргументов командной строки
case "${1:-}" in
    "unit")
        check_flutter
        check_dependencies
        generate_mocks
        run_unit_tests
        ;;
    "widget")
        check_flutter
        check_dependencies
        run_widget_tests
        ;;
    "integration")
        check_flutter
        check_dependencies
        run_integration_tests
        ;;
    "performance")
        check_flutter
        check_dependencies
        run_performance_tests
        ;;
    "coverage")
        analyze_coverage
        ;;
    "analyze")
        run_code_analysis
        ;;
    "clean")
        cleanup
        ;;
    "help"|"-h"|"--help")
        echo "Использование: $0 [команда]"
        echo ""
        echo "Команды:"
        echo "  unit        - Запуск только unit тестов"
        echo "  widget      - Запуск только widget тестов"
        echo "  integration - Запуск integration тестов"
        echo "  performance - Запуск performance тестов"
        echo "  coverage    - Анализ покрытия кода"
        echo "  analyze     - Анализ качества кода"
        echo "  clean       - Очистка проекта"
        echo "  help        - Показать эту справку"
        echo ""
        echo "Без аргументов запускает все тесты"
        ;;
    "")
        main
        ;;
    *)
        print_error "Неизвестная команда: $1"
        echo "Используйте '$0 help' для справки"
        exit 1
        ;;
esac 