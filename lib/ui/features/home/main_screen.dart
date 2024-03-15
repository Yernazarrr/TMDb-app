import 'package:flutter/material.dart';
import 'package:themdb_app/ui/features/movies_list/movies_screen.dart';
import 'package:themdb_app/ui/features/news/news.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onSelectIndex(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          NewsWidget(),
          MoviesScreen(),
          Text('Cartoons'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onSelectIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Movies',
            icon: Icon(Icons.movie),
          ),
          BottomNavigationBarItem(
            label: 'Cartoons',
            icon: Icon(Icons.tv),
          ),
        ],
      ),
    );
  }
}