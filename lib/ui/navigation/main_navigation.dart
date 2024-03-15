import 'package:flutter/material.dart';
import 'package:themdb_app/library/widgets/inherited/provider.dart';
import 'package:themdb_app/ui/features/auth/auth_model.dart';
import 'package:themdb_app/ui/features/auth/auth_widget.dart';
import 'package:themdb_app/ui/features/home/main_screen.dart';
import 'package:themdb_app/ui/features/home/main_screen_model.dart';
import 'package:themdb_app/ui/features/movie_details/movie_details.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movieDetails';
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;
  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteNames.auth: (context) =>
        NotifierProvider(model: AuthModel(), child: const AuthWidget()),
    MainNavigationRouteNames.mainScreen: (context) =>
        NotifierProvider(model: MainScreenModel(), child: const MainScreen()),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => MovieDetailsWidget(movieId: movieId),
        );
      default:
        const widget = Text('Navigation error!');
        return MaterialPageRoute(
          builder: (context) => widget,
        );
    }
  }
}
