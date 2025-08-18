import 'package:flutter/material.dart';
import '../../data/models/recipe_step.dart';

class StepDialog extends StatefulWidget {
  final RecipeStep? step;
  final Function(RecipeStep) onSave;

  const StepDialog({
    super.key,
    this.step,
    required this.onSave,
  });

  @override
  State<StepDialog> createState() => _StepDialogState();
}

class _StepDialogState extends State<StepDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _temperatureController;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.step?.description ?? '');
    _durationController =
        TextEditingController(text: widget.step?.duration?.toString() ?? '');
    _temperatureController =
        TextEditingController(text: widget.step?.temperature?.toString() ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _durationController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.step == null ? 'Add Step' : 'Edit Step'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter step description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (min)',
                      hintText: '30',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _temperatureController,
                    decoration: const InputDecoration(
                      labelText: 'Temperature (°C)',
                      hintText: '180',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveStep,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveStep() {
    if (_formKey.currentState!.validate()) {
      final step = RecipeStep(
        id: widget.step?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text,
        duration: int.tryParse(_durationController.text),
        temperature: int.tryParse(_temperatureController.text),
        order: widget.step?.order ?? 0,
        createdAt: widget.step?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(step);
      Navigator.of(context).pop();
    }
  }
}
