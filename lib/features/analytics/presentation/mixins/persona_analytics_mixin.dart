import 'package:flutter/material.dart';
import 'package:nutry_flow/features/analytics/presentation/utils/persona_analytics_tracker.dart';
import 'package:nutry_flow/features/profile/domain/entities/user_profile.dart';

/// Миксин для интеграции персоны аналитика в виджеты
mixin PersonaAnalyticsMixin<T extends StatefulWidget> on State<T> {
  /// Отслеживание просмотра экрана
  void trackScreenView({
    String? screenName,
    String? screenClass,
    Map<String, dynamic>? additionalData,
  }) {
    final name = screenName ?? widget.runtimeType.toString();
    final className = screenClass ?? runtimeType.toString();

    PersonaAnalyticsTracker.instance.trackScreenView(
      screenName: name,
      screenClass: className,
      additionalData: additionalData,
    );
  }

  /// Отслеживание нажатия кнопки
  void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) {
    final screen = screenName ?? widget.runtimeType.toString();

    PersonaAnalyticsTracker.instance.trackButtonClick(
      buttonName: buttonName,
      screenName: screen,
      additionalData: additionalData,
    );
  }

  /// Отслеживание поиска
  void trackSearch({
    required String searchTerm,
    required String searchCategory,
    Map<String, dynamic>? additionalData,
  }) {
    PersonaAnalyticsTracker.instance.trackSearch(
      searchTerm: searchTerm,
      searchCategory: searchCategory,
      additionalData: additionalData,
    );
  }

  /// Отслеживание выбора элемента
  void trackItemSelection({
    required String itemType,
    required String itemId,
    required String itemName,
    Map<String, dynamic>? additionalData,
  }) {
    PersonaAnalyticsTracker.instance.trackItemSelection(
      itemType: itemType,
      itemId: itemId,
      itemName: itemName,
      additionalData: additionalData,
    );
  }

  /// Отслеживание прогресса цели
  void trackGoalProgress({
    required String goalType,
    required double currentValue,
    required double targetValue,
  }) {
    PersonaAnalyticsTracker.instance.trackGoalProgress(
      goalType: goalType,
      currentValue: currentValue,
      targetValue: targetValue,
    );
  }

  /// Отслеживание использования функции
  void trackFeatureUsage({
    required String featureName,
    required String action,
    Map<String, dynamic>? parameters,
  }) {
    PersonaAnalyticsTracker.instance.trackFeatureUsage(
      featureName: featureName,
      action: action,
      parameters: parameters,
    );
  }

  /// Отслеживание сессии пользователя
  void trackUserSession({
    required String sessionType,
    required int durationMinutes,
    Map<String, dynamic>? additionalData,
  }) {
    PersonaAnalyticsTracker.instance.trackUserSession(
      sessionType: sessionType,
      durationMinutes: durationMinutes,
      additionalData: additionalData,
    );
  }

  /// Создание виджета с отслеживанием нажатий
  Widget createTrackedButton({
    required String buttonName,
    required Widget child,
    required VoidCallback onPressed,
    String? screenName,
    Map<String, dynamic>? additionalData,
  }) {
    return GestureDetector(
      onTap: () {
        trackButtonClick(
          buttonName: buttonName,
          screenName: screenName,
          additionalData: additionalData,
        );
        onPressed();
      },
      child: child,
    );
  }

  /// Создание кнопки с отслеживанием
  Widget createTrackedElevatedButton({
    required String buttonName,
    required String text,
    required VoidCallback onPressed,
    String? screenName,
    Map<String, dynamic>? additionalData,
    ButtonStyle? style,
  }) {
    return ElevatedButton(
      onPressed: () {
        trackButtonClick(
          buttonName: buttonName,
          screenName: screenName,
          additionalData: additionalData,
        );
        onPressed();
      },
      style: style,
      child: Text(text),
    );
  }

  /// Создание текстовой кнопки с отслеживанием
  Widget createTrackedTextButton({
    required String buttonName,
    required String text,
    required VoidCallback onPressed,
    String? screenName,
    Map<String, dynamic>? additionalData,
    ButtonStyle? style,
  }) {
    return TextButton(
      onPressed: () {
        trackButtonClick(
          buttonName: buttonName,
          screenName: screenName,
          additionalData: additionalData,
        );
        onPressed();
      },
      style: style,
      child: Text(text),
    );
  }

  /// Создание иконки с отслеживанием
  Widget createTrackedIconButton({
    required String buttonName,
    required Icon icon,
    required VoidCallback onPressed,
    String? screenName,
    Map<String, dynamic>? additionalData,
    ButtonStyle? style,
  }) {
    return IconButton(
      onPressed: () {
        trackButtonClick(
          buttonName: buttonName,
          screenName: screenName,
          additionalData: additionalData,
        );
        onPressed();
      },
      style: style,
      icon: icon,
    );
  }

  /// Создание карточки с отслеживанием нажатий
  Widget createTrackedCard({
    required String itemType,
    required String itemId,
    required String itemName,
    required Widget child,
    required VoidCallback onTap,
    Map<String, dynamic>? additionalData,
  }) {
    return GestureDetector(
      onTap: () {
        trackItemSelection(
          itemType: itemType,
          itemId: itemId,
          itemName: itemName,
          additionalData: additionalData,
        );
        onTap();
      },
      child: Card(child: child),
    );
  }

  /// Создание поля поиска с отслеживанием
  Widget createTrackedSearchField({
    required String searchCategory,
    required TextEditingController controller,
    required Function(String) onSearch,
    String? hintText,
    Map<String, dynamic>? additionalData,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText ?? 'Поиск...',
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            final searchTerm = controller.text.trim();
            if (searchTerm.isNotEmpty) {
              trackSearch(
                searchTerm: searchTerm,
                searchCategory: searchCategory,
                additionalData: additionalData,
              );
              onSearch(searchTerm);
            }
          },
        ),
      ),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          trackSearch(
            searchTerm: value.trim(),
            searchCategory: searchCategory,
            additionalData: additionalData,
          );
          onSearch(value.trim());
        }
      },
    );
  }

  /// Создание списка с отслеживанием выбора элементов
  Widget createTrackedListView({
    required String itemType,
    required List<Map<String, dynamic>> items,
    required Widget Function(Map<String, dynamic> item, int index) itemBuilder,
    required Function(Map<String, dynamic> item) onItemTap,
    Map<String, dynamic>? additionalData,
  }) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            trackItemSelection(
              itemType: itemType,
              itemId: item['id']?.toString() ?? '',
              itemName: item['name']?.toString() ?? '',
              additionalData: additionalData,
            );
            onItemTap(item);
          },
          child: itemBuilder(item, index),
        );
      },
    );
  }

  /// Создание грида с отслеживанием выбора элементов
  Widget createTrackedGridView({
    required String itemType,
    required List<Map<String, dynamic>> items,
    required Widget Function(Map<String, dynamic> item, int index) itemBuilder,
    required Function(Map<String, dynamic> item) onItemTap,
    required int crossAxisCount,
    Map<String, dynamic>? additionalData,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            trackItemSelection(
              itemType: itemType,
              itemId: item['id']?.toString() ?? '',
              itemName: item['name']?.toString() ?? '',
              additionalData: additionalData,
            );
            onItemTap(item);
          },
          child: itemBuilder(item, index),
        );
      },
    );
  }

  /// Получение текущего профиля пользователя
  UserProfile? get currentUserProfile =>
      PersonaAnalyticsTracker.instance.currentUserProfile;

  /// Проверка инициализации
  bool get isAnalyticsInitialized =>
      PersonaAnalyticsTracker.instance.isInitialized;
}
