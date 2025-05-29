import 'package:flutter/foundation.dart';
import '../models/expense_model.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];
  final Uuid _uuid = const Uuid();

  List<Expense> get expenses => List.unmodifiable(_expenses..sort((a,b) => b.date.compareTo(a.date)));
  double get totalExpensesAmount => _expenses.fold(0.0, (sum, item) => sum + item.amount);

  void addExpense(String description, double amount, DateTime date, {String? category}) {
    final newExpense = Expense(
      description: description,
      amount: amount,
      date: date,
      category: category,
    );
    _expenses.add(newExpense);
    notifyListeners();
  }
 
  void clearAllExpenses() {
    _expenses.clear();
    notifyListeners();
  }
  
  void updateExpense(Expense updatedExpense) {
    final index = _expenses.indexWhere((expense) => expense.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }

  void deleteExpense(String expenseId) {
    _expenses.removeWhere((expense) => expense.id == expenseId);
    notifyListeners();
  }
}