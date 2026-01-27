# NutryButton - Документация компонента

## Обзор

`NutryButton` - универсальный компонент кнопки для приложения NutryFlow, поддерживающий различные стили, размеры и состояния.

## Импорт

```dart
import 'package:nutry_flow/shared/design/components/buttons/nutry_button.dart';
```

## Основные варианты

### Primary Button

Основная кнопка для главных действий.

```dart
NutryButton.primary(
  text: 'Сохранить',
  onPressed: () {
    // Действие
  },
)
```

### Secondary Button

Вторичная кнопка для дополнительных действий.

```dart
NutryButton.secondary(
  text: 'Отмена',
  onPressed: () {
    // Действие
  },
)
```

### Outline Button

Кнопка с обводкой для менее важных действий.

```dart
NutryButton.outline(
  text: 'Подробнее',
  onPressed: () {
    // Действие
  },
)
```

### Destructive Button

Кнопка для деструктивных действий (удаление, отмена).

```dart
NutryButton.destructive(
  text: 'Удалить',
  onPressed: () {
    // Действие
  },
)
```

## Размеры

### Small

```dart
NutryButton.primary(
  text: 'Маленькая',
  size: NutryButtonSize.small,
  onPressed: () {},
)
```

### Medium (по умолчанию)

```dart
NutryButton.primary(
  text: 'Средняя',
  size: NutryButtonSize.medium,
  onPressed: () {},
)
```

### Large

```dart
NutryButton.primary(
  text: 'Большая',
  size: NutryButtonSize.large,
  onPressed: () {},
)
```

## С иконками

```dart
NutryButton.primary(
  text: 'Добавить',
  icon: Icons.add,
  onPressed: () {},
)

NutryButton.secondary(
  text: 'Избранное',
  icon: Icons.favorite,
  iconPosition: IconPosition.right, // Иконка справа
  onPressed: () {},
)
```

## Состояния

### Loading

```dart
NutryButton.primary(
  text: 'Загрузка...',
  isLoading: true,
  onPressed: () {},
)
```

### Disabled

```dart
NutryButton.primary(
  text: 'Недоступно',
  onPressed: null, // null делает кнопку неактивной
)
```

## Полный пример

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Основное действие
          NutryButton.primary(
            text: 'Сохранить изменения',
            icon: Icons.save,
            size: NutryButtonSize.large,
            onPressed: () {
              _saveChanges();
            },
          ),
          
          SizedBox(height: 16),
          
          // Вторичное действие
          NutryButton.secondary(
            text: 'Отмена',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          
          SizedBox(height: 16),
          
          // Загрузка
          NutryButton.primary(
            text: 'Синхронизация',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : () {
              _syncData();
            },
          ),
        ],
      ),
    );
  }
}
```

## Best Practices

1. **Используйте Primary для главных действий** - не более одного Primary button на экране
2. **Secondary для альтернативных действий** - отмена, назад, дополнительные опции
3. **Outline для менее важных действий** - просмотр, детали
4. **Destructive для опасных действий** - удаление, сброс данных
5. **Всегда указывайте onPressed** - даже если это пустая функция
6. **Используйте isLoading** - вместо отключения кнопки при загрузке
7. **Размеры кнопок** - Small для компактных мест, Medium для стандартных, Large для важных действий

## Доступность

- Минимальный размер касания: 44x44px (автоматически соблюдается)
- Поддержка screen readers через семантику Flutter
- Контрастность соответствует WCAG 2.1 AA

