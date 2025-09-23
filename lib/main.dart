import 'package:flutter/material.dart';

import 'folder/views/custom_screen.dart';
import 'folder/views/settings_screen.dart';
import 'folder/views/sound.dart';


void main() {
  runApp(const LullaStarApp());
}

class LullaStarApp extends StatelessWidget {
  const LullaStarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LullaStar',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme
        primaryColor: Colors.deepPurple,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.tealAccent,
          surface: Color(0xFF121212), // Dark background
          onSurface: Colors.white, // White text/icons
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Sound(),
    CustomScreen(),
    SettingsScreen(),
  ];

  static const List<String> _titles = [
    'Sounds',
    'Custom',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Sounds'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Custom'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}