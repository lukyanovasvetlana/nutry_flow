import 'nutrition_info.dart';

class Ingredient {
  final String name;
  final double amount;
  final String unit;
  final NutritionInfo nutritionPer100g;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.nutritionPer100g,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      nutritionPer100g: NutritionInfo.fromJson(json['nutrition_per_100g']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
      'nutrition_per_100g': nutritionPer100g.toJson(),
    };
  }
}
