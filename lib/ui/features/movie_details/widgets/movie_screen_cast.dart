import 'package:flutter/material.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/library/widgets/inherited/provider.dart';
import 'package:themdb_app/ui/features/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Series Cast',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 250,
            child: Scrollbar(
              child: _ActorsListWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Full Cast & Crew'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorsListWidget extends StatelessWidget {
  const _ActorsListWidget();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);
    var cast = model?.movieDetails?.credits.actor;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      itemCount: 20,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ActorListItemWidget(actorIndex: index);
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;

  const _ActorListItemWidget({required this.actorIndex});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<MovieDetailsModel>(context);

    final actor = model!.movieDetails!.credits.actor[actorIndex];
    final profilePath = actor.profilePath;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Image.network(ApiClient.imageUrl(profilePath as String)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor.name as String,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        actor.character as String,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
