import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/food_entry_cubit.dart';
import '../widgets/food_item_card.dart';
import '../widgets/meal_type_selector.dart';
import '../widgets/portion_size_input.dart';
import '../widgets/nutrition_preview.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_entry.dart';

class AddFoodEntryScreen extends StatefulWidget {
  final FoodItem foodItem;
  final MealType? initialMealType;
  final DateTime? initialDate;

  const AddFoodEntryScreen({
    Key? key,
    required this.foodItem,
    this.initialMealType,
    this.initialDate,
  }) : super(key: key);

  @override
  State<AddFoodEntryScreen> createState() => _AddFoodEntryScreenState();
}

class _AddFoodEntryScreenState extends State<AddFoodEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _portionController = TextEditingController();
  final _notesController = TextEditingController();

  late MealType _selectedMealType;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  double _portionSize = 100.0;

  @override
  void initState() {
    super.initState();
    
    _selectedMealType = widget.initialMealType ?? _getCurrentMealType();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedTime = TimeOfDay.now();
    
    _portionController.text = _portionSize.toString();
  }

  @override
  void dispose() {
    _portionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  MealType _getCurrentMealType() {
    final now = TimeOfDay.now();
    final hour = now.hour;
    
    if (hour < 11) return MealType.breakfast;
    if (hour < 16) return MealType.lunch;
    if (hour < 20) return MealType.dinner;
    return MealType.snack;
  }

  void _onPortionChanged(double portion) {
    setState(() {
      _portionSize = portion;
      _portionController.text = portion.toString();
    });
  }

  void _onMealTypeChanged(MealType mealType) {
    setState(() {
      _selectedMealType = mealType;
    });
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _addFoodEntry() {
    if (!_formKey.currentState!.validate()) return;

    final consumedAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    context.read<FoodEntryCubit>().addFoodEntry(
      userId: 'current_user_id',
      foodItem: widget.foodItem,
      grams: _portionSize,
      mealType: _selectedMealType,
      consumedAt: consumedAt,
      notes: _notesController.text.trim().isNotEmpty 
          ? _notesController.text.trim() 
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить приём пищи'),
        actions: [
          BlocConsumer<FoodEntryCubit, FoodEntryState>(
            listener: (context, state) {
              if (state is FoodEntrySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Приём пищи добавлен'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true);
              }
              
              if (state is FoodEntryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is FoodEntryLoading ? null : _addFoodEntry,
                child: state is FoodEntryLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Добавить'),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food item card
              FoodItemCard(
                foodItem: widget.foodItem,
                showActions: false,
              ),
              
              const SizedBox(height: 24),
              
              // Meal type selector
              Text(
                'Тип приёма пищи',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              MealTypeSelector(
                selectedMealType: _selectedMealType,
                onMealTypeChanged: _onMealTypeChanged,
              ),
              
              const SizedBox(height: 24),
              
              // Portion size input
              Text(
                'Размер порции',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              PortionSizeInput(
                foodItem: widget.foodItem,
                initialPortion: _portionSize,
                onPortionChanged: _onPortionChanged,
              ),
              
              const SizedBox(height: 24),
              
              // Date and time selection
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Дата',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8),
                                Text(
                                  '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Время',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(width: 8),
                                Text(
                                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Notes input
              Text(
                'Заметки (необязательно)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Добавьте заметки о приёме пищи...',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Nutrition preview
              Text(
                'Пищевая ценность',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              NutritionPreview(
                foodItem: widget.foodItem,
                portionSize: _portionSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 