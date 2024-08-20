import 'package:flutter/material.dart';
import 'package:voice_message_player/voice_message_player.dart';

class AudioMessage extends StatelessWidget {
  final String audioUrl;

  AudioMessage({required this.audioUrl});

  @override
  Widget build(BuildContext context) {
    return VoiceMessagePlayer(

      controller: VoiceController(

        audioSrc: "https://cdn.pixabay.com/download/audio/2022/11/16/audio_a2b0a45199.mp3?filename=6-islamic-background-sounds-alfa-relaxing-music-126060.mp3",
        maxDuration: const Duration(seconds: 10),
        isFile: false,
        onComplete: () {
          // Do something on complete
          print('Audio playback completed');
        },
        onPause: () {
          // Do something on pause
          print('Audio playback paused');
        },
        onPlaying: () {
          // Do something on playing
          print('Audio playback started');
        },
        onError: (err) {
          // Do something on error
          print('Audio playback error: $err');
        },
      ),
    );
  }
}