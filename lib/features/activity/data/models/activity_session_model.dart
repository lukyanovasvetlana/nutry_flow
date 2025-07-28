import '../../domain/entities/activity_session.dart';

import 'workout_model.dart';

class ActivitySessionModel {
  final String id;
  final String userId;
  final String? workoutId;
  final WorkoutModel? workout;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationMinutes;
  final int? caloriesBurned;
  final String? notes;
  final Map<String, dynamic>? exerciseData;
  final DateTime createdAt;

  ActivitySessionModel({
    required this.id,
    required this.userId,
    this.workoutId,
    this.workout,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.durationMinutes,
    this.caloriesBurned,
    this.notes,
    this.exerciseData,
    required this.createdAt,
  });

  factory ActivitySessionModel.fromJson(Map<String, dynamic> json) {
    return ActivitySessionModel(
      id: json['id'],
      userId: json['user_id'],
      workoutId: json['workout_id'],
      workout: json['workouts'] != null 
          ? WorkoutModel.fromJson(json['workouts']) 
          : null,
      status: json['status'],
      startedAt: DateTime.parse(json['started_at']),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
      durationMinutes: json['duration_minutes'],
      caloriesBurned: json['calories_burned'],
      notes: json['notes'],
      exerciseData: json['exercise_data'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'workout_id': workoutId,
      'status': status,
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'notes': notes,
      'exercise_data': exerciseData,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ActivitySession toEntity() {
    return ActivitySession(
      id: id,
      userId: userId,
      workoutId: workoutId,
      workout: workout?.toEntity(),
      status: _parseStatus(status),
      startedAt: startedAt,
      completedAt: completedAt,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      notes: notes,
      exerciseData: exerciseData,
      createdAt: createdAt,
    );
  }

  static ActivitySessionModel fromEntity(ActivitySession session) {
    return ActivitySessionModel(
      id: session.id,
      userId: session.userId,
      workoutId: session.workoutId,
      workout: session.workout != null 
          ? WorkoutModel.fromEntity(session.workout!) 
          : null,
      status: _statusToString(session.status),
      startedAt: session.startedAt,
      completedAt: session.completedAt,
      durationMinutes: session.durationMinutes,
      caloriesBurned: session.caloriesBurned,
      notes: session.notes,
      exerciseData: session.exerciseData,
      createdAt: session.createdAt,
    );
  }

  static ActivitySessionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return ActivitySessionStatus.inProgress;
      case 'completed':
        return ActivitySessionStatus.completed;
      case 'paused':
        return ActivitySessionStatus.paused;
      case 'cancelled':
        return ActivitySessionStatus.cancelled;
      default:
        return ActivitySessionStatus.inProgress;
    }
  }

  static String _statusToString(ActivitySessionStatus status) {
    switch (status) {
      case ActivitySessionStatus.inProgress:
        return 'in_progress';
      case ActivitySessionStatus.completed:
        return 'completed';
      case ActivitySessionStatus.paused:
        return 'paused';
      case ActivitySessionStatus.cancelled:
        return 'cancelled';
    }
  }
} 