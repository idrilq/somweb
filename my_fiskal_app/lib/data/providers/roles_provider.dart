import 'package:flutter/material.dart';
import '../models/role.dart';

class RolesProvider extends ChangeNotifier {
  final Map<String, Role> _roles = {
    'admin': Role.admin(),
    'user': Role.user(),
  };

  Map<String, Role> get roles => Map.unmodifiable(_roles);

  void updateRole(String id, Role newRole) {
    if (!_roles.containsKey(id)) return;
    _roles[id] = newRole;
    notifyListeners();
  }

  void addRole(Role role) {
    _roles[role.id] = role;
    notifyListeners();
  }

  void deleteRole(String id) {
    if (id == 'admin' || id == 'user') return;
    _roles.remove(id);
    notifyListeners();
  }
}
