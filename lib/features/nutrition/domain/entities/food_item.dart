import 'package:equatable/equatable.dart';

/// Сущность продукта питания
class FoodItem extends Equatable {
  final String id;
  final String name;
  final String? brand;
  final String? barcode;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatsPer100g;
  final double carbsPer100g;
  final double fiberPer100g;
  final double sugarPer100g;
  final double sodiumPer100g;
  final String? category;
  final String? imageUrl;
  final String? description;
  final List<String> allergens;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodItem({
    required this.id,
    required this.name,
    this.brand,
    this.barcode,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.fatsPer100g,
    required this.carbsPer100g,
    this.fiberPer100g = 0.0,
    this.sugarPer100g = 0.0,
    this.sodiumPer100g = 0.0,
    this.category,
    this.imageUrl,
    this.description,
    this.allergens = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Рассчитывает калории для указанного количества в граммах
  double calculateCalories(double grams) {
    return (caloriesPer100g * grams) / 100;
  }

  /// Рассчитывает белки для указанного количества в граммах
  double calculateProtein(double grams) {
    return (proteinPer100g * grams) / 100;
  }

  /// Рассчитывает жиры для указанного количества в граммах
  double calculateFats(double grams) {
    return (fatsPer100g * grams) / 100;
  }

  /// Рассчитывает углеводы для указанного количества в граммах
  double calculateCarbs(double grams) {
    return (carbsPer100g * grams) / 100;
  }

  /// Рассчитывает клетчатку для указанного количества в граммах
  double calculateFiber(double grams) {
    return (fiberPer100g * grams) / 100;
  }

  /// Рассчитывает сахар для указанного количества в граммах
  double calculateSugar(double grams) {
    return (sugarPer100g * grams) / 100;
  }

  /// Рассчитывает натрий для указанного количества в граммах
  double calculateSodium(double grams) {
    return (sodiumPer100g * grams) / 100;
  }

  /// Проверяет, верифицирован ли продукт (всегда true для продуктов из базы)
  bool get isVerified => true;

  /// Создает копию с измененными полями
  FoodItem copyWith({
    String? id,
    String? name,
    String? brand,
    String? barcode,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? fatsPer100g,
    double? carbsPer100g,
    double? fiberPer100g,
    double? sugarPer100g,
    double? sodiumPer100g,
    String? category,
    String? imageUrl,
    String? description,
    List<String>? allergens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      fatsPer100g: fatsPer100g ?? this.fatsPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fiberPer100g: fiberPer100g ?? this.fiberPer100g,
      sugarPer100g: sugarPer100g ?? this.sugarPer100g,
      sodiumPer100g: sodiumPer100g ?? this.sodiumPer100g,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      allergens: allergens ?? this.allergens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        barcode,
        caloriesPer100g,
        proteinPer100g,
        fatsPer100g,
        carbsPer100g,
        fiberPer100g,
        sugarPer100g,
        sodiumPer100g,
        category,
        imageUrl,
        description,
        allergens,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, brand: $brand, calories: $caloriesPer100g/100g)';
  }
} 