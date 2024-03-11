import 'package:themdb_app/features/auth/auth_widget.dart';
import 'package:themdb_app/features/home/main_screen.dart';

abstract class MainNavigationRouteNames {
  static const auth = '/';
  static const mainScreen = '/mainScreen';
  static const movieDetails = '/mainScreen/movieDetails';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.auth;
  final routes = {
    MainNavigationRouteNames.auth: (context) => const AuthWidget(),
    MainNavigationRouteNames.mainScreen: (context) => const MainScreen(),
  };
}
