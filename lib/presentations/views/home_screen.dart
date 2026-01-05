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
      print("getting results");
      final result = await articleRepoImpl.getAllArticles();
      final recentResult = await articleRepoImpl.getRecentlyAddedArticles();
      print(result);
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
      print("Error fectching articles, $err");
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
      horizontalPadding = 200; // desktop web
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
      
           // ==== Header Section ====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset("images/insurance.jpg",width: 120),
                    Text(
                      "BTS Knowledge App",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
        
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddArticleScreen(isEditMode: false),
                          ),
                        );
        
                        // If article was created (result is true), refresh the list
                        if (result == true) {
                          getAllArticles();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 23,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              "New Article",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
      
            // ==== Search Section ====
        
            Container(
              margin: EdgeInsets.symmetric(horizontal: 100),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500, width: 1.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                cursorHeight: 18,
                cursorColor: Colors.grey.shade500,
                onChanged: (value) => searchInfo(searchReq: value),
                controller: searchController,
        
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 18,bottom: 18),
                  border: InputBorder.none,
                  prefixIconColor: Colors.grey.shade500,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                    size: 25,
                  ),
                  hintText:
                      "Search by article title, author name, category name...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
      
            // ==== Statistics Section ====
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      articles.length.toString(),
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text("Total Articles"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      categories.length.toString(),
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    Text("Categories"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      totalViews.toString(),
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text("Total Views"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 70),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  "Recently Added Articles",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              child: ListView.builder(
                itemCount: recentArticles.length,
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final article = recentArticles[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await articleRepoImpl.getArticleById(
                        article.id,
                      );
                      // print(newArticle);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ArticleDetailScreen(articleModel: result);
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
            ),
        
            const SizedBox(height: 30),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text("Browse by Category",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                ),
        
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1, // +1 for "All"
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return categoryItem("All");
                      }
                      final cat = categories.elementAt(index - 1);
                      return categoryItem(cat);
                    },
                  ),
                ),
              ],
            ),
        
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final article = displayList[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await articleRepoImpl.getArticleById(
                        article.id,
                      );
                      // print(newArticle);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ArticleDetailScreen(articleModel: result);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(String title) {
    bool isActive = selectedCategory == title;
    return GestureDetector(
      onTap: () => onClick(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
