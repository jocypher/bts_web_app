import 'package:bts_frontend/data/article_model.dart';
import 'package:bts_frontend/dtos/create_article_request.dart';

abstract class ArticleRepo {
  Future<ArticleModel> createArticle(CreateArticleRequest data);

  Future<List<ArticleModel>> getAllArticles();

  Future<ArticleModel> updateArticle(CreateArticleRequest data, int articleId);

  Future<void> deleteArticle(int articleId);

  Future<ArticleModel> getArticleById(int articleId);

  Future<List<ArticleModel>> getRecentlyAddedArticles();
}
