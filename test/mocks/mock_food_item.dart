import 'package:nutry_flow/features/nutrition/domain/entities/food_item.dart';

class MockFoodItem extends FoodItem {
  const MockFoodItem({
    required super.id,
    required super.name,
    required super.caloriesPer100g,
    required super.proteinPer100g,
    required super.carbsPer100g,
    required super.fatsPer100g,
    required super.fiberPer100g,
    required super.sugarPer100g,
    required super.sodiumPer100g,
    required super.createdAt,
    required super.updatedAt,
    super.brand,
    super.category,
    super.imageUrl,
    super.barcode,
  });

  static FoodItem createSample() {
    final now = DateTime.now();
    return MockFoodItem(
      id: '1',
      name: 'Sample Food',
      caloriesPer100g: 250.0,
      proteinPer100g: 15.0,
      carbsPer100g: 30.0,
      fatsPer100g: 8.0,
      fiberPer100g: 5.0,
      sugarPer100g: 10.0,
      sodiumPer100g: 300.0,
      createdAt: now,
      updatedAt: now,
      brand: 'Sample Brand',
      category: 'Dairy',
      imageUrl: 'https://example.com/image.jpg',
      barcode: '123456789',
    );
  }

  static FoodItem createMinimal() {
    final now = DateTime.now();
    return MockFoodItem(
      id: '2',
      name: 'Minimal Food',
      caloriesPer100g: 100.0,
      proteinPer100g: 5.0,
      carbsPer100g: 15.0,
      fatsPer100g: 3.0,
      fiberPer100g: 2.0,
      sugarPer100g: 5.0,
      sodiumPer100g: 150.0,
      createdAt: now,
      updatedAt: now,
    );
  }
}
