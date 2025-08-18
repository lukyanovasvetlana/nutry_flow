import '../../domain/entities/goal.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/goals_repository.dart';

class MockGoalsRepository implements GoalsRepository {
  static final List<Goal> _goals = [];
  static final List<ProgressEntry> _progressEntries = [];
  static final List<Achievement> _achievements = [];

  MockGoalsRepository() {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    if (_goals.isNotEmpty) return; // Уже инициализировано

    final now = DateTime.now();
    final userId = 'demo-user-id';

    // Демо цели
    _goals.addAll([
      // Цель по весу - похудение
      Goal(
        id: 'goal-weight-1',
        userId: userId,
        type: GoalType.weight,
        status: GoalStatus.active,
        title: 'Сбросить 5 кг',
        description: 'Хочу похудеть к лету и чувствовать себя увереннее',
        targetValue: 70.0,
        currentValue: 75.0,
        unit: 'кг',
        startDate: now.subtract(const Duration(days: 30)),
        targetDate: now.add(const Duration(days: 60)),
        metadata: {
          'weightGoalType': 'lose',
          'startValue': 78.0,
          'tolerance': 1.0,
        },
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // Цель по активности
      Goal(
        id: 'goal-activity-1',
        userId: userId,
        type: GoalType.activity,
        status: GoalStatus.active,
        title: 'Тренировки 4 раза в неделю',
        description: 'Регулярные тренировки для поддержания формы',
        targetValue: 240.0, // 4 тренировки по 60 минут
        currentValue: 180.0, // уже 3 тренировки
        unit: 'мин/неделя',
        startDate: now.subtract(const Duration(days: 14)),
        targetDate: now.add(const Duration(days: 90)),
        metadata: {
          'workoutsPerWeek': 4,
          'durationPerWorkout': 60,
        },
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // Цель по питанию
      Goal(
        id: 'goal-nutrition-1',
        userId: userId,
        type: GoalType.nutrition,
        status: GoalStatus.active,
        title: 'Пить 2 литра воды в день',
        description: 'Поддерживать водный баланс организма',
        targetValue: 2.0,
        currentValue: 1.5,
        unit: 'л/день',
        startDate: now.subtract(const Duration(days: 7)),
        targetDate: now.add(const Duration(days: 30)),
        metadata: {
          'reminderTimes': ['08:00', '12:00', '16:00', '20:00'],
        },
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),

      // Завершенная цель
      Goal(
        id: 'goal-completed-1',
        userId: userId,
        type: GoalType.activity,
        status: GoalStatus.completed,
        title: 'Ходить 10000 шагов в день',
        description: 'Увеличить ежедневную активность',
        targetValue: 10000.0,
        currentValue: 12500.0,
        unit: 'шагов',
        startDate: now.subtract(const Duration(days: 45)),
        targetDate: now.subtract(const Duration(days: 15)),
        completedDate: now.subtract(const Duration(days: 10)),
        metadata: {
          'averageSteps': 11200,
          'bestDay': 15000,
        },
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
    ]);

    // Демо записи прогресса
    _progressEntries.addAll([
      // Записи веса
      for (int i = 0; i < 15; i++)
        ProgressEntry(
          id: 'progress-weight-$i',
          userId: userId,
          goalId: 'goal-weight-1',
          type: ProgressEntryType.weight,
          value: 78.0 - (i * 0.2), // Постепенное снижение веса
          unit: 'кг',
          date: now.subtract(Duration(days: 30 - (i * 2))),
          notes: i == 0
              ? 'Начальное взвешивание'
              : i == 14
                  ? 'Отличный прогресс!'
                  : null,
          createdAt: now.subtract(Duration(days: 30 - (i * 2))),
        ),

      // Записи тренировок
      for (int i = 0; i < 8; i++)
        ProgressEntry(
          id: 'progress-workout-$i',
          userId: userId,
          goalId: 'goal-activity-1',
          type: ProgressEntryType.workout,
          value: 45.0 + (i % 3 * 15), // 45, 60, 75 минут
          unit: 'мин',
          date: now.subtract(Duration(days: 14 - (i * 2))),
          notes: ['Кардио', 'Силовая', 'Йога'][i % 3],
          metadata: {
            'intensity': ['низкая', 'средняя', 'высокая'][i % 3],
            'calories': 200 + (i % 3 * 100),
          },
          createdAt: now.subtract(Duration(days: 14 - (i * 2))),
        ),

      // Записи воды
      for (int i = 0; i < 7; i++)
        ProgressEntry(
          id: 'progress-water-$i',
          userId: userId,
          goalId: 'goal-nutrition-1',
          type: ProgressEntryType.water,
          value: 1.2 + (i * 0.1), // От 1.2 до 1.8 литров
          unit: 'л',
          date: now.subtract(Duration(days: 7 - i)),
          notes: i == 6 ? 'Почти достиг цели!' : null,
          createdAt: now.subtract(Duration(days: 7 - i)),
        ),
    ]);

    // Демо достижения
    _achievements.addAll([
      Achievement(
        id: 'achievement-1',
        userId: userId,
        goalId: 'goal-completed-1',
        type: AchievementType.goalCompleted,
        category: AchievementCategory.activity,
        title: 'Цель достигнута!',
        description:
            'Поздравляем! Вы выполнили цель "Ходить 10000 шагов в день"',
        iconName: 'trophy',
        points: 100,
        earnedDate: now.subtract(const Duration(days: 10)),
        metadata: {'goalType': 'activity'},
      ),
      Achievement(
        id: 'achievement-2',
        userId: userId,
        type: AchievementType.milestone,
        category: AchievementCategory.weight,
        title: 'Первый шаг!',
        description:
            'Отличное начало! Вы сделали первую запись прогресса по весу',
        iconName: 'star',
        points: 10,
        earnedDate: now.subtract(const Duration(days: 30)),
        metadata: {'entryType': 'weight'},
      ),
      Achievement(
        id: 'achievement-3',
        userId: userId,
        type: AchievementType.streak,
        category: AchievementCategory.activity,
        title: 'Неделя силы!',
        description: 'Вы тренировались 7 дней подряд! Впечатляющее постоянство',
        iconName: 'fire',
        points: 50,
        earnedDate: now.subtract(const Duration(days: 5)),
        metadata: {'streakDays': 7, 'type': 'workout'},
      ),
      Achievement(
        id: 'achievement-4',
        userId: userId,
        type: AchievementType.improvement,
        category: AchievementCategory.weight,
        title: 'Отличный прогресс!',
        description: 'Вы потеряли уже 3 кг! Продолжайте в том же духе',
        iconName: 'trending_down',
        points: 30,
        earnedDate: now.subtract(const Duration(days: 15)),
        metadata: {'weightLoss': 3.0},
      ),
    ]);
  }

  @override
  Future<List<Goal>> getUserGoals(String userId) async {
    await _simulateNetworkDelay();
    return _goals.where((goal) => goal.userId == userId).toList();
  }

  @override
  Future<Goal?> getGoalById(String goalId) async {
    await _simulateNetworkDelay();
    try {
      return _goals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Goal> createGoal(Goal goal) async {
    await _simulateNetworkDelay();
    _goals.add(goal);
    return goal;
  }

  @override
  Future<Goal> updateGoal(Goal goal) async {
    await _simulateNetworkDelay();
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      return goal;
    }
    throw Exception('Goal not found');
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _simulateNetworkDelay();
    _goals.removeWhere((goal) => goal.id == goalId);
    _progressEntries.removeWhere((entry) => entry.goalId == goalId);
  }

  @override
  Future<List<ProgressEntry>> getProgressEntries(
    String userId, {
    String? goalId,
    ProgressEntryType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _simulateNetworkDelay();

    var filtered = _progressEntries.where((entry) => entry.userId == userId);

    if (goalId != null) {
      filtered = filtered.where((entry) => entry.goalId == goalId);
    }

    if (type != null) {
      filtered = filtered.where((entry) => entry.type == type);
    }

    if (startDate != null) {
      filtered = filtered.where((entry) =>
          entry.date.isAfter(startDate) ||
          entry.date.isAtSameMomentAs(startDate));
    }

    if (endDate != null) {
      filtered = filtered.where((entry) =>
          entry.date.isBefore(endDate) || entry.date.isAtSameMomentAs(endDate));
    }

    final result = filtered.toList();
    result.sort((a, b) => b.date.compareTo(a.date)); // Новые записи первыми
    return result;
  }

  @override
  Future<ProgressEntry> addProgressEntry(ProgressEntry entry) async {
    await _simulateNetworkDelay();
    _progressEntries.add(entry);
    return entry;
  }

  @override
  Future<void> deleteProgressEntry(String entryId) async {
    await _simulateNetworkDelay();
    _progressEntries.removeWhere((entry) => entry.id == entryId);
  }

  @override
  Future<List<Achievement>> getUserAchievements(String userId) async {
    await _simulateNetworkDelay();
    final result = _achievements
        .where((achievement) => achievement.userId == userId)
        .toList();
    result.sort((a, b) =>
        b.earnedDate.compareTo(a.earnedDate)); // Новые достижения первыми
    return result;
  }

  @override
  Future<Achievement> addAchievement(Achievement achievement) async {
    await _simulateNetworkDelay();
    _achievements.add(achievement);
    return achievement;
  }

  @override
  Future<void> markAchievementAsViewed(String achievementId) async {
    await _simulateNetworkDelay();
    // В реальной реализации здесь бы обновлялось поле viewed
  }

  @override
  Future<Map<String, dynamic>> getGoalStatistics(String goalId) async {
    await _simulateNetworkDelay();

    final goal = await getGoalById(goalId);
    if (goal == null) return {};

    final entries = await getProgressEntries(goal.userId, goalId: goalId);

    return {
      'totalEntries': entries.length,
      'firstEntryDate':
          entries.isNotEmpty ? entries.last.date.toIso8601String() : null,
      'lastEntryDate':
          entries.isNotEmpty ? entries.first.date.toIso8601String() : null,
      'averageValue': entries.isNotEmpty
          ? entries.map((e) => e.value).reduce((a, b) => a + b) / entries.length
          : 0.0,
      'bestValue': entries.isNotEmpty
          ? entries.map((e) => e.value).reduce((a, b) => a > b ? a : b)
          : 0.0,
      'progressPercentage': goal.progressPercentage,
      'daysActive': goal.startDate.difference(DateTime.now()).inDays.abs(),
      'daysRemaining': goal.daysRemaining,
    };
  }

  @override
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    await _simulateNetworkDelay();

    final goals = await getUserGoals(userId);
    final achievements = await getUserAchievements(userId);
    final allEntries = await getProgressEntries(userId);

    final activeGoals =
        goals.where((g) => g.status == GoalStatus.active).length;
    final completedGoals =
        goals.where((g) => g.status == GoalStatus.completed).length;
    final totalPoints = achievements.fold<int>(
        0, (sum, achievement) => sum + achievement.points);

    return {
      'totalGoals': goals.length,
      'activeGoals': activeGoals,
      'completedGoals': completedGoals,
      'completionRate':
          goals.isNotEmpty ? (completedGoals / goals.length * 100).round() : 0,
      'totalAchievements': achievements.length,
      'totalPoints': totalPoints,
      'totalProgressEntries': allEntries.length,
      'averageProgressPerWeek': allEntries.isNotEmpty && goals.isNotEmpty
          ? (allEntries.length /
                  (DateTime.now().difference(goals.first.startDate).inDays / 7))
              .round()
          : 0,
    };
  }

  @override
  Future<void> updateGoalProgress(String goalId, double newValue) async {
    await _simulateNetworkDelay();

    final index = _goals.indexWhere((goal) => goal.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        currentValue: newValue,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<List<Goal>> getActiveGoals(String userId) async {
    final goals = await getUserGoals(userId);
    return goals.where((goal) => goal.status == GoalStatus.active).toList();
  }

  @override
  Future<List<Goal>> getCompletedGoals(String userId) async {
    final goals = await getUserGoals(userId);
    return goals.where((goal) => goal.status == GoalStatus.completed).toList();
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
