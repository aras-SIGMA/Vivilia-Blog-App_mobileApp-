import 'package:flutter/material.dart';

import '../models/blogModel.dart';
import '../services/apiService.dart';

// Halaman pencarian artikel
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  List<Blog> blogs = [];

  bool isLoading = false;

  Future<void> searchArticle() async {
    if (searchController.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService().getPosts(search: searchController.text);

 print("HASIL SEARCH : ${result.length}");
      setState(() {
        blogs = result;
      });
    } catch (error) {
        print("SEARCH ERROR : $error");
      print(error);
    }

    setState(() {
      isLoading = false;
    });
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
                "Search",

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Find articles you want to read",

                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xff181818),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: TextField(
                  controller: searchController,

                  onSubmitted: (value) {
                    searchArticle();
                  },

                  decoration: InputDecoration(
                    hintText: "Search article",

                    border: InputBorder.none,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,

                      vertical: 15,
                    ),

                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search_rounded),

                      onPressed: searchArticle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Search Result",

                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

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
                                Text(
                                  blog.categoryName,

                                  style: const TextStyle(
                                    color: Colors.grey,

                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 10),

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