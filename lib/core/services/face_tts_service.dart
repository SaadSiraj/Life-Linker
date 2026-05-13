import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FaceTtsService {
  static final FaceTtsService _instance = FaceTtsService._internal();
  factory FaceTtsService() => _instance;
  FaceTtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
    debugPrint('[TTS] Service initialized ✅');
  }

  Future<void> announce(String name) async {
    if (!_initialized) await initialize();
    await _tts.stop();
    final text = '$name is in front of the camera';
    await _tts.speak(text);
    debugPrint('[TTS] Speaking: "$text"');
  }

  Future<void> stop() async => _tts.stop();

  Future<void> dispose() async => _tts.stop();
}