import 'package:flutter/material.dart';
import '../model/sound_model.dart';
import '../widgets/sound_box_widget.dart';
import 'sound_detail_screen.dart';

class Sound extends StatefulWidget {
  const Sound({super.key});

  @override
  State<Sound> createState() => _SoundState();
}

class _SoundState extends State<Sound> {
  final List<SoundModel> sounds = const [
    SoundModel(
      label: 'Baby Lullabies 1',
      imagePath: 'assets/images/battleg.jpg',
      soundPath: 'assets/sounds/twinkle_lullaby.mp3',
      subSounds: [
        SubSoundModel(label: 'Brahms Lullaby', soundPath: 'assets/sounds/brahms_cradle.mp3'),
        SubSoundModel(label: 'Hush-A-By Baby', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'Rock-a-Bye Baby', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'Sleep Lena Darling', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'All Through Night', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'German Cradle Song', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'Lullaby No. 14', soundPath: 'assets/sounds/original-lullaby.mp3'),
      ],
    ),
    SoundModel(
      label: 'Baby Lullabies 2',
      imagePath: 'assets/images/battleg.jpg',
      soundPath: 'assets/sounds/brahms_cradle.mp3',
      subSounds: [
        SubSoundModel(label: 'Brahms Lullaby', soundPath: 'assets/sounds/brahms_cradle.mp3'),
        SubSoundModel(label: 'Hush-A-By Baby', soundPath: 'assets/sounds/twinkle_lullaby.mp3'),
        SubSoundModel(label: 'Rock-a-Bye Baby', soundPath: 'assets/sounds/original-lullaby.mp3'),
        SubSoundModel(label: 'Sleep Lena Darling', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'All Through Night', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'German Cradle Song', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'Lullaby No. 14', soundPath: 'assets/sounds/original-lullaby.mp3'),
      ],
    ),
    SoundModel(
      label: 'Baby Lullabies 3',
      imagePath: 'assets/images/battleg.jpg',
      soundPath: 'assets/sounds/original-lullaby.mp3',
      subSounds: [
        SubSoundModel(label: 'Brahms Lullaby', soundPath: 'assets/sounds/brahms_cradle.mp3'),
        SubSoundModel(label: 'Hush-A-By Baby', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'Rock-a-Bye Baby', soundPath: 'assets/sounds/twinkle_lullaby.mp3'),
        SubSoundModel(label: 'Sleep Lena Darling', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'All Through Night', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'German Cradle Song', soundPath: 'assets/sounds/lullaby-sleeping.mp3'),
        SubSoundModel(label: 'Lullaby No. 14', soundPath: 'assets/sounds/original-lullaby.mp3'),
      ],
    ),
    // Add more unique categories if needed, or reduce to avoid repetition
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: sounds.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final sound = sounds[index];
          return SoundBox(
            imagePath: sound.imagePath,
            label: sound.label,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SoundDetailScreen(sound: sound),
                ),
              );
            },
          );
        },
      ),
    );
  }
}