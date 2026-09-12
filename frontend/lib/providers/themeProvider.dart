// Dokumentasi:
// Provider pengaturan tema aplikasi.
// Mengatur perubahan light mode dan dark mode
// serta menyimpan pilihan tema user.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool("isDarkMode") ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isDarkMode", value);

    notifyListeners();
  }
}
