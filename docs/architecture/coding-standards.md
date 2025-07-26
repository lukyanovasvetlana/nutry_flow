# Coding Standards - NutryFlow

## Flutter/Dart Code Standards

### Naming Conventions

#### Classes and Enums
- Use PascalCase for class names
- Use descriptive names that clearly indicate purpose
```dart
class UserProfileRepository {}
class AuthenticationService {}
enum UserGoalType { weightLoss, muscleGain, maintenance }
```

#### Variables and Functions
- Use camelCase for variables and function names
- Use descriptive names that explain what the variable holds or what the function does
```dart
final String userEmail = 'user@example.com';
final int dailyCalorieLimit = 2000;

void updateUserProfile(UserProfile profile) {}
Future<List<Recipe>> fetchRecipesByCategory(String category) async {}
```

#### Constants
- Use SCREAMING_SNAKE_CASE for constants
- Group related constants in classes
```dart
class ApiConstants {
  static const String BASE_URL = 'https://api.nutryflow.com';
  static const int REQUEST_TIMEOUT = 30;
}
```

#### Files and Directories
- Use snake_case for file names
- Keep file names descriptive and related to their content
```
user_profile_repository.dart
authentication_service.dart
meal_plan_screen.dart
```

### Code Organization

#### Feature-First Structure
- Organize code by features, not by layers
- Each feature should be self-contained
```
lib/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── meal_planning/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
```

#### Clean Architecture Layers
- **Presentation Layer**: UI components, BLoC, widgets
- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: Repositories, data sources, models

### BLoC Pattern Standards

#### State Management
- Use BLoC pattern for state management
- Keep BLoCs focused on single responsibility
- Use sealed classes for states when possible

```dart
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
```

#### Event Handling
- Use descriptive event names
- Keep events simple and focused
```dart
abstract class AuthEvent {}
class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested(this.email, this.password);
}
class SignOutRequested extends AuthEvent {}
```

### Error Handling

#### Exception Handling
- Use custom exceptions for domain-specific errors
- Always handle exceptions gracefully
```dart
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ValidationException implements Exception {
  final String field;
  final String message;
  ValidationException(this.field, this.message);
}
```

#### Result Pattern
- Use Result pattern for operations that can fail
```dart
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  Result.success(this.data) : error = null, isSuccess = true;
  Result.failure(this.error) : data = null, isSuccess = false;
}
```

### Testing Standards

#### Unit Tests
- Write unit tests for all business logic
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

```dart
void main() {
  group('UserProfileRepository', () {
    test('should return user profile when valid ID is provided', () async {
      // Arrange
      final repository = UserProfileRepository();
      const userId = 'test-user-id';
      
      // Act
      final result = await repository.getUserProfile(userId);
      
      // Assert
      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
    });
  });
}
```

#### Widget Tests
- Test widget behavior and UI interactions
- Use testWidgets for widget testing
```dart
void main() {
  testWidgets('Login button should be enabled when form is valid', (tester) async {
    await tester.pumpWidget(MyApp());
    
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password123');
    
    expect(find.byKey(Key('login_button')), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byKey(Key('login_button'))).enabled, true);
  });
}
```

### Documentation Standards

#### Code Comments
- Use /// for public API documentation
- Use // for internal implementation comments
- Explain why, not what

```dart
/// Calculates the user's daily calorie needs based on their profile
/// and activity level using the Mifflin-St Jeor equation.
/// 
/// Returns null if the user profile is incomplete.
int? calculateDailyCalories(UserProfile profile) {
  // Using Mifflin-St Jeor equation as it's more accurate for modern lifestyles
  if (profile.age == null || profile.weight == null) {
    return null;
  }
  
  // Base metabolic rate calculation
  double bmr = (10 * profile.weight!) + (6.25 * profile.height!) - (5 * profile.age!) + 5;
  
  return (bmr * profile.activityLevel.multiplier).round();
}
```

### Performance Standards

#### Widget Performance
- Use const constructors where possible
- Avoid rebuilding widgets unnecessarily
- Use ListView.builder for large lists

```dart
class RecipeList extends StatelessWidget {
  const RecipeList({Key? key, required this.recipes}) : super(key: key);
  
  final List<Recipe> recipes;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipe: recipes[index]);
      },
    );
  }
}
```

#### Memory Management
- Dispose controllers and subscriptions properly
- Use weak references where appropriate
- Avoid memory leaks in BLoCs

```dart
class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final StreamSubscription _subscription;
  
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
```

### Security Standards

#### Data Validation
- Always validate user input
- Use proper input sanitization
- Validate data at multiple layers

```dart
class EmailValidator {
  static bool isValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
```

#### Secure Storage
- Use secure storage for sensitive data
- Never store passwords in plain text
- Use encryption for sensitive user data

```dart
class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

### Git Standards

#### Commit Messages
- Use conventional commit format
- Keep messages concise but descriptive
```
feat(auth): add email validation to login form
fix(meal-plan): resolve null pointer exception in recipe loading
docs(readme): update installation instructions
```

#### Branch Naming
- Use descriptive branch names
- Follow the pattern: `type/description`
```
feature/user-profile-editing
bugfix/login-validation-error
hotfix/crash-on-startup
```

### Code Review Standards

#### Review Checklist
- [ ] Code follows naming conventions
- [ ] Business logic is in the domain layer
- [ ] Error handling is implemented
- [ ] Tests are written and passing
- [ ] Documentation is updated
- [ ] Performance considerations are addressed
- [ ] Security best practices are followed

#### Review Process
1. Self-review before requesting review
2. Request review from at least one team member
3. Address all feedback before merging
4. Ensure CI/CD pipeline passes

### Tools and Linting

#### Required Tools
- `flutter_lints`: For code linting
- `dart_code_metrics`: For code quality metrics
- `coverage`: For test coverage reporting

#### Lint Rules
- Follow official Flutter linting rules
- Customize rules in `analysis_options.yaml`
- Maintain 80% or higher test coverage

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - prefer_single_quotes
    - sort_constructors_first
``` 