import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';
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
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'План питания',
          style: AppStyles.headlineMedium.copyWith(color: context.onSurface),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(),
            MealTypeToggle(
                selectedMealType: selectedMealType,
                onMealTypeChanged: _onMealTypeChanged),
            Expanded(child: MealPlanGrid(selectedMealType: selectedMealType)),
          ],
        ),
      ),
    );
  }
}
