import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_edit_expense_dialog.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Consumer<ExpenseProvider>(builder: (context, provider, child) {
            if (provider.expenses.isEmpty)
              return const SizedBox
                  .shrink(); // don't show summary if no expenses
            return Card(
              color: Colors.teal[50],
              margin: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Expenses:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800]),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'en_BD', symbol: '\৳')
                          .format(provider.totalExpensesAmount),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700]),
                    ),
                  ],
                ),
              ),
            );
          }),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                if (provider.expenses.isEmpty) {
                  return const Center(child: Text('No expenses yet. Add one!'));
                }
                final expenses = provider.expenses;
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[100],
                          child: FittedBox(
                            // Ensure text fits
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                NumberFormat.currency(
                                        locale: 'en_BD',
                                        symbol: '৳',
                                        decimalDigits: 0)
                                    .format(expense.amount),
                                style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        title: Text(expense.description),
                        subtitle: Text(
                          DateFormat.yMMMd().format(expense.date),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: Colors.red[400]),
                          onPressed: () async {
                            final confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete expense: "${expense.description}"?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.teal),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text('Delete',
                                          style: TextStyle(
                                              color: Colors.red[600])),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmDelete == true) {
                              expenseProvider.deleteExpense(index);
                            }
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddEditExpenseDialog(
                              expenseProvider: expenseProvider,
                              expense: expense,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                AddEditExpenseDialog(expenseProvider: expenseProvider),
          );
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
