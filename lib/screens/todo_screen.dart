import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import '../widgets/add_edit_todo_dialog.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.todos.isEmpty) {
            return const Center(child: Text('No todos yet. Add one!'));
          }
          final todos = provider.todos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (bool? value) {
                      todoProvider.toggleTodoStatus(index);
                    },
                    activeColor: Colors.teal,
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                      color: todo.isDone ? Colors.grey : Colors.black87,
                    ),
                  ),
                  // Remove subtitle if createdAt is not available
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      todoProvider.deleteTodo(index);
                    },
                  ),
                  onTap: () {
                    // Optionally implement edit dialog using index
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddEditTodoDialog(todoProvider: todoProvider),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
