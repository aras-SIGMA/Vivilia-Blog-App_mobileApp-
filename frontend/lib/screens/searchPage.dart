import 'package:flutter/material.dart';

import '../models/blogModel.dart';
import '../services/apiService.dart';

// Halaman pencarian artikel berdasarkan teks yang dimasukkan user.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Menyimpan kata kunci yang digunakan untuk pencarian.
  final searchController = TextEditingController();

  // Hasil pencarian yang ditampilkan setelah API merespons.
  List<Blog> blogs = [];

  // Mengendalikan indikator loading saat permintaan pencarian berlangsung.
  bool isLoading = false;

  Future<void> searchArticle() async {
    // Query kosong tidak dikirim agar tidak menghasilkan pencarian yang sia-sia.
    if (searchController.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // API mengembalikan artikel yang cocok dengan kata kunci pencarian.
      final result = await ApiService().getPosts(search: searchController.text);

      setState(() {
        blogs = result;
      });
    } catch (error) {
      print(error);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Articles",

          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // Pencarian dapat dijalankan melalui ikon atau tombol submit keyboard.
            TextField(
              controller: searchController,

              decoration: InputDecoration(
                labelText: "Search article",

                labelStyle: Theme.of(context).textTheme.bodyMedium,

                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),

                  onPressed: searchArticle,
                ),
              ),

              onSubmitted: (value) {
                searchArticle();
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : blogs.isEmpty
                  ? Center(
                      child: Text(
                        "No articles found",

                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: blogs.length,

                      itemBuilder: (context, index) {
                        final blog = blogs[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              blog.title,

                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "Author: ${blog.author}",

                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),

                                Text(
                                  "Category: ${blog.categoryName}",

                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
