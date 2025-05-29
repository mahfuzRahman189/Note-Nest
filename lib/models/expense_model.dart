import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String? category;
  final DateTime createdAt;

  Expense({
    String? id,
    required this.description,
    required this.amount,
    required this.date,
    this.category,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();
}