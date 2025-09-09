
// lib/models/sound.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Sound model for LullaStarApp, representing audio assets (e.g., lullaby.mp3).
// Links to audio_controller.dart for playback via audioplayers.
class Sound {
  final String id; // Unique sound ID
  final String title; // Sound title (e.g., "Gentle Lullaby")
  final String path; // Asset path (e.g., "assets/lullaby.mp3")
  final int duration; // Duration in seconds (e.g., 180 for 3-min audio)

  Sound({
    required this.id,
    required this.title,
    required this.path,
    this.duration = 0,
  }) {
    // Validate path to ensure it’s a valid asset path
    if (!path.startsWith('assets/') || !path.endsWith('.mp3')) {
      throw ArgumentError('Sound path must be in assets/ and end with .mp3');
    }
  }

  // Parse Firestore document (optional, for metadata storage in database_service.dart)
  factory Sound.fromFirestore(DocumentSnapshot? doc) {
    final data = doc?.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid Firestore data for Sound');
    }
    return Sound(
      id: doc!.id,
      title: data['title'] ?? '',
      path: data['path'] ?? 'assets/lullaby.mp3',
      duration: (data['duration'] as num?)?.toInt() ?? 0,
    );
  }

  // Convert to JSON for Firestore (optional, for metadata storage)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'path': path,
        'duration': duration,
      };

  // Create copy for immutability (used in audio_controller.dart for updates)
  Sound copyWith({String? id, String? title, String? path, int? duration}) {
    return Sound(
      id: id ?? this.id,
      title: title ?? this.title,
      path: path ?? this.path,
      duration: duration ?? this.duration,
    );
  }
}
