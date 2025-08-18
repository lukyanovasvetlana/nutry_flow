import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../../data/models/ingredient.dart';
import '../../data/models/recipe_step.dart';
import '../../data/models/recipe_photo.dart';
import '../../data/models/nutrition_facts.dart';
import '../../data/models/menu_item.dart';
import '../widgets/ingredient_dialog.dart';
import '../widgets/step_dialog.dart';
import '../widgets/photos_carousel.dart';
import '../widgets/preview_recipe_modal.dart';
import 'package:nutry_flow/features/menu/data/services/recipe_service.dart';
import 'package:nutry_flow/features/menu/data/services/mock_recipe_service.dart';
import 'package:nutry_flow/config/supabase_config.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final MenuItem? recipe;
  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedDifficulty;
  List<RecipePhoto> _photos = [];
  final List<String> _photosToDelete = [];
  List<Ingredient> _ingredients = [];
  List<RecipeStep> _steps = [];
  NutritionFacts? _nutritionFacts;
  late dynamic _recipeService;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
    if (widget.recipe != null) {
      final recipe = widget.recipe!;
      _titleController.text = recipe.title;
      _descriptionController.text = recipe.description;
      _selectedCategory = recipe.category;
      _selectedDifficulty = recipe.difficulty;
      _photos = List.from(recipe.photos);
      _ingredients = List.from(recipe.ingredients);
      _steps = List.from(recipe.steps);
      _nutritionFacts = recipe.nutrition;
    }
  }

  void _initializeService() {
    if (SupabaseConfig.isDemo) {
      _recipeService = MockRecipeService();
    } else {
      _recipeService = RecipeService();
    }
  }

  void _addPhoto() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите фото'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColors.green),
                title: const Text('Галерея'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.green),
                title: const Text('Камера'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _photos.add(RecipePhoto(
            id: const Uuid().v4(),
            file: File(image.path),
            url: '',
            order: _photos.length + 1,
            recipeId: 'temp',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при выборе фото: $e')),
      );
    }
  }

  void _addIngredient() async {
    showDialog(
      context: context,
      builder: (context) => IngredientDialog(
        onSave: (ingredient) {
          setState(() {
            _ingredients.add(ingredient);
            _calculateNutrition();
          });
        },
      ),
    );
  }

  void _addStep() async {
    showDialog(
      context: context,
      builder: (context) => StepDialog(
        onSave: (step) {
          setState(() {
            _steps.add(step);
          });
        },
      ),
    );
  }

  void _calculateNutrition() {
    if (_ingredients.isEmpty) {
      setState(() => _nutritionFacts = null);
      return;
    }
    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;
    for (final ing in _ingredients) {
      // нутриенты на 100г, amount — в тех же единицах, что и нутриенты (г)
      final multiplier = ing.amount / 100.0;
      totalCalories += ing.nutritionPer100g.calories * multiplier;
      totalProtein += ing.nutritionPer100g.protein * multiplier;
      totalFat += ing.nutritionPer100g.fat * multiplier;
      totalCarbs += ing.nutritionPer100g.carbs * multiplier;
    }
    setState(() {
      _nutritionFacts = NutritionFacts(
        calories: totalCalories,
        protein: totalProtein,
        fat: totalFat,
        carbs: totalCarbs,
        fiber: 0,
        sodium: 0,
        cholesterol: 0,
        sugar: 0,
        vitaminC: 0,
      );
    });
  }

  void _showPreview() {
    showDialog(
      context: context,
      builder: (context) => PreviewRecipeModal(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? 'Завтрак',
        difficulty: _selectedDifficulty ?? 'Легко',
        photos: _photos,
        ingredients: _ingredients,
        steps: _steps,
        nutritionFacts: _nutritionFacts,
      ),
    );
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate() &&
        _photos.isNotEmpty &&
        _ingredients.isNotEmpty &&
        _steps.isNotEmpty) {
      setState(() => _isLoading = true);

      try {
        final menuItem = MenuItem(
          id: widget.recipe?.id ?? const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory!,
          difficulty: _selectedDifficulty!,
          photos: _photos,
          ingredients: _ingredients,
          steps: _steps,
          nutrition: _nutritionFacts!,
        );

        if (widget.recipe == null) {
          // Создание нового рецепта
          final photoFiles =
              _photos.where((p) => p.file != null).map((p) => p.file!).toList();
          await _recipeService.saveRecipe(menuItem, photoFiles);
        } else {
          // Обновление существующего
          final newPhotoFiles =
              _photos.where((p) => p.file != null).map((p) => p.file!).toList();
          await _recipeService.updateRecipe(menuItem,
              newPhotos: newPhotoFiles, photosToDelete: _photosToDelete);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Рецепт успешно ${widget.recipe == null ? 'сохранён' : 'обновлён'}!')),
        );
        Navigator.pop(context, true); // Возвращаем true для обновления списка
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Пожалуйста, заполните все поля и добавьте фото, ингредиенты и шаги')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.recipe == null ? 'Добавить рецепт' : 'Редактировать рецепт'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: _showPreview,
            tooltip: 'Предпросмотр',
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Фото
                Text('Фото блюда',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                PhotosCarousel(
                  photos: _photos,
                  onAddPhoto: _addPhoto,
                ),
                const SizedBox(height: 16),
                // Название
                TextFormField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(labelText: 'Название блюда'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Введите название'
                      : null,
                ),
                const SizedBox(height: 16),
                // Описание
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                // Категория
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: ['Завтрак', 'Обед', 'Перекус', 'Ужин']
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  decoration: const InputDecoration(labelText: 'Категория'),
                  validator: (value) =>
                      value == null ? 'Выберите категорию' : null,
                ),
                const SizedBox(height: 16),
                // Сложность
                DropdownButtonFormField<String>(
                  value: _selectedDifficulty,
                  items: ['Легко', 'Средне', 'Сложно']
                      .map((dif) =>
                          DropdownMenuItem(value: dif, child: Text(dif)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedDifficulty = val),
                  decoration: const InputDecoration(labelText: 'Сложность'),
                  validator: (value) =>
                      value == null ? 'Выберите сложность' : null,
                ),
                const SizedBox(height: 24),
                // Ингредиенты
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ингредиенты',
                        style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addIngredient,
                    ),
                  ],
                ),
                ..._ingredients.map((ing) => ListTile(
                      title: Text('${ing.name} — ${ing.amount} ${ing.unit}'),
                    )),
                const SizedBox(height: 24),
                // Шаги
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Шаги приготовления',
                        style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addStep,
                    ),
                  ],
                ),
                ..._steps.map((step) => ListTile(
                      leading: CircleAvatar(child: Text('${step.order}')),
                      title: Text(step.description),
                    )),
                const SizedBox(height: 24),
                // Автоматический расчет нутриентов
                Text('Нутриенты (рассчитаны автоматически)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _nutritionFacts == null
                    ? const Text('Добавьте ингредиенты для расчета')
                    : Text(
                        'Калории: ${_nutritionFacts!.calories} ккал, Белки: ${_nutritionFacts!.protein} г, Жиры: ${_nutritionFacts!.fat} г, Углеводы: ${_nutritionFacts!.carbs} г'),
                const SizedBox(height: 32),
                // Кнопка сохранить
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveRecipe,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Сохранить'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
