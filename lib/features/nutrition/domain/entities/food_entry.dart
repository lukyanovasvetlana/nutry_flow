/// Тип приема пищи
enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

/// Entity класс записи о еде
class FoodEntry {
  final String id;
  final String userId;
  final String foodItemId;
  final String foodName;
  final double quantity;
  final String unit;
  final MealType mealType;
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? consumedAt;
  final String? notes;
  final double? grams;

  const FoodEntry({
    required this.id,
    required this.userId,
    required this.foodItemId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.mealType,
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.createdAt,
    required this.updatedAt,
    this.consumedAt,
    this.notes,
    this.grams,
  });

  // Computed properties for total nutrition values
  double get totalCalories => calories * quantity;
  double get totalProtein => protein * quantity;
  double get totalCarbs => carbs * quantity;
  double get totalFats => fat * quantity;
  double get totalFiber => fiber * quantity;
  double get totalSugar => sugar * quantity;
  double get totalSodium => sodium * quantity;

  // Helper property for date comparison
  DateTime get dateOnly => DateTime(date.year, date.month, date.day);

  FoodEntry copyWith({
    String? id,
    String? userId,
    String? foodItemId,
    String? foodName,
    double? quantity,
    String? unit,
    MealType? mealType,
    DateTime? date,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sugar,
    double? sodium,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? consumedAt,
    String? notes,
    double? grams,
  }) {
    return FoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodItemId: foodItemId ?? this.foodItemId,
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      consumedAt: consumedAt ?? this.consumedAt,
      notes: notes ?? this.notes,
      grams: grams ?? this.grams,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'food_item_id': foodItemId,
      'food_name': foodName,
      'quantity': quantity,
      'unit': unit,
      'meal_type': mealType.name,
      'date': date.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'consumed_at': consumedAt?.toIso8601String(),
      'notes': notes,
      'grams': grams,
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      foodItemId: json['food_item_id'] as String,
      foodName: json['food_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['meal_type'],
        orElse: () => MealType.breakfast,
      ),
      date: DateTime.parse(json['date'] as String),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      sodium: (json['sodium'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      consumedAt: json['consumed_at'] != null
          ? DateTime.parse(json['consumed_at'] as String)
          : null,
      notes: json['notes'] as String?,
      grams: json['grams'] != null ? (json['grams'] as num).toDouble() : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FoodEntry(id: $id, foodName: $foodName, quantity: $quantity $unit)';
  }
}
