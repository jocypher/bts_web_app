class Category {
  final int id;
  final String categoryName;

  Category({required this.id, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(id: data['id'], categoryName: data['categoryName']);
  }

   Map<String, dynamic> toJson() {
    return {'id': id, 'categoryName': categoryName};
  }
}
