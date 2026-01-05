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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, ),
        borderRadius: BorderRadius.circular(12)
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.remove_red_eye_outlined),
                  const SizedBox(width: 10),
                  Text("$viewCount"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                categoryName,
                style: TextStyle(
                  color: const Color.fromARGB(255, 11, 129, 225),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Icon(Icons.person_2_outlined,size: 18), Text(authorName!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Icon(Icons.calendar_month_outlined,size:17),
                  const SizedBox(width: 5,),
                  Text("${dateTime!.day}/${dateTime!.month}/${dateTime!.year}"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
