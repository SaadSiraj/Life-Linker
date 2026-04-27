import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  static final AudioRecorderService _instance =
      AudioRecorderService._internal();
  factory AudioRecorderService() => _instance;
  AudioRecorderService._internal();

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentPath;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _currentPath = '${dir.path}/$fileName';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _currentPath!,
    );
    _isRecording = true;
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    final path = await _recorder.stop();
    _isRecording = false;
    _currentPath = null;
    return path;
  }

  Future<void> cancelRecording() async {
    if (_isRecording) {
      await _recorder.cancel();
      _isRecording = false;
      _currentPath = null;
      if (_currentPath != null) {
        final file = File(_currentPath!);
        if (await file.exists()) await file.delete();
      }
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
