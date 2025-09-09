// lib/controllers/audio_controller.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sound.dart';
import '../providers/settings_provider.dart';

// AudioController for LullaStarApp, managing audio playback (e.g., lullaby.mp3).
// Links to sound.dart for Sound model and settings_provider.dart for volume.
class AudioController {
  final AudioPlayer _player = AudioPlayer();

  // Play a sound using its path
  Future<void> playSound(Sound sound, WidgetRef ref) async {
    try {
      final volume = ref.read(settingsProvider).volume; // Get volume from settings
      await _player.setVolume(volume);
      await _player.play(AssetSource(sound.path));
    } catch (e) {
      throw Exception('Failed to play sound "${sound.title}": $e');
    }
  }

  // Stop playback
  Future<void> stopSound() async {
    try {
      await _player.stop();
    } catch (e) {
      throw Exception('Failed to stop sound: $e');
    }
  }

  // Pause playback
  Future<void> pauseSound() async {
    try {
      await _player.pause();
    } catch (e) {
      throw Exception('Failed to pause sound: $e');
    }
  }

  // Resume playback
  Future<void> resumeSound() async {
    try {
      await _player.resume();
    } catch (e) {
      throw Exception('Failed to resume sound: $e');
    }
  }

  // Set volume (used when settings_provider.dart updates volume)
  Future<void> setVolume(double volume) async {
    try {
      if (volume < 0.0 || volume > 1.0) {
        throw ArgumentError('Volume must be between 0.0 and 1.0');
      }
      await _player.setVolume(volume);
    } catch (e) {
      throw Exception('Failed to set volume: $e');
    }
  }

  // Dispose player to free resources
  void dispose() {
    _player.dispose();
  }
}

// Riverpod provider for AudioController (optional, for stateful access in UI)
final audioControllerProvider = Provider<AudioController>((ref) => AudioController());
