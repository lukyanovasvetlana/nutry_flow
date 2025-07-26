import 'package:equatable/equatable.dart';

enum GoalType {
  weight,
  activity, 
  nutrition,
}

enum GoalStatus {
  active,
  completed,
  paused,
  cancelled,
}

enum WeightGoalType {
  lose,
  gain,
  maintain,
}

class Goal extends Equatable {
  final String id;
  final String userId;
  final GoalType type;
  final GoalStatus status;
  final String title;
  final String? description;
  final double targetValue;
  final double currentValue;
  final String unit;
  final DateTime startDate;
  final DateTime? targetDate;
  final DateTime? completedDate;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Goal({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.title,
    this.description,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.startDate,
    this.targetDate,
    this.completedDate,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progressPercentage {
    if (type == GoalType.weight) {
      final weightGoalType = metadata?['weightGoalType'] as String?;
      final startValue = metadata?['startValue'] as double? ?? currentValue;
      
      if (weightGoalType == 'lose') {
        // Для похудения: чем больше потеряли, тем больше прогресс
        final totalToLose = startValue - targetValue;
        final currentLoss = startValue - currentValue;
        return totalToLose > 0 ? (currentLoss / totalToLose * 100).clamp(0, 100) : 0;
      } else if (weightGoalType == 'gain') {
        // Для набора: чем больше набрали, тем больше прогресс  
        final totalToGain = targetValue - startValue;
        final currentGain = currentValue - startValue;
        return totalToGain > 0 ? (currentGain / totalToGain * 100).clamp(0, 100) : 0;
      } else {
        // Для поддержания: насколько близко к целевому весу
        final tolerance = metadata?['tolerance'] as double? ?? 2.0;
        final difference = (currentValue - targetValue).abs();
        return difference <= tolerance ? 100 : (tolerance / difference * 100).clamp(0, 100);
      }
    } else {
      // Для активности и питания: простой процент
      return targetValue > 0 ? (currentValue / targetValue * 100).clamp(0, 100) : 0;
    }
  }

  bool get isCompleted => status == GoalStatus.completed;
  
  bool get isActive => status == GoalStatus.active;
  
  bool get isOverdue => targetDate != null && 
                       DateTime.now().isAfter(targetDate!) && 
                       !isCompleted;

  int get daysRemaining {
    if (targetDate == null) return -1;
    final now = DateTime.now();
    if (now.isAfter(targetDate!)) return 0;
    return targetDate!.difference(now).inDays;
  }

  Goal copyWith({
    String? id,
    String? userId,
    GoalType? type,
    GoalStatus? status,
    String? title,
    String? description,
    double? targetValue,
    double? currentValue,
    String? unit,
    DateTime? startDate,
    DateTime? targetDate,
    DateTime? completedDate,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      completedDate: completedDate ?? this.completedDate,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        title,
        description,
        targetValue,
        currentValue,
        unit,
        startDate,
        targetDate,
        completedDate,
        metadata,
        createdAt,
        updatedAt,
      ];
} 