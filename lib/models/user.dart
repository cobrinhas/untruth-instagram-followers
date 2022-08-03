class User {
  final int id;

  final String fullName;

  final String username;

  const User({
    required this.fullName,
    required this.id,
    required this.username,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['pk'],
      username: json['username'],
      fullName: json['full_name'],
    );
  }

  @override
  String toString() {
    return '{id: $id, fullName: $fullName, username: $username}';
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}
