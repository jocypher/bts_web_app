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
    final isMobile = width < 600;

    double horizontalPadding;
    if (width < 600) {
      horizontalPadding = 16;
    } else if (width < 1024) {
      horizontalPadding = 32;
    } else {
      horizontalPadding = 64;
    }

    final dateTime = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // ==== FIXED HEADER ====
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, size: 20),
                              SizedBox(width: 8),
                              Text("Back", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Action buttons
                        Row(
                          children: [
                            Expanded(child: _buildEditButton(isMobile)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildDeleteButton(isMobile)),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
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
                            _buildEditButton(isMobile),
                            const SizedBox(width: 10),
                            _buildDeleteButton(isMobile),
                          ],
                        ),
                      ],
                    ),
            ),
          ),

          // ==== SCROLLABLE CONTENT ====
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    currentArticle.title,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Metadata
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _buildMetadataChip(
                        Icons.category_outlined,
                        currentArticle.category.categoryName,
                        Colors.blue,
                      ),
                      _buildMetadataChip(
                        Icons.person_2_outlined,
                        currentArticle.author.authorName,
                        Colors.grey.shade700,
                      ),
                      _buildMetadataChip(
                        Icons.calendar_month_outlined,
                        "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                        Colors.grey.shade700,
                      ),
                      _buildMetadataChip(
                        Icons.remove_red_eye_outlined,
                        "${currentArticle.viewCount} views",
                        Colors.grey.shade700,
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 30),

                  // Steps Section
                  Text(
                    "Steps",
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentArticle.content,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      height: 1.6,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 40),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 30),

                  // Verification Section
                  Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentArticle.verification ?? "No verification provided",
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      height: 1.6,
                      color: Colors.grey.shade800,
                      fontStyle: currentArticle.verification == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(bool isMobile) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddArticleScreen(
              isEditMode: true,
              articleModel: currentArticle,
            ),
          ),
        );

        if (result == true) {
          try {
            final updatedArticle = await articleRepoImpl.getArticleById(
              currentArticle.id,
            );
            setState(() {
              currentArticle = updatedArticle;
            });
          } catch (e) {
            print('Error refreshing article: $e');
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_outlined,
              size: isMobile ? 18 : 20,
              color: Colors.blue,
            ),
            SizedBox(width: isMobile ? 4 : 6),
            Text(
              "Edit",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(bool isMobile) {
    return GestureDetector(
      onTap: () => deleteArticle(currentArticle.id),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 17,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              size: isMobile ? 18 : 20,
              color: Colors.red,
            ),
            SizedBox(width: isMobile ? 4 : 5),
            Text(
              "Delete",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
