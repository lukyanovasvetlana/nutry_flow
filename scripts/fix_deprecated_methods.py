#!/usr/bin/env python3
"""
Скрипт для автоматической замены устаревших методов в Dart файлах
- withOpacity(value) -> withValues(alpha: value)
"""
import os
import re
import sys
from pathlib import Path

def fix_with_opacity(file_path: Path):
    """Заменяет withOpacity() на withValues() в файле"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Заменяем .withOpacity(value) на .withValues(alpha: value)
        # Паттерн: .withOpacity(число или выражение)
        def replace_with_opacity(match):
            full_match = match.group(0)
            value = match.group(1)
            # Убираем точку в начале, если она есть
            prefix = match.group(2) if match.group(2) else ''
            return f"{prefix}.withValues(alpha: {value})"
        
        # Паттерн для поиска .withOpacity(...)
        # Учитываем возможные пробелы
        pattern = r'(\w+)\.withOpacity\s*\(\s*([^)]+)\s*\)'
        content = re.sub(pattern, lambda m: f"{m.group(1)}.withValues(alpha: {m.group(2)})", content)
        
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
        if fix_with_opacity(dart_file):
            fixed_files.append(dart_file)
            print(f"Исправлен: {dart_file.relative_to(project_root)}")
    
    print(f"\nИсправлено файлов: {len(fixed_files)}")
    if fixed_files:
        print("\nВНИМАНИЕ: Проверьте исправления вручную!")

if __name__ == '__main__':
    main()

