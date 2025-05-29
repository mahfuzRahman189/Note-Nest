import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/auth_provider.dart'; 
import '../providers/todo_provider.dart';
import '../providers/expense_provider.dart'; 
import '../providers/habit_provider.dart'; 
import 'todo_screen.dart';
import 'expense_screen.dart';
import 'habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    TodoScreen(),
    ExpenseScreen(),
    HabitScreen(),
  ];

  static const List<String> _titles = <String>[
    'My Todos',
    'My Expenses',
    'My Habits',
  ];

  void _navigateToPage(BuildContext context, int pageIndex) {
    Provider.of<AppStateProvider>(context, listen: false)
        .setSelectedIndex(pageIndex);
    Navigator.pop(context);
  }

  Future<void> _performLogout(BuildContext context) async {
    context.read<TodoProvider>().clearAllTodos();
    context.read<ExpenseProvider>().clearAllExpenses();
    context.read<HabitProvider>().clearAllHabits();

    context.read<AppStateProvider>().setSelectedIndex(0);

    await Provider.of<AuthProvider>(context, listen: false).logout();

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    const Color selectedColor = Colors.teal;

    final Color unselectedColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[appState.selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _performLogout(context), // Use the helper
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text(
                "Md Mahfuzur Rahman",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text(
                "ID : 0182220012101189",
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 48, 164, 137),
                child: const Text(
                  "MMR",
                  style: TextStyle(fontSize: 24.0, color: Colors.white, ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.teal[600],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
                
                color: appState.selectedIndex == 0
                    ? selectedColor
                    : unselectedColor,
              ),
              title: Text(
                'Todos',
                style: TextStyle(
                  color: appState.selectedIndex == 0
                      ? selectedColor
                      : unselectedColor,
                  fontWeight: appState.selectedIndex == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: appState.selectedIndex == 0,
             
              onTap: () {
                _navigateToPage(context, 0);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.attach_money_rounded,
                color: appState.selectedIndex == 1
                    ? selectedColor
                    : unselectedColor,
              ),
              title: Text(
                'Expenses',
                style: TextStyle(
                  color: appState.selectedIndex == 1
                      ? selectedColor
                      : unselectedColor,
                  fontWeight: appState.selectedIndex == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: appState.selectedIndex == 1,
              // selectedTileColor: selectedColor.withOpacity(0.1),
              onTap: () {
                _navigateToPage(context, 1);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle_outline_rounded,
                color: appState.selectedIndex == 2
                    ? selectedColor
                    : unselectedColor,
              ),
              title: Text(
                'Habits',
                style: TextStyle(
                  color: appState.selectedIndex == 2
                      ? selectedColor
                      : unselectedColor,
                  fontWeight: appState.selectedIndex == 2
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: appState.selectedIndex == 2,
              // selectedTileColor: selectedColor.withOpacity(0.1),
              onTap: () {
                _navigateToPage(context, 2);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: unselectedColor),
              title: Text('Logout', style: TextStyle(color: unselectedColor)),
              onTap: () => _performLogout(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(appState.selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'Habits',
          ),
        ],
        currentIndex: appState.selectedIndex,
        onTap: (index) {
          Provider.of<AppStateProvider>(context, listen: false)
              .setSelectedIndex(index);
        },
      ),
    );
  }
}
