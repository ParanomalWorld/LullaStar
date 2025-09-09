
// lib/models/settings.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Settings model for LullaStarApp, representing user preferences (ADHD mode, volume).
// Links to settings_provider.dart for state management and onboarding_screen.dart for UI.
class Settings {
  final bool adhdMode; // Enable ADHD-friendly features (e.g., timers)
  final double volume; // Audio volume (0.0 to 1.0)

  Settings({
    this.adhdMode = false,
    this.volume = 0.5,
  });

  // Parse Firestore document (optional, for future persistence in database_service.dart)
  factory Settings.fromFirestore(DocumentSnapshot? doc) {
    final data = doc?.data() as Map<String, dynamic>?;
    if (data == null) {
      return Settings();
    }
    return Settings(
      adhdMode: data['adhdMode'] ?? false,
      volume: (data['volume'] as num?)?.toDouble() ?? 0.5,
    );
  }

  // Convert to JSON for Firestore (optional, for future persistence)
  Map<String, dynamic> toJson() => {
        'adhdMode': adhdMode,
        'volume': volume,
      };

  // Create copy for immutability (used in settings_provider.dart)
  Settings copyWith({bool? adhdMode, double? volume}) {
    return Settings(
      adhdMode: adhdMode ?? this.adhdMode,
      volume: volume ?? this.volume,
    );
  }
}
