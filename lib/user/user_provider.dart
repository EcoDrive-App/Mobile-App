import 'package:flutter/material.dart';
import 'package:mobile_app/types/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoggedIn => _user?.isLoggedIn ?? false;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _user = User.fromMap({
        'name': prefs.getString('user_name'),
        'email': prefs.getString('user_email'),
        'is_logged_in': prefs.getBool('is_logged_in') ?? false,
      });
    } catch (e) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setBool('is_logged_in', true);

    _user = User(
      name: name,
      email: email,
      isLoggedIn: true,
    );

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.setBool('is_logged_in', false);

    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(String newName) async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);

    _user = User(
      name: newName,
      email: _user!.email,
      isLoggedIn: true,
    );

    notifyListeners();
  }
}