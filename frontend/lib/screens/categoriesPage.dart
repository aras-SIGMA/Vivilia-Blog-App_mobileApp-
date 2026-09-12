import 'package:flutter/material.dart';

import '../models/categoryModel.dart';
import '../models/blogModel.dart';
import '../services/apiService.dart';

// Halaman yang menampilkan kategori dari backend dan membuka artikel terkait.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Kategori yang tersedia untuk dipilih user.
  List<Category> categories = [];

  // Menentukan apakah daftar kategori masih menunggu respons API.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      // Mengambil kategori saat halaman pertama kali ditampilkan.
      final result = await ApiService().getCategories();

      setState(() {
        categories = result;

        isLoading = false;
      });
    } catch (error) {
      print(error);

      setState(() {
        isLoading = false;
      });
    }
  }

  void openCategory(Category category) {
    // Meneruskan kategori terpilih ke halaman artikel berdasarkan kategori.
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => CategoryArticlePage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",

          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? Center(
              child: Text(
                "No categories available",

                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: categories.length,

              itemBuilder: (context, index) {
                final category = categories[index];

                // Setiap kategori menjadi pintu masuk ke daftar artikelnya.
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.category),

                    title: Text(
                      category.name,

                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {
                      openCategory(category);
                    },
                  ),
                );
              },
            ),
    );
  }
}

// Menampilkan artikel yang difilter berdasarkan kategori yang dipilih.
class CategoryArticlePage extends StatefulWidget {
  // Kategori ini menjadi parameter filter untuk permintaan artikel.
  final Category category;

  const CategoryArticlePage({super.key, required this.category});

  @override
  State<CategoryArticlePage> createState() => _CategoryArticlePageState();
}

class _CategoryArticlePageState extends State<CategoryArticlePage> {
  // Hasil artikel dari API untuk kategori yang sedang dibuka.
  List<Blog> blogs = [];

  // Mengendalikan tampilan loading selama artikel kategori dimuat.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getArticles();
  }

  Future<void> getArticles() async {
    try {
      // Filter categoryId menjaga daftar hanya berisi artikel kategori aktif.
      final result = await ApiService().getPosts(
        categoryId: widget.category.id,
      );

      setState(() {
        blogs = result;

        isLoading = false;
      });
    } catch (error) {
      print(error);

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
          widget.category.name,

          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : blogs.isEmpty
          ? Center(
              child: Text(
                "No articles found",

                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

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
                          blog.content,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,

                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
