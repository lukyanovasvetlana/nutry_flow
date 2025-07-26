import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../../../../app.dart';

class MealDetailsScreen extends StatefulWidget {
  final String? mealId;
  final String? mealName;
  
  const MealDetailsScreen({
    super.key,
    this.mealId,
    this.mealName,
  });

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  bool isLoading = true;
  Map<String, dynamic>? mealData;

  @override
  void initState() {
    super.initState();
    _loadMealDetails();
  }

  Future<void> _loadMealDetails() async {
    // Симуляция загрузки данных
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      // Мок-данные для демонстрации
      mealData = {
        'name': widget.mealName ?? 'Здоровый завтрак',
        'calories': 450,
        'protein': 25,
        'carbs': 35,
        'fat': 15,
        'fiber': 8,
        'sugar': 12,
        'cookingTime': 25,
        'servings': 2,
        'difficulty': 'Средняя',
        'ingredients': [
          {'name': 'Овсяные хлопья', 'amount': '1 стакан'},
          {'name': 'Молоко', 'amount': '200 мл'},
          {'name': 'Банан', 'amount': '1 шт'},
          {'name': 'Мед', 'amount': '1 ст.л.'},
          {'name': 'Орехи грецкие', 'amount': '30 г'},
          {'name': 'Ягоды черники', 'amount': '50 г'},
        ],
        'instructions': [
          'Залейте овсяные хлопья молоком и оставьте на 5 минут',
          'Нарежьте банан кольцами',
          'Добавьте мед и перемешайте',
          'Измельчите орехи и добавьте к овсянке',
          'Украсьте ягодами черники',
          'Подавайте немедленно'
        ],
        'nutritionTips': [
          'Богат клетчаткой для улучшения пищеварения',
          'Содержит полезные жиры для работы мозга',
          'Источник медленных углеводов для энергии',
          'Антиоксиданты из ягод защищают клетки'
        ],
        'image': 'assets/images/healthy_breakfast.jpg',
      };
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F4F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Детали блюда',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // TODO: Добавить в избранное
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // TODO: Поделиться рецептом
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Изображение блюда
                  _buildMealImage(),
                  const SizedBox(height: 16),
                  
                  // Название и основная информация
                  _buildMealHeader(),
                  const SizedBox(height: 16),
                  
                  // Быстрая информация
                  _buildQuickInfo(),
                  const SizedBox(height: 24),
                  
                  // Пищевая ценность
                  _buildNutritionInfo(),
                  const SizedBox(height: 24),
                  
                  // Ингредиенты
                  _buildIngredients(),
                  const SizedBox(height: 24),
                  
                  // Инструкции по приготовлению
                  _buildInstructions(),
                  const SizedBox(height: 24),
                  
                  // Советы по питанию
                  _buildNutritionTips(),
                  const SizedBox(height: 24),
                  
                  // Кнопки действий
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildMealImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder для изображения
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.green.withOpacity(0.3),
                    AppColors.yellow.withOpacity(0.3),
                  ],
                ),
              ),
              child: const Icon(
                Icons.restaurant,
                size: 80,
                color: Colors.white,
              ),
            ),
            // Градиент для лучшей читаемости
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealData!['name'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRatingStars(),
            const SizedBox(width: 8),
            Text(
              '4.8 (127 отзывов)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < 4 ? Icons.star : Icons.star_border,
          color: AppColors.yellow,
          size: 16,
        );
      }),
    );
  }

  Widget _buildQuickInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            Icons.access_time,
            '${mealData!['cookingTime']} мин',
            'Время',
          ),
          _buildInfoItem(
            Icons.people,
            '${mealData!['servings']} порции',
            'Порций',
          ),
          _buildInfoItem(
            Icons.bar_chart,
            mealData!['difficulty'],
            'Сложность',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.green, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Пищевая ценность',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildNutritionRow('Калории', '${mealData!['calories']}', 'ккал', AppColors.orange),
              _buildNutritionRow('Белки', '${mealData!['protein']}', 'г', AppColors.green),
              _buildNutritionRow('Углеводы', '${mealData!['carbs']}', 'г', AppColors.yellow),
              _buildNutritionRow('Жиры', '${mealData!['fat']}', 'г', AppColors.orange),
              _buildNutritionRow('Клетчатка', '${mealData!['fiber']}', 'г', AppColors.green),
              _buildNutritionRow('Сахар', '${mealData!['sugar']}', 'г', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionRow(String label, String value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ингредиенты',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: (mealData!['ingredients'] as List).map<Widget>((ingredient) {
              return ListTile(
                leading: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(ingredient['name']),
                trailing: Text(
                  ingredient['amount'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Инструкции по приготовлению',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: (mealData!['instructions'] as List).asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              String instruction = entry.value;
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  instruction,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Полезные советы',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: (mealData!['nutritionTips'] as List).map<Widget>((tip) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Добавить в план питания
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Добавлено в план питания!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Добавить в план питания',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Добавить в список покупок
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ингредиенты добавлены в список покупок!')),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.button,
              side: BorderSide(color: AppColors.button),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Добавить в список покупок',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 