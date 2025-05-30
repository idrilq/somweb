// lib/data/models/user.dart
class User {
  final String id;
  final String username;
  final String password;
  final String role;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  User copyWith({
    String? id,
    String? username,
    String? password,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
