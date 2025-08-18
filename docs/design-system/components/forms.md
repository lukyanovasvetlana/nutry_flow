# Компоненты форм NutryFlow

## Обзор

Компоненты форм обеспечивают единообразный и доступный пользовательский интерфейс для ввода данных в приложении NutryFlow.

## NutryInput

Универсальный компонент поля ввода с полным набором состояний и валидации.

### Основные возможности

- ✅ **Типизированные поля**: text, email, password, number, phone, url, multiline, search
- ✅ **Размеры**: small, medium, large
- ✅ **Состояния**: normal, focused, error, success, disabled, loading
- ✅ **Валидация**: встроенная и кастомная
- ✅ **Иконки**: prefix и suffix иконки
- ✅ **Доступность**: полная поддержка screen readers

### Использование

#### Базовое использование

```dart
import 'package:nutry_flow/shared/design/components/forms/forms.dart';

// Текстовое поле
NutryInput.text(
  label: 'Имя',
  controller: nameController,
  hint: 'Введите ваше имя',
);

// Email поле
NutryInput.email(
  label: 'Email',
  controller: emailController,
  hint: 'Введите ваш email',
);

// Поле пароля
NutryInput.password(
  label: 'Пароль',
  controller: passwordController,
  hint: 'Введите ваш пароль',
);

// Числовое поле
NutryInput.number(
  label: 'Возраст',
  controller: ageController,
  hint: 'Введите ваш возраст',
);
```

#### Фабричные методы

```dart
// Email поле с автоматической валидацией
NutryInput.email(
  label: 'Email',
  controller: emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Некорректный email';
    }
    return null;
  },
);

// Поле пароля с кастомной валидацией
NutryInput.password(
  label: 'Пароль',
  controller: passwordController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Пароль должен содержать буквы и цифры';
    }
    return null;
  },
);
```

#### Размеры

```dart
// Маленькое поле
NutryInput.text(
  label: 'Код',
  controller: codeController,
  size: NutryInputSize.small,
);

// Среднее поле (по умолчанию)
NutryInput.text(
  label: 'Имя',
  controller: nameController,
  size: NutryInputSize.medium,
);

// Большое поле
NutryInput.text(
  label: 'Описание',
  controller: descriptionController,
  size: NutryInputSize.large,
  maxLines: 3,
);
```

#### Состояния

```dart
// Обычное состояние
NutryInput.text(
  label: 'Имя',
  controller: nameController,
);

// Состояние с ошибкой
NutryInput.text(
  label: 'Email',
  controller: emailController,
  errorText: 'Некорректный email',
);

// Состояние успеха
NutryInput.text(
  label: 'Email',
  controller: emailController,
  successText: 'Email подтвержден',
);

// Отключенное состояние
NutryInput.text(
  label: 'Email',
  controller: emailController,
  enabled: false,
);
```

#### Иконки

```dart
// С prefix иконкой
NutryInput.text(
  label: 'Поиск',
  controller: searchController,
  prefixIcon: Icons.search,
);

// С suffix иконкой
NutryInput.text(
  label: 'Ссылка',
  controller: urlController,
  suffixIcon: Icons.link,
);

// С кастомным suffix виджетом
NutryInput.text(
  label: 'Количество',
  controller: quantityController,
  suffixWidget: IconButton(
    icon: Icon(Icons.add),
    onPressed: () => incrementQuantity(),
  ),
);
```

### Параметры

| Параметр | Тип | Описание |
|----------|-----|----------|
| `controller` | `TextEditingController?` | Контроллер поля |
| `type` | `NutryInputType` | Тип поля ввода |
| `size` | `NutryInputSize` | Размер поля |
| `label` | `String?` | Подпись поля |
| `hint` | `String?` | Подсказка |
| `errorText` | `String?` | Текст ошибки |
| `successText` | `String?` | Текст успеха |
| `helperText` | `String?` | Вспомогательный текст |
| `prefixIcon` | `IconData?` | Иконка слева |
| `suffixIcon` | `IconData?` | Иконка справа |
| `suffixWidget` | `Widget?` | Виджет справа |
| `maxLines` | `int?` | Максимальное количество строк |
| `maxLength` | `int?` | Максимальное количество символов |
| `inputFormatters` | `List<TextInputFormatter>?` | Форматтеры ввода |
| `validator` | `String? Function(String?)?` | Валидатор |
| `onChanged` | `ValueChanged<String>?` | Обработчик изменения |
| `onSubmitted` | `ValueChanged<String>?` | Обработчик отправки |
| `onTap` | `VoidCallback?` | Обработчик нажатия |
| `autofocus` | `bool` | Автофокус |
| `readOnly` | `bool` | Только для чтения |
| `enabled` | `bool` | Отключено |
| `showCounter` | `bool` | Показывать счетчик символов |
| `obscureText` | `bool` | Скрывать текст |
| `width` | `double?` | Ширина поля |
| `height` | `double?` | Высота поля |
| `padding` | `EdgeInsetsGeometry?` | Отступы |
| `margin` | `EdgeInsetsGeometry?` | Отступы снаружи |

## NutryForm

Универсальный компонент формы с валидацией и состояниями.

### Основные возможности

- ✅ **Типизированные формы**: login, register, settings
- ✅ **Состояния**: normal, loading, success, error, disabled
- ✅ **Валидация**: автоматическая валидация всех полей
- ✅ **Сообщения**: ошибки, успех, загрузка
- ✅ **Действия**: отправка и сброс формы

### Использование

#### Базовое использование

```dart
import 'package:nutry_flow/shared/design/components/forms/forms.dart';

// Простая форма
NutryForm(
  children: [
    NutryInput.text(label: 'Имя', controller: nameController),
    NutryInput.email(label: 'Email', controller: emailController),
  ],
  onSubmit: () => handleSubmit(),
  onReset: () => handleReset(),
);
```

#### Типизированные формы

```dart
// Форма входа
NutryForm.login(
  children: [
    NutryInput.email(label: 'Email', controller: emailController),
    NutryInput.password(label: 'Пароль', controller: passwordController),
  ],
  onSubmit: () => handleLogin(),
  state: NutryFormState.loading,
  errorMessage: 'Неверный email или пароль',
);

// Форма регистрации
NutryForm.register(
  children: [
    NutryInput.email(label: 'Email', controller: emailController),
    NutryInput.password(label: 'Пароль', controller: passwordController),
    NutryInput.password(
      label: 'Подтвердите пароль',
      controller: confirmPasswordController,
      validator: (value) {
        if (value != passwordController.text) {
          return 'Пароли не совпадают';
        }
        return null;
      },
    ),
  ],
  onSubmit: () => handleRegister(),
);

// Форма настроек
NutryForm.settings(
  children: [
    NutryInput.text(label: 'Имя', controller: firstNameController),
    NutryInput.text(label: 'Фамилия', controller: lastNameController),
    NutryInput.email(label: 'Email', controller: emailController),
  ],
  onSubmit: () => handleSave(),
  onReset: () => handleCancel(),
  successMessage: 'Настройки сохранены',
);
```

#### Состояния формы

```dart
// Обычное состояние
NutryForm(
  children: [...],
  state: NutryFormState.normal,
);

// Загрузка
NutryForm(
  children: [...],
  state: NutryFormState.loading,
  loadingMessage: 'Сохранение...',
);

// Ошибка
NutryForm(
  children: [...],
  state: NutryFormState.error,
  errorMessage: 'Произошла ошибка',
);

// Успех
NutryForm(
  children: [...],
  state: NutryFormState.success,
  successMessage: 'Данные сохранены',
);
```

### NutryFormBuilder

Вспомогательный класс для быстрого создания типовых форм.

```dart
// Форма входа
NutryFormBuilder.buildLoginForm(
  emailController: emailController,
  passwordController: passwordController,
  onLogin: () => handleLogin(),
  state: NutryFormState.loading,
  errorMessage: 'Неверные данные',
);

// Форма регистрации
NutryFormBuilder.buildRegisterForm(
  emailController: emailController,
  passwordController: passwordController,
  confirmPasswordController: confirmPasswordController,
  onRegister: () => handleRegister(),
);

// Форма профиля
NutryFormBuilder.buildProfileForm(
  firstNameController: firstNameController,
  lastNameController: lastNameController,
  emailController: emailController,
  onSave: () => handleSave(),
  onCancel: () => handleCancel(),
  successMessage: 'Профиль обновлен',
);
```

### Параметры NutryForm

| Параметр | Тип | Описание |
|----------|-----|----------|
| `formKey` | `GlobalKey<FormState>?` | Ключ формы |
| `children` | `List<Widget>` | Дочерние виджеты |
| `state` | `NutryFormState` | Состояние формы |
| `errorMessage` | `String?` | Сообщение об ошибке |
| `successMessage` | `String?` | Сообщение об успехе |
| `loadingMessage` | `String?` | Сообщение о загрузке |
| `onSubmit` | `VoidCallback?` | Обработчик отправки |
| `onReset` | `VoidCallback?` | Обработчик сброса |
| `padding` | `EdgeInsetsGeometry?` | Отступы формы |
| `margin` | `EdgeInsetsGeometry?` | Отступы снаружи |
| `width` | `double?` | Ширина формы |
| `height` | `double?` | Высота формы |
| `showActions` | `bool` | Показывать кнопки действий |
| `submitText` | `String` | Текст кнопки отправки |
| `resetText` | `String` | Текст кнопки сброса |
| `disableActions` | `bool` | Отключить кнопки |

## Лучшие практики

### 1. Валидация

```dart
// Используйте встроенные валидаторы
NutryInput.email(
  label: 'Email',
  controller: emailController,
  // Автоматическая валидация email
);

// Создавайте кастомные валидаторы для специфичных требований
NutryInput.password(
  label: 'Пароль',
  controller: passwordController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Минимум 8 символов';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Должен содержать буквы и цифры';
    }
    return null;
  },
);
```

### 2. Состояния

```dart
// Всегда обрабатывайте все состояния
NutryForm(
  children: [...],
  state: isLoading ? NutryFormState.loading : NutryFormState.normal,
  errorMessage: errorMessage,
  successMessage: successMessage,
  disableActions: isLoading,
);
```

### 3. Доступность

```dart
// Используйте семантические лейблы
NutryInput.text(
  label: 'Имя пользователя',
  controller: usernameController,
  hint: 'Введите ваше имя пользователя',
  helperText: 'Имя будет отображаться в профиле',
);
```

### 4. Производительность

```dart
// Используйте контроллеры для управления состоянием
final TextEditingController emailController = TextEditingController();

@override
void dispose() {
  emailController.dispose();
  super.dispose();
}
```

## Примеры использования

### Форма входа

```dart
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing.screenPadding),
        child: NutryForm.login(
          formKey: _formKey,
          state: _isLoading ? NutryFormState.loading : NutryFormState.normal,
          errorMessage: _errorMessage,
          onSubmit: _handleLogin,
          disableActions: _isLoading,
          children: [
            NutryInput.email(
              label: 'Email',
              controller: _emailController,
              hint: 'Введите ваш email',
            ),
            SizedBox(height: DesignTokens.spacing.md),
            NutryInput.password(
              label: 'Пароль',
              controller: _passwordController,
              hint: 'Введите ваш пароль',
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Логика входа
      await authService.login(
        _emailController.text,
        _passwordController.text,
      );
      
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      setState(() {
        _errorMessage = 'Неверный email или пароль';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

### Форма профиля

```dart
class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать профиль')),
      body: NutryForm.settings(
        formKey: _formKey,
        state: _isLoading ? NutryFormState.loading : NutryFormState.normal,
        errorMessage: _errorMessage,
        successMessage: _successMessage,
        onSubmit: _handleSave,
        onReset: _handleCancel,
        disableActions: _isLoading,
        children: [
          Row(
            children: [
              Expanded(
                child: NutryInput.text(
                  label: 'Имя',
                  controller: _firstNameController,
                  hint: 'Введите ваше имя',
                ),
              ),
              SizedBox(width: DesignTokens.spacing.md),
              Expanded(
                child: NutryInput.text(
                  label: 'Фамилия',
                  controller: _lastNameController,
                  hint: 'Введите вашу фамилию',
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacing.md),
          NutryInput.email(
            label: 'Email',
            controller: _emailController,
            hint: 'Введите ваш email',
          ),
        ],
      ),
    );
  }

  void _loadUserData() {
    final user = userService.currentUser;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
  }

  void _handleSave() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await userService.updateProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
      );
      
      setState(() {
        _successMessage = 'Профиль обновлен';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при обновлении профиля';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
```

## Миграция с старых компонентов

Для миграции с старых компонентов используйте скрипт:

```bash
python scripts/migrate_to_design_system.py
```

Этот скрипт автоматически:
- Создаст резервные копии файлов
- Заменит старые компоненты на новые
- Обновит импорты
- Сгенерирует отчет о миграции

## Тестирование

### Unit тесты

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/shared/design/components/forms/forms.dart';

void main() {
  group('NutryInput', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NutryInput.text(
            label: 'Test',
            controller: TextEditingController(),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('validates email correctly', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: NutryInput.email(
            label: 'Email',
            controller: controller,
          ),
        ),
      );

      controller.text = 'invalid-email';
      await tester.pump();

      // Проверяем, что ошибка отображается
      expect(find.text('Некорректный email'), findsOneWidget);
    });
  });
}
```

### Integration тесты

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/auth/presentation/screens/login_screen.dart';

void main() {
  group('Login Form', () {
    testWidgets('submits form with valid data', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Заполняем форму
      await tester.enterText(
        find.byType(NutryInput),
        'test@example.com',
      );
      await tester.enterText(
        find.byType(NutryInput).last,
        'password123',
      );

      // Нажимаем кнопку входа
      await tester.tap(find.text('Войти'));
      await tester.pump();

      // Проверяем, что форма отправлена
      expect(find.text('Войти'), findsOneWidget);
    });
  });
}
```
