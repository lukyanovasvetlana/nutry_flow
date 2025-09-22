import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/exercise/data/models/exercise.dart';

void main() {
  group('Exercise Model Tests', () {
    group('Constructor', () {
      test('should create exercise with all required parameters', () {
        // Arrange
        const id = '1';
        const name = 'Test Exercise';
        const category = 'Test Category';
        const difficulty = 'Beginner';
        const sets = 3;
        const reps = 10;
        const restSeconds = 60;
        const iconName = 'test_icon';
        const description = 'Test description';
        const targetMuscles = ['Muscle1', 'Muscle2'];
        const equipment = ['Equipment1'];

        // Act
        final exercise = Exercise(
          id: id,
          name: name,
          category: category,
          difficulty: difficulty,
          sets: sets,
          reps: reps,
          restSeconds: restSeconds,
          iconName: iconName,
          description: description,
          targetMuscles: targetMuscles,
          equipment: equipment,
        );

        // Assert
        expect(exercise.id, equals(id));
        expect(exercise.name, equals(name));
        expect(exercise.category, equals(category));
        expect(exercise.difficulty, equals(difficulty));
        expect(exercise.sets, equals(sets));
        expect(exercise.reps, equals(reps));
        expect(exercise.restSeconds, equals(restSeconds));
        expect(exercise.iconName, equals(iconName));
        expect(exercise.description, equals(description));
        expect(exercise.targetMuscles, equals(targetMuscles));
        expect(exercise.equipment, equals(equipment));
        expect(exercise.duration, isNull);
      });

      test('should create exercise with optional duration parameter', () {
        // Arrange
        const duration = '30 мин';

        // Act
        final exercise = Exercise(
          id: '1',
          name: 'Test Exercise',
          category: 'Test Category',
          difficulty: 'Beginner',
          sets: 1,
          reps: 1,
          restSeconds: 0,
          duration: duration,
          iconName: 'test_icon',
          description: 'Test description',
          targetMuscles: ['Muscle1'],
          equipment: ['Equipment1'],
        );

        // Assert
        expect(exercise.duration, equals(duration));
      });

      test('should create exercise without duration parameter', () {
        // Act
        final exercise = Exercise(
          id: '1',
          name: 'Test Exercise',
          category: 'Test Category',
          difficulty: 'Beginner',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          iconName: 'test_icon',
          description: 'Test description',
          targetMuscles: ['Muscle1'],
          equipment: ['Equipment1'],
        );

        // Assert
        expect(exercise.duration, isNull);
      });
    });

    group('fromJson', () {
      test('should create exercise from valid JSON', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test Exercise',
          'category': 'Test Category',
          'difficulty': 'Beginner',
          'sets': 3,
          'reps': 10,
          'restSeconds': 60,
          'duration': '30 мин',
          'iconName': 'test_icon',
          'description': 'Test description',
          'targetMuscles': ['Muscle1', 'Muscle2'],
          'equipment': ['Equipment1', 'Equipment2'],
        };

        // Act
        final exercise = Exercise.fromJson(json);

        // Assert
        expect(exercise.id, equals('1'));
        expect(exercise.name, equals('Test Exercise'));
        expect(exercise.category, equals('Test Category'));
        expect(exercise.difficulty, equals('Beginner'));
        expect(exercise.sets, equals(3));
        expect(exercise.reps, equals(10));
        expect(exercise.restSeconds, equals(60));
        expect(exercise.duration, equals('30 мин'));
        expect(exercise.iconName, equals('test_icon'));
        expect(exercise.description, equals('Test description'));
        expect(exercise.targetMuscles, equals(['Muscle1', 'Muscle2']));
        expect(exercise.equipment, equals(['Equipment1', 'Equipment2']));
      });

      test('should create exercise from JSON without duration', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test Exercise',
          'category': 'Test Category',
          'difficulty': 'Beginner',
          'sets': 3,
          'reps': 10,
          'restSeconds': 60,
          'iconName': 'test_icon',
          'description': 'Test description',
          'targetMuscles': ['Muscle1'],
          'equipment': ['Equipment1'],
        };

        // Act
        final exercise = Exercise.fromJson(json);

        // Assert
        expect(exercise.duration, isNull);
      });

      test('should handle empty targetMuscles and equipment lists', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test Exercise',
          'category': 'Test Category',
          'difficulty': 'Beginner',
          'sets': 3,
          'reps': 10,
          'restSeconds': 60,
          'iconName': 'test_icon',
          'description': 'Test description',
          'targetMuscles': [],
          'equipment': [],
        };

        // Act
        final exercise = Exercise.fromJson(json);

        // Assert
        expect(exercise.targetMuscles, isEmpty);
        expect(exercise.equipment, isEmpty);
      });
    });

    group('toJson', () {
      test('should convert exercise to JSON with all fields', () {
        // Arrange
        final exercise = Exercise(
          id: '1',
          name: 'Test Exercise',
          category: 'Test Category',
          difficulty: 'Beginner',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          duration: '30 мин',
          iconName: 'test_icon',
          description: 'Test description',
          targetMuscles: ['Muscle1', 'Muscle2'],
          equipment: ['Equipment1', 'Equipment2'],
        );

        // Act
        final json = exercise.toJson();

        // Assert
        expect(json['id'], equals('1'));
        expect(json['name'], equals('Test Exercise'));
        expect(json['category'], equals('Test Category'));
        expect(json['difficulty'], equals('Beginner'));
        expect(json['sets'], equals(3));
        expect(json['reps'], equals(10));
        expect(json['restSeconds'], equals(60));
        expect(json['duration'], equals('30 мин'));
        expect(json['iconName'], equals('test_icon'));
        expect(json['description'], equals('Test description'));
        expect(json['targetMuscles'], equals(['Muscle1', 'Muscle2']));
        expect(json['equipment'], equals(['Equipment1', 'Equipment2']));
      });

      test('should convert exercise to JSON without duration', () {
        // Arrange
        final exercise = Exercise(
          id: '1',
          name: 'Test Exercise',
          category: 'Test Category',
          difficulty: 'Beginner',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          iconName: 'test_icon',
          description: 'Test description',
          targetMuscles: ['Muscle1'],
          equipment: ['Equipment1'],
        );

        // Act
        final json = exercise.toJson();

        // Assert
        expect(json['duration'], isNull);
      });

      test('should handle empty targetMuscles and equipment lists', () {
        // Arrange
        final exercise = Exercise(
          id: '1',
          name: 'Test Exercise',
          category: 'Test Category',
          difficulty: 'Beginner',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          iconName: 'test_icon',
          description: 'Test description',
          targetMuscles: [],
          equipment: [],
        );

        // Act
        final json = exercise.toJson();

        // Assert
        expect(json['targetMuscles'], equals([]));
        expect(json['equipment'], equals([]));
      });
    });

    group('JSON Round Trip', () {
      test('should maintain data integrity through JSON conversion', () {
        // Arrange
        final originalExercise = Exercise(
          id: '1',
          name: 'Test Exercise',
          category: 'Test Category',
          difficulty: 'Beginner',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          duration: '30 мин',
          iconName: 'test_icon',
          description: 'Test description',
          targetMuscles: ['Muscle1', 'Muscle2'],
          equipment: ['Equipment1', 'Equipment2'],
        );

        // Act
        final json = originalExercise.toJson();
        final convertedExercise = Exercise.fromJson(json);

        // Assert
        expect(convertedExercise.id, equals(originalExercise.id));
        expect(convertedExercise.name, equals(originalExercise.name));
        expect(convertedExercise.category, equals(originalExercise.category));
        expect(convertedExercise.difficulty, equals(originalExercise.difficulty));
        expect(convertedExercise.sets, equals(originalExercise.sets));
        expect(convertedExercise.reps, equals(originalExercise.reps));
        expect(convertedExercise.restSeconds, equals(originalExercise.restSeconds));
        expect(convertedExercise.duration, equals(originalExercise.duration));
        expect(convertedExercise.iconName, equals(originalExercise.iconName));
        expect(convertedExercise.description, equals(originalExercise.description));
        expect(convertedExercise.targetMuscles, equals(originalExercise.targetMuscles));
        expect(convertedExercise.equipment, equals(originalExercise.equipment));
      });
    });

    group('Edge Cases', () {
      test('should handle very long strings', () {
        // Arrange
        final longString = 'a' * 1000;
        final longList = List.generate(100, (index) => 'item$index');

        // Act
        final exercise = Exercise(
          id: longString,
          name: longString,
          category: longString,
          difficulty: longString,
          sets: 1,
          reps: 1,
          restSeconds: 0,
          iconName: longString,
          description: longString,
          targetMuscles: longList,
          equipment: longList,
        );

        // Assert
        expect(exercise.id, equals(longString));
        expect(exercise.name, equals(longString));
        expect(exercise.targetMuscles.length, equals(100));
        expect(exercise.equipment.length, equals(100));
      });

      test('should handle special characters in strings', () {
        // Arrange
        const specialString = r'!@#$%^&*()_+-=[]{}|;:,.<>?';

        // Act
        final exercise = Exercise(
          id: specialString,
          name: specialString,
          category: specialString,
          difficulty: specialString,
          sets: 1,
          reps: 1,
          restSeconds: 0,
          iconName: specialString,
          description: specialString,
          targetMuscles: [specialString],
          equipment: [specialString],
        );

        // Assert
        expect(exercise.id, equals(specialString));
        expect(exercise.name, equals(specialString));
        expect(exercise.targetMuscles.first, equals(specialString));
        expect(exercise.equipment.first, equals(specialString));
      });

      test('should handle unicode characters', () {
        // Arrange
        const unicodeString = 'Приседания 🏋️‍♂️ 中文 العربية';

        // Act
        final exercise = Exercise(
          id: unicodeString,
          name: unicodeString,
          category: unicodeString,
          difficulty: unicodeString,
          sets: 1,
          reps: 1,
          restSeconds: 0,
          iconName: unicodeString,
          description: unicodeString,
          targetMuscles: [unicodeString],
          equipment: [unicodeString],
        );

        // Assert
        expect(exercise.id, equals(unicodeString));
        expect(exercise.name, equals(unicodeString));
        expect(exercise.targetMuscles.first, equals(unicodeString));
        expect(exercise.equipment.first, equals(unicodeString));
      });
    });
  });
}
