import 'package:flutter/material.dart';

import '../models/categoryModel.dart';
import '../services/apiService.dart';

// Halaman formulir untuk membuat artikel baru.
// Callback digunakan agar halaman pemanggil dapat menyegarkan datanya.
class AddBlogPage extends StatefulWidget {
  // Dipanggil setelah artikel berhasil dibuat.
  final VoidCallback onArticleCreated;

  const AddBlogPage({super.key, required this.onArticleCreated});

  @override
  State<AddBlogPage> createState() => AddBlogPageState();
}

class AddBlogPageState extends State<AddBlogPage> {
  // Controller menyimpan judul dan isi artikel yang sedang dibuat.
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  // Daftar kategori yang dimuat dari backend untuk pilihan user.
  List<Category> categories = [];

  // Kategori wajib dipilih sebelum artikel dapat dikirim.
  int? selectedCategory;

  // Status awal artikel baru adalah published dan dapat diubah ke draft.
  String selectedStatus = "published";

  // Mengendalikan indikator proses dan mencegah submit berulang.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      // Kategori dimuat saat halaman dibuka agar dropdown menggunakan data server.
      final result = await ApiService().getCategories();

      setState(() {
        categories = result;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> createArticle() async {
    // Validasi dilakukan sebelum state loading dan request API dimulai.
    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a category")));

      return;
    }

    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content cannot be empty")),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Mengirim artikel baru dengan kategori, isi, dan status yang dipilih.
      await ApiService().createPost(
        categoryId: selectedCategory!,

        title: titleController.text,

        content: contentController.text,

        status: selectedStatus,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article created successfully")),
      );

      // Beri tahu halaman sebelumnya sebelum menutup halaman formulir.
      widget.onArticleCreated();

      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create article: $error")),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Article",

          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [
              // Input utama artikel: judul, kategori, isi, dan status.
              TextField(
                controller: titleController,

                decoration: InputDecoration(
                  labelText: "Title",

                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<int>(
                value: selectedCategory,

                decoration: InputDecoration(
                  labelText: "Category",

                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),

                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,

                    child: Text(
                      category.name,

                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              TextField(
                controller: contentController,

                maxLines: 5,

                decoration: InputDecoration(
                  labelText: "Content",

                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedStatus,

                decoration: InputDecoration(
                  labelText: "Status",

                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),

                items: [
                  DropdownMenuItem(
                    value: "draft",

                    child: Text(
                      "Draft",

                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  DropdownMenuItem(
                    value: "published",

                    child: Text(
                      "Published",

                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: isLoading ? null : createArticle,

                  child: isLoading
                      ? const SizedBox(
                          height: 20,

                          width: 20,

                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          "Create",

                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
