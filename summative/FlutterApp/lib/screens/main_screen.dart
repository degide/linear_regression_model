import 'package:flutter/material.dart';
import 'package:flutter_app/screens/about_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/prediction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          [
            HomeScreen(changeTab: _onItemTapped),
            PredictionScreen(),
            AboutScreen(),
          ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_work_outlined,
              size: 28,
              color: _selectedIndex == 0 ? Colors.white : Colors.black54,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.analytics_outlined,
              size: 28,
              color: _selectedIndex == 1 ? Colors.white : Colors.black54,
            ),
            label: 'Prediction',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.info_outlined,
              size: 28,
              color: _selectedIndex == 2 ? Colors.white : Colors.black54,
            ),
            label: 'About',
          ),
        ],
        indicatorColor: Theme.of(context).primaryColor,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
