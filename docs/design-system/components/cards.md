# NutryCard - Документация компонента

## Обзор

`NutryCard` - универсальный компонент карточки для отображения контента с различными стилями и состояниями.

## Импорт

```dart
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';
```

## Базовое использование

### Простая карточка

```dart
NutryCard(
  title: 'Заголовок карточки',
  child: Text('Содержимое карточки'),
)
```

### С подзаголовком и иконкой

```dart
NutryCard(
  title: 'Статистика',
  subtitle: 'За сегодня',
  icon: Icons.bar_chart,
  child: Text('Данные...'),
)
```

### Интерактивная карточка

```dart
NutryCard(
  title: 'Нажмите для деталей',
  onTap: () {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => DetailsScreen(),
    ));
  },
  child: Text('Контент'),
)
```

## Варианты стилей

### Primary Card

```dart
NutryCard.primary(
  title: 'Основная карточка',
  child: Text('Контент'),
)
```

### Accent Card

```dart
NutryCard.accent(
  title: 'Акцентная карточка',
  child: Text('Контент'),
)
```

### Success Card

```dart
NutryCard.success(
  title: 'Успешно',
  child: Text('Операция выполнена'),
)
```

### Warning Card

```dart
NutryCard.warning(
  title: 'Внимание',
  child: Text('Проверьте данные'),
)
```

### Error Card

```dart
NutryCard.error(
  title: 'Ошибка',
  child: Text('Что-то пошло не так'),
)
```

## Gradient Cards

### Primary Gradient

```dart
NutryGradientCard.primary(
  title: 'Градиентная карточка',
  child: Text('Контент с градиентом'),
)
```

### Secondary Gradient

```dart
NutryGradientCard.secondary(
  title: 'Вторичный градиент',
  child: Text('Контент'),
)
```

### Accent Gradient

```dart
NutryGradientCard.accent(
  title: 'Акцентный градиент',
  child: Text('Контент'),
)
```

## Состояния

### Loading State

```dart
NutryCard(
  title: 'Загрузка данных',
  isLoading: true,
  child: SizedBox(),
)
```

### Empty State

```dart
NutryCard(
  title: 'Нет данных',
  isEmpty: true,
  child: SizedBox(),
)
```

## Полный пример

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Статистическая карточка
          NutryCard(
            title: 'Калории',
            subtitle: 'Сегодня',
            icon: Icons.local_fire_department,
            child: Column(
              children: [
                Text('2000', style: TextStyle(fontSize: 32)),
                Text('из 2500 ккал'),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Интерактивная карточка
          NutryCard(
            title: 'Тренировка',
            subtitle: 'Нажмите для начала',
            icon: Icons.fitness_center,
            onTap: () {
              _startWorkout();
            },
            child: Text('Начать тренировку'),
          ),
          
          SizedBox(height: 16),
          
          // Карточка с градиентом
          NutryGradientCard.primary(
            title: 'Достижение',
            child: Column(
              children: [
                Icon(Icons.emoji_events, size: 48),
                Text('Новый рекорд!'),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Карточка загрузки
          if (_isLoading)
            NutryCard(
              title: 'Синхронизация',
              isLoading: true,
              child: SizedBox(),
            ),
        ],
      ),
    );
  }
}
```

## Кастомизация

### С кастомным отступом

```dart
NutryCard(
  title: 'Карточка',
  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  child: Text('Контент'),
)
```

### С кастомным фоном

```dart
NutryCard(
  title: 'Карточка',
  backgroundColor: Colors.blue.shade50,
  child: Text('Контент'),
)
```

## Best Practices

1. **Используйте карточки для группировки связанного контента**
2. **Primary/Accent для важной информации**
3. **Success/Warning/Error для статусов**
4. **Gradient для выделения важных элементов**
5. **onTap для интерактивных карточек**
6. **isLoading/isEmpty для состояний загрузки**
7. **Не перегружайте карточки контентом** - используйте несколько карточек

## Доступность

- Поддержка screen readers через семантику
- Контрастность соответствует WCAG 2.1 AA
- Интерактивные карточки имеют минимальный размер касания 44x44px

