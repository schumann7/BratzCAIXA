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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7DFF)),
        fontFamily: 'Roboto',
      ),
      home: const DashboardPage(),
    );
  }
}