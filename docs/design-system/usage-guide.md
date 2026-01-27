# Руководство по использованию дизайн-системы

## Введение

Это руководство поможет разработчикам эффективно использовать дизайн-систему NutryFlow в своих проектах.

## Быстрый старт

### 1. Импорт компонентов

```dart
// Кнопки
import 'package:nutry_flow/shared/design/components/buttons/nutry_button.dart';

// Карточки
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';

// Формы
import 'package:nutry_flow/shared/design/components/forms/nutry_input.dart';

// Токены
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
```

### 2. Использование токенов

```dart
// ❌ Плохо - хардкод значений
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 20),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
)

// ✅ Хорошо - использование токенов
Container(
  padding: EdgeInsets.all(context.spacing.md),
  margin: EdgeInsets.symmetric(horizontal: context.spacing.lg),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.borders.md),
  ),
)
```

### 3. Использование динамических цветов

```dart
// ❌ Плохо - статические цвета
Container(
  color: Colors.white,
  child: Text(
    'Текст',
    style: TextStyle(color: Colors.black),
  ),
)

// ✅ Хорошо - динамические цвета
Container(
  color: context.colors.surface,
  child: Text(
    'Текст',
    style: context.typography.bodyMediumStyle.copyWith(
      color: context.colors.onSurface,
    ),
  ),
)
```

## Работа с цветами

### Основные цвета

```dart
// Primary цвет
context.colors.primary

// Secondary цвет
context.colors.secondary

// Accent цвет
context.colors.accent
```

### Системные цвета

```dart
// Фон
context.colors.background
context.colors.surface
context.colors.surfaceVariant

// Текст
context.colors.onSurface
context.colors.onSurfaceVariant
context.colors.onBackground
```

### Семантические цвета

```dart
// Состояния
context.colors.success
context.colors.warning
context.colors.error
context.colors.info

// Цвета питания
context.colors.protein
context.colors.carbs
context.colors.fats
context.colors.water
context.colors.fiber
```

## Работа с типографикой

### Использование стилей

```dart
// Display
Text('Заголовок', style: context.typography.displayLargeStyle)

// Headline
Text('Заголовок', style: context.typography.headlineLargeStyle)

// Title
Text('Заголовок', style: context.typography.titleLargeStyle)

// Body
Text('Текст', style: context.typography.bodyMediumStyle)

// Label
Text('Метка', style: context.typography.labelMediumStyle)
```

### Кастомизация стилей

```dart
Text(
  'Кастомный текст',
  style: context.typography.bodyMediumStyle.copyWith(
    color: context.colors.primary,
    fontWeight: FontWeight.bold,
  ),
)
```

## Работа с отступами

### Spacing токены

```dart
// Маленькие отступы
context.spacing.xs  // 4px
context.spacing.sm  // 8px

// Средние отступы
context.spacing.md  // 16px
context.spacing.lg  // 24px

// Большие отступы
context.spacing.xl  // 32px
context.spacing.xxl // 48px
```

### Примеры использования

```dart
// Padding
Container(
  padding: EdgeInsets.all(context.spacing.md),
)

// Margin
Container(
  margin: EdgeInsets.symmetric(
    horizontal: context.spacing.lg,
    vertical: context.spacing.md,
  ),
)

// Spacing между элементами
Column(
  children: [
    Widget1(),
    SizedBox(height: context.spacing.md),
    Widget2(),
  ],
)
```

## Работа с границами

### Border Radius

```dart
// Маленькие радиусы
context.borders.xs  // 4px
context.borders.sm  // 8px

// Средние радиусы
context.borders.md  // 12px
context.borders.lg  // 16px

// Большие радиусы
context.borders.xl  // 24px
context.borders.full // 9999px (круг)
```

### Примеры

```dart
// Карточка
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.borders.md),
  ),
)

// Кнопка
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.borders.buttonRadius),
  ),
)

// Круглая кнопка
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.borders.full),
  ),
)
```

## Работа с тенями

### Shadow токены

```dart
// Маленькие тени
context.shadows.xs
context.shadows.sm

// Средние тени
context.shadows.md

// Большие тени
context.shadows.lg
context.shadows.xl
```

### Примеры

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: context.shadows.md,
  ),
)

// Карточка с тенью
Container(
  decoration: BoxDecoration(
    color: context.colors.surface,
    borderRadius: BorderRadius.circular(context.borders.md),
    boxShadow: context.shadows.sm,
  ),
)
```

## Работа с анимациями

### Animation токены

```dart
// Быстрые анимации
context.animations.fast    // 150ms
context.animations.normal  // 300ms

// Медленные анимации
context.animations.slow    // 500ms
context.animations.slower  // 700ms
```

### Примеры

```dart
AnimatedContainer(
  duration: context.animations.normal,
  curve: Curves.easeInOut,
  // ...
)

AnimatedOpacity(
  duration: context.animations.fast,
  // ...
)
```

## Создание экранов

### Базовая структура

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.onSurface,
        title: Text(
          'Заголовок',
          style: context.typography.titleLargeStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Контент
          ],
        ),
      ),
    );
  }
}
```

### Использование компонентов

```dart
Column(
  children: [
    // Карточка
    NutryCard(
      title: 'Заголовок',
      child: Text('Контент'),
    ),
    
    SizedBox(height: context.spacing.md),
    
    // Кнопка
    NutryButton.primary(
      text: 'Действие',
      onPressed: () {},
    ),
  ],
)
```

## Best Practices

### 1. Всегда используйте токены

```dart
// ❌ Плохо
padding: EdgeInsets.all(16)

// ✅ Хорошо
padding: EdgeInsets.all(context.spacing.md)
```

### 2. Используйте динамические цвета

```dart
// ❌ Плохо
color: Colors.white

// ✅ Хорошо
color: context.colors.surface
```

### 3. Используйте компоненты вместо кастомных виджетов

```dart
// ❌ Плохо - кастомная кнопка
ElevatedButton(
  onPressed: () {},
  child: Text('Кнопка'),
)

// ✅ Хорошо - компонент дизайн-системы
NutryButton.primary(
  text: 'Кнопка',
  onPressed: () {},
)
```

### 4. Следуйте spacing системе

```dart
// ❌ Плохо - разные отступы
SizedBox(height: 12)
SizedBox(height: 18)
SizedBox(height: 20)

// ✅ Хорошо - токены
SizedBox(height: context.spacing.sm)
SizedBox(height: context.spacing.md)
SizedBox(height: context.spacing.lg)
```

### 5. Используйте правильную типографику

```dart
// ❌ Плохо - кастомные стили
Text(
  'Заголовок',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// ✅ Хорошо - токены типографики
Text(
  'Заголовок',
  style: context.typography.headlineMediumStyle,
)
```

## Доступность

### Минимальные размеры касания

Все интерактивные элементы должны иметь минимальный размер 44x44px:

```dart
// ✅ Хорошо
NutryButton.primary(
  text: 'Кнопка',
  size: NutryButtonSize.medium, // Автоматически 44x44px
  onPressed: () {},
)

// ✅ Хорошо - кастомный элемент
InkWell(
  onTap: () {},
  child: Container(
    width: 44,
    height: 44,
    // ...
  ),
)
```

### Контрастность

Все цветовые пары должны соответствовать WCAG 2.1 AA (минимум 4.5:1):

```dart
// ✅ Хорошо - автоматически соблюдается в компонентах
Text(
  'Текст',
  style: context.typography.bodyMediumStyle.copyWith(
    color: context.colors.onSurface, // Правильный контраст
  ),
)
```

### Screen Readers

Используйте семантику Flutter:

```dart
Semantics(
  label: 'Кнопка сохранения',
  button: true,
  child: NutryButton.primary(
    text: 'Сохранить',
    onPressed: () {},
  ),
)
```

## Визуальный Storybook

Для просмотра всех компонентов и их вариантов используйте визуальный Storybook:

```dart
// В app_router.dart уже добавлен маршрут
Navigator.pushNamed(context, '/design-system-storybook');
```

Или через GoRouter:

```dart
context.go('/design-system-storybook');
```

## Дополнительные ресурсы

- [Документация компонентов](./components/)
- [Обзор дизайн-системы](./design-system-overview.md)
- [Руководство по handoff](./design-handoff-guide.md)

