#!/usr/bin/env python3
"""
Скрипт для экспорта дизайн-токенов NutryFlow в различные форматы
для интеграции с дизайнерскими инструментами (Figma, Sketch, Adobe XD)
"""

import json
import os
import re
from pathlib import Path
from typing import Dict, Any, List

class DesignTokensExporter:
    """Экспортер дизайн-токенов в различные форматы"""
    
    def __init__(self):
        self.tokens = self._parse_dart_tokens()
        self.output_dir = Path("design-tokens")
        self.output_dir.mkdir(exist_ok=True)
    
    def _parse_dart_tokens(self) -> Dict[str, Any]:
        """Парсит токены из Dart файла"""
        tokens_file = Path("lib/shared/design/tokens/design_tokens.dart")
        
        if not tokens_file.exists():
            print(f"❌ Файл токенов не найден: {tokens_file}")
            return {}
        
        content = tokens_file.read_text(encoding='utf-8')
        
        # Извлекаем цвета
        colors = self._extract_colors(content)
        
        # Извлекаем типографику
        typography = self._extract_typography(content)
        
        # Извлекаем отступы
        spacing = self._extract_spacing(content)
        
        # Извлекаем тени
        shadows = self._extract_shadows(content)
        
        # Извлекаем анимации
        animations = self._extract_animations(content)
        
        # Извлекаем границы
        borders = self._extract_borders(content)
        
        return {
            "colors": colors,
            "typography": typography,
            "spacing": spacing,
            "shadows": shadows,
            "animations": animations,
            "borders": borders
        }
    
    def _extract_colors(self, content: str) -> Dict[str, Any]:
        """Извлекает цветовые токены"""
        colors = {}
        
        # Основные цвета
        color_patterns = [
            (r'Color get (\w+) => const Color\(0x([A-F0-9]{8})\)', 'hex'),
            (r'Color get (\w+) => const Color\(0x([A-F0-9]{6})\)', 'hex'),
        ]
        
        for pattern, format_type in color_patterns:
            matches = re.findall(pattern, content)
            for name, value in matches:
                if format_type == 'hex':
                    colors[name] = f"#{value}"
        
        # Градиенты
        gradient_pattern = r'LinearGradient get (\w+) => const LinearGradient\(\s*colors: \[([^\]]+)\],'
        gradient_matches = re.findall(gradient_pattern, content, re.DOTALL)
        
        for name, colors_str in gradient_matches:
            color_values = re.findall(r'Color\(0x([A-F0-9]{8})\)', colors_str)
            colors[f"{name}_gradient"] = [f"#{color}" for color in color_values]
        
        return colors
    
    def _extract_typography(self, content: str) -> Dict[str, Any]:
        """Извлекает типографические токены"""
        typography = {}
        
        # Размеры шрифтов
        size_pattern = r'double get (\w+) => ([\d.]+)'
        size_matches = re.findall(size_pattern, content)
        
        for name, value in size_matches:
            typography[name] = float(value)
        
        # Стили текста
        style_pattern = r'TextStyle get (\w+) => TextStyle\(([^)]+)\)'
        style_matches = re.findall(style_pattern, content, re.DOTALL)
        
        for name, style_content in style_matches:
            # Извлекаем свойства стиля
            font_size_match = re.search(r'fontSize: ([\d.]+)', style_content)
            font_weight_match = re.search(r'fontWeight: (\w+)', style_content)
            
            if font_size_match:
                typography[f"{name}_fontSize"] = float(font_size_match.group(1))
            if font_weight_match:
                typography[f"{name}_fontWeight"] = font_weight_match.group(1)
        
        return typography
    
    def _extract_spacing(self, content: str) -> Dict[str, Any]:
        """Извлекает токены отступов"""
        spacing = {}
        
        spacing_pattern = r'double get (\w+) => ([\d.]+)'
        spacing_matches = re.findall(spacing_pattern, content)
        
        for name, value in spacing_matches:
            spacing[name] = float(value)
        
        return spacing
    
    def _extract_shadows(self, content: str) -> Dict[str, Any]:
        """Извлекает токены теней"""
        shadows = {}
        
        shadow_pattern = r'List<BoxShadow> get (\w+) => \[([^\]]+)\]'
        shadow_matches = re.findall(shadow_pattern, content, re.DOTALL)
        
        for name, shadow_content in shadow_matches:
            # Извлекаем параметры тени
            blur_match = re.search(r'blurRadius: ([\d.]+)', shadow_content)
            offset_match = re.search(r'offset: const Offset\(([^)]+)\)', shadow_content)
            alpha_match = re.search(r'alpha:\s*([\d.]+)', shadow_content)
            
            shadow_data = {}
            if blur_match:
                shadow_data["blurRadius"] = float(blur_match.group(1))
            if offset_match:
                offset_values = offset_match.group(1).split(', ')
                shadow_data["offset"] = {
                    "x": float(offset_values[0]),
                    "y": float(offset_values[1])
                }
            if alpha_match:
                shadow_data["alpha"] = float(alpha_match.group(1))
            
            shadows[name] = shadow_data
        
        return shadows
    
    def _extract_animations(self, content: str) -> Dict[str, Any]:
        """Извлекает токены анимаций"""
        animations = {}
        
        # Длительности
        duration_pattern = r'Duration get (\w+) => const Duration\(milliseconds: ([\d.]+)\)'
        duration_matches = re.findall(duration_pattern, content)
        
        for name, value in duration_matches:
            animations[f"{name}_duration"] = int(value)
        
        # Кривые
        curve_pattern = r'Curve get (\w+) => Curves\.(\w+)'
        curve_matches = re.findall(curve_pattern, content)
        
        for name, curve in curve_matches:
            animations[f"{name}_curve"] = curve
        
        return animations
    
    def _extract_borders(self, content: str) -> Dict[str, Any]:
        """Извлекает токены границ"""
        borders = {}
        
        # Радиусы
        radius_pattern = r'double get (\w+) => ([\d.]+)'
        radius_matches = re.findall(radius_pattern, content)
        
        for name, value in radius_matches:
            borders[name] = float(value)
        
        return borders
    
    def export_json(self):
        """Экспортирует токены в JSON формат"""
        output_file = self.output_dir / "design-tokens.json"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(self.tokens, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Экспортировано в JSON: {output_file}")
    
    def export_css(self):
        """Экспортирует токены в CSS переменные"""
        output_file = self.output_dir / "design-tokens.css"
        
        css_content = ":root {\n"
        
        # Цвета
        for name, value in self.tokens.get("colors", {}).items():
            if isinstance(value, str) and value.startswith('#'):
                css_content += f"  --color-{name}: {value};\n"
        
        # Отступы
        for name, value in self.tokens.get("spacing", {}).items():
            css_content += f"  --spacing-{name}: {value}px;\n"
        
        # Типографика
        for name, value in self.tokens.get("typography", {}).items():
            if "fontSize" in name:
                css_content += f"  --font-size-{name.replace('_fontSize', '')}: {value}px;\n"
        
        css_content += "}\n"
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(css_content)
        
        print(f"✅ Экспортировано в CSS: {output_file}")
    
    def export_figma(self):
        """Экспортирует токены в формат для Figma"""
        figma_tokens = {
            "version": "1.0.0",
            "name": "NutryFlow Design Tokens",
            "tokens": {
                "color": {},
                "typography": {},
                "spacing": {},
                "shadow": {},
                "borderRadius": {}
            }
        }
        
        # Цвета для Figma
        for name, value in self.tokens.get("colors", {}).items():
            if isinstance(value, str) and value.startswith('#'):
                figma_tokens["tokens"]["color"][name] = {
                    "value": value,
                    "type": "color"
                }
        
        # Отступы для Figma
        for name, value in self.tokens.get("spacing", {}).items():
            figma_tokens["tokens"]["spacing"][name] = {
                "value": f"{value}px",
                "type": "dimension"
            }
        
        # Радиусы для Figma
        for name, value in self.tokens.get("borders", {}).items():
            figma_tokens["tokens"]["borderRadius"][name] = {
                "value": f"{value}px",
                "type": "borderRadius"
            }
        
        output_file = self.output_dir / "figma-tokens.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(figma_tokens, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Экспортировано для Figma: {output_file}")
    
    def export_sketch(self):
        """Экспортирует токены в формат для Sketch"""
        sketch_tokens = {
            "colors": {},
            "textStyles": {},
            "spacing": {},
            "shadows": {}
        }
        
        # Цвета для Sketch
        for name, value in self.tokens.get("colors", {}).items():
            if isinstance(value, str) and value.startswith('#'):
                sketch_tokens["colors"][name] = value
        
        # Отступы для Sketch
        for name, value in self.tokens.get("spacing", {}).items():
            sketch_tokens["spacing"][name] = value
        
        output_file = self.output_dir / "sketch-tokens.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(sketch_tokens, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Экспортировано для Sketch: {output_file}")
    
    def export_adobe_xd(self):
        """Экспортирует токены в формат для Adobe XD"""
        xd_tokens = {
            "version": "1.0.0",
            "name": "NutryFlow Design Tokens",
            "colors": {},
            "textStyles": {},
            "spacing": {}
        }
        
        # Цвета для Adobe XD
        for name, value in self.tokens.get("colors", {}).items():
            if isinstance(value, str) and value.startswith('#'):
                xd_tokens["colors"][name] = value
        
        # Отступы для Adobe XD
        for name, value in self.tokens.get("spacing", {}).items():
            xd_tokens["spacing"][name] = value
        
        output_file = self.output_dir / "adobe-xd-tokens.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(xd_tokens, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Экспортировано для Adobe XD: {output_file}")
    
    def generate_readme(self):
        """Генерирует README для дизайн-токенов"""
        readme_content = """# NutryFlow Design Tokens

Этот каталог содержит экспортированные дизайн-токены NutryFlow в различных форматах для интеграции с дизайнерскими инструментами.

## Файлы

- `design-tokens.json` - Полные токены в JSON формате
- `design-tokens.css` - CSS переменные для веб-разработки
- `figma-tokens.json` - Токены для импорта в Figma
- `sketch-tokens.json` - Токены для импорта в Sketch
- `adobe-xd-tokens.json` - Токены для импорта в Adobe XD

## Использование

### Figma
1. Установите плагин "Design Tokens"
2. Импортируйте `figma-tokens.json`
3. Используйте токены в ваших компонентах

### Sketch
1. Используйте плагин "Design Tokens"
2. Импортируйте `sketch-tokens.json`
3. Примените токены к стилям

### Adobe XD
1. Используйте плагин "Design Tokens"
2. Импортируйте `adobe-xd-tokens.json`
3. Создайте компоненты с токенами

### Веб-разработка
1. Подключите `design-tokens.css`
2. Используйте CSS переменные в стилях

## Обновление токенов

Для обновления токенов запустите:

```bash
python scripts/export_design_tokens.py
```

Это автоматически обновит все файлы на основе изменений в `lib/shared/design/tokens/design_tokens.dart`.

## Структура токенов

### Цвета
- Основные цвета бренда (primary, secondary, accent)
- Семантические цвета питания (protein, carbs, fats, water, fiber)
- Системные цвета (background, surface, text)

### Типографика
- Размеры шрифтов (display, headline, title, body, label)
- Веса шрифтов (light, regular, medium, semiBold, bold)
- Готовые текстовые стили

### Отступы
- Базовые размеры (xs, sm, md, lg, xl, xxl, xxxl)
- Специфичные размеры (buttonHeight, inputHeight, screenPadding)

### Тени
- Иерархия теней (none, xs, sm, md, lg, xl)
- Параметры (blurRadius, offset, alpha)

### Анимации
- Длительности (fast, normal, slow, slower)
- Кривые (easeIn, easeOut, easeInOut, bounce)

### Границы
- Радиусы скругления (none, xs, sm, md, lg, xl, xxl, full)
- Ширина границ (thin, medium, thick)
"""
        
        readme_file = self.output_dir / "README.md"
        with open(readme_file, 'w', encoding='utf-8') as f:
            f.write(readme_content)
        
        print(f"✅ Создан README: {readme_file}")
    
    def export_all(self):
        """Экспортирует токены во все форматы"""
        print("🚀 Начинаю экспорт дизайн-токенов...")
        
        if not self.tokens:
            print("❌ Не удалось извлечь токены из Dart файла")
            return
        
        self.export_json()
        self.export_css()
        self.export_figma()
        self.export_sketch()
        self.export_adobe_xd()
        self.generate_readme()
        
        print("✅ Экспорт завершен! Все файлы сохранены в папке 'design-tokens'")

def main():
    """Главная функция"""
    exporter = DesignTokensExporter()
    exporter.export_all()

if __name__ == "__main__":
    main() 