import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  final String youtubeKey;

  const MovieTrailerWidget({required this.youtubeKey, super.key});

  @override
  State<MovieTrailerWidget> createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  late final YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: widget.youtubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final youtubePlayer = YoutubePlayer(
      controller: _youtubeController,
      showVideoProgressIndicator: true,
    );

    return YoutubePlayerBuilder(
      player: youtubePlayer,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Trailer'),
          ),
          body: Center(child: youtubePlayer),
        );
      },
    );
  }
}
