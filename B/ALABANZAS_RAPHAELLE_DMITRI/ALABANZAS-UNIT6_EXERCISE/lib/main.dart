import 'package:flutter/material.dart';

import 'screens/home_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Personal Profile',
      theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF8975D5),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF9F5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFF9F5),
    foregroundColor: Color(0xFF38324A),
    centerTitle: true,
    elevation: 0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: const Color(0xFFE9E1FF),
    elevation: 8,
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => TextStyle(
        fontWeight: states.contains(WidgetState.selected)
            ? FontWeight.w800
            : FontWeight.w500,
        fontSize: 12,
      ),
    ),
  ),
),
      home: const HomeShell(),
    );
  }
}