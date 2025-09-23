import 'package:flutter/material.dart';
import 'dart:async';
import '../model/sound_model.dart';
import '../services/sound_player.dart';

class SoundDetailScreen extends StatefulWidget {
  final SoundModel sound;

  const SoundDetailScreen({super.key, required this.sound});

  @override
  State<SoundDetailScreen> createState() => _SoundDetailScreenState();
}

class _SoundDetailScreenState extends State<SoundDetailScreen> with SingleTickerProviderStateMixin {
  late final SoundPlayer _player;
  late final AnimationController _animationController;
  bool _isPlaying = false;
  bool _isLooping = true;
  bool _isLoading = true;
  String? _errorMessage;
  Duration _playDuration = Duration.zero;
  Timer? _playTimer;
  Timer? _autoStopTimer;
  String? _mixedSound;
  int? _selectedAutoStopMinutes;

  @override
  void initState() {
    super.initState();
    _player = SoundPlayer();
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 500)
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.initialize();
      // Don't auto-play on initialization
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize audio player: $e';
        _isPlaying = false;
      });
    }
  }

  Future<void> _playSound() async {
    try {
      await _player.playAsset(widget.sound.soundPath, loop: _isLooping);
      setState(() {
        _isPlaying = true;
      });
      _startPlayTimer();
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to play audio: $e';
        _isPlaying = false;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _player.pause();
        setState(() => _isPlaying = false);
        _playTimer?.cancel();
        _animationController.reverse();
      } else {
        if (_player.isPlaying) {
          await _player.resume();
        } else {
          await _playSound();
        }
        setState(() => _isPlaying = true);
        _startPlayTimer();
        _animationController.forward();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Playback error: $e';
        _isPlaying = false;
      });
    }
  }

  Future<void> _mixSound(SubSoundModel subSound) async {
    try {
      setState(() => _mixedSound = subSound.label);
      await _player.playMixedAsset(subSound.soundPath, loop: _isLooping);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to mix audio: $e');
    }
  }

  void _toggleLoop() {
    setState(() => _isLooping = !_isLooping);
    _player.setLoopMode(_isLooping);
  }

  void _startPlayTimer() {
    _playTimer?.cancel();
    _playTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _playDuration += const Duration(seconds: 1));
    });
  }

  void _setAutoStopTimer(int minutes) {
    setState(() => _selectedAutoStopMinutes = minutes);
    _autoStopTimer?.cancel();
    if (minutes > 0) {
      _autoStopTimer = Timer(Duration(minutes: minutes), () async {
        if (mounted) {
          await _player.stop();
          _playTimer?.cancel();
          setState(() {
            _isPlaying = false;
            _selectedAutoStopMinutes = null;
            _playDuration = Duration.zero;
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [hours, minutes, seconds].join(':');
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    _playTimer?.cancel();
    _autoStopTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.sound.label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
          ),
          image: DecorationImage(
            image: AssetImage(widget.sound.imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6), 
              BlendMode.darken
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.tealAccent),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            color: Colors.red.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.black.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _formatDuration(_playDuration),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [0, 5, 10, 30, 60].map((minutes) {
                          return ChoiceChip(
                            label: Text(
                              minutes == 0 ? 'Off' : '$minutes min',
                              style: TextStyle(
                                color: _selectedAutoStopMinutes == minutes 
                                    ? Colors.black 
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            selected: _selectedAutoStopMinutes == minutes,
                            selectedColor: Colors.tealAccent.withOpacity(0.9),
                            backgroundColor: Colors.black.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16, 
                              vertical: 10
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.2)
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) _setAutoStopTimer(minutes);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.tealAccent.withOpacity(0.3),
                                        Colors.tealAccent.withOpacity(0.1),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.tealAccent.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 60,
                                    color: Colors.tealAccent,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: _toggleLoop,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isLooping ? Icons.repeat_one : Icons.repeat,
                                size: 40,
                                color: Colors.tealAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        '${widget.sound.label} Tracks',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black54, 
                              blurRadius: 8, 
                              offset: Offset(2, 2)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget.sound.subSounds.length,
                          itemBuilder: (context, index) {
                            final subSound = widget.sound.subSounds[index];
                            return Card(
                              color: Colors.black.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.1)
                                ),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 8
                                ),
                                title: Text(
                                  subSound.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(
                                  _mixedSound == subSound.label 
                                      ? Icons.check_circle 
                                      : Icons.add,
                                  color: Colors.tealAccent,
                                  size: 30,
                                ),
                                onTap: () => _mixSound(subSound),
                                splashColor: Colors.tealAccent.withOpacity(0.3),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}