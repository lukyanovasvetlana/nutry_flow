#!/usr/bin/env python3
"""
Скрипт для автоматической замены print() на developer.log() в Dart файлах
"""
import os
import re
import sys
from pathlib import Path

def fix_print_statements(file_path: Path):
    """Заменяет print() на developer.log() в файле"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Проверяем, есть ли уже импорт developer
        has_developer_import = 'dart:developer' in content or "import 'dart:developer'" in content or 'import "dart:developer"' in content
        
        # Заменяем print('...') на developer.log('...', name: 'ClassName')
        # Паттерн для поиска print('...') или print("...")
        def replace_print(match):
            print_statement = match.group(0)
            # Извлекаем содержимое print
            if "print('" in print_statement or 'print("' in print_statement:
                # Находим класс или функцию, в которой находится print
                # Для простоты используем имя файла как имя для логирования
                file_name = file_path.stem
                # Извлекаем сообщение из print
                message_match = re.search(r"print\(['\"](.*?)['\"]\)", print_statement)
                if message_match:
                    message = message_match.group(1)
                    # Экранируем специальные символы в сообщении
                    message_escaped = message.replace('\\', '\\\\').replace('$', '\\$')
                    return f"developer.log('{message_escaped}', name: '{file_name}')"
            return print_statement
        
        # Заменяем простые print('...') вызовы
        def replace_simple_print(match):
            message = match.group(1)
            # Экранируем специальные символы
            message_escaped = message.replace('\\', '\\\\').replace('$', '\\$')
            return f"developer.log('{message_escaped}', name: '{file_path.stem}')"
        
        content = re.sub(
            r"print\(['\"]([^'\"]*?)['\"]\)",
            replace_simple_print,
            content
        )
        
        # Заменяем print(...) с интерполяцией строк
        content = re.sub(
            r"print\(([^)]+)\)",
            lambda m: f"developer.log({m.group(1)}, name: '{file_path.stem}')",
            content
        )
        
        # Добавляем импорт developer, если его нет
        if content != original_content and not has_developer_import:
            # Находим место для вставки импорта (после других импортов)
            import_pattern = r"(import\s+['\"][^'\"]+['\"];)"
            imports = re.findall(import_pattern, content)
            if imports:
                # Вставляем после последнего импорта
                last_import = imports[-1]
                content = content.replace(
                    last_import,
                    f"{last_import}\nimport 'dart:developer' as developer;"
                )
            else:
                # Если нет импортов, добавляем в начало
                content = "import 'dart:developer' as developer;\n" + content
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Ошибка при обработке {file_path}: {e}", file=sys.stderr)
        return False

def main():
    """Основная функция"""
    project_root = Path(__file__).parent.parent
    lib_dir = project_root / 'lib'
    
    if not lib_dir.exists():
        print(f"Директория {lib_dir} не найдена", file=sys.stderr)
        sys.exit(1)
    
    fixed_files = []
    dart_files = list(lib_dir.rglob('*.dart'))
    
    print(f"Найдено {len(dart_files)} Dart файлов для проверки...")
    
    for dart_file in dart_files:
        if fix_print_statements(dart_file):
            fixed_files.append(dart_file)
            print(f"Исправлен: {dart_file.relative_to(project_root)}")
    
    print(f"\nИсправлено файлов: {len(fixed_files)}")
    if fixed_files:
        print("\nВНИМАНИЕ: Проверьте исправления вручную, особенно:")
        print("- Интерполяцию строк в print()")
        print("- Правильность имен для логирования")
        print("- Импорты developer")

if __name__ == '__main__':
    main()

