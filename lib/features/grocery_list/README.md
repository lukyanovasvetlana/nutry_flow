# 🛒 Grocery List Feature

## 📋 Обзор

Модуль Grocery List отвечает за управление списком покупок, планирование покупок и интеграцию с рецептами.

## 🏗️ Архитектура

### Domain Layer
- **Entities**: `GroceryItem`
- **Repositories**: `GroceryRepository`
- **Use Cases**: `GetGroceryItemsUsecase`

### Data Layer
- **Repositories**: `GroceryRepositoryImpl`

### Presentation Layer
- **Screens**: `GroceryListScreen`

## 🚀 Основные функции

### 1. Управление списком покупок
- Добавление и удаление товаров
- Редактирование количества
- Отметка о покупке
- Категоризация товаров

### 2. Планирование покупок
- Создание списков на основе рецептов
- Планирование на неделю
- Сохранение избранных списков
- Шаблоны списков

### 3. Интеграция с рецептами
- Автоматическое добавление ингредиентов
- Расчет количества продуктов
- Список покупок для меню
- Синхронизация с планами питания

### 4. Управление категориями
- Группировка по категориям
- Сортировка товаров
- Фильтрация по категориям
- Персональные категории

## 📱 Экраны

### GroceryListScreen
Главный экран списка покупок с возможностью управления товарами.

## 🧪 Тестирование

### Unit Tests
```bash
flutter test test/features/grocery_list/data/repositories/grocery_repository_test.dart
```

### Widget Tests
```bash
flutter test test/features/grocery_list/presentation/screens/grocery_list_screen_test.dart
```

### Integration Tests
```bash
flutter test integration_test/grocery_list_integration_test.dart
```

## 🔧 Использование

### Добавление товара
```dart
final groceryService = GroceryService();
final item = GroceryItem(
  name: 'Молоко',
  quantity: 1,
  unit: 'литр',
  category: 'Молочные продукты',
  isPurchased: false,
);
await groceryService.addItem(item);
```

### Получение списка
```dart
final items = await groceryService.getGroceryItems();
```

### Отметка о покупке
```dart
await groceryService.markAsPurchased(itemId);
```

## ⚠️ Обработка ошибок

- **Дублирование товаров**: Проверка существующих записей
- **Неверные данные**: Валидация товаров
- **Ошибки синхронизации**: Retry механизм
- **Пустые списки**: Обработка пустых состояний

## 🚀 Планы развития

- [ ] Интеграция с магазинами
- [ ] Сканирование штрих-кодов
- [ ] Сравнение цен
- [ ] Доставка продуктов
- [ ] Семейные списки

## 🔗 Связанные фичи

- **Menu**: Интеграция с рецептами
- **Nutrition**: Планирование питания
- **Profile**: Персональные предпочтения
- **Notifications**: Напоминания о покупках

---

**Версия**: 1.0.0  
**Последнее обновление**: $(date)  
**Статус**: ✅ Готово к использованию
