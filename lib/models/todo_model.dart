import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String title;
  bool isDone;
  final DateTime createdAt;

  Todo({
    String? id, 
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();
}