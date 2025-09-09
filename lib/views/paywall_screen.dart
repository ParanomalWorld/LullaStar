// lib/views/paywall_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Pastel YodhaPlay-style
      body: Center(
        child: Text(
          'Paywall Screen (Placeholder)',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.blue[800]),
        ),
      ),
    );
  }
}