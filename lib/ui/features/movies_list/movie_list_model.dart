import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/domain/entity/movie/movie.dart';
import 'package:themdb_app/domain/entity/popular_movie_response.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);

  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgres = false;
  String? _searchQuery;

  late DateFormat _dateFormat;
  String _locale = '';
  Timer? timer;

  String stringFromDate(DateTime date) => _dateFormat.format(date);

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;

    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetMovieList();
  }

  Future<PopularMovieResponse> _loadMovies(int page, String locale) async {
    final query = _searchQuery;

    if (query == null) {
      return await _apiClient.getPopularMovies(page, locale);
    } else {
      return await _apiClient.searchMovie(page, locale, query);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgres || _currentPage >= _totalPage) return;
    _isLoadingInProgres = true;

    final nextPage = _currentPage + 1;

    try {
      final movieListResponse = await _loadMovies(nextPage, _locale);

      _currentPage = movieListResponse.page;
      _totalPage = movieListResponse.totalPages;

      _movies.addAll(movieListResponse.movies);
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
    _loadNextPage();
  }

  Future<void> _resetMovieList() async {
    _currentPage = 0;
    _totalPage = 1;

    _movies.clear();
    await _loadNextPage();
  }

  Future<void> searchMovie(String text) async {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 250), () async {
      final searchQuery = text.isNotEmpty ? text : null;

      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;

      await _resetMovieList();
    });
  }
}
