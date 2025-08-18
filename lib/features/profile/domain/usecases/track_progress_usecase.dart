import 'package:uuid/uuid.dart';
import '../entities/goal.dart';
import '../entities/progress_entry.dart';
import '../entities/achievement.dart';
import '../repositories/goals_repository.dart';

class TrackProgressUseCase {
  final GoalsRepository _repository;
  final Uuid _uuid = const Uuid();

  TrackProgressUseCase(this._repository);

  Future<ProgressEntry> addProgressEntry({
    required String userId,
    String? goalId,
    required ProgressEntryType type,
    required double value,
    required String unit,
    DateTime? date,
    String? notes,
    Map<String, dynamic>? metadata,
  }) async {
    // Валидация
    _validateProgressEntry(type: type, value: value, date: date);

    final entry = ProgressEntry(
      id: _uuid.v4(),
      userId: userId,
      goalId: goalId,
      type: type,
      value: value,
      unit: unit,
      date: date ?? DateTime.now(),
      notes: notes?.trim(),
      metadata: metadata,
      createdAt: DateTime.now(),
    );

    // Добавляем запись прогресса
    final savedEntry = await _repository.addProgressEntry(entry);

    // Обновляем связанную цель, если есть
    if (goalId != null) {
      await _updateGoalProgress(goalId, value, type);
    }

    // Проверяем достижения
    await _checkForAchievements(userId, savedEntry);

    return savedEntry;
  }

  Future<List<ProgressEntry>> getProgressEntries(
    String userId, {
    String? goalId,
    ProgressEntryType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID не может быть пустым');
    }

    return _repository.getProgressEntries(
      userId,
      goalId: goalId,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> deleteProgressEntry(String entryId) async {
    if (entryId.isEmpty) {
      throw ArgumentError('Entry ID не может быть пустым');
    }

    await _repository.deleteProgressEntry(entryId);
  }

  Future<Map<String, List<ProgressEntry>>> getProgressByPeriod(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = await getProgressEntries(
      userId,
      startDate: startDate,
      endDate: endDate,
    );

    final grouped = <String, List<ProgressEntry>>{};
    for (final entry in entries) {
      final dateKey = _formatDateKey(entry.date);
      grouped[dateKey] = (grouped[dateKey] ?? [])..add(entry);
    }

    return grouped;
  }

  void _validateProgressEntry({
    required ProgressEntryType type,
    required double value,
    DateTime? date,
  }) {
    if (value < 0) {
      throw ArgumentError('Значение прогресса не может быть отрицательным');
    }

    // Специфичная валидация по типу
    switch (type) {
      case ProgressEntryType.weight:
        if (value < 30 || value > 300) {
          throw ArgumentError('Вес должен быть между 30 и 300 кг');
        }
        break;
      case ProgressEntryType.steps:
        if (value > 100000) {
          throw ArgumentError('Количество шагов не может превышать 100,000');
        }
        break;
      case ProgressEntryType.calories:
        if (value > 10000) {
          throw ArgumentError('Калории не могут превышать 10,000');
        }
        break;
      case ProgressEntryType.water:
        if (value > 10) {
          throw ArgumentError('Потребление воды не может превышать 10 литров');
        }
        break;
      case ProgressEntryType.workout:
        if (value > 24 * 60) {
          throw ArgumentError('Время тренировки не может превышать 24 часа');
        }
        break;
      case ProgressEntryType.nutrition:
        break; // Пока без ограничений
      case ProgressEntryType.measurement:
        if (value > 1000) {
          throw ArgumentError('Измерение не может превышать 1000');
        }
        break;
    }

    if (date != null && date.isAfter(DateTime.now())) {
      throw ArgumentError('Дата записи не может быть в будущем');
    }
  }

  Future<void> _updateGoalProgress(
      String goalId, double value, ProgressEntryType type) async {
    final goal = await _repository.getGoalById(goalId);
    if (goal == null) return;

    // Обновляем текущее значение цели в зависимости от типа
    double newCurrentValue = value;

    // Для некоторых типов целей нужна специальная логика
    if (goal.type == GoalType.weight && type == ProgressEntryType.weight) {
      newCurrentValue = value;
    } else if (goal.type == GoalType.activity) {
      // Для активности можем накапливать дневные значения
      newCurrentValue = value;
    }

    await _repository.updateGoalProgress(goalId, newCurrentValue);

    // Проверяем, не достигнута ли цель
    await _checkGoalCompletion(goal.copyWith(currentValue: newCurrentValue));
  }

  Future<void> _checkGoalCompletion(Goal goal) async {
    if (goal.isCompleted) return;

    bool isCompleted = false;

    switch (goal.type) {
      case GoalType.weight:
        final weightGoalType = goal.metadata?['weightGoalType'] as String?;
        final tolerance = goal.metadata?['tolerance'] as double? ?? 1.0;

        if (weightGoalType == 'lose') {
          isCompleted = goal.currentValue <= goal.targetValue;
        } else if (weightGoalType == 'gain') {
          isCompleted = goal.currentValue >= goal.targetValue;
        } else {
          // maintain
          isCompleted =
              (goal.currentValue - goal.targetValue).abs() <= tolerance;
        }
        break;
      case GoalType.activity:
      case GoalType.nutrition:
        isCompleted = goal.currentValue >= goal.targetValue;
        break;
    }

    if (isCompleted) {
      final updatedGoal = goal.copyWith(
        status: GoalStatus.completed,
        completedDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.updateGoal(updatedGoal);

      // Добавляем достижение за выполнение цели
      await _addGoalCompletionAchievement(goal);
    }
  }

  Future<void> _checkForAchievements(String userId, ProgressEntry entry) async {
    // Здесь можно добавить логику проверки различных достижений
    // Например, за постоянство, рекорды, серии и т.д.

    // Пример: достижение за первую запись прогресса
    final existingEntries =
        await _repository.getProgressEntries(userId, type: entry.type);
    if (existingEntries.length == 1) {
      // Первая запись этого типа
      await _addFirstEntryAchievement(userId, entry);
    }
  }

  Future<void> _addGoalCompletionAchievement(Goal goal) async {
    final achievement = Achievement(
      id: _uuid.v4(),
      userId: goal.userId,
      goalId: goal.id,
      type: AchievementType.goalCompleted,
      category: _getAchievementCategory(goal.type),
      title: 'Цель достигнута!',
      description: 'Поздравляем! Вы успешно выполнили цель "${goal.title}"',
      iconName: 'trophy',
      points: 100,
      earnedDate: DateTime.now(),
      metadata: {'goalType': goal.type.toString()},
    );

    await _repository.addAchievement(achievement);
  }

  Future<void> _addFirstEntryAchievement(
      String userId, ProgressEntry entry) async {
    final achievement = Achievement(
      id: _uuid.v4(),
      userId: userId,
      goalId: entry.goalId,
      type: AchievementType.milestone,
      category: _getAchievementCategory(_progressTypeToGoalType(entry.type)),
      title: 'Первый шаг!',
      description: 'Отличное начало! Вы сделали первую запись прогресса',
      iconName: 'star',
      points: 10,
      earnedDate: DateTime.now(),
      metadata: {'entryType': entry.type.toString()},
    );

    await _repository.addAchievement(achievement);
  }

  AchievementCategory _getAchievementCategory(GoalType goalType) {
    switch (goalType) {
      case GoalType.weight:
        return AchievementCategory.weight;
      case GoalType.activity:
        return AchievementCategory.activity;
      case GoalType.nutrition:
        return AchievementCategory.nutrition;
    }
  }

  GoalType _progressTypeToGoalType(ProgressEntryType progressType) {
    switch (progressType) {
      case ProgressEntryType.weight:
      case ProgressEntryType.measurement:
        return GoalType.weight;
      case ProgressEntryType.workout:
      case ProgressEntryType.steps:
        return GoalType.activity;
      case ProgressEntryType.calories:
      case ProgressEntryType.water:
      case ProgressEntryType.nutrition:
        return GoalType.nutrition;
    }
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
