import 'package:flutter/material.dart';
import '../../data/models/menu_item.dart';
import '../../data/services/recipe_service.dart';
import '../../data/services/mock_recipe_service.dart';
import '../widgets/menu_item_card.dart';
import 'add_edit_recipe_screen.dart';
import '../../../../app.dart';
import '../../../../config/supabase_config.dart';

class HealthyMenuScreen extends StatefulWidget {
  const HealthyMenuScreen({super.key});

  @override
  State<HealthyMenuScreen> createState() => _HealthyMenuScreenState();
}

class _HealthyMenuScreenState extends State<HealthyMenuScreen> {
  late dynamic _recipeService;
  late Future<List<MenuItem>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _loadRecipes();
  }

  void _initializeService() {
    if (SupabaseConfig.isDemo) {
      _recipeService = MockRecipeService();
    } else {
      _recipeService = RecipeService();
    }
  }

  void _loadRecipes() {
    setState(() {
      _recipesFuture = _recipeService.getAllRecipes();
    });
  }

  void _navigateToAddRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditRecipeScreen()),
    );
    // Если с экрана добавления вернулись с результатом, перезагружаем список
    if (result == true) {
      _loadRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Рецептов пока нет. Добавьте первый!'));
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return MenuItemCard(recipe: recipes[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
