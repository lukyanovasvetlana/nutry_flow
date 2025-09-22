import 'package:nutry_flow/features/menu/data/models/menu_item.dart';

class MockMenuItem extends MenuItem {
  MockMenuItem({
    required super.id,
    required String name,
    required super.description,
    required int prepTime,
    required int cookTime,
    required int servings,
    required List<String> ingredients,
    required List<String> instructions,
    required List<Photo> super.photos,
    required List<String> tags,
    required super.difficulty,
    required super.rating,
    required int reviewCount,
    required String author,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          name: name,
          prepTime: prepTime,
          cookTime: cookTime,
          servings: servings,
          ingredients: ingredients,
          instructions: instructions,
          tags: tags,
          reviewCount: reviewCount,
          author: author,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static MenuItem createSample() {
    return MockMenuItem(
      id: '1',
      name: 'Sample Recipe',
      description: 'A delicious sample recipe for testing',
      prepTime: 15,
      cookTime: 30,
      servings: 4,
      ingredients: ['ingredient1', 'ingredient2', 'ingredient3'],
      instructions: ['step1', 'step2', 'step3'],
      photos: [
        Photo(
          id: '1',
          url: 'https://example.com/photo1.jpg',
          alt: 'Sample photo',
        ),
      ],
      tags: ['tag1', 'tag2'],
      difficulty: 'Easy',
      rating: 4.5,
      reviewCount: 10,
      author: 'Test Author',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static MenuItem createMinimal() {
    return MockMenuItem(
      id: '2',
      name: 'Minimal Recipe',
      description: 'A minimal recipe',
      prepTime: 5,
      cookTime: 10,
      servings: 2,
      ingredients: ['ingredient1'],
      instructions: ['step1'],
      photos: [],
      tags: [],
      difficulty: 'Easy',
      rating: 3.0,
      reviewCount: 0,
      author: 'Minimal Author',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
