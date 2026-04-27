import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifelinker/core/services/audio_player_service.dart';
import 'package:lifelinker/core/services/audio_recorder_service.dart';
import 'package:lifelinker/model/voice_message.dart';
import 'package:lifelinker/repository/voice_message_repo.dart';

class VoiceMessageProvider extends ChangeNotifier {
  final AudioPlayerService _playerService = AudioPlayerService();
  final AudioRecorderService _recorderService = AudioRecorderService();

  StreamSubscription<List<VoiceMessageModel>>? _subscription;

  bool _isRecording = false;
  bool _isSending = false;
  bool _isPlayingIncoming = false;
  String? _errorMessage;

  bool get isRecording => _isRecording;
  bool get isSending => _isSending;
  bool get isPlayingIncoming => _isPlayingIncoming;
  String? get errorMessage => _errorMessage;

  // ── Start listening for incoming voice messages ───────────────────────────

  void startListeningForIncomingVoice({
    required String patientId,
    required String caregiverId,
    required VoiceMessageSender targetSender,
  }) {
    _subscription?.cancel();
    _subscription =
        VoiceMessageRepository.listenUnplayedMessages(
          patientId: patientId,
          caregiverId: caregiverId,
          targetSender: targetSender,
        ).listen((messages) async {
          for (final message in messages) {
            await _autoPlayMessage(message);
          }
        });
  }

  Future<void> _autoPlayMessage(VoiceMessageModel message) async {
    if (_isPlayingIncoming) return;
    _isPlayingIncoming = true;
    notifyListeners();

    try {
      await _playerService.playFromUrl(message.audioUrl);
      await VoiceMessageRepository.markAsPlayed(message.id);
    } catch (_) {
    } finally {
      _isPlayingIncoming = false;
      notifyListeners();
    }
  }

  // ── Record and send voice ─────────────────────────────────────────────────

  Future<void> startRecording() async {
    final hasPermission = await _recorderService.hasPermission();
    if (!hasPermission) {
      _errorMessage = 'Microphone permission denied';
      notifyListeners();
      return;
    }

    await _recorderService.startRecording();
    _isRecording = true;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> stopAndSendVoice({
    required String patientId,
    required String caregiverId,
    required VoiceMessageSender sender,
  }) async {
    if (!_isRecording) return;

    final path = await _recorderService.stopRecording();
    _isRecording = false;
    notifyListeners();

    if (path == null) return;

    _isSending = true;
    notifyListeners();

    try {
      await VoiceMessageRepository.sendVoiceMessage(
        audioFilePath: path,
        sender: sender,
        patientId: patientId,
        caregiverId: caregiverId,
      );
    } catch (e) {
      _errorMessage = 'Failed to send voice message';
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> cancelRecording() async {
    await _recorderService.cancelRecording();
    _isRecording = false;
    notifyListeners();
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    stopListening();
    _recorderService.dispose();
    _playerService.dispose();
    super.dispose();
  }
}
