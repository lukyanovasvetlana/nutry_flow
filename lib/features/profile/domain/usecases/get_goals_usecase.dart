import '../entities/goal.dart';
import '../repositories/goals_repository.dart';

class GetGoalsUseCase {
  final GoalsRepository _repository;

  GetGoalsUseCase(this._repository);

  Future<List<Goal>> execute(String userId, {GoalStatus? status}) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID не может быть пустым');
    }

    final goals = await _repository.getUserGoals(userId);
    
    if (status != null) {
      return goals.where((goal) => goal.status == status).toList();
    }
    
    return goals;
  }

  Future<List<Goal>> getActiveGoals(String userId) async {
    return await _repository.getActiveGoals(userId);
  }

  Future<List<Goal>> getCompletedGoals(String userId) async {
    return await _repository.getCompletedGoals(userId);
  }

  Future<Goal?> getGoalById(String goalId) async {
    if (goalId.isEmpty) {
      throw ArgumentError('Goal ID не может быть пустым');
    }
    
    return await _repository.getGoalById(goalId);
  }

  Future<Map<String, dynamic>> getGoalStatistics(String goalId) async {
    if (goalId.isEmpty) {
      throw ArgumentError('Goal ID не может быть пустым');
    }
    
    return await _repository.getGoalStatistics(goalId);
  }

  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID не может быть пустым');
    }
    
    return await _repository.getUserStatistics(userId);
  }

  List<Goal> filterGoalsByType(List<Goal> goals, GoalType type) {
    return goals.where((goal) => goal.type == type).toList();
  }

  List<Goal> getOverdueGoals(List<Goal> goals) {
    return goals.where((goal) => goal.isOverdue).toList();
  }

  List<Goal> getNearingDeadlineGoals(List<Goal> goals, {int daysThreshold = 7}) {
    return goals.where((goal) {
      if (goal.targetDate == null || goal.isCompleted) return false;
      return goal.daysRemaining <= daysThreshold && goal.daysRemaining > 0;
    }).toList();
  }
} 