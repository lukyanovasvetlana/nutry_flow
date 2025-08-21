import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:nutry_flow/features/onboarding/presentation/bloc/goals_setup_bloc.dart';
import 'package:nutry_flow/features/onboarding/di/onboarding_dependencies.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';

/// Класс для управления глобальным состоянием приложения
class AppState {
  bool _isInitialized = false;
  final List<ChangeNotifierProvider> _globalProviders = [];
  final List<BlocProvider> _globalBlocProviders = [];
  final Map<String, dynamic> _globalState = {};

  /// Проверка инициализации
  bool get isInitialized => _isInitialized;

  /// Глобальные провайдеры
  List<ChangeNotifierProvider> get globalProviders => List.unmodifiable(_globalProviders);
  
  /// Глобальные BLoC провайдеры
  List<BlocProvider> get globalBlocProviders => List.unmodifiable(_globalBlocProviders);

  /// Глобальное состояние
  Map<String, dynamic> get globalState => Map.unmodifiable(_globalState);

  /// Инициализация состояния приложения
  Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️ AppState: Already initialized');
      return;
    }

    try {
      print('📊 AppState: Initializing application state...');
      
      // Инициализация глобальных BLoC провайдеров
      await _initializeGlobalProviders();
      
      // Инициализация глобального состояния
      await _initializeGlobalState();
      
      _isInitialized = true;
      print('✅ AppState: Application state initialized successfully');
      
    } catch (e, stackTrace) {
      print('❌ AppState: Initialization failed: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Инициализация глобальных провайдеров
  Future<void> _initializeGlobalProviders() async {
    print('📊 AppState: Initializing global providers...');
    
    // Добавляем глобальные провайдеры, которые нужны во всем приложении
    
    // Theme Manager как ChangeNotifier
    _globalProviders.add(
      ChangeNotifierProvider<ThemeManager>(
        create: (context) => ThemeManager(),
      ),
    );
    
    // Goals Setup BLoC (если нужен глобально)
    _globalBlocProviders.add(
      BlocProvider<GoalsSetupBloc>(
        create: (context) {
          final bloc = OnboardingDependencies.instance.createGoalsSetupBloc();
          // Автоматически инициализируем цели при создании BLoC
          bloc.add(InitializeGoals());
          return bloc;
        },
      ),
    );
    
    print('📊 AppState: Global providers initialized successfully');
  }

  /// Инициализация глобального состояния
  Future<void> _initializeGlobalState() async {
    print('📊 AppState: Initializing global state...');
    
    // Инициализируем базовые значения состояния
    _globalState['appVersion'] = '1.0.0';
    _globalState['buildNumber'] = '1';
    _globalState['isFirstLaunch'] = true;
    _globalState['lastLaunchDate'] = DateTime.now().toIso8601String();
    _globalState['userPreferences'] = <String, dynamic>{};
    _globalState['appSettings'] = <String, dynamic>{};
    
    print('📊 AppState: Global state initialized successfully');
  }

  /// Получение значения из глобального состояния
  T? getValue<T>(String key) {
    if (!_isInitialized) {
      print('⚠️ AppState: Not initialized');
      return null;
    }
    
    final value = _globalState[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  /// Установка значения в глобальное состояние
  void setValue<T>(String key, T value) {
    if (!_isInitialized) {
      print('⚠️ AppState: Not initialized');
      return;
    }
    
    _globalState[key] = value;
    print('📊 AppState: Set value for key "$key": $value');
  }

  /// Обновление значения в глобальном состоянии
  void updateValue<T>(String key, T Function(T current) updater) {
    if (!_isInitialized) {
      print('⚠️ AppState: Not initialized');
      return;
    }
    
    final currentValue = _globalState[key];
    if (currentValue != null) {
      final newValue = updater(currentValue as T);
      _globalState[key] = newValue;
      print('📊 AppState: Updated value for key "$key": $newValue');
    }
  }

  /// Удаление значения из глобального состояния
  void removeValue(String key) {
    if (!_isInitialized) {
      print('⚠️ AppState: Not initialized');
      return;
    }
    
    if (_globalState.containsKey(key)) {
      final removedValue = _globalState.remove(key);
      print('📊 AppState: Removed value for key "$key": $removedValue');
    }
  }

  /// Проверка существования ключа в глобальном состоянии
  bool hasKey(String key) {
    if (!_isInitialized) {
      return false;
    }
    
    return _globalState.containsKey(key);
  }

  /// Получение всех ключей глобального состояния
  List<String> get allKeys {
    if (!_isInitialized) {
      return [];
    }
    
    return _globalState.keys.toList();
  }

  /// Очистка глобального состояния
  void clearState() {
    if (!_isInitialized) {
      return;
    }
    
    _globalState.clear();
    print('📊 AppState: Global state cleared');
  }

  /// Сброс состояния к начальным значениям
  Future<void> resetState() async {
    if (!_isInitialized) {
      return;
    }
    
    print('📊 AppState: Resetting state to initial values...');
    await _initializeGlobalState();
    print('📊 AppState: State reset successfully');
  }

  /// Экспорт состояния в JSON
  Map<String, dynamic> exportState() {
    if (!_isInitialized) {
      return {};
    }
    
    return Map.from(_globalState);
  }

  /// Импорт состояния из JSON
  void importState(Map<String, dynamic> state) {
    if (!_isInitialized) {
      print('⚠️ AppState: Not initialized');
      return;
    }
    
    _globalState.clear();
    _globalState.addAll(state);
    print('📊 AppState: State imported successfully');
  }

  /// Получение статистики состояния
  Map<String, dynamic> getStateStatistics() {
    if (!_isInitialized) {
      return {};
    }
    
    return {
      'totalKeys': _globalState.length,
      'keys': _globalState.keys.toList(),
      'providersCount': _globalProviders.length,
      'isInitialized': _isInitialized,
      'lastUpdate': DateTime.now().toIso8601String(),
    };
  }

  /// Очистка ресурсов
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    print('🧹 AppState: Disposing...');
    
    // Очищаем глобальное состояние
    _globalState.clear();
    
    // Очищаем провайдеры
    _globalProviders.clear();
    
    _isInitialized = false;
    
    print('✅ AppState: Disposed successfully');
  }

  /// Переинициализация состояния
  Future<void> reinitialize() async {
    print('🔄 AppState: Reinitializing...');
    await dispose();
    await initialize();
  }
}
