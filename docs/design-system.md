# Дизайн-Система NutryFlow

## 1. Цветовая Палитра

### 1.1 Основные Цвета
```dart
class NutryColors {
  // Primary
  static const primary = Color(0xFF2196F3);      // Основной синий
  static const primaryLight = Color(0xFF64B5F6); // Светлый синий
  static const primaryDark = Color(0xFF1976D2);  // Темный синий

  // Secondary
  static const secondary = Color(0xFF4CAF50);    // Зеленый для успеха
  static const secondaryLight = Color(0xFF81C784);
  static const secondaryDark = Color(0xFF388E3C);

  // Accent
  static const accent = Color(0xFFFF9800);       // Оранжевый для акцентов
  static const accentLight = Color(0xFFFFB74D);
  static const accentDark = Color(0xFFF57C00);

  // Neutral
  static const background = Color(0xFFF5F5F5);   // Фон
  static const surface = Color(0xFFFFFFFF);      // Поверхности
  static const error = Color(0xFFE53935);        // Ошибки
  static const success = Color(0xFF43A047);      // Успех
  static const warning = Color(0xFFFFA000);      // Предупреждения
  static const info = Color(0xFF039BE5);         // Информация
}
```

### 1.2 Семантические Цвета
```dart
class NutrySemanticColors {
  // Nutrition
  static const protein = Color(0xFFE91E63);      // Белки
  static const carbs = Color(0xFFFFC107);        // Углеводы
  static const fats = Color(0xFFFF9800);         // Жиры
  static const water = Color(0xFF03A9F4);        // Вода

  // Activity
  static const steps = Color(0xFF4CAF50);        // Шаги
  static const calories = Color(0xFFF44336);     // Калории
  static const distance = Color(0xFF9C27B0);     // Дистанция
  static const duration = Color(0xFF3F51B5);     // Длительность
}
```

## 2. Типографика

### 2.1 Шрифты
```dart
class NutryTypography {
  static const String fontFamily = 'Roboto';
  
  // Headlines
  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  
  // Body
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
  );
  
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
  );
  
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );
  
  // Buttons
  static const button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );
}
```

## 3. Компоненты

### 3.1 Кнопки
```dart
class NutryButtons {
  // Primary Button
  static final primary = ElevatedButton.styleFrom(
    backgroundColor: NutryColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // Secondary Button
  static final secondary = OutlinedButton.styleFrom(
    foregroundColor: NutryColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // Text Button
  static final text = TextButton.styleFrom(
    foregroundColor: NutryColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );
}
```

### 3.2 Карточки
```dart
class NutryCards {
  static final defaultCard = Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
    ),
  );
  
  static final elevatedCard = Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
    ),
  );
}
```

### 3.3 Поля Ввода
```dart
class NutryInputs {
  static final textField = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  );
  
  static final searchField = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    prefixIcon: const Icon(Icons.search),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  );
}
```

## 4. Иконография

### 4.1 Основные Иконки
```dart
class NutryIcons {
  // Navigation
  static const home = Icons.home_outlined;
  static const nutrition = Icons.restaurant_outlined;
  static const water = Icons.water_drop_outlined;
  static const activity = Icons.fitness_center_outlined;
  static const profile = Icons.person_outline;
  
  // Actions
  static const add = Icons.add_circle_outline;
  static const edit = Icons.edit_outlined;
  static const delete = Icons.delete_outline;
  static const save = Icons.save_outlined;
  static const share = Icons.share_outlined;
  
  // Nutrition
  static const protein = Icons.egg_outlined;
  static const carbs = Icons.grain_outlined;
  static const fats = Icons.oil_barrel_outlined;
  static const water = Icons.water_drop_outlined;
  
  // Activity
  static const steps = Icons.directions_walk_outlined;
  static const calories = Icons.local_fire_department_outlined;
  static const distance = Icons.straighten_outlined;
  static const duration = Icons.timer_outlined;
}
```

## 5. Анимации

### 5.1 Длительности
```dart
class NutryDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
}
```

### 5.2 Кривые
```dart
class NutryCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve accelerate = Curves.easeOut;
  static const Curve decelerate = Curves.easeIn;
  static const Curve sharp = Curves.easeInOutCubic;
}
```

## 6. Отступы и Размеры

### 6.1 Отступы
```dart
class NutrySpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### 6.2 Размеры
```dart
class NutrySizes {
  // Icons
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  
  // Buttons
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 88.0;
  
  // Inputs
  static const double inputHeight = 48.0;
  
  // Cards
  static const double cardBorderRadius = 12.0;
  static const double cardElevation = 2.0;
}
```

## 7. Тени

### 7.1 Уровни Теней
```dart
class NutryShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
```

## 8. Градиенты

### 8.1 Основные Градиенты
```dart
class NutryGradients {
  static const primary = LinearGradient(
    colors: [
      NutryColors.primary,
      NutryColors.primaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const secondary = LinearGradient(
    colors: [
      NutryColors.secondary,
      NutryColors.secondaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const accent = LinearGradient(
    colors: [
      NutryColors.accent,
      NutryColors.accentLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

## 9. Доступность

### 9.1 Контрастность
```dart
class NutryContrast {
  static const double minimum = 4.5;  // WCAG AA
  static const double enhanced = 7.0; // WCAG AAA
}
```

### 9.2 Размеры для Доступности
```dart
class NutryAccessibility {
  static const double minimumTouchTarget = 48.0;
  static const double minimumTextSize = 16.0;
  static const double minimumIconSize = 24.0;
}
```

## 10. Темная Тема

### 10.1 Цвета Темной Темы
```dart
class NutryDarkColors {
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const primary = Color(0xFF90CAF9);
  static const secondary = Color(0xFF81C784);
  static const accent = Color(0xFFFFB74D);
}
```

## 11. Использование

### 11.1 Пример Применения
```dart
class NutryTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: NutryColors.primary,
        secondary: NutryColors.secondary,
        surface: NutryColors.surface,
        background: NutryColors.background,
        error: NutryColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: NutryTypography.h1,
        displayMedium: NutryTypography.h2,
        displaySmall: NutryTypography.h3,
        bodyLarge: NutryTypography.bodyLarge,
        bodyMedium: NutryTypography.bodyMedium,
        bodySmall: NutryTypography.bodySmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: NutryButtons.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: NutryButtons.secondary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: NutryButtons.text,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NutryColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NutrySizes.cardBorderRadius),
        ),
      ),
    );
  }
}
``` 