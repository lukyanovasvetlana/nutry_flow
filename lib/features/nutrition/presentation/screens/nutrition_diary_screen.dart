import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nutrition_diary_cubit.dart';
import '../widgets/daily_nutrition_summary.dart';
import '../widgets/meal_entries_list.dart';
import '../widgets/nutrition_charts.dart';
import '../../domain/entities/food_entry.dart';

class NutritionDiaryScreen extends StatefulWidget {
  final DateTime? initialDate;

  const NutritionDiaryScreen({
    super.key,
    this.initialDate,
  });

  @override
  State<NutritionDiaryScreen> createState() => _NutritionDiaryScreenState();
}

class _NutritionDiaryScreenState extends State<NutritionDiaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _selectedDate;
  MealType? _selectedMealType;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _tabController = TabController(length: 3, vsync: this);

    _loadDiaryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadDiaryData() {
    final userId = 'current_user_id'; // TODO: Get from auth service

    if (_selectedMealType != null) {
      context.read<NutritionDiaryCubit>().loadFilteredDiary(
            userId,
            _selectedDate,
            _selectedDate,
            mealType: _selectedMealType,
          );
    } else {
      context.read<NutritionDiaryCubit>().loadDailyDiary(userId, _selectedDate);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      _loadDiaryData();
    }
  }

  void _onMealTypeFilterChanged(MealType? mealType) {
    setState(() {
      _selectedMealType = mealType;
    });
    _loadDiaryData();
  }

  void _onAddFoodEntry() {
    Navigator.pushNamed(
      context,
      '/nutrition/search',
    ).then((result) {
      if (result == true) {
        _loadDiaryData();
      }
    });
  }

  void _onEditFoodEntry(FoodEntry entry) {
    Navigator.pushNamed(
      context,
      '/nutrition/edit-entry',
      arguments: entry,
    ).then((result) {
      if (result == true) {
        _loadDiaryData();
      }
    });
  }

  void _onDeleteFoodEntry(FoodEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить запись'),
        content: Text('Вы уверены, что хотите удалить "${entry.foodName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Запись удалена'),
                  backgroundColor: Colors.green,
                ),
              );
              _loadDiaryData();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Дневник питания'),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selectDate,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddFoodEntry,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'День'),
            Tab(text: 'Неделя'),
            Tab(text: 'Месяц'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate =
                          _selectedDate.subtract(const Duration(days: 1));
                    });
                    _loadDiaryData();
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final tomorrow = _selectedDate.add(const Duration(days: 1));
                    if (tomorrow.isBefore(
                        DateTime.now().add(const Duration(days: 1)))) {
                      setState(() {
                        _selectedDate = tomorrow;
                      });
                      _loadDiaryData();
                    }
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDailyTab(),
                _buildWeeklyTab(),
                _buildMonthlyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTab() {
    return BlocBuilder<NutritionDiaryCubit, NutritionDiaryState>(
      builder: (context, state) {
        if (state is NutritionDiaryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NutritionDiarySuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Daily summary
                DailyNutritionSummary(
                  summary: state.diary.summary,
                  onMealTypeFilterChanged: _onMealTypeFilterChanged,
                  selectedMealType: _selectedMealType,
                ),

                const SizedBox(height: 24),

                // Meal entries
                MealEntriesList(
                  entries: state.diary.entries,
                  mealType: MealType
                      .breakfast, // Default meal type, should be dynamic
                  onEdit: _onEditFoodEntry,
                  onDelete: _onDeleteFoodEntry,
                ),
              ],
            ),
          );
        }

        if (state is NutritionDiaryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadDiaryData,
                  child: const Text('Повторить'),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('Выберите дату для просмотра дневника'),
        );
      },
    );
  }

  Widget _buildWeeklyTab() {
    return BlocBuilder<NutritionDiaryCubit, NutritionDiaryState>(
      builder: (context, state) {
        if (state is NutritionDiaryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NutritionDiaryRangeSuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Weekly charts
                NutritionCharts(
                  diaries: state.diaries,
                  chartType: ChartType.weekly,
                ),

                const SizedBox(height: 24),

                // Weekly summary
                Text(
                  'Недельная сводка',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // TODO: Add weekly summary widget
              ],
            ),
          );
        }

        if (state is NutritionDiaryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Load weekly data
                  },
                  child: const Text('Повторить'),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('Недельные данные не найдены'),
        );
      },
    );
  }

  Widget _buildMonthlyTab() {
    return BlocBuilder<NutritionDiaryCubit, NutritionDiaryState>(
      builder: (context, state) {
        if (state is NutritionDiaryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NutritionDiaryRangeSuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Monthly charts
                NutritionCharts(
                  diaries: state.diaries,
                  chartType: ChartType.monthly,
                ),

                const SizedBox(height: 24),

                // Monthly summary
                Text(
                  'Месячная сводка',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // TODO: Add monthly summary widget
              ],
            ),
          );
        }

        if (state is NutritionDiaryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Load monthly data
                  },
                  child: const Text('Повторить'),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('Месячные данные не найдены'),
        );
      },
    );
  }
}
