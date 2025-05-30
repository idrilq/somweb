// lib/data/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/column_settings.dart';
import '../models/filter_settings.dart';
import 'users_provider.dart';
import 'column_settings_provider.dart';
import 'filter_settings_provider.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void login(BuildContext context, String username, String password) {
    final users = Provider.of<UsersProvider>(context, listen: false).users;
    final user = users.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => const User(
        id: '',
        username: '',
        password: '',
        role: 'user',
      ),
    );

    if (user.id.isNotEmpty) {
      _currentUser = user;
      _errorMessage = null;
      
      if (user.role == 'admin') {
        _applyAdminPermissions(context);
      } else {
        _applyUserPermissions(context);
      }
    } else {
      _currentUser = null;
      _errorMessage = 'Неверные учетные данные';
    }
    notifyListeners();
  }

  void _applyAdminPermissions(BuildContext context) {
    context.read<ColumnSettingsProvider>().updateSettings(const ColumnSettings());
    context.read<FilterSettingsProvider>().updateSettings(const FilterSettings());
  }

  void _applyUserPermissions(BuildContext context) {
    context.read<ColumnSettingsProvider>().updateSettings(const ColumnSettings(
      showShop: false,
      showTerminal: false,
      showTransactionType: false,
      showPaymentType: false,
    ));
    
    context.read<FilterSettingsProvider>().updateSettings(const FilterSettings(
      showShop: false,
      showTerminal: false,
      showTransactionType: false,
      showPaymentType: false,
    ));
  }

  void logout(BuildContext context) {
    _currentUser = null;
    _errorMessage = null;
    context.read<ColumnSettingsProvider>().updateSettings(const ColumnSettings());
    context.read<FilterSettingsProvider>().updateSettings(const FilterSettings());
    notifyListeners();
  }
}
