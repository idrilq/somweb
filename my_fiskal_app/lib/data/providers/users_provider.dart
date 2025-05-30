import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UsersProvider extends ChangeNotifier {
  final List<User> _users = [
    const User(
      id: '0',
      username: 'admin',
      password: 'admin',
      role: 'admin',
    ),
    const User(
      id: '1',
      username: 'user',
      password: 'user',
      role: 'user',
    )
  ];

  List<User> get users => _users; // Добавлен геттер

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(String id, User newUser) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index] = newUser;
      notifyListeners();
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }
}
