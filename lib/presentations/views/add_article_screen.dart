import 'package:bts_frontend/data/article_model.dart';
import 'package:bts_frontend/dtos/create_article_request.dart';
import 'package:bts_frontend/repositories/article_repo_impl.dart';
import 'package:flutter/material.dart';

class AddArticleScreen extends StatefulWidget {
  final bool isEditMode;
  final ArticleModel? articleModel;
  const AddArticleScreen({
    super.key,
    this.isEditMode = false,
    this.articleModel,
  });

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final TextEditingController titleEdtController = TextEditingController();
  final TextEditingController authorEdtController = TextEditingController();
  final TextEditingController categoryEdtController = TextEditingController();
  final TextEditingController verificationEdtController =
      TextEditingController();
  final TextEditingController contentEdtController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.articleModel != null) {
      titleEdtController.text = widget.articleModel!.title;
      authorEdtController.text = widget.articleModel!.author.authorName;
      categoryEdtController.text = widget.articleModel!.category.categoryName;
      verificationEdtController.text =
          widget.articleModel!.verification ?? "No verification";
      contentEdtController.text = widget.articleModel!.content;
    }
  }

  Future<void> _saveArticle() async {
    if (titleEdtController.text.isEmpty ||
        authorEdtController.text.isEmpty ||
        categoryEdtController.text.isEmpty ||
        contentEdtController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final articleRepoImpl = ArticleRepoImpl();
      if (widget.isEditMode && widget.articleModel != null) {
        await articleRepoImpl.updateArticle(
          CreateArticleRequest(
            title: titleEdtController.text,
            content: contentEdtController.text,
            authorName: authorEdtController.text,
            categoryName: categoryEdtController.text,
            verification: verificationEdtController.text,
          ),
          widget.articleModel!.id,
        );
      } else {
        await articleRepoImpl.createArticle(
          CreateArticleRequest(
            title: titleEdtController.text,
            content: contentEdtController.text,
            authorName: authorEdtController.text,
            categoryName: categoryEdtController.text,
            verification: verificationEdtController.text,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        print(e);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    titleEdtController.dispose();
    authorEdtController.dispose();
    categoryEdtController.dispose();
    verificationEdtController.dispose();
    contentEdtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    double horizontalPadding;

    if (width < 600) {
      horizontalPadding = 20; // mobile
    } else if (width < 1024) {
      horizontalPadding = 40; // tablet / mobile web
    } else {
      horizontalPadding = 230; // desktop web
    }
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEditMode ? "Edit Article" : "Create New Article",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            titleEdtController.clear();
                            authorEdtController.clear();
                            categoryEdtController.clear();
                            verificationEdtController.clear();
                            contentEdtController.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 23,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                              Text(
                                "cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: isLoading ? null : _saveArticle,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 27,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                          ),
                          child: isLoading
                              ? Text(
                                  "Loading",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.isEditMode
                                          ? "Edit Article"
                                          : "Save Article",
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 18),
                      children: [
                        TextSpan(
                          text: "Title",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1.25,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      cursorHeight: 18,
                      cursorColor: Colors.grey.shade500,
                      controller: titleEdtController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Category Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1.25,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      cursorHeight: 18,
                      cursorColor: Colors.grey.shade500,
                      controller: categoryEdtController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Author Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1.25,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      cursorHeight: 18,
                      cursorColor: Colors.grey.shade500,
                      controller: authorEdtController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Content",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1.25,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      cursorHeight: 18,
                      cursorColor: Colors.grey.shade500,
                      maxLines: 14,
                      controller: contentEdtController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Verification",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 1.25,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      cursorHeight: 18,
                      cursorColor: Colors.grey.shade500,
                      maxLines: 7,
                      controller: verificationEdtController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
