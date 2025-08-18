import 'package:flutter/material.dart';

class StepsCard extends StatelessWidget {
  const StepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Шаги'),
      ),
    );
  }
}
