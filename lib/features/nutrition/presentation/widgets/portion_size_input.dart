import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/food_item.dart';

class PortionSizeInput extends StatefulWidget {
  final FoodItem foodItem;
  final double initialPortion;
  final Function(double) onPortionChanged;

  const PortionSizeInput({
    super.key,
    required this.foodItem,
    required this.initialPortion,
    required this.onPortionChanged,
  });

  @override
  State<PortionSizeInput> createState() => _PortionSizeInputState();
}

class _PortionSizeInputState extends State<PortionSizeInput> {
  late TextEditingController _controller;
  late double _currentPortion;

  @override
  void initState() {
    super.initState();
    _currentPortion = widget.initialPortion;
    _controller = TextEditingController(text: _currentPortion.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePortion(double newPortion) {
    if (newPortion >= 1 && newPortion <= 10000) {
      setState(() {
        _currentPortion = newPortion;
        _controller.text = newPortion.toString();
      });
      widget.onPortionChanged(newPortion);
    }
  }

  void _onTextChanged(String value) {
    final portion = double.tryParse(value);
    if (portion != null && portion >= 1 && portion <= 10000) {
      setState(() {
        _currentPortion = portion;
      });
      widget.onPortionChanged(portion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Portion input field
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Граммы',
                  border: OutlineInputBorder(),
                  suffixText: 'г',
                ),
                onChanged: _onTextChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите размер порции';
                  }
                  final portion = double.tryParse(value);
                  if (portion == null || portion < 1 || portion > 10000) {
                    return 'Размер порции должен быть от 1 до 10000 г';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _updatePortion(_currentPortion + 10),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _updatePortion(_currentPortion - 10),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Portion slider
        Slider(
          value: _currentPortion.clamp(1, 1000),
          min: 1,
          max: 1000,
          divisions: 999,
          onChanged: _updatePortion,
        ),

        const SizedBox(height: 16),

        // Quick portion buttons
        Wrap(
          spacing: 8,
          children: [
            _buildQuickPortionButton(50, '50г'),
            _buildQuickPortionButton(100, '100г'),
            _buildQuickPortionButton(150, '150г'),
            _buildQuickPortionButton(200, '200г'),
            _buildQuickPortionButton(250, '250г'),
          ],
        ),

        const SizedBox(height: 16),

        // Nutrition preview for current portion
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutritionInfo(
                'Калории',
                '${widget.foodItem.calculateCalories(_currentPortion).toStringAsFixed(0)} ккал',
                Colors.orange,
              ),
              _buildNutritionInfo(
                'Белки',
                '${widget.foodItem.calculateProtein(_currentPortion).toStringAsFixed(1)} г',
                Colors.red,
              ),
              _buildNutritionInfo(
                'Жиры',
                '${widget.foodItem.calculateFats(_currentPortion).toStringAsFixed(1)} г',
                Colors.yellow[700]!,
              ),
              _buildNutritionInfo(
                'Углеводы',
                '${widget.foodItem.calculateCarbs(_currentPortion).toStringAsFixed(1)} г',
                Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPortionButton(double portion, String label) {
    final isSelected = _currentPortion == portion;

    return GestureDetector(
      onTap: () => _updatePortion(portion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
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
}
