// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'views/onboarding_screen.dart';
import 'views/story_picker_screen.dart';
import 'views/paywall_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(const ProviderScope(child: LullaStarApp())); // Wrap with ProviderScope
}

class LullaStarApp extends StatelessWidget {
  const LullaStarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LullaStar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50], // Pastel YodhaPlay-style
        fontFamily: GoogleFonts.poppins().fontFamily,
        useMaterial3: true,
      ),
      home: const OnboardingScreen(), // Default home screen
      initialRoute: '/onboarding', // Start with onboarding
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/story_picker': (context) => const StoryPickerScreen(),
        '/paywall': (context) => const PaywallScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
        return null;
      },
    );
  }
}