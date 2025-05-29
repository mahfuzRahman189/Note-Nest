import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'providers/todo_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/habit_provider.dart';
import 'providers/auth_provider.dart'; 
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), 
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: Consumer<AuthProvider>( 
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'notenest',
            theme: ThemeData( 
                primarySwatch: Colors.teal,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                scaffoldBackgroundColor: Colors.grey[100],


                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.teal[600],
                  elevation: 0,
                  titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),

                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: Colors.teal[700],
                  unselectedItemColor: Colors.grey[600],
                  backgroundColor: Colors.white,
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                ),
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.teal[500]!),
                  ),
                  labelStyle: TextStyle(color: Colors.teal[700]),
                ),
                cardTheme: CardTheme(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                )),
            
            home: auth.isAuthenticated ? const HomeScreen() : const LoginScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}