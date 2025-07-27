import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final Box<TodoModel> _todoBox = Hive.box<TodoModel>('todos');

  List<TodoModel> get todos => _todoBox.values.toList().reversed.toList();

  void addTodo(String title) {
    final newTodo = TodoModel(title: title);
    _todoBox.add(newTodo);
    notifyListeners();
  }

  void updateTodo(int index, TodoModel updatedTodo) {
    _todoBox.putAt(index, updatedTodo);
    notifyListeners();
  }

  void clearAllTodos() {
    _todoBox.clear();
    notifyListeners();
  }

  void toggleTodoStatus(int index) {
    final todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      todo.save();
      notifyListeners();
    }
  }

  void deleteTodo(int index) {
    _todoBox.deleteAt(index);
    notifyListeners();
  }
}
