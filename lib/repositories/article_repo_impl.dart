import 'package:bts_frontend/api/api_client.dart';
import 'package:bts_frontend/data/article_model.dart';
import 'package:bts_frontend/dtos/create_article_request.dart';
import 'package:bts_frontend/repositories/article_repo.dart';

class ArticleRepoImpl extends ArticleRepo {
  
  @override
  Future<ArticleModel> createArticle(CreateArticleRequest data) async {
    final response = await Api.instance.post(
      "article/add",
      data: data.toJson(),
    );
    return ArticleModel.fromJson(response.data!);
  }

  @override
  Future<void> deleteArticle(int articleId) async {
    final response = await Api.instance.delete("article/$articleId");
    print(response);
  }

  @override
  Future<List<ArticleModel>> getAllArticles() async {
    final response = await Api.instance.get("article/");
    return (response.data as List)
        .map((article) => ArticleModel.fromJson(article))
        .toList();
  }

  @override
  Future<ArticleModel> getArticleById(int articleId) async {
    final response = await Api.instance.get("article/$articleId");
    print(response.data);
    return ArticleModel.fromJson(response.data);
  }

  @override
  Future<ArticleModel> updateArticle(
    CreateArticleRequest data,
    int articleId,
  ) async {
    final response = await Api.instance.put("article/$articleId", data: data.toJson());

    return ArticleModel.fromJson(response.data);
  }
  
  @override
  Future<List<ArticleModel>> getRecentlyAddedArticles() async {
    final response = await Api.instance.get("article/recent");
    return (response.data as List)
        .map((article) => ArticleModel.fromJson(article))
        .toList();
  }
  

  
}
