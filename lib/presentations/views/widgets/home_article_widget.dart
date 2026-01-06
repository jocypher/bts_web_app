import 'package:flutter/material.dart';

class ArticleWidget extends StatelessWidget {
  final String title;
  final int? viewCount;
  final String? authorName;
  final String categoryName;
  final DateTime? dateTime;
  const ArticleWidget({
    super.key,
    required this.title,
    this.viewCount,
    this.authorName,
    required this.categoryName,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and View Count Row
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: isMobile ? 16 : 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$viewCount",
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Metadata Row - Wrap for mobile
          if (isMobile)
            // Mobile: Stacked layout
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryChip(),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: _buildAuthorInfo()),
                    const SizedBox(width: 12),
                    _buildDateInfo(),
                  ],
                ),
              ],
            )
          else
            // Desktop: Single row
            Row(
              children: [
                _buildCategoryChip(),
                const SizedBox(width: 16),
                Flexible(child: _buildAuthorInfo()),
                const SizedBox(width: 16),
                _buildDateInfo(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        categoryName,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_2_outlined, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            authorName ?? 'Unknown',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo() {
    if (dateTime == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          "${dateTime!.day}/${dateTime!.month}/${dateTime!.year}",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
