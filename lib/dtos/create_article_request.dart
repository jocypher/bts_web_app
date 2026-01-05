class CreateArticleRequest {
  final String title;
  final String content;
  final String authorName;
  final String? verification;
  final String categoryName;

  CreateArticleRequest(
      {required this.title,
      required this.content,
      required this.authorName,
      this.verification,
      required this.categoryName});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category_name': categoryName,
      'author_name': authorName,
      'content': content,
      'verification': verification,
    };
  }
}
