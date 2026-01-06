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
      verificationEdtController.text = widget.articleModel!.verification ?? "";
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
          content: Text('Please fill in all required fields'),
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
            verification: verificationEdtController.text.isEmpty
                ? null
                : verificationEdtController.text,
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
            verification: verificationEdtController.text.isEmpty
                ? null
                : verificationEdtController.text,
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditMode
                  ? 'Article updated successfully'
                  : 'Article created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handleCancel() {
    titleEdtController.clear();
    authorEdtController.clear();
    categoryEdtController.clear();
    verificationEdtController.clear();
    contentEdtController.clear();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleEdtController.dispose();
    authorEdtController.dispose();
    categoryEdtController.dispose();
    verificationEdtController.dispose();
    contentEdtController.dispose();
    super.dispose();
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

    return Scaffold(
      backgroundColor: Colors.white,
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
                        Text(
                          widget.isEditMode
                              ? "Edit Article"
                              : "Create New Article",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildCancelButton(isMobile)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildSaveButton(isMobile)),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isEditMode
                              ? "Edit Article"
                              : "Create New Article",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            _buildCancelButton(isMobile),
                            const SizedBox(width: 12),
                            _buildSaveButton(isMobile),
                          ],
                        ),
                      ],
                    ),
            ),
          ),

          // ==== SCROLLABLE FORM ====
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: "Title",
                    controller: titleEdtController,
                    required: true,
                    maxLines: 1,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: "Category Name",
                    controller: categoryEdtController,
                    required: true,
                    maxLines: 1,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: "Author Name",
                    controller: authorEdtController,
                    required: true,
                    maxLines: 1,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: "Content",
                    controller: contentEdtController,
                    required: true,
                    maxLines: isMobile ? 10 : 14,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: "Verification",
                    controller: verificationEdtController,
                    required: false,
                    maxLines: isMobile ? 6 : 8,
                    isMobile: isMobile,
                    hintText: "Optional: Add verification details",
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool required,
    required int maxLines,
    required bool isMobile,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 15 : 16,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(text: label),
              if (required)
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: isMobile ? 14 : 15),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(isMobile ? 12 : 14),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: isMobile ? 14 : 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(bool isMobile) {
    return GestureDetector(
      onTap: _handleCancel,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close,
              size: isMobile ? 18 : 20,
              color: Colors.grey.shade700,
            ),
            SizedBox(width: isMobile ? 4 : 6),
            Text(
              "Cancel",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isMobile) {
    return GestureDetector(
      onTap: isLoading ? null : _saveArticle,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isLoading ? Colors.blue.shade300 : Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: isMobile ? 16 : 18,
                height: isMobile ? 16 : 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(
                Icons.save_outlined,
                size: isMobile ? 18 : 20,
                color: Colors.white,
              ),
            SizedBox(width: isMobile ? 6 : 8),
            Text(
              isLoading
                  ? "Saving..."
                  : widget.isEditMode
                  ? "Update"
                  : "Save",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
