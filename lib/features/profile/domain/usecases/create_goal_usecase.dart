import 'package:uuid/uuid.dart';
import '../entities/goal.dart';
import '../repositories/goals_repository.dart';

class CreateGoalUseCase {
  final GoalsRepository _repository;
  final Uuid _uuid = const Uuid();

  CreateGoalUseCase(this._repository);

  Future<Goal> execute({
    required String userId,
    required GoalType type,
    required String title,
    String? description,
    required double targetValue,
    required String unit,
    DateTime? targetDate,
    Map<String, dynamic>? metadata,
  }) async {
    // Валидация входных данных
    _validateGoalData(
      type: type,
      title: title,
      targetValue: targetValue,
      targetDate: targetDate,
    );

    final now = DateTime.now();
    final goal = Goal(
      id: _uuid.v4(),
      userId: userId,
      type: type,
      status: GoalStatus.active,
      title: title.trim(),
      description: description?.trim(),
      targetValue: targetValue,
      currentValue: _getInitialCurrentValue(type, metadata),
      unit: unit,
      startDate: now,
      targetDate: targetDate,
      metadata: metadata,
      createdAt: now,
      updatedAt: now,
    );

    return await _repository.createGoal(goal);
  }

  void _validateGoalData({
    required GoalType type,
    required String title,
    required double targetValue,
    DateTime? targetDate,
  }) {
    // Валидация заголовка
    if (title.trim().isEmpty) {
      throw ArgumentError('Название цели не может быть пустым');
    }
    if (title.trim().length < 3) {
      throw ArgumentError('Название цели должно содержать минимум 3 символа');
    }
    if (title.length > 100) {
      throw ArgumentError('Название цели не может превышать 100 символов');
    }

    // Валидация целевого значения
    if (targetValue <= 0) {
      throw ArgumentError('Целевое значение должно быть положительным');
    }

    // Специфичная валидация по типу цели
    switch (type) {
      case GoalType.weight:
        if (targetValue < 30 || targetValue > 300) {
          throw ArgumentError('Целевой вес должен быть между 30 и 300 кг');
        }
        break;
      case GoalType.activity:
        if (targetValue > 24 * 60) { // максимум 24 часа в минутах
          throw ArgumentError('Время активности не может превышать 24 часа в день');
        }
        break;
      case GoalType.nutrition:
        if (targetValue > 10000) { // разумный максимум калорий
          throw ArgumentError('Количество калорий не может превышать 10000');
        }
        break;
    }

    // Валидация даты
    if (targetDate != null) {
      final now = DateTime.now();
      if (targetDate.isBefore(now)) {
        throw ArgumentError('Целевая дата не может быть в прошлом');
      }
      if (targetDate.isAfter(now.add(const Duration(days: 365 * 2)))) {
        throw ArgumentError('Целевая дата не может быть более чем через 2 года');
      }
    }
  }

  double _getInitialCurrentValue(GoalType type, Map<String, dynamic>? metadata) {
    switch (type) {
      case GoalType.weight:
        // Для веса берем стартовое значение из метаданных
        return metadata?['startValue'] as double? ?? 0.0;
      case GoalType.activity:
      case GoalType.nutrition:
        // Для активности и питания начинаем с 0
        return 0.0;
    }
  }
} 