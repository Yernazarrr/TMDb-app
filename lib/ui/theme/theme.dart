import 'package:flutter/material.dart';
import 'package:themdb_app/ui/theme/app_colors.dart';

final theme = ThemeData(
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.mainDarkBlue,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.mainDarkBlue,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);
