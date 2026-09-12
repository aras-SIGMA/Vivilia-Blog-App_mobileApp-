// Dokumentasi:
// Service autentikasi user.
// Menangani proses register dan login ke backend
// serta menerima data user dan JWT token.
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/userModel.dart';

class AuthService {
  final String baseUrl = "http://192.168.1.3:8000/api/auth";

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return {"token": data['token'], "user": UserModel.fromJson(data['user'])};
    } else {
      throw Exception("Login gagal");
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode != 201) {
      throw Exception("Register gagal");
    }
  }
}
