import 'package:flutter/material.dart';
import 'package:themdb_app/features/movie_details/movie_details.dart';
import 'features/auth/auth_widget.dart';
import 'features/home/main_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/auth': (context) => const AuthWidget(),
        '/mainScreen': (context) => const MainScreen(),
        '/mainScreen/movieDetails': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          if (arguments is int) {
            return MovieDetails(movieId: arguments);
          } else {
            return const MovieDetails(movieId: 0);
          }
        }
      },
      initialRoute: '/auth',
    );
  }
}
