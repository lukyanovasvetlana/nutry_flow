import 'package:flutter/material.dart';
import 'exercise_screen_redesigned.dart';
import 'exercise_screen.dart';

class ExerciseShowcase extends StatefulWidget {
  const ExerciseShowcase({super.key});

  @override
  State<ExerciseShowcase> createState() => _ExerciseShowcaseState();
}

class _ExerciseShowcaseState extends State<ExerciseShowcase> {
  bool _showNewDesign = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showNewDesign
          ? const ExerciseScreenRedesigned()
          : const ExerciseScreen(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _showNewDesign = !_showNewDesign;
          });
        },
        icon: Icon(_showNewDesign ? Icons.visibility_off : Icons.visibility),
        label: Text(_showNewDesign ? 'Старый дизайн' : 'Новый дизайн'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
