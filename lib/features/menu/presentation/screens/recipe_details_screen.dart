import 'package:flutter/material.dart';
import '../../data/models/menu_item.dart';
import '../../data/services/recipe_service.dart';
import '../../data/services/mock_recipe_service.dart';
import '../../../../config/supabase_config.dart';
import 'add_edit_recipe_screen.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final MenuItem recipe;
  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late MenuItem _recipe;
  late dynamic _recipeService;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    _initializeService();
  }

  void _initializeService() {
    if (SupabaseConfig.isDemo) {
      _recipeService = MockRecipeService();
    } else {
      _recipeService = RecipeService();
    }
  }

  void _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditRecipeScreen(recipe: _recipe)),
    );
    if (result == true) {
      // TODO: Обновить данные рецепта после редактирования
      setState(() {
        // Здесь можно либо перезагрузить с сервера, либо обновить локально
      });
    }
  }

  void _deleteRecipe() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить рецепт?'),
        content: const Text('Это действие нельзя будет отменить.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _recipeService.deleteRecipe(_recipe.id);
        Navigator.pop(
            context, true); // Возвращаемся с флагом для обновления списка
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото (карусель)
            if (_recipe.photos.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: _recipe.photos.length,
                  itemBuilder: (context, index) {
                    final photo = _recipe.photos[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        photo.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 48),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            // Название, категория, сложность
            Text(_recipe.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(_recipe.category)),
                const SizedBox(width: 8),
                Chip(label: Text('Сложность: ${_recipe.difficulty}')),
              ],
            ),
            const SizedBox(height: 16),
            // Описание
            Text(_recipe.description,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            // Ингредиенты
            Text('Ингредиенты', style: Theme.of(context).textTheme.titleLarge),
            ..._recipe.ingredients.map(
                (ing) => Text('• ${ing.name} - ${ing.amount} ${ing.unit}')),
            const SizedBox(height: 24),
            // Шаги
            Text('Шаги приготовления',
                style: Theme.of(context).textTheme.titleLarge),
            ..._recipe.steps.map((step) => ListTile(
                  leading: CircleAvatar(child: Text('${step.order}')),
                  title: Text(step.description),
                  subtitle: step.imageUrl != null
                      ? Image.network(step.imageUrl!)
                      : null,
                )),
            const SizedBox(height: 24),
            // Нутриенты
            Text('Нутриенты', style: Theme.of(context).textTheme.titleLarge),
            Text('Калории: ${_recipe.nutrition.calories} ккал'),
            Text('Белки: ${_recipe.nutrition.protein} г'),
            Text('Жиры: ${_recipe.nutrition.fat} г'),
            Text('Углеводы: ${_recipe.nutrition.carbs} г'),
            // TODO: Отобразить остальные нутриенты из nutrition_facts
          ],
        ),
      ),
    );
  }
}
