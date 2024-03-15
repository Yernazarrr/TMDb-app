import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/domain/entity/movie/movie.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);

  late DateFormat _dateFormat;
  late String _locale = '';

  late int _currentPage;
  late int _totalPage;

  var _isLoadingInProgress = false;

  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (_locale == locale) return;
    _locale = locale;

    _dateFormat = DateFormat.yMMMMd(locale);

    _currentPage = 0;
    _totalPage = 1;

    _movies.clear();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;

    final nextPage = _currentPage + 1;

    try {
      final movieResponse =
          await _apiClient.getPopularMovies(nextPage, _locale);
      _movies.addAll(movieResponse.movies);

      _currentPage = movieResponse.page;
      _totalPage = movieResponse.totalPages;

      _isLoadingInProgress = false;

      notifyListeners();
    } on Exception catch (e) {
      log(e.toString());
      _isLoadingInProgress = false;
    }
  }

  void onSelectMovie(int index, BuildContext context) {
    final movieId = _movies[index].id;

    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: movieId,
    );
  }

  String stringFromDate(DateTime date) => _dateFormat.format(date);

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;

    _loadMovies();
  }
}
