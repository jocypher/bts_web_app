import 'package:bts_frontend/data/article_model.dart';
import 'package:bts_frontend/presentations/views/article_detail_screen.dart';
import 'package:bts_frontend/presentations/views/add_article_screen.dart';
import 'package:bts_frontend/presentations/views/widgets/home_article_widget.dart';
import 'package:bts_frontend/repositories/article_repo_impl.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  ArticleRepoImpl articleRepoImpl = ArticleRepoImpl();
  List<ArticleModel> searchResult = [];
  List<ArticleModel> articles = [];
  List<ArticleModel> recentArticles = [];
  int totalViews = 0;
  Set<String> categories = {};

  String selectedCategory = 'All';

  void onClick(String title) {
    setState(() {
      selectedCategory = title.isEmpty ? 'All' : title;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllArticles();
  }

  void getAllArticles() async {
    try {
      final result = await articleRepoImpl.getAllArticles();
      final recentResult = await articleRepoImpl.getRecentlyAddedArticles();
      if (!mounted) return;

      setState(() {
        articles = result;
        recentArticles = recentResult;
        categories = articles
            .map((article) => article.category.categoryName)
            .toSet();
        totalViews = articles.fold(0, (sum, a) => sum + a.viewCount);
      });
    } catch (err) {
      rethrow;
    }
  }

  void searchInfo({required String searchReq}) {
    final query = searchReq.toLowerCase();
    setState(() {
      searchResult = articles
          .where(
            (article) =>
                article.author.authorName.toLowerCase().contains(query) ||
                article.category.categoryName.toLowerCase().contains(query) ||
                article.title.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ArticleModel> displayList = articles.where((article) {
      if (selectedCategory == "All") return true;
      return article.category.categoryName == selectedCategory;
    }).toList();

    if (searchResult.isNotEmpty) {
      displayList = searchResult;
    }

    final width = MediaQuery.of(context).size.width;

    double horizontalPadding;

    if (width < 600) {
      horizontalPadding = 16; // mobile
    } else if (width < 1024) {
      horizontalPadding = 32; // tablet / mobile web
    } else {
      horizontalPadding = 64; // desktop web (reduced from 200)
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // ==== FIXED HEADER SECTION ====
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Image.asset(
                          "images/insurance.jpg",
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            "BTS Knowledge App",
                            style: TextStyle(
                              fontSize: width < 600 ? 16 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddArticleScreen(isEditMode: false),
                        ),
                      );

                      if (result == true) {
                        getAllArticles();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width < 600 ? 12 : 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 18, color: Colors.white),
                          if (width >= 600) ...[
                            const SizedBox(width: 6),
                            Text(
                              "New Article",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==== Search Section ====
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      cursorHeight: 18,
                      cursorColor: Colors.grey.shade500,
                      onChanged: (value) => searchInfo(searchReq: value),
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                          size: 22,
                        ),
                        hintText: "Search by title, author, or category...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ==== Statistics Section ====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        articles.length.toString(),
                        "Total Articles",
                        Colors.blue,
                      ),
                      _buildStatCard(
                        categories.length.toString(),
                        "Categories",
                        Colors.purple,
                      ),
                      _buildStatCard(
                        totalViews.toString(),
                        "Total Views",
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // ==== Recently Added Articles ====
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Recently Added Articles",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ListView.builder(
                    itemCount: recentArticles.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final article = recentArticles[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await articleRepoImpl.getArticleById(
                            article.id,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ArticleDetailScreen(
                                  articleModel: result,
                                );
                              },
                            ),
                          );
                        },
                        child: ArticleWidget(
                          title: article.title,
                          viewCount: article.viewCount,
                          authorName: article.author.authorName,
                          categoryName: article.category.categoryName,
                          dateTime: DateTime.now(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // ==== Browse by Category ====
                  Row(
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.blue,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Browse by Category",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return categoryItem("All");
                        }
                        final cat = categories.elementAt(index - 1);
                        return categoryItem(cat);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==== Filtered Articles ====
                  ListView.builder(
                    itemCount: displayList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final article = displayList[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await articleRepoImpl.getArticleById(
                            article.id,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ArticleDetailScreen(
                                  articleModel: result,
                                );
                              },
                            ),
                          );
                        },
                        child: ArticleWidget(
                          title: article.title,
                          viewCount: article.viewCount,
                          authorName: article.author.authorName,
                          categoryName: article.category.categoryName,
                          dateTime: DateTime.now(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget categoryItem(String title) {
    bool isActive = selectedCategory == title;
    return GestureDetector(
      onTap: () => onClick(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
