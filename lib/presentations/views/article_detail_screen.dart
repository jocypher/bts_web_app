import 'package:bts_frontend/data/article_model.dart';
import 'package:bts_frontend/presentations/views/add_article_screen.dart';
import 'package:bts_frontend/repositories/article_repo_impl.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatefulWidget {
  final ArticleModel articleModel;
  const ArticleDetailScreen({super.key, required this.articleModel});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  ArticleRepoImpl articleRepoImpl = ArticleRepoImpl();
  late ArticleModel currentArticle;

  @override
  void initState() {
    super.initState();
    currentArticle = widget.articleModel;
  }

  Future<void> deleteArticle(int id) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Article'),
        content: const Text('Are you sure you want to delete this article?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await articleRepoImpl.deleteArticle(id);
        if (mounted) {
          // Return true to indicate deletion
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting article: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double horizontalPadding;

    if (width < 600) {
      horizontalPadding = 16; // mobile
    } else if (width < 1024) {
      horizontalPadding = 32; // tablet / mobile web
    } else {
      horizontalPadding = 200; // desktop web
    }

    final dateTime = DateTime.now();
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 22),
                      SizedBox(width: 10),
                      Text("Back to home"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Pass the article to edit screen
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddArticleScreen(
                              isEditMode: true,
                              articleModel: currentArticle, // Pass current article
                            ),
                          ),
                        );

                        // If article was updated, refresh it
                        if (result == true) {
                          try {
                            final updatedArticle = await articleRepoImpl
                                .getArticleById(currentArticle.id);
                            setState(() {
                              currentArticle = updatedArticle;
                            });
                          } catch (e) {
                            print('Error refreshing article: $e');
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => deleteArticle(currentArticle.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 70),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentArticle.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          currentArticle.category.categoryName,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 11, 129, 225),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(Icons.person_2_outlined, size: 18),
                            Text(
                              currentArticle.author.authorName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 17),
                            const SizedBox(width: 5),
                            Text(
                              "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(Icons.remove_red_eye_outlined, size: 17),
                            const SizedBox(width: 5),
                            Text("${currentArticle.viewCount} views"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Steps",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(currentArticle.content),
                    const SizedBox(height: 50),
                    const Text(
                      "Verification",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(currentArticle.verification ?? "No verification"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
