import 'package:hive/hive.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 2)
class HabitModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int streak;

  @HiveField(2)
  Map<String, bool> completions;

  HabitModel(
      {required this.name, this.streak = 0, Map<String, bool>? completions})
      : completions = completions ?? {};

  // Helper: Calculate current streak
  int getStreak() {
    int streak = 0;
    DateTime checkDate = DateTime.now();
    while (true) {
      String dateKey = dateToKey(checkDate);
      if (completions[dateKey] == true) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  static String dateToKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
