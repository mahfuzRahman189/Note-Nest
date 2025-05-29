import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart'; // Changed import

class AddEditTodoDialog extends StatefulWidget {
  // Changed firebaseService to todoProvider
  final TodoProvider todoProvider;
  final Todo? todo;

  const AddEditTodoDialog({
    super.key,
    required this.todoProvider, // Changed parameter
    this.todo,
  });

  @override
  State<AddEditTodoDialog> createState() => _AddEditTodoDialogState();
}

class _AddEditTodoDialogState extends State<AddEditTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _isDone = widget.todo?.isDone ?? false;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.todo == null) {
        widget.todoProvider.addTodo(_title); // Use todoProvider
      } else {
        final updatedTodo = Todo(
          id: widget.todo!.id,
          title: _title,
          isDone: _isDone,
          createdAt: widget.todo!.createdAt,
        );
        widget.todoProvider.updateTodo(updatedTodo); // Use todoProvider
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            if (widget.todo != null)
              CheckboxListTile(
                title: const Text("Completed"),
                value: _isDone,
                onChanged: (bool? value) {
                  setState(() {
                    _isDone = value ?? false;
                  });
                },
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel',style: TextStyle(color: Colors.teal)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.todo == null ? 'Add' : 'Save',style: TextStyle(color: Colors.teal)),
          onPressed: _submit,
        ),
      ],
    );
  }
}