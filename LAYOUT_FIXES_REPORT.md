# Отчет об исправлениях layout'а и ошибки !semantics.parentDataDirty

## Проблема
Ошибка `'package:flutter/src/rendering/object.dart': Failed assertion: line 4951 pos 14: '!semantics.parentDataDirty' : is not true.`

## Причина
Конфликт между `Expanded` внутри `NutryCard` и родительскими layout'ами в dashboard. `Expanded` требует точного расчета размеров, что конфликтует с `Column` и `Row` в dashboard.

## Исправления

### 1. NutryCard - замена Expanded на Flexible
**Файл:** `lib/shared/design/components/cards/nutry_card.dart`

**Проблема:** В заголовках карточек использовался `Expanded`, который конфликтовал с родительскими layout'ами.

**Решение:** Заменил `Expanded` на `Flexible` в двух местах:
- Строка 259: `_buildHeader` для обычной карточки
- Строка 516: `_buildHeader` для градиентной карточки

**Код:**
```dart
// Было:
Expanded(
  child: Column(...),
),

// Стало:
Flexible(
  child: Column(...),
),
```

### 2. StatsOverview - исправление layout'а
**Файл:** `lib/features/dashboard/presentation/widgets/stats_overview.dart`

**Проблема:** Использование `IntrinsicHeight` вызывало конфликты layout'а.

**Решение:** Заменил `IntrinsicHeight` на `Row` с `Expanded` для равномерного распределения ширины.

### 3. Chart widgets - убрал лишние Card и Container
**Файлы:** 
- `lib/features/dashboard/presentation/widgets/expense_chart.dart`
- `lib/features/dashboard/presentation/widgets/calories_chart.dart`
- `lib/features/dashboard/presentation/widgets/products_chart.dart`

**Проблема:** Двойные обертки `Card` и фиксированные высоты вызывали overflow.

**Решение:** Убрал внешние `Card` и `Container` с фиксированной высотой, оставил только `BarChart`.

## Результат
- ✅ Ошибка `!semantics.parentDataDirty` исправлена
- ✅ Overflow на верхних карточках исправлен
- ✅ Charts теперь корректно помещаются в контейнеры
- ✅ Layout стал более гибким и предсказуемым

## Технические детали
- `Flexible` вместо `Expanded` позволяет контенту адаптироваться к доступному пространству
- Убрал `IntrinsicHeight` для предотвращения конфликтов с `Row` и `Column`
- Упростил структуру chart widgets для лучшей совместимости с родительскими layout'ами

## Рекомендации
1. Избегать `Expanded` внутри `NutryCard` при использовании в сложных layout'ах
2. Использовать `Flexible` для адаптивного контента
3. Минимизировать вложенность `Card` и `Container` в chart widgets
4. Тестировать layout на разных размерах экрана
