import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/food_entry.dart';

class FoodEntryModel {
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

  const FoodEntryModel({
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

  factory FoodEntryModel.fromJson(Map<String, dynamic> json) {
    return FoodEntryModel(
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

  FoodEntry toEntity() {
    return FoodEntry(
      id: id,
      userId: userId,
      foodItemId: foodItemId,
      foodName: foodName,
      quantity: quantity,
      unit: unit,
      mealType: mealType,
      date: date,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
      createdAt: createdAt,
      updatedAt: updatedAt,
      consumedAt: consumedAt,
      notes: notes,
      grams: grams,
    );
  }

  factory FoodEntryModel.fromEntity(FoodEntry entity) {
    return FoodEntryModel(
      id: entity.id,
      userId: entity.userId,
      foodItemId: entity.foodItemId,
      foodName: entity.foodName,
      quantity: entity.quantity,
      unit: entity.unit,
      mealType: entity.mealType,
      date: entity.date,
      calories: entity.calories,
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
      fiber: entity.fiber,
      sugar: entity.sugar,
      sodium: entity.sodium,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      consumedAt: entity.consumedAt,
      notes: entity.notes,
      grams: entity.grams,
    );
  }
} 