import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/core/services/cloudinary_service.dart';
import 'package:lifelinker/model/voice_message.dart';

class VoiceMessageRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _collection = 'voice_messages';

  static Future<VoiceMessageModel> sendVoiceMessage({
    required String audioFilePath,
    required VoiceMessageSender sender,
    required String patientId,
    required String caregiverId,
  }) async {
    final url = await CloudinaryService.uploadAudio(audioFilePath);
    if (url == null) throw Exception('Failed to upload audio');

    final docRef = _db.collection(_collection).doc();
    final message = VoiceMessageModel(
      id: docRef.id,
      audioUrl: url,
      sender: sender,
      isPlayed: false,
      createdAt: DateTime.now(),
      patientId: patientId,
      caregiverId: caregiverId,
    );

    await docRef.set(message.toMap());
    return message;
  }

  static Stream<List<VoiceMessageModel>> listenUnplayedMessages({
    required String patientId,
    required String caregiverId,
    required VoiceMessageSender targetSender,
  }) {
    return _db
        .collection(_collection)
        .where('patientId', isEqualTo: patientId)
        .where('caregiverId', isEqualTo: caregiverId)
        .where(
          'sender',
          isEqualTo: targetSender == VoiceMessageSender.caregiver
              ? 'caregiver'
              : 'patient',
        )
        .where('isPlayed', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => VoiceMessageModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  static Future<void> markAsPlayed(String messageId) async {
    await _db.collection(_collection).doc(messageId).update({'isPlayed': true});
  }
}
