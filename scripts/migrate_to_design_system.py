#!/usr/bin/env python3
"""
Скрипт для миграции старых компонентов на новую дизайн-систему NutryFlow
Заменяет старые TextFormField на NutryInput и унифицирует стили
"""

import os
import re
import shutil
from pathlib import Path
from typing import List, Dict, Any

class DesignSystemMigrator:
    """Мигратор для обновления компонентов на новую дизайн-систему"""
    
    def __init__(self):
        self.project_root = Path(".")
        self.backup_dir = self.project_root / "backup_before_migration"
        self.migration_log = []
        
    def backup_files(self):
        """Создает резервные копии файлов перед миграцией"""
        print("🔄 Создание резервных копий...")
        
        if self.backup_dir.exists():
            shutil.rmtree(self.backup_dir)
        
        self.backup_dir.mkdir(exist_ok=True)
        
        # Файлы для резервного копирования
        files_to_backup = [
            "lib/features/auth/presentation/widgets/auth_widgets.dart",
            "lib/features/profile/presentation/widgets/profile_form_field.dart",
            "lib/features/onboarding/presentation/screens/login_screen.dart",
            "lib/features/onboarding/presentation/screens/registration_screen.dart",
            "lib/features/onboarding/presentation/screens/enhanced_login_screen.dart",
            "lib/features/onboarding/presentation/screens/enhanced_registration_screen.dart",
            "lib/features/onboarding/presentation/screens/profile_info_screen.dart",
            "lib/features/onboarding/presentation/screens/forgot_password_screen.dart",
        ]
        
        for file_path in files_to_backup:
            source = self.project_root / file_path
            if source.exists():
                backup_path = self.backup_dir / file_path
                backup_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, backup_path)
                print(f"✅ Резервная копия: {file_path}")
        
        print("✅ Резервные копии созданы в папке 'backup_before_migration'")
    
    def migrate_auth_widgets(self):
        """Мигрирует auth_widgets.dart на новую дизайн-систему"""
        file_path = "lib/features/auth/presentation/widgets/auth_widgets.dart"
        
        if not Path(file_path).exists():
            print(f"⚠️ Файл не найден: {file_path}")
            return
        
        print(f"🔄 Миграция {file_path}...")
        
        # Читаем файл
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Заменяем AuthTextField на NutryInput
        new_content = self._replace_auth_text_field(content)
        
        # Обновляем импорты
        new_content = self._update_imports(new_content, [
            "import '../../../../shared/design/components/forms/forms.dart';"
        ])
        
        # Записываем обновленный файл
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"✅ Миграция завершена: {file_path}")
        self.migration_log.append(f"Migrated: {file_path}")
    
    def migrate_profile_form_field(self):
        """Мигрирует profile_form_field.dart на новую дизайн-систему"""
        file_path = "lib/features/profile/presentation/widgets/profile_form_field.dart"
        
        if not Path(file_path).exists():
            print(f"⚠️ Файл не найден: {file_path}")
            return
        
        print(f"🔄 Миграция {file_path}...")
        
        # Читаем файл
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Заменяем ProfileFormField на NutryInput
        new_content = self._replace_profile_form_field(content)
        
        # Обновляем импорты
        new_content = self._update_imports(new_content, [
            "import '../../../../shared/design/components/forms/forms.dart';"
        ])
        
        # Записываем обновленный файл
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"✅ Миграция завершена: {file_path}")
        self.migration_log.append(f"Migrated: {file_path}")
    
    def migrate_onboarding_screens(self):
        """Мигрирует экраны onboarding на новую дизайн-систему"""
        screens = [
            "lib/features/onboarding/presentation/screens/login_screen.dart",
            "lib/features/onboarding/presentation/screens/registration_screen.dart",
            "lib/features/onboarding/presentation/screens/enhanced_login_screen.dart",
            "lib/features/onboarding/presentation/screens/enhanced_registration_screen.dart",
            "lib/features/onboarding/presentation/screens/profile_info_screen.dart",
            "lib/features/onboarding/presentation/screens/forgot_password_screen.dart",
        ]
        
        for screen_path in screens:
            if not Path(screen_path).exists():
                print(f"⚠️ Файл не найден: {screen_path}")
                continue
            
            print(f"🔄 Миграция {screen_path}...")
            
            # Читаем файл
            with open(screen_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Заменяем TextFormField на NutryInput
            new_content = self._replace_text_form_fields(content)
            
            # Обновляем импорты
            new_content = self._update_imports(new_content, [
                "import '../../../../shared/design/components/forms/forms.dart';"
            ])
            
            # Записываем обновленный файл
            with open(screen_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print(f"✅ Миграция завершена: {screen_path}")
            self.migration_log.append(f"Migrated: {screen_path}")
    
    def _replace_auth_text_field(self, content: str) -> str:
        """Заменяет AuthTextField на NutryInput"""
        
        # Заменяем класс AuthTextField
        content = re.sub(
            r'class AuthTextField extends StatelessWidget \{[\s\S]*?\}',
            self._get_auth_text_field_replacement(),
            content
        )
        
        # Заменяем использование AuthTextField
        content = re.sub(
            r'AuthTextField\(([^)]+)\)',
            r'NutryInput(\1)',
            content
        )
        
        return content
    
    def _replace_profile_form_field(self, content: str) -> str:
        """Заменяет ProfileFormField на NutryInput"""
        
        # Заменяем класс ProfileFormField
        content = re.sub(
            r'class ProfileFormField extends StatelessWidget \{[\s\S]*?\}',
            self._get_profile_form_field_replacement(),
            content
        )
        
        # Заменяем использование ProfileFormField
        content = re.sub(
            r'ProfileFormField\(([^)]+)\)',
            r'NutryInput(\1)',
            content
        )
        
        return content
    
    def _replace_text_form_fields(self, content: str) -> str:
        """Заменяет TextFormField на NutryInput в экранах"""
        
        # Паттерны для замены различных типов полей
        patterns = [
            # Email поля
            (
                r'TextFormField\(\s*controller:\s*(\w+),\s*decoration:\s*InputDecoration\(\s*labelText:\s*[\'"](Email|email)[\'"]',
                r'NutryInput.email(label: \'\1\', controller: \1'
            ),
            # Password поля
            (
                r'TextFormField\(\s*controller:\s*(\w+),\s*decoration:\s*InputDecoration\(\s*labelText:\s*[\'"](Пароль|пароль|Password|password)[\'"]',
                r'NutryInput.password(label: \'\1\', controller: \1'
            ),
            # Number поля
            (
                r'TextFormField\(\s*controller:\s*(\w+),\s*keyboardType:\s*TextInputType\.number',
                r'NutryInput.number(label: \'Число\', controller: \1'
            ),
            # Обычные текстовые поля
            (
                r'TextFormField\(\s*controller:\s*(\w+),\s*decoration:\s*InputDecoration\(\s*labelText:\s*[\'"]([^\'"]+)[\'"]',
                r'NutryInput.text(label: \'\2\', controller: \1'
            ),
        ]
        
        for pattern, replacement in patterns:
            content = re.sub(pattern, replacement, content)
        
        return content
    
    def _update_imports(self, content: str, new_imports: List[str]) -> str:
        """Обновляет импорты в файле"""
        
        # Удаляем старые импорты дизайн-системы
        content = re.sub(
            r'import.*app_colors\.dart.*\n',
            '',
            content
        )
        
        # Добавляем новые импорты
        import_section = "import 'package:flutter/material.dart';\n"
        for new_import in new_imports:
            import_section += f"{new_import}\n"
        
        # Находим позицию для вставки импортов
        lines = content.split('\n')
        insert_index = 0
        
        for i, line in enumerate(lines):
            if line.startswith('import '):
                insert_index = i + 1
        
        # Вставляем новые импорты
        lines.insert(insert_index, "")
        for new_import in new_imports:
            lines.insert(insert_index, new_import)
        
        return '\n'.join(lines)
    
    def _get_auth_text_field_replacement(self) -> str:
        """Возвращает замену для AuthTextField"""
        return '''class AuthTextField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? helperText;

  const AuthTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return NutryInput(
      controller: controller,
      label: label,
      prefixIcon: prefixIcon,
      obscureText: obscureText,
      validator: validator,
      suffixWidget: suffixIcon,
      helperText: helperText,
    );
  }
}'''
    
    def _get_profile_form_field_replacement(self) -> str:
        """Возвращает замену для ProfileFormField"""
        return '''class ProfileFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool enabled;
  final VoidCallback? onTap;

  const ProfileFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NutryInput(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      suffixWidget: suffixIcon,
      maxLines: maxLines,
      enabled: enabled,
      onTap: onTap,
      inputFormatters: inputFormatters,
    );
  }
}'''
    
    def generate_migration_report(self):
        """Генерирует отчет о миграции"""
        report_path = self.project_root / "MIGRATION_REPORT.md"
        
        report_content = f"""# Отчет о миграции на дизайн-систему

## Обзор
Миграция старых компонентов на новую дизайн-систему NutryFlow завершена.

## Мигрированные файлы
{chr(10).join(f"- {log}" for log in self.migration_log)}

## Что было изменено

### 1. Замена компонентов
- `AuthTextField` → `NutryInput`
- `ProfileFormField` → `NutryInput`
- `TextFormField` → `NutryInput` (с соответствующими типами)

### 2. Унификация стилей
- Все поля ввода теперь используют дизайн-токены
- Единая система цветов и отступов
- Консистентные состояния (normal, focused, error, success, disabled)

### 3. Улучшения
- Автоматическая валидация для email и password полей
- Встроенные иконки для различных типов полей
- Поддержка всех состояний поля ввода
- Улучшенная доступность

## Резервные копии
Резервные копии файлов сохранены в папке `backup_before_migration/`

## Следующие шаги
1. Протестировать все мигрированные экраны
2. Обновить тесты для новых компонентов
3. Удалить старые неиспользуемые компоненты
4. Обновить документацию

## Использование новых компонентов

### NutryInput
```dart
// Email поле
NutryInput.email(
  label: 'Email',
  controller: emailController,
  hint: 'Введите ваш email',
);

// Поле пароля
NutryInput.password(
  label: 'Пароль',
  controller: passwordController,
  hint: 'Введите ваш пароль',
);

// Числовое поле
NutryInput.number(
  label: 'Возраст',
  controller: ageController,
  hint: 'Введите ваш возраст',
);
```

### NutryForm
```dart
// Форма входа
NutryForm.login(
  children: [
    NutryInput.email(label: 'Email', controller: emailController),
    NutryInput.password(label: 'Пароль', controller: passwordController),
  ],
  onSubmit: () => handleLogin(),
);
```
"""
        
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        print(f"✅ Отчет о миграции сохранен: {report_path}")
    
    def run_migration(self):
        """Запускает полную миграцию"""
        print("🚀 Начинаю миграцию на новую дизайн-систему...")
        
        # Создаем резервные копии
        self.backup_files()
        
        # Мигрируем компоненты
        self.migrate_auth_widgets()
        self.migrate_profile_form_field()
        self.migrate_onboarding_screens()
        
        # Генерируем отчет
        self.generate_migration_report()
        
        print("✅ Миграция завершена!")
        print(f"📊 Обработано файлов: {len(self.migration_log)}")
        print("📋 Подробный отчет: MIGRATION_REPORT.md")

def main():
    """Главная функция"""
    migrator = DesignSystemMigrator()
    migrator.run_migration()

if __name__ == "__main__":
    main()
