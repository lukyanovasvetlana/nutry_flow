import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/exercise_bloc.dart';
import '../widgets/exercise_card.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class ExerciseCatalogScreen extends StatefulWidget {
  final String? initialCategory;
  
  const ExerciseCatalogScreen({
    Key? key,
    this.initialCategory,
  }) : super(key: key);

  @override
  State<ExerciseCatalogScreen> createState() => _ExerciseCatalogScreenState();
}

class _ExerciseCatalogScreenState extends State<ExerciseCatalogScreen>
    with TickerProviderStateMixin {
  late ExerciseBloc _exerciseBloc;
  late AnimationController _listAnimationController;
  late Animation<double> _listAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _exerciseBloc = GetIt.instance.get<ExerciseBloc>();
    _initializeAnimations();
    
    if (widget.initialCategory != null) {
      _exerciseBloc.add(FilterByCategory(widget.initialCategory!));
    } else {
      _exerciseBloc.add(LoadExercises());
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          'Упражнения',
          style: context.typography.headlineSmallStyle.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: context.colors.onSurface,
            ),
            onPressed: () {
              // TODO: Navigate to favorites
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _exerciseBloc,
        child: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ExerciseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки',
                      style: context.typography.headlineSmallStyle.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: context.typography.bodyMediumStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _exerciseBloc.add(LoadExercises());
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            if (state is ExerciseLoaded) {
              return Column(
                children: [
                  _buildSearchBar(),
                  _buildFilterChips(state),
                  Expanded(
                    child: _buildExerciseList(state.exercises),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Поиск упражнений...',
          prefixIcon: Icon(
            Icons.search,
            color: context.colors.onSurfaceVariant,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.colors.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _exerciseBloc.add(LoadExercises());
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.colors.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.colors.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.colors.primary),
          ),
          filled: true,
          fillColor: context.colors.surfaceVariant,
        ),
        onChanged: (query) {
          if (query.isEmpty) {
            _exerciseBloc.add(LoadExercises());
          } else {
            _exerciseBloc.add(SearchExercises(query));
          }
        },
      ),
    );
  }

  Widget _buildFilterChips(ExerciseLoaded state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Category filter
          if (state.categories.isNotEmpty) ...[
            Text(
              'Категория:',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            ...state.categories.map((category) {
              final isSelected = state.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _exerciseBloc.add(FilterByCategory(category));
                    } else {
                      _exerciseBloc.add(LoadExercises());
                    }
                  },
                  selectedColor: context.colors.primaryLight,
                  checkmarkColor: context.colors.onPrimary,
                  backgroundColor: context.colors.surfaceVariant,
                  side: BorderSide(color: context.colors.outline),
                ),
              );
            }).toList(),
            const SizedBox(width: 16),
          ],
          
          // Difficulty filter
          if (state.difficulties.isNotEmpty) ...[
            Text(
              'Сложность:',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            ...state.difficulties.map((difficulty) {
              final isSelected = state.selectedDifficulty == difficulty;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(difficulty),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _exerciseBloc.add(FilterByDifficulty(difficulty));
                    } else {
                      _exerciseBloc.add(LoadExercises());
                    }
                  },
                  backgroundColor: context.colors.surfaceVariant,
                  selectedColor: context.colors.primaryLight,
                  labelStyle: context.typography.bodyMediumStyle.copyWith(
                    color: isSelected 
                        ? context.colors.onPrimary 
                        : context.colors.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildExerciseList(List<dynamic> exercises) {
    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Упражнения не найдены',
              style: context.typography.headlineSmallStyle.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить фильтры или поисковый запрос',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _listAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ExerciseCard(
              exercise: exercise,
              onTap: () {
                // TODO: Navigate to exercise details
              },
              onFavoriteToggle: () {
                // TODO: Toggle favorite
              },
            ),
          );
        },
      ),
    );
  }
} 