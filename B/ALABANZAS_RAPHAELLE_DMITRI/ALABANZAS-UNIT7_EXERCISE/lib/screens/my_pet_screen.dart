
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyPetScreen extends StatefulWidget {
  const MyPetScreen({super.key});

  @override
  State<MyPetScreen> createState() => _MyPetScreenState();
}

class _MyPetScreenState extends State<MyPetScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  late final StreamSubscription<void> _completionSubscription;

  bool _isPlaying = false;
  bool _isLiked = false;
  int _playCount = 0;

  static const String _petName = 'Cosa';

  static const Color _lavender = Color(0xFF8975D5);
  static const Color _pink = Color(0xFFFFDCE8);
  static const Color _cream = Color(0xFFFFF9F5);
  static const Color _ink = Color(0xFF38324A);

  @override
  void initState() {
    super.initState();

    _completionSubscription =
        _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _resetCount() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset play count?'),
        content: const Text('Are you sure you want to reset the sound play count to zero?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _playCount = 0;
      });
    }
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
    });

    try {
      await _audioPlayer.play(
        AssetSource('sounds/pet_sound.mp3'),
      );

      if (mounted) {
        setState(() {
          _playCount++;
        });
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not play the sound. Please check your audio asset.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_completionSubscription.cancel());
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        title: const Text(
          'My Pet',
          style: TextStyle(
            color: _ink,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: _cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9F5),
              Color(0xFFF4EFFF),
              Color(0xFFFFF0F5),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Intro
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _pink,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: _lavender,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Smol but Sabad',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Meet $_petName!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: _ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'A little face, a lot of love. ♡',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _ink.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Pet photo with a decorative frame
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: _lavender.withOpacity(0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/images/pet.jpg',
                          width: double.infinity,
                          height: 340,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of $_petName',
                        ),
                      ),

                      // Photo label
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.pets,
                                color: _lavender,
                                size: 17,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'with Momonga and Hachiware',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: _ink,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Heart appears after double-tapping
                      if (_isLiked)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Color(0xFFFF7096),
                              size: 30,
                              semanticLabel: 'Favorite pet',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '♡  Double-tap the photo to show some love  ♡',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _ink.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),

              // Sound button
              SizedBox(
                height: 58,
                child: FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(
                    _isPlaying
                        ? Icons.graphic_eq
                        : Icons.play_circle_fill_rounded,
                    size: 25,
                  ),
                  label: Text(
                    _isPlaying
                        ? 'Playing...'
                        : 'Play $_petName\'s Sound',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _lavender,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        _lavender.withOpacity(0.55),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: _lavender.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Play counter card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _lavender.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: _pink,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE9789A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'The meow of Cosa',
                            style: TextStyle(
                              color: _ink,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Played $_playCount '
                            '${_playCount == 1 ? 'time' : 'times'}',
                            style: TextStyle(
                              color: _ink.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '$_playCount',
                        style: const TextStyle(
                          color: Color(0xFF43875A),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _playCount == 0 ? null : _resetCount,
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset count'),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
