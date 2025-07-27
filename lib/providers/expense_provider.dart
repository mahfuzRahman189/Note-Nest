import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final Box<ExpenseModel> _expenseBox = Hive.box<ExpenseModel>('expenses');

  List<ExpenseModel> get expenses =>
      _expenseBox.values.toList().reversed.toList();
  double get totalExpensesAmount =>
      _expenseBox.values.fold(0.0, (sum, item) => sum + item.amount);

  void addExpense(String description, double amount, DateTime date) {
    final newExpense =
        ExpenseModel(description: description, amount: amount, date: date);
    _expenseBox.add(newExpense);
    notifyListeners();
  }

  void clearAllExpenses() {
    _expenseBox.clear();
    notifyListeners();
  }

  void updateExpense(int index, ExpenseModel updatedExpense) {
    _expenseBox.putAt(index, updatedExpense);
    notifyListeners();
  }

  void deleteExpense(int index) {
    _expenseBox.deleteAt(index);
    notifyListeners();
  }
}
