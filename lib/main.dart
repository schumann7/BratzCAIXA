import 'package:flutter/material.dart';
import 'package:bratzcaixa/screens/login_screen.dart';
import 'package:bratzcaixa/screens/home_screen.dart';
import 'package:bratzcaixa/screens/clients_screen.dart';
import 'package:bratzcaixa/screens/finances_screen.dart';
import 'package:bratzcaixa/screens/products_screen.dart';
import 'package:bratzcaixa/screens/settings_screen.dart';
import 'package:bratzcaixa/screens/system_screen.dart';

void main() {
  runApp(const BratzApp());
}

class BratzApp extends StatelessWidget {
  const BratzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bratz',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/clients': (context) => ClientsScreen(),
        '/finances': (context) => FinancesScreen(),
        '/products': (context) => ProductsScreen(),
        '/settings': (context) => SettingsScreen(),
        '/system': (context) => SystemScreen(),
      },
    );
  }
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7DFF)),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    bodySmall: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
  ),
  hintColor: Colors.white,
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7DFF)),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
  ),
  hintColor: Colors.black,
);
