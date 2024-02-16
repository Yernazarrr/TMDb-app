import 'package:flutter/material.dart';
import 'features/auth/auth_widget.dart';
import 'features/home/main_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/auth': (context) => const AuthWidget(),
        '/mainScreen': (context) => const MainScreen(),
      },
      initialRoute: '/auth',
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text('s'),
              ),
            );
          },
        );
      },
    );
  }
}
