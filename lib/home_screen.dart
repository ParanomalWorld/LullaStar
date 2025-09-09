
// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../views/onboarding_screen.dart';
import '../views/paywall_screen.dart';
import '../views/story_picker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Default to Onboarding tab

  static const List<Widget> _screens = [
    OnboardingScreen(),
    StoryPickerScreen(),
    PaywallScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Onboarding',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Premium',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[300], // Pastel color
        unselectedItemColor: Colors.blue[600],
        backgroundColor: Colors.blue[50],
        onTap: _onItemTapped,
        selectedLabelStyle: GoogleFonts.poppins(),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}