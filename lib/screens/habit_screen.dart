import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../widgets/add_edit_habit_dialog.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final List<DateTime> recentDates = List.generate(
      7,
      (index) => DateTime.now().subtract(Duration(days: index)),
    ).reversed.toList();

    return Scaffold(
      body: Consumer<HabitProvider>(
        builder: (context, provider, child) {
          if (provider.habits.isEmpty) {
            return const Center(child: Text('No habits yet. Add one!'));
          }
          final habits = provider.habits;
          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              habit.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'Streak: ${habit.getStreak()}',
                            style: TextStyle(fontSize: 14, color: Colors.orange[700], fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_note_outlined, color: Colors.blueGrey[400]),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddEditHabitDialog(
                                  habitProvider: habitProvider,
                                  habit: habit,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                            onPressed: () async {
                               final confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Delete'),
                                    content: Text('Are you sure you want to delete habit: "${habit.name}"?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel',style: TextStyle(color: Colors.teal),),
                                        onPressed: () => Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: Text('Delete', style: TextStyle(color: Colors.red[600])),
                                        onPressed: () => Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmDelete == true) {
                                 habitProvider.deleteHabit(habit.id);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Recent Activity (Last 7 Days):',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: recentDates.map((date) {
                          final isCompleted = habit.isCompletedOn(date);
                          final isToday = DateUtils.isSameDay(date, DateTime.now());
                          return GestureDetector(
                            onTap: () {
                              habitProvider.toggleHabitCompletion(habit.id, date);
                            },
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('E').format(date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                    color: isToday ? Colors.teal[700] : Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  DateFormat('d').format(date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                    color: isToday ? Colors.teal[700] : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                  color: isCompleted ? Colors.green[600] : (isToday ? Colors.teal[300] : Colors.grey[400]),
                                  size: 28,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddEditHabitDialog(habitProvider: habitProvider),
          );
        },
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}