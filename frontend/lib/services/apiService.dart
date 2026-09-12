// Dokumentasi:
// Service komunikasi antara aplikasi Flutter dan backend API.
// Menangani request artikel, kategori, create, update,
// delete, serta pengiriman token autentikasi.
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/blogModel.dart';
import '../models/categoryModel.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.3:8000/api";

  Future<Map<String, String>> getAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    return {
      "Content-Type": "application/json",

      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<List<Blog>> getPosts({
    String? search,

    int? categoryId,

    String? status,
  }) async {
    String url = "$baseUrl/posts";

    List<String> queryParams = [];

    if (search != null && search.isNotEmpty) {
      queryParams.add("search=$search");
    }

    if (categoryId != null) {
      queryParams.add("category_id=$categoryId");
    }

    if (status != null && status.isNotEmpty) {
      queryParams.add("status=$status");
    }

    if (queryParams.isNotEmpty) {
      url += "?${queryParams.join("&")}";
    }

    print("REQUEST URL: $url");

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    print("STATUS CODE: ${response.statusCode}");

    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List data = jsonData['data'];

      return data.map((item) => Blog.fromJson(item)).toList();
    } else {
      throw Exception("Failed to get articles ${response.body}");
    }
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/categories"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List data = jsonData['data'];

      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil kategori");
    }
  }

  Future<void> createPost({
    required int categoryId,

    required String title,

    required String content,

    required String status,
  }) async {
    final headers = await getAuthHeader();

    print("HEADER CREATE: $headers");
    final response = await http.post(
      Uri.parse("$baseUrl/posts"),

      headers: await getAuthHeader(),

      body: jsonEncode({
        "category_id": categoryId,

        "title": title,

        "content": content,

        "status": status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal menambahkan artikel");
    }
  }

  Future<void> updatePost({
    required int id,

    required int categoryId,

    required String title,

    required String content,

    required String status,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/posts/$id"),

      headers: await getAuthHeader(),

      body: jsonEncode({
        "category_id": categoryId,

        "title": title,

        "content": content,

        "status": status,
      }),
    );

    print("STATUS CREATE: ${response.statusCode}");
    print("BODY CREATE: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception("Gagal memperbarui artikel");
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/posts/$id"),

      headers: await getAuthHeader(),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus artikel");
    }
  }
}
