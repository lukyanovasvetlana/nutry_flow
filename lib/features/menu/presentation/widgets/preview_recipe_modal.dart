import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/ingredient.dart';
import '../../data/models/recipe_step.dart';
import '../../data/models/recipe_photo.dart';
import '../../data/models/nutrition_facts.dart';

class PreviewRecipeModal extends StatelessWidget {
  final String title;
  final String description;
  final String? category;
  final String? difficulty;
  final List<RecipePhoto> photos;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final NutritionFacts? nutritionFacts;

  const PreviewRecipeModal({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.photos,
    required this.ingredients,
    required this.steps,
    required this.nutritionFacts,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Фото (первое)
              if (photos.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: photos.first.file != null
                      ? Image.file(photos.first.file!, height: 180, width: double.infinity, fit: BoxFit.cover)
                      : (photos.first.url != null
                          ? Image.network(photos.first.url!, height: 180, width: double.infinity, fit: BoxFit.cover)
                          : const SizedBox(height: 180)),
                ),
              const SizedBox(height: 16),
              // Название и категория
              Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              if (category != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Chip(label: Text(category!)),
                ),
              if (difficulty != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Chip(label: Text('Сложность: $difficulty')),
                ),
              const SizedBox(height: 12),
              // Описание
              if (description.isNotEmpty)
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              // Ингредиенты
              Text('Ингредиенты', style: Theme.of(context).textTheme.titleMedium),
              ...ingredients.map((ing) => Text('• ${ing.name} — ${ing.amount} ${ing.unit}')),
              const SizedBox(height: 16),
              // Шаги
              Text('Шаги приготовления', style: Theme.of(context).textTheme.titleMedium),
              ...steps.map((step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 12, child: Text('${step.order}')),
                        const SizedBox(width: 8),
                        Expanded(child: Text(step.description)),
                        if (step.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Image.file(File(step.imageUrl!), width: 40, height: 40, fit: BoxFit.cover),
                          ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              // Нутриенты
              if (nutritionFacts != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Нутриенты (на порцию):', style: Theme.of(context).textTheme.titleMedium),
                    Text('Калории: ${nutritionFacts!.calories} ккал'),
                    Text('Белки: ${nutritionFacts!.protein} г'),
                    Text('Жиры: ${nutritionFacts!.fat} г'),
                    Text('Углеводы: ${nutritionFacts!.carbs} г'),
                  ],
                ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 