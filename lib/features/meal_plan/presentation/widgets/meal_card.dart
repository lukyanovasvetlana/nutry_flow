import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';

class MealCard extends StatelessWidget {
  final String type;
  final Color color;
  final String title;
  const MealCard(
      {required this.type,
      required this.color,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMealDetails(context);
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: context.shadow.withValues(alpha: 0.07), blurRadius: 2)
          ],
        ),
        child: Row(
          children: [
            // Изображение
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: context.surfaceVariant,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: Icon(Icons.image,
                  color: context.onSurfaceContainer, size: 32),
            ),
            // Контент
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Иконка стрелки
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                color: context.onSurfaceVariant,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: context.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.image, color: context.onPrimary, size: 64),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.onSurface),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Пищевая ценность',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.onSurface),
                      ),
                      SizedBox(height: 8),
                      _NutritionRow('Калории', '350 ккал'),
                      _NutritionRow('Белки', '25 г'),
                      _NutritionRow('Углеводы', '45 г'),
                      _NutritionRow('Жиры', '12 г'),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primary,
                            foregroundColor: context.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Закрыть'),
                        ),
                      ),
                    ],
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

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  const _NutritionRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.onSurfaceVariant)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: context.onSurface)),
        ],
      ),
    );
  }
}
