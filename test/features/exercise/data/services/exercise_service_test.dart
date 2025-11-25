import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/exercise/data/services/exercise_service.dart';
import 'package:nutry_flow/features/exercise/data/models/exercise.dart';

void main() {
  group('ExerciseService Tests', () {
    group('getAllExercises', () {
      test('should return all exercises', () {
        // Act
        final exercises = ExerciseService.getAllExercises();

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.length, greaterThan(0));
        expect(exercises.first, isA<Exercise>());
      });

      test('should return list of Exercise objects', () {
        // Act
        final exercises = ExerciseService.getAllExercises();

        // Assert
        for (final exercise in exercises) {
          expect(exercise, isA<Exercise>());
          expect(exercise.id, isNotEmpty);
          expect(exercise.name, isNotEmpty);
          expect(exercise.category, isNotEmpty);
          expect(exercise.difficulty, isNotEmpty);
        }
      });
    });

    group('searchExercises', () {
      test('should return all exercises when query is empty', () {
        // Act
        final exercises = ExerciseService.searchExercises('');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.length, equals(ExerciseService.getAllExercises().length));
      });

      test('should find exercises by name', () {
        // Act
        final exercises = ExerciseService.searchExercises('приседания');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.any((e) => e.name.toLowerCase().contains('приседания')), isTrue);
      });

      test('should find exercises by category', () {
        // Act
        final exercises = ExerciseService.searchExercises('ноги');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.any((e) => e.category.toLowerCase().contains('ноги')), isTrue);
      });

      test('should find exercises by target muscles', () {
        // Act
        final exercises = ExerciseService.searchExercises('квадрицепсы');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.any((e) => e.targetMuscles.any((m) => m.toLowerCase().contains('квадрицепсы'))), isTrue);
      });

      test('should be case insensitive', () {
        // Act
        final exercises1 = ExerciseService.searchExercises('ПРИСЕДАНИЯ');
        final exercises2 = ExerciseService.searchExercises('приседания');

        // Assert
        expect(exercises1.length, equals(exercises2.length));
      });

      test('should return empty list for non-existent query', () {
        // Act
        final exercises = ExerciseService.searchExercises('nonexistent');

        // Assert
        expect(exercises, isEmpty);
      });
    });

    group('filterByCategory', () {
      test('should return all exercises when category is empty', () {
        // Act
        final exercises = ExerciseService.filterByCategory('');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.length, equals(ExerciseService.getAllExercises().length));
      });

      test('should return all exercises when category is All', () {
        // Act
        final exercises = ExerciseService.filterByCategory('All');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.length, equals(ExerciseService.getAllExercises().length));
      });

      test('should filter exercises by specific category', () {
        // Act
        final exercises = ExerciseService.filterByCategory('Ноги');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.every((e) => e.category == 'Ноги'), isTrue);
      });

      test('should return empty list for non-existent category', () {
        // Act
        final exercises = ExerciseService.filterByCategory('NonExistent');

        // Assert
        expect(exercises, isEmpty);
      });
    });

    group('filterByDifficulty', () {
      test('should return all exercises when difficulty is empty', () {
        // Act
        final exercises = ExerciseService.filterByDifficulty('');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.length, equals(ExerciseService.getAllExercises().length));
      });

      test('should return all exercises when difficulty is All', () {
        // Act
        final exercises = ExerciseService.filterByDifficulty('All');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.length, equals(ExerciseService.getAllExercises().length));
      });

      test('should filter exercises by specific difficulty', () {
        // Act
        final exercises = ExerciseService.filterByDifficulty('Beginner');

        // Assert
        expect(exercises, isNotEmpty);
        expect(exercises.every((e) => e.difficulty == 'Beginner'), isTrue);
      });

      test('should return empty list for non-existent difficulty', () {
        // Act
        final exercises = ExerciseService.filterByDifficulty('NonExistent');

        // Assert
        expect(exercises, isEmpty);
      });
    });

    group('getCategories', () {
      test('should return list of categories', () {
        // Act
        final categories = ExerciseService.getCategories();

        // Assert
        expect(categories, isNotEmpty);
        expect(categories, isA<List<String>>());
        expect(categories.contains('All'), isTrue);
      });

      test('should include all expected categories', () {
        // Act
        final categories = ExerciseService.getCategories();

        // Assert
        expect(categories.contains('All'), isTrue);
        expect(categories.contains('Ноги'), isTrue);
        expect(categories.contains('Спина'), isTrue);
        expect(categories.contains('Грудь'), isTrue);
        expect(categories.contains('Плечи'), isTrue);
        expect(categories.contains('Руки'), isTrue);
        expect(categories.contains('Пресс'), isTrue);
        expect(categories.contains('Кардио'), isTrue);
        expect(categories.contains('Растяжка'), isTrue);
      });
    });

    group('getDifficulties', () {
      test('should return list of difficulties', () {
        // Act
        final difficulties = ExerciseService.getDifficulties();

        // Assert
        expect(difficulties, isNotEmpty);
        expect(difficulties, isA<List<String>>());
        expect(difficulties.contains('All'), isTrue);
      });

      test('should include all expected difficulties', () {
        // Act
        final difficulties = ExerciseService.getDifficulties();

        // Assert
        expect(difficulties.contains('All'), isTrue);
        expect(difficulties.contains('Beginner'), isTrue);
        expect(difficulties.contains('Intermediate'), isTrue);
        expect(difficulties.contains('Advanced'), isTrue);
      });
    });

    group('getExerciseById', () {
      test('should return exercise when id exists', () {
        // Arrange
        final allExercises = ExerciseService.getAllExercises();
        final firstExercise = allExercises.first;

        // Act
        final exercise = ExerciseService.getExerciseById(firstExercise.id);

        // Assert
        expect(exercise, isNotNull);
        expect(exercise!.id, equals(firstExercise.id));
        expect(exercise.name, equals(firstExercise.name));
      });

      test('should return null when id does not exist', () {
        // Act
        final exercise = ExerciseService.getExerciseById('non-existent-id');

        // Assert
        expect(exercise, isNull);
      });

      test('should return null when id is empty', () {
        // Act
        final exercise = ExerciseService.getExerciseById('');

        // Assert
        expect(exercise, isNull);
      });
    });

    group('Edge Cases', () {
      test('should handle empty search query', () {
        // Act & Assert
        final result = ExerciseService.searchExercises('');
        expect(result, isA<List<Exercise>>());
      });

      test('should handle very long search query', () {
        // Arrange
        final longQuery = 'a' * 1000;

        // Act
        final exercises = ExerciseService.searchExercises(longQuery);

        // Assert
        expect(exercises, isA<List<Exercise>>());
        expect(exercises, isEmpty);
      });

      test('should handle special characters in search query', () {
        // Act
        final exercises = ExerciseService.searchExercises(r'!@#$%^&*()');

        // Assert
        expect(exercises, isA<List<Exercise>>());
        expect(exercises, isEmpty);
      });
    });
  });
}
