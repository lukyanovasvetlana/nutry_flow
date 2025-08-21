import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/architecture/architecture.dart';

void main() {
  group('AppArchitecture Tests', () {
    late AppArchitecture architecture;

    setUp(() {
      architecture = AppArchitecture();
    });

    tearDown(() async {
      if (architecture.isInitialized) {
        await architecture.dispose();
      }
    });

    test('should create singleton instance', () {
      final instance1 = AppArchitecture();
      final instance2 = AppArchitecture();
      
      expect(instance1, same(instance2));
    });

    test('should not be initialized by default', () {
      expect(architecture.isInitialized, false);
    });

    test('should have access to components after initialization', () async {
      await architecture.initialize();
      
      expect(architecture.initializer, isNotNull);
      expect(architecture.router, isNotNull);
      expect(architecture.state, isNotNull);
      expect(architecture.serviceLocator, isNotNull);
    });

    test('should be initialized after successful initialization', () async {
      await architecture.initialize();
      
      expect(architecture.isInitialized, true);
    });

    test('should throw error when creating app before initialization', () {
      expect(
        () => architecture.createApp(),
        throwsStateError,
      );
    });

    test('should dispose resources correctly', () async {
      await architecture.initialize();
      expect(architecture.isInitialized, true);
      
      await architecture.dispose();
      expect(architecture.isInitialized, false);
    });
  });

  group('AppInitializer Tests', () {
    late AppInitializer initializer;

    setUp(() {
      initializer = AppInitializer();
    });

    tearDown(() async {
      if (initializer.isInitialized) {
        await initializer.dispose();
      }
    });

    test('should not be initialized by default', () {
      expect(initializer.isInitialized, false);
    });

    test('should be initialized after successful initialization', () async {
      await initializer.initialize();
      
      expect(initializer.isInitialized, true);
    });

    test('should track initialized features', () async {
      await initializer.initialize();
      
      final features = initializer.initializedFeatures;
      expect(features, isNotEmpty);
      expect(features.contains('Onboarding'), true);
    });

    test('should provide features status', () async {
      await initializer.initialize();
      
      final status = initializer.getFeaturesStatus();
      expect(status, isNotEmpty);
      expect(status['Onboarding'], true);
    });

    test('should check specific feature initialization', () async {
      await initializer.initialize();
      
      expect(initializer.isFeatureInitialized('Onboarding'), true);
      expect(initializer.isFeatureInitialized('NonExistent'), false);
    });
  });

  group('AppState Tests', () {
    late AppState state;

    setUp(() {
      state = AppState();
    });

    tearDown(() async {
      if (state.isInitialized) {
        await state.dispose();
      }
    });

    test('should not be initialized by default', () {
      expect(state.isInitialized, false);
    });

    test('should be initialized after successful initialization', () async {
      await state.initialize();
      
      expect(state.isInitialized, true);
    });

    test('should provide global BLoC providers', () async {
      await state.initialize();
      
      final providers = state.globalBlocProviders;
      expect(providers, isNotEmpty);
    });

    test('should manage global state values', () async {
      await state.initialize();
      
      // Set value
      state.setValue('test_key', 'test_value');
      expect(state.getValue<String>('test_key'), 'test_value');
      
      // Check existence
      expect(state.hasKey('test_key'), true);
      expect(state.hasKey('non_existent'), false);
      
      // Update value
      state.updateValue('test_key', (current) => '${current}_updated');
      expect(state.getValue<String>('test_key'), 'test_value_updated');
      
      // Remove value
      state.removeValue('test_key');
      expect(state.hasKey('test_key'), false);
    });

    test('should provide state statistics', () async {
      await state.initialize();
      
      final stats = state.getStateStatistics();
      expect(stats, isNotEmpty);
      expect(stats['isInitialized'], true);
      expect(stats['totalKeys'], isA<int>());
    });

    test('should export and import state', () async {
      await state.initialize();
      
      state.setValue('export_key', 'export_value');
      
      final exported = state.exportState();
      expect(exported['export_key'], 'export_value');
      
      // Clear and import
      state.clearState();
      expect(state.hasKey('export_key'), false);
      
      state.importState(exported);
      expect(state.getValue<String>('export_key'), 'export_value');
    });
  });

  group('AppRouter Tests', () {
    late AppRouter router;

    setUp(() {
      router = AppRouter();
    });

    tearDown(() async {
      if (router.isInitialized) {
        await router.dispose();
      }
    });

    test('should not be initialized by default', () {
      expect(router.isInitialized, false);
    });

    test('should be initialized after successful initialization', () async {
      await router.initialize();
      
      expect(router.isInitialized, true);
    });

    test('should provide router instance after initialization', () async {
      await router.initialize();
      
      expect(router.router, isNotNull);
    });

    test('should throw error when creating app before initialization', () {
      expect(
        () => router.createApp(),
        throwsStateError,
      );
    });
  });
}
