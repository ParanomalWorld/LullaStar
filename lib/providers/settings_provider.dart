
// lib/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings.dart';

// StateProvider for Settings, managing adhdMode and volume state.
// Links to settings.dart (model) and onboarding_screen.dart (UI updates).
final settingsProvider = StateProvider<Settings>((ref) => Settings());

// Optional: Notifier for complex updates (e.g., Firestore sync in future)
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings());

  void updateAdhdMode(bool adhdMode) {
    state = state.copyWith(adhdMode: adhdMode);
  }

  void updateVolume(double volume) {
    if (volume < 0.0 || volume > 1.0) {
      throw ArgumentError('Volume must be between 0.0 and 1.0');
    }
    state = state.copyWith(volume: volume);
  }
}

// Notifier provider (use if complex updates needed, else use settingsProvider)
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
