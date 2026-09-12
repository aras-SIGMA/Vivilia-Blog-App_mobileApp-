import 'package:flutter/material.dart';

import '../models/blogModel.dart';
import '../models/categoryModel.dart';
import '../services/apiService.dart';

// Halaman untuk memperbarui artikel yang telah dipilih dari daftar artikel.
// Data awal formulir berasal dari artikel yang diterima melalui constructor.
class EditBlogPage extends StatefulWidget {
  // Artikel yang sedang diedit, termasuk identitas pemilik dan id-nya.
  final Blog article;

  const EditBlogPage({super.key, required this.article});

  @override
  State<EditBlogPage> createState() => EditBlogPageState();
}

class EditBlogPageState extends State<EditBlogPage> {
  // Controller menyimpan nilai formulir yang dapat diubah user.
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  // Kategori terbaru dari server untuk pilihan saat penyuntingan.
  List<Category> categories = [];

  int? selectedCategory;

  String selectedStatus = "published";

  // Mengendalikan indikator proses dan mencegah update berulang.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Mengisi formulir dengan nilai artikel sebelum mengambil kategori.
    titleController.text = widget.article.title;

    contentController.text = widget.article.content;

    selectedCategory = widget.article.categoryId;

    selectedStatus = widget.article.status;

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      // Kategori dimuat ulang agar pilihan editor sesuai data backend.
      final result = await ApiService().getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateArticle() async {
    // Artikel tidak dikirim jika kategori, judul, atau isi belum valid.
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
      // Mengirim perubahan artikel berdasarkan id artikel yang sedang diedit.
      await ApiService().updatePost(
        id: widget.article.id,

        categoryId: selectedCategory!,

        title: titleController.text,

        content: contentController.text,

        status: selectedStatus,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article updated successfully")),
      );

      // Kembali ke daftar setelah update berhasil.
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update article: $error")),
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
          "Edit Article",

          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [
              // Form editor berisi nilai artikel yang dapat diperbarui user.
              TextField(
                controller: titleController,

                decoration: InputDecoration(
                  labelText: "Title",

                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 10),

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

              const SizedBox(height: 10),

              TextField(
                controller: contentController,

                maxLines: 5,

                decoration: InputDecoration(
                  labelText: "Content",

                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 10),

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
                  onPressed: isLoading ? null : updateArticle,

                  child: isLoading
                      ? const SizedBox(
                          height: 20,

                          width: 20,

                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          "Update",

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
