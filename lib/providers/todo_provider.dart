import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  final Uuid _uuid = const Uuid();

  List<Todo> get todos => List.unmodifiable(_todos..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  void addTodo(String title) {
    final newTodo = Todo(title: title);
    _todos.add(newTodo);
    notifyListeners();
  }

  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  void clearAllTodos() {
    _todos.clear();
    notifyListeners();
  }
  
  void toggleTodoStatus(String todoId) {
    final index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      notifyListeners();
    }
  }

  void deleteTodo(String todoId) {
    _todos.removeWhere((todo) => todo.id == todoId);
    notifyListeners();
  }
}