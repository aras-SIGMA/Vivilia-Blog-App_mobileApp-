import 'package:flutter/material.dart';

import '../models/categoryModel.dart';
import '../models/blogModel.dart';
import '../services/apiService.dart';

// Halaman kategori artikel Vivilia
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      final result = await ApiService().getCategories();

      setState(() {
        categories = result;

        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void openCategory(Category category) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => CategoryArticlePage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xffF7F7F7)
          : Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 25),

              Text(
                "Categories",

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Explore articles based on topics",

                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                    ? const Center(child: Text("No categories available"))
                    : ListView.builder(
                        itemCount: categories.length,

                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return CategoryCard(
                            category: category,

                            onTap: () {
                              openCategory(category);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card kategori Vivilia
class CategoryCard extends StatelessWidget {
  final Category category;

  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light
              ? Colors.white
              : const Color(0xff181818),

          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),

              blurRadius: 12,

              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Row(
              children: [
                Container(
                  height: 42,

                  width: 42,

                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xffF0F0F0)
                        : const Color(0xff252525),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(Icons.category_outlined, size: 22),
                ),

                const SizedBox(width: 14),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      category.name,

                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Explore articles",

                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,

              size: 17,

              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman artikel berdasarkan kategori
class CategoryArticlePage extends StatefulWidget {
  final Category category;

  const CategoryArticlePage({super.key, required this.category});

  @override
  State<CategoryArticlePage> createState() => _CategoryArticlePageState();
}

class _CategoryArticlePageState extends State<CategoryArticlePage> {
  List<Blog> blogs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getArticles();
  }

  Future<void> getArticles() async {
    try {
      final result = await ApiService().getPosts(
        categoryId: widget.category.id,
      );

      setState(() {
        blogs = result;

        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xffF7F7F7)
          : Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 25),

              Text(
                widget.category.name,

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Articles in this category",

                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : blogs.isEmpty
                    ? const Center(child: Text("No articles found"))
                    : ListView.builder(
                        itemCount: blogs.length,

                        itemBuilder: (context, index) {
                          final blog = blogs[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.light
                                  ? Colors.white
                                  : const Color(0xff181818),

                              borderRadius: BorderRadius.circular(22),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  blog.title,

                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  blog.content,

                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "By ${blog.author}",

                                  style: const TextStyle(
                                    color: Colors.grey,

                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
