import 'package:flutter/material.dart';

import '../models/categoryModel.dart';
import '../services/apiService.dart';

// Halaman membuat artikel baru Vivilia
class AddBlogPage extends StatefulWidget {
  final VoidCallback onArticleCreated;

  const AddBlogPage({super.key, required this.onArticleCreated});

  @override
  State<AddBlogPage> createState() => AddBlogPageState();
}

class AddBlogPageState extends State<AddBlogPage> {
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  List<Category> categories = [];

  int? selectedCategory;

  String selectedStatus = "published";

  bool isLoading = false;

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
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> createArticle() async {
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xffF7F7F7)
          : Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 25),

                Text(
                  "Create Article",

                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Write your new article",

                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                Container(
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xff181818),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: TextField(
                    controller: titleController,

                    decoration: const InputDecoration(
                      hintText: "Title",

                      prefixIcon: Icon(Icons.title),

                      border: InputBorder.none,

                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xff181818),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: DropdownButtonFormField<int>(
                    value: selectedCategory,

                    decoration: const InputDecoration(
                      hintText: "Category",

                      prefixIcon: Icon(Icons.category_outlined),

                      border: InputBorder.none,
                    ),

                    items: categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,

                        child: Text(category.name),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xff181818),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: TextField(
                    controller: contentController,

                    maxLines: 6,

                    decoration: const InputDecoration(
                      hintText: "Content",

                      prefixIcon: Icon(Icons.article_outlined),

                      border: InputBorder.none,

                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xff181818),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,

                    decoration: const InputDecoration(
                      hintText: "Status",

                      prefixIcon: Icon(Icons.publish_outlined),

                      border: InputBorder.none,
                    ),

                    items: const [
                      DropdownMenuItem(value: "draft", child: Text("Draft")),

                      DropdownMenuItem(
                        value: "published",

                        child: Text("Published"),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  height: 52,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : createArticle,

                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            height: 22,

                            width: 22,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Create"),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
