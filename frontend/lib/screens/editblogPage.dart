import 'package:flutter/material.dart';

import '../models/blogModel.dart';
import '../models/categoryModel.dart';
import '../services/apiService.dart';

// Halaman edit artikel Vivilia
class EditBlogPage extends StatefulWidget {
  final Blog article;

  const EditBlogPage({super.key, required this.article});

  @override
  State<EditBlogPage> createState() => EditBlogPageState();
}

class EditBlogPageState extends State<EditBlogPage> {
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  List<Category> categories = [];

  int? selectedCategory;

  String selectedStatus = "published";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.article.title;

    contentController.text = widget.article.content;

    selectedCategory = widget.article.categoryId;

    selectedStatus = widget.article.status;

    getCategories();
  }

  Future<void> getCategories() async {
    try {
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
      await ApiService().updatePost(
        id: widget.article.id,

        categoryId: selectedCategory!,

        title: titleController.text,

        content: contentController.text,

        status: selectedStatus,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
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
                  "Edit Article",

                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Update your article information",

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
                    onPressed: isLoading ? null : updateArticle,

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
                        : const Text("Update"),
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