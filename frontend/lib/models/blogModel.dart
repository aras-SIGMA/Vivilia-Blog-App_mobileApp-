// Dokumentasi:
// Model data artikel/blog.
// Digunakan untuk mengubah response JSON API
// menjadi object yang dapat digunakan Flutter.
class Blog {
  final int id;
  final int userId;
  final int categoryId;
  final String categoryName;
  final String author;
  final String title;
  final String content;
  final String status;

  Blog({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.author,
    required this.title,
    required this.content,
    required this.status,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'] ?? '',
      author: json['author'],
      title: json['title'],
      content: json['content'],
      status: json['status'],
    );
  }
}
