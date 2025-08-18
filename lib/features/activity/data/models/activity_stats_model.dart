import '../../domain/entities/activity_stats.dart';

class ActivityStatsModel {
  final String id;
  final String userId;
  final DateTime date;
  final int totalWorkouts;
  final int totalDurationMinutes;
  final int totalCaloriesBurned;
  final int totalExercises;
  final Map<String, dynamic> categoryBreakdown;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityStatsModel({
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

  factory ActivityStatsModel.fromJson(Map<String, dynamic> json) {
    return ActivityStatsModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      totalWorkouts: json['total_workouts'] ?? 0,
      totalDurationMinutes: json['total_duration_minutes'] ?? 0,
      totalCaloriesBurned: json['total_calories_burned'] ?? 0,
      totalExercises: json['total_exercises'] ?? 0,
      categoryBreakdown: json['category_breakdown'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'total_workouts': totalWorkouts,
      'total_duration_minutes': totalDurationMinutes,
      'total_calories_burned': totalCaloriesBurned,
      'total_exercises': totalExercises,
      'category_breakdown': categoryBreakdown,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ActivityStats toEntity() {
    return ActivityStats(
      id: id,
      userId: userId,
      date: date,
      totalWorkouts: totalWorkouts,
      totalDurationMinutes: totalDurationMinutes,
      totalCaloriesBurned: totalCaloriesBurned,
      totalExercises: totalExercises,
      categoryBreakdown: _convertCategoryBreakdown(categoryBreakdown),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ActivityStatsModel fromEntity(ActivityStats stats) {
    return ActivityStatsModel(
      id: stats.id,
      userId: stats.userId,
      date: stats.date,
      totalWorkouts: stats.totalWorkouts,
      totalDurationMinutes: stats.totalDurationMinutes,
      totalCaloriesBurned: stats.totalCaloriesBurned,
      totalExercises: stats.totalExercises,
      categoryBreakdown: stats.categoryBreakdown,
      createdAt: stats.createdAt,
      updatedAt: stats.updatedAt,
    );
  }

  Map<String, int> _convertCategoryBreakdown(Map<String, dynamic> breakdown) {
    final result = <String, int>{};
    breakdown.forEach((key, value) {
      if (value is int) {
        result[key] = value;
      } else if (value is String) {
        result[key] = int.tryParse(value) ?? 0;
      }
    });
    return result;
  }
}
