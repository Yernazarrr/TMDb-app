import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(3, 37, 65, 1),
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    backgroundColor: Color.fromRGBO(3, 37, 65, 1),
  ),
);
