class User {
  final String name;
  final String email;
  final bool isLoggedIn;

  User({
    required this.name,
    required this.email,
    required this.isLoggedIn,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'is_logged_in': isLoggedIn,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'] ?? '',
      isLoggedIn: map['is_logged_in'] ?? false,
    );
  }
}