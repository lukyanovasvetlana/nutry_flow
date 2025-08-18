class GroceryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String? unit;
  final double? pricePerUnit;
  final bool isCompleted;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.unit,
    this.pricePerUnit,
    this.isCompleted = false,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Создает копию с изменениями
  GroceryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    String? unit,
    double? pricePerUnit,
    bool? isCompleted,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Создает GroceryItem из JSON
  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String?,
      pricePerUnit: json['price_per_unit']?.toDouble(),
      isCompleted: json['is_completed'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Конвертирует GroceryItem в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'price_per_unit': pricePerUnit,
      'is_completed': isCompleted,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Возвращает общую стоимость
  double? get totalPrice {
    if (pricePerUnit == null) return null;
    return pricePerUnit! * quantity;
  }

  /// Возвращает отформатированное название с количеством
  String get displayName {
    final unitText = unit != null ? ' $unit' : '';
    return '$name ($quantity$unitText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroceryItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GroceryItem(id: $id, name: $name, quantity: $quantity, isCompleted: $isCompleted)';
  }
}
