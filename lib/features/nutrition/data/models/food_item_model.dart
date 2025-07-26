import '../../domain/entities/food_item.dart';

class FoodItemModel extends FoodItem {
  FoodItemModel({
    required super.id,
    required super.name,
    required super.caloriesPer100g,
    required super.proteinPer100g,
    required super.fatsPer100g,
    required super.carbsPer100g,
    super.brand,
    super.barcode,
    super.category,
    super.fiberPer100g,
    super.sugarPer100g,
    super.sodiumPer100g,
    super.imageUrl,
    super.description,
    super.allergens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
  );

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      caloriesPer100g: (json['calories_per_100g'] as num).toDouble(),
      proteinPer100g: (json['protein_per_100g'] as num).toDouble(),
      fatsPer100g: (json['fats_per_100g'] as num).toDouble(),
      carbsPer100g: (json['carbs_per_100g'] as num).toDouble(),
      brand: json['brand'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String?,
      fiberPer100g: json['fiber_per_100g'] != null 
          ? (json['fiber_per_100g'] as num).toDouble() 
          : 0.0,
      sugarPer100g: json['sugar_per_100g'] != null 
          ? (json['sugar_per_100g'] as num).toDouble() 
          : 0.0,
      sodiumPer100g: json['sodium_per_100g'] != null 
          ? (json['sodium_per_100g'] as num).toDouble() 
          : 0.0,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      allergens: json['allergens'] != null 
          ? List<String>.from(json['allergens'] as List) 
          : [],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories_per_100g': caloriesPer100g,
      'protein_per_100g': proteinPer100g,
      'fats_per_100g': fatsPer100g,
      'carbs_per_100g': carbsPer100g,
      'brand': brand,
      'barcode': barcode,
      'category': category,
      'fiber_per_100g': fiberPer100g,
      'sugar_per_100g': sugarPer100g,
      'sodium_per_100g': sodiumPer100g,
      'image_url': imageUrl,
      'description': description,
      'allergens': allergens,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory FoodItemModel.fromEntity(FoodItem entity) {
    return FoodItemModel(
      id: entity.id,
      name: entity.name,
      caloriesPer100g: entity.caloriesPer100g,
      proteinPer100g: entity.proteinPer100g,
      fatsPer100g: entity.fatsPer100g,
      carbsPer100g: entity.carbsPer100g,
      brand: entity.brand,
      barcode: entity.barcode,
      category: entity.category,
      fiberPer100g: entity.fiberPer100g,
      sugarPer100g: entity.sugarPer100g,
      sodiumPer100g: entity.sodiumPer100g,
      imageUrl: entity.imageUrl,
      description: entity.description,
      allergens: entity.allergens,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  FoodItem toEntity() {
    return FoodItem(
      id: id,
      name: name,
      caloriesPer100g: caloriesPer100g,
      proteinPer100g: proteinPer100g,
      fatsPer100g: fatsPer100g,
      carbsPer100g: carbsPer100g,
      brand: brand,
      barcode: barcode,
      category: category,
      fiberPer100g: fiberPer100g,
      sugarPer100g: sugarPer100g,
      sodiumPer100g: sodiumPer100g,
      imageUrl: imageUrl,
      description: description,
      allergens: allergens,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
} 