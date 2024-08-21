import 'package:voice_message_player/voice_message_player.dart';

class AudioPlayerManager {
  VoiceController? _activeController;

  void setActiveController(VoiceController controller) {
    if (_activeController != null && _activeController != controller) {
      _activeController!.pausePlaying(); // Stops the currently playing audio
    }
    _activeController = controller;
  }

  void stopActiveController() {
    if (_activeController != null) {
      _activeController!.pausePlaying(); // Ensure that the active audio stops
    }
  }
}

final AudioPlayerManager audioPlayerManager = AudioPlayerManager();