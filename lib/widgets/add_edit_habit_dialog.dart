import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../providers/habit_provider.dart';

class AddEditHabitDialog extends StatefulWidget {
  final HabitProvider habitProvider;
  final HabitModel? habit;

  const AddEditHabitDialog({
    super.key,
    required this.habitProvider,
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
        widget.habitProvider.addHabit(_name);
      } else {
        widget.habitProvider.updateHabit(
          widget.habitProvider.habits.indexOf(widget.habit!),
          HabitModel(name: _name, streak: widget.habit!.streak),
        );
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
          child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.habit == null ? 'Add' : 'Save',
              style: TextStyle(color: Colors.teal)),
          onPressed: _submit,
        ),
      ],
    );
  }
}
