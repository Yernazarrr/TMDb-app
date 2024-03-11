import 'package:flutter/material.dart';
import 'package:themdb_app/ui/features/movies_list/model/movie.dart';
import 'package:themdb_app/resources/resources.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _movies = [
    Movie(
        id: 1,
        imageName: AppImages.theDarkKnight,
        title: 'The Dark Knight',
        time: 'July 18, 2008',
        description:
            'Batman raises the stakes in his war on crime. With the help of Lt'),
    Movie(
        id: 2,
        imageName: AppImages.theDarkKnight,
        title: 'Spider-Man: No way home',
        time: 'July 18, 2008',
        description:
            'Batman raises the stakes in his war on crime. With the help of Lt'),
    Movie(
        id: 3,
        imageName: AppImages.theDarkKnight,
        title: 'Django Unchained',
        time: 'July 18, 2008',
        description:
            'Batman raises the stakes in his war on crime. With the help of Lt'),
    Movie(
        id: 4,
        imageName: AppImages.theDarkKnight,
        title: 'Test',
        time: 'July 18, 2008',
        description:
            'Batman raises the stakes in his war on crime. With the help of Lt'),
    Movie(
        id: 5,
        imageName: AppImages.theDarkKnight,
        title: 'Something',
        time: 'July 18, 2008',
        description:
            'Batman raises the stakes in his war on crime. With the help of Lt'),
  ];

  final _searchController = TextEditingController();

  var _filteredMovies = <Movie>[];

  void _searchMovies() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _filteredMovies = _movies.where((Movie movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredMovies = _movies;
    }

    setState(() {});
  }

  void _onSelectMovie(int index) {
    final id = _movies[index].id;
    Navigator.pushNamed(context, MainNavigationRouteNames.movieDetails,
        arguments: id);
  }

  @override
  void initState() {
    super.initState();
    _filteredMovies = _movies;
    _searchController.addListener(_searchMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _filteredMovies.length,
          itemExtent: 163,
          itemBuilder: (context, index) {
            final movie = _filteredMovies[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        Image.asset(movie.imageName),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                movie.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                movie.time,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                movie.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _onSelectMovie(index),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
//'Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.',