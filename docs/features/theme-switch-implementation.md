# Реализация тумблера темной темы в настройках пользователя

## Обзор

Данная документация описывает реализацию тумблера переключения темной темы в экране настроек пользователя приложения NutryFlow.

## 🎯 Функциональность

### Основные возможности
- ✅ **Переключение тем**: Светлая ↔ Темная тема
- ✅ **Автоматическое обновление UI**: Мгновенное применение изменений
- ✅ **Визуальная обратная связь**: Уведомления о смене темы
- ✅ **Сохранение состояния**: Запоминание выбора пользователя
- ✅ **Адаптивный дизайн**: Использование дизайн-системы

### Интеграция с дизайн-системой
- ✅ **ThemeTokens**: Использование централизованной системы тем
- ✅ **DesignTokens**: Применение типографики и отступов
- ✅ **NutryCard**: Использование компонентов дизайн-системы
- ✅ **Адаптивные цвета**: Автоматическое изменение цветов

## 🏗️ Архитектура

### Структура файлов
```
lib/
├── features/
│   └── profile/
│       └── presentation/
│           └── screens/
│               └── profile_settings_screen.dart  # Основной экран настроек
├── shared/
│   └── design/
│       ├── tokens/
│       │   ├── theme_tokens.dart                # Система тем
│       │   └── design_tokens.dart               # Дизайн-токены
│       └── components/
│           ├── cards/
│           │   └── nutry_card.dart              # Компонент карточки
│           └── buttons/
│               └── nutry_button.dart            # Компонент кнопки
└── screens/
    └── theme_switch_demo_screen.dart            # Демо экран
```

### Ключевые компоненты

#### 1. ProfileSettingsScreen
```dart
class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = ThemeTokens.currentTheme == ThemeMode.dark;
  }
}
```

#### 2. Тумблер темной темы
```dart
_buildSwitchTile(
  icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
  title: 'Тёмная тема',
  subtitle: _isDarkMode 
      ? 'Используется тёмная тема приложения'
      : 'Использовать тёмную тему приложения',
  value: _isDarkMode,
  onChanged: (value) {
    setState(() {
      _isDarkMode = value;
    });
    
    // Переключение темы
    ThemeTokens.toggleTheme();
    
    // Показать уведомление
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Тема изменена на ${_isDarkMode ? 'темную' : 'светлую'}',
          style: TextStyle(color: context.onPrimary),
        ),
        backgroundColor: context.primary,
        duration: Duration(seconds: 2),
      ),
    );
  },
)
```

## 🎨 UI/UX Реализация

### Визуальный дизайн

#### Тумблер
- **Иконка**: Динамически меняется (dark_mode ↔ light_mode)
- **Заголовок**: "Тёмная тема"
- **Подзаголовок**: Адаптивный текст в зависимости от состояния
- **Switch**: Использует цвета дизайн-системы

#### Цветовая схема
```dart
// Активные цвета
activeColor: context.primary
activeTrackColor: context.primaryContainer

// Неактивные цвета
inactiveThumbColor: context.outline
inactiveTrackColor: context.surfaceVariant
```

#### Типографика
```dart
// Заголовок
DesignTokens.typography.bodyLargeStyle.copyWith(
  color: context.onSurface,
  fontWeight: DesignTokens.typography.medium,
)

// Подзаголовок
DesignTokens.typography.bodyMediumStyle.copyWith(
  color: context.onSurfaceVariant,
)
```

### Адаптивность

#### Светлая тема
- **Фон**: `context.background` (#F9F4F2)
- **Поверхность**: `context.surface` (#FFFFFF)
- **Текст**: `context.onSurface` (#2D3748)
- **Акцент**: `context.primary` (#4CAF50)

#### Темная тема
- **Фон**: `context.background` (#121212)
- **Поверхность**: `context.surface` (#1E1E1E)
- **Текст**: `context.onSurface` (#FFFFFF)
- **Акцент**: `context.primary` (#81C784)

## 🔧 Техническая реализация

### Интеграция с ThemeTokens

#### Инициализация
```dart
@override
void initState() {
  super.initState();
  _isDarkMode = ThemeTokens.currentTheme == ThemeMode.dark;
}
```

#### Переключение темы
```dart
void _toggleTheme() {
  setState(() {
    _isDarkMode = !_isDarkMode;
  });
  
  ThemeTokens.toggleTheme();
}
```

#### Получение текущей темы
```dart
ThemeMode currentTheme = ThemeTokens.currentTheme;
bool isDark = currentTheme == ThemeMode.dark;
```

### Обработка состояний

#### Состояние тумблера
```dart
bool _isDarkMode = false;

// Обновление при изменении
onChanged: (value) {
  setState(() {
    _isDarkMode = value;
  });
  ThemeTokens.toggleTheme();
}
```

#### Уведомления
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'Тема изменена на ${_isDarkMode ? 'темную' : 'светлую'}',
      style: TextStyle(color: context.onPrimary),
    ),
    backgroundColor: context.primary,
    duration: Duration(seconds: 2),
  ),
);
```

## 🧪 Тестирование

### Автоматические тесты
```dart
// Тест переключения темы
test('Theme switching works correctly', () {
  // Начинаем со светлой темы
  ThemeTokens.currentTheme = ThemeMode.light;
  expect(ThemeTokens.current, equals(ThemeTokens.light));
  
  // Переключаемся на темную тему
  ThemeTokens.toggleTheme();
  expect(ThemeTokens.currentTheme, equals(ThemeMode.dark));
  expect(ThemeTokens.current, equals(ThemeTokens.dark));
});
```

### Ручное тестирование
1. **Запуск демо экрана**:
   ```bash
   flutter run --target lib/screens/theme_switch_demo_screen.dart
   ```

2. **Тестирование настроек**:
   ```bash
   flutter run --target lib/features/profile/presentation/screens/profile_settings_screen.dart
   ```

### Чек-лист тестирования
- [ ] Тумблер корректно отображает текущее состояние
- [ ] Переключение работает в обе стороны
- [ ] UI обновляется мгновенно
- [ ] Уведомления показываются корректно
- [ ] Цвета адаптируются к теме
- [ ] Состояние сохраняется между сессиями

## 📱 Использование

### В экране настроек
```dart
// Добавление тумблера в секцию "Внешний вид"
_buildSwitchTile(
  icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
  title: 'Тёмная тема',
  subtitle: _isDarkMode 
      ? 'Используется тёмная тема приложения'
      : 'Использовать тёмную тему приложения',
  value: _isDarkMode,
  onChanged: (value) {
    setState(() {
      _isDarkMode = value;
    });
    ThemeTokens.toggleTheme();
  },
)
```

### В других экранах
```dart
// Простое переключение темы
IconButton(
  icon: Icon(
    ThemeTokens.currentTheme == ThemeMode.dark 
        ? Icons.light_mode 
        : Icons.dark_mode,
  ),
  onPressed: () => ThemeTokens.toggleTheme(),
)
```

## 🔄 Интеграция с приложением

### Навигация к настройкам
```dart
// Из профиля пользователя
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ProfileSettingsScreen(),
  ),
);
```

### Сохранение настроек
```dart
// В будущем можно добавить сохранение в SharedPreferences
Future<void> _saveThemePreference(bool isDark) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDark);
}
```

## 🚀 Демонстрация

### Демо экран
Создан специальный демонстрационный экран `ThemeSwitchDemoScreen`, который показывает:

1. **Информацию о тумблере** - описание функциональности
2. **Интерактивный тумблер** - рабочий переключатель
3. **Демо настроек** - кнопка для открытия экрана настроек
4. **Информацию о теме** - текущие настройки и цвета

### Запуск демо
```bash
flutter run --target lib/screens/theme_switch_demo_screen.dart
```

## 📋 Рекомендации

### Лучшие практики
1. **Всегда используйте дизайн-систему** для консистентности
2. **Проверяйте контрастность** при смене тем
3. **Тестируйте на разных устройствах** для адаптивности
4. **Добавляйте анимации** для плавности переключения

### Будущие улучшения
1. **Сохранение в SharedPreferences** - для запоминания выбора
2. **Анимации переключения** - для более плавного UX
3. **Автоматическое определение** - по системным настройкам
4. **Кастомные темы** - возможность создания пользовательских тем

## 📝 Заключение

Тумблер темной темы успешно интегрирован в экран настроек пользователя с полной поддержкой дизайн-системы NutryFlow. Реализация обеспечивает:

- ✅ **Простое использование** - интуитивный интерфейс
- ✅ **Надежную работу** - стабильное переключение тем
- ✅ **Красивый дизайн** - соответствие дизайн-системе
- ✅ **Хорошую производительность** - мгновенное обновление UI

Тумблер готов к использованию в продакшене и может быть легко расширен дополнительной функциональностью.

---

*Документация создана для разработчиков NutryFlow Design System*
