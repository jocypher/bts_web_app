import 'package:bts_frontend/data/category_model.dart';
import 'package:bts_frontend/data/user.dart';

class ArticleModel {
  final int id;
  final String title;
  final String content;
  final int viewCount;
  final User author;
  final Category category;
  final String? verification;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.viewCount,
    this.verification,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> data) {
    return ArticleModel(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      viewCount: data['views'],
      author: User.fromJson(data['author']),
      category: Category.fromJson(data['category']),

      verification:
          data['verification'] ?? 'This Article does not have a verification',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author.toJson(),
      'category': category.toJson(),
      'views': viewCount,
      'verification':
          verification ?? 'This Article does not have a verification',
    };
  }
}
