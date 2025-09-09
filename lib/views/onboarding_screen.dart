// lib/views/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/settings.dart';
import '../providers/settings_provider.dart'; // Link to settings_provider.dart for adhdMode

// Onboarding screen for LullaStarApp, allowing users to select child’s age and ADHD mode.
// Links to settings_provider.dart for state management, navigates to home_screen.dart.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  double _age = 3; // Default age

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider); // Read adhdMode from provider

    return Scaffold(
      backgroundColor: Colors.blue[50], // Pastel YodhaPlay-style background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to LullaStar',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Child’s Age',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.blue[600]),
              ),
              Slider(
                value: _age,
                min: 0,
                max: 12,
                divisions: 12,
                label: '$_age years',
                activeColor: Colors.blue[300], // Pastel color
                onChanged: (value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(
                  'ADHD-Friendly Mode',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                value: settings.adhdMode,
                activeColor: Colors.blue[300],
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).state = Settings(
                    adhdMode: value,
                    volume: settings.volume,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[200], // Pastel button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  try {
                    Navigator.pushNamed(context, '/home').then((_) {
                      // Ensure navigation completes or handle failure
                      if (Navigator.of(context).canPop()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navigation to home failed')),
                        );
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Navigation error: $e')),
                    );
                  }
                },
                child: Text(
                  'Start',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.blue[800]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
