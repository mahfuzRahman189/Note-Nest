import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart'; // Changed import

class AddEditExpenseDialog extends StatefulWidget {
  final ExpenseProvider expenseProvider; // Changed
  final Expense? expense;

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
  String? _category;

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _description = widget.expense?.description ?? '';
    _amount = widget.expense?.amount ?? 0.0;
    _selectedDate = widget.expense?.date ?? DateTime.now();
    _category = widget.expense?.category;
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
        widget.expenseProvider.addExpense( // Use expenseProvider
          _description,
          _amount,
          _selectedDate,
          category: _category,
        );
      } else {
        final updatedExpense = Expense(
          id: widget.expense!.id,
          description: _description,
          amount: _amount,
          date: _selectedDate,
          category: _category,
          createdAt: widget.expense!.createdAt,
        );
        widget.expenseProvider.updateExpense(updatedExpense); // Use expenseProvider
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
      title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a description';
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _amount != 0.0 ? _amount.toStringAsFixed(2) : '',
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  if (double.parse(value) <= 0) return 'Amount must be positive';
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _pickDate,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category (Optional)'),
                onSaved: (value) => _category = value?.isNotEmpty == true ? value : null,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel',style: TextStyle(color: Colors.teal),),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.expense == null ? 'Add' : 'Save',style: TextStyle(color: Colors.teal),),
          onPressed: _submit,
        ),
      ],
    );
  }
}