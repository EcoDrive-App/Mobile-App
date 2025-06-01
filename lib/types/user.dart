class User {
  final String id;
  final String name;
  final String email;
  final double points;
  final bool isLoggedIn;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.isLoggedIn,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'points': points,
      'is_logged_in': isLoggedIn,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      points: map['points'] ?? 0,
      isLoggedIn: map['is_logged_in'] ?? false,
    );
  }
}