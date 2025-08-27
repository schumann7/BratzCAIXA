import 'package:flutter/material.dart';
import 'screens/home.dart';

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
      home: const DashboardPage(),
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
  hintColor: Colors.white
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
  hintColor: Colors.black
);
