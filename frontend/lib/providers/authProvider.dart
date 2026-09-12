// Dokumentasi:
// Provider untuk mengelola status autentikasi aplikasi.
// Menyimpan data user, token login, proses login,
// register, logout, dan pemulihan session.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userModel.dart';
import '../services/authService.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;

  String? _token;

  UserModel? get user => _user;

  String? get token => _token;

  bool get isLoggedIn => _token != null;

  Future<bool> login({required String email, required String password}) async {
    try {
      final result = await _authService.login(email: email, password: password);

      _token = result['token'];

      _user = result['user'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("token", _token!);

      await prefs.setString("user_name", _user!.name);

      await prefs.setString("user_email", _user!.email);

      notifyListeners();

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _authService.register(name: name, email: email, password: password);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    _token = null;

    _user = null;

    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    final savedToken = prefs.getString("token");

    if (savedToken != null) {
      _token = savedToken;

      _user = UserModel(
        id: 0,

        name: prefs.getString("user_name") ?? "",

        email: prefs.getString("user_email") ?? "",
      );

      notifyListeners();
    }
  }
}
