# BLoC Integration with Repositories

## Обзор

Интеграция BLoC'ов с репозиториями обеспечивает связь между UI и бизнес-логикой через слой данных.

## Архитектура BLoC'ов

### 1. MealPlanBloc
Управляет планами питания пользователя.

**Events:**
- `LoadMealPlans` - загрузка всех планов
- `CreateMealPlan` - создание нового плана
- `UpdateMealPlan` - обновление плана
- `DeleteMealPlan` - удаление плана
- `ActivateMealPlan` - активация плана
- `LoadActiveMealPlan` - загрузка активного плана
- `AddMealToPlan` - добавление блюда в план
- `RemoveMealFromPlan` - удаление блюда из плана

**States:**
- `MealPlanInitial` - начальное состояние
- `MealPlanLoading` - загрузка
- `MealPlanLoaded` - данные загружены
- `MealPlanError` - ошибка
- `MealPlanSuccess` - успешная операция

**Использование:**
```dart
// В UI
BlocProvider<MealPlanBloc>(
  create: (context) => MealPlanDependencies.instance.createMealPlanBloc(),
  child: MealPlanScreen(),
)

// Отправка событий
context.read<MealPlanBloc>().add(LoadMealPlans());
context.read<MealPlanBloc>().add(CreateMealPlan(mealPlan));

// Прослушивание состояний
BlocBuilder<MealPlanBloc, MealPlanState>(
  builder: (context, state) {
    if (state is MealPlanLoading) {
      return CircularProgressIndicator();
    } else if (state is MealPlanLoaded) {
      return MealPlanList(plans: state.mealPlans);
    } else if (state is MealPlanError) {
      return ErrorWidget(message: state.message);
    }
    return Container();
  },
)
```

### 2. ExerciseBloc
Управляет упражнениями и тренировками.

**Events:**
- `LoadExercises` - загрузка всех упражнений
- `LoadExercisesByCategory` - загрузка по категории
- `CreateExercise` - создание упражнения
- `UpdateExercise` - обновление упражнения
- `DeleteExercise` - удаление упражнения
- `LoadWorkouts` - загрузка тренировок
- `CreateWorkout` - создание тренировки
- `UpdateWorkout` - обновление тренировки
- `DeleteWorkout` - удаление тренировки
- `StartWorkoutSession` - начало сессии
- `CompleteWorkoutSession` - завершение сессии
- `LoadWorkoutHistory` - загрузка истории

**States:**
- `ExerciseInitial` - начальное состояние
- `ExerciseLoading` - загрузка
- `ExerciseLoaded` - данные загружены
- `ExerciseError` - ошибка
- `ExerciseSuccess` - успешная операция
- `WorkoutSessionActive` - активная сессия

**Использование:**
```dart
// В UI
BlocProvider<ExerciseBloc>(
  create: (context) => ExerciseDependencies.createExerciseBloc(),
  child: ExerciseScreen(),
)

// Отправка событий
context.read<ExerciseBloc>().add(LoadExercises());
context.read<ExerciseBloc>().add(LoadExercisesByCategory('strength'));

// Прослушивание состояний
BlocBuilder<ExerciseBloc, ExerciseState>(
  builder: (context, state) {
    if (state is ExerciseLoaded) {
      return ExerciseList(exercises: state.exercises);
    }
    return Container();
  },
)
```

### 3. AnalyticsBloc
Управляет аналитическими данными.

**Events:**
- `LoadAnalyticsData` - загрузка данных за период
- `LoadNutritionTracking` - загрузка данных о питании
- `SaveNutritionTracking` - сохранение данных о питании
- `LoadWeightTracking` - загрузка данных о весе
- `SaveWeightTracking` - сохранение данных о весе
- `LoadActivityTracking` - загрузка данных об активности
- `SaveActivityTracking` - сохранение данных об активности
- `LoadAnalyticsSummary` - загрузка сводки

**States:**
- `AnalyticsInitial` - начальное состояние
- `AnalyticsLoading` - загрузка
- `AnalyticsLoaded` - данные загружены
- `AnalyticsError` - ошибка
- `AnalyticsSuccess` - успешная операция
- `AnalyticsSummaryLoaded` - сводка загружена

**Использование:**
```dart
// В UI
BlocProvider<AnalyticsBloc>(
  create: (context) => AnalyticsDependencies.instance.createAnalyticsBloc(),
  child: AnalyticsScreen(),
)

// Отправка событий
final startDate = DateTime.now().subtract(Duration(days: 7));
final endDate = DateTime.now();
context.read<AnalyticsBloc>().add(LoadAnalyticsData(
  startDate: startDate,
  endDate: endDate,
));

// Прослушивание состояний
BlocBuilder<AnalyticsBloc, AnalyticsState>(
  builder: (context, state) {
    if (state is AnalyticsLoaded) {
      return AnalyticsCharts(
        nutritionData: state.nutritionTracking,
        weightData: state.weightTracking,
        activityData: state.activityTracking,
      );
    }
    return Container();
  },
)
```

## Интеграция с репозиториями

### 1. Dependency Injection
```dart
// В dependencies файлах
class MealPlanDependencies {
  Future<void> initialize() async {
    final getIt = GetIt.instance;

    // Репозитории
    getIt.registerLazySingleton<MealPlanRepository>(
      () => MealPlanRepository(),
    );

    // BLoC'и
    getIt.registerFactory<MealPlanBloc>(
      () => MealPlanBloc(
        mealPlanRepository: getIt<MealPlanRepository>(),
      ),
    );
  }
}
```

### 2. Инициализация в main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация сервисов
  await SupabaseService.instance.initialize();
  await LocalCacheService.instance.initialize();
  
  // Инициализация зависимостей
  await MealPlanDependencies.instance.initialize();
  ExerciseDependencies.initialize();
  await AnalyticsDependencies.instance.initialize();
  
  runApp(const MyApp());
}
```

### 3. Использование в экранах
```dart
class MealPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealPlanBloc>(
      create: (context) => MealPlanDependencies.instance.createMealPlanBloc()
        ..add(LoadMealPlans()),
      child: Scaffold(
        appBar: AppBar(title: Text('Планы питания')),
        body: BlocBuilder<MealPlanBloc, MealPlanState>(
          builder: (context, state) {
            if (state is MealPlanLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MealPlanLoaded) {
              return MealPlanListView(plans: state.mealPlans);
            } else if (state is MealPlanError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Создание нового плана
            final newPlan = MealPlan(...);
            context.read<MealPlanBloc>().add(CreateMealPlan(newPlan));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

## Обработка ошибок

### 1. Глобальная обработка ошибок
```dart
class ErrorHandler {
  static void handleError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// В BLoC'ах
} catch (e) {
  developer.log('Error: $e', name: 'MealPlanBloc');
  emit(MealPlanError('Не удалось выполнить операцию: $e'));
}
```

### 2. Retry механизм
```dart
class RetryButton extends StatelessWidget {
  final VoidCallback onRetry;
  
  const RetryButton({required this.onRetry});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onRetry,
      child: Text('Повторить'),
    );
  }
}

// В экранах
if (state is MealPlanError) {
  return Center(
    child: Column(
      children: [
        Text(state.message),
        RetryButton(
          onRetry: () => context.read<MealPlanBloc>().add(LoadMealPlans()),
        ),
      ],
    ),
  );
}
```

## Оптимизация производительности

### 1. Ленивая загрузка
```dart
// Загружаем данные только при необходимости
class MealPlanScreen extends StatefulWidget {
  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при инициализации экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealPlanBloc>().add(LoadMealPlans());
    });
  }
}
```

### 2. Кэширование состояний
```dart
// В BLoC'ах сохраняем предыдущее состояние
if (state is MealPlanLoaded) {
  final currentState = state as MealPlanLoaded;
  emit(currentState.copyWith(mealPlans: updatedPlans));
} else {
  emit(MealPlanLoaded(mealPlans: updatedPlans));
}
```

### 3. Debounce для поиска
```dart
class SearchDebouncer {
  Timer? _timer;
  
  void debounce(VoidCallback callback, Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }
}

// В экранах
final _debouncer = SearchDebouncer();

TextField(
  onChanged: (value) {
    _debouncer.debounce(() {
      context.read<MealPlanBloc>().add(SearchMealPlans(value));
    }, Duration(milliseconds: 500));
  },
)
```

## Тестирование BLoC'ов

### 1. Unit тесты
```dart
group('MealPlanBloc', () {
  late MealPlanBloc bloc;
  late MockMealPlanRepository mockRepository;

  setUp(() {
    mockRepository = MockMealPlanRepository();
    bloc = MealPlanBloc(mealPlanRepository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is MealPlanInitial', () {
    expect(bloc.state, isA<MealPlanInitial>());
  });

  blocTest<MealPlanBloc, MealPlanState>(
    'emits [MealPlanLoading, MealPlanLoaded] when LoadMealPlans is added',
    build: () {
      when(mockRepository.getUserMealPlans())
          .thenAnswer((_) async => []);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMealPlans()),
    expect: () => [
      isA<MealPlanLoading>(),
      isA<MealPlanLoaded>(),
    ],
  );
});
```

### 2. Widget тесты
```dart
testWidgets('shows loading indicator when loading', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<MealPlanBloc>(
        create: (context) => MealPlanBloc(
          mealPlanRepository: MockMealPlanRepository(),
        ),
        child: MealPlanScreen(),
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Лучшие практики

### 1. Разделение ответственности
- **BLoC** - управление состоянием и бизнес-логикой
- **Repository** - работа с данными
- **UI** - отображение и взаимодействие

### 2. Именование
- Events: `LoadMealPlans`, `CreateMealPlan`
- States: `MealPlanLoaded`, `MealPlanError`
- Methods: `_onLoadMealPlans`, `_onCreateMealPlan`

### 3. Логирование
```dart
developer.log('🍽️ MealPlanBloc: Loading meal plans', name: 'MealPlanBloc');
developer.log('🍽️ MealPlanBloc: Loaded ${mealPlans.length} meal plans', name: 'MealPlanBloc');
```

### 4. Обработка состояний
```dart
// Всегда обрабатывайте все возможные состояния
BlocBuilder<MealPlanBloc, MealPlanState>(
  builder: (context, state) {
    switch (state.runtimeType) {
      case MealPlanInitial:
        return InitialWidget();
      case MealPlanLoading:
        return LoadingWidget();
      case MealPlanLoaded:
        return LoadedWidget(data: state.data);
      case MealPlanError:
        return ErrorWidget(message: state.message);
      default:
        return Container();
    }
  },
)
```

## Будущие улучшения

### 1. Автоматическая синхронизация
```dart
class AutoSyncBloc extends Bloc<AutoSyncEvent, AutoSyncState> {
  Timer? _syncTimer;
  
  void startAutoSync() {
    _syncTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      add(SyncData());
    });
  }
}
```

### 2. Офлайн поддержка
```dart
class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  void queueOperation(Operation operation) {
    add(QueueOperation(operation));
  }
  
  void syncWhenOnline() {
    add(SyncQueuedOperations());
  }
}
```

### 3. Реактивные обновления
```dart
class ReactiveBloc extends Bloc<ReactiveEvent, ReactiveState> {
  StreamSubscription? _dataSubscription;
  
  void startReactiveUpdates() {
    _dataSubscription = repository.dataStream.listen((data) {
      add(DataUpdated(data));
    });
  }
}
``` 