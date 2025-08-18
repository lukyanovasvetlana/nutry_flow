import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class ProfileMultiSelectionField<T> extends StatelessWidget {
  final String label;
  final List<T> selectedItems;
  final List<T> allItems;
  final String Function(T) getDisplayText;
  final Function(List<T>) onSelectionChanged;
  final bool canAddCustom;
  final String? hint;

  const ProfileMultiSelectionField({
    super.key,
    required this.label,
    required this.selectedItems,
    required this.allItems,
    required this.getDisplayText,
    required this.onSelectionChanged,
    this.canAddCustom = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSelectionDialog(context),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: selectedItems.isEmpty
                      ? Text(
                          hint ?? 'Выберите $label',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: selectedItems.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    getDisplayText(item),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _removeItem(item),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: AppColors.green,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _removeItem(T item) {
    final newList = List<T>.from(selectedItems);
    newList.remove(item);
    onSelectionChanged(newList);
  }

  Future<void> _showSelectionDialog(BuildContext context) async {
    final TextEditingController customController = TextEditingController();
    final List<T> tempSelected = List.from(selectedItems);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Выберите $label'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Existing options
                ...allItems.map((item) {
                  final isSelected = tempSelected.contains(item);
                  return CheckboxListTile(
                    title: Text(getDisplayText(item)),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          tempSelected.add(item);
                        } else {
                          tempSelected.remove(item);
                        }
                      });
                    },
                    activeColor: AppColors.green,
                  );
                }),

                // Custom input if allowed
                if (canAddCustom) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: customController,
                            decoration: InputDecoration(
                              hintText: 'Добавить свой вариант',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final customText = customController.text.trim();
                            if (customText.isNotEmpty && T == String) {
                              final customItem = customText as T;
                              if (!tempSelected.contains(customItem)) {
                                setState(() {
                                  tempSelected.add(customItem);
                                  customController.clear();
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Добавить'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                onSelectionChanged(tempSelected);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Готово'),
            ),
          ],
        ),
      ),
    );
  }
}
