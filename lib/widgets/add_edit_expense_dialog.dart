import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart'; // Changed import

class AddEditExpenseDialog extends StatefulWidget {
  final ExpenseProvider expenseProvider; // Changed
  final ExpenseModel? expense;

  const AddEditExpenseDialog({
    super.key,
    required this.expenseProvider, // Changed
    this.expense,
  });

  @override
  State<AddEditExpenseDialog> createState() => _AddEditExpenseDialogState();
}

class _AddEditExpenseDialogState extends State<AddEditExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late double _amount;
  late DateTime _selectedDate;

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _description = widget.expense?.description ?? '';
    _amount = widget.expense?.amount ?? 0.0;
    _selectedDate = widget.expense?.date ?? DateTime.now();
    _dateController.text = DateFormat.yMMMd().format(_selectedDate);
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.expense == null) {
        widget.expenseProvider.addExpense(
          _description,
          _amount,
          _selectedDate,
        );
      } else {
        widget.expenseProvider.updateExpense(
          // Find the index of the expense in the box
          widget.expenseProvider.expenses.indexOf(widget.expense!),
          ExpenseModel(
            description: _description,
            amount: _amount,
            date: _selectedDate,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _amount == 0.0 ? '' : _amount.toString(),
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter an amount' : null,
              onSaved: (value) => _amount = double.tryParse(value ?? '') ?? 0.0,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date'),
              onTap: _pickDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: _submit,
          child: Text(widget.expense == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
