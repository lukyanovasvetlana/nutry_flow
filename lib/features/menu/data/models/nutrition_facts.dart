class NutritionFacts {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final double sodium;
  final double cholesterol;
  final double sugar;
  final double vitaminC;

  NutritionFacts({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.sodium,
    required this.cholesterol,
    required this.sugar,
    required this.vitaminC,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0,
      cholesterol: (json['cholesterol'] as num?)?.toDouble() ?? 0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0,
      vitaminC: (json['vitaminC'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'sodium': sodium,
      'cholesterol': cholesterol,
      'sugar': sugar,
      'vitaminC': vitaminC,
    };
  }
} 