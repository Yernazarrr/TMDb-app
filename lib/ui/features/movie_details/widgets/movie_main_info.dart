import 'package:flutter/material.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/domain/entity/movie_details_credits/movie_details_credits.dart';
import 'package:themdb_app/library/widgets/inherited/provider.dart';
import 'package:themdb_app/ui/features/elements/radial_percent_widget.dart';
import 'package:themdb_app/ui/features/movie_details/movie_details_model.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TopPosterWidget(),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        const _ScoreWidget(),
        const _SummaryWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: overviewWidget(),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: _PeopleWidgets(),
        ),
      ],
    );
  }

  Text overviewWidget() {
    return const Text(
      'Overview',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    return Text(
      model?.movieDetails?.overview ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);

    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: posterPath != null
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 20,
            child: IconButton(
              onPressed: () => model?.toggleFavorite(),
              icon: Icon(
                model?.isFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);

    var year = model?.movieDetails?.releaseDate.year.toString();
    year = year != null ? ' ($year)' : '';

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: model?.movieDetails?.title ?? '',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: year,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        NotifierProvider.of<MovieDetailsModel>(context)?.movieDetails;

    var voteAverage = movieDetails?.voteAverage ?? 0;
    voteAverage = voteAverage * 10;

    final trailer = movieDetails?.trailer?.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');

    final trailerKey = trailer?.isNotEmpty == true ? trailer?.first.key : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: RadialPercentWidget(
                  percent: voteAverage / 100,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3,
                  child: Text(voteAverage.toStringAsFixed(0)),
                ),
              ),
              const SizedBox(width: 10),
              const Text('User Score'),
            ],
          ),
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        trailerKey != null
            ? TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.movieTrailer,
                  arguments: trailerKey,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.play_arrow),
                    Text('Play Trailer'),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);

    if (model == null) return const SizedBox.shrink();

    var texts = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;

    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }

    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }

    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          texts.join(' '),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _PeopleWidgets extends StatelessWidget {
  const _PeopleWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;

    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;

    var crewChunks = <List<Crew>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }

    return Column(
      children: crewChunks
          .map(
            (chunk) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _PeopleWidgetsRow(crew: chunk),
            ),
          )
          .toList(),
    );
  }
}

class _PeopleWidgetsRow extends StatelessWidget {
  final List<Crew> crew;
  const _PeopleWidgetsRow({required this.crew});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: crew.map((e) => _PeopleWidgetsRowItem(crew: e)).toList(),
    );
  }
}

class _PeopleWidgetsRowItem extends StatelessWidget {
  final Crew crew;
  const _PeopleWidgetsRowItem({required this.crew});

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    const jobTilteStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(crew.name, style: nameStyle),
          Text(crew.job, style: jobTilteStyle),
        ],
      ),
    );
  }
}
