import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../providers/habit_provider.dart'; // Changed import

class AddEditHabitDialog extends StatefulWidget {
  final HabitProvider habitProvider; // Changed
  final Habit? habit;

  const AddEditHabitDialog({
    super.key,
    required this.habitProvider, // Changed
    this.habit,
  });

  @override
  State<AddEditHabitDialog> createState() => _AddEditHabitDialogState();
}

class _AddEditHabitDialogState extends State<AddEditHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.habit?.name ?? '';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.habit == null) {
        widget.habitProvider.addHabit(_name); // Use habitProvider
      } else {
        final updatedHabit = Habit(
          id: widget.habit!.id,
          name: _name,
          completions: widget.habit!.completions,
          createdAt: widget.habit!.createdAt,
        );
        widget.habitProvider.updateHabit(updatedHabit); // Use habitProvider
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _name,
          decoration: const InputDecoration(labelText: 'Habit Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a habit name';
            }
            return null;
          },
          onSaved: (value) => _name = value!,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel',style: TextStyle(color: Colors.teal)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.habit == null ? 'Add' : 'Save',style: TextStyle(color: Colors.teal)),
          onPressed: _submit,
        ),
      ],
    );
  }
}