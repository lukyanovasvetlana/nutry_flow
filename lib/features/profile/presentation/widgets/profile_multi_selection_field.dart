import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class ProfileMultiSelectionField<T> extends StatefulWidget {
  final String label;
  final List<T> selectedItems;
  final List<T> allItems;
  final String Function(T) getDisplayText;
  final Function(List<T>) onSelectionChanged;
  final bool canAddCustom;
  final String? hint;
  final String? Function(List<T>?)? validator;

  const ProfileMultiSelectionField({
    super.key,
    required this.label,
    required this.selectedItems,
    required this.allItems,
    required this.getDisplayText,
    required this.onSelectionChanged,
    this.canAddCustom = false,
    this.hint,
    this.validator,
  });

  @override
  State<ProfileMultiSelectionField<T>> createState() => _ProfileMultiSelectionFieldState<T>();
}

class _ProfileMultiSelectionFieldState<T> extends State<ProfileMultiSelectionField<T>> {
  final GlobalKey<FormFieldState<List<T>>> _fieldKey = GlobalKey<FormFieldState<List<T>>>();

  @override
  void didUpdateWidget(ProfileMultiSelectionField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Обновляем значение FormField при изменении selectedItems
    // Откладываем вызов до следующего кадра, чтобы избежать setState во время сборки
    if (oldWidget.selectedItems != widget.selectedItems) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final fieldState = _fieldKey.currentState;
        if (fieldState != null && fieldState.mounted) {
          try {
            fieldState.didChange(widget.selectedItems);
          } catch (e) {
            // Игнорируем ошибки, если виджет уже удален
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        FormField<List<T>>(
          key: _fieldKey,
          initialValue: widget.selectedItems,
          validator: widget.validator,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showSelectionDialog(context, field),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.dynamicCard,
                      border: Border.all(
                        color: field.hasError ? AppColors.dynamicError : AppColors.dynamicBorder,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.selectedItems.isEmpty
                              ? Text(
                                  widget.hint ?? 'Выберите ${widget.label}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.dynamicTextSecondary,
                                  ),
                                )
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: widget.selectedItems.map((item) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.dynamicPrimary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.dynamicPrimary.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            widget.getDisplayText(item),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.dynamicPrimary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () => _removeItem(item, field),
                                            child: Icon(
                                              Icons.close,
                                              size: 14,
                                              color: AppColors.dynamicPrimary,
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
                          color: AppColors.dynamicTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: AppColors.dynamicError,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _removeItem(T item, FormFieldState<List<T>> field) {
    if (!mounted) return;
    final newList = List<T>.from(widget.selectedItems);
    newList.remove(item);
    if (field.mounted) {
      field.didChange(newList);
    }
    widget.onSelectionChanged(newList);
  }

  Future<void> _showSelectionDialog(
      BuildContext context, FormFieldState<List<T>> field) async {
    final TextEditingController customController = TextEditingController();
    final List<T> tempSelected = List.from(widget.selectedItems);

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: AppColors.dynamicCard,
            title: Text(
              'Выберите ${widget.label}',
              style: TextStyle(color: AppColors.dynamicTextPrimary),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Existing options
                  ...widget.allItems.map((item) {
                    final isSelected = tempSelected.contains(item);
                    return CheckboxListTile(
                      title: Text(
                        widget.getDisplayText(item),
                        style: TextStyle(color: AppColors.dynamicTextPrimary),
                      ),
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
                      activeColor: AppColors.dynamicPrimary,
                    );
                  }),

                  // Custom input if allowed
                  if (widget.canAddCustom) ...[
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
                                hintStyle: TextStyle(
                                  color: AppColors.dynamicTextSecondary,
                                ),
                                fillColor: AppColors.dynamicBackground,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.dynamicBorder,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.dynamicBorder,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.dynamicPrimary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              style: TextStyle(
                                color: AppColors.dynamicTextPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              try {
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
                              } catch (e) {
                                // Игнорируем ошибки, если контроллер уже удален
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.dynamicPrimary,
                              foregroundColor: AppColors.dynamicOnPrimary,
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
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  'Отмена',
                  style: TextStyle(color: AppColors.dynamicTextPrimary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!mounted) return;
                  try {
                    if (field.mounted) {
                      field.didChange(tempSelected);
                    }
                    widget.onSelectionChanged(tempSelected);
                  } catch (e) {
                    // Игнорируем ошибки, если виджет уже удален
                  }
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dynamicSuccess,
                  foregroundColor: AppColors.dynamicOnPrimary,
                ),
                child: const Text('Готово'),
              ),
            ],
          ),
        ),
      );
    } finally {
      try {
        customController.dispose();
      } catch (e) {
        // Игнорируем ошибки при dispose
      }
    }
  }
}
