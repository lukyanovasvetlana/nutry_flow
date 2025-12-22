# Инструкции по настройке тестов для ProfileEditScreen

**Дата:** 2025-01-27

---

## 📋 Требования

Для полноценного тестирования `ProfileEditScreen` необходимо настроить следующие пакеты:

### Зависимости

Добавьте в `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
  bloc_test: ^9.1.0
```

Затем выполните:
```bash
flutter pub get
```

---

## 🔧 Настройка моков

### 1. Создание моков для Use Cases

Создайте файл `test/mocks/mock_profile_usecases.dart`:

```dart
import 'package:mockito/annotations.dart';
import 'package:nutry_flow/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:nutry_flow/features/profile/domain/usecases/update_user_profile_usecase.dart';

@GenerateMocks([
  GetUserProfileUseCase,
  UpdateUserProfileUseCase,
])
void main() {}
```

### 2. Генерация моков

Запустите генерацию:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Это создаст файл `test/mocks/mock_profile_usecases.mocks.dart`.

---

## 📝 Обновление тестов

### Пример правильной настройки теста

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';
import 'package:nutry_flow/features/profile/presentation/blocs/profile_bloc.dart';
import 'test/mocks/mock_profile_usecases.mocks.dart';

void main() {
  group('ProfileEditScreen Tests', () {
    late MockGetUserProfileUseCase mockGetUserProfileUseCase;
    late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
    late ProfileBloc profileBloc;
    late UserProfile testProfile;

    setUp(() {
      mockGetUserProfileUseCase = MockGetUserProfileUseCase();
      mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
      
      profileBloc = ProfileBloc(
        getUserProfileUseCase: mockGetUserProfileUseCase,
        updateUserProfileUseCase: mockUpdateUserProfileUseCase,
      );

      testProfile = UserProfile(
        id: 'test-user-id',
        firstName: 'Иван',
        lastName: 'Петров',
        email: 'ivan.petrov@example.com',
      );
    });

    tearDown(() {
      profileBloc.close();
    });

    Widget createWidgetUnderTest({UserProfile? profile}) {
      return MaterialApp(
        home: BlocProvider<ProfileBloc>(
          create: (_) => profileBloc,
          child: ProfileEditScreen(userProfile: profile ?? testProfile),
        ),
      );
    }

    testWidgets('should render ProfileEditScreen', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest();

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Редактировать профиль'), findsOneWidget);
    });
  });
}
```

---

## 🧪 Тестирование BLoC взаимодействий

### Использование bloc_test

```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<ProfileBloc, ProfileState>(
  'emits ProfileUpdated when UpdateProfile is added',
  build: () {
    when(mockUpdateUserProfileUseCase.execute(any))
        .thenAnswer((_) async => Result.success(testProfile));
    
    return ProfileBloc(
      getUserProfileUseCase: mockGetUserProfileUseCase,
      updateUserProfileUseCase: mockUpdateUserProfileUseCase,
    );
  },
  act: (bloc) => bloc.add(UpdateProfile(testProfile)),
  expect: () => [
    ProfileUpdating(),
    ProfileUpdated(),
  ],
);
```

---

## ✅ Текущий статус тестов

### Что работает сейчас:
- ✅ `profile_form_field_test.dart` - полностью рабочие тесты
- ✅ Структура тестов для `profile_edit_screen_test.dart` создана
- ✅ Документация по настройке создана

### Что требует настройки:
- ⚠️ `profile_edit_screen_test.dart` - требует настройки моков
- ⚠️ BLoC интеграционные тесты - требуют bloc_test

---

## 🚀 Быстрый старт

1. **Добавьте зависимости:**
   ```bash
   flutter pub add --dev mockito build_runner bloc_test
   ```

2. **Создайте файл моков** (см. выше)

3. **Сгенерируйте моки:**
   ```bash
   flutter pub run build_runner build
   ```

4. **Обновите тесты** используя примеры выше

5. **Запустите тесты:**
   ```bash
   flutter test test/features/profile/
   ```

---

## 📚 Дополнительные ресурсы

- [Mockito документация](https://pub.dev/packages/mockito)
- [bloc_test документация](https://pub.dev/packages/bloc_test)
- [Flutter testing guide](https://docs.flutter.dev/testing)

---

**Примечание:** Текущие тесты в `profile_edit_screen_test.dart` являются шаблоном и требуют настройки моков для полноценной работы.

