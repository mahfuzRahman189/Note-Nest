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
                      todoProvider.toggleTodoStatus(todo.id);
                    },
                    activeColor: Colors.teal,
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone ? TextDecoration.lineThrough : null,
                      color: todo.isDone ? Colors.grey : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Created: ${DateFormat.yMMMd().add_jm().format(todo.createdAt)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                    onPressed: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete "${todo.title}"?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel',style: TextStyle(color: Colors.teal)),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Delete', style: TextStyle(color: Colors.red[600])),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmDelete == true) {
                        todoProvider.deleteTodo(todo.id);
                      }
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddEditTodoDialog(
                        // Pass the provider instead of firebaseService
                        todoProvider: todoProvider,
                        todo: todo,
                      ),
                    );
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
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}