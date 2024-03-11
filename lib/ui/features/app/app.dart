import 'package:flutter/material.dart';
import 'package:themdb_app/ui/features/app/my_app_model.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';
import 'package:themdb_app/ui/theme/theme.dart';

class MovieApp extends StatelessWidget {
  final MyAppModel model;
  static final mainNavigation = MainNavigation();
  const MovieApp({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(model.isAuth),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
