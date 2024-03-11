import 'package:flutter/material.dart';
import 'package:themdb_app/domain/data_providers/session_data_provider.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  Widget build(BuildContext context) {
    final sessionDataProvider = SessionDataProvider();
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () => sessionDataProvider.setSessionId(null),
          icon: const Icon(Icons.logout),
        ),
      ),
    );
  }
}
