import 'package:flutter/material.dart';
import 'package:themdb_app/ui/features/movie_details/widgets/movie_main_info.dart';
import 'package:themdb_app/ui/features/movie_details/widgets/movie_screen_cast.dart';

class MovieDetailsWidget extends StatefulWidget {
  final int movieId;
  const MovieDetailsWidget({super.key, required this.movieId});

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Dark Knight'),
      ),
      body: ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1.0),
        child: ListView(
          children: const [
            MovieMainInfo(),
            SizedBox(height: 30),
            MovieScreenCast(),
          ],
        ),
      ),
    );
  }
}
