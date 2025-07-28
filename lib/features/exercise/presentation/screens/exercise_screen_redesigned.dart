import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';
import '../../data/services/exercise_service.dart';
import '../widgets/simple_exercise_card.dart';

import '../../../../shared/design/tokens/design_tokens.dart';

class ExerciseScreenRedesigned extends StatefulWidget {
  const ExerciseScreenRedesigned({Key? key}) : super(key: key);

  @override
  State<ExerciseScreenRedesigned> createState() => _ExerciseScreenRedesignedState();
}

class _ExerciseScreenRedesignedState extends State<ExerciseScreenRedesigned> 
    with TickerProviderStateMixin {
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  

  late AnimationController _listAnimationController;
  late Animation<double> _listAnimation;
  
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadExercises();
    _initializeAnimations();
  }

  void _initializeAnimations() {

    
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _listAnimation = CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeOutQuart,
    );
    
    _listAnimationController.forward();
  }

  @override
  void dispose() {

    _listAnimationController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  void _loadExercises() {
    _exercises = ExerciseService.getAllExercises();
    _applyFilters();
  }

  void _applyFilters() {
    List<Exercise> filtered = _exercises;

    if (_searchQuery.isNotEmpty) {
      filtered = ExerciseService.searchExercises(_searchQuery);
    }

    if (_selectedCategory != 'All') {
      filtered = filtered.where((exercise) => exercise.category == _selectedCategory).toList();
    }

    if (_selectedDifficulty != 'All') {
      filtered = filtered.where((exercise) => exercise.difficulty == _selectedDifficulty).toList();
    }

    setState(() {
      _filteredExercises = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }



  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              'Фильтры',
              style: context.typography.headlineSmallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            
            // Category filter
            _buildFilterSection(
              title: 'Категория',
              value: _selectedCategory,
              options: ExerciseService.getCategories(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Difficulty filter
            _buildFilterSection(
              title: 'Сложность',
              value: _selectedDifficulty,
              options: ExerciseService.getDifficulties(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value;
                });
              },
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _selectedDifficulty = 'All';
                      });
                      _applyFilters();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: context.colors.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Сбросить',
                      style: context.typography.bodyLargeStyle.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _applyFilters();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Применить',
                      style: context.typography.bodyLargeStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.typography.bodyLargeStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.outline),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: context.colors.onSurface),
            items: options.map((String option) {
              String displayText = _getDisplayText(option);
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  displayText,
                  style: context.typography.bodyMediumStyle.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  String _getDisplayText(String value) {
    switch (value) {
      case 'All':
        return 'Все';
      case 'Beginner':
        return 'Начинающий';
      case 'Intermediate':
        return 'Средний';
      case 'Advanced':
        return 'Продвинутый';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search section
            _buildSearchSection(),
            
            // Filters and actions
            _buildFiltersSection(),
            
            // Table header
            _buildTableHeader(),
            
            // Exercise list
            Expanded(
              child: _buildExerciseList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(
              Icons.arrow_back,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Упражнения',
              style: context.typography.headlineMediumStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.onBackground,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.outline),
            ),
            child: Icon(
              Icons.more_horiz,
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          // Fixed search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.outline),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: context.colors.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Поиск упражнений...',
                      hintStyle: context.typography.bodyMediumStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: context.typography.bodyMediumStyle.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                    child: Icon(
                      Icons.clear,
                      color: context.colors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          // Filter button
          Expanded(
            child: GestureDetector(
              onTap: _showFilterBottomSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.tune,
                      color: context.colors.onSurface,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                                          Flexible(
                        child: Text(
                          'Фильтры',
                          style: context.typography.bodySmallStyle.copyWith(
                            color: context.colors.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Add exercise button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                // Handle add exercise
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary,
                      context.colors.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: context.colors.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                                          Flexible(
                        child: Text(
                          'Добавить',
                          style: context.typography.bodySmallStyle.copyWith(
                            color: context.colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 70), // Space for category indicator and icon
          Expanded(
            child: Text(
              'Упражнения',
              style: context.typography.headlineSmallStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.onSurface,
              ),
            ),
          ),
          Text(
            '${_filteredExercises.length} найдено',
            style: context.typography.bodyMediumStyle.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return AnimatedBuilder(
      animation: _listAnimation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: _filteredExercises.length,
          itemBuilder: (context, index) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _listAnimation,
                curve: Interval(
                  (index * 0.1).clamp(0.0, 1.0),
                  ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                  curve: Curves.easeOutQuart,
                ),
              )),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _listAnimation,
                  curve: Interval(
                    (index * 0.1).clamp(0.0, 1.0),
                    ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
                child: SimpleExerciseCard(
                  exercise: _filteredExercises[index],
                  onTap: () {
                    // Navigate to exercise details
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
} 