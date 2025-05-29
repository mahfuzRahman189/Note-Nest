import 'package:flutter/foundation.dart';
import '../models/habit_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];
  final Uuid _uuid = const Uuid();

  List<Habit> get habits => List.unmodifiable(_habits..sort((a,b) => b.createdAt.compareTo(a.createdAt)));

  void addHabit(String name) {
    final newHabit = Habit(name: name);
    _habits.add(newHabit);
    notifyListeners();
  }

  void updateHabit(Habit updatedHabit) {
    final index = _habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }
  
  void clearAllHabits() {
    _habits.clear();
    notifyListeners();
  }
  
  void toggleHabitCompletion(String habitId, DateTime date) {
    final index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      final habit = _habits[index];
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final currentCompletionStatus = habit.completions[dateKey] ?? false;
      habit.completions[dateKey] = !currentCompletionStatus;
      notifyListeners();
    }
  }

  void deleteHabit(String habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
    notifyListeners();
  }
}