import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode? _themeMode;
  bool _isLoading = true;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
  bool get isLoading => _isLoading;

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    _themeMode = switch (theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', mode.name);
    notifyListeners();
  }
}