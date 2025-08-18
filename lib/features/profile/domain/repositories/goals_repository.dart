import '../entities/goal.dart';
import '../entities/progress_entry.dart';
import '../entities/achievement.dart';

abstract class GoalsRepository {
  // Goals CRUD operations
  Future<List<Goal>> getUserGoals(String userId);
  Future<Goal?> getGoalById(String goalId);
  Future<Goal> createGoal(Goal goal);
  Future<Goal> updateGoal(Goal goal);
  Future<void> deleteGoal(String goalId);

  // Progress tracking
  Future<List<ProgressEntry>> getProgressEntries(
    String userId, {
    String? goalId,
    ProgressEntryType? type,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ProgressEntry> addProgressEntry(ProgressEntry entry);
  Future<void> deleteProgressEntry(String entryId);

  // Achievements
  Future<List<Achievement>> getUserAchievements(String userId);
  Future<Achievement> addAchievement(Achievement achievement);
  Future<void> markAchievementAsViewed(String achievementId);

  // Statistics and analytics
  Future<Map<String, dynamic>> getGoalStatistics(String goalId);
  Future<Map<String, dynamic>> getUserStatistics(String userId);

  // Goal progress updates
  Future<void> updateGoalProgress(String goalId, double newValue);
  Future<List<Goal>> getActiveGoals(String userId);
  Future<List<Goal>> getCompletedGoals(String userId);
}
