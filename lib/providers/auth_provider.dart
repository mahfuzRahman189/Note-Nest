import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _username;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username; 

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _username = email; 
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _username = email;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _username = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}