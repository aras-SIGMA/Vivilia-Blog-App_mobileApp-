import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/blogModel.dart';
import '../services/apiService.dart';
import '../providers/authProvider.dart';

import 'editblogPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Blog> blogs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getPosts();
  }

  // Mengambil data artikel dari backend
  Future<void> getPosts() async {
    try {
      final result = await ApiService().getPosts();

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

  // Menghapus artikel
  Future<void> deletePost(int id) async {
    try {
      await ApiService().deletePost(id);

      setState(() {
        blogs.removeWhere((blog) => blog.id == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article deleted successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
                auth.user != null
                    ? "Hi, ${auth.user!.name} 👋"
                    : "Welcome to Vivilia 👋",

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Discover latest articles",

                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              Text(
                "Latest Articles",

                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : blogs.isEmpty
                    ? const Center(child: Text("No articles available"))
                    : ListView.builder(
                        itemCount: blogs.length,

                        itemBuilder: (context, index) {
                          final blog = blogs[index];

                          return ArticleCard(
                            blog: blog,

                            isOwner:
                                auth.user != null &&
                                auth.user!.id == blog.userId,

                            onDelete: () {
                              deletePost(blog.id);
                            },

                            onEdit: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditBlogPage(article: blog),
                                ),
                              ).then((value) {
                                getPosts();

                                if (value == true && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Article updated successfully",
                                      ),
                                    ),
                                  );
                                }
                              });
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

// ===============================
// ARTICLE CARD
// ===============================

class ArticleCard extends StatefulWidget {
  final Blog blog;

  final bool isOwner;

  final VoidCallback onDelete;

  final VoidCallback onEdit;

  const ArticleCard({
    super.key,

    required this.blog,

    required this.isOwner,

    required this.onDelete,

    required this.onEdit,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? Colors.white
            : const Color(0xff181818),

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                widget.blog.categoryName,

                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),

              if (widget.isOwner)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: widget.onEdit,

                      child: const Text("Edit"),
                    ),

                    PopupMenuItem(
                      onTap: widget.onDelete,

                      child: const Text("Delete"),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            widget.blog.title,

            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            widget.blog.content,

            maxLines: expanded ? null : 2,

            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),

          if (widget.blog.content.length > 100)
            TextButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },

              child: Text(expanded ? "Show Less" : "See More"),
            ),

          const SizedBox(height: 5),

          Text(
            "By ${widget.blog.author}",

            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
