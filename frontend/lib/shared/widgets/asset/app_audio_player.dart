import 'package:flutter/material.dart';

/// Audio player wrapper — stub for future audio package integration.
///
/// When an audio package (e.g. `audioplayers`, `just_audio`) is added,
/// replace the body of [build] with the actual player UI. This widget
/// provides the API contract that screens program against.
///
/// ```dart
/// AppAudioPlayer(AppAudio.sfxSuccess);
/// AppAudioPlayer(AppAudio.musicHome, autoPlay: true);
/// ```
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

  /// Audio asset path from the audio registry.
  final String assetPath;

  /// Whether to start playing when the widget builds.
  final bool autoPlay;

  /// Whether to loop the audio.
  final bool loop;

  /// Volume level (0.0 – 1.0).
  final double volume;

  /// Called when the audio finishes loading.
  final void Function()? onLoaded;

  /// Called when playback completes.
  final void Function()? onCompleted;

  @override
  State<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual audio player UI when audio package is added.
    //
    // The widget currently renders a minimal play/pause toggle as a
    // placeholder. This demonstrates the API contract without requiring
    // an audio package.

    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
      ),
      onPressed: () {
        setState(() => _isPlaying = !_isPlaying);
        // Actual audio playback goes here.
      },
      tooltip: _isPlaying ? 'Pause' : 'Play',
    );
  }
}

/// Utility to play a one-shot sound effect without mounting a widget.
///
/// Use for button clicks, success chimes, error sounds, etc.
///
/// ```dart
/// AppAudioPlayer.playOneShot(AppAudio.sfxClick);
/// ```
class AppAudioTrigger {
  const AppAudioTrigger._();

  /// Plays a one-shot audio asset.
  ///
  /// Stub — no audio playback is implemented. When an audio package is added,
  /// this method initializes a temporary player, plays the asset, and
  /// disposes it on completion.
  static Future<void> playOneShot(
    String assetPath, {
    double volume = 1.0,
  }) async {
    // TODO: Implement with audio package.
    //
    // Scaffold:
    // ```dart
    // final player = AudioPlayer();
    // await player.setAsset(assetPath);
    // await player.setVolume(volume);
    // await player.play();
    // player.onPlayerComplete.listen((_) => player.dispose());
    // ```
  }
}
