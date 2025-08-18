# План Исправления Ошибок - NutryFlow

## 🚨 Критические ошибки (624 issues)

### Приоритет 1: Отсутствующие файлы

#### 1. Создать файлы entities
```bash
# Создать структуру папок
mkdir -p lib/features/meal_plan/domain/entities
mkdir -p lib/features/exercise/domain/entities

# Создать файлы
touch lib/features/meal_plan/domain/entities/meal.dart
touch lib/features/exercise/domain/entities/exercise.dart
```

#### 2. Создать базовые классы
```dart
// lib/features/meal_plan/domain/entities/meal.dart
class Meal {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final List<String> foodItems;
  final String mealType;
  final double sodiumConsumed;
  final double sugarConsumed;
  final double totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarbs;
  final bool isActive;

  const Meal({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.foodItems,
    required this.mealType,
    required this.sodiumConsumed,
    required this.sugarConsumed,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbs,
    required this.isActive,
  });
}
```

```dart
// lib/features/exercise/domain/entities/exercise.dart
class Exercise {
  final String id;
  final String name;
  final String description;
  final String category;
  final int duration;
  final int caloriesBurned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.duration,
    required this.caloriesBurned,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });
}
```

### Приоритет 2: Исправить дизайн-систему

#### 1. Исправить nutry_animations.dart
```bash
# Открыть файл для редактирования
code lib/shared/design/components/animations/nutry_animations.dart
```

**Проблемы:**
- Использование ключевого слова `in` как идентификатор
- Неопределенный `context`
- Проблемы с инициализацией контроллеров

**Исправления:**
- Заменить `in` на `inAnimation`
- Добавить параметр `BuildContext context`
- Исправить инициализацию контроллеров

#### 2. Исправить nutry_form.dart
```bash
# Открыть файл для редактирования
code lib/shared/design/components/forms/nutry_form.dart
```

**Проблемы:**
- `BorderRadius` вместо `double` для borderRadius
- Неправильные типы данных

**Исправления:**
```dart
// Заменить
borderRadius: DesignTokens.borders.cardRadius,
// На
borderRadius: BorderRadius.circular(16.0),
```

#### 3. Исправить nutry_select.dart
```bash
# Открыть файл для редактирования
code lib/shared/design/components/forms/nutry_select.dart
```

**Проблемы:**
- Type parameters в конструкторах
- Неправильные типы для borderRadius

**Исправления:**
```dart
// Убрать type parameters из конструкторов
const NutrySelect.dropdown({
  // параметры
});

// Исправить borderRadius
borderRadius: BorderRadius.circular(16.0),
```

### Приоритет 3: Исправить тесты

#### 1. Сгенерировать mock файлы
```bash
# Установить build_runner
flutter packages pub run build_runner build --delete-conflicting-outputs

# Или в режиме наблюдения
flutter packages pub run build_runner watch
```

#### 2. Исправить импорты в тестах
```bash
# Найти все файлы с неправильными импортами
find test/ -name "*.dart" -exec grep -l "package:nutry_flow/features/meal_plan/domain/entities/meal.dart" {} \;
find test/ -name "*.dart" -exec grep -l "package:nutry_flow/features/exercise/domain/entities/exercise.dart" {} \;
```

### Приоритет 4: Исправить уведомления

#### 1. Исправить notification_repository.dart
```bash
# Открыть файл для редактирования
code lib/features/notifications/data/repositories/notification_repository.dart
```

**Проблемы:**
- Неправильные типы данных
- Отсутствующие геттеры

**Исправления:**
```dart
// Заменить DateTime на TZDateTime
final TZDateTime scheduledTime = TZDateTime.from(dateTime, local);

// Добавить недостающие геттеры в NotificationService
String get _mealReminderChannel => 'meal_reminders';
String get _workoutReminderChannel => 'workout_reminders';
String get _goalReminderChannel => 'goal_reminders';
String get _generalChannel => 'general';
```

## 🛠️ Команды для исправления

### 1. Создать отсутствующие файлы
```bash
# Создать структуру папок
mkdir -p lib/features/meal_plan/domain/entities
mkdir -p lib/features/exercise/domain/entities

# Создать файлы с базовыми классами
cat > lib/features/meal_plan/domain/entities/meal.dart << 'EOF'
class Meal {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final List<String> foodItems;
  final String mealType;
  final double sodiumConsumed;
  final double sugarConsumed;
  final double totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarbs;
  final bool isActive;

  const Meal({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.foodItems,
    required this.mealType,
    required this.sodiumConsumed,
    required this.sugarConsumed,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbs,
    required this.isActive,
  });
}
EOF

cat > lib/features/exercise/domain/entities/exercise.dart << 'EOF'
class Exercise {
  final String id;
  final String name;
  final String description;
  final String category;
  final int duration;
  final int caloriesBurned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.duration,
    required this.caloriesBurned,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });
}
EOF
```

### 2. Сгенерировать mock файлы
```bash
# Установить зависимости для тестирования
flutter pub add --dev mockito build_runner

# Сгенерировать mock файлы
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Проверить исправления
```bash
# Проверить анализ кода
flutter analyze

# Запустить тесты
flutter test

# Проверить компиляцию
flutter build apk --debug
```

## 📋 Чек-лист исправлений

- [ ] Создать `lib/features/meal_plan/domain/entities/meal.dart`
- [ ] Создать `lib/features/exercise/domain/entities/exercise.dart`
- [ ] Исправить `nutry_animations.dart`
- [ ] Исправить `nutry_form.dart`
- [ ] Исправить `nutry_select.dart`
- [ ] Исправить `notification_repository.dart`
- [ ] Сгенерировать mock файлы
- [ ] Исправить импорты в тестах
- [ ] Убрать неиспользуемые импорты
- [ ] Исправить deprecated методы
- [ ] Добавить @override аннотации

## 🎯 Ожидаемый результат

После исправления всех ошибок:
- ✅ `flutter analyze` - 0 ошибок
- ✅ `flutter test` - все тесты проходят
- ✅ `flutter run` - приложение запускается
- ✅ `flutter build apk` - успешная сборка

## 📞 Поддержка

При возникновении проблем:
- **Tech Lead**: [tech.lead@company.com]
- **Slack**: #nutryflow-dev
- **GitHub Issues**: Создайте issue с тегом `bugfix`

---

**Версия**: 1.0  
**Статус**: В разработке  
**Следующий обзор**: После исправления всех ошибок
