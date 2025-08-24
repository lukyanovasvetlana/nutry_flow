# Фича Dashboard - Главный экран приложения

## 📋 Обзор

Фича Dashboard является центральным экраном приложения Nutry Flow, предоставляющим пользователю обзор ключевых метрик, быстрый доступ к основным функциям и персонализированную информацию на основе профиля пользователя.

## 🏗️ Архитектура

### Структура фичи

```
lib/features/dashboard/
├── presentation/           # UI слой
│   ├── screens/           # Экраны дашборда
│   │   ├── dashboard_screen.dart      # Основной экран
│   │   └── dashboard_variants.dart    # Варианты отображения
│   └── widgets/           # Переиспользуемые виджеты
│       ├── stats_overview.dart        # Обзор статистики
│       ├── expense_chart.dart         # График расходов
│       ├── expense_breakdown_chart.dart # Детализация расходов
│       ├── products_chart.dart        # График продуктов
│       ├── products_breakdown_chart.dart # Детализация продуктов
│       ├── calories_chart.dart        # График калорий
│       └── calories_breakdown_chart.dart # Детализация калорий
```

### Основные компоненты

1. **DashboardScreen** - основной экран дашборда
2. **StatsOverview** - виджет обзора статистики
3. **Chart Widgets** - различные типы графиков и диаграмм
4. **FloatingMenu** - плавающее меню быстрого доступа

## 🚀 Использование

### Базовое использование

```dart
import 'package:nutry_flow/features/dashboard/presentation/screens/dashboard_screen.dart';

// Навигация к дашборду
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DashboardScreen()),
);

// Или через именованный роут
Navigator.pushNamed(context, '/dashboard');
```

### Интеграция с аналитикой

Dashboard автоматически интегрируется с системой аналитики:

```dart
// Отслеживание просмотра экрана
trackScreenView(AnalyticsUtils.screenDashboard);

// Отслеживание навигации
trackNavigation(
  fromScreen: AnalyticsUtils.screenDashboard,
  toScreen: 'healthy_menu_screen',
  navigationMethod: 'push',
);

// Отслеживание UI взаимодействий
trackUIInteraction(
  elementType: AnalyticsUtils.elementTypeList,
  elementName: 'dashboard_menu_item',
  action: AnalyticsUtils.actionSelect,
);
```

## 🔧 Функциональность

### 1. Персонализированное приветствие

Dashboard автоматически формирует приветствие на основе:
- Времени суток (утро, день, вечер, ночь)
- Профиля пользователя (имя, настройки)
- Текущей темы (светлая/темная)

```dart
// Временные интервалы
// 5:00 - 11:59: "Доброе утро"
// 12:00 - 16:59: "Добрый день"
// 17:00 - 21:59: "Добрый вечер"
// 22:00 - 4:59: "Добрый день" (или "Доброй ночи" в темной теме)
```

### 2. Система графиков

Dashboard поддерживает три основных типа графиков:

#### График расходов (Expenses)
- Основной график: линейный график расходов по дням
- Детализация: круговая диаграмма по категориям трат

#### График продуктов (Products)
- Основной график: столбчатая диаграмма потребления продуктов
- Детализация: распределение по типам продуктов

#### График калорий (Calories)
- Основной график: график калорийности по дням
- Детализация: распределение по макронутриентам

### 3. Быстрое меню

Плавающее меню предоставляет доступ к основным разделам:

- **Здоровое меню** - планирование питания
- **Упражнения** - фитнес и тренировки
- **Статьи о здоровье** - образовательный контент
- **Аналитика** - детальная статистика
- **Список покупок** - управление покупками

### 4. Адаптивный дизайн

Dashboard автоматически адаптируется к:
- Размеру экрана устройства
- Ориентации (портрет/ландшафт)
- Текущей теме (светлая/темная)
- Доступности (увеличенный текст, контраст)

## 📊 Интеграция с профилем

### Загрузка профиля

Dashboard автоматически загружает профиль пользователя:

1. **Локальное хранилище** - из SharedPreferences
2. **Mock сервис** - демо-профиль для тестирования
3. **Supabase** - реальный профиль (в продакшене)

```dart
Future<void> _loadUserProfile() async {
  try {
    // Сначала пробуем загрузить из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');
    
    if (userName != null && userName.isNotEmpty) {
      // Создаем локальный профиль
      final localProfile = UserProfile(
        id: 'local-user',
        firstName: userName,
        lastName: prefs.getString('userLastName') ?? '',
        email: prefs.getString('userEmail') ?? 'user@example.com',
        // ... другие поля
      );
      
      setState(() {
        _userProfile = localProfile;
        _isLoadingProfile = false;
      });
      
      // Отслеживаем успешную загрузку
      trackEvent('profile_loaded', parameters: {
        'profile_source': 'local_storage',
        'has_name': localProfile.firstName.isNotEmpty,
        'has_email': localProfile.email.isNotEmpty,
      });
    }
  } catch (e) {
    // Обработка ошибок
    trackError(
      errorType: 'profile_load_failed',
      errorMessage: e.toString(),
      additionalData: {'method': '_loadUserProfile'},
    );
  }
}
```

## 🎨 Дизайн и темы

### Цветовая схема

Dashboard использует динамическую цветовую схему:

```dart
// Основные цвета
AppColors.dynamicBackground    // Фон экрана
AppColors.dynamicCard         // Фон карточек
AppColors.dynamicPrimary      // Основной цвет
AppColors.dynamicTextPrimary  // Основной текст
AppColors.dynamicTextSecondary // Вторичный текст

// Цвета для графиков
AppColors.dynamicInfo         // Синий (расходы)
AppColors.dynamicGray         // Серый (продукты)
AppColors.dynamicError        // Красный (калории)
```

### Типографика

Используется система дизайн-токенов:

```dart
// Заголовки
DesignTokens.typography.headlineLargeStyle
DesignTokens.typography.titleLargeStyle
DesignTokens.typography.titleMediumStyle

// Основной текст
DesignTokens.typography.bodyMediumStyle
```

### Компоненты

Dashboard использует переиспользуемые компоненты:

```dart
// Карточки
NutryCard(
  backgroundColor: AppColors.dynamicCard,
  child: // содержимое
)

// Кнопки и иконки
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppColors.dynamicPrimary,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(
    Icons.restaurant_menu,
    color: AppColors.dynamicOnPrimary,
    size: 24,
  ),
)
```

## 🧪 Тестирование

### Unit тесты

```bash
# Запуск тестов для DashboardScreen
flutter test test/features/dashboard/presentation/screens/dashboard_screen_test.dart

# Запуск всех тестов фичи Dashboard
flutter test test/features/dashboard/
```

### Тестовые сценарии

- ✅ Отображение имени пользователя при наличии
- ✅ Отображение приветствия по умолчанию
- ✅ Отображение приветственного сообщения
- ✅ Отображение логотипа
- ✅ Загрузка профиля из SharedPreferences
- ✅ Загрузка демо-профиля
- ✅ Обработка ошибок загрузки

### Mock данные

Для тестирования используются:

```dart
// Mock SharedPreferences
SharedPreferences.setMockInitialValues({
  'userName': 'Анна',
  'userLastName': 'Иванова',
  'userEmail': 'anna@example.com',
});

// Mock ProfileService
final profileService = MockProfileService();
```

## 📱 Responsive дизайн

### Адаптация к экранам

Dashboard автоматически адаптируется к различным размерам экранов:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: // содержимое
      ),
    );
  },
)
```

### Обработка ориентации

```dart
// Автоматическая адаптация к ориентации
MediaQuery.of(context).orientation == Orientation.landscape
  ? _buildLandscapeLayout()
  : _buildPortraitLayout();
```

## 🔄 Состояние и жизненный цикл

### Управление состоянием

```dart
class _DashboardScreenState extends State<DashboardScreen> {
  int selectedChartIndex = 0;        // Выбранный график
  UserProfile? _userProfile;         // Профиль пользователя
  bool _isLoadingProfile = true;     // Статус загрузки
  
  @override
  void initState() {
    super.initState();
    trackScreenView(AnalyticsUtils.screenDashboard);
    _loadUserProfile();
  }
}
```

### Обработка жизненного цикла

```dart
// Проверка mounted перед setState
if (mounted) {
  setState(() {
    _userProfile = profile;
    _isLoadingProfile = false;
  });
}

// Отмена операций при размонтировании
@override
void dispose() {
  // Очистка ресурсов
  super.dispose();
}
```

## 🚨 Обработка ошибок

### Типы ошибок

1. **Ошибки загрузки профиля**
2. **Ошибки сети**
3. **Ошибки валидации данных**

### Стратегии обработки

```dart
try {
  await _loadUserProfile();
} catch (e) {
  // Логирование ошибки
  trackError(
    errorType: 'profile_load_failed',
    errorMessage: e.toString(),
    additionalData: {'method': '_loadUserProfile'},
  );
  
  // Показ пользователю
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ошибка загрузки профиля: $e'),
        backgroundColor: AppColors.dynamicError,
      ),
    );
  }
}
```

## 📈 Производительность

### Оптимизации

1. **Lazy loading** - загрузка данных по требованию
2. **Кэширование** - сохранение профиля в SharedPreferences
3. **Debouncing** - ограничение частоты обновлений
4. **Memoization** - кэширование вычисляемых значений

### Метрики

- Время загрузки экрана: < 500ms
- Время отклика на взаимодействие: < 100ms
- Использование памяти: < 50MB

## 🔒 Безопасность

### Валидация данных

```dart
// Проверка входных данных
if (userName != null && userName.isNotEmpty) {
  // Создание профиля только с валидными данными
}

// Санитизация данных
final sanitizedName = userName.trim();
if (sanitizedName.length > 100) {
  throw ArgumentError('Имя слишком длинное');
}
```

### Приватность

- Не логируем персональные данные
- Используем безопасное хранение (SharedPreferences)
- Соблюдаем принцип минимальной достаточности

## 🚀 Планы развития

### Краткосрочные (1-2 месяца)

- [ ] Добавить анимации переходов между графиками
- [ ] Реализовать pull-to-refresh
- [ ] Добавить поддержку жестов
- [ ] Улучшить accessibility

### Среднесрочные (3-6 месяцев)

- [ ] Добавить кастомизацию дашборда
- [ ] Реализовать виджеты по требованию
- [ ] Добавить поддержку темной темы
- [ ] Интеграция с push-уведомлениями

### Долгосрочные (6+ месяцев)

- [ ] AI-рекомендации на основе данных
- [ ] Социальные функции
- [ ] Интеграция с внешними сервисами
- [ ] Advanced analytics

## 🤝 Вклад в разработку

### Code Review чеклист

- [ ] JSDoc документация для всех методов
- [ ] Unit тесты с покрытием >80%
- [ ] Обработка ошибок и edge cases
- [ ] Responsive дизайн
- [ ] Accessibility поддержка

### Стандарты кода

- Используйте `///` для документации
- Следуйте naming conventions
- Обрабатывайте все возможные ошибки
- Пишите тесты для новых фич
- Используйте Design Tokens для стилизации

## 📞 Поддержка

### Полезные ссылки

- [Flutter Widget Testing](https://docs.flutter.dev/testing)
- [Material Design Guidelines](https://material.io/design)
- [Flutter Responsive Design](https://docs.flutter.dev/development/ui/layout/responsive)

### Команда

- **Product Owner**: [Имя]
- **Tech Lead**: [Имя]
- **QA Engineer**: [Имя]

---

*Последнее обновление: ${new Date().toLocaleDateString()}*
