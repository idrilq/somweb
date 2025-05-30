import 'package:flutter/material.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/terminals/screens/terminals_screen.dart';
import '../features/receipts/screens/receipts_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/terminals':
        return MaterialPageRoute(builder: (_) => const TerminalsScreen());
      case '/receipts':
        return MaterialPageRoute(builder: (_) => const ReceiptsScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Страница не найдена')),
          ),
        );
    }
  }
}
