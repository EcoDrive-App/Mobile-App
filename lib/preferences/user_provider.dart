import 'package:flutter/material.dart';
import 'package:mobile_app/types/user.dart';
import 'package:mobile_app/utils/token_storage.dart';
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
        'id': prefs.getString('user_id'),
        'name': prefs.getString('user_name'),
        'email': prefs.getString('user_email'),
        'points': prefs.getDouble('user_points'),
        'is_logged_in': prefs.getBool('is_logged_in') ?? false,
      });
    } catch (e) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setDouble('user_points', user.points);
    await prefs.setBool('is_logged_in', true);

    _user = user;

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await TokenStorage.removeToken();

    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_points');
    await prefs.setBool('is_logged_in', false);

    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(String newName, String newEmail) async {
    if (_user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);

    _user = User(
      id: _user!.id,
      name: newName,
      email: newEmail,
      points: _user!.points,
      isLoggedIn: true,
    );

    notifyListeners();
  }
}