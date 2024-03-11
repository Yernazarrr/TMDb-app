import 'package:flutter/material.dart';
import 'package:themdb_app/features/auth/auth_model.dart';
import 'package:themdb_app/features/auth/auth_widget.dart';
import 'package:themdb_app/features/home/main_screen.dart';
import 'package:themdb_app/features/movie_details/movie_details.dart';
import 'package:themdb_app/ui/theme/theme.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/auth': (context) =>
            AuthProvider(model: AuthModel(), child: const AuthWidget()),
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
