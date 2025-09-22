# 🏠 Dashboard Feature

## Обзор

Dashboard - это главный экран приложения NutryFlow, который предоставляет пользователю обзор его прогресса в области питания и здоровья.

## Архитектура

### Структура папок
```
lib/features/dashboard/
├── presentation/
│   ├── screens/
│   │   └── dashboard_screen.dart      # Главный экран дашборда
│   └── widgets/
│       ├── stats_overview.dart        # Обзор статистики
│       ├── expense_chart.dart         # График расходов
│       ├── expense_breakdown_chart.dart # Детализация расходов
│       ├── products_chart.dart        # График продуктов
│       ├── products_breakdown_chart.dart # Детализация продуктов
│       ├── calories_chart.dart        # График калорий
│       └── calories_breakdown_chart.dart # Детализация калорий
```

## Основные компоненты

### 1. DashboardScreen
Главный экран дашборда с:
- Приветствием пользователя
- Статистикой питания
- Интерактивными диаграммами
- Плавающим меню навигации

### 2. StatsOverview
Виджет с карточками статистики:
- Стоимость питания
- Количество продуктов
- Калорийность

### 3. Charts
Интерактивные диаграммы:
- **ExpenseChart** - график расходов на питание
- **ProductsChart** - график потребления продуктов
- **CaloriesChart** - график калорийности

## Использование

### Базовое использование
```dart
import 'package:nutry_flow/features/dashboard/presentation/screens/dashboard_screen.dart';

// В навигации
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DashboardScreen()),
);
```

### С кастомным репозиторием
```dart
DashboardScreen(
  profileRepository: CustomProfileRepository(),
)
```

## Аналитика

Dashboard интегрирован с системой аналитики и отслеживает:
- Просмотры экрана
- Взаимодействия с карточками статистики
- Навигацию по меню
- Изменения выбранных графиков

## Тестирование

### Widget тесты
```bash
flutter test test/features/dashboard/
```

### Покрытие тестами
- ✅ DashboardScreen - 4 теста
- ❌ Widgets - требуются тесты

## Зависимости

- `shared_preferences` - для локального хранения
- `flutter/material.dart` - UI компоненты
- `go_router` - навигация
- `provider` - управление состоянием

## Известные проблемы

1. **Layout overflow** - некоторые диаграммы могут выходить за границы контейнера
2. **Memory leaks** - требуется оптимизация для больших наборов данных

## Планы развития

- [ ] Добавить анимации переходов
- [ ] Реализовать кастомизацию виджетов
- [ ] Добавить экспорт данных
- [ ] Улучшить responsive design

## Связанные фичи

- **Profile** - данные пользователя
- **Analytics** - детальная аналитика
- **Menu** - планирование питания
- **Nutrition** - отслеживание питания
