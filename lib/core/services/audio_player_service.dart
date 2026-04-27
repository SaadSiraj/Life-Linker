import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  bool get isPlaying => _player.playing;

  Future<void> playFromUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (_) {}
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Stream<bool> get playingStream => _player.playingStream;

  Future<void> dispose() async {
    await _player.dispose();
  }
}
