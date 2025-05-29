import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  final String name;
  Map<String, bool> completions; // "YYYY-MM-DD" -> true
  final DateTime createdAt;

  Habit({
    String? id,
    required this.name,
    Map<String, bool>? completions,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       completions = completions ?? {},
       createdAt = createdAt ?? DateTime.now();

  bool isCompletedOn(DateTime date) {
    String dateKey = DateFormat('yyyy-MM-dd').format(date);
    return completions[dateKey] ?? false;
  }

  int getStreak() {
    int streak = 0;
    DateTime checkDate = DateTime.now();
    while (isCompletedOn(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }
}