#!/bin/bash

# NutryFlow Developer Environment Setup Script
# Автоматическая настройка среды разработки для проекта NutryFlow

set -e  # Остановка при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функции для вывода
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка операционной системы
check_os() {
    print_info "Проверка операционной системы..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        print_success "Обнаружена macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
        print_success "Обнаружен Linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="Windows"
        print_success "Обнаружен Windows"
    else
        print_error "Неподдерживаемая операционная система: $OSTYPE"
        exit 1
    fi
}

# Проверка наличия команд
check_command() {
    if command -v $1 &> /dev/null; then
        print_success "$1 установлен"
        return 0
    else
        print_warning "$1 не найден"
        return 1
    fi
}

# Установка Homebrew (macOS)
install_homebrew() {
    if [[ "$OS" == "macOS" ]]; then
        if ! check_command brew; then
            print_info "Установка Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            print_success "Homebrew установлен"
        fi
    fi
}

# Установка Flutter
install_flutter() {
    if ! check_command flutter; then
        print_info "Установка Flutter..."
        
        if [[ "$OS" == "macOS" ]]; then
            brew install --cask flutter
        elif [[ "$OS" == "Linux" ]]; then
            # Скачивание Flutter для Linux
            cd ~
            wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
            tar xf flutter_linux_3.16.0-stable.tar.xz
            export PATH="$PATH:`pwd`/flutter/bin"
            echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
            rm flutter_linux_3.16.0-stable.tar.xz
        fi
        
        print_success "Flutter установлен"
    fi
}

# Установка Node.js
install_nodejs() {
    if ! check_command node; then
        print_info "Установка Node.js..."
        
        if [[ "$OS" == "macOS" ]]; then
            brew install node
        elif [[ "$OS" == "Linux" ]]; then
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install -y nodejs
        fi
        
        print_success "Node.js установлен"
    fi
}

# Установка Git
install_git() {
    if ! check_command git; then
        print_info "Установка Git..."
        
        if [[ "$OS" == "macOS" ]]; then
            brew install git
        elif [[ "$OS" == "Linux" ]]; then
            sudo apt-get update
            sudo apt-get install -y git
        fi
        
        print_success "Git установлен"
    fi
}

# Настройка Flutter
setup_flutter() {
    print_info "Настройка Flutter..."
    
    # Проверка Flutter doctor
    flutter doctor
    
    # Принятие лицензий Android (если доступно)
    if command -v flutter &> /dev/null; then
        flutter doctor --android-licenses || print_warning "Android licenses не могут быть приняты автоматически"
    fi
    
    print_success "Flutter настроен"
}

# Установка зависимостей проекта
install_project_dependencies() {
    print_info "Установка зависимостей проекта..."
    
    # Flutter зависимости
    if [ -f "pubspec.yaml" ]; then
        flutter pub get
        print_success "Flutter зависимости установлены"
    else
        print_error "pubspec.yaml не найден"
        exit 1
    fi
    
    # iOS зависимости (только для macOS)
    if [[ "$OS" == "macOS" ]] && [ -d "ios" ]; then
        print_info "Установка iOS зависимостей..."
        cd ios && pod install && cd ..
        print_success "iOS зависимости установлены"
    fi
}

# Установка глобальных npm пакетов
install_global_packages() {
    print_info "Установка глобальных npm пакетов..."
    
    # Supabase CLI
    npm install -g supabase
    
    # Firebase CLI
    npm install -g firebase-tools
    
    print_success "Глобальные пакеты установлены"
}

# Создание файла .env
create_env_file() {
    print_info "Создание файла .env..."
    
    if [ ! -f ".env" ]; then
        cat > .env << EOF
# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key

# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_ANDROID_APP_ID=your_firebase_android_app_id
FIREBASE_IOS_APP_ID=your_firebase_ios_app_id

# Analytics Configuration
MIXPANEL_TOKEN=your_mixpanel_token
EOF
        print_success "Файл .env создан"
        print_warning "Не забудьте заполнить реальные значения в .env файле"
    else
        print_info "Файл .env уже существует"
    fi
}

# Настройка Git
setup_git() {
    print_info "Настройка Git..."
    
    # Проверка конфигурации Git
    if [ -z "$(git config --global user.name)" ]; then
        print_warning "Git user.name не настроен"
        echo "Введите ваше имя для Git:"
        read git_name
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        print_warning "Git user.email не настроен"
        echo "Введите ваш email для Git:"
        read git_email
        git config --global user.email "$git_email"
    fi
    
    print_success "Git настроен"
}

# Проверка эмуляторов
check_emulators() {
    print_info "Проверка эмуляторов..."
    
    if command -v flutter &> /dev/null; then
        print_info "Доступные эмуляторы:"
        flutter emulators || print_warning "Эмуляторы не найдены"
    fi
}

# Создание VS Code настроек
setup_vscode() {
    print_info "Настройка VS Code..."
    
    if [ -d ".vscode" ]; then
        print_info "Папка .vscode уже существует"
    else
        mkdir -p .vscode
    fi
    
    # Создание settings.json
    cat > .vscode/settings.json << EOF
{
    "dart.flutterSdkPath": "flutter",
    "dart.sdkPath": "flutter/bin/cache/dart-sdk",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll": true,
        "source.organizeImports": true
    },
    "files.exclude": {
        "**/.dart_tool": true,
        "**/.flutter-plugins": true,
        "**/.flutter-plugins-dependencies": true,
        "**/.packages": true,
        "**/build": true,
        "**/coverage": true
    }
}
EOF
    
    # Создание launch.json
    cat > .vscode/launch.json << EOF
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart"
        },
        {
            "name": "Flutter (Profile Mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "program": "lib/main.dart"
        }
    ]
}
EOF
    
    print_success "VS Code настроен"
}

# Проверка готовности
check_readiness() {
    print_info "Проверка готовности среды разработки..."
    
    local ready=true
    
    # Проверка основных инструментов
    if ! check_command flutter; then
        print_error "Flutter не установлен"
        ready=false
    fi
    
    if ! check_command git; then
        print_error "Git не установлен"
        ready=false
    fi
    
    if ! check_command node; then
        print_error "Node.js не установлен"
        ready=false
    fi
    
    # Проверка проекта
    if [ ! -f "pubspec.yaml" ]; then
        print_error "pubspec.yaml не найден - убедитесь, что вы в корне проекта"
        ready=false
    fi
    
    if [ ! -f ".env" ]; then
        print_warning ".env файл не создан"
    fi
    
    if [ "$ready" = true ]; then
        print_success "Среда разработки готова!"
        print_info "Следующие шаги:"
        print_info "1. Заполните .env файл реальными значениями"
        print_info "2. Настройте Supabase: supabase login"
        print_info "3. Настройте Firebase: firebase login"
        print_info "4. Запустите приложение: flutter run"
    else
        print_error "Среда разработки не готова. Исправьте ошибки выше."
        exit 1
    fi
}

# Основная функция
main() {
    print_info "Начинаем настройку среды разработки NutryFlow..."
    
    check_os
    install_homebrew
    install_git
    install_nodejs
    install_flutter
    setup_flutter
    install_global_packages
    install_project_dependencies
    create_env_file
    setup_git
    setup_vscode
    check_emulators
    check_readiness
    
    print_success "Настройка завершена! 🎉"
    print_info "Дополнительная информация: docs/developer-onboarding-guide.md"
}

# Запуск скрипта
main "$@"
