import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class SoundPlayer {
  final AudioPlayer _mainPlayer = AudioPlayer();
  final AudioPlayer _mixPlayer = AudioPlayer();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      ));
      await session.setActive(true);
      
      _isInitialized = true;
    } catch (e) {
      throw 'Audio session initialization failed: $e';
    }
  }

  Future<void> playAsset(String path, {bool loop = true}) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _mainPlayer.setAsset(path);
      _mainPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await _mainPlayer.play();
    } catch (e) {
      throw 'Failed to play asset $path: $e';
    }
  }

  Future<void> playMixedAsset(String path, {bool loop = true}) async {
    if (!_isInitialized) await initialize();
    
    try {
      await _mixPlayer.setAsset(path);
      _mixPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await _mixPlayer.play();
    } catch (e) {
      throw 'Failed to play mixed asset $path: $e';
    }
  }

  void setLoopMode(bool loop) {
    final mode = loop ? LoopMode.one : LoopMode.off;
    _mainPlayer.setLoopMode(mode);
    _mixPlayer.setLoopMode(mode);
  }

  Future<void> pause() async {
    try {
      await _mainPlayer.pause();
      await _mixPlayer.pause();
    } catch (e) {
      throw 'Pause failed: $e';
    }
  }

  Future<void> resume() async {
    try {
      await _mainPlayer.play();
      await _mixPlayer.play();
    } catch (e) {
      throw 'Resume failed: $e';
    }
  }

  Future<void> stop() async {
    try {
      await _mainPlayer.stop();
      await _mixPlayer.stop();
    } catch (e) {
      throw 'Stop failed: $e';
    }
  }

  bool get isPlaying => _mainPlayer.playing || _mixPlayer.playing;

  void dispose() {
    _mainPlayer.dispose();
    _mixPlayer.dispose();
    _isInitialized = false;
  }
}