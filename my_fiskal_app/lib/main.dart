import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Импорт провайдеров
import 'data/providers/auth_provider.dart';
import 'data/providers/users_provider.dart';
import 'data/providers/roles_provider.dart';
import 'data/providers/column_settings_provider.dart';
import 'data/providers/filter_settings_provider.dart';
import 'data/providers/receipts_provider.dart';
import 'data/providers/terminals_provider.dart';
import 'features/registrators/providers/registrator_connect_provider.dart';
import 'features/registrators/providers/shift_auto_provider.dart';

// Импорт экранов
import 'features/auth/screens/auth_screen.dart';
import 'features/receipts/screens/receipts_screen.dart';
import 'features/terminals/screens/terminals_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/registrators/screens/registrator_settings_screen.dart';
import 'features/registrators/screens/kkm_log_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => RolesProvider()),
        ChangeNotifierProvider(create: (_) => ColumnSettingsProvider()),
        ChangeNotifierProvider(create: (_) => FilterSettingsProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptsProvider()),
        ChangeNotifierProvider(create: (_) => TerminalsProvider()),
        ChangeNotifierProvider(create: (_) => RegistratorConnectProvider()),
        ChangeNotifierProvider(create: (_) => ShiftAutoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фискальный менеджер',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 6,
          shadowColor: const Color(0x40000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 15),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFE3EDFB),
          selectedColor: const Color(0xFF2563EB),
          labelStyle: const TextStyle(color: Colors.black),
          secondaryLabelStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2563EB)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru', 'RU')],
      locale: const Locale('ru', 'RU'),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/receipts': (context) => const ReceiptsScreen(),
        '/terminals': (context) => const TerminalsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/registrator-settings': (context) => const RegistratorSettingsScreen(),
        '/kkm-logs': (context) => const KkmLogScreen(),
      },
    );
  }
}
