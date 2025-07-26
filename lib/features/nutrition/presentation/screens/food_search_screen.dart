import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nutrition_search_cubit.dart';
import '../widgets/food_search_bar.dart';
import '../widgets/food_search_results.dart';
import '../widgets/food_categories_grid.dart';
import '../widgets/popular_foods_section.dart';
import '../widgets/barcode_scanner_button.dart';
import '../../domain/entities/food_item.dart';

class FoodSearchScreen extends StatefulWidget {
  final Function(FoodItem)? onFoodItemSelected;
  final String? initialQuery;

  const FoodSearchScreen({
    super.key,
    this.onFoodItemSelected,
    this.initialQuery,
  });

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    } else {
      _loadPopularItems();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<NutritionSearchCubit>().searchFoodItems(query);
    } else {
      context.read<NutritionSearchCubit>().clearSearch();
    }
  }

  void _loadPopularItems() {
    context.read<NutritionSearchCubit>().getPopularItems();
  }

  void _loadFavoriteItems() {
    // TODO: Get user ID from auth service
    const userId = 'current_user_id';
    context.read<NutritionSearchCubit>().getFavoriteItems(userId);
  }

  void _loadRecommendedItems() {
    // TODO: Get user ID from auth service
    const userId = 'current_user_id';
    context.read<NutritionSearchCubit>().getRecommendedItems(userId);
  }

  void _onBarcodeScanned(String barcode) {
    context.read<NutritionSearchCubit>().searchByBarcode(barcode);
  }

  void _onFoodItemSelected(FoodItem foodItem) {
    if (widget.onFoodItemSelected != null) {
      widget.onFoodItemSelected!(foodItem);
    } else {
      // Navigate to food entry screen
      Navigator.pushNamed(
        context,
        '/nutrition/add-entry',
        arguments: foodItem,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск продуктов'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Поиск'),
            Tab(text: 'Популярные'),
            Tab(text: 'Избранные'),
            Tab(text: 'Рекомендации'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                if (_searchController.text.isEmpty) {
                  context.read<NutritionSearchCubit>().clearSearch();
                }
                break;
              case 1:
                _loadPopularItems();
                break;
              case 2:
                _loadFavoriteItems();
                break;
              case 3:
                _loadRecommendedItems();
                break;
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FoodSearchBar(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _performSearch,
                    onSubmitted: _performSearch,
                  ),
                ),
                const SizedBox(width: 12),
                BarcodeScannerButton(
                  onBarcodeScanned: _onBarcodeScanned,
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Search tab
                _buildSearchTab(),
                
                // Popular tab
                _buildContentTab(),
                
                // Favorites tab
                _buildContentTab(),
                
                // Recommendations tab
                _buildContentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return BlocBuilder<NutritionSearchCubit, NutritionSearchState>(
      builder: (context, state) {
        if (state is NutritionSearchInitial) {
          return _buildInitialContent();
        }
        
        return _buildContentTab();
      },
    );
  }

  Widget _buildContentTab() {
    return BlocBuilder<NutritionSearchCubit, NutritionSearchState>(
      builder: (context, state) {
        if (state is NutritionSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NutritionSearchSuccess) {
          return FoodSearchResults(
            foodItems: state.foodItems,
            onFoodItemSelected: _onFoodItemSelected,
          );
        }

        if (state is NutritionSearchEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is NutritionSearchError) {
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
                    final currentTab = _tabController.index;
                    switch (currentTab) {
                      case 1:
                        _loadPopularItems();
                        break;
                      case 2:
                        _loadFavoriteItems();
                        break;
                      case 3:
                        _loadRecommendedItems();
                        break;
                      default:
                        if (_searchController.text.isNotEmpty) {
                          _performSearch(_searchController.text);
                        }
                    }
                  },
                  child: const Text('Повторить'),
                ),
              ],
            ),
          );
        }

        return _buildInitialContent();
      },
    );
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories section
          Text(
            'Категории',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          FoodCategoriesGrid(
            onCategorySelected: (category) {
              context.read<NutritionSearchCubit>().getFoodItemsByCategory(category);
            },
          ),
          
          const SizedBox(height: 32),
          
          // Popular foods section
          Text(
            'Популярные продукты',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          PopularFoodsSection(
            onFoodItemSelected: _onFoodItemSelected,
          ),
        ],
      ),
    );
  }
} 