import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/domain/entity/movie/movie.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);

  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgres = false;

  late DateFormat _dateFormat;
  String _locale = '';

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

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
    if (_isLoadingInProgres || _currentPage >= _totalPage) return;
    _isLoadingInProgres = true;

    final nextPage = _currentPage + 1;

    try {
      final moviesResponse =
          await _apiClient.getPopularMovies(nextPage, _locale);

      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;

      _movies.addAll(moviesResponse.movies);
      _isLoadingInProgres = false;

      notifyListeners();
    } catch (e) {
      _isLoadingInProgres = false;
    }
  }

  void onSelectMovie(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadMovies();
  }
}
