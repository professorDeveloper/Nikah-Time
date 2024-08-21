import 'package:flutter/cupertino.dart';
import 'package:voice_message_player/voice_message_player.dart';
import '../manager/audio_manager.dart';

class VoiceMessageView extends StatefulWidget {
  final String url;

  VoiceMessageView({required this.url});

  @override
  _VoiceMessageViewState createState() => _VoiceMessageViewState();
}

class _VoiceMessageViewState extends State<VoiceMessageView> {
  late VoiceController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = VoiceController(
      audioSrc: widget.url,
      maxDuration: const Duration(seconds: 10),
      isFile: false,
      onComplete: () {
        print("Playback completed");
        audioPlayerManager.stopActiveController();
      },
      onPause: () {
        print("Playback paused");
      },
      onPlaying: () {
        print("Playback started");
        audioPlayerManager.setActiveController(_controller);
      },
      onError: (err) {
        print("Error occurred: $err");
      },
    );
  }

  @override
  void didUpdateWidget(covariant VoiceMessageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      // If the URL changes, dispose the old controller and create a new one
      _controller.dispose();
      _initializeController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoiceMessagePlayer(
      controller: _controller,
      innerPadding: 12,
      cornerRadius: 20,
    );
  }
}