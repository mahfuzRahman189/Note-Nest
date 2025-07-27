import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/habit_model.dart';
import 'package:intl/intl.dart';

class HabitProvider with ChangeNotifier {
  final Box<HabitModel> _habitBox = Hive.box<HabitModel>('habits');

  List<HabitModel> get habits => _habitBox.values.toList().reversed.toList();

  void addHabit(String name) {
    final newHabit = HabitModel(name: name);
    _habitBox.add(newHabit);
    notifyListeners();
  }

  void updateHabit(int index, HabitModel updatedHabit) {
    _habitBox.putAt(index, updatedHabit);
    notifyListeners();
  }

  void clearAllHabits() {
    _habitBox.clear();
    notifyListeners();
  }

  void toggleHabitCompletion(int index, DateTime date) {
    final habit = _habitBox.getAt(index);
    if (habit != null) {
      final dateKey = HabitModel.dateToKey(date);
      final current = habit.completions[dateKey] ?? false;
      habit.completions[dateKey] = !current;
      habit.save();
      notifyListeners();
    }
  }

  void deleteHabit(int index) {
    _habitBox.deleteAt(index);
    notifyListeners();
  }
}
