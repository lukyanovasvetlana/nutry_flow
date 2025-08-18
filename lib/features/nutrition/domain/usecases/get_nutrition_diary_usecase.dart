import '../entities/food_entry.dart';
import '../entities/nutrition_summary.dart';
import '../repositories/nutrition_repository.dart';

/// Дневник питания за определенную дату
class NutritionDiary {
  final DateTime date;
  final NutritionSummary summary;
  final Map<MealType, List<FoodEntry>> entriesByMeal;
  final List<FoodEntry> allEntries;

  const NutritionDiary({
    required this.date,
    required this.summary,
    required this.entriesByMeal,
    required this.allEntries,
  });

  /// Получает записи для определенного типа приема пищи
  List<FoodEntry> getEntriesForMeal(MealType mealType) {
    return entriesByMeal[mealType] ?? [];
  }

  /// Проверяет, есть ли записи за день
  bool get hasEntries => allEntries.isNotEmpty;

  /// Получает количество приемов пищи
  int get mealCount => entriesByMeal.keys.length;

  /// Получает общее количество записей
  int get totalEntries => allEntries.length;

  /// Возвращает все записи (алиас для allEntries)
  List<FoodEntry> get entries => allEntries;
}

/// Use Case для получения дневника питания
class GetNutritionDiaryUseCase {
  final NutritionRepository _repository;

  const GetNutritionDiaryUseCase(this._repository);

  /// Получает дневник питания за определенную дату
  Future<NutritionDiary> execute(String userId, DateTime date) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    // Нормализуем дату (убираем время, оставляем только дату)
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Получаем записи о приеме пищи за день
    final entries =
        await _repository.getFoodEntriesByDate(userId, normalizedDate);

    // Группируем записи по типам приемов пищи
    final entriesByMeal = _groupEntriesByMealType(entries);

    // Получаем или создаем суммарную информацию
    final summary = await _getSummaryForDate(userId, normalizedDate, entries);

    return NutritionDiary(
      date: normalizedDate,
      summary: summary,
      entriesByMeal: entriesByMeal,
      allEntries: entries,
    );
  }

  /// Получает дневник питания за день (алиас для execute)
  Future<NutritionDiary> getDailyDiary(String userId, DateTime date) async {
    return execute(userId, date);
  }

  /// Получает дневники питания за период
  Future<List<NutritionDiary>> getDateRangeDiary(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return getForDateRange(userId, startDate, endDate);
  }

  /// Получает дневники питания за неделю
  Future<List<NutritionDiary>> getWeeklyDiary(
    String userId,
    DateTime weekStart,
  ) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return getForDateRange(userId, weekStart, weekEnd);
  }

  /// Получает дневники питания за месяц
  Future<List<NutritionDiary>> getMonthlyDiary(
    String userId,
    DateTime monthStart,
  ) async {
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
    return getForDateRange(userId, monthStart, monthEnd);
  }

  /// Получает отфильтрованные дневники питания
  Future<List<NutritionDiary>> getFilteredDiary(
    String userId,
    DateTime startDate,
    DateTime endDate, {
    MealType? mealType,
    String? foodCategory,
  }) async {
    final diaries = await getForDateRange(userId, startDate, endDate);

    if (mealType == null && foodCategory == null) {
      return diaries;
    }

    return Future.wait(diaries.map((diary) async {
      List<FoodEntry> filteredEntries = diary.allEntries;

      // Фильтруем по типу приема пищи
      if (mealType != null) {
        filteredEntries = filteredEntries
            .where((entry) => entry.mealType == mealType)
            .toList();
      }

      // Фильтруем по категории продукта
      if (foodCategory != null) {
        // Асинхронно фильтруем записи по категории
        final filtered = <FoodEntry>[];
        for (final entry in filteredEntries) {
          final foodItem = await _repository.getFoodItemById(entry.foodItemId);
          if (foodItem?.category?.toLowerCase() == foodCategory.toLowerCase()) {
            filtered.add(entry);
          }
        }
        filteredEntries = filtered;
      }

      // Создаем новый дневник с отфильтрованными записями
      final filteredEntriesByMeal = _groupEntriesByMealType(filteredEntries);
      final filteredSummary =
          NutritionSummary.fromEntries(diary.date, filteredEntries);

      return NutritionDiary(
        date: diary.date,
        summary: filteredSummary,
        entriesByMeal: filteredEntriesByMeal,
        allEntries: filteredEntries,
      );
    }));
  }

  /// Анализирует соблюдение целей питания
  Future<NutritionGoalsAnalysis> getGoalAnalysis(
    String userId,
    DateTime date,
    NutritionGoals goals,
  ) async {
    return analyzeNutritionGoals(userId, date, goals);
  }

  /// Получает дневники питания за период
  Future<List<NutritionDiary>> getForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Начальная дата не может быть позже конечной');
    }

    // Получаем записи за период
    final entries =
        await _repository.getFoodEntriesByDateRange(userId, startDate, endDate);

    // Группируем записи по датам
    final entriesByDate = _groupEntriesByDate(entries);

    // Создаем дневники для каждой даты
    final diaries = <NutritionDiary>[];

    for (var date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final dateEntries = entriesByDate[_dateKey(date)] ?? [];
      final entriesByMeal = _groupEntriesByMealType(dateEntries);
      final summary = await _getSummaryForDate(userId, date, dateEntries);

      diaries.add(NutritionDiary(
        date: date,
        summary: summary,
        entriesByMeal: entriesByMeal,
        allEntries: dateEntries,
      ));
    }

    return diaries;
  }

  /// Получает записи для определенного типа приема пищи
  Future<List<FoodEntry>> getEntriesForMealType(
    String userId,
    DateTime date,
    MealType mealType,
  ) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    return _repository.getFoodEntriesByMealType(userId, date, mealType);
  }

  /// Получает последние записи пользователя
  Future<List<FoodEntry>> getRecentEntries(String userId,
      {int limit = 10}) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    return _repository.getRecentFoodEntries(userId, limit: limit);
  }

  /// Получает статистику питания за неделю
  Future<Map<DateTime, NutritionSummary>> getWeeklyStats(
    String userId,
    DateTime weekStart,
  ) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    return _repository.getWeeklyNutritionStats(userId, weekStart);
  }

  /// Получает статистику питания за месяц
  Future<Map<DateTime, NutritionSummary>> getMonthlyStats(
    String userId,
    DateTime monthStart,
  ) async {
    if (userId.trim().isEmpty) {
      throw ArgumentError('ID пользователя не может быть пустым');
    }

    return _repository.getMonthlyNutritionStats(userId, monthStart);
  }

  /// Анализирует соблюдение целей питания
  Future<NutritionGoalsAnalysis> analyzeNutritionGoals(
    String userId,
    DateTime date,
    NutritionGoals goals,
  ) async {
    final diary = await execute(userId, date);

    return NutritionGoalsAnalysis(
      date: date,
      goals: goals,
      actual: diary.summary,
      caloriesPercentage:
          diary.summary.getCaloriesPercentage(goals.dailyCalories),
      proteinPercentage: diary.summary.getProteinPercentage(goals.dailyProtein),
      fatsPercentage: diary.summary.getFatsPercentage(goals.dailyFats),
      carbsPercentage: diary.summary.getCarbsPercentage(goals.dailyCarbs),
      isCaloriesExceeded: diary.summary.isCaloriesExceeded(goals.dailyCalories),
      remainingCalories:
          diary.summary.getRemainingCalories(goals.dailyCalories),
    );
  }

  /// Группирует записи по типам приемов пищи
  Map<MealType, List<FoodEntry>> _groupEntriesByMealType(
      List<FoodEntry> entries) {
    final grouped = <MealType, List<FoodEntry>>{};

    for (final entry in entries) {
      grouped.putIfAbsent(entry.mealType, () => []).add(entry);
    }

    // Сортируем записи в каждой группе по времени
    for (final mealEntries in grouped.values) {
      mealEntries.sort(
          (a, b) => (a.consumedAt ?? a.date).compareTo(b.consumedAt ?? b.date));
    }

    return grouped;
  }

  /// Группирует записи по датам
  Map<String, List<FoodEntry>> _groupEntriesByDate(List<FoodEntry> entries) {
    final grouped = <String, List<FoodEntry>>{};

    for (final entry in entries) {
      final dateKey = _dateKey(entry.dateOnly);
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    return grouped;
  }

  /// Создает ключ для даты
  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Получает или создает суммарную информацию для даты
  Future<NutritionSummary> _getSummaryForDate(
    String userId,
    DateTime date,
    List<FoodEntry> entries,
  ) async {
    try {
      // Пытаемся получить готовую суммарную информацию
      return await _repository.getNutritionSummaryByDate(userId, date);
    } catch (e) {
      // Если не удалось, создаем на основе записей
      return NutritionSummary.fromEntries(date, entries);
    }
  }
}

/// Цели питания пользователя
class NutritionGoals {
  final double dailyCalories;
  final double dailyProtein;
  final double dailyFats;
  final double dailyCarbs;

  const NutritionGoals({
    required this.dailyCalories,
    required this.dailyProtein,
    required this.dailyFats,
    required this.dailyCarbs,
  });
}

/// Анализ соблюдения целей питания
class NutritionGoalsAnalysis {
  final DateTime date;
  final NutritionGoals goals;
  final NutritionSummary actual;
  final double caloriesPercentage;
  final double proteinPercentage;
  final double fatsPercentage;
  final double carbsPercentage;
  final bool isCaloriesExceeded;
  final double remainingCalories;

  const NutritionGoalsAnalysis({
    required this.date,
    required this.goals,
    required this.actual,
    required this.caloriesPercentage,
    required this.proteinPercentage,
    required this.fatsPercentage,
    required this.carbsPercentage,
    required this.isCaloriesExceeded,
    required this.remainingCalories,
  });

  /// Создает анализ из сводки питания
  factory NutritionGoalsAnalysis.fromSummary(
    DateTime date,
    NutritionSummary summary,
    NutritionGoals goals,
  ) {
    return NutritionGoalsAnalysis(
      date: date,
      goals: goals,
      actual: summary,
      caloriesPercentage: summary.getCaloriesPercentage(goals.dailyCalories),
      proteinPercentage: summary.getProteinPercentage(goals.dailyProtein),
      fatsPercentage: summary.getFatsPercentage(goals.dailyFats),
      carbsPercentage: summary.getCarbsPercentage(goals.dailyCarbs),
      isCaloriesExceeded: summary.isCaloriesExceeded(goals.dailyCalories),
      remainingCalories: summary.getRemainingCalories(goals.dailyCalories),
    );
  }

  /// Проверяет, достигнуты ли все цели
  bool get allGoalsAchieved {
    return caloriesPercentage >= 90 &&
        caloriesPercentage <= 110 &&
        proteinPercentage >= 80 &&
        fatsPercentage >= 20 &&
        fatsPercentage <= 35 &&
        carbsPercentage >= 45 &&
        carbsPercentage <= 65;
  }

  /// Получает процент общего выполнения целей
  double get overallCompletionPercentage {
    final scores = [
      _normalizePercentage(caloriesPercentage, 100),
      _normalizePercentage(proteinPercentage, 100),
      _normalizePercentage(fatsPercentage, 100),
      _normalizePercentage(carbsPercentage, 100),
    ];

    return scores.reduce((a, b) => a + b) / scores.length;
  }

  /// Алиас для overallCompletionPercentage
  double get overallScore => overallCompletionPercentage;

  /// Проверяет, достигнута ли цель по калориям
  bool get isCaloriesOnTarget {
    return caloriesPercentage >= 90 && caloriesPercentage <= 110;
  }

  /// Проверяет, достигнута ли цель по белкам
  bool get isProteinOnTarget {
    return proteinPercentage >= 80;
  }

  /// Проверяет, достигнута ли цель по жирам
  bool get isFatsOnTarget {
    return fatsPercentage >= 20 && fatsPercentage <= 35;
  }

  /// Проверяет, достигнута ли цель по углеводам
  bool get isCarbsOnTarget {
    return carbsPercentage >= 45 && carbsPercentage <= 65;
  }

  double _normalizePercentage(double percentage, double target) {
    if (percentage >= target) return 100.0;
    return percentage;
  }
}
