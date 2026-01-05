class User {
  final int id;
  final String authorName;

  User({required this.id, required this.authorName});

  factory User.fromJson(Map<String, dynamic> data) {
    return User(id: data['id'], authorName: data['authorName']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'authorName': authorName};
  }
}
