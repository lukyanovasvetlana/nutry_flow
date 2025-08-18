import 'package:equatable/equatable.dart';
import 'workout.dart';

enum ActivitySessionStatus {
  inProgress,
  completed,
  paused,
  cancelled,
}

class ActivitySession extends Equatable {
  final String id;
  final String userId;
  final String? workoutId;
  final Workout? workout;
  final ActivitySessionStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? durationMinutes;
  final int? caloriesBurned;
  final String? notes;
  final Map<String, dynamic>? exerciseData; // Store exercise performance data
  final DateTime createdAt;

  const ActivitySession({
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

  int get actualDurationMinutes {
    if (completedAt != null) {
      return completedAt!.difference(startedAt).inMinutes;
    }
    return DateTime.now().difference(startedAt).inMinutes;
  }

  bool get isActive => status == ActivitySessionStatus.inProgress;

  bool get isCompleted => status == ActivitySessionStatus.completed;

  ActivitySession copyWith({
    String? id,
    String? userId,
    String? workoutId,
    Workout? workout,
    ActivitySessionStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? durationMinutes,
    int? caloriesBurned,
    String? notes,
    Map<String, dynamic>? exerciseData,
    DateTime? createdAt,
  }) {
    return ActivitySession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workoutId: workoutId ?? this.workoutId,
      workout: workout ?? this.workout,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      notes: notes ?? this.notes,
      exerciseData: exerciseData ?? this.exerciseData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        workoutId,
        workout,
        status,
        startedAt,
        completedAt,
        durationMinutes,
        caloriesBurned,
        notes,
        exerciseData,
        createdAt,
      ];
}
