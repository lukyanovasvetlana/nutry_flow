import 'package:nutry_flow/features/nutrition/domain/entities/food_item.dart';

class MockFoodItem extends FoodItem {
  const MockFoodItem({
    required super.id,
    required super.name,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required double sugar,
    required double sodium,
    super.brand,
    super.category,
    super.imageUrl,
    super.barcode,
    Map<String, dynamic>? nutritionFacts,
  }) : super(
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          fiber: fiber,
          sugar: sugar,
          sodium: sodium,
          nutritionFacts: nutritionFacts,
        );

  static FoodItem createSample() {
    return MockFoodItem(
      id: '1',
      name: 'Sample Food',
      calories: 250.0,
      protein: 15.0,
      carbs: 30.0,
      fat: 8.0,
      fiber: 5.0,
      sugar: 10.0,
      sodium: 300.0,
      brand: 'Sample Brand',
      category: 'Dairy',
      imageUrl: 'https://example.com/image.jpg',
      barcode: '123456789',
      nutritionFacts: {
        'vitamin_c': 20.0,
        'calcium': 100.0,
      },
    );
  }

  static FoodItem createMinimal() {
    return MockFoodItem(
      id: '2',
      name: 'Minimal Food',
      calories: 100.0,
      protein: 5.0,
      carbs: 15.0,
      fat: 3.0,
      fiber: 2.0,
      sugar: 5.0,
      sodium: 150.0,
    );
  }
}
