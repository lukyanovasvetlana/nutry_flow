import 'package:equatable/equatable.dart';

class ActivityStats extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int totalWorkouts;
  final int totalDurationMinutes;
  final int totalCaloriesBurned;
  final int totalExercises;
  final Map<String, int> categoryBreakdown; // Exercise category -> count
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActivityStats({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalWorkouts,
    required this.totalDurationMinutes,
    required this.totalCaloriesBurned,
    required this.totalExercises,
    required this.categoryBreakdown,
    required this.createdAt,
    required this.updatedAt,
  });

  double get averageWorkoutDuration {
    if (totalWorkouts == 0) return 0.0;
    return totalDurationMinutes / totalWorkouts;
  }

  double get averageCaloriesPerWorkout {
    if (totalWorkouts == 0) return 0.0;
    return totalCaloriesBurned / totalWorkouts;
  }

  String get mostActiveCategory {
    if (categoryBreakdown.isEmpty) return 'Нет данных';
    
    String mostActive = '';
    int maxCount = 0;
    
    categoryBreakdown.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostActive = category;
      }
    });
    
    return mostActive;
  }

  ActivityStats copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? totalWorkouts,
    int? totalDurationMinutes,
    int? totalCaloriesBurned,
    int? totalExercises,
    Map<String, int>? categoryBreakdown,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityStats(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      totalCaloriesBurned: totalCaloriesBurned ?? this.totalCaloriesBurned,
      totalExercises: totalExercises ?? this.totalExercises,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        totalWorkouts,
        totalDurationMinutes,
        totalCaloriesBurned,
        totalExercises,
        categoryBreakdown,
        createdAt,
        updatedAt,
      ];
} 