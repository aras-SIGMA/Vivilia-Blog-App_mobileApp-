import 'package:flutter/material.dart';

import 'package:frontend/screens/editblogPage.dart';

import '../models/blogModel.dart';
import '../services/apiService.dart';
import 'package:provider/provider.dart';
import '../providers/authProvider.dart';

// Halaman daftar seluruh artikel dan tindakan yang boleh dilakukan pemiliknya.
// Artikel dapat dibuka untuk diedit atau dihapus setelah ownership diverifikasi.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mengukur apakah teks artikel melampaui satu baris pada lebar tertentu.
  bool isTextOverflow(String text, TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    painter.layout(maxWidth: maxWidth);

    return painter.didExceedMaxLines;
  }

  // Menyimpan hasil artikel dari API untuk ditampilkan pada daftar.
  List<Blog> blogs = [];

  // Mengendalikan tampilan indikator saat data artikel sedang dimuat.
  bool isLoading = true;

  // Indeks artikel yang sedang diperluas pada kontrol See More.
  int? expandedIndex;

  @override
  void initState() {
    super.initState();

    getPosts();
  }

  Future<void> getPosts() async {
    // Mengambil daftar artikel terbaru dari layanan backend.
    print("GET POSTS START");
    try {
      final result = await ApiService().getPosts();

      print("DATA MASUK: ${result.length}");

      setState(() {
        blogs = result;

        isLoading = false;
      });
    } catch (error) {
      print("ERROR GET POSTS: $error");

      setState(() {
        isLoading = false;
      });
    }
  }

  // Menghapus artikel melalui API lalu menghapusnya dari daftar lokal.

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete article: $error")),
      );
    }
  }

  // Meminta konfirmasi sebelum operasi penghapusan dijalankan.

  void showDeleteDialog(int id) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Article",

            style: Theme.of(context).textTheme.titleLarge,
          ),

          content: Text(
            "Are you sure you want to delete this article?",

            style: Theme.of(context).textTheme.bodyMedium,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: Text(
                "Cancel",

                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                deletePost(id);
              },

              child: Text(
                "Delete",

                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // AuthProvider dipantau agar kontrol edit/hapus mengikuti user aktif.
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog Articles",

          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : blogs.isEmpty
          ? Center(
              child: Text(
                "No articles available",

                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              itemCount: blogs.length,

              itemBuilder: (context, index) {
                final blog = blogs[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          blog.title,

                          style: Theme.of(context).textTheme.titleLarge,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Author: ${blog.author}",

                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        Text(
                          "Category: ${blog.categoryName}",

                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 10),

                        // Bagian ini membatasi konten menjadi satu baris dan
                        // menyediakan perluasan hanya jika teks benar-benar meluap.
                        Builder(
                          builder: (context) {
                            final style = Theme.of(context).textTheme.bodyLarge;

                            final overflow = isTextOverflow(
                              blog.content,
                              style!,
                              MediaQuery.of(context).size.width - 50,
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final textStyle = Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!;

                                    final textPainter = TextPainter(
                                      text: TextSpan(
                                        text: blog.content,
                                        style: textStyle,
                                      ),
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                    );

                                    textPainter.layout(
                                      maxWidth: constraints.maxWidth,
                                    );

                                    final isOverflow =
                                        textPainter.didExceedMaxLines;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          blog.content,
                                          style: textStyle,
                                          maxLines: expandedIndex == index
                                              ? null
                                              : 1,
                                          overflow: expandedIndex == index
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                        ),

                                        if (isOverflow)
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                expandedIndex =
                                                    expandedIndex == index
                                                    ? null
                                                    : index;
                                              });
                                            },
                                            child: Text(
                                              expandedIndex == index
                                                  ? "Show Less"
                                                  : "See More",
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),

                        // Hanya pemilik artikel yang melihat aksi edit dan hapus.
                        if (auth.user != null && auth.user!.id == blog.userId)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),

                                onPressed: () {
                                  // Setelah kembali dari editor, daftar dimuat ulang
                                  // agar perubahan artikel langsung terlihat.
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditBlogPage(article: blog),
                                    ),
                                  ).then((_) {
                                    getPosts();
                                  });
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),

                                onPressed: () {
                                  showDeleteDialog(blog.id);
                                },
                              ),
                            ],
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
