import 'package:equatable/equatable.dart';

class WeightTracking extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final double? waterPercentage;
  final double? bmi;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WeightTracking({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.waterPercentage,
    this.bmi,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        weight,
        bodyFatPercentage,
        muscleMass,
        waterPercentage,
        bmi,
        notes,
        createdAt,
        updatedAt,
      ];

  WeightTracking copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    double? waterPercentage,
    double? bmi,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WeightTracking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
      waterPercentage: waterPercentage ?? this.waterPercentage,
      bmi: bmi ?? this.bmi,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'weight': weight,
      'body_fat_percentage': bodyFatPercentage,
      'muscle_mass': muscleMass,
      'water_percentage': waterPercentage,
      'bmi': bmi,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory WeightTracking.fromJson(Map<String, dynamic> json) {
    return WeightTracking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num).toDouble(),
      bodyFatPercentage: json['body_fat_percentage'] != null
          ? (json['body_fat_percentage'] as num).toDouble()
          : null,
      muscleMass: json['muscle_mass'] != null
          ? (json['muscle_mass'] as num).toDouble()
          : null,
      waterPercentage: json['water_percentage'] != null
          ? (json['water_percentage'] as num).toDouble()
          : null,
      bmi: json['bmi'] != null ? (json['bmi'] as num).toDouble() : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
