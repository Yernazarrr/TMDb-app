import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/domain/data_providers/session_data_provider.dart';
import 'package:themdb_app/domain/entity/movie_details/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  MovieDetails? get movieDetails => _movieDetails;

  MovieDetailsModel(this.movieId);

  String stringFromDate(DateTime date) => _dateFormat.format(date);

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (_locale == locale) return;
    _locale = locale;

    _dateFormat = DateFormat.yMMMMd(locale);

    await loadDetails();
  }

  Future<void> loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);

    final sessionId = await _sessionDataProvider.getSessionId();
    if (sessionId != null) {
      _isFavorite = await _apiClient.isFavoriteMovie(movieId, sessionId);
    }

    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (accountId == null || sessionId == null) return;

    _isFavorite = !_isFavorite;
    notifyListeners();

    try {
      await _apiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.movie,
        mediaId: movieId,
        isFavorite: _isFavorite,
      );
    } catch (e) {
      print(e);
    }
  }
}
