import 'package:flutter/material.dart';

class RecommendedMenuCard extends StatelessWidget {
  const RecommendedMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Recommended Menu'),
      ),
    );
  }
} 