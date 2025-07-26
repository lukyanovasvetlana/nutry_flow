import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';
import '../../../../app.dart';
import '../widgets/top_bar.dart';
import '../widgets/meal_type_toggle.dart';
import '../widgets/meal_plan_grid.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  String selectedMealType = 'Завтрак';

  void _onMealTypeChanged(String mealType) {
    setState(() {
      selectedMealType = mealType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'План питания',
          style: AppStyles.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(),
            MealTypeToggle(selectedMealType: selectedMealType, onMealTypeChanged: _onMealTypeChanged),
            Expanded(child: MealPlanGrid(selectedMealType: selectedMealType)),
          ],
        ),
      ),
    );
  }
} 