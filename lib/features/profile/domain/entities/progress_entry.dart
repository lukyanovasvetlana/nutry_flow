import 'package:equatable/equatable.dart';

enum ProgressEntryType {
  weight,
  workout,
  steps,
  calories,
  water,
  nutrition,
  measurement,
}

class ProgressEntry extends Equatable {
  final String id;
  final String userId;
  final String? goalId;
  final ProgressEntryType type;
  final double value;
  final String unit;
  final DateTime date;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const ProgressEntry({
    required this.id,
    required this.userId,
    this.goalId,
    required this.type,
    required this.value,
    required this.unit,
    required this.date,
    this.notes,
    this.metadata,
    required this.createdAt,
  });

  String get displayValue {
    switch (type) {
      case ProgressEntryType.weight:
        return '${value.toStringAsFixed(1)} $unit';
      case ProgressEntryType.steps:
        return '${value.toInt()} $unit';
      case ProgressEntryType.calories:
        return '${value.toInt()} $unit';
      case ProgressEntryType.water:
        return '${value.toStringAsFixed(1)} $unit';
      case ProgressEntryType.workout:
        return '${value.toInt()} $unit';
      case ProgressEntryType.nutrition:
        return '${value.toInt()} $unit';
      case ProgressEntryType.measurement:
        return '${value.toStringAsFixed(1)} $unit';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case ProgressEntryType.weight:
        return 'Вес';
      case ProgressEntryType.workout:
        return 'Тренировка';
      case ProgressEntryType.steps:
        return 'Шаги';
      case ProgressEntryType.calories:
        return 'Калории';
      case ProgressEntryType.water:
        return 'Вода';
      case ProgressEntryType.nutrition:
        return 'Питание';
      case ProgressEntryType.measurement:
        return 'Измерение';
    }
  }

  ProgressEntry copyWith({
    String? id,
    String? userId,
    String? goalId,
    ProgressEntryType? type,
    double? value,
    String? unit,
    DateTime? date,
    String? notes,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return ProgressEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      goalId: goalId ?? this.goalId,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        goalId,
        type,
        value,
        unit,
        date,
        notes,
        metadata,
        createdAt,
      ];
} 