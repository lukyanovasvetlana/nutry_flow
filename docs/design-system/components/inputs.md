# NutryInput - Документация компонента

## Обзор

`NutryInput` - универсальный компонент поля ввода с поддержкой различных типов, валидации и состояний.

## Импорт

```dart
import 'package:nutry_flow/shared/design/components/forms/nutry_input.dart';
```

## Типы полей

### Text Input

```dart
NutryInput.text(
  label: 'Имя',
  controller: _nameController,
  hint: 'Введите ваше имя',
)
```

### Email Input

```dart
NutryInput.email(
  label: 'Email',
  controller: _emailController,
  hint: 'example@mail.com',
)
```

### Password Input

```dart
NutryInput.password(
  label: 'Пароль',
  controller: _passwordController,
  hint: 'Введите пароль',
)
```

### Search Input

```dart
NutryInput.search(
  hint: 'Поиск...',
  controller: _searchController,
  onChanged: (value) {
    _performSearch(value);
  },
)
```

## Состояния

### С ошибкой

```dart
NutryInput.text(
  label: 'Email',
  controller: _emailController,
  errorText: 'Неверный формат email',
)
```

### Успешная валидация

```dart
NutryInput.text(
  label: 'Имя пользователя',
  controller: _usernameController,
  successText: 'Имя пользователя доступно',
)
```

### С подсказкой

```dart
NutryInput.text(
  label: 'Пароль',
  controller: _passwordController,
  helperText: 'Минимум 8 символов',
)
```

### Disabled

```dart
NutryInput.text(
  label: 'Email',
  controller: _emailController,
  enabled: false,
)
```

## С иконками

### С префиксной иконкой

```dart
NutryInput.text(
  label: 'Поиск',
  controller: _searchController,
  prefixIcon: Icons.search,
)
```

### С суффиксной иконкой

```dart
NutryInput.password(
  label: 'Пароль',
  controller: _passwordController,
  suffixIcon: Icons.visibility,
  onSuffixTap: () {
    _togglePasswordVisibility();
  },
)
```

## Валидация

### С кастомным валидатором

```dart
NutryInput.text(
  label: 'Телефон',
  controller: _phoneController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Поле обязательно для заполнения';
    }
    if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value)) {
      return 'Неверный формат телефона';
    }
    return null;
  },
)
```

## Полный пример формы

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;
  
  void _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      
      if (_emailController.text.isEmpty) {
        _emailError = 'Email обязателен';
      } else if (!_emailController.text.contains('@')) {
        _emailError = 'Неверный формат email';
      }
      
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Пароль обязателен';
      } else if (_passwordController.text.length < 8) {
        _passwordError = 'Пароль должен быть минимум 8 символов';
      }
    });
    
    if (_emailError == null && _passwordError == null) {
      _submitForm();
    }
  }
  
  void _submitForm() {
    // Отправка формы
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          NutryInput.email(
            label: 'Email',
            controller: _emailController,
            errorText: _emailError,
            onChanged: (value) {
              if (_emailError != null) {
                setState(() => _emailError = null);
              }
            },
          ),
          
          SizedBox(height: 16),
          
          NutryInput.password(
            label: 'Пароль',
            controller: _passwordController,
            errorText: _passwordError,
            suffixIcon: _isPasswordVisible 
                ? Icons.visibility 
                : Icons.visibility_off,
            onSuffixTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            onChanged: (value) {
              if (_passwordError != null) {
                setState(() => _passwordError = null);
              }
            },
          ),
          
          SizedBox(height: 24),
          
          NutryButton.primary(
            text: 'Войти',
            onPressed: _validateForm,
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

## Кастомизация

### С кастомным стилем

```dart
NutryInput.text(
  label: 'Кастомное поле',
  controller: _controller,
  textStyle: TextStyle(fontSize: 18),
  labelStyle: TextStyle(fontWeight: FontWeight.bold),
)
```

### С кастомным отступом

```dart
NutryInput.text(
  label: 'Поле',
  controller: _controller,
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
)
```

## Best Practices

1. **Всегда используйте TextEditingController** - для управления состоянием поля
2. **Валидация на onChange** - для лучшего UX
3. **Показывайте ошибки сразу** - после потери фокуса или при отправке
4. **Используйте правильные типы** - email, password для соответствующих полей
5. **Добавляйте helperText** - для подсказок пользователю
6. **Используйте prefixIcon/suffixIcon** - для улучшения понимания
7. **Dispose контроллеры** - в методе dispose виджета

## Доступность

- Поддержка screen readers
- Автоматическая маркировка полей
- Контрастность соответствует WCAG 2.1 AA
- Поддержка клавиатурной навигации

