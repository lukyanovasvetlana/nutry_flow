import 'package:equatable/equatable.dart';

class ActivityTracking extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int stepsCount;
  final double caloriesBurned;
  final int workoutDuration; // в минутах
  final double distance; // в километрах
  final String? workoutType; // running, cycling, swimming, etc.
  final double? averageHeartRate;
  final double? maxHeartRate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActivityTracking({
    required this.id,
    required this.userId,
    required this.date,
    required this.stepsCount,
    required this.caloriesBurned,
    required this.workoutDuration,
    required this.distance,
    this.workoutType,
    this.averageHeartRate,
    this.maxHeartRate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        stepsCount,
        caloriesBurned,
        workoutDuration,
        distance,
        workoutType,
        averageHeartRate,
        maxHeartRate,
        notes,
        createdAt,
        updatedAt,
      ];

  ActivityTracking copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? stepsCount,
    double? caloriesBurned,
    int? workoutDuration,
    double? distance,
    String? workoutType,
    double? averageHeartRate,
    double? maxHeartRate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityTracking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      stepsCount: stepsCount ?? this.stepsCount,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      workoutDuration: workoutDuration ?? this.workoutDuration,
      distance: distance ?? this.distance,
      workoutType: workoutType ?? this.workoutType,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
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
      'steps_count': stepsCount,
      'calories_burned': caloriesBurned,
      'workout_duration': workoutDuration,
      'distance': distance,
      'workout_type': workoutType,
      'average_heart_rate': averageHeartRate,
      'max_heart_rate': maxHeartRate,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ActivityTracking.fromJson(Map<String, dynamic> json) {
    return ActivityTracking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      stepsCount: json['steps_count'] as int,
      caloriesBurned: (json['calories_burned'] as num).toDouble(),
      workoutDuration: json['workout_duration'] as int,
      distance: (json['distance'] as num).toDouble(),
      workoutType: json['workout_type'] as String?,
      averageHeartRate: json['average_heart_rate'] != null
          ? (json['average_heart_rate'] as num).toDouble()
          : null,
      maxHeartRate: json['max_heart_rate'] != null
          ? (json['max_heart_rate'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
} 