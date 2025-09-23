class SoundModel {
  final String label;
  final String imagePath;
  final String soundPath;
  final List<SubSoundModel> subSounds;

  const SoundModel({
    required this.label,
    required this.imagePath,
    required this.soundPath,
    this.subSounds = const [],
  });
}

class SubSoundModel {
  final String label;
  final String soundPath;

  const SubSoundModel({
    required this.label,
    required this.soundPath,
  });
}