# NutryFlow Design Tokens

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
