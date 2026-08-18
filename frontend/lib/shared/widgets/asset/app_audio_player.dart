//**
// frontend/shared/widgets/asset/app_audio_player.dart
//
// frontend:
// Shared widget. Menyediakan reusable UI components untuk feature screens.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering dan behavior.
//**
import 'package:flutter/material.dart';

class AppAudioPlayer extends StatefulWidget {
  const AppAudioPlayer(
    this.assetPath, {
    super.key,
    this.autoPlay = false,
    this.loop = false,
    this.volume = 1.0,
    this.onLoaded,
    this.onCompleted,
  });

  final String assetPath;

  final bool autoPlay;

  final bool loop;

  final double volume;

  final void Function()? onLoaded;

  final void Function()? onCompleted;

  @override
  State<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
      ),
      onPressed: () {
        setState(() => _isPlaying = !_isPlaying);
      },
      tooltip: _isPlaying ? 'Pause' : 'Play',
    );
  }
}

class AppAudioTrigger {
  const AppAudioTrigger._();

  static Future<void> playOneShot(
    String assetPath, {
    double volume = 1.0,
  }) async {}
}
