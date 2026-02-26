import 'package:flutter/foundation.dart';

final ValueNotifier<int> nutritionMetricsRefresh = ValueNotifier<int>(0);

void notifyNutritionMetricsUpdated() {
  nutritionMetricsRefresh.value++;
}
